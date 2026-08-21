// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oyuncu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Oyuncu _$OyuncuFromJson(Map<String, dynamic> json) => _Oyuncu(
  ad: json['ad'] as String,
  sehir: json['sehir'] as String,
  tur: (json['tur'] as num?)?.toInt() ?? 0,
  baslangicYasi:
      (json['baslangicYasi'] as num?)?.toInt() ??
      Oyuncu.baslangicYasiVarsayilan,
  nakit: (json['nakit'] as num?)?.toInt() ?? 0,
  enerji: (json['enerji'] as num?)?.toInt() ?? Oyuncu.enerjiTavan,
  mutluluk: (json['mutluluk'] as num?)?.toInt() ?? 70,
  itibar: (json['itibar'] as num?)?.toInt() ?? 5,
  krediNotu: (json['krediNotu'] as num?)?.toInt() ?? Oyuncu.krediNotuBaslangic,
  yetkinlikler:
      (json['yetkinlikler'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const <String, int>{},
);

Map<String, dynamic> _$OyuncuToJson(_Oyuncu instance) => <String, dynamic>{
  'ad': instance.ad,
  'sehir': instance.sehir,
  'tur': instance.tur,
  'baslangicYasi': instance.baslangicYasi,
  'nakit': instance.nakit,
  'enerji': instance.enerji,
  'mutluluk': instance.mutluluk,
  'itibar': instance.itibar,
  'krediNotu': instance.krediNotu,
  'yetkinlikler': instance.yetkinlikler,
};
