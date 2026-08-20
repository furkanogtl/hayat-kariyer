import 'dart:math' as math;

import 'rastgele_akis.dart';

/// Oyunun tek rastgelelik kaynağı.
///
/// Tasarım kararı: tek bir global `Random` KULLANILMAZ. Sebebi, motora
/// sonradan fazladan bir zar atışı eklendiğinde o noktadan sonraki tüm
/// sonuçların kayması ve eski kayıtların/bug tekrar üretiminin bozulmasıdır.
///
/// Bunun yerine her alt sistem kendi adlandırılmış akışını alır:
///
/// ```dart
/// final piyasa = kaynak.akis('piyasa', tur: 7);
/// final olay   = kaynak.akis('olay', tur: 7);
/// ```
///
/// Akış tohumu `(anaTohum, ad, tur)` üçlüsünden saf bir karma ile türetilir;
/// alt sistemler birbirinin zar sırasını bozamaz.
class RastgeleKaynak {
  /// Kayda yazılan ana tohum. Aynı ana tohum = aynı oyun.
  final int anaTohum;

  const RastgeleKaynak(this.anaTohum);

  /// Yeni oyun için tohum üretir.
  factory RastgeleKaynak.yeniOyun() =>
      RastgeleKaynak(math.Random.secure().nextInt(0xffffffff));

  /// [ad] ve [tur] için deterministik akış döndürür.
  ///
  /// Aynı üçlü her çağrıldığında akış BAŞTAN başlar. Yani bir turda aynı
  /// akış iki kez istenirse aynı sayılar gelir; alt sistem akışını tur
  /// başında bir kez alıp elden geçirmelidir.
  RastgeleAkis akis(String ad, {int tur = 0}) => RastgeleAkis.turetilmis(
        ad: ad,
        tur: tur,
        tohum: akisTohumu(ad, tur),
      );

  /// Akış tohumunu hesaplar. Hata ayıklama ve testler için açık bırakıldı.
  int akisTohumu(String ad, int tur) {
    final adKarmasi = _fnv1a32(ad);
    final turKarmasi = _karistir32((tur * 0x9e3779b1) & 0xffffffff);
    return _karistir32(
      (_karistir32(anaTohum & 0xffffffff) ^ adKarmasi ^ turKarmasi) &
          0xffffffff,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is RastgeleKaynak && other.anaTohum == anaTohum;

  @override
  int get hashCode => anaTohum.hashCode;

  @override
  String toString() => 'RastgeleKaynak($anaTohum)';
}

/// FNV-1a 32 bit. Sabit ve platformdan bağımsız olduğu için `String.hashCode`
/// yerine bu kullanılır — `hashCode` sürümler arası değişebilir, kayıtları bozar.
int _fnv1a32(String metin) {
  var h = 0x811c9dc5;
  for (final kod in metin.codeUnits) {
    h = ((h ^ (kod & 0xff)) * 0x01000193) & 0xffffffff;
    h = ((h ^ ((kod >> 8) & 0xff)) * 0x01000193) & 0xffffffff;
  }
  return h;
}

/// 32 bit bit-karıştırıcı (splitmix türevi). Yakın tohumları birbirinden
/// uzaklaştırır; ardışık turların benzer sonuç üretmesini engeller.
int _karistir32(int x) {
  x &= 0xffffffff;
  x = ((x ^ (x >> 16)) * 0x7feb352d) & 0xffffffff;
  x = ((x ^ (x >> 15)) * 0x846ca68b) & 0xffffffff;
  return (x ^ (x >> 16)) & 0xffffffff;
}
