import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/shared/bicimleme.dart';

void main() {
  const tr = Bicim('tr');
  const en = Bicim('en');

  group('para', () {
    test('binlik ayracı yerelden gelir', () {
      expect(tr.para(1234567), '1.234.567 ₺');
      expect(en.para(1234567), '1,234,567 ₺');
    });

    test('kuruş tutulmaz, yuvarlanır', () {
      expect(tr.para(1234.6), '1.235 ₺');
    });

    test('küçük tutar kısaltılmaz', () {
      // "9,8 B" okunmuyor; eşik altında tam yazım.
      expect(tr.kisaPara(9800), '9.800 ₺');
    });

    test('büyük tutar kısaltılır', () {
      // 40 yıllık oyunda net değer satıra sığmıyor; kısaltma eki de
      // yerelden gelir, elle yazılmaz.
      expect(tr.kisaPara(1200000), isNot(contains('1.200.000')));
      expect(tr.kisaPara(1200000), contains('₺'));
    });

    test('işaret yönü gösterir', () {
      expect(tr.imzaliPara(50000), startsWith('+'));
      expect(tr.imzaliPara(-50000), startsWith('-'));
      expect(tr.imzaliPara(0), isNot(startsWith('+')));
      expect(tr.imzaliPara(0), isNot(startsWith('-')));
    });

    test('negatifte çift işaret olmaz', () {
      expect(tr.imzaliPara(-1200000).split('-'), hasLength(2));
    });
  });

  group('yüzde', () {
    test('oran yüzdeye çevrilir', () {
      expect(tr.yuzde(0.325), '%32,5');
      expect(tr.yuzde(0.325, basamak: 0), '%33');
    });
  });

  test('ondalık katsayı', () {
    expect(tr.ondalik(1.35), '1,35');
    expect(tr.ondalik(0.85), '0,85');
  });
}
