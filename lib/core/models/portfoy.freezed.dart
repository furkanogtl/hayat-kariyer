// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfoy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Pozisyon {

 double get adet;/// Birim başına ortalama alış maliyeti (ham TL, komisyon dahil).
/// Kâr/zarar göstergesi buna bakar.
 double get ortalamaMaliyet;
/// Create a copy of Pozisyon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PozisyonCopyWith<Pozisyon> get copyWith => _$PozisyonCopyWithImpl<Pozisyon>(this as Pozisyon, _$identity);

  /// Serializes this Pozisyon to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pozisyon&&(identical(other.adet, adet) || other.adet == adet)&&(identical(other.ortalamaMaliyet, ortalamaMaliyet) || other.ortalamaMaliyet == ortalamaMaliyet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adet,ortalamaMaliyet);

@override
String toString() {
  return 'Pozisyon(adet: $adet, ortalamaMaliyet: $ortalamaMaliyet)';
}


}

/// @nodoc
abstract mixin class $PozisyonCopyWith<$Res>  {
  factory $PozisyonCopyWith(Pozisyon value, $Res Function(Pozisyon) _then) = _$PozisyonCopyWithImpl;
@useResult
$Res call({
 double adet, double ortalamaMaliyet
});




}
/// @nodoc
class _$PozisyonCopyWithImpl<$Res>
    implements $PozisyonCopyWith<$Res> {
  _$PozisyonCopyWithImpl(this._self, this._then);

  final Pozisyon _self;
  final $Res Function(Pozisyon) _then;

/// Create a copy of Pozisyon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adet = null,Object? ortalamaMaliyet = null,}) {
  return _then(_self.copyWith(
adet: null == adet ? _self.adet : adet // ignore: cast_nullable_to_non_nullable
as double,ortalamaMaliyet: null == ortalamaMaliyet ? _self.ortalamaMaliyet : ortalamaMaliyet // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Pozisyon].
extension PozisyonPatterns on Pozisyon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pozisyon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pozisyon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pozisyon value)  $default,){
final _that = this;
switch (_that) {
case _Pozisyon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pozisyon value)?  $default,){
final _that = this;
switch (_that) {
case _Pozisyon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double adet,  double ortalamaMaliyet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pozisyon() when $default != null:
return $default(_that.adet,_that.ortalamaMaliyet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double adet,  double ortalamaMaliyet)  $default,) {final _that = this;
switch (_that) {
case _Pozisyon():
return $default(_that.adet,_that.ortalamaMaliyet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double adet,  double ortalamaMaliyet)?  $default,) {final _that = this;
switch (_that) {
case _Pozisyon() when $default != null:
return $default(_that.adet,_that.ortalamaMaliyet);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Pozisyon extends Pozisyon {
  const _Pozisyon({required this.adet, required this.ortalamaMaliyet}): super._();
  factory _Pozisyon.fromJson(Map<String, dynamic> json) => _$PozisyonFromJson(json);

@override final  double adet;
/// Birim başına ortalama alış maliyeti (ham TL, komisyon dahil).
/// Kâr/zarar göstergesi buna bakar.
@override final  double ortalamaMaliyet;

/// Create a copy of Pozisyon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PozisyonCopyWith<_Pozisyon> get copyWith => __$PozisyonCopyWithImpl<_Pozisyon>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PozisyonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pozisyon&&(identical(other.adet, adet) || other.adet == adet)&&(identical(other.ortalamaMaliyet, ortalamaMaliyet) || other.ortalamaMaliyet == ortalamaMaliyet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adet,ortalamaMaliyet);

@override
String toString() {
  return 'Pozisyon(adet: $adet, ortalamaMaliyet: $ortalamaMaliyet)';
}


}

/// @nodoc
abstract mixin class _$PozisyonCopyWith<$Res> implements $PozisyonCopyWith<$Res> {
  factory _$PozisyonCopyWith(_Pozisyon value, $Res Function(_Pozisyon) _then) = __$PozisyonCopyWithImpl;
@override @useResult
$Res call({
 double adet, double ortalamaMaliyet
});




}
/// @nodoc
class __$PozisyonCopyWithImpl<$Res>
    implements _$PozisyonCopyWith<$Res> {
  __$PozisyonCopyWithImpl(this._self, this._then);

  final _Pozisyon _self;
  final $Res Function(_Pozisyon) _then;

/// Create a copy of Pozisyon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adet = null,Object? ortalamaMaliyet = null,}) {
  return _then(_Pozisyon(
adet: null == adet ? _self.adet : adet // ignore: cast_nullable_to_non_nullable
as double,ortalamaMaliyet: null == ortalamaMaliyet ? _self.ortalamaMaliyet : ortalamaMaliyet // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$BekleyenSatis {

 String get varlikId; double get adet; int get kalanTur;
/// Create a copy of BekleyenSatis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BekleyenSatisCopyWith<BekleyenSatis> get copyWith => _$BekleyenSatisCopyWithImpl<BekleyenSatis>(this as BekleyenSatis, _$identity);

  /// Serializes this BekleyenSatis to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BekleyenSatis&&(identical(other.varlikId, varlikId) || other.varlikId == varlikId)&&(identical(other.adet, adet) || other.adet == adet)&&(identical(other.kalanTur, kalanTur) || other.kalanTur == kalanTur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,varlikId,adet,kalanTur);

@override
String toString() {
  return 'BekleyenSatis(varlikId: $varlikId, adet: $adet, kalanTur: $kalanTur)';
}


}

/// @nodoc
abstract mixin class $BekleyenSatisCopyWith<$Res>  {
  factory $BekleyenSatisCopyWith(BekleyenSatis value, $Res Function(BekleyenSatis) _then) = _$BekleyenSatisCopyWithImpl;
@useResult
$Res call({
 String varlikId, double adet, int kalanTur
});




}
/// @nodoc
class _$BekleyenSatisCopyWithImpl<$Res>
    implements $BekleyenSatisCopyWith<$Res> {
  _$BekleyenSatisCopyWithImpl(this._self, this._then);

  final BekleyenSatis _self;
  final $Res Function(BekleyenSatis) _then;

/// Create a copy of BekleyenSatis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? varlikId = null,Object? adet = null,Object? kalanTur = null,}) {
  return _then(_self.copyWith(
varlikId: null == varlikId ? _self.varlikId : varlikId // ignore: cast_nullable_to_non_nullable
as String,adet: null == adet ? _self.adet : adet // ignore: cast_nullable_to_non_nullable
as double,kalanTur: null == kalanTur ? _self.kalanTur : kalanTur // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BekleyenSatis].
extension BekleyenSatisPatterns on BekleyenSatis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BekleyenSatis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BekleyenSatis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BekleyenSatis value)  $default,){
final _that = this;
switch (_that) {
case _BekleyenSatis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BekleyenSatis value)?  $default,){
final _that = this;
switch (_that) {
case _BekleyenSatis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String varlikId,  double adet,  int kalanTur)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BekleyenSatis() when $default != null:
return $default(_that.varlikId,_that.adet,_that.kalanTur);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String varlikId,  double adet,  int kalanTur)  $default,) {final _that = this;
switch (_that) {
case _BekleyenSatis():
return $default(_that.varlikId,_that.adet,_that.kalanTur);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String varlikId,  double adet,  int kalanTur)?  $default,) {final _that = this;
switch (_that) {
case _BekleyenSatis() when $default != null:
return $default(_that.varlikId,_that.adet,_that.kalanTur);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BekleyenSatis extends BekleyenSatis {
  const _BekleyenSatis({required this.varlikId, required this.adet, required this.kalanTur}): super._();
  factory _BekleyenSatis.fromJson(Map<String, dynamic> json) => _$BekleyenSatisFromJson(json);

@override final  String varlikId;
@override final  double adet;
@override final  int kalanTur;

/// Create a copy of BekleyenSatis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BekleyenSatisCopyWith<_BekleyenSatis> get copyWith => __$BekleyenSatisCopyWithImpl<_BekleyenSatis>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BekleyenSatisToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BekleyenSatis&&(identical(other.varlikId, varlikId) || other.varlikId == varlikId)&&(identical(other.adet, adet) || other.adet == adet)&&(identical(other.kalanTur, kalanTur) || other.kalanTur == kalanTur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,varlikId,adet,kalanTur);

@override
String toString() {
  return 'BekleyenSatis(varlikId: $varlikId, adet: $adet, kalanTur: $kalanTur)';
}


}

/// @nodoc
abstract mixin class _$BekleyenSatisCopyWith<$Res> implements $BekleyenSatisCopyWith<$Res> {
  factory _$BekleyenSatisCopyWith(_BekleyenSatis value, $Res Function(_BekleyenSatis) _then) = __$BekleyenSatisCopyWithImpl;
@override @useResult
$Res call({
 String varlikId, double adet, int kalanTur
});




}
/// @nodoc
class __$BekleyenSatisCopyWithImpl<$Res>
    implements _$BekleyenSatisCopyWith<$Res> {
  __$BekleyenSatisCopyWithImpl(this._self, this._then);

  final _BekleyenSatis _self;
  final $Res Function(_BekleyenSatis) _then;

/// Create a copy of BekleyenSatis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? varlikId = null,Object? adet = null,Object? kalanTur = null,}) {
  return _then(_BekleyenSatis(
varlikId: null == varlikId ? _self.varlikId : varlikId // ignore: cast_nullable_to_non_nullable
as String,adet: null == adet ? _self.adet : adet // ignore: cast_nullable_to_non_nullable
as double,kalanTur: null == kalanTur ? _self.kalanTur : kalanTur // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Portfoy {

/// Varlık kimliği -> pozisyon.
 Map<String, Pozisyon> get pozisyonlar;/// Satışa çıkarılmış ama henüz sonuçlanmamış emirler.
 List<BekleyenSatis> get bekleyenSatislar;
/// Create a copy of Portfoy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfoyCopyWith<Portfoy> get copyWith => _$PortfoyCopyWithImpl<Portfoy>(this as Portfoy, _$identity);

  /// Serializes this Portfoy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Portfoy&&const DeepCollectionEquality().equals(other.pozisyonlar, pozisyonlar)&&const DeepCollectionEquality().equals(other.bekleyenSatislar, bekleyenSatislar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pozisyonlar),const DeepCollectionEquality().hash(bekleyenSatislar));

@override
String toString() {
  return 'Portfoy(pozisyonlar: $pozisyonlar, bekleyenSatislar: $bekleyenSatislar)';
}


}

/// @nodoc
abstract mixin class $PortfoyCopyWith<$Res>  {
  factory $PortfoyCopyWith(Portfoy value, $Res Function(Portfoy) _then) = _$PortfoyCopyWithImpl;
@useResult
$Res call({
 Map<String, Pozisyon> pozisyonlar, List<BekleyenSatis> bekleyenSatislar
});




}
/// @nodoc
class _$PortfoyCopyWithImpl<$Res>
    implements $PortfoyCopyWith<$Res> {
  _$PortfoyCopyWithImpl(this._self, this._then);

  final Portfoy _self;
  final $Res Function(Portfoy) _then;

/// Create a copy of Portfoy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pozisyonlar = null,Object? bekleyenSatislar = null,}) {
  return _then(_self.copyWith(
pozisyonlar: null == pozisyonlar ? _self.pozisyonlar : pozisyonlar // ignore: cast_nullable_to_non_nullable
as Map<String, Pozisyon>,bekleyenSatislar: null == bekleyenSatislar ? _self.bekleyenSatislar : bekleyenSatislar // ignore: cast_nullable_to_non_nullable
as List<BekleyenSatis>,
  ));
}

}


/// Adds pattern-matching-related methods to [Portfoy].
extension PortfoyPatterns on Portfoy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Portfoy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Portfoy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Portfoy value)  $default,){
final _that = this;
switch (_that) {
case _Portfoy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Portfoy value)?  $default,){
final _that = this;
switch (_that) {
case _Portfoy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, Pozisyon> pozisyonlar,  List<BekleyenSatis> bekleyenSatislar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Portfoy() when $default != null:
return $default(_that.pozisyonlar,_that.bekleyenSatislar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, Pozisyon> pozisyonlar,  List<BekleyenSatis> bekleyenSatislar)  $default,) {final _that = this;
switch (_that) {
case _Portfoy():
return $default(_that.pozisyonlar,_that.bekleyenSatislar);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, Pozisyon> pozisyonlar,  List<BekleyenSatis> bekleyenSatislar)?  $default,) {final _that = this;
switch (_that) {
case _Portfoy() when $default != null:
return $default(_that.pozisyonlar,_that.bekleyenSatislar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Portfoy extends Portfoy {
  const _Portfoy({final  Map<String, Pozisyon> pozisyonlar = const <String, Pozisyon>{}, final  List<BekleyenSatis> bekleyenSatislar = const <BekleyenSatis>[]}): _pozisyonlar = pozisyonlar,_bekleyenSatislar = bekleyenSatislar,super._();
  factory _Portfoy.fromJson(Map<String, dynamic> json) => _$PortfoyFromJson(json);

/// Varlık kimliği -> pozisyon.
 final  Map<String, Pozisyon> _pozisyonlar;
/// Varlık kimliği -> pozisyon.
@override@JsonKey() Map<String, Pozisyon> get pozisyonlar {
  if (_pozisyonlar is EqualUnmodifiableMapView) return _pozisyonlar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_pozisyonlar);
}

/// Satışa çıkarılmış ama henüz sonuçlanmamış emirler.
 final  List<BekleyenSatis> _bekleyenSatislar;
/// Satışa çıkarılmış ama henüz sonuçlanmamış emirler.
@override@JsonKey() List<BekleyenSatis> get bekleyenSatislar {
  if (_bekleyenSatislar is EqualUnmodifiableListView) return _bekleyenSatislar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bekleyenSatislar);
}


/// Create a copy of Portfoy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortfoyCopyWith<_Portfoy> get copyWith => __$PortfoyCopyWithImpl<_Portfoy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PortfoyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Portfoy&&const DeepCollectionEquality().equals(other._pozisyonlar, _pozisyonlar)&&const DeepCollectionEquality().equals(other._bekleyenSatislar, _bekleyenSatislar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_pozisyonlar),const DeepCollectionEquality().hash(_bekleyenSatislar));

@override
String toString() {
  return 'Portfoy(pozisyonlar: $pozisyonlar, bekleyenSatislar: $bekleyenSatislar)';
}


}

/// @nodoc
abstract mixin class _$PortfoyCopyWith<$Res> implements $PortfoyCopyWith<$Res> {
  factory _$PortfoyCopyWith(_Portfoy value, $Res Function(_Portfoy) _then) = __$PortfoyCopyWithImpl;
@override @useResult
$Res call({
 Map<String, Pozisyon> pozisyonlar, List<BekleyenSatis> bekleyenSatislar
});




}
/// @nodoc
class __$PortfoyCopyWithImpl<$Res>
    implements _$PortfoyCopyWith<$Res> {
  __$PortfoyCopyWithImpl(this._self, this._then);

  final _Portfoy _self;
  final $Res Function(_Portfoy) _then;

/// Create a copy of Portfoy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pozisyonlar = null,Object? bekleyenSatislar = null,}) {
  return _then(_Portfoy(
pozisyonlar: null == pozisyonlar ? _self._pozisyonlar : pozisyonlar // ignore: cast_nullable_to_non_nullable
as Map<String, Pozisyon>,bekleyenSatislar: null == bekleyenSatislar ? _self._bekleyenSatislar : bekleyenSatislar // ignore: cast_nullable_to_non_nullable
as List<BekleyenSatis>,
  ));
}


}

// dart format on
