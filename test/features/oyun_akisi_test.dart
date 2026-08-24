import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/meslek.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/zaman_dagilimi.dart';
import 'package:hayat_kariyer/features/oyun/oyun_saglayicilar.dart';

/// Arayüz katmanının motora bağlanışını sınar.
///
/// Widget testi değil: burada sınanan şey ekranın nasıl göründüğü değil,
/// sağlayıcıların motoru DOĞRU sırayla ve doğru girdiyle çağırıp
/// çağırmadığı. Ekranlar değişse de bu sözleşme durmalı.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> kur() async {
    final kap = ProviderContainer();
    addTearDown(kap.dispose);
    // Katalog yüklenmeden motor kurulamaz; uygulama kabuğu da bunu bekler.
    await kap.read(kataloglarProvider.future);
    return kap;
  }

  /// Oyuncunun o an girebileceği ilk iş.
  Meslek ilkIs(ProviderContainer kap) => kap
      .read(kataloglarProvider)
      .requireValue
      .meslekler
      .girilebilirler(kap.read(oyunProvider)!.durum.oyuncu)
      .first;

  void yeniOyun(ProviderContainer kap) =>
      kap.read(oyunProvider.notifier).yeniOyun(
            ad: 'Test',
            cinsiyet: Cinsiyet.erkek,
            sehir: Sehir.konya,
            egitim: EgitimSeviyesi.lisans,
            // Tohum sabit: test tekrar üretilebilir olmalı.
            tohum: 4242,
          );

  test('kataloglar asset paketinden okunuyor', () async {
    final kap = await kur();
    final k = kap.read(kataloglarProvider).requireValue;
    expect(k.meslekler.tumu, isNotEmpty);
    expect(k.olaylar.tumu, isNotEmpty);
    expect(k.isletmeler.tumu, isNotEmpty);
  });

  test('işletme kart dizini motora bağlanıyor', () async {
    // Bağlanmazsa işletme kartları işletmesi olmayan herkese sızar.
    // TurProcessor kurucusundaki assert bunu yakalıyor; burada da
    // dizinin gerçekten dolu geldiğini doğruluyoruz.
    final kap = await kur();
    final motor = kap.read(turProcessorProvider);
    expect(motor.olay!.isletmeKartlari, isNotEmpty);
  });

  test('yeni oyun 18 yaşında ve işsiz başlar', () async {
    final kap = await kur();
    expect(kap.read(oyunProvider), isNull);
    yeniOyun(kap);
    final durum = kap.read(oyunProvider)!.durum;
    expect(durum.yas, 18);
    expect(durum.tur, 0);
    expect(durum.oyuncu.kariyer, isA<Issiz>());
  });

  test('aynı tohum aynı oyunu verir', () async {
    Future<int> oyna() async {
      final kap = await kur();
      yeniOyun(kap);
      kap
          .read(oyunProvider.notifier)
          .turlariAtla(TurGirdisi(zaman: ZamanDagilimi.dengeli()), 6);
      return kap.read(oyunProvider)!.durum.netDeger;
    }

    expect(await oyna(), await oyna());
  });

  test('işe giriş talebi turu bitirince uygulanır', () async {
    final kap = await kur();
    yeniOyun(kap);
    final meslek = ilkIs(kap);

    kap.read(taleplerProvider.notifier).iseGir(meslek.id);
    // Talep tek başına hiçbir şey yapmaz: durum hâlâ işsiz.
    expect(kap.read(oyunProvider)!.durum.oyuncu.kariyer, isA<Issiz>());

    kap.read(oyunProvider.notifier).turuBitir(
          TurGirdisi(
            zaman: ZamanDagilimi.dengeli(),
            iseGirTalebi: meslek.id,
          ),
        );
    final kariyer = kap.read(oyunProvider)!.durum.oyuncu.kariyer;
    expect(kariyer, isA<Calisan>());
    expect(kariyer.meslekId, meslek.id);
  });

  test('işe giriş talebi zaman varsayılanını çalışmaya çevirir', () async {
    // İşsizin varsayılanı çalışma 0. İşe girdiği turda o dağılımla turu
    // bitirseydi performansı sıfır olduğu için İLK AY kovulurdu; oyuncunun
    // göremeyeceği bir tuzaktı.
    final kap = await kur();
    yeniOyun(kap);
    expect(kap.read(zamanProvider).calisma, 0);

    kap.read(taleplerProvider.notifier).iseGir(ilkIs(kap).id);
    expect(kap.read(zamanProvider).calisma, greaterThan(0));
  });

  test('işe giren oyuncu ilk ay kovulmuyor', () async {
    // Yukarıdaki tuzağın uçtan uca kanıtı: ekranın gerçekten kullandığı
    // taslakla turu bitir, hâlâ çalışıyor ol.
    final kap = await kur();
    yeniOyun(kap);
    final meslek = ilkIs(kap);
    kap.read(taleplerProvider.notifier).iseGir(meslek.id);
    kap.read(oyunProvider.notifier).turuBitir(
          TurGirdisi(
            zaman: kap.read(zamanProvider),
            iseGirTalebi: meslek.id,
          ),
        );
    expect(kap.read(oyunProvider)!.durum.oyuncu.kariyer, isA<Calisan>());
    expect(kap.read(oyunProvider)!.sonRaporlar.single.istenCikarildi, isFalse);
  });

  test('zaman taslağı turlar arasında korunur', () async {
    // Her tur varsayılana dönseydi oyuncu dağılımı her ay elle kurardı.
    final kap = await kur();
    yeniOyun(kap);
    final meslek = ilkIs(kap);
    kap.read(taleplerProvider.notifier).iseGir(meslek.id);
    kap.read(oyunProvider.notifier).turuBitir(
          TurGirdisi(
            zaman: kap.read(zamanProvider),
            iseGirTalebi: meslek.id,
          ),
        );
    kap.read(taleplerProvider.notifier).temizle();

    const elleKurulan = ZamanDagilimi(calisma: 8, dinlenme: 2);
    kap.read(zamanProvider.notifier).ayarla(elleKurulan);
    kap
        .read(oyunProvider.notifier)
        .turuBitir(TurGirdisi(zaman: kap.read(zamanProvider)));
    expect(kap.read(zamanProvider), elleKurulan);
  });

  test('zaman dağılımı toplam puanı aşamaz', () async {
    final kap = await kur();
    yeniOyun(kap);
    final notifier = kap.read(zamanProvider.notifier);
    notifier.ayarla(ZamanDagilimi.tamMesai());
    // Doluyken artırma yok sayılır, sessizce başka kalemden çalmaz.
    notifier.artir(ZamanAlani.egitim, 1);
    expect(kap.read(zamanProvider).toplam, ZamanDagilimi.toplamPuan);
    expect(kap.read(zamanProvider).egitim, 0);
  });

  test('tur raporu üretiliyor ve temizlenebiliyor', () async {
    final kap = await kur();
    yeniOyun(kap);
    final notifier = kap.read(oyunProvider.notifier)
      ..turuBitir(TurGirdisi(zaman: ZamanDagilimi.dengeli()));
    expect(kap.read(oyunProvider)!.sonRaporlar, hasLength(1));
    notifier.raporlariTemizle();
    expect(kap.read(oyunProvider)!.sonRaporlar, isEmpty);
  });

  test('atlama erken kesilebilir, rapor sayısı bunu gösterir', () async {
    final kap = await kur();
    yeniOyun(kap);
    kap
        .read(oyunProvider.notifier)
        .turlariAtla(TurGirdisi(zaman: ZamanDagilimi.dengeli()), 12);
    final raporlar = kap.read(oyunProvider)!.sonRaporlar;
    expect(raporlar, isNotEmpty);
    expect(raporlar.length, lessThanOrEqualTo(12));
    // Kaç tur işlendiyse tur sayacı o kadar ilerlemiş olmalı.
    expect(kap.read(oyunProvider)!.durum.tur, raporlar.length);
  });
}
