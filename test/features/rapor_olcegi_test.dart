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
import 'package:hayat_kariyer/features/ozet/tur_raporu_kagidi.dart';

/// EKRANLAR ARASI ÖLÇEK SÖZLEŞMESİ.
///
/// Furkan oynarken sordu: "kazanılan para 2 Mn ama net nakit 100 B
/// görünüyor, orada bir sıkıntı mı var". Vardı: tur raporu NOMİNAL,
/// Özet kartı REEL basıyordu. Aynı para iki ekranda iki ölçekte duruyordu
/// ve hiçbir yerde patlamıyordu — yalnız oyuncu kendi parasını sayamıyordu.
///
/// Karar: bilanço yüzeyleri nominal, YALNIZ ana skor reel ve öyle etiketli.
/// Bu testler o kararı tutuyor.
void main() {
  final katalog = MeslekKatalogu.jsonMetinlerinden(
    Directory('assets/careers')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .map((f) => f.readAsStringSync()),
  );
  final motor = TurProcessor(katalog: katalog);

  OyunDurumu baslat() => motor.yeniOyun(
        oyuncu: Oyuncu.yeni(
          ad: 'Test',
          sehir: Sehir.konya,
          egitim: EgitimSeviyesi.lisans,
        ).yetkinlikDegistir(Sektor.hukukKamu, 20).copyWith(
              nakit: 100000,
              kariyer: const KariyerDurumu.calisan(meslekId: 'memur'),
            ),
        anaTohum: 4242,
        baslangicRejimi: Rejim.buyume,
      );

  test('rapordaki nakit değişimi Özet\'teki nakitle bire bir tutuyor', () {
    // Enflasyon endeksi 1'den belirgin şekilde uzaklaşsın: hatanın
    // görünür olduğu yer orası. Endeks 1 iken reel ve nominal aynı sayıdır
    // ve test hiçbir şey kanıtlamaz.
    var durum = baslat();
    for (var i = 0; i < 180; i++) {
      durum = motor.turuBitir(durum, TurGirdisi(zaman: ZamanDagilimi.dengeli()))
          .durum;
    }
    expect(durum.piyasa.enflasyonEndeksi, greaterThan(5),
        reason: 'ölçüm anlamlı olsun diye endeks yeterince büyümeli');

    final oncekiNakit = durum.oyuncu.nakit;
    final sonuc =
        motor.turuBitir(durum, TurGirdisi(zaman: ZamanDagilimi.dengeli()));

    // Özet kartının nakit satırı bu iki değeri gösteriyor.
    final ekranOncesi = sonuc.durum.piyasa.gosterimTutari(oncekiNakit);
    final ekranSonrasi =
        sonuc.durum.piyasa.gosterimTutari(sonuc.durum.oyuncu.nakit);

    // Rapor kâğıdının "nakit değişimi" satırı bunu gösteriyor.
    final raporSatiri =
        raporToplami([sonuc.rapor], (r) => r.nakitDegisimi);

    expect(raporSatiri, closeTo(ekranSonrasi - ekranOncesi, 1),
        reason: 'rapor reele çevrilirse bu fark asla kapanmaz: mevcut '
            'bakiye de enflasyonla eriyor');
  });

  test('çok turlu rapor da bakiyeyle tutuyor (nominal toplanıyor)', () {
    var durum = baslat();
    for (var i = 0; i < 120; i++) {
      durum = motor.turuBitir(durum, TurGirdisi(zaman: ZamanDagilimi.dengeli()))
          .durum;
    }
    final oncekiNakit = durum.oyuncu.nakit;
    final sonuc = motor.turlariAtla(
      durum,
      TurGirdisi(zaman: ZamanDagilimi.dengeli()),
      12,
    );
    // Atlama erken kesilmiş olabilir; kaç tur işlendiyse o kadarı sayılır.
    final beklenen = sonuc.durum.piyasa.gosterimTutari(sonuc.durum.oyuncu.nakit) -
        sonuc.durum.piyasa.gosterimTutari(oncekiNakit);

    expect(raporToplami(sonuc.raporlar, (r) => r.nakitDegisimi),
        closeTo(beklenen, 1),
        reason: 'turların deltası deflate edilirse toplam bakiyeyi tutmaz');
  });

  test('para reformu raporda da uygulanıyor', () {
    // Reform yalnız sunum ölçeği; motor ham TL ile çalışmaya devam eder.
    // Rapor bu ölçeği uygulamazsa ekranın geri kalanı üç sıfır atılmış
    // parayı gösterirken rapor eski parayla yazar — 1000 kat sapma.
    TurRaporu ornek(double olcek) => TurRaporu(
          tur: 1,
          yas: 18,
          ay: 1,
          netGelir: 2000000,
          yasamGideri: 0,
          faizGideri: 0,
          nakitDegisimi: 2000000,
          rejim: Rejim.buyume,
          rejimDegisti: false,
          aylikEnflasyon: 0.02,
          paraOlcegi: olcek,
          maasZammiYapildi: false,
          paraReformuYapildi: false,
          performans: 1,
          kiraGeliri: 0,
          portfoyDegeri: 0,
          netDeger: 0,
        );

    expect(raporToplami([ornek(1)], (r) => r.netGelir), 2000000);
    expect(raporToplami([ornek(1000)], (r) => r.netGelir), 2000);
  });
}
