// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oyun_durumu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OyunDurumu _$OyunDurumuFromJson(Map<String, dynamic> json) => _OyunDurumu(
  anaTohum: (json['anaTohum'] as num).toInt(),
  oyuncu: Oyuncu.fromJson(json['oyuncu'] as Map<String, dynamic>),
  piyasa: PiyasaDurumu.fromJson(json['piyasa'] as Map<String, dynamic>),
  portfoy: json['portfoy'] == null
      ? const Portfoy()
      : Portfoy.fromJson(json['portfoy'] as Map<String, dynamic>),
  bekleyenOlaylar:
      (json['bekleyenOlaylar'] as List<dynamic>?)
          ?.map((e) => BekleyenOlay.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <BekleyenOlay>[],
  olayGecmisi:
      (json['olayGecmisi'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const <String, int>{},
  maasEndeksi: (json['maasEndeksi'] as num?)?.toDouble() ?? 1.0,
  kayitSurumu: (json['kayitSurumu'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$OyunDurumuToJson(_OyunDurumu instance) =>
    <String, dynamic>{
      'anaTohum': instance.anaTohum,
      'oyuncu': instance.oyuncu,
      'piyasa': instance.piyasa,
      'portfoy': instance.portfoy,
      'bekleyenOlaylar': instance.bekleyenOlaylar,
      'olayGecmisi': instance.olayGecmisi,
      'maasEndeksi': instance.maasEndeksi,
      'kayitSurumu': instance.kayitSurumu,
    };
