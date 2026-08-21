// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kariyer_durumu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
KariyerDurumu _$KariyerDurumuFromJson(
  Map<String, dynamic> json
) {
        switch (json['durum']) {
                  case 'ogrenci':
          return Ogrenci.fromJson(
            json
          );
                case 'calisan':
          return Calisan.fromJson(
            json
          );
                case 'issiz':
          return Issiz.fromJson(
            json
          );
                case 'askerlik':
          return Askerlik.fromJson(
            json
          );
                case 'emekli':
          return Emekli.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'durum',
  'KariyerDurumu',
  'Invalid union type "${json['durum']}"!'
);
        }
      
}

/// @nodoc
mixin _$KariyerDurumu {



  /// Serializes this KariyerDurumu to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KariyerDurumu);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KariyerDurumu()';
}


}

/// @nodoc
class $KariyerDurumuCopyWith<$Res>  {
$KariyerDurumuCopyWith(KariyerDurumu _, $Res Function(KariyerDurumu) __);
}


/// Adds pattern-matching-related methods to [KariyerDurumu].
extension KariyerDurumuPatterns on KariyerDurumu {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Ogrenci value)?  ogrenci,TResult Function( Calisan value)?  calisan,TResult Function( Issiz value)?  issiz,TResult Function( Askerlik value)?  askerlik,TResult Function( Emekli value)?  emekli,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Ogrenci() when ogrenci != null:
return ogrenci(_that);case Calisan() when calisan != null:
return calisan(_that);case Issiz() when issiz != null:
return issiz(_that);case Askerlik() when askerlik != null:
return askerlik(_that);case Emekli() when emekli != null:
return emekli(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Ogrenci value)  ogrenci,required TResult Function( Calisan value)  calisan,required TResult Function( Issiz value)  issiz,required TResult Function( Askerlik value)  askerlik,required TResult Function( Emekli value)  emekli,}){
final _that = this;
switch (_that) {
case Ogrenci():
return ogrenci(_that);case Calisan():
return calisan(_that);case Issiz():
return issiz(_that);case Askerlik():
return askerlik(_that);case Emekli():
return emekli(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Ogrenci value)?  ogrenci,TResult? Function( Calisan value)?  calisan,TResult? Function( Issiz value)?  issiz,TResult? Function( Askerlik value)?  askerlik,TResult? Function( Emekli value)?  emekli,}){
final _that = this;
switch (_that) {
case Ogrenci() when ogrenci != null:
return ogrenci(_that);case Calisan() when calisan != null:
return calisan(_that);case Issiz() when issiz != null:
return issiz(_that);case Askerlik() when askerlik != null:
return askerlik(_that);case Emekli() when emekli != null:
return emekli(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( EgitimSeviyesi hedef,  int kalanTur)?  ogrenci,TResult Function( String meslekId,  int kademeIndeksi,  int kademeTuru,  bool kayitDisi)?  calisan,TResult Function( int gecenTur,  bool atamaBekliyor)?  issiz,TResult Function( int kalanTur,  bool bedelli)?  askerlik,TResult Function( int tabanAylik)?  emekli,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Ogrenci() when ogrenci != null:
return ogrenci(_that.hedef,_that.kalanTur);case Calisan() when calisan != null:
return calisan(_that.meslekId,_that.kademeIndeksi,_that.kademeTuru,_that.kayitDisi);case Issiz() when issiz != null:
return issiz(_that.gecenTur,_that.atamaBekliyor);case Askerlik() when askerlik != null:
return askerlik(_that.kalanTur,_that.bedelli);case Emekli() when emekli != null:
return emekli(_that.tabanAylik);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( EgitimSeviyesi hedef,  int kalanTur)  ogrenci,required TResult Function( String meslekId,  int kademeIndeksi,  int kademeTuru,  bool kayitDisi)  calisan,required TResult Function( int gecenTur,  bool atamaBekliyor)  issiz,required TResult Function( int kalanTur,  bool bedelli)  askerlik,required TResult Function( int tabanAylik)  emekli,}) {final _that = this;
switch (_that) {
case Ogrenci():
return ogrenci(_that.hedef,_that.kalanTur);case Calisan():
return calisan(_that.meslekId,_that.kademeIndeksi,_that.kademeTuru,_that.kayitDisi);case Issiz():
return issiz(_that.gecenTur,_that.atamaBekliyor);case Askerlik():
return askerlik(_that.kalanTur,_that.bedelli);case Emekli():
return emekli(_that.tabanAylik);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( EgitimSeviyesi hedef,  int kalanTur)?  ogrenci,TResult? Function( String meslekId,  int kademeIndeksi,  int kademeTuru,  bool kayitDisi)?  calisan,TResult? Function( int gecenTur,  bool atamaBekliyor)?  issiz,TResult? Function( int kalanTur,  bool bedelli)?  askerlik,TResult? Function( int tabanAylik)?  emekli,}) {final _that = this;
switch (_that) {
case Ogrenci() when ogrenci != null:
return ogrenci(_that.hedef,_that.kalanTur);case Calisan() when calisan != null:
return calisan(_that.meslekId,_that.kademeIndeksi,_that.kademeTuru,_that.kayitDisi);case Issiz() when issiz != null:
return issiz(_that.gecenTur,_that.atamaBekliyor);case Askerlik() when askerlik != null:
return askerlik(_that.kalanTur,_that.bedelli);case Emekli() when emekli != null:
return emekli(_that.tabanAylik);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class Ogrenci extends KariyerDurumu {
  const Ogrenci({required this.hedef, required this.kalanTur, final  String? $type}): $type = $type ?? 'ogrenci',super._();
  factory Ogrenci.fromJson(Map<String, dynamic> json) => _$OgrenciFromJson(json);

 final  EgitimSeviyesi hedef;
/// Mezuniyete kalan tur.
 final  int kalanTur;

@JsonKey(name: 'durum')
final String $type;


/// Create a copy of KariyerDurumu
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OgrenciCopyWith<Ogrenci> get copyWith => _$OgrenciCopyWithImpl<Ogrenci>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OgrenciToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ogrenci&&(identical(other.hedef, hedef) || other.hedef == hedef)&&(identical(other.kalanTur, kalanTur) || other.kalanTur == kalanTur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hedef,kalanTur);

@override
String toString() {
  return 'KariyerDurumu.ogrenci(hedef: $hedef, kalanTur: $kalanTur)';
}


}

/// @nodoc
abstract mixin class $OgrenciCopyWith<$Res> implements $KariyerDurumuCopyWith<$Res> {
  factory $OgrenciCopyWith(Ogrenci value, $Res Function(Ogrenci) _then) = _$OgrenciCopyWithImpl;
@useResult
$Res call({
 EgitimSeviyesi hedef, int kalanTur
});




}
/// @nodoc
class _$OgrenciCopyWithImpl<$Res>
    implements $OgrenciCopyWith<$Res> {
  _$OgrenciCopyWithImpl(this._self, this._then);

  final Ogrenci _self;
  final $Res Function(Ogrenci) _then;

/// Create a copy of KariyerDurumu
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hedef = null,Object? kalanTur = null,}) {
  return _then(Ogrenci(
hedef: null == hedef ? _self.hedef : hedef // ignore: cast_nullable_to_non_nullable
as EgitimSeviyesi,kalanTur: null == kalanTur ? _self.kalanTur : kalanTur // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class Calisan extends KariyerDurumu {
  const Calisan({required this.meslekId, this.kademeIndeksi = 0, this.kademeTuru = 0, this.kayitDisi = false, final  String? $type}): $type = $type ?? 'calisan',super._();
  factory Calisan.fromJson(Map<String, dynamic> json) => _$CalisanFromJson(json);

/// `assets/careers/*.json` içindeki meslek kimliği.
 final  String meslekId;
/// Kariyer merdivenindeki basamak indeksi.
@JsonKey() final  int kademeIndeksi;
/// Bu kademede geçirilen tur sayısı. Terfinin kıdem kapısı buna bakar.
@JsonKey() final  int kademeTuru;
/// Kayıt dışı çalışma: net gelir yüksek, SGK primi yok, koruma yok.
@JsonKey() final  bool kayitDisi;

@JsonKey(name: 'durum')
final String $type;


/// Create a copy of KariyerDurumu
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalisanCopyWith<Calisan> get copyWith => _$CalisanCopyWithImpl<Calisan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalisanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Calisan&&(identical(other.meslekId, meslekId) || other.meslekId == meslekId)&&(identical(other.kademeIndeksi, kademeIndeksi) || other.kademeIndeksi == kademeIndeksi)&&(identical(other.kademeTuru, kademeTuru) || other.kademeTuru == kademeTuru)&&(identical(other.kayitDisi, kayitDisi) || other.kayitDisi == kayitDisi));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,meslekId,kademeIndeksi,kademeTuru,kayitDisi);

@override
String toString() {
  return 'KariyerDurumu.calisan(meslekId: $meslekId, kademeIndeksi: $kademeIndeksi, kademeTuru: $kademeTuru, kayitDisi: $kayitDisi)';
}


}

/// @nodoc
abstract mixin class $CalisanCopyWith<$Res> implements $KariyerDurumuCopyWith<$Res> {
  factory $CalisanCopyWith(Calisan value, $Res Function(Calisan) _then) = _$CalisanCopyWithImpl;
@useResult
$Res call({
 String meslekId, int kademeIndeksi, int kademeTuru, bool kayitDisi
});




}
/// @nodoc
class _$CalisanCopyWithImpl<$Res>
    implements $CalisanCopyWith<$Res> {
  _$CalisanCopyWithImpl(this._self, this._then);

  final Calisan _self;
  final $Res Function(Calisan) _then;

/// Create a copy of KariyerDurumu
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? meslekId = null,Object? kademeIndeksi = null,Object? kademeTuru = null,Object? kayitDisi = null,}) {
  return _then(Calisan(
meslekId: null == meslekId ? _self.meslekId : meslekId // ignore: cast_nullable_to_non_nullable
as String,kademeIndeksi: null == kademeIndeksi ? _self.kademeIndeksi : kademeIndeksi // ignore: cast_nullable_to_non_nullable
as int,kademeTuru: null == kademeTuru ? _self.kademeTuru : kademeTuru // ignore: cast_nullable_to_non_nullable
as int,kayitDisi: null == kayitDisi ? _self.kayitDisi : kayitDisi // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class Issiz extends KariyerDurumu {
  const Issiz({this.gecenTur = 0, this.atamaBekliyor = false, final  String? $type}): $type = $type ?? 'issiz',super._();
  factory Issiz.fromJson(Map<String, dynamic> json) => _$IssizFromJson(json);

@JsonKey() final  int gecenTur;
/// Atama bekleyen öğretmen/memur bu bayrakla işaretlenir; işsizlikten
/// farklı olay havuzu ve farklı çıkış yolu kullanır.
@JsonKey() final  bool atamaBekliyor;

@JsonKey(name: 'durum')
final String $type;


/// Create a copy of KariyerDurumu
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssizCopyWith<Issiz> get copyWith => _$IssizCopyWithImpl<Issiz>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IssizToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Issiz&&(identical(other.gecenTur, gecenTur) || other.gecenTur == gecenTur)&&(identical(other.atamaBekliyor, atamaBekliyor) || other.atamaBekliyor == atamaBekliyor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gecenTur,atamaBekliyor);

@override
String toString() {
  return 'KariyerDurumu.issiz(gecenTur: $gecenTur, atamaBekliyor: $atamaBekliyor)';
}


}

/// @nodoc
abstract mixin class $IssizCopyWith<$Res> implements $KariyerDurumuCopyWith<$Res> {
  factory $IssizCopyWith(Issiz value, $Res Function(Issiz) _then) = _$IssizCopyWithImpl;
@useResult
$Res call({
 int gecenTur, bool atamaBekliyor
});




}
/// @nodoc
class _$IssizCopyWithImpl<$Res>
    implements $IssizCopyWith<$Res> {
  _$IssizCopyWithImpl(this._self, this._then);

  final Issiz _self;
  final $Res Function(Issiz) _then;

/// Create a copy of KariyerDurumu
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? gecenTur = null,Object? atamaBekliyor = null,}) {
  return _then(Issiz(
gecenTur: null == gecenTur ? _self.gecenTur : gecenTur // ignore: cast_nullable_to_non_nullable
as int,atamaBekliyor: null == atamaBekliyor ? _self.atamaBekliyor : atamaBekliyor // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class Askerlik extends KariyerDurumu {
  const Askerlik({required this.kalanTur, this.bedelli = false, final  String? $type}): $type = $type ?? 'askerlik',super._();
  factory Askerlik.fromJson(Map<String, dynamic> json) => _$AskerlikFromJson(json);

 final  int kalanTur;
/// Bedelli askerlik mi (para ödendi, süre kısa).
@JsonKey() final  bool bedelli;

@JsonKey(name: 'durum')
final String $type;


/// Create a copy of KariyerDurumu
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AskerlikCopyWith<Askerlik> get copyWith => _$AskerlikCopyWithImpl<Askerlik>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AskerlikToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Askerlik&&(identical(other.kalanTur, kalanTur) || other.kalanTur == kalanTur)&&(identical(other.bedelli, bedelli) || other.bedelli == bedelli));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kalanTur,bedelli);

@override
String toString() {
  return 'KariyerDurumu.askerlik(kalanTur: $kalanTur, bedelli: $bedelli)';
}


}

/// @nodoc
abstract mixin class $AskerlikCopyWith<$Res> implements $KariyerDurumuCopyWith<$Res> {
  factory $AskerlikCopyWith(Askerlik value, $Res Function(Askerlik) _then) = _$AskerlikCopyWithImpl;
@useResult
$Res call({
 int kalanTur, bool bedelli
});




}
/// @nodoc
class _$AskerlikCopyWithImpl<$Res>
    implements $AskerlikCopyWith<$Res> {
  _$AskerlikCopyWithImpl(this._self, this._then);

  final Askerlik _self;
  final $Res Function(Askerlik) _then;

/// Create a copy of KariyerDurumu
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kalanTur = null,Object? bedelli = null,}) {
  return _then(Askerlik(
kalanTur: null == kalanTur ? _self.kalanTur : kalanTur // ignore: cast_nullable_to_non_nullable
as int,bedelli: null == bedelli ? _self.bedelli : bedelli // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class Emekli extends KariyerDurumu {
  const Emekli({required this.tabanAylik, final  String? $type}): $type = $type ?? 'emekli',super._();
  factory Emekli.fromJson(Map<String, dynamic> json) => _$EmekliFromJson(json);

/// Emeklilik anında hesaplanan taban aylık (enflasyon endeksi ayrıca
/// uygulanır).
 final  int tabanAylik;

@JsonKey(name: 'durum')
final String $type;


/// Create a copy of KariyerDurumu
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmekliCopyWith<Emekli> get copyWith => _$EmekliCopyWithImpl<Emekli>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmekliToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Emekli&&(identical(other.tabanAylik, tabanAylik) || other.tabanAylik == tabanAylik));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tabanAylik);

@override
String toString() {
  return 'KariyerDurumu.emekli(tabanAylik: $tabanAylik)';
}


}

/// @nodoc
abstract mixin class $EmekliCopyWith<$Res> implements $KariyerDurumuCopyWith<$Res> {
  factory $EmekliCopyWith(Emekli value, $Res Function(Emekli) _then) = _$EmekliCopyWithImpl;
@useResult
$Res call({
 int tabanAylik
});




}
/// @nodoc
class _$EmekliCopyWithImpl<$Res>
    implements $EmekliCopyWith<$Res> {
  _$EmekliCopyWithImpl(this._self, this._then);

  final Emekli _self;
  final $Res Function(Emekli) _then;

/// Create a copy of KariyerDurumu
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tabanAylik = null,}) {
  return _then(Emekli(
tabanAylik: null == tabanAylik ? _self.tabanAylik : tabanAylik // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
