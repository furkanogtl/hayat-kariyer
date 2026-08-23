// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'borc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Borc {

 String get id; BorcTuru get tur;/// Çekildiği andaki anapara (nominal TL).
 int get anapara;/// Kalan anapara (nominal TL).
 int get kalanAnapara;/// Sabit aylık taksit (nominal TL).
 int get aylikTaksit;/// AYLIK nominal faiz oranı. Çekildiği turdaki rejime ve kredi notuna
/// göre belirlenir, sonra DEĞİŞMEZ.
 double get aylikFaiz;/// Kalan taksit sayısı.
 int get kalanTaksit; int get cekildigiTur;/// Üst üste ödenemeyen taksit sayısı.
 int get gecikmeTuru;
/// Create a copy of Borc
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BorcCopyWith<Borc> get copyWith => _$BorcCopyWithImpl<Borc>(this as Borc, _$identity);

  /// Serializes this Borc to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Borc&&(identical(other.id, id) || other.id == id)&&(identical(other.tur, tur) || other.tur == tur)&&(identical(other.anapara, anapara) || other.anapara == anapara)&&(identical(other.kalanAnapara, kalanAnapara) || other.kalanAnapara == kalanAnapara)&&(identical(other.aylikTaksit, aylikTaksit) || other.aylikTaksit == aylikTaksit)&&(identical(other.aylikFaiz, aylikFaiz) || other.aylikFaiz == aylikFaiz)&&(identical(other.kalanTaksit, kalanTaksit) || other.kalanTaksit == kalanTaksit)&&(identical(other.cekildigiTur, cekildigiTur) || other.cekildigiTur == cekildigiTur)&&(identical(other.gecikmeTuru, gecikmeTuru) || other.gecikmeTuru == gecikmeTuru));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tur,anapara,kalanAnapara,aylikTaksit,aylikFaiz,kalanTaksit,cekildigiTur,gecikmeTuru);

@override
String toString() {
  return 'Borc(id: $id, tur: $tur, anapara: $anapara, kalanAnapara: $kalanAnapara, aylikTaksit: $aylikTaksit, aylikFaiz: $aylikFaiz, kalanTaksit: $kalanTaksit, cekildigiTur: $cekildigiTur, gecikmeTuru: $gecikmeTuru)';
}


}

