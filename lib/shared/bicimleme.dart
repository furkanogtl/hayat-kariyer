import 'package:intl/intl.dart';

/// Sayı ve para biçimleme.
///
/// Motor HAM TL ile çalışır; ekrana gelen tutar önce
/// `PiyasaDurumu.gosterimTutari()` ile ölçeklenir (para reformu), sonra
/// buradan geçer. İkisini karıştırmamak için bu sınıf `int` değil `num`
/// alır: gösterim tutarı ondalıklıdır.
class Bicim {
  const Bicim(this.yerelKod);

  /// `tr` / `en`. Binlik ayracı ve kısaltma ekleri (Mn, Mr) intl'den gelir;
  /// dile gömülü metin yazılmaz.
  final String yerelKod;

  static const String paraSimgesi = '₺';

  /// Tam tutar: `1.234.567 ₺`.
  String para(num tutar) =>
      '${NumberFormat.decimalPattern(yerelKod).format(tutar.round())} '
      '$paraSimgesi';

  /// Kısa tutar: `1,2 Mn ₺`. Dashboard'da net değer gibi büyüyen
  /// rakamlar için; 40 yıllık oyunda tam yazım satıra sığmıyor.
  String kisaPara(num tutar) {
    final mutlak = tutar.abs();
    // Küçük tutarda kısaltma okunabilirliği bozar: "9,8 B" yerine "9.800".
    if (mutlak < 10000) return para(tutar);
    return '${NumberFormat.compact(locale: yerelKod).format(tutar)} '
        '$paraSimgesi';
  }

  /// İşaretli tutar: gelir/gider satırlarında yön belli olsun.
  String imzaliPara(num tutar) {
    final govde = kisaPara(tutar.abs());
    if (tutar > 0) return '+$govde';
    if (tutar < 0) return '-$govde';
    return govde;
  }

  /// `0.325` -> `%32,5`.
  String yuzde(num oran, {int basamak = 1}) =>
      NumberFormat.decimalPercentPattern(
        locale: yerelKod,
        decimalDigits: basamak,
      ).format(oran);

  String tamsayi(num deger) =>
      NumberFormat.decimalPattern(yerelKod).format(deger.round());

  /// `1.35` -> `1,35`. Şehir gider çarpanı gibi ham katsayılar için.
  String ondalik(num deger, {int basamak = 2}) =>
      NumberFormat.decimalPattern(yerelKod).format(
        double.parse(deger.toStringAsFixed(basamak)),
      );
}
