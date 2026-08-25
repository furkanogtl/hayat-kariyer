import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/skor.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/meslek_katalogu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/zaman_dagilimi.dart';

void main() {
  final katalog = MeslekKatalogu.jsonMetinlerinden(
    Directory('assets/careers')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .map((f) => f.readAsStringSync()),
  );
  final motor = TurProcessor(katalog: katalog);

  group('ünvan', () {
    test('bantlar sırayla yükseliyor', () {
      expect(unvanHesapla(-1, 0), OyunSonuUnvani.ucuUcuna);
      expect(unvanHesapla(0, 0), OyunSonuUnvani.orta);
      expect(unvanHesapla(9999999, 0), OyunSonuUnvani.orta);
      expect(unvanHesapla(10000000, 0), OyunSonuUnvani.rahat);
      expect(unvanHesapla(100000000, 0), OyunSonuUnvani.zengin);
      expect(unvanHesapla(1000000000, 0), OyunSonuUnvani.imparator);
    });

    test('haciz görüp toparlanan ayrı sayılıyor', () {
      // Aynı serveti hiç düşmeden kuran ile dipten dönen aynı ünvanı
      // almamalı.
      expect(unvanHesapla(50000000, 0), OyunSonuUnvani.rahat);
      expect(unvanHesapla(50000000, 1), OyunSonuUnvani.dipteDonen);
    });

    test('haciz görüp toparlanamayan dipten dönmüş sayılmıyor', () {
      expect(unvanHesapla(500000, 1), OyunSonuUnvani.orta);
      expect(unvanHesapla(-500000, 1), OyunSonuUnvani.ucuUcuna);
    });
  });

  group('zirve', () {
    test('en yüksek reel net değer kayda giriyor', () {
      var durum = motor.yeniOyun(
        oyuncu: Oyuncu.yeni(
          ad: 'Test',
          sehir: Sehir.konya,
          egitim: EgitimSeviyesi.lisans,
        ).copyWith(
          nakit: 5000000,
          kariyer: const KariyerDurumu.calisan(
            meslekId: 'yazilim_gelistirici',
          ),
        ),
        anaTohum: 12,
      );
      var enYuksek = 0;
      for (var t = 0; t < 60; t++) {
        durum = motor
            .turuBitir(durum, TurGirdisi(zaman: ZamanDagilimi.dengeli()))
            .durum;
        if (durum.reelNetDeger > enYuksek) enYuksek = durum.reelNetDeger;
      }
      expect(durum.zirveNetDeger, enYuksek);
    });

    test('zirve düşüşte geri gitmiyor', () {
      // Serveti eriyen oyuncu "bir ara buradaydım" bilgisini kaybetmemeli.
      var durum = motor.yeniOyun(
        oyuncu: Oyuncu.yeni(
          ad: 'Test',
          sehir: Sehir.istanbul,
          egitim: EgitimSeviyesi.lise,
        ).copyWith(nakit: 3000000, kariyer: const KariyerDurumu.issiz()),
        anaTohum: 33,
      );
      durum = motor
          .turuBitir(durum, TurGirdisi(zaman: ZamanDagilimi.calismadan()))
          .durum;
      final ilkZirve = durum.zirveNetDeger;
      expect(ilkZirve, greaterThan(0));

      for (var t = 0; t < 48; t++) {
        durum = motor
            .turuBitir(durum, TurGirdisi(zaman: ZamanDagilimi.calismadan()))
            .durum;
      }
      expect(durum.reelNetDeger, lessThan(ilkZirve));
      expect(durum.zirveNetDeger, ilkZirve);
    });
  });

  test('özet durumdan türetiliyor', () {
    final durum = motor
        .yeniOyun(
          oyuncu: Oyuncu.yeni(
            ad: 'Test',
            sehir: Sehir.konya,
            egitim: EgitimSeviyesi.lisans,
          ),
          anaTohum: 909,
        )
        .copyWith(iflasSayisi: 2, zirveNetDeger: 50000000);
    final ozet = OyunSonuOzeti.durumdan(durum);
    expect(ozet.tohum, 909);
    expect(ozet.iflasSayisi, 2);
    expect(ozet.zirveNetDeger, 50000000);
    expect(ozet.yas, durum.yas);
  });

  test('zirvesi yazılmamış eski kayıt son değere düşüyor', () {
    // Alanı olmayan kayıtta zirve 0; özet son net değeri göstermeli,
    // "zirven sıfırdı" dememeli.
    final durum = motor
        .yeniOyun(
          oyuncu: Oyuncu.yeni(
            ad: 'Test',
            sehir: Sehir.konya,
            egitim: EgitimSeviyesi.lisans,
          ).copyWith(nakit: 1000000),
          anaTohum: 1,
        )
        .copyWith(zirveNetDeger: 0);
    final ozet = OyunSonuOzeti.durumdan(durum);
    expect(ozet.zirveNetDeger, ozet.reelNetDeger);
  });
}
