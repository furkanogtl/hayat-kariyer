// Kart kâğıdının görsel önizlemesi — emülatör açmadan kompozisyon
// kontrolü için. Gerçek widget'lar ve gerçek tema kullanılıyor.
//
//   flutter test tool/kart_onizleme_test.dart --update-goldens
//
// `tool/` altında çünkü altın dosya karşılaştırması DEĞİL, bir önizleme:
// her `flutter test` koşuşunda çalışıp kırılmasını istemiyoruz.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/models/olay.dart';
import 'package:hayat_kariyer/shared/animasyon/haberci.dart';
import 'package:hayat_kariyer/shared/animasyon/haberci_sahnesi.dart';
import 'package:hayat_kariyer/shared/tema.dart';
import 'package:hayat_kariyer/shared/widgets/zemin.dart';

void main() {
  Widget kart(OlayTuru tur, String baslik, String metin, List<String> secenekler,
      {required bool karanlik}) {
    final tema = Tema.oyun();
    return MaterialApp(
      theme: tema,
      home: Scaffold(
        body: ZeminGradyani(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                HaberciSahnesi(
                  tip: HaberciTipi.olayTurunden(tur),
                  onTamamlandi: () {},
                ),
                const SizedBox(height: 16),
                Builder(builder: (context) {
                  final t = Theme.of(context);
                  final renk = switch (tur) {
                    OlayTuru.firsat => t.oyun.kazanc,
                    OlayTuru.kriz => t.oyun.kayip,
                    OlayTuru.teklif => t.colorScheme.primary,
                    OlayTuru.hayat => t.oyun.notr,
                  };
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: renk.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tur.name.toUpperCase(),
                        style: t.textTheme.labelSmall
                            ?.copyWith(color: renk, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                Builder(builder: (context) {
                  final t = Theme.of(context);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(baslik,
                          style: t.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(metin, style: t.textTheme.bodyMedium),
                      const SizedBox(height: 20),
                      for (final s in secenekler)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(s),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('kart önizleme', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 1500)
      ..devicePixelRatio = 2.4;
    addTearDown(tester.view.reset);

    for (final (ad, karanlik) in [('acik', false), ('koyu', true)]) {
      await tester.pumpWidget(kart(
        OlayTuru.firsat,
        'Arsaya ortaklık çağrısı',
        'Tanıdığın müteahhit şehir dışında bir parsele ortak arıyor. '
            'İmar söylentisi var.',
        ['Ortak ol', 'Uzak dur'],
        karanlik: karanlik,
      ));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('../scratch/kart_$ad.png'),
      );
    }
  });
}
