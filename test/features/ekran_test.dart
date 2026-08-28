import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/sektor.dart';
import 'package:hayat_kariyer/features/banka/kredi_kagidi.dart';
import 'dart:io';

import 'package:hayat_kariyer/data/isletme_yukleyici.dart';
import 'package:hayat_kariyer/data/kayit_deposu.dart';
import 'package:hayat_kariyer/data/meslek_yukleyici.dart';
import 'package:hayat_kariyer/data/olay_yukleyici.dart';
import 'package:hayat_kariyer/features/kabuk/uygulama.dart';
import 'package:hayat_kariyer/features/olay/olay_karti_sayfasi.dart';
import 'package:hayat_kariyer/features/ozet/tur_raporu_kagidi.dart';
import 'package:hayat_kariyer/features/piyasa/fiyat_grafigi.dart';
import 'package:hayat_kariyer/features/skor/skor_ekrani.dart';
import 'package:hayat_kariyer/features/piyasa/varlik_detay_kagidi.dart';
import 'package:hayat_kariyer/features/oyun/oyun_saglayicilar.dart';

/// Ekranların uçtan uca dumanı: açılıştan turu bitirmeye kadar.
///
/// Metinler ARB'den geldiği için burada Türkçe dizge aranmıyor; aranan şey
/// widget'ların var olması. Böylece metin değişince test kırılmıyor ama
/// akış bozulunca kırılıyor.
void main() {
  late Kataloglar kataloglar;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    kataloglar = Kataloglar(
      meslekler: await MeslekYukleyici().yukle(),
      olaylar: await OlayYukleyici().yukle(),
      isletmeler: await IsletmeYukleyici().yukle(),
    );
  });

  /// Uygulamayı katalogları yüklenmiş halde açar.
  ///
  /// Asset okuması widget testinin sahte zaman düzleminde çözülmüyor;
  /// katalog gerçek async ile bir kez yüklenip sağlayıcıya veriliyor.
  /// Testin konusu zaten yükleme değil, ekranlar.
  Future<void> ac(WidgetTester tester, {bool kayitVar = false}) async {
    // Varsayılan 800x600 tuvalde liste dışında kalan widget'lar hiç
    // KURULMUYOR ve `find` onları bulamıyor. Duman testinin ekranın
    // tamamını görmesi için tuval büyütülüyor.
    tester.view.physicalSize = const Size(1000, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final dizin = Directory.systemTemp.createTempSync('hk_ekran_');
    addTearDown(() {
      if (dizin.existsSync()) dizin.deleteSync(recursive: true);
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          kataloglarProvider.overrideWith((ref) async => kataloglar),
          // Otomatik kayıt geçici dizine gitsin; platform eklentisi yok.
          kayitDeposuProvider.overrideWithValue(KayitDeposu(dizin: dizin)),
          // "Kayıt var mı" diski okuyor; widget testinin sahte zaman
          // düzleminde gerçek İ/O çözülmediği için değer doğrudan
          // veriliyor. Yüklemenin KENDİSİ sağlayıcı testinde sınanıyor.
          kayitVarMiProvider.overrideWith((ref) async => kayitVar),
        ],
        child: const HayatKariyerUygulamasi(),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Yeni oyun ekranındaki "Hayata Başla".
  ///
  /// Oyun KART BEKLEYEREK başlayabilir (deste turn 0 durumundan çekiliyor).
  /// O durumda "Turu Bitir" kapalı olur; testlerin çoğu turu bitirmek
  /// istediği için açılıştaki kartlar burada cevaplanıyor.
  Future<void> oyunaBasla(WidgetTester tester) async {
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    final kap = ProviderScope.containerOf(
      tester.element(find.byType(NavigationBar)),
    );
    final notifier = kap.read(oyunProvider.notifier);
    while (kap.read(oyunProvider)!.kararBekliyor) {
      notifier
        ..secimYap(kap.read(oyunProvider)!.bekleyenKartlar.first, 0)
        ..kartiKapat();
    }
    await tester.pumpAndSettle();
  }

  testWidgets('açılışta yeni oyun ekranı gelir', (tester) async {
    await ac(tester);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testWidgets('oyun başlatılınca kabuk açılır', (tester) async {
    await ac(tester);
    await oyunaBasla(tester);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('turu bitir raporu açar ve kapanır', (tester) async {
    await ac(tester);
    await oyunaBasla(tester);

    // Özet ekranındaki tek dolgulu düğme "Turu Bitir".
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.byKey(turRaporuAnahtari), findsOneWidget);

    // Rapordaki "Devam" kâğıdı kapatır. Rapordan sonra olay kartı
    // açılabildiği için "hiç kâğıt kalmadı" diye bakılmıyor; tohum
    // rastgele olduğundan o kontrol kararsız olurdu.
    await tester.tap(find.descendant(
      of: find.byKey(turRaporuAnahtari),
      matching: find.byType(FilledButton),
    ));
    await tester.pumpAndSettle();
    expect(find.byKey(turRaporuAnahtari), findsNothing);
  });

  testWidgets('bütün sekmeler hatasız açılıyor', (tester) async {
    await ac(tester);
    await oyunaBasla(tester);

    final kabuk = tester.widget<NavigationBar>(find.byType(NavigationBar));
    for (var i = 0; i < kabuk.destinations.length; i++) {
      await tester.tap(find.byType(NavigationDestination).at(i));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('kariyer ekranından işe girilir', (tester) async {
    await ac(tester);
    await oyunaBasla(tester);
    await tester.tap(find.byType(NavigationDestination).at(3));
    await tester.pumpAndSettle();

    // İlk açık pozisyonun "Bu işe gir" düğmesi.
    await tester.tap(find.byType(TextButton).first);
    await tester.pumpAndSettle();

    final kap = ProviderScope.containerOf(
      tester.element(find.byType(NavigationBar)),
    );
    expect(kap.read(taleplerProvider).iseGirTalebi, isNotNull);
    // Talep beklerken zaman varsayılanı çalışmaya dönmüş olmalı; yoksa
    // oyuncu işe girdiği ay kovulur.
    expect(kap.read(zamanProvider).calisma, greaterThan(0));
  });

  /// Kart çıkana kadar turu bitirir. Kart çıkma ihtimali %25.
  Future<void> kartaKadarOyna(WidgetTester tester) async {
    final kap = ProviderScope.containerOf(
      tester.element(find.byType(NavigationBar)),
    );
    for (var i = 0; i < 60 && !kap.read(oyunProvider)!.kararBekliyor; i++) {
      kap
          .read(oyunProvider.notifier)
          .turuBitir(TurGirdisi(zaman: kap.read(zamanProvider)));
    }
    kap.read(oyunProvider.notifier).raporlariTemizle();
    await tester.pumpAndSettle();
    expect(kap.read(oyunProvider)!.kararBekliyor, isTrue);
  }

  testWidgets('kart beklerken turu bitir kapalı', (tester) async {
    // Çekirdek döngüde kart turun bitmesinden ÖNCE gelir; oyuncu kartı
    // görmezden gelip ilerleyememeli, yoksa içerik boşa gider.
    await ac(tester);
    await oyunaBasla(tester);
    await kartaKadarOyna(tester);

    final turuBitir = tester.widget<FilledButton>(
      find.byType(FilledButton).first,
    );
    expect(turuBitir.onPressed, isNull);
    final atlamalar = tester
        .widgetList<OutlinedButton>(find.byType(OutlinedButton))
        .where((d) => d.onPressed == null);
    expect(atlamalar, hasLength(2));
  });

  testWidgets('kart cevaplanınca tur açılır', (tester) async {
    await ac(tester);
    await oyunaBasla(tester);
    await kartaKadarOyna(tester);

    final kap = ProviderScope.containerOf(
      tester.element(find.byType(NavigationBar)),
    );
    // Uyarı kartındaki "Kararı ver" kâğıdı açar.
    await tester.tap(find.byType(TextButton).first);
    await tester.pumpAndSettle();
    expect(find.byKey(olayKartiAnahtari), findsOneWidget);

    // Bütün kartları ilk seçenekle cevapla.
    while (kap.read(oyunProvider)!.kararBekliyor) {
      // Seçenekler anahtarla bulunuyor: Material düğmesi olmaktan çıkıp
      // elle kurulmuş satıra dönüştüler, tip araması boşa düşüyordu.
      // Sonuç ekranındaki "Devam" hâlâ FilledButton.
      await tester.tap(find.descendant(
        of: find.byKey(olayKartiAnahtari),
        matching: find.byKey(olaySecenekAnahtari(0)),
      ).first);
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(
        of: find.byKey(olayKartiAnahtari),
        matching: find.byType(FilledButton),
      ));
      await tester.pumpAndSettle();
    }
    // Kâğıt kendiliğinden kapanır ve tur yeniden bitirilebilir olur.
    expect(find.byKey(olayKartiAnahtari), findsNothing);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton).first).onPressed,
      isNotNull,
    );
  });

  testWidgets('piyasa ekranından emir verilebiliyor', (tester) async {
    await ac(tester);
    await oyunaBasla(tester);
    final kap = ProviderScope.containerOf(
      tester.element(find.byType(NavigationBar)),
    );
    // Oyuncu 18 yaşında beş parasız başlıyor; alım için nakit gerekiyor.
    kap.read(oyunProvider.notifier).durumaGec(
          kap.read(oyunProvider)!.durum.copyWith(
                oyuncu: kap
                    .read(oyunProvider)!
                    .durum
                    .oyuncu
                    .copyWith(nakit: 5000000),
              ),
        );
    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();

    // İlk varlık satırına dokun: detay kâğıdı açılır.
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    expect(find.byKey(varlikDetayAnahtari), findsOneWidget);

    // "Tümü" adet kutusunu doldurur, ardından "Al" emri sıraya alır.
    await tester.tap(find.descendant(
      of: find.byKey(varlikDetayAnahtari),
      matching: find.byType(OutlinedButton),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
      of: find.byKey(varlikDetayAnahtari),
      matching: find.byType(FilledButton),
    ));
    await tester.pumpAndSettle();

    expect(find.byKey(varlikDetayAnahtari), findsNothing);
    expect(kap.read(taleplerProvider).emirler, hasLength(1));
  });

  testWidgets('grafik çiziliyor', (tester) async {
    await ac(tester);
    await oyunaBasla(tester);
    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();
    // Yeni oyunda seri tek noktalı: mini grafik çizilmez ama ekran patlamaz.
    expect(tester.takeException(), isNull);

    final kap = ProviderScope.containerOf(
      tester.element(find.byType(NavigationBar)),
    );
    for (var i = 0; i < 4; i++) {
      while (kap.read(oyunProvider)!.kararBekliyor) {
        kap.read(oyunProvider.notifier)
          ..secimYap(kap.read(oyunProvider)!.bekleyenKartlar.first, 0)
          ..kartiKapat();
      }
      kap
          .read(oyunProvider.notifier)
          .turuBitir(TurGirdisi(zaman: kap.read(zamanProvider)));
    }
    await tester.pumpAndSettle();
    expect(find.byType(MiniGrafik), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('işletme sekmesinden işletme açılabiliyor', (tester) async {
    await ac(tester);
    await oyunaBasla(tester);
    final kap = ProviderScope.containerOf(
      tester.element(find.byType(NavigationBar)),
    );
    // Kuruluş bedeli için sermaye ve giriş şartları gerekiyor.
    final durum = kap.read(oyunProvider)!.durum;
    kap.read(oyunProvider.notifier).durumaGec(
          durum.copyWith(
            oyuncu: durum.oyuncu.copyWith(
              nakit: 20000000,
              itibar: 70,
              baslangicYasi: 30,
              yetkinlikler: {for (final s in Sektor.values) s: 80},
            ),
          ),
        );
    await tester.tap(find.byType(NavigationDestination).at(4));
    await tester.pumpAndSettle();

    // İlk açılabilir işletmenin "İşletme aç" düğmesi.
    await tester.tap(find.byType(FilledButton).first);
    await tester.pumpAndSettle();
    expect(kap.read(taleplerProvider).isletmeKomutu, isA<IsletmeAc>());

    // Özete dön: bekleyen komut atlamayı kapatmalı.
    await tester.tap(find.byType(NavigationDestination).at(0));
    await tester.pumpAndSettle();
    final atlamalar = tester
        .widgetList<OutlinedButton>(find.byType(OutlinedButton))
        .where((d) => d.onPressed == null);
    expect(atlamalar, hasLength(2));
  });

  testWidgets('banka ekranından kredi çekilebiliyor', (tester) async {
    await ac(tester);
    await oyunaBasla(tester);
    final kap = ProviderScope.containerOf(
      tester.element(find.byType(NavigationBar)),
    );
    // Stajyerin bordrosu düşük; teklif çıkması için çalışan bir kariyer.
    final durum = kap.read(oyunProvider)!.durum;
    kap.read(oyunProvider.notifier).durumaGec(
          durum.copyWith(
            oyuncu: durum.oyuncu.copyWith(
              baslangicYasi: 30,
              kariyer: const KariyerDurumu.calisan(
                meslekId: 'yazilim_gelistirici',
                kademeIndeksi: 2,
              ),
            ),
          ),
        );
    await tester.tap(find.byType(NavigationDestination).at(2));
    await tester.pumpAndSettle();

    // İlk teklif kartına dokun: kredi kâğıdı açılır.
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    expect(find.byKey(krediKagidiAnahtari), findsOneWidget);

    await tester.tap(find.descendant(
      of: find.byKey(krediKagidiAnahtari),
      matching: find.byType(FilledButton),
    ));
    await tester.pumpAndSettle();

    expect(find.byKey(krediKagidiAnahtari), findsNothing);
    expect(kap.read(taleplerProvider).krediTalebi, isNotNull);
  });

  testWidgets('oyun bitince skor ekranı geliyor', (tester) async {
    await ac(tester);
    await oyunaBasla(tester);
    final kap = ProviderScope.containerOf(
      tester.element(find.byType(NavigationBar)),
    );
    // Yaş sınırına gelmiş bir duruma geç: kabuk yerine skor açılmalı.
    final durum = kap.read(oyunProvider)!.durum;
    kap.read(oyunProvider.notifier).durumaGec(
          durum.copyWith(
            oyunBitti: true,
            zirveNetDeger: 50000000,
            oyuncu: durum.oyuncu.copyWith(baslangicYasi: 65),
          ),
        );
    await tester.pumpAndSettle();

    expect(find.byType(SkorEkrani), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    // "Yeni hayat" başlangıç ekranına döndürür.
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('kayıt yokken devam kartı görünmüyor', (tester) async {
    await ac(tester);
    // Yalnız "Hayata Başla".
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testWidgets('kayıt varken devam kartı geliyor', (tester) async {
    await ac(tester, kayitVar: true);
    // Devam kartı + "Hayata Başla".
    expect(find.byType(FilledButton), findsNWidgets(2));
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('bekleyen talep varken atlama kapalı', (tester) async {
    await ac(tester);
    await oyunaBasla(tester);
    await tester.tap(find.byType(NavigationDestination).at(3));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextButton).first);
    await tester.pumpAndSettle();

    // Özete dön: "3 ay atla" ve "1 yıl atla" pasif olmalı.
    await tester.tap(find.byType(NavigationDestination).at(0));
    await tester.pumpAndSettle();
    final atlamalar = tester
        .widgetList<OutlinedButton>(find.byType(OutlinedButton))
        .where((d) => d.onPressed == null);
    expect(atlamalar, hasLength(2));
  });
}
