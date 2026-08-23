// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isletme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Kalem _$KalemFromJson(Map<String, dynamic> json) => _Kalem(
  ad: json['ad'] as String,
  tur: $enumDecodeNullable(_$KalemTuruEnumMap, json['tur']) ?? KalemTuru.sabit,
  taban: (json['taban'] as num?)?.toInt() ?? 0,
  statId: json['statId'] as String?,
  oran: (json['oran'] as num?)?.toDouble() ?? 0.0,
  periyotTur: (json['periyotTur'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$KalemToJson(_Kalem instance) => <String, dynamic>{
  'ad': instance.ad,
  'tur': _$KalemTuruEnumMap[instance.tur]!,
  'taban': instance.taban,
  'statId': instance.statId,
  'oran': instance.oran,
  'periyotTur': instance.periyotTur,
};

const _$KalemTuruEnumMap = {
  KalemTuru.sabit: 'sabit',
  KalemTuru.stataBagli: 'stata_bagli',
  KalemTuru.cirodanPay: 'cirodan_pay',
};

_IsletmeGirisSarti _$IsletmeGirisSartiFromJson(Map<String, dynamic> json) =>
    _IsletmeGirisSarti(
      sektor: $enumDecodeNullable(_$SektorEnumMap, json['sektor']),
      yetkinlik: (json['yetkinlik'] as num?)?.toInt() ?? 0,
      itibar: (json['itibar'] as num?)?.toInt() ?? 0,
      enAzYas: (json['enAzYas'] as num?)?.toInt() ?? 18,
    );

Map<String, dynamic> _$IsletmeGirisSartiToJson(_IsletmeGirisSarti instance) =>
    <String, dynamic>{
      'sektor': _$SektorEnumMap[instance.sektor],
      'yetkinlik': instance.yetkinlik,
      'itibar': instance.itibar,
      'enAzYas': instance.enAzYas,
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

_IsletmeTanimi _$IsletmeTanimiFromJson(Map<String, dynamic> json) =>
    _IsletmeTanimi(
      id: json['id'] as String,
      ad: json['ad'] as String,
      sermaye: (json['sermaye'] as num).toInt(),
      gelirler:
          (json['gelirler'] as List<dynamic>?)
              ?.map((e) => Kalem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Kalem>[],
      giderler:
          (json['giderler'] as List<dynamic>?)
              ?.map((e) => Kalem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Kalem>[],
      yonetimYuku: (json['yonetimYuku'] as num?)?.toInt() ?? 1,
      prestij: (json['prestij'] as num?)?.toDouble() ?? 0.0,
      baslangicStatlari:
          (json['baslangicStatlari'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const <String, int>{},
      olayHavuzu:
          (json['olayHavuzu'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      girisSarti: json['girisSarti'] == null
          ? const IsletmeGirisSarti()
          : IsletmeGirisSarti.fromJson(
              json['girisSarti'] as Map<String, dynamic>,
            ),
      ceoMaasi: (json['ceoMaasi'] as num).toInt(),
      ceoEtkinligi: (json['ceoEtkinligi'] as num?)?.toDouble() ?? 0.7,
      degerCarpani: (json['degerCarpani'] as num?)?.toDouble() ?? 3.0,
      satisSuresiTur: (json['satisSuresiTur'] as num?)?.toInt() ?? 3,
    );

Map<String, dynamic> _$IsletmeTanimiToJson(_IsletmeTanimi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ad': instance.ad,
      'sermaye': instance.sermaye,
      'gelirler': instance.gelirler,
      'giderler': instance.giderler,
      'yonetimYuku': instance.yonetimYuku,
      'prestij': instance.prestij,
      'baslangicStatlari': instance.baslangicStatlari,
      'olayHavuzu': instance.olayHavuzu,
      'girisSarti': instance.girisSarti,
      'ceoMaasi': instance.ceoMaasi,
      'ceoEtkinligi': instance.ceoEtkinligi,
      'degerCarpani': instance.degerCarpani,
      'satisSuresiTur': instance.satisSuresiTur,
    };

_Isletme _$IsletmeFromJson(Map<String, dynamic> json) => _Isletme(
  id: json['id'] as String,
  tanimId: json['tanimId'] as String,
  kurulusTuru: (json['kurulusTuru'] as num).toInt(),
  statlar:
      (json['statlar'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const <String, int>{},
  ceoVar: json['ceoVar'] as bool? ?? false,
  sonNetKar: (json['sonNetKar'] as num?)?.toInt() ?? 0,
  yillikNetKar: (json['yillikNetKar'] as num?)?.toInt() ?? 0,
  guncelDeger: (json['guncelDeger'] as num?)?.toInt() ?? 0,
  ihmalTuru: (json['ihmalTuru'] as num?)?.toInt() ?? 0,
  satisKalanTur: (json['satisKalanTur'] as num?)?.toInt(),
);

Map<String, dynamic> _$IsletmeToJson(_Isletme instance) => <String, dynamic>{
  'id': instance.id,
  'tanimId': instance.tanimId,
  'kurulusTuru': instance.kurulusTuru,
  'statlar': instance.statlar,
  'ceoVar': instance.ceoVar,
  'sonNetKar': instance.sonNetKar,
  'yillikNetKar': instance.yillikNetKar,
  'guncelDeger': instance.guncelDeger,
  'ihmalTuru': instance.ihmalTuru,
  'satisKalanTur': instance.satisKalanTur,
};
