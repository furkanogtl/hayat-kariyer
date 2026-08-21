import 'package:freezed_annotation/freezed_annotation.dart';

import 'oyuncu.dart';
import 'piyasa_durumu.dart';

part 'oyun_durumu.freezed.dart';
part 'oyun_durumu.g.dart';

/// Kayıt dosyasının kökü. Tek JSON dokümanı olarak diske yazılır.
///
/// Tur sayacı BURADA TUTULMAZ; `oyuncu.tur` tek kaynaktır. İki yerde tutulsa
/// er ya da geç birbirinden kayardı — yaş/tur ilişkisinde verilen kararın
/// aynısı.
@freezed
abstract class OyunDurumu with _$OyunDurumu {
  const OyunDurumu._();

  const factory OyunDurumu({
    /// Oyunun tohumu. Aynı tohum + aynı kararlar = aynı oyun.
    /// Bug tekrar üretimi buna bağlı.
    required int anaTohum,
    required Oyuncu oyuncu,
    required PiyasaDurumu piyasa,

    /// Maaşların bağlı olduğu fiyat endeksi.
    ///
    /// Enflasyon endeksinden ayrı tutuluyor çünkü maaş yılda bir (ocakta)
    /// zamlanır, giderler her ay artar. Aradaki makas oyunun en gerçekçi
    /// baskısı: yıl ortasında alım gücü erir, ocakta düzelir.
    @Default(1.0) double maasEndeksi,

    /// Kayıt biçimi sürümü. İleride şema değişirse göç buradan yönetilir.
    @Default(1) int kayitSurumu,
  }) = _OyunDurumu;

  factory OyunDurumu.fromJson(Map<String, dynamic> json) =>
      _$OyunDurumuFromJson(json);

  /// Oynanan tur (ay). `oyuncu.tur` ile aynı; kolaylık için.
  int get tur => oyuncu.tur;

  int get yas => oyuncu.yas;

  int get ay => oyuncu.ay;

  /// Maaşın enflasyon karşısında ne kadar geride kaldığı (0.15 = %15 erimiş).
  /// Ocakta sıfırlanır.
  double get alimGucuKaybi =>
      1 - maasEndeksi / piyasa.enflasyonEndeksi;

  /// Kayıttan yüklenen veriyi güvenli hale getirir.
  OyunDurumu duzelt() => copyWith(
        oyuncu: oyuncu.duzelt(),
        maasEndeksi: maasEndeksi <= 0 ? 1.0 : maasEndeksi,
      );
}
