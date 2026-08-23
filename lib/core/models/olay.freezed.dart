// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'olay.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OlayEtkileri {

 int get nakit; int get enerji; int get mutluluk; int get itibar; int get krediNotu;/// Sektör bazlı yetkinlik değişimi.
 Map<Sektor, int> get yetkinlik;/// Piyasaya müdahale: `{"arsa": 6.0}` imar haberi.
 Map<String, double> get fiyatCarpani;/// Portföye eklenen (ya da eksiyle çıkarılan) adet.
 Map<String, double> get varlik;
/// Create a copy of OlayEtkileri
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OlayEtkileriCopyWith<OlayEtkileri> get copyWith => _$OlayEtkileriCopyWithImpl<OlayEtkileri>(this as OlayEtkileri, _$identity);

  /// Serializes this OlayEtkileri to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OlayEtkileri&&(identical(other.nakit, nakit) || other.nakit == nakit)&&(identical(other.enerji, enerji) || other.enerji == enerji)&&(identical(other.mutluluk, mutluluk) || other.mutluluk == mutluluk)&&(identical(other.itibar, itibar) || other.itibar == itibar)&&(identical(other.krediNotu, krediNotu) || other.krediNotu == krediNotu)&&const DeepCollectionEquality().equals(other.yetkinlik, yetkinlik)&&const DeepCollectionEquality().equals(other.fiyatCarpani, fiyatCarpani)&&const DeepCollectionEquality().equals(other.varlik, varlik));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nakit,enerji,mutluluk,itibar,krediNotu,const DeepCollectionEquality().hash(yetkinlik),const DeepCollectionEquality().hash(fiyatCarpani),const DeepCollectionEquality().hash(varlik));

@override
String toString() {
  return 'OlayEtkileri(nakit: $nakit, enerji: $enerji, mutluluk: $mutluluk, itibar: $itibar, krediNotu: $krediNotu, yetkinlik: $yetkinlik, fiyatCarpani: $fiyatCarpani, varlik: $varlik)';
}


}

/// @nodoc
abstract mixin class $OlayEtkileriCopyWith<$Res>  {
  factory $OlayEtkileriCopyWith(OlayEtkileri value, $Res Function(OlayEtkileri) _then) = _$OlayEtkileriCopyWithImpl;
@useResult
$Res call({
 int nakit, int enerji, int mutluluk, int itibar, int krediNotu, Map<Sektor, int> yetkinlik, Map<String, double> fiyatCarpani, Map<String, double> varlik
});




}
/// @nodoc
class _$OlayEtkileriCopyWithImpl<$Res>
    implements $OlayEtkileriCopyWith<$Res> {
  _$OlayEtkileriCopyWithImpl(this._self, this._then);

  final OlayEtkileri _self;
  final $Res Function(OlayEtkileri) _then;

/// Create a copy of OlayEtkileri
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nakit = null,Object? enerji = null,Object? mutluluk = null,Object? itibar = null,Object? krediNotu = null,Object? yetkinlik = null,Object? fiyatCarpani = null,Object? varlik = null,}) {
  return _then(_self.copyWith(
nakit: null == nakit ? _self.nakit : nakit // ignore: cast_nullable_to_non_nullable
as int,enerji: null == enerji ? _self.enerji : enerji // ignore: cast_nullable_to_non_nullable
as int,mutluluk: null == mutluluk ? _self.mutluluk : mutluluk // ignore: cast_nullable_to_non_nullable
as int,itibar: null == itibar ? _self.itibar : itibar // ignore: cast_nullable_to_non_nullable
as int,krediNotu: null == krediNotu ? _self.krediNotu : krediNotu // ignore: cast_nullable_to_non_nullable
as int,yetkinlik: null == yetkinlik ? _self.yetkinlik : yetkinlik // ignore: cast_nullable_to_non_nullable
as Map<Sektor, int>,fiyatCarpani: null == fiyatCarpani ? _self.fiyatCarpani : fiyatCarpani // ignore: cast_nullable_to_non_nullable
as Map<String, double>,varlik: null == varlik ? _self.varlik : varlik // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [OlayEtkileri].
extension OlayEtkileriPatterns on OlayEtkileri {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OlayEtkileri value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OlayEtkileri() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OlayEtkileri value)  $default,){
final _that = this;
switch (_that) {
case _OlayEtkileri():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OlayEtkileri value)?  $default,){
final _that = this;
switch (_that) {
case _OlayEtkileri() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int nakit,  int enerji,  int mutluluk,  int itibar,  int krediNotu,  Map<Sektor, int> yetkinlik,  Map<String, double> fiyatCarpani,  Map<String, double> varlik)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OlayEtkileri() when $default != null:
return $default(_that.nakit,_that.enerji,_that.mutluluk,_that.itibar,_that.krediNotu,_that.yetkinlik,_that.fiyatCarpani,_that.varlik);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int nakit,  int enerji,  int mutluluk,  int itibar,  int krediNotu,  Map<Sektor, int> yetkinlik,  Map<String, double> fiyatCarpani,  Map<String, double> varlik)  $default,) {final _that = this;
switch (_that) {
case _OlayEtkileri():
return $default(_that.nakit,_that.enerji,_that.mutluluk,_that.itibar,_that.krediNotu,_that.yetkinlik,_that.fiyatCarpani,_that.varlik);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int nakit,  int enerji,  int mutluluk,  int itibar,  int krediNotu,  Map<Sektor, int> yetkinlik,  Map<String, double> fiyatCarpani,  Map<String, double> varlik)?  $default,) {final _that = this;
switch (_that) {
case _OlayEtkileri() when $default != null:
return $default(_that.nakit,_that.enerji,_that.mutluluk,_that.itibar,_that.krediNotu,_that.yetkinlik,_that.fiyatCarpani,_that.varlik);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OlayEtkileri extends OlayEtkileri {
  const _OlayEtkileri({this.nakit = 0, this.enerji = 0, this.mutluluk = 0, this.itibar = 0, this.krediNotu = 0, final  Map<Sektor, int> yetkinlik = const <Sektor, int>{}, final  Map<String, double> fiyatCarpani = const <String, double>{}, final  Map<String, double> varlik = const <String, double>{}}): _yetkinlik = yetkinlik,_fiyatCarpani = fiyatCarpani,_varlik = varlik,super._();
  factory _OlayEtkileri.fromJson(Map<String, dynamic> json) => _$OlayEtkileriFromJson(json);

@override@JsonKey() final  int nakit;
@override@JsonKey() final  int enerji;
@override@JsonKey() final  int mutluluk;
@override@JsonKey() final  int itibar;
@override@JsonKey() final  int krediNotu;
/// Sektör bazlı yetkinlik değişimi.
 final  Map<Sektor, int> _yetkinlik;
/// Sektör bazlı yetkinlik değişimi.
@override@JsonKey() Map<Sektor, int> get yetkinlik {
  if (_yetkinlik is EqualUnmodifiableMapView) return _yetkinlik;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_yetkinlik);
}

/// Piyasaya müdahale: `{"arsa": 6.0}` imar haberi.
 final  Map<String, double> _fiyatCarpani;
/// Piyasaya müdahale: `{"arsa": 6.0}` imar haberi.
@override@JsonKey() Map<String, double> get fiyatCarpani {
  if (_fiyatCarpani is EqualUnmodifiableMapView) return _fiyatCarpani;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fiyatCarpani);
}

/// Portföye eklenen (ya da eksiyle çıkarılan) adet.
 final  Map<String, double> _varlik;
/// Portföye eklenen (ya da eksiyle çıkarılan) adet.
@override@JsonKey() Map<String, double> get varlik {
  if (_varlik is EqualUnmodifiableMapView) return _varlik;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_varlik);
}


/// Create a copy of OlayEtkileri
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OlayEtkileriCopyWith<_OlayEtkileri> get copyWith => __$OlayEtkileriCopyWithImpl<_OlayEtkileri>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OlayEtkileriToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OlayEtkileri&&(identical(other.nakit, nakit) || other.nakit == nakit)&&(identical(other.enerji, enerji) || other.enerji == enerji)&&(identical(other.mutluluk, mutluluk) || other.mutluluk == mutluluk)&&(identical(other.itibar, itibar) || other.itibar == itibar)&&(identical(other.krediNotu, krediNotu) || other.krediNotu == krediNotu)&&const DeepCollectionEquality().equals(other._yetkinlik, _yetkinlik)&&const DeepCollectionEquality().equals(other._fiyatCarpani, _fiyatCarpani)&&const DeepCollectionEquality().equals(other._varlik, _varlik));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nakit,enerji,mutluluk,itibar,krediNotu,const DeepCollectionEquality().hash(_yetkinlik),const DeepCollectionEquality().hash(_fiyatCarpani),const DeepCollectionEquality().hash(_varlik));

