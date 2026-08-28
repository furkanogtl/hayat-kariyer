// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'olay.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OlayEtkileri _$OlayEtkileriFromJson(Map<String, dynamic> json) =>
    _OlayEtkileri(
      nakit: (json['nakit'] as num?)?.toInt() ?? 0,
      enerji: (json['enerji'] as num?)?.toInt() ?? 0,
      mutluluk: (json['mutluluk'] as num?)?.toInt() ?? 0,
      itibar: (json['itibar'] as num?)?.toInt() ?? 0,
      krediNotu: (json['krediNotu'] as num?)?.toInt() ?? 0,
      yetkinlik:
          (json['yetkinlik'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry($enumDecode(_$SektorEnumMap, k), (e as num).toInt()),
          ) ??
          const <Sektor, int>{},
      fiyatCarpani:
          (json['fiyatCarpani'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const <String, double>{},
      varlik:
          (json['varlik'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const <String, double>{},
      isletmeStat:
          (json['isletmeStat'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const <String, int>{},
    );

Map<String, dynamic> _$OlayEtkileriToJson(_OlayEtkileri instance) =>
    <String, dynamic>{
      'nakit': instance.nakit,
      'enerji': instance.enerji,
      'mutluluk': instance.mutluluk,
      'itibar': instance.itibar,
      'krediNotu': instance.krediNotu,
      'yetkinlik': instance.yetkinlik.map(
        (k, e) => MapEntry(_$SektorEnumMap[k]!, e),
      ),
      'fiyatCarpani': instance.fiyatCarpani,
      'varlik': instance.varlik,
      'isletmeStat': instance.isletmeStat,
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

_OlaySonucu _$OlaySonucuFromJson(Map<String, dynamic> json) => _OlaySonucu(
  sans: (json['sans'] as num).toDouble(),
  metin: json['metin'] as String,
  etkiler: json['etkiler'] == null
      ? const OlayEtkileri()
      : OlayEtkileri.fromJson(json['etkiler'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OlaySonucuToJson(_OlaySonucu instance) =>
    <String, dynamic>{
      'sans': instance.sans,
      'metin': instance.metin,
      'etkiler': instance.etkiler,
    };

_OlaySecenegi _$OlaySecenegiFromJson(Map<String, dynamic> json) =>
    _OlaySecenegi(
      etiket: json['etiket'] as String,
      etkiler: json['etkiler'] == null
          ? const OlayEtkileri()
          : OlayEtkileri.fromJson(json['etkiler'] as Map<String, dynamic>),
      sonuclar:
          (json['sonuclar'] as List<dynamic>?)
              ?.map((e) => OlaySonucu.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <OlaySonucu>[],
      gecikmeTuru: (json['gecikmeTuru'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$OlaySecenegiToJson(_OlaySecenegi instance) =>
    <String, dynamic>{
      'etiket': instance.etiket,
      'etkiler': instance.etkiler,
      'sonuclar': instance.sonuclar,
      'gecikmeTuru': instance.gecikmeTuru,
    };

_OlayKosullari _$OlayKosullariFromJson(Map<String, dynamic> json) =>
    _OlayKosullari(
      enAzItibar: (json['enAzItibar'] as num?)?.toInt(),
      enAzNakit: (json['enAzNakit'] as num?)?.toInt(),
      enAzEnerji: (json['enAzEnerji'] as num?)?.toInt(),
      enAzMutluluk: (json['enAzMutluluk'] as num?)?.toInt(),
      enAzKrediNotu: (json['enAzKrediNotu'] as num?)?.toInt(),
      enCokNakit: (json['enCokNakit'] as num?)?.toInt(),
      enAzNetDeger: (json['enAzNetDeger'] as num?)?.toInt(),
      enCokNetDeger: (json['enCokNetDeger'] as num?)?.toInt(),
      enCokKrediNotu: (json['enCokKrediNotu'] as num?)?.toInt(),
      yasAraligi: (json['yas'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      sehirler: (json['sehirler'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$SehirEnumMap, e))
          .toList(),
      meslekler: (json['meslekler'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sektorler: (json['sektorler'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$SektorEnumMap, e))
          .toList(),
      rejimler: (json['rejimler'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$RejimEnumMap, e))
          .toList(),
      durumlar: (json['durumlar'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$KariyerTuruEnumMap, e))
          .toList(),
      cinsiyet: $enumDecodeNullable(_$CinsiyetEnumMap, json['cinsiyet']),
      enAzEgitim: $enumDecodeNullable(
        _$EgitimSeviyesiEnumMap,
        json['enAzEgitim'],
      ),
      enAzIhmalTuru: (json['enAzIhmalTuru'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OlayKosullariToJson(
  _OlayKosullari instance,
) => <String, dynamic>{
  'enAzItibar': instance.enAzItibar,
  'enAzNakit': instance.enAzNakit,
  'enAzEnerji': instance.enAzEnerji,
  'enAzMutluluk': instance.enAzMutluluk,
  'enAzKrediNotu': instance.enAzKrediNotu,
  'enCokNakit': instance.enCokNakit,
  'enAzNetDeger': instance.enAzNetDeger,
  'enCokNetDeger': instance.enCokNetDeger,
  'enCokKrediNotu': instance.enCokKrediNotu,
  'yas': instance.yasAraligi,
  'sehirler': instance.sehirler?.map((e) => _$SehirEnumMap[e]!).toList(),
  'meslekler': instance.meslekler,
  'sektorler': instance.sektorler?.map((e) => _$SektorEnumMap[e]!).toList(),
  'rejimler': instance.rejimler?.map((e) => _$RejimEnumMap[e]!).toList(),
  'durumlar': instance.durumlar?.map((e) => _$KariyerTuruEnumMap[e]!).toList(),
  'cinsiyet': _$CinsiyetEnumMap[instance.cinsiyet],
  'enAzEgitim': _$EgitimSeviyesiEnumMap[instance.enAzEgitim],
  'enAzIhmalTuru': instance.enAzIhmalTuru,
};

const _$SehirEnumMap = {
  Sehir.istanbul: 'istanbul',
  Sehir.izmir: 'izmir',
  Sehir.gaziantep: 'gaziantep',
  Sehir.trabzon: 'trabzon',
  Sehir.konya: 'konya',
};

const _$RejimEnumMap = {
  Rejim.buyume: 'buyume',
  Rejim.durgunluk: 'durgunluk',
  Rejim.kriz: 'kriz',
  Rejim.enflasyon: 'enflasyon',
};

const _$KariyerTuruEnumMap = {
  KariyerTuru.ogrenci: 'ogrenci',
  KariyerTuru.calisan: 'calisan',
  KariyerTuru.issiz: 'issiz',
  KariyerTuru.askerlik: 'askerlik',
  KariyerTuru.emekli: 'emekli',
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

_BekleyenOlay _$BekleyenOlayFromJson(Map<String, dynamic> json) =>
    _BekleyenOlay(
      olayId: json['olayId'] as String,
      secenekIndeksi: (json['secenekIndeksi'] as num).toInt(),
      kalanTur: (json['kalanTur'] as num).toInt(),
      hedefIsletmeId: json['hedefIsletmeId'] as String?,
    );

Map<String, dynamic> _$BekleyenOlayToJson(_BekleyenOlay instance) =>
    <String, dynamic>{
      'olayId': instance.olayId,
      'secenekIndeksi': instance.secenekIndeksi,
      'kalanTur': instance.kalanTur,
      'hedefIsletmeId': instance.hedefIsletmeId,
    };

_Olay _$OlayFromJson(Map<String, dynamic> json) => _Olay(
  id: json['id'] as String,
  baslik: json['baslik'] as String,
  metin: json['metin'] as String,
  tur: $enumDecodeNullable(_$OlayTuruEnumMap, json['tur']) ?? OlayTuru.hayat,
  kosullar: json['kosullar'] == null
      ? const OlayKosullari()
      : OlayKosullari.fromJson(json['kosullar'] as Map<String, dynamic>),
  agirlik: (json['agirlik'] as num?)?.toDouble() ?? 10.0,
  tekSeferlik: json['tekSeferlik'] as bool? ?? false,
  bekleme: (json['bekleme'] as num?)?.toInt() ?? 60,
  olcekli: json['olcekli'] as bool? ?? false,
  secenekler: (json['secenekler'] as List<dynamic>)
      .map((e) => OlaySecenegi.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OlayToJson(_Olay instance) => <String, dynamic>{
  'id': instance.id,
  'baslik': instance.baslik,
  'metin': instance.metin,
  'tur': _$OlayTuruEnumMap[instance.tur]!,
  'kosullar': instance.kosullar,
  'agirlik': instance.agirlik,
  'tekSeferlik': instance.tekSeferlik,
  'bekleme': instance.bekleme,
  'olcekli': instance.olcekli,
  'secenekler': instance.secenekler,
};

const _$OlayTuruEnumMap = {
  OlayTuru.firsat: 'firsat',
  OlayTuru.kriz: 'kriz',
  OlayTuru.teklif: 'teklif',
  OlayTuru.hayat: 'hayat',
};
