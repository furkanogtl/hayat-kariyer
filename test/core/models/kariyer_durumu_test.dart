import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';

void main() {
  const tumDurumlar = <KariyerDurumu>[
    KariyerDurumu.ogrenci(hedef: EgitimSeviyesi.lisans, kalanTur: 48),
    KariyerDurumu.calisan(meslekId: 'yazilim_gelistirici'),
    KariyerDurumu.issiz(),
    KariyerDurumu.askerlik(kalanTur: 6),
    KariyerDurumu.emekli(tabanAylik: 22000),
  ];

  group('JSON', () {
    test('tüm durumlar round-trip edilir', () {
      for (final durum in tumDurumlar) {
        final geri = KariyerDurumu.fromJson(
          jsonDecode(jsonEncode(durum.toJson())) as Map<String, dynamic>,
        );
        expect(geri, durum, reason: '$durum');
      }
    });

    test('ayrım anahtarı sabit: durum', () {
      expect(
        const KariyerDurumu.calisan(meslekId: 'memur').toJson()['durum'],
        'calisan',
      );
      expect(
        const KariyerDurumu.askerlik(kalanTur: 12).toJson()['durum'],
        'askerlik',
      );
    });
  });

  group('Gelir ve prim', () {
    test('sadece çalışan ve emekli gelir üretir', () {
      expect(const KariyerDurumu.calisan(meslekId: 'x').gelirVarMi, isTrue);
      expect(const KariyerDurumu.emekli(tabanAylik: 1).gelirVarMi, isTrue);
      expect(const KariyerDurumu.issiz().gelirVarMi, isFalse);
      expect(const KariyerDurumu.askerlik(kalanTur: 6).gelirVarMi, isFalse);
      expect(
        const KariyerDurumu.ogrenci(
          hedef: EgitimSeviyesi.lisans,
          kalanTur: 1,
        ).gelirVarMi,
        isFalse,
      );
    });

    test('kayıt dışı çalışanın primi yatmaz', () {
      expect(
        const KariyerDurumu.calisan(meslekId: 'x').primYatiyorMu,
        isTrue,
      );
      expect(
        const KariyerDurumu.calisan(meslekId: 'x', kayitDisi: true)
            .primYatiyorMu,
        isFalse,
      );
    });

    test('meslekId sadece çalışanda dolu', () {
      expect(
        const KariyerDurumu.calisan(meslekId: 'asci').meslekId,
        'asci',
      );
      expect(const KariyerDurumu.issiz().meslekId, isNull);
    });
  });

  group('turIlerlet', () {
    test('öğrencilik ve askerlik geri sayar', () {
      const ogrenci = KariyerDurumu.ogrenci(
        hedef: EgitimSeviyesi.lisans,
        kalanTur: 2,
      );
      expect((ogrenci.turIlerlet() as Ogrenci).kalanTur, 1);
      expect(ogrenci.turIlerlet().turIlerlet().suresiDoldu, isTrue);

      const asker = KariyerDurumu.askerlik(kalanTur: 1, bedelli: true);
      final sonra = asker.turIlerlet() as Askerlik;
      expect(sonra.kalanTur, 0);
      expect(sonra.bedelli, isTrue, reason: 'bedelli bilgisi korunmalı');
      expect(sonra.suresiDoldu, isTrue);
    });

    test('çalışanın kademe kıdemi artar, kademesi değişmez', () {
      const calisan = KariyerDurumu.calisan(
        meslekId: 'yazilim_gelistirici',
        kademeIndeksi: 2,
        kademeTuru: 5,
      );
      final sonra = calisan.turIlerlet() as Calisan;
      expect(sonra.kademeTuru, 6);
      expect(sonra.kademeIndeksi, 2, reason: 'terfi motorun işi, modelin değil');
    });

    test('işsizlik sayacı artar, atama bayrağı korunur', () {
      const issiz = KariyerDurumu.issiz(gecenTur: 3, atamaBekliyor: true);
      final sonra = issiz.turIlerlet() as Issiz;
      expect(sonra.gecenTur, 4);
      expect(sonra.atamaBekliyor, isTrue);
    });

    test('emeklilik değişmez', () {
      const emekli = KariyerDurumu.emekli(tabanAylik: 22000);
      expect(emekli.turIlerlet(), emekli);
    });

    test('süresiz durumlarda suresiDoldu daima false', () {
      expect(const KariyerDurumu.issiz(gecenTur: 99).suresiDoldu, isFalse);
      expect(const KariyerDurumu.calisan(meslekId: 'x').suresiDoldu, isFalse);
      expect(const KariyerDurumu.emekli(tabanAylik: 1).suresiDoldu, isFalse);
    });
  });

  group('EgitimSeviyesi', () {
    test('sıralı karşılaştırma', () {
      expect(EgitimSeviyesi.lisans.yeterliMi(EgitimSeviyesi.lise), isTrue);
      expect(EgitimSeviyesi.lisans.yeterliMi(EgitimSeviyesi.lisans), isTrue);
      expect(EgitimSeviyesi.lise.yeterliMi(EgitimSeviyesi.lisans), isFalse);
      expect(EgitimSeviyesi.doktora.sonraki, isNull);
      expect(EgitimSeviyesi.lise.sonraki, EgitimSeviyesi.onlisans);
    });

    test('kimlikten bulunur', () {
      expect(EgitimSeviyesi.bul('yuksek_lisans'), EgitimSeviyesi.yuksekLisans);
      expect(EgitimSeviyesi.bul('yok'), isNull);
    });
  });

  group('Cinsiyet', () {
    test('askerlik yükümlülüğü', () {
      expect(Cinsiyet.erkek.askerlikYukumlusu, isTrue);
      expect(Cinsiyet.kadin.askerlikYukumlusu, isFalse);
    });
  });
}