@override
String toString() {
  return 'OlayEtkileri(nakit: $nakit, enerji: $enerji, mutluluk: $mutluluk, itibar: $itibar, krediNotu: $krediNotu, yetkinlik: $yetkinlik, fiyatCarpani: $fiyatCarpani, varlik: $varlik)';
}


}

/// @nodoc
abstract mixin class _$OlayEtkileriCopyWith<$Res> implements $OlayEtkileriCopyWith<$Res> {
  factory _$OlayEtkileriCopyWith(_OlayEtkileri value, $Res Function(_OlayEtkileri) _then) = __$OlayEtkileriCopyWithImpl;
@override @useResult
$Res call({
 int nakit, int enerji, int mutluluk, int itibar, int krediNotu, Map<Sektor, int> yetkinlik, Map<String, double> fiyatCarpani, Map<String, double> varlik
});




}
/// @nodoc
class __$OlayEtkileriCopyWithImpl<$Res>
    implements _$OlayEtkileriCopyWith<$Res> {
  __$OlayEtkileriCopyWithImpl(this._self, this._then);

  final _OlayEtkileri _self;
  final $Res Function(_OlayEtkileri) _then;

/// Create a copy of OlayEtkileri
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nakit = null,Object? enerji = null,Object? mutluluk = null,Object? itibar = null,Object? krediNotu = null,Object? yetkinlik = null,Object? fiyatCarpani = null,Object? varlik = null,}) {
  return _then(_OlayEtkileri(
nakit: null == nakit ? _self.nakit : nakit // ignore: cast_nullable_to_non_nullable
as int,enerji: null == enerji ? _self.enerji : enerji // ignore: cast_nullable_to_non_nullable
as int,mutluluk: null == mutluluk ? _self.mutluluk : mutluluk // ignore: cast_nullable_to_non_nullable
as int,itibar: null == itibar ? _self.itibar : itibar // ignore: cast_nullable_to_non_nullable
as int,krediNotu: null == krediNotu ? _self.krediNotu : krediNotu // ignore: cast_nullable_to_non_nullable
as int,yetkinlik: null == yetkinlik ? _self._yetkinlik : yetkinlik // ignore: cast_nullable_to_non_nullable
as Map<Sektor, int>,fiyatCarpani: null == fiyatCarpani ? _self._fiyatCarpani : fiyatCarpani // ignore: cast_nullable_to_non_nullable
as Map<String, double>,varlik: null == varlik ? _self._varlik : varlik // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}


}


/// @nodoc
mixin _$OlaySonucu {

/// Bu dalın çıkma ihtimali. Bir seçenekteki payların toplamı 1 olmalı.
 double get sans; String get metin; OlayEtkileri get etkiler;
/// Create a copy of OlaySonucu
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OlaySonucuCopyWith<OlaySonucu> get copyWith => _$OlaySonucuCopyWithImpl<OlaySonucu>(this as OlaySonucu, _$identity);

  /// Serializes this OlaySonucu to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OlaySonucu&&(identical(other.sans, sans) || other.sans == sans)&&(identical(other.metin, metin) || other.metin == metin)&&(identical(other.etkiler, etkiler) || other.etkiler == etkiler));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sans,metin,etkiler);

@override
String toString() {
  return 'OlaySonucu(sans: $sans, metin: $metin, etkiler: $etkiler)';
}


}

/// @nodoc
abstract mixin class $OlaySonucuCopyWith<$Res>  {
  factory $OlaySonucuCopyWith(OlaySonucu value, $Res Function(OlaySonucu) _then) = _$OlaySonucuCopyWithImpl;
@useResult
$Res call({
 double sans, String metin, OlayEtkileri etkiler
});


$OlayEtkileriCopyWith<$Res> get etkiler;

}
/// @nodoc
class _$OlaySonucuCopyWithImpl<$Res>
    implements $OlaySonucuCopyWith<$Res> {
  _$OlaySonucuCopyWithImpl(this._self, this._then);

  final OlaySonucu _self;
  final $Res Function(OlaySonucu) _then;

/// Create a copy of OlaySonucu
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sans = null,Object? metin = null,Object? etkiler = null,}) {
  return _then(_self.copyWith(
sans: null == sans ? _self.sans : sans // ignore: cast_nullable_to_non_nullable
as double,metin: null == metin ? _self.metin : metin // ignore: cast_nullable_to_non_nullable
as String,etkiler: null == etkiler ? _self.etkiler : etkiler // ignore: cast_nullable_to_non_nullable
as OlayEtkileri,
  ));
}
/// Create a copy of OlaySonucu
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OlayEtkileriCopyWith<$Res> get etkiler {
  
  return $OlayEtkileriCopyWith<$Res>(_self.etkiler, (value) {
    return _then(_self.copyWith(etkiler: value));
  });
}
}


/// Adds pattern-matching-related methods to [OlaySonucu].
extension OlaySonucuPatterns on OlaySonucu {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OlaySonucu value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OlaySonucu() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OlaySonucu value)  $default,){
final _that = this;
switch (_that) {
case _OlaySonucu():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OlaySonucu value)?  $default,){
final _that = this;
switch (_that) {
case _OlaySonucu() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double sans,  String metin,  OlayEtkileri etkiler)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OlaySonucu() when $default != null:
return $default(_that.sans,_that.metin,_that.etkiler);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double sans,  String metin,  OlayEtkileri etkiler)  $default,) {final _that = this;
switch (_that) {
case _OlaySonucu():
return $default(_that.sans,_that.metin,_that.etkiler);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double sans,  String metin,  OlayEtkileri etkiler)?  $default,) {final _that = this;
switch (_that) {
case _OlaySonucu() when $default != null:
return $default(_that.sans,_that.metin,_that.etkiler);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OlaySonucu extends OlaySonucu {
  const _OlaySonucu({required this.sans, required this.metin, this.etkiler = const OlayEtkileri()}): super._();
  factory _OlaySonucu.fromJson(Map<String, dynamic> json) => _$OlaySonucuFromJson(json);

/// Bu dalın çıkma ihtimali. Bir seçenekteki payların toplamı 1 olmalı.
@override final  double sans;
@override final  String metin;
@override@JsonKey() final  OlayEtkileri etkiler;

/// Create a copy of OlaySonucu
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OlaySonucuCopyWith<_OlaySonucu> get copyWith => __$OlaySonucuCopyWithImpl<_OlaySonucu>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OlaySonucuToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OlaySonucu&&(identical(other.sans, sans) || other.sans == sans)&&(identical(other.metin, metin) || other.metin == metin)&&(identical(other.etkiler, etkiler) || other.etkiler == etkiler));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sans,metin,etkiler);

@override
String toString() {
  return 'OlaySonucu(sans: $sans, metin: $metin, etkiler: $etkiler)';
}


}

