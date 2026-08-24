import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/data/isletme_yukleyici.dart';
import 'package:hayat_kariyer/data/meslek_yukleyici.dart';
import 'package:hayat_kariyer/data/olay_yukleyici.dart';
import 'package:hayat_kariyer/features/kabuk/uygulama.dart';
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
  Future<void> ac(WidgetTester tester) async {
    // Varsayılan 800x600 tuvalde liste dışında kalan widget'lar hiç
    // KURULMUYOR ve `find` onları bulamıyor. Duman testinin ekranın
    // tamamını görmesi için tuval büyütülüyor.
    tester.view.physicalSize = const Size(1000, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          kataloglarProvider.overrideWith((ref) async => kataloglar),
        ],
        child: const HayatKariyerUygulamasi(),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Yeni oyun ekranındaki "Hayata Başla".
  Future<void> oyunaBasla(WidgetTester tester) async {
    await tester.tap(find.byType(FilledButton));
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
    expect(find.byType(BottomSheet), findsOneWidget);

    // Rapordaki "Devam" kâğıdı kapatır.
    await tester.tap(find.descendant(
      of: find.byType(BottomSheet),
      matching: find.byType(FilledButton),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
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
    await tester.tap(find.byType(NavigationDestination).at(2));
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

  testWidgets('bekleyen talep varken atlama kapalı', (tester) async {
    await ac(tester);
    await oyunaBasla(tester);
    await tester.tap(find.byType(NavigationDestination).at(2));
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
