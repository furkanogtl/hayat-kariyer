import 'package:json_annotation/json_annotation.dart';

/// Oyunun geçtiği şehirler.
///
/// Şehir yalnızca dekor değil: yaşam maliyeti çarpanı doğrudan her turun
/// gider kalemine giriyor. İstanbul'da kazanmak kolay, tutmak zordur;
/// Konya'da tam tersi.
@JsonEnum(valueField: 'id')
enum Sehir {
  istanbul('istanbul', 1.35),
  izmir('izmir', 1.15),
  gaziantep('gaziantep', 0.92),
  trabzon('trabzon', 0.88),
  konya('konya', 0.85);

  const Sehir(this.id, this.giderCarpani);

  /// JSON ve kayıt dosyasındaki sabit kimlik.
  final String id;

  /// Taban yaşam giderinin bu şehirdeki çarpanı.
  final double giderCarpani;

  static Sehir? bul(String id) {
    for (final s in Sehir.values) {
      if (s.id == id) return s;
    }
    return null;
  }
}
