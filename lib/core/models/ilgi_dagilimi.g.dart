// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ilgi_dagilimi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IlgiDagilimi _$IlgiDagilimiFromJson(Map<String, dynamic> json) =>
    _IlgiDagilimi(
      puanlar:
          (json['puanlar'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const <String, int>{},
    );

Map<String, dynamic> _$IlgiDagilimiToJson(_IlgiDagilimi instance) =>
    <String, dynamic>{'puanlar': instance.puanlar};
