// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oyun_durumu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OyunDurumu _$OyunDurumuFromJson(Map<String, dynamic> json) => _OyunDurumu(
  anaTohum: (json['anaTohum'] as num).toInt(),
  oyuncu: Oyuncu.fromJson(json['oyuncu'] as Map<String, dynamic>),
  piyasa: PiyasaDurumu.fromJson(json['piyasa'] as Map<String, dynamic>),
  maasEndeksi: (json['maasEndeksi'] as num?)?.toDouble() ?? 1.0,
  kayitSurumu: (json['kayitSurumu'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$OyunDurumuToJson(_OyunDurumu instance) =>
    <String, dynamic>{
      'anaTohum': instance.anaTohum,
      'oyuncu': instance.oyuncu,
      'piyasa': instance.piyasa,
      'maasEndeksi': instance.maasEndeksi,
      'kayitSurumu': instance.kayitSurumu,
    };
