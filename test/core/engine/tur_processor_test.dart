import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/rejim.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/meslek_katalogu.dart';
import 'package:hayat_kariyer/core/models/oyun_durumu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/sektor.dart';
import 'package:hayat_kariyer/core/models/zaman_dagilimi.dart';

MeslekKatalogu gercekKatalog() => MeslekKatalogu.jsonMetinlerinden(
      Directory('assets/careers')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .map((f) => f.readAsStringSync()),
    );

void main() {
  final katalog = gercekKatalog();
  final motor = TurProcessor(katalog: katalog);
  const ayarlar = TurAyarlari();

  Oyuncu memur({Sehir sehir = Sehir.konya, int nakit = 100000}) =>
      Oyuncu.yeni(ad: 'Test', sehir: sehir, egitim: EgitimSeviyesi.lisans)
          .yetkinlikDegistir(Sektor.hukukKamu, 20)
          .copyWith(
            nakit: nakit,
            kariyer: const KariyerDurumu.calisan(meslekId: 'memur'),
          );

  OyunDurumu baslat({
    Oyuncu? oyuncu,
    int tohum = 4242,
    Rejim rejim = Rejim.buyume,
  }) =>
      motor.yeniOyun(
        oyuncu: oyuncu ?? memur(),
        anaTohum: tohum,
        baslangicRejimi: rejim,
      );

  TurSonucu tek(OyunDurumu d, {ZamanDagilimi? z}) => motor.turuBitir(
        d,
        TurGirdisi(zaman: z ?? ZamanDagilimi.dengeli()),
      );

  group('Yeni oyun', () {
    test('başlangıç durumu tutarlı', () {
      final d = baslat();
      expect(d.tur, 0);
      expect(d.yas, 18);
      expect(d.ay, 1);
      expect(d.maasEndeksi, 1.0);
      expect(d.piyasa.enflasyonEndeksi, 1.0);
      expect(d.piyasa.fiyatlar, isNotEmpty);
      expect(d.alimGucuKaybi, 0);
    });

    test('tur sayacı tek kaynaktan gelir', () {
      var d = baslat();
      for (var i = 0; i < 5; i++) {
        d = tek(d).durum;
      }
      expect(d.tur, d.oyuncu.tur);
      expect(d.tur, 5);
    });
  });

  group('Boru hattı sırası', () {
    test('bir turda piyasa, gelir, gider ve yaş birlikte ilerler', () {
      final d = baslat();
      final s = tek(d);
      expect(s.rapor.tur, 1);
      expect(s.durum.piyasa.enflasyonEndeksi,
          greaterThan(d.piyasa.enflasyonEndeksi));
      expect(s.rapor.netGelir, greaterThan(0));
      expect(s.rapor.yasamGideri, greaterThan(0));
      expect(
        s.rapor.nakitDegisimi,
        s.rapor.netGelir - s.rapor.yasamGideri - s.rapor.faizGideri,
      );
      expect(s.durum.oyuncu.nakit, d.oyuncu.nakit + s.rapor.nakitDegisimi);
    });

    test('gider güncel enflasyonla, maaş geçen yılın endeksiyle hesaplanır', () {
      var d = baslat();
      // Şubattan aralığa kadar zam yok; makas açılmalı.
      final ilk = tek(d);
      d = ilk.durum;
      var oncekiKayip = d.alimGucuKaybi;
      for (var i = 0; i < 10; i++) {
        d = tek(d).durum;
        expect(
          d.alimGucuKaybi,
          greaterThanOrEqualTo(oncekiKayip),
          reason: 'yıl içinde alım gücü sürekli erimeli',
        );
        oncekiKayip = d.alimGucuKaybi;
      }
      expect(oncekiKayip, greaterThan(0.1), reason: 'bir yılda ciddi erime');
    });

    test('ocakta zam yapılır ve alım gücü kaybı sıfırlanır', () {
      var d = baslat();
      final raporlar = <TurRaporu>[];
      for (var i = 0; i < 13; i++) {
        final s = tek(d);
        d = s.durum;
        raporlar.add(s.rapor);
      }
      final zamliTurlar =
          raporlar.where((r) => r.maasZammiYapildi).map((r) => r.ay).toList();
      expect(zamliTurlar, [1], reason: 'yılda tek zam, ocakta');
      expect(d.alimGucuKaybi, lessThan(0.02));
    });

    test('zam sonrası maaş gözle görülür artar', () {
      var d = baslat();
      var aralikMaasi = 0;
      var ocakMaasi = 0;
      for (var i = 0; i < 13; i++) {
        final s = tek(d);
        d = s.durum;
        if (s.rapor.ay == 12) aralikMaasi = s.rapor.netGelir;
        if (s.rapor.ay == 1 && s.rapor.tur > 0) ocakMaasi = s.rapor.netGelir;
      }
      expect(ocakMaasi, greaterThan(aralikMaasi));
    });
  });

  group('Yaşam gideri', () {
    test('şehir çarpanı uygulanır', () {
      final istanbul = tek(baslat(oyuncu: memur(sehir: Sehir.istanbul)));
      final konya = tek(baslat(oyuncu: memur(sehir: Sehir.konya)));
      expect(istanbul.rapor.yasamGideri, greaterThan(konya.rapor.yasamGideri));
      expect(
        istanbul.rapor.yasamGideri / konya.rapor.yasamGideri,
        closeTo(Sehir.istanbul.giderCarpani / Sehir.konya.giderCarpani, 0.01),
      );
    });

    test('İstanbul memuru zor geçinir, Konya memuru rahat eder', () {
      var istanbul = baslat(oyuncu: memur(sehir: Sehir.istanbul, nakit: 0));
      var konya = baslat(oyuncu: memur(sehir: Sehir.konya, nakit: 0));
      for (var i = 0; i < 24; i++) {
        istanbul = tek(istanbul).durum;
        konya = tek(konya).durum;
      }
      expect(konya.oyuncu.nakit, greaterThan(istanbul.oyuncu.nakit));
    });

    test('gider enflasyonla birlikte büyür', () {
      var d = baslat();
      final ilk = tek(d);
      d = ilk.durum;
      for (var i = 0; i < 60; i++) {
        d = tek(d).durum;
      }
      final son = tek(d);
      // Rejim sırasına göre hız değişir; amaç giderin enflasyonu izlediğini
      // görmek, belirli bir oranı kilitlemek değil.
      expect(son.rapor.yasamGideri, greaterThan(ilk.rapor.yasamGideri * 1.5));
    });
  });

  group('Eksi bakiye ve kredi notu', () {
    test('artıda kapatan oyuncunun kredi notu yükselir', () {
      final d = baslat();
      final s = tek(d);
      expect(s.durum.oyuncu.nakit, greaterThan(0));
      expect(
        s.durum.oyuncu.krediNotu,
        d.oyuncu.krediNotu + ayarlar.duzenliKrediNotuArtisi,
      );
    });

    test('eksi bakiye faiz işletir ve kredi notunu düşürür', () {
      final d = baslat(oyuncu: memur(nakit: -50000));
      final s = tek(d);
      expect(s.rapor.faizGideri, greaterThan(0));
      expect(
        s.rapor.faizGideri,
        (50000 * ayarlar.eksiBakiyeFaizi).round(),
      );
      expect(s.durum.oyuncu.krediNotu, lessThan(d.oyuncu.krediNotu));
    });

    test('borç çevrilemezse kredi notu tabana oturur', () {
      // Geliri olmayan, borçlu oyuncu.
      var d = baslat(
        oyuncu: Oyuncu.yeni(ad: 'Test', sehir: Sehir.istanbul)
            .copyWith(nakit: -200000),
      );
      for (var i = 0; i < 100; i++) {
        d = tek(d).durum;
      }
      expect(d.oyuncu.krediNotu, Oyuncu.krediNotuTaban);
      expect(d.oyuncu.nakit, lessThan(-200000));
    });
  });

  group('Tur atlama', () {
    test('3 ay atlamak 3 rapor üretir', () {
      final sonuc = motor.turlariAtla(baslat(), TurGirdisi.varsayilan(), 3);
      expect(sonuc.raporlar, hasLength(3));
      expect(sonuc.durum.tur, 3);
    });

    test('atlamak tek tek oynamakla aynı sonucu verir', () {
      var teker = baslat();
      for (var i = 0; i < 12; i++) {
        teker = tek(teker).durum;
      }
      final toplu =
          motor.turlariAtla(baslat(), TurGirdisi.varsayilan(), 12).durum;
      expect(toplu, teker);
    });

    test('dikkat gerektiren olayda atlama erken biter', () {
      // Terfiye hazır yazılımcı: ilk turda terfi eder, atlama kesilir.
      final hazir = Oyuncu.yeni(
        ad: 'Test',
        sehir: Sehir.konya,
        egitim: EgitimSeviyesi.lisans,
      ).yetkinlikDegistir(Sektor.teknoloji, 40).copyWith(
            nakit: 200000,
            kariyer: const KariyerDurumu.calisan(
              meslekId: 'yazilim_gelistirici',
              kademeTuru: 10,
            ),
          );
      final sonuc = motor.turlariAtla(
        baslat(oyuncu: hazir),
        TurGirdisi.varsayilan(),
        12,
      );
      expect(sonuc.raporlar.length, lessThan(12));
      expect(sonuc.raporlar.last.terfiEtti, isTrue);
      expect(sonuc.durum.tur, sonuc.raporlar.length);
    });
  });

  group('Determinizm ve kayıt', () {
    test('aynı tohum ve aynı kararlar aynı oyunu üretir', () {
      OyunDurumu oyna(int tohum) {
        var d = baslat(tohum: tohum);
        for (var i = 0; i < 60; i++) {
          d = tek(d).durum;
        }
        return d;
      }

      expect(oyna(1234), oyna(1234));
      expect(oyna(1234), isNot(oyna(1235)));
    });

    test('kaydet-yükle oyunun geleceğini değiştirmez', () {
      var kesintisiz = baslat();
      for (var i = 0; i < 40; i++) {
        kesintisiz = tek(kesintisiz).durum;
      }

      var kayitli = baslat();
      for (var i = 0; i < 20; i++) {
        kayitli = tek(kayitli).durum;
      }
      kayitli = OyunDurumu.fromJson(
        jsonDecode(jsonEncode(kayitli.toJson())) as Map<String, dynamic>,
      );
      for (var i = 0; i < 20; i++) {
        kayitli = tek(kayitli).durum;
      }

      expect(kayitli, kesintisiz);
    });

    test('bozuk kayıt düzeltilir', () {
      final bozuk = baslat().copyWith(
        maasEndeksi: -3,
        oyuncu: memur().copyWith(enerji: 500, tur: -2),
      );
      final d = bozuk.duzelt();
      expect(d.maasEndeksi, 1.0);
      expect(d.oyuncu.enerji, Oyuncu.enerjiTavan);
      expect(d.tur, 0);
    });
  });

  group('Uzun oyun sağlığı', () {
    test('40 yıl boyunca durum tutarlı kalır', () {
      var d = baslat(oyuncu: memur(nakit: 0));
      for (var i = 0; i < 480; i++) {
        d = tek(d).durum;
        expect(d.oyuncu.enerji, inInclusiveRange(0, 100));
        expect(d.oyuncu.mutluluk, inInclusiveRange(0, 100));
        expect(d.oyuncu.itibar, inInclusiveRange(0, 100));
        expect(
          d.oyuncu.krediNotu,
          inInclusiveRange(Oyuncu.krediNotuTaban, Oyuncu.krediNotuTavan),
        );
        expect(d.oyuncu.nakit.isFinite, isTrue);
      }
      expect(d.yas, 58);
      expect(d.oyuncu.sgkPrimAyi, greaterThan(400));
    });

    test('çalışan oyuncu 40 yılda servet biriktirir', () {
      var d = baslat(oyuncu: memur(nakit: 0));
      for (var i = 0; i < 480; i++) {
        d = tek(d).durum;
      }
      // Nominal değil reel bakılır; enflasyon rakamları şişirir.
      expect(d.piyasa.reeleCevir(d.oyuncu.nakit), greaterThan(0));
    });
  });
}
