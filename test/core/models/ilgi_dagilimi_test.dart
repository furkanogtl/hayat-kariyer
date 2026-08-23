import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/models/ilgi_dagilimi.dart';

void main() {
  group('temel', () {
    test('boş dağılımda tüm puan serbest', () {
      const d = IlgiDagilimi();
      expect(d.toplam, 0);
      expect(d.bosPuan, IlgiDagilimi.toplamPuan);
      expect(d.gecerli, isTrue);
      expect(d.puan('kafe'), 0);
    });

    test('ayarla ve kaldır', () {
      final d = const IlgiDagilimi().ayarla('kafe', 2).ayarla('galeri', 3);
      expect(d.toplam, 5);
      expect(d.puan('kafe'), 2);
      expect(d.kaldir('kafe').toplam, 3);
      expect(d.kaldir('kafe').puan('kafe'), 0);
    });

    test('negatif puan sıfıra çekilir', () {
      expect(const IlgiDagilimi().ayarla('kafe', -4).puan('kafe'), 0);
    });

    test('toplamı aşan dağılım geçersiz', () {
      final d = const IlgiDagilimi()
          .ayarla('a', IlgiDagilimi.toplamPuan)
          .ayarla('b', 1);
      expect(d.gecerli, isFalse);
    });
  });

  group('duzelt', () {
    test('sınır içindeki dağılıma dokunmaz', () {
      final d = const IlgiDagilimi().ayarla('kafe', 2).ayarla('galeri', 3);
      expect(d.duzelt(), d);
    });

    test('fazlalık en çok puan alandan kırpılır', () {
      // Oyuncunun az puan ayırdığı işletme sessizce sıfırlanmamalı.
      final d = const IlgiDagilimi(puanlar: {'buyuk': 8, 'kucuk': 1}).duzelt();
      expect(d.toplam, IlgiDagilimi.toplamPuan);
      expect(d.puan('kucuk'), 1);
      expect(d.puan('buyuk'), IlgiDagilimi.toplamPuan - 1);
    });

    test('sıfır puanlı kayıt temizlenir', () {
      final d = const IlgiDagilimi(puanlar: {'kafe': 0, 'galeri': 2}).duzelt();
      expect(d.puanlar.containsKey('kafe'), isFalse);
      expect(d.puanlar, {'galeri': 2});
    });

    test('eşit puanlarda kırpma belirlenimli', () {
      // Aynı girdi her çalıştırmada aynı sonucu vermeli; map sırası
      // değişse bile kayıt bozulmasın.
      const girdi = IlgiDagilimi(puanlar: {'b': 4, 'a': 4, 'c': 4});
      final ilk = girdi.duzelt();
      for (var i = 0; i < 5; i++) {
        expect(girdi.duzelt(), ilk);
      }
      expect(ilk.toplam, IlgiDagilimi.toplamPuan);
    });

    test('düzeltilmiş dağılım her zaman geçerli', () {
      const bozuk = IlgiDagilimi(puanlar: {'a': 50, 'b': -3, 'c': 9});
      expect(bozuk.duzelt().gecerli, isTrue);
    });
  });

  test('JSON round-trip', () {
    final d = const IlgiDagilimi().ayarla('kafe', 2).ayarla('galeri', 3);
    expect(IlgiDagilimi.fromJson(d.toJson()), d);
  });

  test('toplam puan iki işletmeyi taşır, üçüncüsünü zorlar', () {
    // Anayasanın kaldırılamaz kısıtı sayıya bağlanıyor: kafe (2) + oto
    // galeri (3) = 5, altıncı puan artıyor. Üçüncü bir işletme ancak
    // CEO ile mümkün.
    expect(IlgiDagilimi.toplamPuan, 6);
    expect(2 + 3, lessThanOrEqualTo(IlgiDagilimi.toplamPuan));
    expect(2 + 3 + 2, greaterThan(IlgiDagilimi.toplamPuan));
  });
}
