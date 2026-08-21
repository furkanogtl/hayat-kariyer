// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meslek.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GirisSarti {

 EgitimSeviyesi get egitim;/// Mesleğin sektöründe gereken asgari yetkinlik (0-100).
 int get yetkinlik;/// `[enAz, enCok]` — JSON'da iki elemanlı dizi olarak tutulur.
@JsonKey(name: 'yas') List<int> get yasAraligi;
/// Create a copy of GirisSarti
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GirisSartiCopyWith<GirisSarti> get copyWith => _$GirisSartiCopyWithImpl<GirisSarti>(this as GirisSarti, _$identity);

  /// Serializes this GirisSarti to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GirisSarti&&(identical(other.egitim, egitim) || other.egitim == egitim)&&(identical(other.yetkinlik, yetkinlik) || other.yetkinlik == yetkinlik)&&const DeepCollectionEquality().equals(other.yasAraligi, yasAraligi));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,egitim,yetkinlik,const DeepCollectionEquality().hash(yasAraligi));

@override
String toString() {
  return 'GirisSarti(egitim: $egitim, yetkinlik: $yetkinlik, yasAraligi: $yasAraligi)';
}


}

/// @nodoc
abstract mixin class $GirisSartiCopyWith<$Res>  {
  factory $GirisSartiCopyWith(GirisSarti value, $Res Function(GirisSarti) _then) = _$GirisSartiCopyWithImpl;
@useResult
$Res call({
 EgitimSeviyesi egitim, int yetkinlik,@JsonKey(name: 'yas') List<int> yasAraligi
});




}
/// @nodoc
class _$GirisSartiCopyWithImpl<$Res>
    implements $GirisSartiCopyWith<$Res> {
  _$GirisSartiCopyWithImpl(this._self, this._then);

  final GirisSarti _self;
  final $Res Function(GirisSarti) _then;

/// Create a copy of GirisSarti
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? egitim = null,Object? yetkinlik = null,Object? yasAraligi = null,}) {
  return _then(_self.copyWith(
egitim: null == egitim ? _self.egitim : egitim // ignore: cast_nullable_to_non_nullable
as EgitimSeviyesi,yetkinlik: null == yetkinlik ? _self.yetkinlik : yetkinlik // ignore: cast_nullable_to_non_nullable
as int,yasAraligi: null == yasAraligi ? _self.yasAraligi : yasAraligi // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [GirisSarti].
extension GirisSartiPatterns on GirisSarti {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GirisSarti value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GirisSarti() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GirisSarti value)  $default,){
final _that = this;
switch (_that) {
case _GirisSarti():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GirisSarti value)?  $default,){
final _that = this;
switch (_that) {
case _GirisSarti() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EgitimSeviyesi egitim,  int yetkinlik, @JsonKey(name: 'yas')  List<int> yasAraligi)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GirisSarti() when $default != null:
return $default(_that.egitim,_that.yetkinlik,_that.yasAraligi);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EgitimSeviyesi egitim,  int yetkinlik, @JsonKey(name: 'yas')  List<int> yasAraligi)  $default,) {final _that = this;
switch (_that) {
case _GirisSarti():
return $default(_that.egitim,_that.yetkinlik,_that.yasAraligi);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EgitimSeviyesi egitim,  int yetkinlik, @JsonKey(name: 'yas')  List<int> yasAraligi)?  $default,) {final _that = this;
switch (_that) {
case _GirisSarti() when $default != null:
return $default(_that.egitim,_that.yetkinlik,_that.yasAraligi);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GirisSarti extends GirisSarti {
  const _GirisSarti({this.egitim = EgitimSeviyesi.lise, this.yetkinlik = 0, @JsonKey(name: 'yas') final  List<int> yasAraligi = const <int>[18, 99]}): _yasAraligi = yasAraligi,super._();
  factory _GirisSarti.fromJson(Map<String, dynamic> json) => _$GirisSartiFromJson(json);

@override@JsonKey() final  EgitimSeviyesi egitim;
/// Mesleğin sektöründe gereken asgari yetkinlik (0-100).
@override@JsonKey() final  int yetkinlik;
/// `[enAz, enCok]` — JSON'da iki elemanlı dizi olarak tutulur.
 final  List<int> _yasAraligi;
/// `[enAz, enCok]` — JSON'da iki elemanlı dizi olarak tutulur.
@override@JsonKey(name: 'yas') List<int> get yasAraligi {
  if (_yasAraligi is EqualUnmodifiableListView) return _yasAraligi;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_yasAraligi);
}


/// Create a copy of GirisSarti
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GirisSartiCopyWith<_GirisSarti> get copyWith => __$GirisSartiCopyWithImpl<_GirisSarti>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GirisSartiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GirisSarti&&(identical(other.egitim, egitim) || other.egitim == egitim)&&(identical(other.yetkinlik, yetkinlik) || other.yetkinlik == yetkinlik)&&const DeepCollectionEquality().equals(other._yasAraligi, _yasAraligi));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,egitim,yetkinlik,const DeepCollectionEquality().hash(_yasAraligi));

@override
String toString() {
  return 'GirisSarti(egitim: $egitim, yetkinlik: $yetkinlik, yasAraligi: $yasAraligi)';
}


}

