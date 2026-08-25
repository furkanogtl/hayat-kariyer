import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/ilgi_dagilimi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/sektor.dart';
import 'package:hayat_kariyer/data/kayit_deposu.dart';
import 'package:hayat_kariyer/features/oyun/oyun_saglayicilar.dart';

/// İşletme komutlarının arayüz katmanındaki sözleşmesi.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> kur({int nakit = 20000000}) async {
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
        tohum: 1907,
      );
    final durum = kap.read(oyunProvider)!.durum;
    n.durumaGec(
      durum.copyWith(
        oyuncu: durum.oyuncu.copyWith(
          nakit: nakit,
          itibar: 70,
          baslangicYasi: 30,
          kariyer: const KariyerDurumu.calisan(
            meslekId: 'yazilim_gelistirici',
          ),
          yetkinlikler: {for (final s in Sektor.values) s: 80},
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
    final talepler = kap.read(taleplerProvider);
    n.turuBitir(
      TurGirdisi(
        zaman: kap.read(zamanProvider),
        iseGirTalebi: talepler.iseGirTalebi,
        emirler: talepler.emirler,
        isletmeKomutu: talepler.isletmeKomutu,
      ),
    );
    kap.read(taleplerProvider.notifier).temizle();
  }

  String acilabilirId(ProviderContainer kap) => kap
      .read(kataloglarProvider)
      .requireValue
      .isletmeler
      .acilabilirler(kap.read(oyunProvider)!.durum.oyuncu)
      .first
      .id;

  test('işletme komutu talep olarak kuyruğa giriyor', () async {
    final kap = await kur();
    kap.read(taleplerProvider.notifier).isletmeKomutu(
          IsletmeAc(acilabilirId(kap)),
        );
    // Talep tek başına hiçbir şey yapmaz.
    expect(kap.read(oyunProvider)!.durum.isletmeler, isEmpty);
    expect(kap.read(taleplerProvider).bosMu, isFalse);

    turuBitir(kap);
    expect(kap.read(oyunProvider)!.durum.isletmeler, hasLength(1));
    expect(kap.read(taleplerProvider).isletmeKomutu, isNull);
  });

  test('komut geri alınabiliyor', () async {
    final kap = await kur();
    final n = kap.read(taleplerProvider.notifier)
      ..isletmeKomutu(IsletmeAc(acilabilirId(kap)))
      ..isletmeKomutu(null);
    expect(kap.read(taleplerProvider).isletmeKomutu, isNull);
    expect(kap.read(taleplerProvider).bosMu, isTrue);
    n.temizle();
  });

  test('ilgi TALEP değil, doğrudan duruma yazılıyor', () async {
    // İlgi dağılımı kayda giren kalıcı bir ayar; zaman dağılımı gibi
    // tura özel taslak değil.
    final kap = await kur();
    kap.read(taleplerProvider.notifier).isletmeKomutu(
          IsletmeAc(acilabilirId(kap)),
        );
    turuBitir(kap);
    final id = kap.read(oyunProvider)!.durum.isletmeler.single.id;

    kap.read(oyunProvider.notifier).ilgiAyarla(id, 2);
    expect(kap.read(oyunProvider)!.durum.ilgi.puan(id), 2);
    // Tur bitince de yerinde kalmalı.
    turuBitir(kap);
    expect(kap.read(oyunProvider)!.durum.ilgi.puan(id), 2);
  });

  test('gerekenin üstündeki ilgi işe yaramıyor', () async {
    // Motor ilgi oranını 1,0'da kırpıyor; ekran da + düğmesini gerekende
    // kapatıyor. İkisi ayrışırsa oyuncu boşa puan harcar.
    final kap = await kur();
    kap.read(taleplerProvider.notifier).isletmeKomutu(
          IsletmeAc(acilabilirId(kap)),
        );
    turuBitir(kap);
    final isletme = kap.read(oyunProvider)!.durum.isletmeler.single;
    final gereken =
        kap.read(turProcessorProvider).isletme!.gerekenIlgi(isletme);

    final statId = kap
        .read(kataloglarProvider)
        .requireValue
        .isletmeler
        .bul(isletme.tanimId)!
        .statlar
        .first;

    int statIlerlet(int puan) {
      kap.read(oyunProvider.notifier).ilgiAyarla(isletme.id, puan);
      turuBitir(kap);
      return kap.read(oyunProvider)!.durum.isletmeler.single.stat(statId);
    }

    final tamIlgi = statIlerlet(gereken);
    final fazlaIlgi = statIlerlet(IlgiDagilimi.toplamPuan);
    // Fazla puan statı daha hızlı büyütmüyor.
    expect(fazlaIlgi - tamIlgi, lessThanOrEqualTo(4));
  });

  test('ilgi toplam puanı aşamıyor', () async {
    final kap = await kur();
    kap.read(taleplerProvider.notifier).isletmeKomutu(
          IsletmeAc(acilabilirId(kap)),
        );
    turuBitir(kap);
    final id = kap.read(oyunProvider)!.durum.isletmeler.single.id;

    kap.read(oyunProvider.notifier).ilgiAyarla(id, 99);
    expect(
      kap.read(oyunProvider)!.durum.ilgi.toplam,
      lessThanOrEqualTo(IlgiDagilimi.toplamPuan),
    );
  });

  test('tam ilgili işletme kâra geçiyor, ihmal edilen çöküyor', () async {
    // Ekranın gösterdiği sayıların gerçekten anlamlı olduğunun kanıtı.
    Future<int> oyna({required bool ilgiVer}) async {
      final kap = await kur();
      kap.read(taleplerProvider.notifier).isletmeKomutu(
            IsletmeAc(acilabilirId(kap)),
          );
      turuBitir(kap);
      final id = kap.read(oyunProvider)!.durum.isletmeler.single.id;
      if (ilgiVer) {
        kap.read(oyunProvider.notifier).ilgiAyarla(id, 6);
      }
      for (var i = 0; i < 36; i++) {
        turuBitir(kap);
      }
      final isletme = kap.read(oyunProvider)!.durum.isletmeler.single;
      return isletme.sonNetKar;
    }

    expect(await oyna(ilgiVer: true), greaterThan(0));
    expect(await oyna(ilgiVer: false), lessThan(0));
  });

  test('satılan işletmenin ilgi puanı serbest kalıyor', () async {
    final kap = await kur();
    kap.read(taleplerProvider.notifier).isletmeKomutu(
          IsletmeAc(acilabilirId(kap)),
        );
    turuBitir(kap);
    final id = kap.read(oyunProvider)!.durum.isletmeler.single.id;
    kap.read(oyunProvider.notifier).ilgiAyarla(id, 3);

    kap.read(taleplerProvider.notifier).isletmeKomutu(IsletmeSat(id));
    turuBitir(kap);
    for (var i = 0; i < 6 &&
        kap.read(oyunProvider)!.durum.isletmeler.isNotEmpty; i++) {
      turuBitir(kap);
    }
    expect(kap.read(oyunProvider)!.durum.isletmeler, isEmpty);
    expect(kap.read(oyunProvider)!.durum.ilgi.toplam, 0);
  });
}