/// @nodoc
abstract mixin class $BorcCopyWith<$Res>  {
  factory $BorcCopyWith(Borc value, $Res Function(Borc) _then) = _$BorcCopyWithImpl;
@useResult
$Res call({
 String id, BorcTuru tur, int anapara, int kalanAnapara, int aylikTaksit, double aylikFaiz, int kalanTaksit, int cekildigiTur, int gecikmeTuru
});




}
/// @nodoc
class _$BorcCopyWithImpl<$Res>
    implements $BorcCopyWith<$Res> {
  _$BorcCopyWithImpl(this._self, this._then);

  final Borc _self;
  final $Res Function(Borc) _then;

/// Create a copy of Borc
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tur = null,Object? anapara = null,Object? kalanAnapara = null,Object? aylikTaksit = null,Object? aylikFaiz = null,Object? kalanTaksit = null,Object? cekildigiTur = null,Object? gecikmeTuru = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tur: null == tur ? _self.tur : tur // ignore: cast_nullable_to_non_nullable
as BorcTuru,anapara: null == anapara ? _self.anapara : anapara // ignore: cast_nullable_to_non_nullable
as int,kalanAnapara: null == kalanAnapara ? _self.kalanAnapara : kalanAnapara // ignore: cast_nullable_to_non_nullable
as int,aylikTaksit: null == aylikTaksit ? _self.aylikTaksit : aylikTaksit // ignore: cast_nullable_to_non_nullable
as int,aylikFaiz: null == aylikFaiz ? _self.aylikFaiz : aylikFaiz // ignore: cast_nullable_to_non_nullable
as double,kalanTaksit: null == kalanTaksit ? _self.kalanTaksit : kalanTaksit // ignore: cast_nullable_to_non_nullable
as int,cekildigiTur: null == cekildigiTur ? _self.cekildigiTur : cekildigiTur // ignore: cast_nullable_to_non_nullable
as int,gecikmeTuru: null == gecikmeTuru ? _self.gecikmeTuru : gecikmeTuru // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Borc].
extension BorcPatterns on Borc {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Borc value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Borc() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Borc value)  $default,){
final _that = this;
switch (_that) {
case _Borc():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Borc value)?  $default,){
final _that = this;
switch (_that) {
case _Borc() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  BorcTuru tur,  int anapara,  int kalanAnapara,  int aylikTaksit,  double aylikFaiz,  int kalanTaksit,  int cekildigiTur,  int gecikmeTuru)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Borc() when $default != null:
return $default(_that.id,_that.tur,_that.anapara,_that.kalanAnapara,_that.aylikTaksit,_that.aylikFaiz,_that.kalanTaksit,_that.cekildigiTur,_that.gecikmeTuru);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  BorcTuru tur,  int anapara,  int kalanAnapara,  int aylikTaksit,  double aylikFaiz,  int kalanTaksit,  int cekildigiTur,  int gecikmeTuru)  $default,) {final _that = this;
switch (_that) {
case _Borc():
return $default(_that.id,_that.tur,_that.anapara,_that.kalanAnapara,_that.aylikTaksit,_that.aylikFaiz,_that.kalanTaksit,_that.cekildigiTur,_that.gecikmeTuru);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  BorcTuru tur,  int anapara,  int kalanAnapara,  int aylikTaksit,  double aylikFaiz,  int kalanTaksit,  int cekildigiTur,  int gecikmeTuru)?  $default,) {final _that = this;
switch (_that) {
case _Borc() when $default != null:
return $default(_that.id,_that.tur,_that.anapara,_that.kalanAnapara,_that.aylikTaksit,_that.aylikFaiz,_that.kalanTaksit,_that.cekildigiTur,_that.gecikmeTuru);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Borc extends Borc {
  const _Borc({required this.id, required this.tur, required this.anapara, required this.kalanAnapara, required this.aylikTaksit, required this.aylikFaiz, required this.kalanTaksit, required this.cekildigiTur, this.gecikmeTuru = 0}): super._();
  factory _Borc.fromJson(Map<String, dynamic> json) => _$BorcFromJson(json);

@override final  String id;
@override final  BorcTuru tur;
/// Çekildiği andaki anapara (nominal TL).
@override final  int anapara;
/// Kalan anapara (nominal TL).
@override final  int kalanAnapara;
/// Sabit aylık taksit (nominal TL).
@override final  int aylikTaksit;
/// AYLIK nominal faiz oranı. Çekildiği turdaki rejime ve kredi notuna
/// göre belirlenir, sonra DEĞİŞMEZ.
@override final  double aylikFaiz;
/// Kalan taksit sayısı.
@override final  int kalanTaksit;
@override final  int cekildigiTur;
/// Üst üste ödenemeyen taksit sayısı.
@override@JsonKey() final  int gecikmeTuru;

/// Create a copy of Borc
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BorcCopyWith<_Borc> get copyWith => __$BorcCopyWithImpl<_Borc>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BorcToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Borc&&(identical(other.id, id) || other.id == id)&&(identical(other.tur, tur) || other.tur == tur)&&(identical(other.anapara, anapara) || other.anapara == anapara)&&(identical(other.kalanAnapara, kalanAnapara) || other.kalanAnapara == kalanAnapara)&&(identical(other.aylikTaksit, aylikTaksit) || other.aylikTaksit == aylikTaksit)&&(identical(other.aylikFaiz, aylikFaiz) || other.aylikFaiz == aylikFaiz)&&(identical(other.kalanTaksit, kalanTaksit) || other.kalanTaksit == kalanTaksit)&&(identical(other.cekildigiTur, cekildigiTur) || other.cekildigiTur == cekildigiTur)&&(identical(other.gecikmeTuru, gecikmeTuru) || other.gecikmeTuru == gecikmeTuru));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tur,anapara,kalanAnapara,aylikTaksit,aylikFaiz,kalanTaksit,cekildigiTur,gecikmeTuru);

@override
String toString() {
  return 'Borc(id: $id, tur: $tur, anapara: $anapara, kalanAnapara: $kalanAnapara, aylikTaksit: $aylikTaksit, aylikFaiz: $aylikFaiz, kalanTaksit: $kalanTaksit, cekildigiTur: $cekildigiTur, gecikmeTuru: $gecikmeTuru)';
}


}