/// @nodoc
abstract mixin class _$GirisSartiCopyWith<$Res> implements $GirisSartiCopyWith<$Res> {
  factory _$GirisSartiCopyWith(_GirisSarti value, $Res Function(_GirisSarti) _then) = __$GirisSartiCopyWithImpl;
@override @useResult
$Res call({
 EgitimSeviyesi egitim, int yetkinlik,@JsonKey(name: 'yas') List<int> yasAraligi
});




}
/// @nodoc
class __$GirisSartiCopyWithImpl<$Res>
    implements _$GirisSartiCopyWith<$Res> {
  __$GirisSartiCopyWithImpl(this._self, this._then);

  final _GirisSarti _self;
  final $Res Function(_GirisSarti) _then;

/// Create a copy of GirisSarti
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? egitim = null,Object? yetkinlik = null,Object? yasAraligi = null,}) {
  return _then(_GirisSarti(
egitim: null == egitim ? _self.egitim : egitim // ignore: cast_nullable_to_non_nullable
as EgitimSeviyesi,yetkinlik: null == yetkinlik ? _self.yetkinlik : yetkinlik // ignore: cast_nullable_to_non_nullable
as int,yasAraligi: null == yasAraligi ? _self._yasAraligi : yasAraligi // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}


/// @nodoc
mixin _$Kademe {

 String get ad;/// Bugünkü TL cinsinden TABAN maaş. Motor bunu enflasyon endeksiyle
/// çarpar; sabit tutulursa 20 tur sonra anlamsızlaşır.
 int get maas;/// Bu kademeye geçmek için gereken sektör yetkinliği (0-100).
 int get yetkinlikGerek;/// Bu kademede geçirilmesi gereken asgari tur. Son kademede null.
 int? get sureTur;
/// Create a copy of Kademe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KademeCopyWith<Kademe> get copyWith => _$KademeCopyWithImpl<Kademe>(this as Kademe, _$identity);

  /// Serializes this Kademe to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Kademe&&(identical(other.ad, ad) || other.ad == ad)&&(identical(other.maas, maas) || other.maas == maas)&&(identical(other.yetkinlikGerek, yetkinlikGerek) || other.yetkinlikGerek == yetkinlikGerek)&&(identical(other.sureTur, sureTur) || other.sureTur == sureTur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ad,maas,yetkinlikGerek,sureTur);

@override
String toString() {
  return 'Kademe(ad: $ad, maas: $maas, yetkinlikGerek: $yetkinlikGerek, sureTur: $sureTur)';
}


}

/// @nodoc
abstract mixin class $KademeCopyWith<$Res>  {
  factory $KademeCopyWith(Kademe value, $Res Function(Kademe) _then) = _$KademeCopyWithImpl;
@useResult
$Res call({
 String ad, int maas, int yetkinlikGerek, int? sureTur
});




}
/// @nodoc
class _$KademeCopyWithImpl<$Res>
    implements $KademeCopyWith<$Res> {
  _$KademeCopyWithImpl(this._self, this._then);

  final Kademe _self;
  final $Res Function(Kademe) _then;

/// Create a copy of Kademe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ad = null,Object? maas = null,Object? yetkinlikGerek = null,Object? sureTur = freezed,}) {
  return _then(_self.copyWith(
ad: null == ad ? _self.ad : ad // ignore: cast_nullable_to_non_nullable
as String,maas: null == maas ? _self.maas : maas // ignore: cast_nullable_to_non_nullable
as int,yetkinlikGerek: null == yetkinlikGerek ? _self.yetkinlikGerek : yetkinlikGerek // ignore: cast_nullable_to_non_nullable
as int,sureTur: freezed == sureTur ? _self.sureTur : sureTur // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Kademe].
extension KademePatterns on Kademe {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Kademe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Kademe() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Kademe value)  $default,){
final _that = this;
switch (_that) {
case _Kademe():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Kademe value)?  $default,){
final _that = this;
switch (_that) {
case _Kademe() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ad,  int maas,  int yetkinlikGerek,  int? sureTur)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Kademe() when $default != null:
return $default(_that.ad,_that.maas,_that.yetkinlikGerek,_that.sureTur);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ad,  int maas,  int yetkinlikGerek,  int? sureTur)  $default,) {final _that = this;
switch (_that) {
case _Kademe():
return $default(_that.ad,_that.maas,_that.yetkinlikGerek,_that.sureTur);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ad,  int maas,  int yetkinlikGerek,  int? sureTur)?  $default,) {final _that = this;
switch (_that) {
case _Kademe() when $default != null:
return $default(_that.ad,_that.maas,_that.yetkinlikGerek,_that.sureTur);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Kademe extends Kademe {
  const _Kademe({required this.ad, required this.maas, this.yetkinlikGerek = 0, this.sureTur}): super._();
  factory _Kademe.fromJson(Map<String, dynamic> json) => _$KademeFromJson(json);

@override final  String ad;
/// Bugünkü TL cinsinden TABAN maaş. Motor bunu enflasyon endeksiyle
/// çarpar; sabit tutulursa 20 tur sonra anlamsızlaşır.
@override final  int maas;
/// Bu kademeye geçmek için gereken sektör yetkinliği (0-100).
@override@JsonKey() final  int yetkinlikGerek;
/// Bu kademede geçirilmesi gereken asgari tur. Son kademede null.
@override final  int? sureTur;

/// Create a copy of Kademe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KademeCopyWith<_Kademe> get copyWith => __$KademeCopyWithImpl<_Kademe>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KademeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Kademe&&(identical(other.ad, ad) || other.ad == ad)&&(identical(other.maas, maas) || other.maas == maas)&&(identical(other.yetkinlikGerek, yetkinlikGerek) || other.yetkinlikGerek == yetkinlikGerek)&&(identical(other.sureTur, sureTur) || other.sureTur == sureTur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ad,maas,yetkinlikGerek,sureTur);

@override
String toString() {
  return 'Kademe(ad: $ad, maas: $maas, yetkinlikGerek: $yetkinlikGerek, sureTur: $sureTur)';
}


}

/// @nodoc
abstract mixin class _$KademeCopyWith<$Res> implements $KademeCopyWith<$Res> {
  factory _$KademeCopyWith(_Kademe value, $Res Function(_Kademe) _then) = __$KademeCopyWithImpl;
@override @useResult
$Res call({
 String ad, int maas, int yetkinlikGerek, int? sureTur
});




}
/// @nodoc
class __$KademeCopyWithImpl<$Res>
    implements _$KademeCopyWith<$Res> {
  __$KademeCopyWithImpl(this._self, this._then);

  final _Kademe _self;
  final $Res Function(_Kademe) _then;

/// Create a copy of Kademe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ad = null,Object? maas = null,Object? yetkinlikGerek = null,Object? sureTur = freezed,}) {
  return _then(_Kademe(
ad: null == ad ? _self.ad : ad // ignore: cast_nullable_to_non_nullable
as String,maas: null == maas ? _self.maas : maas // ignore: cast_nullable_to_non_nullable
as int,yetkinlikGerek: null == yetkinlikGerek ? _self.yetkinlikGerek : yetkinlikGerek // ignore: cast_nullable_to_non_nullable
as int,sureTur: freezed == sureTur ? _self.sureTur : sureTur // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$Meslek {

 String get id; String get ad; Sektor get sektor; GirisSarti get girisSarti; List<Kademe> get kademeler;/// Turda kazanılan yetkinlik çarpanı.
 double get yetkinlikArtisHizi;/// Turda kazanılan itibar/network çarpanı.
 double get networkArtisi;/// Her turda yakılan enerji.
 int get enerjiMaliyeti;/// Maaşın tur bazında oynaklığı (0 = memur, 0.6 = emlakçı).
 double get gelirVaryansi;/// Gelirin dövize endeksli oranı (0-1). Kur şokunda koruma sağlar.
 double get dovizOrani;/// Bu meslekle açılabilen işletme kimlikleri.
 List<String> get acilanIsletmeler;/// Bu mesleğe özel olay kartı kimlikleri.
 List<String> get olayHavuzu;
/// Create a copy of Meslek
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeslekCopyWith<Meslek> get copyWith => _$MeslekCopyWithImpl<Meslek>(this as Meslek, _$identity);

  /// Serializes this Meslek to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Meslek&&(identical(other.id, id) || other.id == id)&&(identical(other.ad, ad) || other.ad == ad)&&(identical(other.sektor, sektor) || other.sektor == sektor)&&(identical(other.girisSarti, girisSarti) || other.girisSarti == girisSarti)&&const DeepCollectionEquality().equals(other.kademeler, kademeler)&&(identical(other.yetkinlikArtisHizi, yetkinlikArtisHizi) || other.yetkinlikArtisHizi == yetkinlikArtisHizi)&&(identical(other.networkArtisi, networkArtisi) || other.networkArtisi == networkArtisi)&&(identical(other.enerjiMaliyeti, enerjiMaliyeti) || other.enerjiMaliyeti == enerjiMaliyeti)&&(identical(other.gelirVaryansi, gelirVaryansi) || other.gelirVaryansi == gelirVaryansi)&&(identical(other.dovizOrani, dovizOrani) || other.dovizOrani == dovizOrani)&&const DeepCollectionEquality().equals(other.acilanIsletmeler, acilanIsletmeler)&&const DeepCollectionEquality().equals(other.olayHavuzu, olayHavuzu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ad,sektor,girisSarti,const DeepCollectionEquality().hash(kademeler),yetkinlikArtisHizi,networkArtisi,enerjiMaliyeti,gelirVaryansi,dovizOrani,const DeepCollectionEquality().hash(acilanIsletmeler),const DeepCollectionEquality().hash(olayHavuzu));

@override
String toString() {
  return 'Meslek(id: $id, ad: $ad, sektor: $sektor, girisSarti: $girisSarti, kademeler: $kademeler, yetkinlikArtisHizi: $yetkinlikArtisHizi, networkArtisi: $networkArtisi, enerjiMaliyeti: $enerjiMaliyeti, gelirVaryansi: $gelirVaryansi, dovizOrani: $dovizOrani, acilanIsletmeler: $acilanIsletmeler, olayHavuzu: $olayHavuzu)';
}


}

/// @nodoc
abstract mixin class $MeslekCopyWith<$Res>  {
  factory $MeslekCopyWith(Meslek value, $Res Function(Meslek) _then) = _$MeslekCopyWithImpl;
@useResult
$Res call({
 String id, String ad, Sektor sektor, GirisSarti girisSarti, List<Kademe> kademeler, double yetkinlikArtisHizi, double networkArtisi, int enerjiMaliyeti, double gelirVaryansi, double dovizOrani, List<String> acilanIsletmeler, List<String> olayHavuzu
});


$GirisSartiCopyWith<$Res> get girisSarti;

}
/// @nodoc
class _$MeslekCopyWithImpl<$Res>
    implements $MeslekCopyWith<$Res> {
  _$MeslekCopyWithImpl(this._self, this._then);

  final Meslek _self;
  final $Res Function(Meslek) _then;

/// Create a copy of Meslek
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ad = null,Object? sektor = null,Object? girisSarti = null,Object? kademeler = null,Object? yetkinlikArtisHizi = null,Object? networkArtisi = null,Object? enerjiMaliyeti = null,Object? gelirVaryansi = null,Object? dovizOrani = null,Object? acilanIsletmeler = null,Object? olayHavuzu = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ad: null == ad ? _self.ad : ad // ignore: cast_nullable_to_non_nullable
as String,sektor: null == sektor ? _self.sektor : sektor // ignore: cast_nullable_to_non_nullable
as Sektor,girisSarti: null == girisSarti ? _self.girisSarti : girisSarti // ignore: cast_nullable_to_non_nullable
as GirisSarti,kademeler: null == kademeler ? _self.kademeler : kademeler // ignore: cast_nullable_to_non_nullable
as List<Kademe>,yetkinlikArtisHizi: null == yetkinlikArtisHizi ? _self.yetkinlikArtisHizi : yetkinlikArtisHizi // ignore: cast_nullable_to_non_nullable
as double,networkArtisi: null == networkArtisi ? _self.networkArtisi : networkArtisi // ignore: cast_nullable_to_non_nullable
as double,enerjiMaliyeti: null == enerjiMaliyeti ? _self.enerjiMaliyeti : enerjiMaliyeti // ignore: cast_nullable_to_non_nullable
as int,gelirVaryansi: null == gelirVaryansi ? _self.gelirVaryansi : gelirVaryansi // ignore: cast_nullable_to_non_nullable
as double,dovizOrani: null == dovizOrani ? _self.dovizOrani : dovizOrani // ignore: cast_nullable_to_non_nullable
as double,acilanIsletmeler: null == acilanIsletmeler ? _self.acilanIsletmeler : acilanIsletmeler // ignore: cast_nullable_to_non_nullable
as List<String>,olayHavuzu: null == olayHavuzu ? _self.olayHavuzu : olayHavuzu // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of Meslek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GirisSartiCopyWith<$Res> get girisSarti {
  
  return $GirisSartiCopyWith<$Res>(_self.girisSarti, (value) {
    return _then(_self.copyWith(girisSarti: value));
  });
}
}


/// Adds pattern-matching-related methods to [Meslek].
extension MeslekPatterns on Meslek {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Meslek value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Meslek() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Meslek value)  $default,){
final _that = this;
switch (_that) {
case _Meslek():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Meslek value)?  $default,){
final _that = this;
switch (_that) {
case _Meslek() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ad,  Sektor sektor,  GirisSarti girisSarti,  List<Kademe> kademeler,  double yetkinlikArtisHizi,  double networkArtisi,  int enerjiMaliyeti,  double gelirVaryansi,  double dovizOrani,  List<String> acilanIsletmeler,  List<String> olayHavuzu)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Meslek() when $default != null:
return $default(_that.id,_that.ad,_that.sektor,_that.girisSarti,_that.kademeler,_that.yetkinlikArtisHizi,_that.networkArtisi,_that.enerjiMaliyeti,_that.gelirVaryansi,_that.dovizOrani,_that.acilanIsletmeler,_that.olayHavuzu);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ad,  Sektor sektor,  GirisSarti girisSarti,  List<Kademe> kademeler,  double yetkinlikArtisHizi,  double networkArtisi,  int enerjiMaliyeti,  double gelirVaryansi,  double dovizOrani,  List<String> acilanIsletmeler,  List<String> olayHavuzu)  $default,) {final _that = this;
switch (_that) {
case _Meslek():
return $default(_that.id,_that.ad,_that.sektor,_that.girisSarti,_that.kademeler,_that.yetkinlikArtisHizi,_that.networkArtisi,_that.enerjiMaliyeti,_that.gelirVaryansi,_that.dovizOrani,_that.acilanIsletmeler,_that.olayHavuzu);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ad,  Sektor sektor,  GirisSarti girisSarti,  List<Kademe> kademeler,  double yetkinlikArtisHizi,  double networkArtisi,  int enerjiMaliyeti,  double gelirVaryansi,  double dovizOrani,  List<String> acilanIsletmeler,  List<String> olayHavuzu)?  $default,) {final _that = this;
switch (_that) {
case _Meslek() when $default != null:
return $default(_that.id,_that.ad,_that.sektor,_that.girisSarti,_that.kademeler,_that.yetkinlikArtisHizi,_that.networkArtisi,_that.enerjiMaliyeti,_that.gelirVaryansi,_that.dovizOrani,_that.acilanIsletmeler,_that.olayHavuzu);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Meslek extends Meslek {
  const _Meslek({required this.id, required this.ad, required this.sektor, this.girisSarti = const GirisSarti(), required final  List<Kademe> kademeler, this.yetkinlikArtisHizi = 1.0, this.networkArtisi = 0.5, this.enerjiMaliyeti = 3, this.gelirVaryansi = 0.0, this.dovizOrani = 0.0, final  List<String> acilanIsletmeler = const <String>[], final  List<String> olayHavuzu = const <String>[]}): _kademeler = kademeler,_acilanIsletmeler = acilanIsletmeler,_olayHavuzu = olayHavuzu,super._();
  factory _Meslek.fromJson(Map<String, dynamic> json) => _$MeslekFromJson(json);

@override final  String id;
@override final  String ad;
@override final  Sektor sektor;
@override@JsonKey() final  GirisSarti girisSarti;
 final  List<Kademe> _kademeler;
@override List<Kademe> get kademeler {
  if (_kademeler is EqualUnmodifiableListView) return _kademeler;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_kademeler);
}

/// Turda kazanılan yetkinlik çarpanı.
@override@JsonKey() final  double yetkinlikArtisHizi;
/// Turda kazanılan itibar/network çarpanı.
@override@JsonKey() final  double networkArtisi;
/// Her turda yakılan enerji.
@override@JsonKey() final  int enerjiMaliyeti;
/// Maaşın tur bazında oynaklığı (0 = memur, 0.6 = emlakçı).
@override@JsonKey() final  double gelirVaryansi;
/// Gelirin dövize endeksli oranı (0-1). Kur şokunda koruma sağlar.
@override@JsonKey() final  double dovizOrani;
/// Bu meslekle açılabilen işletme kimlikleri.
 final  List<String> _acilanIsletmeler;
/// Bu meslekle açılabilen işletme kimlikleri.
@override@JsonKey() List<String> get acilanIsletmeler {
  if (_acilanIsletmeler is EqualUnmodifiableListView) return _acilanIsletmeler;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_acilanIsletmeler);
}

/// Bu mesleğe özel olay kartı kimlikleri.
 final  List<String> _olayHavuzu;
/// Bu mesleğe özel olay kartı kimlikleri.
@override@JsonKey() List<String> get olayHavuzu {
  if (_olayHavuzu is EqualUnmodifiableListView) return _olayHavuzu;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_olayHavuzu);
}


/// Create a copy of Meslek
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeslekCopyWith<_Meslek> get copyWith => __$MeslekCopyWithImpl<_Meslek>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeslekToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Meslek&&(identical(other.id, id) || other.id == id)&&(identical(other.ad, ad) || other.ad == ad)&&(identical(other.sektor, sektor) || other.sektor == sektor)&&(identical(other.girisSarti, girisSarti) || other.girisSarti == girisSarti)&&const DeepCollectionEquality().equals(other._kademeler, _kademeler)&&(identical(other.yetkinlikArtisHizi, yetkinlikArtisHizi) || other.yetkinlikArtisHizi == yetkinlikArtisHizi)&&(identical(other.networkArtisi, networkArtisi) || other.networkArtisi == networkArtisi)&&(identical(other.enerjiMaliyeti, enerjiMaliyeti) || other.enerjiMaliyeti == enerjiMaliyeti)&&(identical(other.gelirVaryansi, gelirVaryansi) || other.gelirVaryansi == gelirVaryansi)&&(identical(other.dovizOrani, dovizOrani) || other.dovizOrani == dovizOrani)&&const DeepCollectionEquality().equals(other._acilanIsletmeler, _acilanIsletmeler)&&const DeepCollectionEquality().equals(other._olayHavuzu, _olayHavuzu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ad,sektor,girisSarti,const DeepCollectionEquality().hash(_kademeler),yetkinlikArtisHizi,networkArtisi,enerjiMaliyeti,gelirVaryansi,dovizOrani,const DeepCollectionEquality().hash(_acilanIsletmeler),const DeepCollectionEquality().hash(_olayHavuzu));

@override
String toString() {
  return 'Meslek(id: $id, ad: $ad, sektor: $sektor, girisSarti: $girisSarti, kademeler: $kademeler, yetkinlikArtisHizi: $yetkinlikArtisHizi, networkArtisi: $networkArtisi, enerjiMaliyeti: $enerjiMaliyeti, gelirVaryansi: $gelirVaryansi, dovizOrani: $dovizOrani, acilanIsletmeler: $acilanIsletmeler, olayHavuzu: $olayHavuzu)';
}


}

/// @nodoc
abstract mixin class _$MeslekCopyWith<$Res> implements $MeslekCopyWith<$Res> {
  factory _$MeslekCopyWith(_Meslek value, $Res Function(_Meslek) _then) = __$MeslekCopyWithImpl;
@override @useResult
$Res call({
 String id, String ad, Sektor sektor, GirisSarti girisSarti, List<Kademe> kademeler, double yetkinlikArtisHizi, double networkArtisi, int enerjiMaliyeti, double gelirVaryansi, double dovizOrani, List<String> acilanIsletmeler, List<String> olayHavuzu
});


@override $GirisSartiCopyWith<$Res> get girisSarti;

}
/// @nodoc
class __$MeslekCopyWithImpl<$Res>
    implements _$MeslekCopyWith<$Res> {
  __$MeslekCopyWithImpl(this._self, this._then);

  final _Meslek _self;
  final $Res Function(_Meslek) _then;

/// Create a copy of Meslek
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ad = null,Object? sektor = null,Object? girisSarti = null,Object? kademeler = null,Object? yetkinlikArtisHizi = null,Object? networkArtisi = null,Object? enerjiMaliyeti = null,Object? gelirVaryansi = null,Object? dovizOrani = null,Object? acilanIsletmeler = null,Object? olayHavuzu = null,}) {
  return _then(_Meslek(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ad: null == ad ? _self.ad : ad // ignore: cast_nullable_to_non_nullable
as String,sektor: null == sektor ? _self.sektor : sektor // ignore: cast_nullable_to_non_nullable
as Sektor,girisSarti: null == girisSarti ? _self.girisSarti : girisSarti // ignore: cast_nullable_to_non_nullable
as GirisSarti,kademeler: null == kademeler ? _self._kademeler : kademeler // ignore: cast_nullable_to_non_nullable
as List<Kademe>,yetkinlikArtisHizi: null == yetkinlikArtisHizi ? _self.yetkinlikArtisHizi : yetkinlikArtisHizi // ignore: cast_nullable_to_non_nullable
as double,networkArtisi: null == networkArtisi ? _self.networkArtisi : networkArtisi // ignore: cast_nullable_to_non_nullable
as double,enerjiMaliyeti: null == enerjiMaliyeti ? _self.enerjiMaliyeti : enerjiMaliyeti // ignore: cast_nullable_to_non_nullable
as int,gelirVaryansi: null == gelirVaryansi ? _self.gelirVaryansi : gelirVaryansi // ignore: cast_nullable_to_non_nullable
as double,dovizOrani: null == dovizOrani ? _self.dovizOrani : dovizOrani // ignore: cast_nullable_to_non_nullable
as double,acilanIsletmeler: null == acilanIsletmeler ? _self._acilanIsletmeler : acilanIsletmeler // ignore: cast_nullable_to_non_nullable
as List<String>,olayHavuzu: null == olayHavuzu ? _self._olayHavuzu : olayHavuzu // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of Meslek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GirisSartiCopyWith<$Res> get girisSarti {
  
  return $GirisSartiCopyWith<$Res>(_self.girisSarti, (value) {
    return _then(_self.copyWith(girisSarti: value));
  });
}
}

// dart format on