/// @nodoc
abstract mixin class _$OlaySonucuCopyWith<$Res> implements $OlaySonucuCopyWith<$Res> {
  factory _$OlaySonucuCopyWith(_OlaySonucu value, $Res Function(_OlaySonucu) _then) = __$OlaySonucuCopyWithImpl;
@override @useResult
$Res call({
 double sans, String metin, OlayEtkileri etkiler
});


@override $OlayEtkileriCopyWith<$Res> get etkiler;

}
/// @nodoc
class __$OlaySonucuCopyWithImpl<$Res>
    implements _$OlaySonucuCopyWith<$Res> {
  __$OlaySonucuCopyWithImpl(this._self, this._then);

  final _OlaySonucu _self;
  final $Res Function(_OlaySonucu) _then;

/// Create a copy of OlaySonucu
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sans = null,Object? metin = null,Object? etkiler = null,}) {
  return _then(_OlaySonucu(
sans: null == sans ? _self.sans : sans // ignore: cast_nullable_to_non_nullable
as double,metin: null == metin ? _self.metin : metin // ignore: cast_nullable_to_non_nullable
as String,etkiler: null == etkiler ? _self.etkiler : etkiler // ignore: cast_nullable_to_non_nullable
as OlayEtkileri,
  ));
}

/// Create a copy of OlaySonucu
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OlayEtkileriCopyWith<$Res> get etkiler {
  
  return $OlayEtkileriCopyWith<$Res>(_self.etkiler, (value) {
    return _then(_self.copyWith(etkiler: value));
  });
}
}


/// @nodoc
mixin _$OlaySecenegi {

 String get etiket;/// Seçildiği anda uygulanan etkiler.
 OlayEtkileri get etkiler;/// Rastgele dallanan sonuçlar. Boşsa yalnızca [etkiler] işler.
 List<OlaySonucu> get sonuclar;/// Sonucun kaç tur sonra açığa çıkacağı. 0 = anında.
/// Gerilimin kaynağı: parayı bugün verirsin, sonucu altı ay sonra
/// öğrenirsin.
 int get gecikmeTuru;
/// Create a copy of OlaySecenegi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OlaySecenegiCopyWith<OlaySecenegi> get copyWith => _$OlaySecenegiCopyWithImpl<OlaySecenegi>(this as OlaySecenegi, _$identity);

  /// Serializes this OlaySecenegi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OlaySecenegi&&(identical(other.etiket, etiket) || other.etiket == etiket)&&(identical(other.etkiler, etkiler) || other.etkiler == etkiler)&&const DeepCollectionEquality().equals(other.sonuclar, sonuclar)&&(identical(other.gecikmeTuru, gecikmeTuru) || other.gecikmeTuru == gecikmeTuru));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,etiket,etkiler,const DeepCollectionEquality().hash(sonuclar),gecikmeTuru);

@override
String toString() {
  return 'OlaySecenegi(etiket: $etiket, etkiler: $etkiler, sonuclar: $sonuclar, gecikmeTuru: $gecikmeTuru)';
}


}

