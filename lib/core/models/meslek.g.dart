// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meslek.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GirisSarti _$GirisSartiFromJson(Map<String, dynamic> json) => _GirisSarti(
  egitim:
      $enumDecodeNullable(_$EgitimSeviyesiEnumMap, json['egitim']) ??
      EgitimSeviyesi.lise,
  yetkinlik: (json['yetkinlik'] as num?)?.toInt() ?? 0,
  yasAraligi:
      (json['yas'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[18, 99],
);

Map<String, dynamic> _$GirisSartiToJson(_GirisSarti instance) =>
    <String, dynamic>{
      'egitim': _$EgitimSeviyesiEnumMap[instance.egitim]!,
      'yetkinlik': instance.yetkinlik,
      'yas': instance.yasAraligi,
    };

const _$EgitimSeviyesiEnumMap = {
  EgitimSeviyesi.ilkogretim: 'ilkogretim',
  EgitimSeviyesi.lise: 'lise',
  EgitimSeviyesi.onlisans: 'onlisans',
  EgitimSeviyesi.lisans: 'lisans',
  EgitimSeviyesi.yuksekLisans: 'yuksek_lisans',
  EgitimSeviyesi.doktora: 'doktora',
};

_Kademe _$KademeFromJson(Map<String, dynamic> json) => _Kademe(
  ad: json['ad'] as String,
  maas: (json['maas'] as num).toInt(),
  yetkinlikGerek: (json['yetkinlikGerek'] as num?)?.toInt() ?? 0,
  sureTur: (json['sureTur'] as num?)?.toInt(),
);

Map<String, dynamic> _$KademeToJson(_Kademe instance) => <String, dynamic>{
  'ad': instance.ad,
  'maas': instance.maas,
  'yetkinlikGerek': instance.yetkinlikGerek,
  'sureTur': instance.sureTur,
};

_Meslek _$MeslekFromJson(Map<String, dynamic> json) => _Meslek(
  id: json['id'] as String,
  ad: json['ad'] as String,
  sektor: $enumDecode(_$SektorEnumMap, json['sektor']),
  girisSarti: json['girisSarti'] == null
      ? const GirisSarti()
      : GirisSarti.fromJson(json['girisSarti'] as Map<String, dynamic>),
  kademeler: (json['kademeler'] as List<dynamic>)
      .map((e) => Kademe.fromJson(e as Map<String, dynamic>))
      .toList(),
  yetkinlikArtisHizi: (json['yetkinlikArtisHizi'] as num?)?.toDouble() ?? 1.0,
  networkArtisi: (json['networkArtisi'] as num?)?.toDouble() ?? 0.5,
  enerjiMaliyeti: (json['enerjiMaliyeti'] as num?)?.toInt() ?? 3,
  gelirVaryansi: (json['gelirVaryansi'] as num?)?.toDouble() ?? 0.0,
  dovizOrani: (json['dovizOrani'] as num?)?.toDouble() ?? 0.0,
  acilanIsletmeler:
      (json['acilanIsletmeler'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  olayHavuzu:
      (json['olayHavuzu'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$MeslekToJson(_Meslek instance) => <String, dynamic>{
  'id': instance.id,
  'ad': instance.ad,
  'sektor': _$SektorEnumMap[instance.sektor]!,
  'girisSarti': instance.girisSarti,
  'kademeler': instance.kademeler,
  'yetkinlikArtisHizi': instance.yetkinlikArtisHizi,
  'networkArtisi': instance.networkArtisi,
  'enerjiMaliyeti': instance.enerjiMaliyeti,
  'gelirVaryansi': instance.gelirVaryansi,
  'dovizOrani': instance.dovizOrani,
  'acilanIsletmeler': instance.acilanIsletmeler,
  'olayHavuzu': instance.olayHavuzu,
};

const _$SektorEnumMap = {
  Sektor.saglik: 'saglik',
  Sektor.teknoloji: 'teknoloji',
  Sektor.hukukKamu: 'hukuk_kamu',
  Sektor.finans: 'finans',
  Sektor.ticaret: 'ticaret',
  Sektor.esnaf: 'esnaf',
  Sektor.medya: 'medya',
  Sektor.lojistik: 'lojistik',
  Sektor.tarim: 'tarim',
  Sektor.turizm: 'turizm',
};
