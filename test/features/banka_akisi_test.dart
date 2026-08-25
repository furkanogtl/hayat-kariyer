import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/portfoy_motoru.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/core/models/borc.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/sektor.dart';
import 'package:hayat_kariyer/data/kayit_deposu.dart';
import 'package:hayat_kariyer/features/oyun/oyun_saglayicilar.dart';

/// Kredi ekranının motora bağlanışı.
///
/// Buradaki asıl sözleşme: ekranın gösterdiği teklif ile bankanın kabul
/// ettiği teklif AYNI OLMALI. Ayrışırsa oyuncu gördüğü tutarı isteyip
/// reddedilir ve bunu bir hata sanır.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> kur({
    int krediNotu = Oyuncu.krediNotuBaslangic,
  }) async {
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
    final n = kap.read(oyunProvider.notifier)
      ..yeniOyun(
        ad: 'Test',
        cinsiyet: Cinsiyet.erkek,
        sehir: Sehir.konya,
        egitim: EgitimSeviyesi.lisans,
        tohum: 555,
      );
    final durum = kap.read(oyunProvider)!.durum;
    n.durumaGec(
      durum.copyWith(
        oyuncu: durum.oyuncu.copyWith(
          krediNotu: krediNotu,
          baslangicYasi: 30,
          kariyer: const KariyerDurumu.calisan(
            meslekId: 'yazilim_gelistirici',
            kademeIndeksi: 2,
          ),
          yetkinlikler: {for (final s in Sektor.values) s: 70},
        ),
      ),
    );
    return kap;
  }

  void turuBitir(ProviderContainer kap) {
    final n = kap.read(oyunProvider.notifier);
    while (kap.read(oyunProvider)!.kararBekliyor) {
      n
        ..secimYap(kap.read(oyunProvider)!.bekleyenKartlar.first, 0)
        ..kartiKapat();
    }
    final t = kap.read(taleplerProvider);
    n.turuBitir(
      TurGirdisi(
        zaman: kap.read(zamanProvider),
        iseGirTalebi: t.iseGirTalebi,
        emirler: t.emirler,
        isletmeKomutu: t.isletmeKomutu,
        krediTalebi: t.krediTalebi,
      ),
    );
    kap.read(taleplerProvider.notifier).temizle();
  }

  test('ekranın gösterdiği azami tutar banka tarafından kabul ediliyor', () {
    // Bu testin kırılması "gördüğüm krediyi alamıyorum" hatası demek.
    return kur().then((kap) {
      final durum = kap.read(oyunProvider)!.durum;
      final teklifler = kap.read(turProcessorProvider).krediTeklifleri(durum);
      expect(teklifler, isNotEmpty);

      for (final teklif in teklifler) {
        kap.read(taleplerProvider.notifier).krediTalebi(
              KrediTalebi(tur: teklif.tur, anapara: teklif.enYuksekTutar),
            );
        final n = kap.read(oyunProvider.notifier);
        while (kap.read(oyunProvider)!.kararBekliyor) {
          n
            ..secimYap(kap.read(oyunProvider)!.bekleyenKartlar.first, 0)
            ..kartiKapat();
        }
        final sonuc = kap.read(turProcessorProvider).turuBitir(
              kap.read(oyunProvider)!.durum,
              TurGirdisi(
                zaman: kap.read(zamanProvider),
                krediTalebi: KrediTalebi(
                  tur: teklif.tur,
                  anapara: teklif.enYuksekTutar,
                ),
              ),
            );
        expect(
          sonuc.rapor.krediHatasi,
          isNull,
          reason: '${teklif.tur.id} azami tutarı reddedildi',
        );
        expect(sonuc.rapor.cekilenKredi, teklif.enYuksekTutar);
        kap.read(taleplerProvider.notifier).temizle();
      }
    });
  });

  test('kredi talebi tur bitene kadar uygulanmıyor', () async {
    final kap = await kur();
    final teklif =
        kap.read(turProcessorProvider).krediTeklifleri(
              kap.read(oyunProvider)!.durum,
            ).first;
    kap.read(taleplerProvider.notifier).krediTalebi(
          KrediTalebi(tur: teklif.tur, anapara: 100000),
        );
    expect(kap.read(oyunProvider)!.durum.borclar, isEmpty);
    expect(kap.read(taleplerProvider).bosMu, isFalse);

    turuBitir(kap);
    expect(kap.read(oyunProvider)!.durum.borclar, hasLength(1));
    expect(kap.read(taleplerProvider).krediTalebi, isNull);
  });

  test('kredi talebi geri alınabiliyor', () async {
    final kap = await kur();
    kap.read(taleplerProvider.notifier)
      ..krediTalebi(const KrediTalebi(tur: BorcTuru.ihtiyac, anapara: 50000))
      ..krediTalebi(null);
    expect(kap.read(taleplerProvider).krediTalebi, isNull);
    expect(kap.read(taleplerProvider).bosMu, isTrue);
  });

  test('kredi notu düşükse ekran teklif göstermiyor', () async {
    // Ölçek 300-1900; 0-100 sanılsaydı herkes tavan notlu görünürdü.
    final kap = await kur(krediNotu: Oyuncu.krediNotuTaban);
    expect(
      kap.read(turProcessorProvider).krediTeklifleri(
            kap.read(oyunProvider)!.durum,
          ),
      isEmpty,
    );
  });

  test('teklif limiti bordroya bağlı, şoklu gelire değil', () async {
    // Banka maaş belgesine bakar; aynı durumda teklif her tohumda aynı.
    Future<int> limit(int tohum) async {
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
      final n = kap.read(oyunProvider.notifier)
        ..yeniOyun(
          ad: 'T',
          cinsiyet: Cinsiyet.erkek,
          sehir: Sehir.konya,
          egitim: EgitimSeviyesi.lisans,
          tohum: tohum,
        );
      final d = kap.read(oyunProvider)!.durum;
      n.durumaGec(
        d.copyWith(
          oyuncu: d.oyuncu.copyWith(
            baslangicYasi: 30,
            kariyer: const KariyerDurumu.calisan(
              meslekId: 'yazilim_gelistirici',
              kademeIndeksi: 2,
            ),
          ),
        ),
      );
      return kap
          .read(turProcessorProvider)
          .krediTeklifleri(kap.read(oyunProvider)!.durum)
          .first
          .enYuksekTutar;
    }

    expect(await limit(1), await limit(9999));
  });

  test('gecikmede yeni kredi verilmiyor', () async {
    final kap = await kur();
    final durum = kap.read(oyunProvider)!.durum;
    kap.read(oyunProvider.notifier).durumaGec(
          durum.copyWith(
            borclar: [
              Borc(
                id: 'g1',
                tur: BorcTuru.ihtiyac,
                anapara: 100000,
                kalanAnapara: 100000,
                aylikTaksit: 5000,
                aylikFaiz: 0.03,
                kalanTaksit: 24,
                cekildigiTur: 0,
                gecikmeTuru: 2,
              ),
            ],
          ),
        );
    expect(
      kap.read(turProcessorProvider).krediTeklifleri(
            kap.read(oyunProvider)!.durum,
          ),
      isEmpty,
    );
  });

  test('çekilen kredi aynı turda yatırıma gidebiliyor', () async {
    // Motor krediyi emirlerden ÖNCE işliyor; ekranın bu sırayı bozmaması
    // gerekiyor.
    final kap = await kur();
    final teklif = kap
        .read(turProcessorProvider)
        .krediTeklifleri(kap.read(oyunProvider)!.durum)
        .first;
    kap.read(taleplerProvider.notifier)
      ..krediTalebi(KrediTalebi(tur: teklif.tur, anapara: 100000))
      ..emirEkle(const Alim('altin', 5));
    turuBitir(kap);

    expect(kap.read(oyunProvider)!.durum.borclar, hasLength(1));
    expect(kap.read(oyunProvider)!.durum.portfoy.adet('altin'), 5);
  });
}
