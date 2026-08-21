// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kariyer_durumu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ogrenci _$OgrenciFromJson(Map<String, dynamic> json) => Ogrenci(
  hedef: $enumDecode(_$EgitimSeviyesiEnumMap, json['hedef']),
  kalanTur: (json['kalanTur'] as num).toInt(),
  $type: json['durum'] as String?,
);

Map<String, dynamic> _$OgrenciToJson(Ogrenci instance) => <String, dynamic>{
  'hedef': _$EgitimSeviyesiEnumMap[instance.hedef]!,
  'kalanTur': instance.kalanTur,
  'durum': instance.$type,
};

const _$EgitimSeviyesiEnumMap = {
  EgitimSeviyesi.ilkogretim: 'ilkogretim',
  EgitimSeviyesi.lise: 'lise',
  EgitimSeviyesi.onlisans: 'onlisans',
  EgitimSeviyesi.lisans: 'lisans',
  EgitimSeviyesi.yuksekLisans: 'yuksek_lisans',
  EgitimSeviyesi.doktora: 'doktora',
};

Calisan _$CalisanFromJson(Map<String, dynamic> json) => Calisan(
  meslekId: json['meslekId'] as String,
  kademeIndeksi: (json['kademeIndeksi'] as num?)?.toInt() ?? 0,
  kademeTuru: (json['kademeTuru'] as num?)?.toInt() ?? 0,
  kayitDisi: json['kayitDisi'] as bool? ?? false,
  $type: json['durum'] as String?,
);

Map<String, dynamic> _$CalisanToJson(Calisan instance) => <String, dynamic>{
  'meslekId': instance.meslekId,
  'kademeIndeksi': instance.kademeIndeksi,
  'kademeTuru': instance.kademeTuru,
  'kayitDisi': instance.kayitDisi,
  'durum': instance.$type,
};

Issiz _$IssizFromJson(Map<String, dynamic> json) => Issiz(
  gecenTur: (json['gecenTur'] as num?)?.toInt() ?? 0,
  atamaBekliyor: json['atamaBekliyor'] as bool? ?? false,
  $type: json['durum'] as String?,
);

Map<String, dynamic> _$IssizToJson(Issiz instance) => <String, dynamic>{
  'gecenTur': instance.gecenTur,
  'atamaBekliyor': instance.atamaBekliyor,
  'durum': instance.$type,
};

Askerlik _$AskerlikFromJson(Map<String, dynamic> json) => Askerlik(
  kalanTur: (json['kalanTur'] as num).toInt(),
  bedelli: json['bedelli'] as bool? ?? false,
  $type: json['durum'] as String?,
);

Map<String, dynamic> _$AskerlikToJson(Askerlik instance) => <String, dynamic>{
  'kalanTur': instance.kalanTur,
  'bedelli': instance.bedelli,
  'durum': instance.$type,
};

Emekli _$EmekliFromJson(Map<String, dynamic> json) => Emekli(
  tabanAylik: (json['tabanAylik'] as num).toInt(),
  $type: json['durum'] as String?,
);

Map<String, dynamic> _$EmekliToJson(Emekli instance) => <String, dynamic>{
  'tabanAylik': instance.tabanAylik,
  'durum': instance.$type,
};
