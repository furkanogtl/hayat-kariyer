import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/models/olay.dart';
import 'package:hayat_kariyer/shared/animasyon/haberci.dart';
import 'package:hayat_kariyer/shared/animasyon/haberci_sahnesi.dart';
import 'package:hayat_kariyer/shared/animasyon/sayi_akisi.dart';

/// Animasyon katmanının sözleşmesi.
///
/// Buradaki asıl risk şu: kart içeriği haberci animasyonu bitene kadar
/// KAPALI. Animasyon herhangi bir sebeple tamamlanmazsa oyuncu kartı
/// cevaplayamaz ve oyun kilitlenir. Bu yüzden "tamamlanma her koşulda
/// bildiriliyor mu" testle tutuluyor.
void main() {
  Widget sar(Widget cocuk, {bool hareketKapali = false}) => MediaQuery(
        data: MediaQueryData(disableAnimations: hareketKapali),
        child: MaterialApp(home: Scaffold(body: cocuk)),
      );

  group('haberci sahnesi', () {
    testWidgets('animasyon bitince teslim bildiriliyor', (tester) async {
      var tamamlandi = false;
      await tester.pumpWidget(sar(
        HaberciSahnesi(
          tip: HaberciTipi.isInsani,
          onTamamlandi: () => tamamlandi = true,
        ),
      ));
      expect(tamamlandi, isFalse, reason: 'daha ilk karede bitmemeli');
      await tester.pumpAndSettle();
      expect(tamamlandi, isTrue);
    });

    testWidgets('hareket kapalıyken beklemeden bildiriliyor', (tester) async {
      // Erişilebilirlik ayarı açıkken animasyon hiç oynamıyor; o dalda
      // tamamlanma bildirimi atlanırsa kart sonsuza kadar kapalı kalır.
      var tamamlandi = false;
      await tester.pumpWidget(sar(
        HaberciSahnesi(
          tip: HaberciTipi.memur,
          onTamamlandi: () => tamamlandi = true,
        ),
        hareketKapali: true,
      ));
      await tester.pump();
      await tester.pump();
      expect(tamamlandi, isTrue);
    });

    testWidgets('dokununca animasyon sona atlıyor', (tester) async {
      var tamamlandi = false;
      await tester.pumpWidget(sar(
        HaberciSahnesi(
          tip: HaberciTipi.komsu,
          onTamamlandi: () => tamamlandi = true,
        ),
      ));
      await tester.pump(const Duration(milliseconds: 50));
      expect(tamamlandi, isFalse);

      await tester.tap(find.byType(HaberciSahnesi));
      await tester.pump();
      expect(tamamlandi, isTrue, reason: 'dokunuş beklemeyi bitirmeli');
    });

    testWidgets('tamamlanma bir kez bildiriliyor', (tester) async {
      // Hem dokunuş hem doğal bitiş tetiklenirse iki kez çağrılır ve
      // üstteki setState gereksiz yere tekrarlanır.
      var sayi = 0;
      await tester.pumpWidget(sar(
        HaberciSahnesi(
          tip: HaberciTipi.temsilci,
          onTamamlandi: () => sayi++,
        ),
      ));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byType(HaberciSahnesi));
      await tester.pumpAndSettle();
      expect(sayi, 1);
    });
  });

  group('haberci tipi', () {
    test('her kart türünün bir habercisi var', () {
      // Switch derleyici tarafından zorlanıyor; bu test yeni bir kart
      // türü eklenirse eşlemenin unutulmadığını da belgeliyor.
      for (final tur in OlayTuru.values) {
        expect(HaberciTipi.olayTurunden(tur), isNotNull);
      }
      expect(
        {for (final t in OlayTuru.values) HaberciTipi.olayTurunden(t)},
        hasLength(OlayTuru.values.length),
        reason: 'iki kart türü aynı haberciyi paylaşmamalı',
      );
    });
  });

  group('sayı akışı', () {
    testWidgets('değer değişince araya değerler uğruyor', (tester) async {
      await tester.pumpWidget(sar(
        const SayiAkisi(deger: 0, bicimle: _tamsayi),
      ));
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);

      await tester.pumpWidget(sar(
        const SayiAkisi(deger: 100, bicimle: _tamsayi),
      ));
      await tester.pump(const Duration(milliseconds: 200));
      final araDeger = int.parse(
        (tester.widget<Text>(find.byType(Text)).data)!,
      );
      expect(araDeger, greaterThan(0));
      expect(araDeger, lessThan(100), reason: 'anında sıçramamalı');

      await tester.pumpAndSettle();
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('hareket kapalıyken anında son değeri gösteriyor',
        (tester) async {
      await tester.pumpWidget(sar(
        const SayiAkisi(deger: 0, bicimle: _tamsayi),
        hareketKapali: true,
      ));
      await tester.pumpAndSettle();
      await tester.pumpWidget(sar(
        const SayiAkisi(deger: 100, bicimle: _tamsayi),
        hareketKapali: true,
      ));
      await tester.pump();
      expect(find.text('100'), findsOneWidget);
    });
  });
}

String _tamsayi(num v) => v.round().toString();
