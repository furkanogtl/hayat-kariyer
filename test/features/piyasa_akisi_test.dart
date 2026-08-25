import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/portfoy_motoru.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/portfoy.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/data/kayit_deposu.dart';
import 'package:hayat_kariyer/features/oyun/oyun_saglayicilar.dart';

/// Emir kuyruğunun motora bağlanışı.
///
/// Emirler `iseGirTalebi` ile aynı şablonda: taleptir, turu bitirene kadar
/// uygulanmaz, tek `TurGirdisi` kapısından geçer.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Kademe 2: stajyer maaşı yaşam giderini karşılamıyor ve uzun
  // senaryolarda oyuncu eksiye düşüp hacizlik oluyor.
  Future<ProviderContainer> kur({int nakit = 5000000}) async {
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
    await kap.read(kataloglarProvider.future);
    kap.read(oyunProvider.notifier).yeniOyun(
          ad: 'Test',
          cinsiyet: Cinsiyet.erkek,
          sehir: Sehir.konya,
          egitim: EgitimSeviyesi.lisans,
          tohum: 2026,
        );
    final oturum = kap.read(oyunProvider)!;
    kap.read(oyunProvider.notifier).durumaGec(
          oturum.durum.copyWith(
            oyuncu: oturum.durum.oyuncu.copyWith(
              nakit: nakit,
              baslangicYasi: 25,
              kariyer: const KariyerDurumu.calisan(
                meslekId: 'yazilim_gelistirici',
                kademeIndeksi: 2,
              ),
            ),
          ),
        );
    return kap;
  }

  /// Bekleyen kartları temizler; kart varken ekran turu bitirtmiyor.
  void kartlariGec(ProviderContainer kap) {
    final n = kap.read(oyunProvider.notifier);
    while (kap.read(oyunProvider)!.kararBekliyor) {
      n
        ..secimYap(kap.read(oyunProvider)!.bekleyenKartlar.first, 0)
        ..kartiKapat();
    }
  }

  void turuBitir(ProviderContainer kap) {
    kartlariGec(kap);
    final talepler = kap.read(taleplerProvider);
    kap.read(oyunProvider.notifier).turuBitir(
          TurGirdisi(
            zaman: kap.read(zamanProvider),
            iseGirTalebi: talepler.iseGirTalebi,
            emirler: talepler.emirler,
          ),
        );
    kap.read(taleplerProvider.notifier).temizle();
  }

  test('emir sıraya girer, tur bitene kadar uygulanmaz', () async {
    final kap = await kur();
    kap.read(taleplerProvider.notifier).emirEkle(const Alim('altin', 100));
    expect(kap.read(taleplerProvider).emirler, hasLength(1));
    expect(kap.read(oyunProvider)!.durum.portfoy.bosMu, isTrue);

    turuBitir(kap);
    expect(kap.read(oyunProvider)!.durum.portfoy.adet('altin'), 100);
    expect(kap.read(taleplerProvider).emirler, isEmpty);
  });

  test('emir varken atlama kapalı', () async {
    // Aynı emir 12 kez işlenmemeli; ekran atlama düğmelerini bu bayrakla
    // kapatıyor.
    final kap = await kur();
    expect(kap.read(taleplerProvider).bosMu, isTrue);
    kap.read(taleplerProvider.notifier).emirEkle(const Alim('altin', 1));
    expect(kap.read(taleplerProvider).bosMu, isFalse);
  });

  test('emir silinebiliyor, sınır dışı indeks yok sayılıyor', () async {
    final kap = await kur();
    final n = kap.read(taleplerProvider.notifier)
      ..emirEkle(const Alim('altin', 1))
      ..emirEkle(const Alim('doviz', 10))
      ..emirSil(5)
      ..emirSil(0);
    expect(kap.read(taleplerProvider).emirler, hasLength(1));
    expect(kap.read(taleplerProvider).emirler.single.varlikId, 'doviz');
    n.emirleriTemizle();
    expect(kap.read(taleplerProvider).emirler, isEmpty);
  });

  test('işe giriş ve emir aynı turda birlikte gider', () async {
    // İkisi de aynı `TurGirdisi` kapısından geçiyor; biri diğerini
    // düşürmemeli.
    final kap = await kur();
    // Kamu mesleği atama kuyruğuna girer ve o turda Calisan olmaz;
    // sınanan şey işe girişin emirle birlikte gitmesi.
    final meslek = kap
        .read(kataloglarProvider)
        .requireValue
        .meslekler
        .girilebilirler(kap.read(oyunProvider)!.durum.oyuncu)
        .firstWhere((m) => !m.atamaGerektirir);
    kap.read(taleplerProvider.notifier)
      ..iseGir(meslek.id)
      ..emirEkle(const Alim('altin', 10));
    turuBitir(kap);

    final durum = kap.read(oyunProvider)!.durum;
    expect(durum.oyuncu.kariyer.meslekId, meslek.id);
    expect(durum.portfoy.adet('altin'), 10);
  });

  test('oyuncu GÖRDÜĞÜ fiyattan alıyor', () async {
    // Emirler piyasa hareket etmeden önce işleniyor. Tersi olsaydı
    // "aldığım fiyat bu değildi" hissi oluşurdu.
    final kap = await kur();
    final gorulenFiyat = kap.read(oyunProvider)!.durum.piyasa.fiyat('altin');
    kap.read(taleplerProvider.notifier).emirEkle(const Alim('altin', 10));
    turuBitir(kap);

    final pozisyon =
        kap.read(oyunProvider)!.durum.portfoy.pozisyonlar['altin']!;
    // Ortalama maliyet komisyon dahil: görülen fiyat + %1.
    expect(pozisyon.ortalamaMaliyet, closeTo(gorulenFiyat * 1.01, 1));
  });

  test('gecikmeli satış kuyruğa giriyor', () async {
    final kap = await kur(nakit: 20000000);
    kap.read(taleplerProvider.notifier).emirEkle(const Alim('gayrimenkul', 1));
    turuBitir(kap);
    expect(kap.read(oyunProvider)!.durum.portfoy.adet('gayrimenkul'), 1);

    kap.read(taleplerProvider.notifier).emirEkle(const Satim('gayrimenkul', 1));
    turuBitir(kap);
    final portfoy = kap.read(oyunProvider)!.durum.portfoy;
    // Daire hâlâ elde ama satışta: ikinci kez satılamaz.
    expect(portfoy.adet('gayrimenkul'), 1);
    expect(portfoy.satilabilirAdet('gayrimenkul'), 0);
    expect(portfoy.bekleyenSatislar, hasLength(1));
  });

  test('reel kâr/zarar enflasyon yalanını açığa çıkarıyor', () async {
    // Nominal K/Z gösterilseydi 15 yıl tutulan mevduat ekranda büyük bir
    // "kâr" olarak görünürdü; oysa reel olarak kaybettiriyor. Oyunun
    // "nakit tutmak cezalandırılır" kuralı ekranda da görünmeli.
    final kap = await kur(nakit: 5000000);
    kap.read(taleplerProvider.notifier).emirEkle(const Alim('mevduat', 40000));
    turuBitir(kap);
    for (var i = 0; i < 180; i++) {
      turuBitir(kap);
    }

    final durum = kap.read(oyunProvider)!.durum;
    final pozisyon = durum.portfoy.pozisyonlar['mevduat']!;
    final fiyat = durum.piyasa.fiyat('mevduat');
    final endeks = durum.piyasa.enflasyonEndeksi;

    expect(pozisyon.karZarar(fiyat), greaterThan(0), reason: 'nominal kâr');
    expect(
      pozisyon.reelKarZarar(fiyat, endeks),
      lessThan(0),
      reason: 'reel zarar',
    );
  });

  test('pozisyon endeksi tutarla ağırlıklanıyor', () async {
    // Küçük eski alım ile büyük yeni alım ortalamaya eşit katkı yapmamalı.
    final kap = await kur(nakit: 50000000);
    kap.read(taleplerProvider.notifier).emirEkle(const Alim('altin', 1));
    turuBitir(kap);
    final ilkEndeks =
        kap.read(oyunProvider)!.durum.portfoy.pozisyonlar['altin']!
            .ortalamaEndeks;

    for (var i = 0; i < 36; i++) {
      turuBitir(kap);
    }
    final aradakiEndeks = kap.read(oyunProvider)!.durum.piyasa.enflasyonEndeksi;
    kap.read(taleplerProvider.notifier).emirEkle(const Alim('altin', 200));
    turuBitir(kap);

    final endeks =
        kap.read(oyunProvider)!.durum.portfoy.pozisyonlar['altin']!
            .ortalamaEndeks;
    // Büyük alım baskın: ortalama ilk alımın endeksinden çok, ikincisine
    // yakın olmalı.
    expect(endeks, greaterThan(ilkEndeks));
    expect(endeks, greaterThan(aradakiEndeks * 0.8));
  });

  test('eski kayıt endekssiz okunuyor', () async {
    // Alanı olmayan kayıt oyun başı seviyesinden alınmış sayılır; okuma
    // patlamamalı.
    final pozisyon = Pozisyon.fromJson(const {
      'adet': 10.0,
      'ortalamaMaliyet': 5000.0,
    });
    expect(pozisyon.ortalamaEndeks, 1.0);
  });

  test('fiyat serisi turlar ilerledikçe büyüyor', () async {
    // Grafik kayıttan geliyor; ekranın ayrıca geçmiş tutmasına gerek yok.
    final kap = await kur();
    final ilk = kap.read(oyunProvider)!.durum.piyasa.seri('altin').length;
    for (var i = 0; i < 5; i++) {
      turuBitir(kap);
    }
    expect(
      kap.read(oyunProvider)!.durum.piyasa.seri('altin').length,
      ilk + 5,
    );
  });
}
