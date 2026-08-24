// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piyasa_durumu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PiyasaDurumu _$PiyasaDurumuFromJson(Map<String, dynamic> json) =>
    _PiyasaDurumu(
      rejim: $enumDecodeNullable(_$RejimEnumMap, json['rejim']) ?? Rejim.buyume,
      rejimSuresi: (json['rejimSuresi'] as num?)?.toInt() ?? 0,
      enflasyonEndeksi: (json['enflasyonEndeksi'] as num?)?.toDouble() ?? 1.0,
      sonAylikEnflasyon: (json['sonAylikEnflasyon'] as num?)?.toDouble() ?? 0.0,
      paraReformuSayisi: (json['paraReformuSayisi'] as num?)?.toInt() ?? 0,
      paraReformuYapildi: json['paraReformuYapildi'] as bool? ?? false,
      fiyatlar:
          (json['fiyatlar'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const <String, double>{},
      gecmis:
          (json['gecmis'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
            ),
          ) ??
          const <String, List<double>>{},
    );

Map<String, dynamic> _$PiyasaDurumuToJson(_PiyasaDurumu instance) =>
    <String, dynamic>{
      'rejim': _$RejimEnumMap[instance.rejim]!,
      'rejimSuresi': instance.rejimSuresi,
      'enflasyonEndeksi': instance.enflasyonEndeksi,
      'sonAylikEnflasyon': instance.sonAylikEnflasyon,
      'paraReformuSayisi': instance.paraReformuSayisi,
      'paraReformuYapildi': instance.paraReformuYapildi,
      'fiyatlar': instance.fiyatlar,
      'gecmis': instance.gecmis,
    };

const _$RejimEnumMap = {
  Rejim.buyume: 'buyume',
  Rejim.durgunluk: 'durgunluk',
  Rejim.kriz: 'kriz',
  Rejim.enflasyon: 'enflasyon',
};
