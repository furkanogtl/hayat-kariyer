import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/olay_motoru.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/meslek_katalogu.dart';
import 'package:hayat_kariyer/core/models/olay.dart';
import 'package:hayat_kariyer/core/models/olay_katalogu.dart';
import 'package:hayat_kariyer/core/models/oyun_durumu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';

/// `TurProcessor.secimUygula` — arayüzün kart seçimi kapısı.
///
/// Buradaki asıl konu RNG AKIŞ ADI. `RastgeleKaynak.akis` aynı (tohum, ad,
/// tur) üçlüsü için akışı hep BAŞTAN verir; tek isim kullanılsaydı bir
/// turdaki bütün kartlar aynı zarla çözülürdü.
void main() {
  MeslekKatalogu meslekler() => MeslekKatalogu.jsonMetinlerinden(
        Directory('assets/careers')
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.json'))
            .map((f) => f.readAsStringSync()),
      );

  /// Yazı-tura dallanan kart. İki dal da aynı yapıda; fark yalnız metinde.
  Olay yaziTura(String id) => Olay(
        id: id,
        baslik: id,
        metin: 'test',
        secenekler: const [
          OlaySecenegi(
            etiket: 'at',
            sonuclar: [
              OlaySonucu(sans: 0.5, metin: 'yazi'),
              OlaySonucu(sans: 0.5, metin: 'tura'),
            ],
          ),
        ],
      );

  TurProcessor motorKur(Iterable<Olay> kartlar) => TurProcessor(
        katalog: meslekler(),
        olay: OlayMotoru(katalog: OlayKatalogu.listeden(kartlar)),
      );

  OyunDurumu durumKur(TurProcessor motor, int tohum) => motor.yeniOyun(
        oyuncu: Oyuncu.yeni(
          ad: 'Test',
          sehir: Sehir.konya,
          egitim: EgitimSeviyesi.lisans,
        ).copyWith(
          nakit: 500000,
          kariyer: const KariyerDurumu.calisan(meslekId: 'yazilim_gelistirici'),
        ),
        anaTohum: tohum,
      );

  test('aynı turdaki iki kart aynı zara kilitlenmiyor', () {
    // Tek akış adı kullanılsaydı bu oran 1,0 çıkardı: iki kart her oyunda
    // aynı dala düşerdi ve "iki kart çıktı" hissi sahte olurdu.
    final motor = motorKur([yaziTura('a'), yaziTura('b')]);
    final a = motor.olay!.katalog.bul('a')!;
    final b = motor.olay!.katalog.bul('b')!;

    var ayni = 0;
    const deneme = 200;
    for (var tohum = 1; tohum <= deneme; tohum++) {
      final durum = durumKur(motor, tohum);
      final sonucA = motor.secimUygula(durum, a, 0).acilanSonuc!.metin;
      final sonucB = motor.secimUygula(durum, b, 0).acilanSonuc!.metin;
      if (sonucA == sonucB) ayni++;
    }
    // Bağımsızsa ~%50. Geniş bant: sınanan şey kilitlenme, dağılım değil.
    expect(ayni / deneme, greaterThan(0.3));
    expect(ayni / deneme, lessThan(0.7));
  });

  test('aynı kart aynı durumda hep aynı sonucu verir', () {
    // Belirlenimlilik: kayıt tekrar üretilebilir olmalı.
    final motor = motorKur([yaziTura('a')]);
    final kart = motor.olay!.katalog.bul('a')!;
    final durum = durumKur(motor, 99);
    final ilk = motor.secimUygula(durum, kart, 0).acilanSonuc!.metin;
    expect(motor.secimUygula(durum, kart, 0).acilanSonuc!.metin, ilk);
  });

  test('olay motoru yoksa seçim durumu bozmaz', () {
    // Denge simülasyonları kartsız koşuyor; oradan gelen çağrı patlamamalı.
    final motor = TurProcessor(katalog: meslekler());
    final durum = durumKur(motor, 1);
    expect(motor.secimUygula(durum, yaziTura('a'), 0).durum, durum);
  });

  test('gecikmeli seçim sonucu ANINDA açmıyor', () {
    // Anayasa: gecikmeli sonucun zarı bekleme bitince atılır. Karar anında
    // atılıp saklansaydı kayıt dosyasını açan sonucu görebilirdi.
    const gecikmeli = Olay(
      id: 'g',
      baslik: 'g',
      metin: 'test',
      secenekler: [
        OlaySecenegi(
          etiket: 'bekle',
          gecikmeTuru: 6,
          sonuclar: [
            OlaySonucu(sans: 0.5, metin: 'iyi'),
            OlaySonucu(sans: 0.5, metin: 'kotu'),
          ],
        ),
      ],
    );
    final motor = motorKur([gecikmeli]);
    final sonuc = motor.secimUygula(durumKur(motor, 5), gecikmeli, 0);
    expect(sonuc.beklemeyeAlindi, isTrue);
    expect(sonuc.acilanSonuc, isNull);
    expect(sonuc.durum.bekleyenOlaylar.single.kalanTur, 6);
  });
}
