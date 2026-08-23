// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Borc _$BorcFromJson(Map<String, dynamic> json) => _Borc(
  id: json['id'] as String,
  tur: $enumDecode(_$BorcTuruEnumMap, json['tur']),
  anapara: (json['anapara'] as num).toInt(),
  kalanAnapara: (json['kalanAnapara'] as num).toInt(),
  aylikTaksit: (json['aylikTaksit'] as num).toInt(),
  aylikFaiz: (json['aylikFaiz'] as num).toDouble(),
  kalanTaksit: (json['kalanTaksit'] as num).toInt(),
  cekildigiTur: (json['cekildigiTur'] as num).toInt(),
  gecikmeTuru: (json['gecikmeTuru'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$BorcToJson(_Borc instance) => <String, dynamic>{
  'id': instance.id,
  'tur': _$BorcTuruEnumMap[instance.tur]!,
  'anapara': instance.anapara,
  'kalanAnapara': instance.kalanAnapara,
  'aylikTaksit': instance.aylikTaksit,
  'aylikFaiz': instance.aylikFaiz,
  'kalanTaksit': instance.kalanTaksit,
  'cekildigiTur': instance.cekildigiTur,
  'gecikmeTuru': instance.gecikmeTuru,
};

const _$BorcTuruEnumMap = {
  BorcTuru.ihtiyac: 'ihtiyac',
  BorcTuru.tasit: 'tasit',
  BorcTuru.konut: 'konut',
  BorcTuru.kartBorcu: 'kart_borcu',
};

_KrediTeklifi _$KrediTeklifiFromJson(Map<String, dynamic> json) =>
    _KrediTeklifi(
      tur: $enumDecode(_$BorcTuruEnumMap, json['tur']),
      enYuksekTutar: (json['enYuksekTutar'] as num).toInt(),
      aylikFaiz: (json['aylikFaiz'] as num).toDouble(),
      vadeTur: (json['vadeTur'] as num).toInt(),
    );

Map<String, dynamic> _$KrediTeklifiToJson(_KrediTeklifi instance) =>
    <String, dynamic>{
      'tur': _$BorcTuruEnumMap[instance.tur]!,
      'enYuksekTutar': instance.enYuksekTutar,
      'aylikFaiz': instance.aylikFaiz,
      'vadeTur': instance.vadeTur,
    };
