import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/rng/rng.dart';

void main() {
  group('RastgeleAkis determinizmi', () {
    test('aynı tohum aynı diziyi üretir', () {
      final a = RastgeleAkis.tohumdan(1234);
      final b = RastgeleAkis.tohumdan(1234);
      final dizi1 = List.generate(50, (_) => a.sonraki());
      final dizi2 = List.generate(50, (_) => b.sonraki());
      expect(dizi1, dizi2);
    });

    test('farklı tohum farklı dizi üretir', () {
      final a = RastgeleAkis.tohumdan(1234);
      final b = RastgeleAkis.tohumdan(1235);
      final dizi1 = List.generate(50, (_) => a.sonraki());
      final dizi2 = List.generate(50, (_) => b.sonraki());
      expect(dizi1, isNot(dizi2));
    });

    test('karistir deterministiktir', () {
      final liste1 = List.generate(20, (i) => i);
      final liste2 = List.generate(20, (i) => i);
      RastgeleAkis.tohumdan(7).karistir(liste1);
      RastgeleAkis.tohumdan(7).karistir(liste2);
      expect(liste1, liste2);
      expect(liste1, isNot(List.generate(20, (i) => i)));
    });
  });

  group('sans', () {
    test('0 hiçbir zaman, 1 her zaman', () {
      final akis = RastgeleAkis.tohumdan(99);
      for (var i = 0; i < 200; i++) {
        expect(akis.sans(0.0), isFalse);
        expect(akis.sans(1.0), isTrue);
      }
    });

    test('0.3 olasılık uzun vadede oransal çıkar', () {
      final akis = RastgeleAkis.tohumdan(42);
      var basari = 0;
      const deneme = 100000;
      for (var i = 0; i < deneme; i++) {
        if (akis.sans(0.3)) basari++;
      }
      expect(basari / deneme, closeTo(0.3, 0.01));
    });
  });

  group('aralik', () {
    test('tam sayı aralığı sınırları içinde kalır ve iki ucu da görür', () {
      final akis = RastgeleAkis.tohumdan(5);
      final gorulen = <int>{};
      for (var i = 0; i < 5000; i++) {
        final d = akis.aralik(18, 24);
        expect(d, greaterThanOrEqualTo(18));
        expect(d, lessThan(24));
        gorulen.add(d);
      }
      expect(gorulen, {18, 19, 20, 21, 22, 23});
    });

    test('ondalık aralık sınırları içinde kalır', () {
      final akis = RastgeleAkis.tohumdan(6);
      for (var i = 0; i < 5000; i++) {
        final d = akis.aralikOndalik(-0.05, 0.12);
        expect(d, greaterThanOrEqualTo(-0.05));
        expect(d, lessThanOrEqualTo(0.12));
      }
    });
  });

  group('agirlikliIndeks', () {
    test('sıfır ağırlıklı eleman asla seçilmez', () {
      final akis = RastgeleAkis.tohumdan(11);
      for (var i = 0; i < 5000; i++) {
        expect(akis.agirlikliIndeks([1.0, 0.0, 1.0]), isNot(1));
      }
    });

    test('seçim ağırlıklarla orantılıdır', () {
      final akis = RastgeleAkis.tohumdan(2024);
      final sayac = [0, 0, 0];
      const deneme = 120000;
      for (var i = 0; i < deneme; i++) {
        sayac[akis.agirlikliIndeks([10.0, 30.0, 60.0])]++;
      }
      expect(sayac[0] / deneme, closeTo(0.10, 0.01));
      expect(sayac[1] / deneme, closeTo(0.30, 0.01));
      expect(sayac[2] / deneme, closeTo(0.60, 0.01));
    });

    test('agirlikliSecim elemanı döndürür', () {
      final akis = RastgeleAkis.tohumdan(3);
      final olaylar = ['kriz', 'firsat', 'teklif'];
      final secilen = akis.agirlikliSecim(
        olaylar,
        (o) => o == 'firsat' ? 1.0 : 0.0,
      );
      expect(secilen, 'firsat');
    });
  });

  group('normal', () {
    test('ortalama ve standart sapma beklenene yakın', () {
      final akis = RastgeleAkis.tohumdan(777);
      const n = 200000;
      var toplam = 0.0;
      final ornekler = List.generate(n, (_) {
        final d = akis.normal(ortalama: 0.02, sapma: 0.15);
        toplam += d;
        return d;
      });
      final ortalama = toplam / n;
      var kareToplam = 0.0;
      for (final o in ornekler) {
        kareToplam += (o - ortalama) * (o - ortalama);
      }
      final sapma = (kareToplam / n);
      expect(ortalama, closeTo(0.02, 0.005));
      expect(sapma, closeTo(0.15 * 0.15, 0.001));
    });

    test('normal çağrıları da deterministiktir', () {
      final a = List.generate(20, (_) => 0.0);
      final akis1 = RastgeleAkis.tohumdan(8);
      final akis2 = RastgeleAkis.tohumdan(8);
      for (var i = 0; i < a.length; i++) {
        expect(akis1.normal(), akis2.normal());
      }
    });
  });
}
