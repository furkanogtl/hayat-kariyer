// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfoy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Pozisyon _$PozisyonFromJson(Map<String, dynamic> json) => _Pozisyon(
  adet: (json['adet'] as num).toDouble(),
  ortalamaMaliyet: (json['ortalamaMaliyet'] as num).toDouble(),
  ortalamaEndeks: (json['ortalamaEndeks'] as num?)?.toDouble() ?? 1.0,
);

Map<String, dynamic> _$PozisyonToJson(_Pozisyon instance) => <String, dynamic>{
  'adet': instance.adet,
  'ortalamaMaliyet': instance.ortalamaMaliyet,
  'ortalamaEndeks': instance.ortalamaEndeks,
};

_BekleyenSatis _$BekleyenSatisFromJson(Map<String, dynamic> json) =>
    _BekleyenSatis(
      varlikId: json['varlikId'] as String,
      adet: (json['adet'] as num).toDouble(),
      kalanTur: (json['kalanTur'] as num).toInt(),
    );

Map<String, dynamic> _$BekleyenSatisToJson(_BekleyenSatis instance) =>
    <String, dynamic>{
      'varlikId': instance.varlikId,
      'adet': instance.adet,
      'kalanTur': instance.kalanTur,
    };

_Portfoy _$PortfoyFromJson(Map<String, dynamic> json) => _Portfoy(
  pozisyonlar:
      (json['pozisyonlar'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, Pozisyon.fromJson(e as Map<String, dynamic>)),
      ) ??
      const <String, Pozisyon>{},
  bekleyenSatislar:
      (json['bekleyenSatislar'] as List<dynamic>?)
          ?.map((e) => BekleyenSatis.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <BekleyenSatis>[],
);

Map<String, dynamic> _$PortfoyToJson(_Portfoy instance) => <String, dynamic>{
  'pozisyonlar': instance.pozisyonlar,
  'bekleyenSatislar': instance.bekleyenSatislar,
};
