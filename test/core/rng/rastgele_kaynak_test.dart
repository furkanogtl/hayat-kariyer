import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/rng/rng.dart';

void main() {
  group('Akış türetme', () {
    test('aynı ana tohum + ad + tur aynı sonucu verir', () {
      final k1 = const RastgeleKaynak(20260820);
      final k2 = const RastgeleKaynak(20260820);
      final a = List.generate(30, (_) => k1.akis('piyasa', tur: 5).sonraki());
      final b = List.generate(30, (_) => k2.akis('piyasa', tur: 5).sonraki());
      expect(a, b);
    });

    test('farklı ad farklı akış üretir', () {
      const kaynak = RastgeleKaynak(20260820);
      final piyasa = kaynak.akis('piyasa', tur: 5);
      final olay = kaynak.akis('olay', tur: 5);
      expect(piyasa.tohum, isNot(olay.tohum));
      expect(
        List.generate(20, (_) => piyasa.sonraki()),
        isNot(List.generate(20, (_) => olay.sonraki())),
      );
    });

    test('farklı tur farklı akış üretir', () {
      const kaynak = RastgeleKaynak(20260820);
      expect(
        kaynak.akis('piyasa', tur: 5).tohum,
        isNot(kaynak.akis('piyasa', tur: 6).tohum),
      );
    });

    test('farklı ana tohum farklı akış üretir', () {
      expect(
        const RastgeleKaynak(1).akis('piyasa', tur: 0).tohum,
        isNot(const RastgeleKaynak(2).akis('piyasa', tur: 0).tohum),
      );
    });

    test('akış tohumu 32 bit ve negatif olmayan aralıkta kalır', () {
      for (var tohum = 0; tohum < 200; tohum++) {
        final kaynak = RastgeleKaynak(tohum);
        for (final ad in ['piyasa', 'olay', 'isletme:kafe_01', 'kariyer']) {
          final t = kaynak.akisTohumu(ad, tohum % 40);
          expect(t, greaterThanOrEqualTo(0));
          expect(t, lessThanOrEqualTo(0xffffffff));
        }
      }
    });
  });

  group('Akış bağımsızlığı (regresyon güvencesi)', () {
    test('bir akıştan fazladan zar çekmek diğer akışı etkilemez', () {
      const kaynak = RastgeleKaynak(4242);

      // Senaryo A: sadece olay akışı okunur.
      final olayA = kaynak.akis('olay', tur: 3);
      final sonucA = List.generate(10, (_) => olayA.sonraki());

      // Senaryo B: motora piyasa tarafında yeni bir zar atışı eklenmiş gibi
      // davranılır; olay akışı bundan etkilenmemelidir.
      final piyasa = kaynak.akis('piyasa', tur: 3);
      List.generate(137, (_) => piyasa.sonraki());
      final olayB = kaynak.akis('olay', tur: 3);
      final sonucB = List.generate(10, (_) => olayB.sonraki());

      expect(sonucA, sonucB);
    });

    test('farklı işletme akışları birbirinden bağımsızdır', () {
      const kaynak = RastgeleKaynak(9);
      final kafe = kaynak.akis('isletme:kafe_01', tur: 12);
      final galeri = kaynak.akis('isletme:galeri_01', tur: 12);
      expect(
        List.generate(20, (_) => kafe.sonraki()),
        isNot(List.generate(20, (_) => galeri.sonraki())),
      );
    });
  });

  group('Yeni oyun tohumu', () {
    test('yeniOyun geçerli aralıkta tohum üretir', () {
      for (var i = 0; i < 50; i++) {
        final t = RastgeleKaynak.yeniOyun().anaTohum;
        expect(t, greaterThanOrEqualTo(0));
        expect(t, lessThan(0xffffffff));
      }
    });

    test('eşitlik ana tohuma bağlıdır (kayıt karşılaştırması için)', () {
      expect(const RastgeleKaynak(5), const RastgeleKaynak(5));
      expect(const RastgeleKaynak(5), isNot(const RastgeleKaynak(6)));
    });
  });
}
