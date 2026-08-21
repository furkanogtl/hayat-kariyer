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
  cinsiyet:
      $enumDecodeNullable(_$CinsiyetEnumMap, json['cinsiyet']) ??
      Cinsiyet.erkek,
  egitim:
      $enumDecodeNullable(_$EgitimSeviyesiEnumMap, json['egitim']) ??
      EgitimSeviyesi.lise,
  kariyer: json['kariyer'] == null
      ? const KariyerDurumu.issiz()
      : KariyerDurumu.fromJson(json['kariyer'] as Map<String, dynamic>),
  nakit: (json['nakit'] as num?)?.toInt() ?? 0,
  enerji: (json['enerji'] as num?)?.toInt() ?? Oyuncu.enerjiTavan,
  mutluluk: (json['mutluluk'] as num?)?.toInt() ?? 70,
  itibar: (json['itibar'] as num?)?.toInt() ?? 5,
  krediNotu: (json['krediNotu'] as num?)?.toInt() ?? Oyuncu.krediNotuBaslangic,
  yetkinlikler:
      (json['yetkinlikler'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$SektorEnumMap, k), (e as num).toInt()),
      ) ??
      const <Sektor, int>{},
  sgkPrimAyi: (json['sgkPrimAyi'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$OyuncuToJson(_Oyuncu instance) => <String, dynamic>{
  'ad': instance.ad,
  'sehir': instance.sehir,
  'tur': instance.tur,
  'baslangicYasi': instance.baslangicYasi,
  'cinsiyet': _$CinsiyetEnumMap[instance.cinsiyet]!,
  'egitim': _$EgitimSeviyesiEnumMap[instance.egitim]!,
  'kariyer': instance.kariyer,
  'nakit': instance.nakit,
  'enerji': instance.enerji,
  'mutluluk': instance.mutluluk,
  'itibar': instance.itibar,
  'krediNotu': instance.krediNotu,
  'yetkinlikler': instance.yetkinlikler.map(
    (k, e) => MapEntry(_$SektorEnumMap[k]!, e),
  ),
  'sgkPrimAyi': instance.sgkPrimAyi,
};

const _$CinsiyetEnumMap = {Cinsiyet.erkek: 'erkek', Cinsiyet.kadin: 'kadin'};

const _$EgitimSeviyesiEnumMap = {
  EgitimSeviyesi.ilkogretim: 'ilkogretim',
  EgitimSeviyesi.lise: 'lise',
  EgitimSeviyesi.onlisans: 'onlisans',
  EgitimSeviyesi.lisans: 'lisans',
  EgitimSeviyesi.yuksekLisans: 'yuksek_lisans',
  EgitimSeviyesi.doktora: 'doktora',
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
