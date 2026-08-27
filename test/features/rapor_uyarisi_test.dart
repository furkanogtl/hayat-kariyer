import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/borc_motoru.dart';
import 'package:hayat_kariyer/core/engine/isletme_motoru.dart';
import 'package:hayat_kariyer/core/engine/rejim.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/features/ozet/tur_raporu_kagidi.dart';
import 'package:hayat_kariyer/l10n/uygulama_metinleri.dart';
import 'package:hayat_kariyer/shared/tema.dart';

/// Uygulanamayan komut oyuncuya SÖYLENİYOR mu.
///
/// `TurRaporu.krediHatasi` ve `isletmeHatasi` motorda baştan beri vardı ama
/// hiçbir ekran okumuyordu: oyuncunun kredisi ya da işletme işlemi sessizce
/// düşüyor, ekranda hiçbir iz kalmıyordu. Bu test o bağlantıyı tutuyor —
/// motor bir hata raporladıysa rapor kâğıdında görünmeli.
void main() {
  TurRaporu rapor({
    KrediHatasi? krediHatasi,
    IsletmeHatasi? isletmeHatasi,
  }) =>
      TurRaporu(
        tur: 12,
        yas: 19,
        ay: 1,
        netGelir: 50000,
        yasamGideri: 30000,
        faizGideri: 0,
        nakitDegisimi: 20000,
        rejim: Rejim.buyume,
        rejimDegisti: false,
        aylikEnflasyon: 0.02,
        maasZammiYapildi: false,
        paraReformuYapildi: false,
        performans: 1,
        kiraGeliri: 0,
        portfoyDegeri: 0,
        netDeger: 100000,
        krediHatasi: krediHatasi,
        isletmeHatasi: isletmeHatasi,
      );

  Future<void> goster(WidgetTester tester, TurRaporu r) async {
    tester.view.physicalSize = const Size(1000, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: Tema.oyun(),
        locale: const Locale('tr'),
        localizationsDelegates: UygulamaMetinleri.localizationsDelegates,
        supportedLocales: UygulamaMetinleri.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => turRaporunuGoster(context, [r]),
                child: const Text('ac'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('ac'));
    await tester.pumpAndSettle();
  }

  testWidgets('reddedilen kredi rapor kâğıdında görünüyor', (tester) async {
    await goster(tester, rapor(krediHatasi: KrediHatasi.limitAsildi));
    expect(find.byKey(turRaporuAnahtari), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });

  testWidgets('uygulanamayan işletme komutu görünüyor', (tester) async {
    await goster(tester, rapor(isletmeHatasi: IsletmeHatasi.yetersizNakit));
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });

  testWidgets('hata yokken uyarı satırı çıkmıyor', (tester) async {
    // Aksi halde test, uyarıyı hiç bağlamasan da geçerdi.
    await goster(tester, rapor());
    expect(find.byKey(turRaporuAnahtari), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsNothing);
  });
}