/// @nodoc
abstract mixin class _$BorcCopyWith<$Res> implements $BorcCopyWith<$Res> {
  factory _$BorcCopyWith(_Borc value, $Res Function(_Borc) _then) = __$BorcCopyWithImpl;
@override @useResult
$Res call({
 String id, BorcTuru tur, int anapara, int kalanAnapara, int aylikTaksit, double aylikFaiz, int kalanTaksit, int cekildigiTur, int gecikmeTuru
});




}
/// @nodoc
class __$BorcCopyWithImpl<$Res>
    implements _$BorcCopyWith<$Res> {
  __$BorcCopyWithImpl(this._self, this._then);

  final _Borc _self;
  final $Res Function(_Borc) _then;

/// Create a copy of Borc
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tur = null,Object? anapara = null,Object? kalanAnapara = null,Object? aylikTaksit = null,Object? aylikFaiz = null,Object? kalanTaksit = null,Object? cekildigiTur = null,Object? gecikmeTuru = null,}) {
  return _then(_Borc(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tur: null == tur ? _self.tur : tur // ignore: cast_nullable_to_non_nullable
as BorcTuru,anapara: null == anapara ? _self.anapara : anapara // ignore: cast_nullable_to_non_nullable
as int,kalanAnapara: null == kalanAnapara ? _self.kalanAnapara : kalanAnapara // ignore: cast_nullable_to_non_nullable
as int,aylikTaksit: null == aylikTaksit ? _self.aylikTaksit : aylikTaksit // ignore: cast_nullable_to_non_nullable
as int,aylikFaiz: null == aylikFaiz ? _self.aylikFaiz : aylikFaiz // ignore: cast_nullable_to_non_nullable
as double,kalanTaksit: null == kalanTaksit ? _self.kalanTaksit : kalanTaksit // ignore: cast_nullable_to_non_nullable
as int,cekildigiTur: null == cekildigiTur ? _self.cekildigiTur : cekildigiTur // ignore: cast_nullable_to_non_nullable
as int,gecikmeTuru: null == gecikmeTuru ? _self.gecikmeTuru : gecikmeTuru // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$KrediTeklifi {

 BorcTuru get tur;/// Çekilebilecek en yüksek anapara (nominal TL).
 int get enYuksekTutar; double get aylikFaiz; int get vadeTur;
/// Create a copy of KrediTeklifi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KrediTeklifiCopyWith<KrediTeklifi> get copyWith => _$KrediTeklifiCopyWithImpl<KrediTeklifi>(this as KrediTeklifi, _$identity);

  /// Serializes this KrediTeklifi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KrediTeklifi&&(identical(other.tur, tur) || other.tur == tur)&&(identical(other.enYuksekTutar, enYuksekTutar) || other.enYuksekTutar == enYuksekTutar)&&(identical(other.aylikFaiz, aylikFaiz) || other.aylikFaiz == aylikFaiz)&&(identical(other.vadeTur, vadeTur) || other.vadeTur == vadeTur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tur,enYuksekTutar,aylikFaiz,vadeTur);

@override
String toString() {
  return 'KrediTeklifi(tur: $tur, enYuksekTutar: $enYuksekTutar, aylikFaiz: $aylikFaiz, vadeTur: $vadeTur)';
}


}

/// @nodoc
abstract mixin class $KrediTeklifiCopyWith<$Res>  {
  factory $KrediTeklifiCopyWith(KrediTeklifi value, $Res Function(KrediTeklifi) _then) = _$KrediTeklifiCopyWithImpl;
@useResult
$Res call({
 BorcTuru tur, int enYuksekTutar, double aylikFaiz, int vadeTur
});




}
/// @nodoc
class _$KrediTeklifiCopyWithImpl<$Res>
    implements $KrediTeklifiCopyWith<$Res> {
  _$KrediTeklifiCopyWithImpl(this._self, this._then);

  final KrediTeklifi _self;
  final $Res Function(KrediTeklifi) _then;

/// Create a copy of KrediTeklifi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tur = null,Object? enYuksekTutar = null,Object? aylikFaiz = null,Object? vadeTur = null,}) {
  return _then(_self.copyWith(
tur: null == tur ? _self.tur : tur // ignore: cast_nullable_to_non_nullable
as BorcTuru,enYuksekTutar: null == enYuksekTutar ? _self.enYuksekTutar : enYuksekTutar // ignore: cast_nullable_to_non_nullable
as int,aylikFaiz: null == aylikFaiz ? _self.aylikFaiz : aylikFaiz // ignore: cast_nullable_to_non_nullable
as double,vadeTur: null == vadeTur ? _self.vadeTur : vadeTur // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [KrediTeklifi].
extension KrediTeklifiPatterns on KrediTeklifi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KrediTeklifi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KrediTeklifi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KrediTeklifi value)  $default,){
final _that = this;
switch (_that) {
case _KrediTeklifi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KrediTeklifi value)?  $default,){
final _that = this;
switch (_that) {
case _KrediTeklifi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BorcTuru tur,  int enYuksekTutar,  double aylikFaiz,  int vadeTur)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KrediTeklifi() when $default != null:
return $default(_that.tur,_that.enYuksekTutar,_that.aylikFaiz,_that.vadeTur);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BorcTuru tur,  int enYuksekTutar,  double aylikFaiz,  int vadeTur)  $default,) {final _that = this;
switch (_that) {
case _KrediTeklifi():
return $default(_that.tur,_that.enYuksekTutar,_that.aylikFaiz,_that.vadeTur);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BorcTuru tur,  int enYuksekTutar,  double aylikFaiz,  int vadeTur)?  $default,) {final _that = this;
switch (_that) {
case _KrediTeklifi() when $default != null:
return $default(_that.tur,_that.enYuksekTutar,_that.aylikFaiz,_that.vadeTur);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KrediTeklifi extends KrediTeklifi {
  const _KrediTeklifi({required this.tur, required this.enYuksekTutar, required this.aylikFaiz, required this.vadeTur}): super._();
  factory _KrediTeklifi.fromJson(Map<String, dynamic> json) => _$KrediTeklifiFromJson(json);

@override final  BorcTuru tur;
/// Çekilebilecek en yüksek anapara (nominal TL).
@override final  int enYuksekTutar;
@override final  double aylikFaiz;
@override final  int vadeTur;

/// Create a copy of KrediTeklifi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KrediTeklifiCopyWith<_KrediTeklifi> get copyWith => __$KrediTeklifiCopyWithImpl<_KrediTeklifi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KrediTeklifiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KrediTeklifi&&(identical(other.tur, tur) || other.tur == tur)&&(identical(other.enYuksekTutar, enYuksekTutar) || other.enYuksekTutar == enYuksekTutar)&&(identical(other.aylikFaiz, aylikFaiz) || other.aylikFaiz == aylikFaiz)&&(identical(other.vadeTur, vadeTur) || other.vadeTur == vadeTur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tur,enYuksekTutar,aylikFaiz,vadeTur);

@override
String toString() {
  return 'KrediTeklifi(tur: $tur, enYuksekTutar: $enYuksekTutar, aylikFaiz: $aylikFaiz, vadeTur: $vadeTur)';
}


}

/// @nodoc
abstract mixin class _$KrediTeklifiCopyWith<$Res> implements $KrediTeklifiCopyWith<$Res> {
  factory _$KrediTeklifiCopyWith(_KrediTeklifi value, $Res Function(_KrediTeklifi) _then) = __$KrediTeklifiCopyWithImpl;
@override @useResult
$Res call({
 BorcTuru tur, int enYuksekTutar, double aylikFaiz, int vadeTur
});




}
/// @nodoc
class __$KrediTeklifiCopyWithImpl<$Res>
    implements _$KrediTeklifiCopyWith<$Res> {
  __$KrediTeklifiCopyWithImpl(this._self, this._then);

  final _KrediTeklifi _self;
  final $Res Function(_KrediTeklifi) _then;

/// Create a copy of KrediTeklifi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tur = null,Object? enYuksekTutar = null,Object? aylikFaiz = null,Object? vadeTur = null,}) {
  return _then(_KrediTeklifi(
tur: null == tur ? _self.tur : tur // ignore: cast_nullable_to_non_nullable
as BorcTuru,enYuksekTutar: null == enYuksekTutar ? _self.enYuksekTutar : enYuksekTutar // ignore: cast_nullable_to_non_nullable
as int,aylikFaiz: null == aylikFaiz ? _self.aylikFaiz : aylikFaiz // ignore: cast_nullable_to_non_nullable
as double,vadeTur: null == vadeTur ? _self.vadeTur : vadeTur // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
