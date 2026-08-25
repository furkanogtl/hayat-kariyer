import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/meslek.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/zaman_dagilimi.dart';
import 'package:hayat_kariyer/data/kayit_deposu.dart';
import 'package:hayat_kariyer/features/oyun/oyun_saglayicilar.dart';

/// Arayüz katmanının motora bağlanışını sınar.
///
/// Widget testi değil: burada sınanan şey ekranın nasıl göründüğü değil,
/// sağlayıcıların motoru DOĞRU sırayla ve doğru girdiyle çağırıp
/// çağırmadığı. Ekranlar değişse de bu sözleşme durmalı.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> kur() async {
    final dizin = Directory.systemTemp.createTempSync('hk_test_');
    addTearDown(() {
      if (dizin.existsSync()) dizin.deleteSync(recursive: true);
    });
    // Otomatik kayıt platform eklentisine gitmesin: testler diske değil
    // geçici dizine yazsın.
    final kap = ProviderContainer(
      overrides: [
        kayitDeposuProvider.overrideWithValue(KayitDeposu(dizin: dizin)),
      ],
    );
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

  group('olay kartları', () {
    /// Kart çıkana kadar tur işler. Kart çıkma ihtimali %25 olduğu için
    /// birkaç turda kesin çıkıyor; çıkmazsa test anlamsız olur, o yüzden
    /// üst sınır var.
    Future<ProviderContainer> kartaKadarOyna() async {
      final kap = await kur();
      yeniOyun(kap);
      final meslek = ilkIs(kap);
      kap.read(oyunProvider.notifier).turuBitir(
            TurGirdisi(
              zaman: ZamanDagilimi.dengeli(),
              iseGirTalebi: meslek.id,
            ),
          );
      for (var i = 0; i < 60 && !kap.read(oyunProvider)!.kararBekliyor; i++) {
        kap
            .read(oyunProvider.notifier)
            .turuBitir(TurGirdisi(zaman: ZamanDagilimi.dengeli()));
      }
      expect(
        kap.read(oyunProvider)!.kararBekliyor,
        isTrue,
        reason: '60 turda hiç kart çıkmadı',
      );
      return kap;
    }

    test('deste tur işlendikçe çekiliyor', () async {
      final kap = await kartaKadarOyna();
      final oturum = kap.read(oyunProvider)!;
      expect(oturum.bekleyenKartlar, isNotEmpty);
      // Deste durumdan SAF olarak türetiliyor: motor aynı durumdan aynı
      // desteyi vermeli, yoksa kayıttan dönen oyuncu başka kart görürdü.
      expect(
        kap
            .read(turProcessorProvider)
            .desteCek(oturum.durum)
            .kartlar
            .map((k) => k.id),
        oturum.bekleyenKartlar.map((k) => k.id),
      );
    });

    test('seçim kartı desteden düşürmez, kapatma düşürür', () async {
      // Sonuç metni okunmadan sıradaki karta atlanmamalı.
      final kap = await kartaKadarOyna();
      final notifier = kap.read(oyunProvider.notifier);
      final kart = kap.read(oyunProvider)!.bekleyenKartlar.first;
      final adet = kap.read(oyunProvider)!.bekleyenKartlar.length;

      expect(notifier.secimYap(kart, 0), isNotNull);
      expect(kap.read(oyunProvider)!.bekleyenKartlar, hasLength(adet));

      notifier.kartiKapat();
      expect(kap.read(oyunProvider)!.bekleyenKartlar, hasLength(adet - 1));
    });

    test('seçim oyun durumunu gerçekten değiştiriyor', () async {
      final kap = await kartaKadarOyna();
      final once = kap.read(oyunProvider)!.durum;
      final kart = kap.read(oyunProvider)!.bekleyenKartlar.first;
      kap.read(oyunProvider.notifier).secimYap(kart, 0);
      final sonra = kap.read(oyunProvider)!.durum;
      // Kart geçmişine yazılmış olmalı: aynı kart hemen tekrar çıkmasın.
      expect(sonra.olayGecmisi[kart.id], isNotNull);
      expect(sonra, isNot(once));
    });

    test('kart bekleyen turda tur bitirilmemeli', () async {
      // Ekran bunu düğmeyi kapatarak zorluyor; burada sözleşmenin
      // sağlayıcı tarafı sınanıyor.
      final kap = await kartaKadarOyna();
      expect(kap.read(oyunProvider)!.kararBekliyor, isTrue);
    });
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

  group('kayıt', () {
    /// Aynı geçici dizine bakan iki ayrı kap: "uygulamayı kapat, aç".
    Future<ProviderContainer> kapAc(Directory dizin) async {
      final kap = ProviderContainer(
        overrides: [
          kayitDeposuProvider.overrideWithValue(KayitDeposu(dizin: dizin)),
        ],
      );
      addTearDown(kap.dispose);
      await kap.read(kataloglarProvider.future);
      return kap;
    }

    test('tur bitince otomatik kaydediliyor, yeniden açılınca dönüyor',
        () async {
      final dizin = Directory.systemTemp.createTempSync('hk_akis_');
      addTearDown(() {
        if (dizin.existsSync()) dizin.deleteSync(recursive: true);
      });

      final ilk = await kapAc(dizin);
      ilk.read(oyunProvider.notifier).yeniOyun(
            ad: 'Kayıtlı',
            cinsiyet: Cinsiyet.erkek,
            sehir: Sehir.trabzon,
            egitim: EgitimSeviyesi.lisans,
            tohum: 8181,
          );
      for (var i = 0; i < 3; i++) {
        while (ilk.read(oyunProvider)!.kararBekliyor) {
          ilk.read(oyunProvider.notifier)
            ..secimYap(ilk.read(oyunProvider)!.bekleyenKartlar.first, 0)
            ..kartiKapat();
        }
        ilk
            .read(oyunProvider.notifier)
            .turuBitir(TurGirdisi(zaman: ilk.read(zamanProvider)));
      }
      await ilk.read(kayitDeposuProvider).bekle();
      final beklenen = ilk.read(oyunProvider)!.durum;

      // İkinci "açılış": kayıt görünmeli ve birebir dönmeli.
      final ikinci = await kapAc(dizin);
      expect(await ikinci.read(kayitVarMiProvider.future), isTrue);
      expect(await ikinci.read(oyunProvider.notifier).kayittanYukle(), isTrue);
      expect(ikinci.read(oyunProvider)!.durum, beklenen);
    });

    test('kayıttan dönen oyuncu AYNI kartları görüyor', () async {
      // Deste kayda girmiyor; `desteCek` saf olduğu için durumdan
      // yeniden türetiliyor. Bu tutmazsa oyuncu kaydı yükleyerek
      // beğenmediği kartı değiştirebilirdi.
      final dizin = Directory.systemTemp.createTempSync('hk_deste_');
      addTearDown(() {
        if (dizin.existsSync()) dizin.deleteSync(recursive: true);
      });

      final ilk = await kapAc(dizin);
      ilk.read(oyunProvider.notifier).yeniOyun(
            ad: 'T',
            cinsiyet: Cinsiyet.erkek,
            sehir: Sehir.konya,
            egitim: EgitimSeviyesi.lisans,
            tohum: 31337,
          );
      // Kart çıkan bir tura gelene kadar oyna.
      for (var i = 0; i < 40 && !ilk.read(oyunProvider)!.kararBekliyor; i++) {
        ilk
            .read(oyunProvider.notifier)
            .turuBitir(TurGirdisi(zaman: ilk.read(zamanProvider)));
      }
      final kartlar =
          ilk.read(oyunProvider)!.bekleyenKartlar.map((k) => k.id).toList();
      expect(kartlar, isNotEmpty);
      await ilk.read(kayitDeposuProvider).bekle();

      final ikinci = await kapAc(dizin);
      await ikinci.read(oyunProvider.notifier).kayittanYukle();
      expect(
        ikinci.read(oyunProvider)!.bekleyenKartlar.map((k) => k.id),
        kartlar,
      );
    });

    test('yeni hayat kaydı siliyor', () async {
      final dizin = Directory.systemTemp.createTempSync('hk_sil_');
      addTearDown(() {
        if (dizin.existsSync()) dizin.deleteSync(recursive: true);
      });

      final kap = await kapAc(dizin);
      kap.read(oyunProvider.notifier).yeniOyun(
            ad: 'T',
            cinsiyet: Cinsiyet.erkek,
            sehir: Sehir.konya,
            egitim: EgitimSeviyesi.lisans,
            tohum: 5,
          );
      await kap.read(kayitDeposuProvider).bekle();
      expect(await kap.read(kayitDeposuProvider).kayitVarMi(), isTrue);

      kap.read(oyunProvider.notifier).oyunuBitir();
      await kap.read(kayitDeposuProvider).bekle();
      expect(await kap.read(kayitDeposuProvider).kayitVarMi(), isFalse);
      expect(kap.read(oyunProvider), isNull);
    });

    test('bozuk kayıt yüklenemiyor ama çökertmiyor', () async {
      final dizin = Directory.systemTemp.createTempSync('hk_bozuk_');
      addTearDown(() {
        if (dizin.existsSync()) dizin.deleteSync(recursive: true);
      });
      File('${dizin.path}/${KayitDeposu.dosyaAdi}')
          .writeAsStringSync('bozuk');

      final kap = await kapAc(dizin);
      expect(await kap.read(oyunProvider.notifier).kayittanYukle(), isFalse);
      expect(kap.read(oyunProvider), isNull);
    });
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
