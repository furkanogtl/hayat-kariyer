// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ilgi_dagilimi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IlgiDagilimi {

/// İşletme örnek kimliği → ayrılan puan.
 Map<String, int> get puanlar;
/// Create a copy of IlgiDagilimi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IlgiDagilimiCopyWith<IlgiDagilimi> get copyWith => _$IlgiDagilimiCopyWithImpl<IlgiDagilimi>(this as IlgiDagilimi, _$identity);

  /// Serializes this IlgiDagilimi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IlgiDagilimi&&const DeepCollectionEquality().equals(other.puanlar, puanlar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(puanlar));

@override
String toString() {
  return 'IlgiDagilimi(puanlar: $puanlar)';
}


}

/// @nodoc
abstract mixin class $IlgiDagilimiCopyWith<$Res>  {
  factory $IlgiDagilimiCopyWith(IlgiDagilimi value, $Res Function(IlgiDagilimi) _then) = _$IlgiDagilimiCopyWithImpl;
@useResult
$Res call({
 Map<String, int> puanlar
});




}
/// @nodoc
class _$IlgiDagilimiCopyWithImpl<$Res>
    implements $IlgiDagilimiCopyWith<$Res> {
  _$IlgiDagilimiCopyWithImpl(this._self, this._then);

  final IlgiDagilimi _self;
  final $Res Function(IlgiDagilimi) _then;

/// Create a copy of IlgiDagilimi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? puanlar = null,}) {
  return _then(_self.copyWith(
puanlar: null == puanlar ? _self.puanlar : puanlar // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [IlgiDagilimi].
extension IlgiDagilimiPatterns on IlgiDagilimi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IlgiDagilimi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IlgiDagilimi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IlgiDagilimi value)  $default,){
final _that = this;
switch (_that) {
case _IlgiDagilimi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IlgiDagilimi value)?  $default,){
final _that = this;
switch (_that) {
case _IlgiDagilimi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, int> puanlar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IlgiDagilimi() when $default != null:
return $default(_that.puanlar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, int> puanlar)  $default,) {final _that = this;
switch (_that) {
case _IlgiDagilimi():
return $default(_that.puanlar);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, int> puanlar)?  $default,) {final _that = this;
switch (_that) {
case _IlgiDagilimi() when $default != null:
return $default(_that.puanlar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IlgiDagilimi extends IlgiDagilimi {
  const _IlgiDagilimi({final  Map<String, int> puanlar = const <String, int>{}}): _puanlar = puanlar,super._();
  factory _IlgiDagilimi.fromJson(Map<String, dynamic> json) => _$IlgiDagilimiFromJson(json);

/// İşletme örnek kimliği → ayrılan puan.
 final  Map<String, int> _puanlar;
/// İşletme örnek kimliği → ayrılan puan.
@override@JsonKey() Map<String, int> get puanlar {
  if (_puanlar is EqualUnmodifiableMapView) return _puanlar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_puanlar);
}


/// Create a copy of IlgiDagilimi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IlgiDagilimiCopyWith<_IlgiDagilimi> get copyWith => __$IlgiDagilimiCopyWithImpl<_IlgiDagilimi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IlgiDagilimiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IlgiDagilimi&&const DeepCollectionEquality().equals(other._puanlar, _puanlar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_puanlar));

@override
String toString() {
  return 'IlgiDagilimi(puanlar: $puanlar)';
}


}

/// @nodoc
abstract mixin class _$IlgiDagilimiCopyWith<$Res> implements $IlgiDagilimiCopyWith<$Res> {
  factory _$IlgiDagilimiCopyWith(_IlgiDagilimi value, $Res Function(_IlgiDagilimi) _then) = __$IlgiDagilimiCopyWithImpl;
@override @useResult
$Res call({
 Map<String, int> puanlar
});




}
/// @nodoc
class __$IlgiDagilimiCopyWithImpl<$Res>
    implements _$IlgiDagilimiCopyWith<$Res> {
  __$IlgiDagilimiCopyWithImpl(this._self, this._then);

  final _IlgiDagilimi _self;
  final $Res Function(_IlgiDagilimi) _then;

/// Create a copy of IlgiDagilimi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? puanlar = null,}) {
  return _then(_IlgiDagilimi(
puanlar: null == puanlar ? _self._puanlar : puanlar // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
