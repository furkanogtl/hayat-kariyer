import 'package:freezed_annotation/freezed_annotation.dart';

part 'borc.freezed.dart';
part 'borc.g.dart';

/// Kredi türü. Vade, faiz farkı ve teminat davranışı buradan gelir.
@JsonEnum(valueField: 'id')
enum BorcTuru {
  /// İhtiyaç kredisi: kısa vade, yüksek faiz, teminatsız.
  ihtiyac('ihtiyac'),

  /// Taşıt kredisi: orta vade, araç teminatlı.
  tasit('tasit'),

  /// Konut kredisi: uzun vade, en düşük faiz, ipotekli.
  konut('konut'),

  /// Kredi kartı borcu: en pahalısı. Olay kartları buraya yazar.
  kartBorcu('kart_borcu');

  const BorcTuru(this.id);

  final String id;

  static BorcTuru? bul(String id) {
    for (final t in BorcTuru.values) {
      if (t.id == id) return t;
    }
    return null;
  }
}

/// Alınmış bir kredi.
///
/// Tutarlar NOMİNAL TL'dir, taban TL değil. Sebebi tasarımın kalbi:
/// kredinin taksiti çekildiği günün parasıyla sabitlenir, enflasyon onu
/// aşındırır. Türkiye'de "kredi çekip ev al" baskısının sayısal karşılığı
/// bu — taksitler sabit kalırken maaş ve fiyatlar büyür.
@freezed
abstract class Borc with _$Borc {
  const Borc._();

  const factory Borc({
    required String id,
    required BorcTuru tur,

    /// Çekildiği andaki anapara (nominal TL).
    required int anapara,

    /// Kalan anapara (nominal TL).
    required int kalanAnapara,

    /// Sabit aylık taksit (nominal TL).
    required int aylikTaksit,

    /// AYLIK nominal faiz oranı. Çekildiği turdaki rejime ve kredi notuna
    /// göre belirlenir, sonra DEĞİŞMEZ.
    required double aylikFaiz,

    /// Kalan taksit sayısı.
    required int kalanTaksit,
    required int cekildigiTur,

    /// Üst üste ödenemeyen taksit sayısı.
    @Default(0) int gecikmeTuru,
  }) = _Borc;

  factory Borc.fromJson(Map<String, dynamic> json) => _$BorcFromJson(json);

  bool get kapandi => kalanTaksit <= 0 || kalanAnapara <= 0;

  bool get gecikmede => gecikmeTuru > 0;

  /// Bu turun faizi (nominal TL).
  int get donemFaizi => (kalanAnapara * aylikFaiz).round();

  /// Erken kapatma bedeli: kalan anapara + bir aylık faiz.
  /// Bankanın "erken kapama komisyonu"nun basitleştirilmiş hali; kredinin
  /// bedavaya kapanmasını engelliyor.
  int get erkenKapamaBedeli => kalanAnapara + donemFaizi;

  Borc duzelt() => copyWith(
        kalanAnapara: kalanAnapara < 0 ? 0 : kalanAnapara,
        kalanTaksit: kalanTaksit < 0 ? 0 : kalanTaksit,
        gecikmeTuru: gecikmeTuru < 0 ? 0 : gecikmeTuru,
      );
}

/// Bankanın oyuncuya sunduğu kredi teklifi. Henüz çekilmiş değil.
@freezed
abstract class KrediTeklifi with _$KrediTeklifi {
  const KrediTeklifi._();

  const factory KrediTeklifi({
    required BorcTuru tur,

    /// Çekilebilecek en yüksek anapara (nominal TL).
    required int enYuksekTutar,
    required double aylikFaiz,
    required int vadeTur,
  }) = _KrediTeklifi;

  factory KrediTeklifi.fromJson(Map<String, dynamic> json) =>
      _$KrediTeklifiFromJson(json);

  /// Verilen anapara için aylık taksit (eşit taksitli/anüite).
  ///
  /// `T = A * i / (1 - (1+i)^-n)`. Faiz sıfırsa düz bölme.
  int taksit(int anapara) => taksitHesapla(anapara, aylikFaiz, vadeTur);

  /// Toplam geri ödeme (nominal TL).
  int toplamOdeme(int anapara) => taksit(anapara) * vadeTur;

  bool get gecerli => enYuksekTutar > 0;
}

/// Anüite taksiti. Motor ve teklif aynı formülü kullansın diye tek yerde.
int taksitHesapla(int anapara, double aylikFaiz, int vadeTur) {
  if (vadeTur <= 0) return anapara;
  if (aylikFaiz <= 0) return (anapara / vadeTur).ceil();
  final carpan = _us(1 + aylikFaiz, vadeTur);
  return (anapara * aylikFaiz * carpan / (carpan - 1)).ceil();
}

double _us(double taban, int us) {
  var sonuc = 1.0;
  for (var i = 0; i < us; i++) {
    sonuc *= taban;
  }
  return sonuc;
}
