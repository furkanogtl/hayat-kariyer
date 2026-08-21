import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../engine/rejim.dart';

part 'piyasa_durumu.freezed.dart';
part 'piyasa_durumu.g.dart';

/// Piyasanın o turdaki durumu. Kayda yazılır.
@freezed
abstract class PiyasaDurumu with _$PiyasaDurumu {
  const PiyasaDurumu._();

  const factory PiyasaDurumu({
    @Default(Rejim.buyume) Rejim rejim,

    /// Mevcut rejimin kaç turdur sürdüğü. Asgari süre kontrolü buna bakar.
    @Default(0) int rejimSuresi,

    /// Oyun başından beri birikmiş fiyat seviyesi. Başlangıç 1.0.
    /// Taban TL cinsinden yazılmış her tutar (maaş, kira, gider) bununla
    /// çarpılarak o turun nominal değerine çevrilir.
    @Default(1.0) double enflasyonEndeksi,

    /// Son turda gerçekleşen aylık enflasyon (0.03 = %3).
    @Default(0.0) double sonAylikEnflasyon,
  }) = _PiyasaDurumu;

  factory PiyasaDurumu.fromJson(Map<String, dynamic> json) =>
      _$PiyasaDurumuFromJson(json);

  /// Son aylık enflasyonun yıllıklandırılmış hali. Yalnızca gösterim içindir.
  double get yillikEnflasyon => math.pow(1 + sonAylikEnflasyon, 12) - 1;

  /// Taban TL tutarını bu turun nominal değerine çevirir.
  /// Maaş, kira, sabit gider — hepsi buradan geçer.
  int endeksle(int tabanTutar) => (tabanTutar * enflasyonEndeksi).round();

  /// Nominal tutarı bugünkü (oyun başı) paraya indirger. Skor ekranında
  /// "reel servet" göstermek için.
  int reeleCevir(int nominalTutar) => (nominalTutar / enflasyonEndeksi).round();

  /// Rejim değişimi için asgari süre doldu mu.
  bool get rejimDegisebilir => rejimSuresi >= rejimEnAzSure;
}
