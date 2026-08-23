import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/borc_motoru.dart';
import 'package:hayat_kariyer/core/engine/portfoy_motoru.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/core/models/borc.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/meslek_katalogu.dart';
import 'package:hayat_kariyer/core/models/oyun_durumu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/sektor.dart';
import 'package:hayat_kariyer/core/models/zaman_dagilimi.dart';

MeslekKatalogu _meslekler() => MeslekKatalogu.jsonMetinlerinden(
      Directory('assets/careers')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .map((f) => f.readAsStringSync()),
    );

void main() {
  final motor = TurProcessor(katalog: _meslekler());
  const borcMotoru = BorcMotoru();

  Oyuncu oyuncu({
    int nakit = 500000,
    int krediNotu = Oyuncu.krediNotuBaslangic,
  }) => Oyuncu.yeni(
        ad: 'Test',
        sehir: Sehir.konya,
        egitim: EgitimSeviyesi.lisans,
      ).yetkinlikDegistir(Sektor.teknoloji, 40).copyWith(
            nakit: nakit,
            krediNotu: krediNotu,
            kariyer:
                const KariyerDurumu.calisan(meslekId: 'yazilim_gelistirici'),
          );

  OyunDurumu baslat({
    List<Borc> borclar = const [],
    int nakit = 500000,
    int krediNotu = Oyuncu.krediNotuBaslangic,
  }) =>
      motor
          .yeniOyun(
            oyuncu: oyuncu(nakit: nakit, krediNotu: krediNotu),
            anaTohum: 313,
          )
          .copyWith(borclar: borclar);

  TurSonucu tek(OyunDurumu d) =>
      motor.turuBitir(d, TurGirdisi(zaman: ZamanDagilimi.dengeli()));

  Borc kredi({int anapara = 400000, int vade = 36, double faiz = 0.03}) => Borc(
        id: 'k1',
        tur: BorcTuru.ihtiyac,
        anapara: anapara,
        kalanAnapara: anapara,
        aylikTaksit: taksitHesapla(anapara, faiz, vade),
        aylikFaiz: faiz,
        kalanTaksit: vade,
        cekildigiTur: 0,
      );

  group('boru hattı', () {
    test('borçsuz oyun etkilenmez', () {
      final rapor = tek(baslat()).rapor;
      expect(rapor.odenenTaksit, 0);
      expect(rapor.toplamBorc, 0);
    });

    test('taksit nakitten düşer', () {
      final k = kredi();
      final borclu = tek(baslat(borclar: [k]));
      final borcsuz = tek(baslat());
      expect(borclu.rapor.odenenTaksit, k.aylikTaksit);
      expect(
        borclu.rapor.nakitDegisimi,
        borcsuz.rapor.nakitDegisimi - k.aylikTaksit,
      );
    });

    test('borç net değerden düşülür', () {
      final k = kredi();
      final borclu = tek(baslat(borclar: [k])).durum;
      expect(borclu.toplamBorc, greaterThan(0));
      expect(
        borclu.netDeger,
        borclu.oyuncu.nakit + borclu.portfoyDegeri - borclu.toplamBorc,
      );
    });

    test('parası olmayan taksiti kaçırır, kredi notu düşer', () {
      // Nakit yok ve maaş taksiti karşılamıyor: gecikme.
      final k = kredi(anapara: 3000000, vade: 12);
      final durum = baslat(borclar: [k], nakit: 0);
      final sonuc = tek(durum);
      expect(sonuc.rapor.gecikenKrediler, ['k1']);
      expect(sonuc.rapor.odenenTaksit, 0);
      expect(
        sonuc.durum.oyuncu.krediNotu,
        lessThan(durum.oyuncu.krediNotu),
      );
      // Borç ödenmediği için büyümüş olmalı.
      expect(sonuc.durum.toplamBorc, greaterThan(k.kalanAnapara));
    });

    test('taksit yaşam giderinden önce ödenir', () {
      // Banka maaş hesabından payını önce çeker: gelir taksiti karşılıyorsa
      // yaşam gideri eksiye düşürse bile taksit ödenmiş olmalı.
      final k = kredi(anapara: 250000, vade: 36);
      final sonuc = tek(baslat(borclar: [k], nakit: 0));
      expect(sonuc.rapor.odenenTaksit, k.aylikTaksit);
      expect(sonuc.rapor.gecikenKrediler, isEmpty);
    });

    test('kredi vade sonunda kapanır', () {
      var durum = baslat(borclar: [kredi(anapara: 200000, vade: 6)]);
      var kapanis = <String>[];
      for (var t = 0; t < 6; t++) {
        final s = tek(durum);
        durum = s.durum;
        if (s.rapor.kapananKrediler.isNotEmpty) {
          kapanis = s.rapor.kapananKrediler;
        }
      }
      expect(kapanis, ['k1']);
      expect(durum.borclar, isEmpty);
      expect(durum.toplamBorc, 0);
    });
  });

  group('enflasyon aşındırması', () {
    test('sabit taksit reel olarak küçülür', () {
      // Tasarımın kalbi: kredi nominal, taksit sabit, enflasyon onu
      // eritiyor. "Kredi çekip ev al" baskısının sayısal karşılığı.
      var durum = baslat(borclar: [kredi(anapara: 600000, vade: 60)]);
      final ilkTaksitReel =
          durum.piyasa.reeleCevir(durum.borclar.single.aylikTaksit);
      for (var t = 0; t < 36; t++) {
        durum = tek(durum).durum;
      }
      final sonTaksitReel =
          durum.piyasa.reeleCevir(durum.borclar.single.aylikTaksit);
      expect(sonTaksitReel, lessThan(ilkTaksitReel / 2));
    });
  });

  group('tur atlama', () {
    test('gecikme atlamayı keser', () {
      final durum = baslat(
        borclar: [kredi(anapara: 5000000, vade: 12)],
        nakit: 0,
      );
      final sonuc = motor.turlariAtla(
        durum,
        TurGirdisi(zaman: ZamanDagilimi.dengeli()),
        12,
      );
      expect(sonuc.raporlar.length, lessThan(12));
      expect(sonuc.raporlar.last.gecikenKrediler, isNotEmpty);
    });

    test('ödenen kredi atlamayı kesmez', () {
      final durum = baslat(borclar: [kredi(anapara: 200000, vade: 60)]);
      final sonuc = motor.turlariAtla(
        durum,
        TurGirdisi(zaman: ZamanDagilimi.dengeli()),
        6,
      );
      expect(sonuc.raporlar.length, 6);
    });
  });

  test('teklif limitleri gerçek gelirle tutarlı', () {
    final durum = baslat();
    final sonuc = tek(durum);
    final teklifler = borcMotoru.teklifler(
      oyuncu: sonuc.durum.oyuncu,
      borclar: const [],
      piyasa: sonuc.durum.piyasa,
      aylikGelir: sonuc.rapor.netGelir,
    );
    expect(teklifler, isNotEmpty);
    for (final t in teklifler) {
      expect(t.enYuksekTutar, greaterThan(0));
      expect(
        t.taksit(t.enYuksekTutar) * 2,
        lessThanOrEqualTo(sonuc.rapor.netGelir + 1),
      );
    }
  });

  group('kredi talebi', () {
    test('çekilen kredi nakde geçer, aynı turda yatırılabilir', () {
      final durum = baslat(nakit: 0);
      final sonuc = motor.turuBitir(
        durum,
        TurGirdisi(
          zaman: ZamanDagilimi.dengeli(),
          // Stajyer bordrosu 18.000: limit gelirin ~9 katı. 100.000
          // içeride, 200.000 dışarıda kalıyor.
          krediTalebi: const KrediTalebi(
            tur: BorcTuru.ihtiyac,
            anapara: 100000,
          ),
          emirler: const [Alim('altin', 20)],
        ),
      );
      expect(sonuc.rapor.cekilenKredi, 100000);
      expect(sonuc.rapor.krediHatasi, isNull);
      expect(sonuc.durum.borclar, hasLength(1));
      // Emir kredi parasıyla karşılandı: pozisyon açıldı.
      expect(sonuc.durum.portfoy.pozisyonlar['altin'], isNotNull);
      // İlk taksit de aynı turda ödendi.
      expect(sonuc.rapor.odenenTaksit, greaterThan(0));
    });

    test('banka bordroya bakar, o turun şoklu gelirine değil', () {
      // Kredi tur işlenmeden önce çekiliyor; gerçekleşen gelir henüz
      // yok. Aynı durumdan çekilen kredi her tohumda aynı limiti vermeli.
      int limit(int tohum) {
        final d = motor
            .yeniOyun(oyuncu: oyuncu(), anaTohum: tohum)
            .copyWith(borclar: const []);
        return motor
            .turuBitir(
              d,
              TurGirdisi(
                zaman: ZamanDagilimi.dengeli(),
                krediTalebi: const KrediTalebi(
                  tur: BorcTuru.ihtiyac,
                  anapara: 100000,
                ),
              ),
            )
            .rapor
            .cekilenKredi;
      }

      expect(limit(1), 100000);
      expect(limit(999), 100000);
    });

    test('reddedilen talep rapora sebebiyle düşer', () {
      final sonuc = motor.turuBitir(
        baslat(),
        TurGirdisi(
          zaman: ZamanDagilimi.dengeli(),
          krediTalebi: const KrediTalebi(
            tur: BorcTuru.ihtiyac,
            anapara: 500000000,
          ),
        ),
      );
      expect(sonuc.rapor.cekilenKredi, 0);
      expect(sonuc.rapor.krediHatasi, KrediHatasi.limitAsildi);
      expect(sonuc.durum.borclar, isEmpty);
    });

    test('işsize kredi verilmez', () {
      final durum = baslat().copyWith(
        oyuncu: oyuncu().copyWith(kariyer: const KariyerDurumu.issiz()),
      );
      final sonuc = motor.turuBitir(
        durum,
        TurGirdisi(
          zaman: ZamanDagilimi.dengeli(),
          krediTalebi: const KrediTalebi(
            tur: BorcTuru.ihtiyac,
            anapara: 50000,
          ),
        ),
      );
      expect(sonuc.rapor.cekilenKredi, 0);
      expect(sonuc.durum.borclar, isEmpty);
    });
  });

  test('kayıt round-trip borçları taşır', () {
    final durum = tek(baslat(borclar: [kredi()])).durum;
    final geri = OyunDurumu.fromJson(
      jsonDecode(jsonEncode(durum)) as Map<String, dynamic>,
    );
    expect(geri, durum);
    expect(geri.borclar.single.kalanTaksit, 35);
  });
}
