import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/borc_motoru.dart';
import 'package:hayat_kariyer/core/engine/dip_motoru.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/core/models/borc.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/meslek_katalogu.dart';
import 'package:hayat_kariyer/core/models/oyun_durumu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/portfoy.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/zaman_dagilimi.dart';

/// Oyunun dibi: kısıtlı yaşam, haciz, oyun sonu.
///
/// Bu sistemden önce oyunun kaybetme hâli TANIMSIZDI — net değer sınırsız
/// eksiye gidiyordu. Buradaki testler dibin gerçekten dip olduğunu tutuyor.
void main() {
  final katalog = MeslekKatalogu.jsonMetinlerinden(
    Directory('assets/careers')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .map((f) => f.readAsStringSync()),
  );
  final motor = TurProcessor(katalog: katalog);
  const dip = DipMotoru();

  Borc gecikmis(int gecikmeTuru) => Borc(
        id: 'k1',
        tur: BorcTuru.ihtiyac,
        anapara: 2000000,
        kalanAnapara: 2000000,
        aylikTaksit: 90000,
        aylikFaiz: 0.03,
        kalanTaksit: 30,
        cekildigiTur: 0,
        gecikmeTuru: gecikmeTuru,
      );

  OyunDurumu baslat({
    int nakit = 0,
    int yas = 30,
    List<Borc> borclar = const [],
    Portfoy portfoy = const Portfoy(),
  }) =>
      motor
          .yeniOyun(
            oyuncu: Oyuncu.yeni(
              ad: 'Test',
              sehir: Sehir.konya,
              egitim: EgitimSeviyesi.lisans,
            ).copyWith(
              nakit: nakit,
              baslangicYasi: yas,
              kariyer: const KariyerDurumu.calisan(
                meslekId: 'yazilim_gelistirici',
              ),
            ),
            anaTohum: 4040,
          )
          .copyWith(borclar: borclar, portfoy: portfoy);

  TurSonucu isle(OyunDurumu durum) =>
      motor.turuBitir(durum, TurGirdisi(zaman: ZamanDagilimi.dengeli()));

  group('kısıtlı yaşam', () {
    test('nakit eksideyken gider düşüyor', () {
      final artida = isle(baslat(nakit: 5000000));
      final ekside = isle(baslat(nakit: -100));
      expect(artida.rapor.kisitliYasam, isFalse);
      expect(ekside.rapor.kisitliYasam, isTrue);
      expect(ekside.rapor.yasamGideri, lessThan(artida.rapor.yasamGideri));
    });

    test('bedava değil: mutluluk eriyor', () {
      // Gider düşerken mutluluk da düşmeseydi "parasız kalmak" bir
      // tasarruf stratejisine dönerdi.
      final durum = baslat(nakit: -100);
      final sonuc = isle(durum);
      expect(
        sonuc.durum.oyuncu.mutluluk,
        lessThan(isle(baslat(nakit: 5000000)).durum.oyuncu.mutluluk),
      );
    });

    test('gider tabanı düşüşü YAVAŞLATIYOR ama durdurmuyor', () {
      // Yumuşak dip tek başına yeterli değil: oyuncu yine batıyor,
      // sadece daha yavaş. Durduran şey sert dip (haciz).
      final tam = const DipMotoru().yasamGideri(100000, 5000000);
      final kisitli = const DipMotoru().yasamGideri(100000, -1);
      expect(kisitli, lessThan(tam));
      expect(kisitli, greaterThan(0));
    });
  });

  group('haciz', () {
    test('eşiği aşan gecikme haczi tetikliyor', () {
      expect(dip.iflasGerekiyorMu([gecikmis(5)]), isFalse);
      expect(dip.iflasGerekiyorMu([gecikmis(6)]), isTrue);
    });

    test('portföy elden çıkıyor, borç siliniyor, kredi kapanıyor', () {
      final durum = baslat(
        nakit: -50000,
        borclar: [gecikmis(6)],
        portfoy: const Portfoy(
          pozisyonlar: {
            'altin': Pozisyon(adet: 100, ortalamaMaliyet: 4500),
          },
        ),
      );
      final sonuc = isle(durum);

      expect(sonuc.rapor.iflasEtti, isTrue);
      expect(sonuc.rapor.hacizGeliri, greaterThan(0));
      expect(sonuc.durum.portfoy.bosMu, isTrue);
      expect(sonuc.durum.borclar, isEmpty);
      expect(sonuc.durum.oyuncu.krediNotu, Oyuncu.krediNotuTaban);
      expect(sonuc.durum.krediYasakli, isTrue);
      expect(sonuc.durum.iflasSayisi, 1);
      // Hesap sıfırlanıyor: varlıklar gitti, borç silindi.
      expect(sonuc.durum.oyuncu.nakit, 0);
    });

    test('icra satışı piyasa fiyatının altında', () {
      const portfoy = Portfoy(
        pozisyonlar: {'altin': Pozisyon(adet: 100, ortalamaMaliyet: 4500)},
      );
      final durum = baslat(portfoy: portfoy, borclar: [gecikmis(6)]);
      final piyasaDegeri = portfoy.piyasaDegeri(durum.piyasa.fiyatlar);
      final sonuc = dip.hacizUygula(
        portfoy: portfoy,
        borclar: [gecikmis(6)],
        piyasa: durum.piyasa,
        nakit: 0,
      );
      expect(sonuc.hacizGeliri, lessThan(piyasaDegeri));
      expect(sonuc.silinenBorc, greaterThan(0));
    });

    test('işletmelere dokunulmuyor', () {
      // Her şeyi kaybetmek oyunu bitirir; iflas bir bitiş değil bir dip.
      final durum = baslat(borclar: [gecikmis(6)]);
      final sonuc = isle(durum);
      expect(sonuc.durum.isletmeler, durum.isletmeler);
    });

    test('yasak süresince kredi verilmiyor, sonra açılıyor', () {
      var durum = isle(baslat(borclar: [gecikmis(6)])).durum;
      expect(motor.krediTeklifleri(durum), isEmpty);

      final ret = motor.turuBitir(
        durum,
        TurGirdisi(
          zaman: ZamanDagilimi.dengeli(),
          krediTalebi: const KrediTalebi(
            tur: BorcTuru.ihtiyac,
            anapara: 50000,
          ),
        ),
      );
      expect(ret.rapor.krediHatasi, KrediHatasi.krediYasagi);
      expect(ret.rapor.cekilenKredi, 0);

      // Sayaç her tur azalıyor.
      for (var t = 0; t < 30; t++) {
        durum = isle(durum).durum;
      }
      expect(durum.krediYasakli, isFalse);
    });

    test('borcu olmayan oyuncu için de dip var', () {
      // Eksi bakiye faizi hiçbir borç nesnesine bağlı değil; bu eşik
      // olmadan kredisiz oyuncu sonsuza kadar eksiye gidiyordu.
      // Ölçüldü: 37 işsiz yılda -139,8M reel.
      expect(dip.nakitIflasiGerekiyorMu(-100000, 30000), isFalse);
      expect(dip.nakitIflasiGerekiyorMu(-400000, 30000), isTrue);
      // Gider bilinmiyorsa tetiklenmiyor.
      expect(dip.nakitIflasiGerekiyorMu(-99999999, 0), isFalse);
    });

    test('gelirsiz oyuncunun bakiyesi sınırsız eksiye gitmiyor', () {
      var durum = baslat(nakit: 0).copyWith(
        oyuncu: baslat().oyuncu.copyWith(
              kariyer: const KariyerDurumu.issiz(),
            ),
      );
      for (var t = 0; t < 120; t++) {
        durum = isle(durum).durum;
      }
      expect(durum.iflasSayisi, greaterThan(0));
      // Haciz hesabı sıfırladığı için bakiye bir yıllık giderin birkaç
      // katından öteye gidemiyor.
      expect(durum.oyuncu.nakit, greaterThan(-30000000));
    });

    test('haciz tur atlamayı kesiyor', () {
      final sonuc = motor.turlariAtla(
        baslat(borclar: [gecikmis(6)]),
        TurGirdisi(zaman: ZamanDagilimi.dengeli()),
        12,
      );
      expect(sonuc.raporlar, hasLength(1));
      expect(sonuc.raporlar.single.iflasEtti, isTrue);
    });

    test('haciz sonrası oyuncu toparlanabiliyor', () {
      // Dip bir bitiş değil: gelir devam ediyor, oyuncu yeniden birikime
      // geçebilmeli.
      var durum = isle(baslat(borclar: [gecikmis(6)])).durum;
      for (var t = 0; t < 36; t++) {
        durum = isle(durum).durum;
      }
      expect(durum.oyuncu.nakit, greaterThan(0));
      expect(durum.oyuncu.krediNotu, greaterThan(Oyuncu.krediNotuTaban));
    });
  });

  group('oyun sonu', () {
    test('yaş sınırında oyun bitiyor', () {
      expect(dip.oyunBitti(64), isFalse);
      expect(dip.oyunBitti(65), isTrue);
    });

    test('sınıra gelen turda rapor bunu söylüyor', () {
      // 64 yaşında 12 tur: 65'e geçtiği turda bayrak kalkmalı.
      var durum = baslat(yas: 64);
      var bitti = false;
      for (var t = 0; t < 12 && !bitti; t++) {
        final sonuc = isle(durum);
        durum = sonuc.durum;
        bitti = sonuc.rapor.oyunBitti;
      }
      expect(bitti, isTrue);
      expect(durum.oyunBitti, isTrue);
    });
  });

  test('kayıt round-trip dip alanlarını taşıyor', () {
    final durum = isle(baslat(borclar: [gecikmis(6)])).durum;
    final geri = OyunDurumu.fromJson(
      jsonDecode(jsonEncode(durum)) as Map<String, dynamic>,
    );
    expect(geri, durum);
    expect(geri.krediYasagiTuru, durum.krediYasagiTuru);
    expect(geri.iflasSayisi, 1);
  });
}
