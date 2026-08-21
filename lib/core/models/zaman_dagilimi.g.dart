// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zaman_dagilimi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ZamanDagilimi _$ZamanDagilimiFromJson(Map<String, dynamic> json) =>
    _ZamanDagilimi(
      calisma: (json['calisma'] as num?)?.toInt() ?? 0,
      egitim: (json['egitim'] as num?)?.toInt() ?? 0,
      network: (json['network'] as num?)?.toInt() ?? 0,
      dinlenme: (json['dinlenme'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ZamanDagilimiToJson(_ZamanDagilimi instance) =>
    <String, dynamic>{
      'calisma': instance.calisma,
      'egitim': instance.egitim,
      'network': instance.network,
      'dinlenme': instance.dinlenme,
    };