/// @nodoc
abstract mixin class $OlaySecenegiCopyWith<$Res>  {
  factory $OlaySecenegiCopyWith(OlaySecenegi value, $Res Function(OlaySecenegi) _then) = _$OlaySecenegiCopyWithImpl;
@useResult
$Res call({
 String etiket, OlayEtkileri etkiler, List<OlaySonucu> sonuclar, int gecikmeTuru
});


$OlayEtkileriCopyWith<$Res> get etkiler;

}
/// @nodoc
class _$OlaySecenegiCopyWithImpl<$Res>
    implements $OlaySecenegiCopyWith<$Res> {
  _$OlaySecenegiCopyWithImpl(this._self, this._then);

  final OlaySecenegi _self;
  final $Res Function(OlaySecenegi) _then;

/// Create a copy of OlaySecenegi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? etiket = null,Object? etkiler = null,Object? sonuclar = null,Object? gecikmeTuru = null,}) {
  return _then(_self.copyWith(
etiket: null == etiket ? _self.etiket : etiket // ignore: cast_nullable_to_non_nullable
as String,etkiler: null == etkiler ? _self.etkiler : etkiler // ignore: cast_nullable_to_non_nullable
as OlayEtkileri,sonuclar: null == sonuclar ? _self.sonuclar : sonuclar // ignore: cast_nullable_to_non_nullable
as List<OlaySonucu>,gecikmeTuru: null == gecikmeTuru ? _self.gecikmeTuru : gecikmeTuru // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of OlaySecenegi
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OlayEtkileriCopyWith<$Res> get etkiler {
  
  return $OlayEtkileriCopyWith<$Res>(_self.etkiler, (value) {
    return _then(_self.copyWith(etkiler: value));
  });
}
}


/// Adds pattern-matching-related methods to [OlaySecenegi].
extension OlaySecenegiPatterns on OlaySecenegi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OlaySecenegi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OlaySecenegi() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OlaySecenegi value)  $default,){
final _that = this;
switch (_that) {
case _OlaySecenegi():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OlaySecenegi value)?  $default,){
final _that = this;
switch (_that) {
case _OlaySecenegi() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String etiket,  OlayEtkileri etkiler,  List<OlaySonucu> sonuclar,  int gecikmeTuru)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OlaySecenegi() when $default != null:
return $default(_that.etiket,_that.etkiler,_that.sonuclar,_that.gecikmeTuru);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String etiket,  OlayEtkileri etkiler,  List<OlaySonucu> sonuclar,  int gecikmeTuru)  $default,) {final _that = this;
switch (_that) {
case _OlaySecenegi():
return $default(_that.etiket,_that.etkiler,_that.sonuclar,_that.gecikmeTuru);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String etiket,  OlayEtkileri etkiler,  List<OlaySonucu> sonuclar,  int gecikmeTuru)?  $default,) {final _that = this;
switch (_that) {
case _OlaySecenegi() when $default != null:
return $default(_that.etiket,_that.etkiler,_that.sonuclar,_that.gecikmeTuru);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OlaySecenegi extends OlaySecenegi {
  const _OlaySecenegi({required this.etiket, this.etkiler = const OlayEtkileri(), final  List<OlaySonucu> sonuclar = const <OlaySonucu>[], this.gecikmeTuru = 0}): _sonuclar = sonuclar,super._();
  factory _OlaySecenegi.fromJson(Map<String, dynamic> json) => _$OlaySecenegiFromJson(json);

@override final  String etiket;
/// Seçildiği anda uygulanan etkiler.
@override@JsonKey() final  OlayEtkileri etkiler;
/// Rastgele dallanan sonuçlar. Boşsa yalnızca [etkiler] işler.
 final  List<OlaySonucu> _sonuclar;
/// Rastgele dallanan sonuçlar. Boşsa yalnızca [etkiler] işler.
@override@JsonKey() List<OlaySonucu> get sonuclar {
  if (_sonuclar is EqualUnmodifiableListView) return _sonuclar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sonuclar);
}

/// Sonucun kaç tur sonra açığa çıkacağı. 0 = anında.
/// Gerilimin kaynağı: parayı bugün verirsin, sonucu altı ay sonra
/// öğrenirsin.
@override@JsonKey() final  int gecikmeTuru;

/// Create a copy of OlaySecenegi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OlaySecenegiCopyWith<_OlaySecenegi> get copyWith => __$OlaySecenegiCopyWithImpl<_OlaySecenegi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OlaySecenegiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OlaySecenegi&&(identical(other.etiket, etiket) || other.etiket == etiket)&&(identical(other.etkiler, etkiler) || other.etkiler == etkiler)&&const DeepCollectionEquality().equals(other._sonuclar, _sonuclar)&&(identical(other.gecikmeTuru, gecikmeTuru) || other.gecikmeTuru == gecikmeTuru));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,etiket,etkiler,const DeepCollectionEquality().hash(_sonuclar),gecikmeTuru);

@override
String toString() {
  return 'OlaySecenegi(etiket: $etiket, etkiler: $etkiler, sonuclar: $sonuclar, gecikmeTuru: $gecikmeTuru)';
}


}

/// @nodoc
abstract mixin class _$OlaySecenegiCopyWith<$Res> implements $OlaySecenegiCopyWith<$Res> {
  factory _$OlaySecenegiCopyWith(_OlaySecenegi value, $Res Function(_OlaySecenegi) _then) = __$OlaySecenegiCopyWithImpl;
@override @useResult
$Res call({
 String etiket, OlayEtkileri etkiler, List<OlaySonucu> sonuclar, int gecikmeTuru
});


@override $OlayEtkileriCopyWith<$Res> get etkiler;

}
/// @nodoc
class __$OlaySecenegiCopyWithImpl<$Res>
    implements _$OlaySecenegiCopyWith<$Res> {
  __$OlaySecenegiCopyWithImpl(this._self, this._then);

  final _OlaySecenegi _self;
  final $Res Function(_OlaySecenegi) _then;

/// Create a copy of OlaySecenegi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? etiket = null,Object? etkiler = null,Object? sonuclar = null,Object? gecikmeTuru = null,}) {
  return _then(_OlaySecenegi(
etiket: null == etiket ? _self.etiket : etiket // ignore: cast_nullable_to_non_nullable
as String,etkiler: null == etkiler ? _self.etkiler : etkiler // ignore: cast_nullable_to_non_nullable
as OlayEtkileri,sonuclar: null == sonuclar ? _self._sonuclar : sonuclar // ignore: cast_nullable_to_non_nullable
as List<OlaySonucu>,gecikmeTuru: null == gecikmeTuru ? _self.gecikmeTuru : gecikmeTuru // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of OlaySecenegi
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OlayEtkileriCopyWith<$Res> get etkiler {
  
  return $OlayEtkileriCopyWith<$Res>(_self.etkiler, (value) {
    return _then(_self.copyWith(etkiler: value));
  });
}
}


/// @nodoc
mixin _$OlayKosullari {

 int? get enAzItibar;/// Asgari nakit — TABAN TL. Oyuncunun nakiti enflasyondan arındırılarak
/// karşılaştırılır.
 int? get enAzNakit; int? get enAzEnerji; int? get enAzMutluluk; int? get enAzKrediNotu;/// Üst sınırlar. Kriz ve borç kartları "durumu kötü olana çıksın"
/// diyebilmek için var; yalnız `enAz...` olsaydı sıkışmış oyuncuya özel
/// kart yazılamazdı. [enCokNakit] de TABAN TL'dir.
 int? get enCokNakit; int? get enCokKrediNotu;/// `[enAz, enCok]`.
@JsonKey(name: 'yas') List<int>? get yasAraligi; List<Sehir>? get sehirler; List<String>? get meslekler; List<Sektor>? get sektorler; List<Rejim>? get rejimler; List<KariyerTuru>? get durumlar; Cinsiyet? get cinsiyet; EgitimSeviyesi? get enAzEgitim;
/// Create a copy of OlayKosullari
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OlayKosullariCopyWith<OlayKosullari> get copyWith => _$OlayKosullariCopyWithImpl<OlayKosullari>(this as OlayKosullari, _$identity);

  /// Serializes this OlayKosullari to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OlayKosullari&&(identical(other.enAzItibar, enAzItibar) || other.enAzItibar == enAzItibar)&&(identical(other.enAzNakit, enAzNakit) || other.enAzNakit == enAzNakit)&&(identical(other.enAzEnerji, enAzEnerji) || other.enAzEnerji == enAzEnerji)&&(identical(other.enAzMutluluk, enAzMutluluk) || other.enAzMutluluk == enAzMutluluk)&&(identical(other.enAzKrediNotu, enAzKrediNotu) || other.enAzKrediNotu == enAzKrediNotu)&&(identical(other.enCokNakit, enCokNakit) || other.enCokNakit == enCokNakit)&&(identical(other.enCokKrediNotu, enCokKrediNotu) || other.enCokKrediNotu == enCokKrediNotu)&&const DeepCollectionEquality().equals(other.yasAraligi, yasAraligi)&&const DeepCollectionEquality().equals(other.sehirler, sehirler)&&const DeepCollectionEquality().equals(other.meslekler, meslekler)&&const DeepCollectionEquality().equals(other.sektorler, sektorler)&&const DeepCollectionEquality().equals(other.rejimler, rejimler)&&const DeepCollectionEquality().equals(other.durumlar, durumlar)&&(identical(other.cinsiyet, cinsiyet) || other.cinsiyet == cinsiyet)&&(identical(other.enAzEgitim, enAzEgitim) || other.enAzEgitim == enAzEgitim));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enAzItibar,enAzNakit,enAzEnerji,enAzMutluluk,enAzKrediNotu,enCokNakit,enCokKrediNotu,const DeepCollectionEquality().hash(yasAraligi),const DeepCollectionEquality().hash(sehirler),const DeepCollectionEquality().hash(meslekler),const DeepCollectionEquality().hash(sektorler),const DeepCollectionEquality().hash(rejimler),const DeepCollectionEquality().hash(durumlar),cinsiyet,enAzEgitim);

@override
String toString() {
  return 'OlayKosullari(enAzItibar: $enAzItibar, enAzNakit: $enAzNakit, enAzEnerji: $enAzEnerji, enAzMutluluk: $enAzMutluluk, enAzKrediNotu: $enAzKrediNotu, enCokNakit: $enCokNakit, enCokKrediNotu: $enCokKrediNotu, yasAraligi: $yasAraligi, sehirler: $sehirler, meslekler: $meslekler, sektorler: $sektorler, rejimler: $rejimler, durumlar: $durumlar, cinsiyet: $cinsiyet, enAzEgitim: $enAzEgitim)';
}


}

/// @nodoc
abstract mixin class $OlayKosullariCopyWith<$Res>  {
  factory $OlayKosullariCopyWith(OlayKosullari value, $Res Function(OlayKosullari) _then) = _$OlayKosullariCopyWithImpl;
@useResult
$Res call({
 int? enAzItibar, int? enAzNakit, int? enAzEnerji, int? enAzMutluluk, int? enAzKrediNotu, int? enCokNakit, int? enCokKrediNotu,@JsonKey(name: 'yas') List<int>? yasAraligi, List<Sehir>? sehirler, List<String>? meslekler, List<Sektor>? sektorler, List<Rejim>? rejimler, List<KariyerTuru>? durumlar, Cinsiyet? cinsiyet, EgitimSeviyesi? enAzEgitim
});




}
/// @nodoc
class _$OlayKosullariCopyWithImpl<$Res>
    implements $OlayKosullariCopyWith<$Res> {
  _$OlayKosullariCopyWithImpl(this._self, this._then);

  final OlayKosullari _self;
  final $Res Function(OlayKosullari) _then;

/// Create a copy of OlayKosullari
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enAzItibar = freezed,Object? enAzNakit = freezed,Object? enAzEnerji = freezed,Object? enAzMutluluk = freezed,Object? enAzKrediNotu = freezed,Object? enCokNakit = freezed,Object? enCokKrediNotu = freezed,Object? yasAraligi = freezed,Object? sehirler = freezed,Object? meslekler = freezed,Object? sektorler = freezed,Object? rejimler = freezed,Object? durumlar = freezed,Object? cinsiyet = freezed,Object? enAzEgitim = freezed,}) {
  return _then(_self.copyWith(
enAzItibar: freezed == enAzItibar ? _self.enAzItibar : enAzItibar // ignore: cast_nullable_to_non_nullable
as int?,enAzNakit: freezed == enAzNakit ? _self.enAzNakit : enAzNakit // ignore: cast_nullable_to_non_nullable
as int?,enAzEnerji: freezed == enAzEnerji ? _self.enAzEnerji : enAzEnerji // ignore: cast_nullable_to_non_nullable
as int?,enAzMutluluk: freezed == enAzMutluluk ? _self.enAzMutluluk : enAzMutluluk // ignore: cast_nullable_to_non_nullable
as int?,enAzKrediNotu: freezed == enAzKrediNotu ? _self.enAzKrediNotu : enAzKrediNotu // ignore: cast_nullable_to_non_nullable
as int?,enCokNakit: freezed == enCokNakit ? _self.enCokNakit : enCokNakit // ignore: cast_nullable_to_non_nullable
as int?,enCokKrediNotu: freezed == enCokKrediNotu ? _self.enCokKrediNotu : enCokKrediNotu // ignore: cast_nullable_to_non_nullable
as int?,yasAraligi: freezed == yasAraligi ? _self.yasAraligi : yasAraligi // ignore: cast_nullable_to_non_nullable
as List<int>?,sehirler: freezed == sehirler ? _self.sehirler : sehirler // ignore: cast_nullable_to_non_nullable
as List<Sehir>?,meslekler: freezed == meslekler ? _self.meslekler : meslekler // ignore: cast_nullable_to_non_nullable
as List<String>?,sektorler: freezed == sektorler ? _self.sektorler : sektorler // ignore: cast_nullable_to_non_nullable
as List<Sektor>?,rejimler: freezed == rejimler ? _self.rejimler : rejimler // ignore: cast_nullable_to_non_nullable
as List<Rejim>?,durumlar: freezed == durumlar ? _self.durumlar : durumlar // ignore: cast_nullable_to_non_nullable
as List<KariyerTuru>?,cinsiyet: freezed == cinsiyet ? _self.cinsiyet : cinsiyet // ignore: cast_nullable_to_non_nullable
as Cinsiyet?,enAzEgitim: freezed == enAzEgitim ? _self.enAzEgitim : enAzEgitim // ignore: cast_nullable_to_non_nullable
as EgitimSeviyesi?,
  ));
}

}


/// Adds pattern-matching-related methods to [OlayKosullari].
extension OlayKosullariPatterns on OlayKosullari {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OlayKosullari value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OlayKosullari() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OlayKosullari value)  $default,){
final _that = this;
switch (_that) {
case _OlayKosullari():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OlayKosullari value)?  $default,){
final _that = this;
switch (_that) {
case _OlayKosullari() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? enAzItibar,  int? enAzNakit,  int? enAzEnerji,  int? enAzMutluluk,  int? enAzKrediNotu,  int? enCokNakit,  int? enCokKrediNotu, @JsonKey(name: 'yas')  List<int>? yasAraligi,  List<Sehir>? sehirler,  List<String>? meslekler,  List<Sektor>? sektorler,  List<Rejim>? rejimler,  List<KariyerTuru>? durumlar,  Cinsiyet? cinsiyet,  EgitimSeviyesi? enAzEgitim)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OlayKosullari() when $default != null:
return $default(_that.enAzItibar,_that.enAzNakit,_that.enAzEnerji,_that.enAzMutluluk,_that.enAzKrediNotu,_that.enCokNakit,_that.enCokKrediNotu,_that.yasAraligi,_that.sehirler,_that.meslekler,_that.sektorler,_that.rejimler,_that.durumlar,_that.cinsiyet,_that.enAzEgitim);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? enAzItibar,  int? enAzNakit,  int? enAzEnerji,  int? enAzMutluluk,  int? enAzKrediNotu,  int? enCokNakit,  int? enCokKrediNotu, @JsonKey(name: 'yas')  List<int>? yasAraligi,  List<Sehir>? sehirler,  List<String>? meslekler,  List<Sektor>? sektorler,  List<Rejim>? rejimler,  List<KariyerTuru>? durumlar,  Cinsiyet? cinsiyet,  EgitimSeviyesi? enAzEgitim)  $default,) {final _that = this;
switch (_that) {
case _OlayKosullari():
return $default(_that.enAzItibar,_that.enAzNakit,_that.enAzEnerji,_that.enAzMutluluk,_that.enAzKrediNotu,_that.enCokNakit,_that.enCokKrediNotu,_that.yasAraligi,_that.sehirler,_that.meslekler,_that.sektorler,_that.rejimler,_that.durumlar,_that.cinsiyet,_that.enAzEgitim);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? enAzItibar,  int? enAzNakit,  int? enAzEnerji,  int? enAzMutluluk,  int? enAzKrediNotu,  int? enCokNakit,  int? enCokKrediNotu, @JsonKey(name: 'yas')  List<int>? yasAraligi,  List<Sehir>? sehirler,  List<String>? meslekler,  List<Sektor>? sektorler,  List<Rejim>? rejimler,  List<KariyerTuru>? durumlar,  Cinsiyet? cinsiyet,  EgitimSeviyesi? enAzEgitim)?  $default,) {final _that = this;
switch (_that) {
case _OlayKosullari() when $default != null:
return $default(_that.enAzItibar,_that.enAzNakit,_that.enAzEnerji,_that.enAzMutluluk,_that.enAzKrediNotu,_that.enCokNakit,_that.enCokKrediNotu,_that.yasAraligi,_that.sehirler,_that.meslekler,_that.sektorler,_that.rejimler,_that.durumlar,_that.cinsiyet,_that.enAzEgitim);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OlayKosullari extends OlayKosullari {
  const _OlayKosullari({this.enAzItibar, this.enAzNakit, this.enAzEnerji, this.enAzMutluluk, this.enAzKrediNotu, this.enCokNakit, this.enCokKrediNotu, @JsonKey(name: 'yas') final  List<int>? yasAraligi, final  List<Sehir>? sehirler, final  List<String>? meslekler, final  List<Sektor>? sektorler, final  List<Rejim>? rejimler, final  List<KariyerTuru>? durumlar, this.cinsiyet, this.enAzEgitim}): _yasAraligi = yasAraligi,_sehirler = sehirler,_meslekler = meslekler,_sektorler = sektorler,_rejimler = rejimler,_durumlar = durumlar,super._();
  factory _OlayKosullari.fromJson(Map<String, dynamic> json) => _$OlayKosullariFromJson(json);

@override final  int? enAzItibar;
/// Asgari nakit — TABAN TL. Oyuncunun nakiti enflasyondan arındırılarak
/// karşılaştırılır.
@override final  int? enAzNakit;
@override final  int? enAzEnerji;
@override final  int? enAzMutluluk;
@override final  int? enAzKrediNotu;
/// Üst sınırlar. Kriz ve borç kartları "durumu kötü olana çıksın"
/// diyebilmek için var; yalnız `enAz...` olsaydı sıkışmış oyuncuya özel
/// kart yazılamazdı. [enCokNakit] de TABAN TL'dir.
@override final  int? enCokNakit;
@override final  int? enCokKrediNotu;
/// `[enAz, enCok]`.
 final  List<int>? _yasAraligi;
/// `[enAz, enCok]`.
@override@JsonKey(name: 'yas') List<int>? get yasAraligi {
  final value = _yasAraligi;
  if (value == null) return null;
  if (_yasAraligi is EqualUnmodifiableListView) return _yasAraligi;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Sehir>? _sehirler;
@override List<Sehir>? get sehirler {
  final value = _sehirler;
  if (value == null) return null;
  if (_sehirler is EqualUnmodifiableListView) return _sehirler;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _meslekler;
@override List<String>? get meslekler {
  final value = _meslekler;
  if (value == null) return null;
  if (_meslekler is EqualUnmodifiableListView) return _meslekler;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Sektor>? _sektorler;
@override List<Sektor>? get sektorler {
  final value = _sektorler;
  if (value == null) return null;
  if (_sektorler is EqualUnmodifiableListView) return _sektorler;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Rejim>? _rejimler;
@override List<Rejim>? get rejimler {
  final value = _rejimler;
  if (value == null) return null;
  if (_rejimler is EqualUnmodifiableListView) return _rejimler;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<KariyerTuru>? _durumlar;
@override List<KariyerTuru>? get durumlar {
  final value = _durumlar;
  if (value == null) return null;
  if (_durumlar is EqualUnmodifiableListView) return _durumlar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  Cinsiyet? cinsiyet;
@override final  EgitimSeviyesi? enAzEgitim;

/// Create a copy of OlayKosullari
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OlayKosullariCopyWith<_OlayKosullari> get copyWith => __$OlayKosullariCopyWithImpl<_OlayKosullari>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OlayKosullariToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OlayKosullari&&(identical(other.enAzItibar, enAzItibar) || other.enAzItibar == enAzItibar)&&(identical(other.enAzNakit, enAzNakit) || other.enAzNakit == enAzNakit)&&(identical(other.enAzEnerji, enAzEnerji) || other.enAzEnerji == enAzEnerji)&&(identical(other.enAzMutluluk, enAzMutluluk) || other.enAzMutluluk == enAzMutluluk)&&(identical(other.enAzKrediNotu, enAzKrediNotu) || other.enAzKrediNotu == enAzKrediNotu)&&(identical(other.enCokNakit, enCokNakit) || other.enCokNakit == enCokNakit)&&(identical(other.enCokKrediNotu, enCokKrediNotu) || other.enCokKrediNotu == enCokKrediNotu)&&const DeepCollectionEquality().equals(other._yasAraligi, _yasAraligi)&&const DeepCollectionEquality().equals(other._sehirler, _sehirler)&&const DeepCollectionEquality().equals(other._meslekler, _meslekler)&&const DeepCollectionEquality().equals(other._sektorler, _sektorler)&&const DeepCollectionEquality().equals(other._rejimler, _rejimler)&&const DeepCollectionEquality().equals(other._durumlar, _durumlar)&&(identical(other.cinsiyet, cinsiyet) || other.cinsiyet == cinsiyet)&&(identical(other.enAzEgitim, enAzEgitim) || other.enAzEgitim == enAzEgitim));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enAzItibar,enAzNakit,enAzEnerji,enAzMutluluk,enAzKrediNotu,enCokNakit,enCokKrediNotu,const DeepCollectionEquality().hash(_yasAraligi),const DeepCollectionEquality().hash(_sehirler),const DeepCollectionEquality().hash(_meslekler),const DeepCollectionEquality().hash(_sektorler),const DeepCollectionEquality().hash(_rejimler),const DeepCollectionEquality().hash(_durumlar),cinsiyet,enAzEgitim);

@override
String toString() {
  return 'OlayKosullari(enAzItibar: $enAzItibar, enAzNakit: $enAzNakit, enAzEnerji: $enAzEnerji, enAzMutluluk: $enAzMutluluk, enAzKrediNotu: $enAzKrediNotu, enCokNakit: $enCokNakit, enCokKrediNotu: $enCokKrediNotu, yasAraligi: $yasAraligi, sehirler: $sehirler, meslekler: $meslekler, sektorler: $sektorler, rejimler: $rejimler, durumlar: $durumlar, cinsiyet: $cinsiyet, enAzEgitim: $enAzEgitim)';
}


}

/// @nodoc
abstract mixin class _$OlayKosullariCopyWith<$Res> implements $OlayKosullariCopyWith<$Res> {
  factory _$OlayKosullariCopyWith(_OlayKosullari value, $Res Function(_OlayKosullari) _then) = __$OlayKosullariCopyWithImpl;
@override @useResult
$Res call({
 int? enAzItibar, int? enAzNakit, int? enAzEnerji, int? enAzMutluluk, int? enAzKrediNotu, int? enCokNakit, int? enCokKrediNotu,@JsonKey(name: 'yas') List<int>? yasAraligi, List<Sehir>? sehirler, List<String>? meslekler, List<Sektor>? sektorler, List<Rejim>? rejimler, List<KariyerTuru>? durumlar, Cinsiyet? cinsiyet, EgitimSeviyesi? enAzEgitim
});




}
/// @nodoc
class __$OlayKosullariCopyWithImpl<$Res>
    implements _$OlayKosullariCopyWith<$Res> {
  __$OlayKosullariCopyWithImpl(this._self, this._then);

  final _OlayKosullari _self;
  final $Res Function(_OlayKosullari) _then;

/// Create a copy of OlayKosullari
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enAzItibar = freezed,Object? enAzNakit = freezed,Object? enAzEnerji = freezed,Object? enAzMutluluk = freezed,Object? enAzKrediNotu = freezed,Object? enCokNakit = freezed,Object? enCokKrediNotu = freezed,Object? yasAraligi = freezed,Object? sehirler = freezed,Object? meslekler = freezed,Object? sektorler = freezed,Object? rejimler = freezed,Object? durumlar = freezed,Object? cinsiyet = freezed,Object? enAzEgitim = freezed,}) {
  return _then(_OlayKosullari(
enAzItibar: freezed == enAzItibar ? _self.enAzItibar : enAzItibar // ignore: cast_nullable_to_non_nullable
as int?,enAzNakit: freezed == enAzNakit ? _self.enAzNakit : enAzNakit // ignore: cast_nullable_to_non_nullable
as int?,enAzEnerji: freezed == enAzEnerji ? _self.enAzEnerji : enAzEnerji // ignore: cast_nullable_to_non_nullable
as int?,enAzMutluluk: freezed == enAzMutluluk ? _self.enAzMutluluk : enAzMutluluk // ignore: cast_nullable_to_non_nullable
as int?,enAzKrediNotu: freezed == enAzKrediNotu ? _self.enAzKrediNotu : enAzKrediNotu // ignore: cast_nullable_to_non_nullable
as int?,enCokNakit: freezed == enCokNakit ? _self.enCokNakit : enCokNakit // ignore: cast_nullable_to_non_nullable
as int?,enCokKrediNotu: freezed == enCokKrediNotu ? _self.enCokKrediNotu : enCokKrediNotu // ignore: cast_nullable_to_non_nullable
as int?,yasAraligi: freezed == yasAraligi ? _self._yasAraligi : yasAraligi // ignore: cast_nullable_to_non_nullable
as List<int>?,sehirler: freezed == sehirler ? _self._sehirler : sehirler // ignore: cast_nullable_to_non_nullable
as List<Sehir>?,meslekler: freezed == meslekler ? _self._meslekler : meslekler // ignore: cast_nullable_to_non_nullable
as List<String>?,sektorler: freezed == sektorler ? _self._sektorler : sektorler // ignore: cast_nullable_to_non_nullable
as List<Sektor>?,rejimler: freezed == rejimler ? _self._rejimler : rejimler // ignore: cast_nullable_to_non_nullable
as List<Rejim>?,durumlar: freezed == durumlar ? _self._durumlar : durumlar // ignore: cast_nullable_to_non_nullable
as List<KariyerTuru>?,cinsiyet: freezed == cinsiyet ? _self.cinsiyet : cinsiyet // ignore: cast_nullable_to_non_nullable
as Cinsiyet?,enAzEgitim: freezed == enAzEgitim ? _self.enAzEgitim : enAzEgitim // ignore: cast_nullable_to_non_nullable
as EgitimSeviyesi?,
  ));
}


}


/// @nodoc
mixin _$BekleyenOlay {

 String get olayId; int get secenekIndeksi; int get kalanTur;
/// Create a copy of BekleyenOlay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BekleyenOlayCopyWith<BekleyenOlay> get copyWith => _$BekleyenOlayCopyWithImpl<BekleyenOlay>(this as BekleyenOlay, _$identity);

  /// Serializes this BekleyenOlay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BekleyenOlay&&(identical(other.olayId, olayId) || other.olayId == olayId)&&(identical(other.secenekIndeksi, secenekIndeksi) || other.secenekIndeksi == secenekIndeksi)&&(identical(other.kalanTur, kalanTur) || other.kalanTur == kalanTur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,olayId,secenekIndeksi,kalanTur);

@override
String toString() {
  return 'BekleyenOlay(olayId: $olayId, secenekIndeksi: $secenekIndeksi, kalanTur: $kalanTur)';
}


}

/// @nodoc
abstract mixin class $BekleyenOlayCopyWith<$Res>  {
  factory $BekleyenOlayCopyWith(BekleyenOlay value, $Res Function(BekleyenOlay) _then) = _$BekleyenOlayCopyWithImpl;
@useResult
$Res call({
 String olayId, int secenekIndeksi, int kalanTur
});




}
/// @nodoc
class _$BekleyenOlayCopyWithImpl<$Res>
    implements $BekleyenOlayCopyWith<$Res> {
  _$BekleyenOlayCopyWithImpl(this._self, this._then);

  final BekleyenOlay _self;
  final $Res Function(BekleyenOlay) _then;

/// Create a copy of BekleyenOlay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? olayId = null,Object? secenekIndeksi = null,Object? kalanTur = null,}) {
  return _then(_self.copyWith(
olayId: null == olayId ? _self.olayId : olayId // ignore: cast_nullable_to_non_nullable
as String,secenekIndeksi: null == secenekIndeksi ? _self.secenekIndeksi : secenekIndeksi // ignore: cast_nullable_to_non_nullable
as int,kalanTur: null == kalanTur ? _self.kalanTur : kalanTur // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BekleyenOlay].
extension BekleyenOlayPatterns on BekleyenOlay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BekleyenOlay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BekleyenOlay() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BekleyenOlay value)  $default,){
final _that = this;
switch (_that) {
case _BekleyenOlay():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BekleyenOlay value)?  $default,){
final _that = this;
switch (_that) {
case _BekleyenOlay() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String olayId,  int secenekIndeksi,  int kalanTur)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BekleyenOlay() when $default != null:
return $default(_that.olayId,_that.secenekIndeksi,_that.kalanTur);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String olayId,  int secenekIndeksi,  int kalanTur)  $default,) {final _that = this;
switch (_that) {
case _BekleyenOlay():
return $default(_that.olayId,_that.secenekIndeksi,_that.kalanTur);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String olayId,  int secenekIndeksi,  int kalanTur)?  $default,) {final _that = this;
switch (_that) {
case _BekleyenOlay() when $default != null:
return $default(_that.olayId,_that.secenekIndeksi,_that.kalanTur);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BekleyenOlay extends BekleyenOlay {
  const _BekleyenOlay({required this.olayId, required this.secenekIndeksi, required this.kalanTur}): super._();
  factory _BekleyenOlay.fromJson(Map<String, dynamic> json) => _$BekleyenOlayFromJson(json);

@override final  String olayId;
@override final  int secenekIndeksi;
@override final  int kalanTur;

/// Create a copy of BekleyenOlay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BekleyenOlayCopyWith<_BekleyenOlay> get copyWith => __$BekleyenOlayCopyWithImpl<_BekleyenOlay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BekleyenOlayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BekleyenOlay&&(identical(other.olayId, olayId) || other.olayId == olayId)&&(identical(other.secenekIndeksi, secenekIndeksi) || other.secenekIndeksi == secenekIndeksi)&&(identical(other.kalanTur, kalanTur) || other.kalanTur == kalanTur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,olayId,secenekIndeksi,kalanTur);

@override
String toString() {
  return 'BekleyenOlay(olayId: $olayId, secenekIndeksi: $secenekIndeksi, kalanTur: $kalanTur)';
}


}

/// @nodoc
abstract mixin class _$BekleyenOlayCopyWith<$Res> implements $BekleyenOlayCopyWith<$Res> {
  factory _$BekleyenOlayCopyWith(_BekleyenOlay value, $Res Function(_BekleyenOlay) _then) = __$BekleyenOlayCopyWithImpl;
@override @useResult
$Res call({
 String olayId, int secenekIndeksi, int kalanTur
});




}
/// @nodoc
class __$BekleyenOlayCopyWithImpl<$Res>
    implements _$BekleyenOlayCopyWith<$Res> {
  __$BekleyenOlayCopyWithImpl(this._self, this._then);

  final _BekleyenOlay _self;
  final $Res Function(_BekleyenOlay) _then;

/// Create a copy of BekleyenOlay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? olayId = null,Object? secenekIndeksi = null,Object? kalanTur = null,}) {
  return _then(_BekleyenOlay(
olayId: null == olayId ? _self.olayId : olayId // ignore: cast_nullable_to_non_nullable
as String,secenekIndeksi: null == secenekIndeksi ? _self.secenekIndeksi : secenekIndeksi // ignore: cast_nullable_to_non_nullable
as int,kalanTur: null == kalanTur ? _self.kalanTur : kalanTur // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Olay {

 String get id; String get baslik;/// En fazla 2-3 cümle. Mobilde uzun paragraf okunmaz.
 String get metin; OlayTuru get tur; OlayKosullari get kosullar;/// Seçim havuzundaki ağırlık.
 double get agirlik;/// Oyun boyunca bir kez mi çıkar.
 bool get tekSeferlik;/// Tekrar çıkabilmesi için geçmesi gereken tur.
 int get bekleme; List<OlaySecenegi> get secenekler;
/// Create a copy of Olay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OlayCopyWith<Olay> get copyWith => _$OlayCopyWithImpl<Olay>(this as Olay, _$identity);

  /// Serializes this Olay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Olay&&(identical(other.id, id) || other.id == id)&&(identical(other.baslik, baslik) || other.baslik == baslik)&&(identical(other.metin, metin) || other.metin == metin)&&(identical(other.tur, tur) || other.tur == tur)&&(identical(other.kosullar, kosullar) || other.kosullar == kosullar)&&(identical(other.agirlik, agirlik) || other.agirlik == agirlik)&&(identical(other.tekSeferlik, tekSeferlik) || other.tekSeferlik == tekSeferlik)&&(identical(other.bekleme, bekleme) || other.bekleme == bekleme)&&const DeepCollectionEquality().equals(other.secenekler, secenekler));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,baslik,metin,tur,kosullar,agirlik,tekSeferlik,bekleme,const DeepCollectionEquality().hash(secenekler));

@override
String toString() {
  return 'Olay(id: $id, baslik: $baslik, metin: $metin, tur: $tur, kosullar: $kosullar, agirlik: $agirlik, tekSeferlik: $tekSeferlik, bekleme: $bekleme, secenekler: $secenekler)';
}


}

/// @nodoc
abstract mixin class $OlayCopyWith<$Res>  {
  factory $OlayCopyWith(Olay value, $Res Function(Olay) _then) = _$OlayCopyWithImpl;
@useResult
$Res call({
 String id, String baslik, String metin, OlayTuru tur, OlayKosullari kosullar, double agirlik, bool tekSeferlik, int bekleme, List<OlaySecenegi> secenekler
});


$OlayKosullariCopyWith<$Res> get kosullar;

}
/// @nodoc
class _$OlayCopyWithImpl<$Res>
    implements $OlayCopyWith<$Res> {
  _$OlayCopyWithImpl(this._self, this._then);

  final Olay _self;
  final $Res Function(Olay) _then;

/// Create a copy of Olay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? baslik = null,Object? metin = null,Object? tur = null,Object? kosullar = null,Object? agirlik = null,Object? tekSeferlik = null,Object? bekleme = null,Object? secenekler = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,baslik: null == baslik ? _self.baslik : baslik // ignore: cast_nullable_to_non_nullable
as String,metin: null == metin ? _self.metin : metin // ignore: cast_nullable_to_non_nullable
as String,tur: null == tur ? _self.tur : tur // ignore: cast_nullable_to_non_nullable
as OlayTuru,kosullar: null == kosullar ? _self.kosullar : kosullar // ignore: cast_nullable_to_non_nullable
as OlayKosullari,agirlik: null == agirlik ? _self.agirlik : agirlik // ignore: cast_nullable_to_non_nullable
as double,tekSeferlik: null == tekSeferlik ? _self.tekSeferlik : tekSeferlik // ignore: cast_nullable_to_non_nullable
as bool,bekleme: null == bekleme ? _self.bekleme : bekleme // ignore: cast_nullable_to_non_nullable
as int,secenekler: null == secenekler ? _self.secenekler : secenekler // ignore: cast_nullable_to_non_nullable
as List<OlaySecenegi>,
  ));
}
/// Create a copy of Olay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OlayKosullariCopyWith<$Res> get kosullar {
  
  return $OlayKosullariCopyWith<$Res>(_self.kosullar, (value) {
    return _then(_self.copyWith(kosullar: value));
  });
}
}


/// Adds pattern-matching-related methods to [Olay].
extension OlayPatterns on Olay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Olay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Olay() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Olay value)  $default,){
final _that = this;
switch (_that) {
case _Olay():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Olay value)?  $default,){
final _that = this;
switch (_that) {
case _Olay() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String baslik,  String metin,  OlayTuru tur,  OlayKosullari kosullar,  double agirlik,  bool tekSeferlik,  int bekleme,  List<OlaySecenegi> secenekler)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Olay() when $default != null:
return $default(_that.id,_that.baslik,_that.metin,_that.tur,_that.kosullar,_that.agirlik,_that.tekSeferlik,_that.bekleme,_that.secenekler);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String baslik,  String metin,  OlayTuru tur,  OlayKosullari kosullar,  double agirlik,  bool tekSeferlik,  int bekleme,  List<OlaySecenegi> secenekler)  $default,) {final _that = this;
switch (_that) {
case _Olay():
return $default(_that.id,_that.baslik,_that.metin,_that.tur,_that.kosullar,_that.agirlik,_that.tekSeferlik,_that.bekleme,_that.secenekler);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String baslik,  String metin,  OlayTuru tur,  OlayKosullari kosullar,  double agirlik,  bool tekSeferlik,  int bekleme,  List<OlaySecenegi> secenekler)?  $default,) {final _that = this;
switch (_that) {
case _Olay() when $default != null:
return $default(_that.id,_that.baslik,_that.metin,_that.tur,_that.kosullar,_that.agirlik,_that.tekSeferlik,_that.bekleme,_that.secenekler);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Olay extends Olay {
  const _Olay({required this.id, required this.baslik, required this.metin, this.tur = OlayTuru.hayat, this.kosullar = const OlayKosullari(), this.agirlik = 10.0, this.tekSeferlik = false, this.bekleme = 60, required final  List<OlaySecenegi> secenekler}): _secenekler = secenekler,super._();
  factory _Olay.fromJson(Map<String, dynamic> json) => _$OlayFromJson(json);

@override final  String id;
@override final  String baslik;
/// En fazla 2-3 cümle. Mobilde uzun paragraf okunmaz.
@override final  String metin;
@override@JsonKey() final  OlayTuru tur;
@override@JsonKey() final  OlayKosullari kosullar;
/// Seçim havuzundaki ağırlık.
@override@JsonKey() final  double agirlik;
/// Oyun boyunca bir kez mi çıkar.
@override@JsonKey() final  bool tekSeferlik;
/// Tekrar çıkabilmesi için geçmesi gereken tur.
@override@JsonKey() final  int bekleme;
 final  List<OlaySecenegi> _secenekler;
@override List<OlaySecenegi> get secenekler {
  if (_secenekler is EqualUnmodifiableListView) return _secenekler;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_secenekler);
}


/// Create a copy of Olay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OlayCopyWith<_Olay> get copyWith => __$OlayCopyWithImpl<_Olay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OlayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Olay&&(identical(other.id, id) || other.id == id)&&(identical(other.baslik, baslik) || other.baslik == baslik)&&(identical(other.metin, metin) || other.metin == metin)&&(identical(other.tur, tur) || other.tur == tur)&&(identical(other.kosullar, kosullar) || other.kosullar == kosullar)&&(identical(other.agirlik, agirlik) || other.agirlik == agirlik)&&(identical(other.tekSeferlik, tekSeferlik) || other.tekSeferlik == tekSeferlik)&&(identical(other.bekleme, bekleme) || other.bekleme == bekleme)&&const DeepCollectionEquality().equals(other._secenekler, _secenekler));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,baslik,metin,tur,kosullar,agirlik,tekSeferlik,bekleme,const DeepCollectionEquality().hash(_secenekler));

@override
String toString() {
  return 'Olay(id: $id, baslik: $baslik, metin: $metin, tur: $tur, kosullar: $kosullar, agirlik: $agirlik, tekSeferlik: $tekSeferlik, bekleme: $bekleme, secenekler: $secenekler)';
}


}

/// @nodoc
abstract mixin class _$OlayCopyWith<$Res> implements $OlayCopyWith<$Res> {
  factory _$OlayCopyWith(_Olay value, $Res Function(_Olay) _then) = __$OlayCopyWithImpl;
@override @useResult
$Res call({
 String id, String baslik, String metin, OlayTuru tur, OlayKosullari kosullar, double agirlik, bool tekSeferlik, int bekleme, List<OlaySecenegi> secenekler
});


@override $OlayKosullariCopyWith<$Res> get kosullar;

}
/// @nodoc
class __$OlayCopyWithImpl<$Res>
    implements _$OlayCopyWith<$Res> {
  __$OlayCopyWithImpl(this._self, this._then);

  final _Olay _self;
  final $Res Function(_Olay) _then;

/// Create a copy of Olay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? baslik = null,Object? metin = null,Object? tur = null,Object? kosullar = null,Object? agirlik = null,Object? tekSeferlik = null,Object? bekleme = null,Object? secenekler = null,}) {
  return _then(_Olay(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,baslik: null == baslik ? _self.baslik : baslik // ignore: cast_nullable_to_non_nullable
as String,metin: null == metin ? _self.metin : metin // ignore: cast_nullable_to_non_nullable
as String,tur: null == tur ? _self.tur : tur // ignore: cast_nullable_to_non_nullable
as OlayTuru,kosullar: null == kosullar ? _self.kosullar : kosullar // ignore: cast_nullable_to_non_nullable
as OlayKosullari,agirlik: null == agirlik ? _self.agirlik : agirlik // ignore: cast_nullable_to_non_nullable
as double,tekSeferlik: null == tekSeferlik ? _self.tekSeferlik : tekSeferlik // ignore: cast_nullable_to_non_nullable
as bool,bekleme: null == bekleme ? _self.bekleme : bekleme // ignore: cast_nullable_to_non_nullable
as int,secenekler: null == secenekler ? _self._secenekler : secenekler // ignore: cast_nullable_to_non_nullable
as List<OlaySecenegi>,
  ));
}

/// Create a copy of Olay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OlayKosullariCopyWith<$Res> get kosullar {
  
  return $OlayKosullariCopyWith<$Res>(_self.kosullar, (value) {
    return _then(_self.copyWith(kosullar: value));
  });
}
}

// dart format on
