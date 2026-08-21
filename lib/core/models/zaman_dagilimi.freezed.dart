// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zaman_dagilimi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ZamanDagilimi {

 int get calisma; int get egitim; int get network; int get dinlenme;
/// Create a copy of ZamanDagilimi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZamanDagilimiCopyWith<ZamanDagilimi> get copyWith => _$ZamanDagilimiCopyWithImpl<ZamanDagilimi>(this as ZamanDagilimi, _$identity);

  /// Serializes this ZamanDagilimi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ZamanDagilimi&&(identical(other.calisma, calisma) || other.calisma == calisma)&&(identical(other.egitim, egitim) || other.egitim == egitim)&&(identical(other.network, network) || other.network == network)&&(identical(other.dinlenme, dinlenme) || other.dinlenme == dinlenme));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,calisma,egitim,network,dinlenme);

@override
String toString() {
  return 'ZamanDagilimi(calisma: $calisma, egitim: $egitim, network: $network, dinlenme: $dinlenme)';
}


}

/// @nodoc
abstract mixin class $ZamanDagilimiCopyWith<$Res>  {
  factory $ZamanDagilimiCopyWith(ZamanDagilimi value, $Res Function(ZamanDagilimi) _then) = _$ZamanDagilimiCopyWithImpl;
@useResult
$Res call({
 int calisma, int egitim, int network, int dinlenme
});




}
/// @nodoc
class _$ZamanDagilimiCopyWithImpl<$Res>
    implements $ZamanDagilimiCopyWith<$Res> {
  _$ZamanDagilimiCopyWithImpl(this._self, this._then);

  final ZamanDagilimi _self;
  final $Res Function(ZamanDagilimi) _then;

/// Create a copy of ZamanDagilimi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? calisma = null,Object? egitim = null,Object? network = null,Object? dinlenme = null,}) {
  return _then(_self.copyWith(
calisma: null == calisma ? _self.calisma : calisma // ignore: cast_nullable_to_non_nullable
as int,egitim: null == egitim ? _self.egitim : egitim // ignore: cast_nullable_to_non_nullable
as int,network: null == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as int,dinlenme: null == dinlenme ? _self.dinlenme : dinlenme // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ZamanDagilimi].
extension ZamanDagilimiPatterns on ZamanDagilimi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ZamanDagilimi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ZamanDagilimi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ZamanDagilimi value)  $default,){
final _that = this;
switch (_that) {
case _ZamanDagilimi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ZamanDagilimi value)?  $default,){
final _that = this;
switch (_that) {
case _ZamanDagilimi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int calisma,  int egitim,  int network,  int dinlenme)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ZamanDagilimi() when $default != null:
return $default(_that.calisma,_that.egitim,_that.network,_that.dinlenme);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int calisma,  int egitim,  int network,  int dinlenme)  $default,) {final _that = this;
switch (_that) {
case _ZamanDagilimi():
return $default(_that.calisma,_that.egitim,_that.network,_that.dinlenme);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int calisma,  int egitim,  int network,  int dinlenme)?  $default,) {final _that = this;
switch (_that) {
case _ZamanDagilimi() when $default != null:
return $default(_that.calisma,_that.egitim,_that.network,_that.dinlenme);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ZamanDagilimi extends ZamanDagilimi {
  const _ZamanDagilimi({this.calisma = 0, this.egitim = 0, this.network = 0, this.dinlenme = 0}): super._();
  factory _ZamanDagilimi.fromJson(Map<String, dynamic> json) => _$ZamanDagilimiFromJson(json);

@override@JsonKey() final  int calisma;
@override@JsonKey() final  int egitim;
@override@JsonKey() final  int network;
@override@JsonKey() final  int dinlenme;

/// Create a copy of ZamanDagilimi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ZamanDagilimiCopyWith<_ZamanDagilimi> get copyWith => __$ZamanDagilimiCopyWithImpl<_ZamanDagilimi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ZamanDagilimiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ZamanDagilimi&&(identical(other.calisma, calisma) || other.calisma == calisma)&&(identical(other.egitim, egitim) || other.egitim == egitim)&&(identical(other.network, network) || other.network == network)&&(identical(other.dinlenme, dinlenme) || other.dinlenme == dinlenme));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,calisma,egitim,network,dinlenme);

@override
String toString() {
  return 'ZamanDagilimi(calisma: $calisma, egitim: $egitim, network: $network, dinlenme: $dinlenme)';
}


}

/// @nodoc
abstract mixin class _$ZamanDagilimiCopyWith<$Res> implements $ZamanDagilimiCopyWith<$Res> {
  factory _$ZamanDagilimiCopyWith(_ZamanDagilimi value, $Res Function(_ZamanDagilimi) _then) = __$ZamanDagilimiCopyWithImpl;
@override @useResult
$Res call({
 int calisma, int egitim, int network, int dinlenme
});




}
/// @nodoc
class __$ZamanDagilimiCopyWithImpl<$Res>
    implements _$ZamanDagilimiCopyWith<$Res> {
  __$ZamanDagilimiCopyWithImpl(this._self, this._then);

  final _ZamanDagilimi _self;
  final $Res Function(_ZamanDagilimi) _then;

/// Create a copy of ZamanDagilimi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? calisma = null,Object? egitim = null,Object? network = null,Object? dinlenme = null,}) {
  return _then(_ZamanDagilimi(
calisma: null == calisma ? _self.calisma : calisma // ignore: cast_nullable_to_non_nullable
as int,egitim: null == egitim ? _self.egitim : egitim // ignore: cast_nullable_to_non_nullable
as int,network: null == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as int,dinlenme: null == dinlenme ? _self.dinlenme : dinlenme // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
