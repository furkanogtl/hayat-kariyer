// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'isletme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Kalem {

 String get ad; KalemTuru get tur;/// TABAN TL (2026 ölçeği). Motor enflasyon endeksiyle çarpar.
/// [KalemTuru.cirodanPay] için kullanılmaz.
 int get taban;/// [KalemTuru.stataBagli] için: hangi özel stat (0-100).
 String? get statId;/// [KalemTuru.cirodanPay] için: cironun kaçta kaçı (0-1).
 double get oran;/// Kaç turda bir işler. 1 = her ay, 12 = yılda bir (vergi, sigorta).
 int get periyotTur;
/// Create a copy of Kalem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KalemCopyWith<Kalem> get copyWith => _$KalemCopyWithImpl<Kalem>(this as Kalem, _$identity);

  /// Serializes this Kalem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Kalem&&(identical(other.ad, ad) || other.ad == ad)&&(identical(other.tur, tur) || other.tur == tur)&&(identical(other.taban, taban) || other.taban == taban)&&(identical(other.statId, statId) || other.statId == statId)&&(identical(other.oran, oran) || other.oran == oran)&&(identical(other.periyotTur, periyotTur) || other.periyotTur == periyotTur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ad,tur,taban,statId,oran,periyotTur);

@override
String toString() {
  return 'Kalem(ad: $ad, tur: $tur, taban: $taban, statId: $statId, oran: $oran, periyotTur: $periyotTur)';
}


}

/// @nodoc
abstract mixin class $KalemCopyWith<$Res>  {
  factory $KalemCopyWith(Kalem value, $Res Function(Kalem) _then) = _$KalemCopyWithImpl;
@useResult
$Res call({
 String ad, KalemTuru tur, int taban, String? statId, double oran, int periyotTur
});




}
/// @nodoc
class _$KalemCopyWithImpl<$Res>
    implements $KalemCopyWith<$Res> {
  _$KalemCopyWithImpl(this._self, this._then);

  final Kalem _self;
  final $Res Function(Kalem) _then;

/// Create a copy of Kalem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ad = null,Object? tur = null,Object? taban = null,Object? statId = freezed,Object? oran = null,Object? periyotTur = null,}) {
  return _then(_self.copyWith(
ad: null == ad ? _self.ad : ad // ignore: cast_nullable_to_non_nullable
as String,tur: null == tur ? _self.tur : tur // ignore: cast_nullable_to_non_nullable
as KalemTuru,taban: null == taban ? _self.taban : taban // ignore: cast_nullable_to_non_nullable
as int,statId: freezed == statId ? _self.statId : statId // ignore: cast_nullable_to_non_nullable
as String?,oran: null == oran ? _self.oran : oran // ignore: cast_nullable_to_non_nullable
as double,periyotTur: null == periyotTur ? _self.periyotTur : periyotTur // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Kalem].
extension KalemPatterns on Kalem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Kalem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Kalem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Kalem value)  $default,){
final _that = this;
switch (_that) {
case _Kalem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Kalem value)?  $default,){
final _that = this;
switch (_that) {
case _Kalem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ad,  KalemTuru tur,  int taban,  String? statId,  double oran,  int periyotTur)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Kalem() when $default != null:
return $default(_that.ad,_that.tur,_that.taban,_that.statId,_that.oran,_that.periyotTur);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ad,  KalemTuru tur,  int taban,  String? statId,  double oran,  int periyotTur)  $default,) {final _that = this;
switch (_that) {
case _Kalem():
return $default(_that.ad,_that.tur,_that.taban,_that.statId,_that.oran,_that.periyotTur);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ad,  KalemTuru tur,  int taban,  String? statId,  double oran,  int periyotTur)?  $default,) {final _that = this;
switch (_that) {
case _Kalem() when $default != null:
return $default(_that.ad,_that.tur,_that.taban,_that.statId,_that.oran,_that.periyotTur);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Kalem extends Kalem {
  const _Kalem({required this.ad, this.tur = KalemTuru.sabit, this.taban = 0, this.statId, this.oran = 0.0, this.periyotTur = 1}): super._();
  factory _Kalem.fromJson(Map<String, dynamic> json) => _$KalemFromJson(json);

@override final  String ad;
@override@JsonKey() final  KalemTuru tur;
/// TABAN TL (2026 ölçeği). Motor enflasyon endeksiyle çarpar.
/// [KalemTuru.cirodanPay] için kullanılmaz.
@override@JsonKey() final  int taban;
/// [KalemTuru.stataBagli] için: hangi özel stat (0-100).
@override final  String? statId;
/// [KalemTuru.cirodanPay] için: cironun kaçta kaçı (0-1).
@override@JsonKey() final  double oran;
/// Kaç turda bir işler. 1 = her ay, 12 = yılda bir (vergi, sigorta).
@override@JsonKey() final  int periyotTur;

/// Create a copy of Kalem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KalemCopyWith<_Kalem> get copyWith => __$KalemCopyWithImpl<_Kalem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KalemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Kalem&&(identical(other.ad, ad) || other.ad == ad)&&(identical(other.tur, tur) || other.tur == tur)&&(identical(other.taban, taban) || other.taban == taban)&&(identical(other.statId, statId) || other.statId == statId)&&(identical(other.oran, oran) || other.oran == oran)&&(identical(other.periyotTur, periyotTur) || other.periyotTur == periyotTur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ad,tur,taban,statId,oran,periyotTur);

@override
String toString() {
  return 'Kalem(ad: $ad, tur: $tur, taban: $taban, statId: $statId, oran: $oran, periyotTur: $periyotTur)';
}


}

/// @nodoc
abstract mixin class _$KalemCopyWith<$Res> implements $KalemCopyWith<$Res> {
  factory _$KalemCopyWith(_Kalem value, $Res Function(_Kalem) _then) = __$KalemCopyWithImpl;
@override @useResult
$Res call({
 String ad, KalemTuru tur, int taban, String? statId, double oran, int periyotTur
});




}
/// @nodoc
class __$KalemCopyWithImpl<$Res>
    implements _$KalemCopyWith<$Res> {
  __$KalemCopyWithImpl(this._self, this._then);

  final _Kalem _self;
  final $Res Function(_Kalem) _then;

/// Create a copy of Kalem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ad = null,Object? tur = null,Object? taban = null,Object? statId = freezed,Object? oran = null,Object? periyotTur = null,}) {
  return _then(_Kalem(
ad: null == ad ? _self.ad : ad // ignore: cast_nullable_to_non_nullable
as String,tur: null == tur ? _self.tur : tur // ignore: cast_nullable_to_non_nullable
as KalemTuru,taban: null == taban ? _self.taban : taban // ignore: cast_nullable_to_non_nullable
as int,statId: freezed == statId ? _self.statId : statId // ignore: cast_nullable_to_non_nullable
as String?,oran: null == oran ? _self.oran : oran // ignore: cast_nullable_to_non_nullable
as double,periyotTur: null == periyotTur ? _self.periyotTur : periyotTur // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$IsletmeGirisSarti {

/// Sektör yetkinliği: işletmeyi meslekten bağımsız açmak zor olmalı.
 Sektor? get sektor; int get yetkinlik; int get itibar; int get enAzYas;
/// Create a copy of IsletmeGirisSarti
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IsletmeGirisSartiCopyWith<IsletmeGirisSarti> get copyWith => _$IsletmeGirisSartiCopyWithImpl<IsletmeGirisSarti>(this as IsletmeGirisSarti, _$identity);

  /// Serializes this IsletmeGirisSarti to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IsletmeGirisSarti&&(identical(other.sektor, sektor) || other.sektor == sektor)&&(identical(other.yetkinlik, yetkinlik) || other.yetkinlik == yetkinlik)&&(identical(other.itibar, itibar) || other.itibar == itibar)&&(identical(other.enAzYas, enAzYas) || other.enAzYas == enAzYas));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sektor,yetkinlik,itibar,enAzYas);

@override
String toString() {
  return 'IsletmeGirisSarti(sektor: $sektor, yetkinlik: $yetkinlik, itibar: $itibar, enAzYas: $enAzYas)';
}


}

/// @nodoc
abstract mixin class $IsletmeGirisSartiCopyWith<$Res>  {
  factory $IsletmeGirisSartiCopyWith(IsletmeGirisSarti value, $Res Function(IsletmeGirisSarti) _then) = _$IsletmeGirisSartiCopyWithImpl;
@useResult
$Res call({
 Sektor? sektor, int yetkinlik, int itibar, int enAzYas
});




}
/// @nodoc
class _$IsletmeGirisSartiCopyWithImpl<$Res>
    implements $IsletmeGirisSartiCopyWith<$Res> {
  _$IsletmeGirisSartiCopyWithImpl(this._self, this._then);

  final IsletmeGirisSarti _self;
  final $Res Function(IsletmeGirisSarti) _then;

/// Create a copy of IsletmeGirisSarti
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sektor = freezed,Object? yetkinlik = null,Object? itibar = null,Object? enAzYas = null,}) {
  return _then(_self.copyWith(
sektor: freezed == sektor ? _self.sektor : sektor // ignore: cast_nullable_to_non_nullable
as Sektor?,yetkinlik: null == yetkinlik ? _self.yetkinlik : yetkinlik // ignore: cast_nullable_to_non_nullable
as int,itibar: null == itibar ? _self.itibar : itibar // ignore: cast_nullable_to_non_nullable
as int,enAzYas: null == enAzYas ? _self.enAzYas : enAzYas // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [IsletmeGirisSarti].
extension IsletmeGirisSartiPatterns on IsletmeGirisSarti {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IsletmeGirisSarti value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IsletmeGirisSarti() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IsletmeGirisSarti value)  $default,){
final _that = this;
switch (_that) {
case _IsletmeGirisSarti():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IsletmeGirisSarti value)?  $default,){
final _that = this;
switch (_that) {
case _IsletmeGirisSarti() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Sektor? sektor,  int yetkinlik,  int itibar,  int enAzYas)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IsletmeGirisSarti() when $default != null:
return $default(_that.sektor,_that.yetkinlik,_that.itibar,_that.enAzYas);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Sektor? sektor,  int yetkinlik,  int itibar,  int enAzYas)  $default,) {final _that = this;
switch (_that) {
case _IsletmeGirisSarti():
return $default(_that.sektor,_that.yetkinlik,_that.itibar,_that.enAzYas);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Sektor? sektor,  int yetkinlik,  int itibar,  int enAzYas)?  $default,) {final _that = this;
switch (_that) {
case _IsletmeGirisSarti() when $default != null:
return $default(_that.sektor,_that.yetkinlik,_that.itibar,_that.enAzYas);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IsletmeGirisSarti extends IsletmeGirisSarti {
  const _IsletmeGirisSarti({this.sektor, this.yetkinlik = 0, this.itibar = 0, this.enAzYas = 18}): super._();
  factory _IsletmeGirisSarti.fromJson(Map<String, dynamic> json) => _$IsletmeGirisSartiFromJson(json);

/// Sektör yetkinliği: işletmeyi meslekten bağımsız açmak zor olmalı.
@override final  Sektor? sektor;
@override@JsonKey() final  int yetkinlik;
@override@JsonKey() final  int itibar;
@override@JsonKey() final  int enAzYas;

/// Create a copy of IsletmeGirisSarti
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IsletmeGirisSartiCopyWith<_IsletmeGirisSarti> get copyWith => __$IsletmeGirisSartiCopyWithImpl<_IsletmeGirisSarti>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IsletmeGirisSartiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IsletmeGirisSarti&&(identical(other.sektor, sektor) || other.sektor == sektor)&&(identical(other.yetkinlik, yetkinlik) || other.yetkinlik == yetkinlik)&&(identical(other.itibar, itibar) || other.itibar == itibar)&&(identical(other.enAzYas, enAzYas) || other.enAzYas == enAzYas));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sektor,yetkinlik,itibar,enAzYas);

@override
String toString() {
  return 'IsletmeGirisSarti(sektor: $sektor, yetkinlik: $yetkinlik, itibar: $itibar, enAzYas: $enAzYas)';
}


}

/// @nodoc
abstract mixin class _$IsletmeGirisSartiCopyWith<$Res> implements $IsletmeGirisSartiCopyWith<$Res> {
  factory _$IsletmeGirisSartiCopyWith(_IsletmeGirisSarti value, $Res Function(_IsletmeGirisSarti) _then) = __$IsletmeGirisSartiCopyWithImpl;
@override @useResult
$Res call({
 Sektor? sektor, int yetkinlik, int itibar, int enAzYas
});




}
/// @nodoc
class __$IsletmeGirisSartiCopyWithImpl<$Res>
    implements _$IsletmeGirisSartiCopyWith<$Res> {
  __$IsletmeGirisSartiCopyWithImpl(this._self, this._then);

  final _IsletmeGirisSarti _self;
  final $Res Function(_IsletmeGirisSarti) _then;

/// Create a copy of IsletmeGirisSarti
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sektor = freezed,Object? yetkinlik = null,Object? itibar = null,Object? enAzYas = null,}) {
  return _then(_IsletmeGirisSarti(
sektor: freezed == sektor ? _self.sektor : sektor // ignore: cast_nullable_to_non_nullable
as Sektor?,yetkinlik: null == yetkinlik ? _self.yetkinlik : yetkinlik // ignore: cast_nullable_to_non_nullable
as int,itibar: null == itibar ? _self.itibar : itibar // ignore: cast_nullable_to_non_nullable
as int,enAzYas: null == enAzYas ? _self.enAzYas : enAzYas // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$IsletmeTanimi {

 String get id; String get ad;/// Kuruluş/satın alma maliyeti — TABAN TL.
 int get sermaye; List<Kalem> get gelirler; List<Kalem> get giderler;/// Oyuncunun her tur ayırması gereken ilgi puanı. Oyunun strateji
/// derinliğinin temeli: ilgi sınırlı bir kaynaktır, işletme sayısı
/// bununla sınırlanır.
 int get yonetimYuku;/// İtibara aylık katkı.
 double get prestij;/// Özel statların başlangıç değerleri (hepsi 0-100 ölçeğinde).
/// Ölçek ortak olmasaydı denge testi yazılamazdı.
 Map<String, int> get baslangicStatlari;/// Bu işletmeye özel olay kartı kimlikleri.
 List<String> get olayHavuzu; IsletmeGirisSarti get girisSarti;/// CEO/genel müdür aylığı — TABAN TL.
 int get ceoMaasi;/// CEO'nun düşürdüğü yönetim yükü oranı (0-1).
 double get ceoEtkinligi;/// Satışta yıllık kârın kaç katı isteniyor.
 double get degerCarpani;/// Satışın tamamlanması kaç tur sürer.
 int get satisSuresiTur;
/// Create a copy of IsletmeTanimi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IsletmeTanimiCopyWith<IsletmeTanimi> get copyWith => _$IsletmeTanimiCopyWithImpl<IsletmeTanimi>(this as IsletmeTanimi, _$identity);

  /// Serializes this IsletmeTanimi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IsletmeTanimi&&(identical(other.id, id) || other.id == id)&&(identical(other.ad, ad) || other.ad == ad)&&(identical(other.sermaye, sermaye) || other.sermaye == sermaye)&&const DeepCollectionEquality().equals(other.gelirler, gelirler)&&const DeepCollectionEquality().equals(other.giderler, giderler)&&(identical(other.yonetimYuku, yonetimYuku) || other.yonetimYuku == yonetimYuku)&&(identical(other.prestij, prestij) || other.prestij == prestij)&&const DeepCollectionEquality().equals(other.baslangicStatlari, baslangicStatlari)&&const DeepCollectionEquality().equals(other.olayHavuzu, olayHavuzu)&&(identical(other.girisSarti, girisSarti) || other.girisSarti == girisSarti)&&(identical(other.ceoMaasi, ceoMaasi) || other.ceoMaasi == ceoMaasi)&&(identical(other.ceoEtkinligi, ceoEtkinligi) || other.ceoEtkinligi == ceoEtkinligi)&&(identical(other.degerCarpani, degerCarpani) || other.degerCarpani == degerCarpani)&&(identical(other.satisSuresiTur, satisSuresiTur) || other.satisSuresiTur == satisSuresiTur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ad,sermaye,const DeepCollectionEquality().hash(gelirler),const DeepCollectionEquality().hash(giderler),yonetimYuku,prestij,const DeepCollectionEquality().hash(baslangicStatlari),const DeepCollectionEquality().hash(olayHavuzu),girisSarti,ceoMaasi,ceoEtkinligi,degerCarpani,satisSuresiTur);

@override
String toString() {
  return 'IsletmeTanimi(id: $id, ad: $ad, sermaye: $sermaye, gelirler: $gelirler, giderler: $giderler, yonetimYuku: $yonetimYuku, prestij: $prestij, baslangicStatlari: $baslangicStatlari, olayHavuzu: $olayHavuzu, girisSarti: $girisSarti, ceoMaasi: $ceoMaasi, ceoEtkinligi: $ceoEtkinligi, degerCarpani: $degerCarpani, satisSuresiTur: $satisSuresiTur)';
}


}

/// @nodoc
abstract mixin class $IsletmeTanimiCopyWith<$Res>  {
  factory $IsletmeTanimiCopyWith(IsletmeTanimi value, $Res Function(IsletmeTanimi) _then) = _$IsletmeTanimiCopyWithImpl;
@useResult
$Res call({
 String id, String ad, int sermaye, List<Kalem> gelirler, List<Kalem> giderler, int yonetimYuku, double prestij, Map<String, int> baslangicStatlari, List<String> olayHavuzu, IsletmeGirisSarti girisSarti, int ceoMaasi, double ceoEtkinligi, double degerCarpani, int satisSuresiTur
});


$IsletmeGirisSartiCopyWith<$Res> get girisSarti;

}
/// @nodoc
class _$IsletmeTanimiCopyWithImpl<$Res>
    implements $IsletmeTanimiCopyWith<$Res> {
  _$IsletmeTanimiCopyWithImpl(this._self, this._then);

  final IsletmeTanimi _self;
  final $Res Function(IsletmeTanimi) _then;

/// Create a copy of IsletmeTanimi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ad = null,Object? sermaye = null,Object? gelirler = null,Object? giderler = null,Object? yonetimYuku = null,Object? prestij = null,Object? baslangicStatlari = null,Object? olayHavuzu = null,Object? girisSarti = null,Object? ceoMaasi = null,Object? ceoEtkinligi = null,Object? degerCarpani = null,Object? satisSuresiTur = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ad: null == ad ? _self.ad : ad // ignore: cast_nullable_to_non_nullable
as String,sermaye: null == sermaye ? _self.sermaye : sermaye // ignore: cast_nullable_to_non_nullable
as int,gelirler: null == gelirler ? _self.gelirler : gelirler // ignore: cast_nullable_to_non_nullable
as List<Kalem>,giderler: null == giderler ? _self.giderler : giderler // ignore: cast_nullable_to_non_nullable
as List<Kalem>,yonetimYuku: null == yonetimYuku ? _self.yonetimYuku : yonetimYuku // ignore: cast_nullable_to_non_nullable
as int,prestij: null == prestij ? _self.prestij : prestij // ignore: cast_nullable_to_non_nullable
as double,baslangicStatlari: null == baslangicStatlari ? _self.baslangicStatlari : baslangicStatlari // ignore: cast_nullable_to_non_nullable
as Map<String, int>,olayHavuzu: null == olayHavuzu ? _self.olayHavuzu : olayHavuzu // ignore: cast_nullable_to_non_nullable
as List<String>,girisSarti: null == girisSarti ? _self.girisSarti : girisSarti // ignore: cast_nullable_to_non_nullable
as IsletmeGirisSarti,ceoMaasi: null == ceoMaasi ? _self.ceoMaasi : ceoMaasi // ignore: cast_nullable_to_non_nullable
as int,ceoEtkinligi: null == ceoEtkinligi ? _self.ceoEtkinligi : ceoEtkinligi // ignore: cast_nullable_to_non_nullable
as double,degerCarpani: null == degerCarpani ? _self.degerCarpani : degerCarpani // ignore: cast_nullable_to_non_nullable
as double,satisSuresiTur: null == satisSuresiTur ? _self.satisSuresiTur : satisSuresiTur // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of IsletmeTanimi
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IsletmeGirisSartiCopyWith<$Res> get girisSarti {
  
  return $IsletmeGirisSartiCopyWith<$Res>(_self.girisSarti, (value) {
    return _then(_self.copyWith(girisSarti: value));
  });
}
}


/// Adds pattern-matching-related methods to [IsletmeTanimi].
extension IsletmeTanimiPatterns on IsletmeTanimi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IsletmeTanimi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IsletmeTanimi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IsletmeTanimi value)  $default,){
final _that = this;
switch (_that) {
case _IsletmeTanimi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IsletmeTanimi value)?  $default,){
final _that = this;
switch (_that) {
case _IsletmeTanimi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ad,  int sermaye,  List<Kalem> gelirler,  List<Kalem> giderler,  int yonetimYuku,  double prestij,  Map<String, int> baslangicStatlari,  List<String> olayHavuzu,  IsletmeGirisSarti girisSarti,  int ceoMaasi,  double ceoEtkinligi,  double degerCarpani,  int satisSuresiTur)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IsletmeTanimi() when $default != null:
return $default(_that.id,_that.ad,_that.sermaye,_that.gelirler,_that.giderler,_that.yonetimYuku,_that.prestij,_that.baslangicStatlari,_that.olayHavuzu,_that.girisSarti,_that.ceoMaasi,_that.ceoEtkinligi,_that.degerCarpani,_that.satisSuresiTur);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ad,  int sermaye,  List<Kalem> gelirler,  List<Kalem> giderler,  int yonetimYuku,  double prestij,  Map<String, int> baslangicStatlari,  List<String> olayHavuzu,  IsletmeGirisSarti girisSarti,  int ceoMaasi,  double ceoEtkinligi,  double degerCarpani,  int satisSuresiTur)  $default,) {final _that = this;
switch (_that) {
case _IsletmeTanimi():
return $default(_that.id,_that.ad,_that.sermaye,_that.gelirler,_that.giderler,_that.yonetimYuku,_that.prestij,_that.baslangicStatlari,_that.olayHavuzu,_that.girisSarti,_that.ceoMaasi,_that.ceoEtkinligi,_that.degerCarpani,_that.satisSuresiTur);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ad,  int sermaye,  List<Kalem> gelirler,  List<Kalem> giderler,  int yonetimYuku,  double prestij,  Map<String, int> baslangicStatlari,  List<String> olayHavuzu,  IsletmeGirisSarti girisSarti,  int ceoMaasi,  double ceoEtkinligi,  double degerCarpani,  int satisSuresiTur)?  $default,) {final _that = this;
switch (_that) {
case _IsletmeTanimi() when $default != null:
return $default(_that.id,_that.ad,_that.sermaye,_that.gelirler,_that.giderler,_that.yonetimYuku,_that.prestij,_that.baslangicStatlari,_that.olayHavuzu,_that.girisSarti,_that.ceoMaasi,_that.ceoEtkinligi,_that.degerCarpani,_that.satisSuresiTur);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IsletmeTanimi extends IsletmeTanimi {
  const _IsletmeTanimi({required this.id, required this.ad, required this.sermaye, final  List<Kalem> gelirler = const <Kalem>[], final  List<Kalem> giderler = const <Kalem>[], this.yonetimYuku = 1, this.prestij = 0.0, final  Map<String, int> baslangicStatlari = const <String, int>{}, final  List<String> olayHavuzu = const <String>[], this.girisSarti = const IsletmeGirisSarti(), required this.ceoMaasi, this.ceoEtkinligi = 0.7, this.degerCarpani = 3.0, this.satisSuresiTur = 3}): _gelirler = gelirler,_giderler = giderler,_baslangicStatlari = baslangicStatlari,_olayHavuzu = olayHavuzu,super._();
  factory _IsletmeTanimi.fromJson(Map<String, dynamic> json) => _$IsletmeTanimiFromJson(json);

@override final  String id;
@override final  String ad;
/// Kuruluş/satın alma maliyeti — TABAN TL.
@override final  int sermaye;
 final  List<Kalem> _gelirler;
@override@JsonKey() List<Kalem> get gelirler {
  if (_gelirler is EqualUnmodifiableListView) return _gelirler;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gelirler);
}

 final  List<Kalem> _giderler;
@override@JsonKey() List<Kalem> get giderler {
  if (_giderler is EqualUnmodifiableListView) return _giderler;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_giderler);
}

/// Oyuncunun her tur ayırması gereken ilgi puanı. Oyunun strateji
/// derinliğinin temeli: ilgi sınırlı bir kaynaktır, işletme sayısı
/// bununla sınırlanır.
@override@JsonKey() final  int yonetimYuku;
/// İtibara aylık katkı.
@override@JsonKey() final  double prestij;
/// Özel statların başlangıç değerleri (hepsi 0-100 ölçeğinde).
/// Ölçek ortak olmasaydı denge testi yazılamazdı.
 final  Map<String, int> _baslangicStatlari;
/// Özel statların başlangıç değerleri (hepsi 0-100 ölçeğinde).
/// Ölçek ortak olmasaydı denge testi yazılamazdı.
@override@JsonKey() Map<String, int> get baslangicStatlari {
  if (_baslangicStatlari is EqualUnmodifiableMapView) return _baslangicStatlari;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_baslangicStatlari);
}

/// Bu işletmeye özel olay kartı kimlikleri.
 final  List<String> _olayHavuzu;
/// Bu işletmeye özel olay kartı kimlikleri.
@override@JsonKey() List<String> get olayHavuzu {
  if (_olayHavuzu is EqualUnmodifiableListView) return _olayHavuzu;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_olayHavuzu);
}

@override@JsonKey() final  IsletmeGirisSarti girisSarti;
/// CEO/genel müdür aylığı — TABAN TL.
@override final  int ceoMaasi;
/// CEO'nun düşürdüğü yönetim yükü oranı (0-1).
@override@JsonKey() final  double ceoEtkinligi;
/// Satışta yıllık kârın kaç katı isteniyor.
@override@JsonKey() final  double degerCarpani;
/// Satışın tamamlanması kaç tur sürer.
@override@JsonKey() final  int satisSuresiTur;

/// Create a copy of IsletmeTanimi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IsletmeTanimiCopyWith<_IsletmeTanimi> get copyWith => __$IsletmeTanimiCopyWithImpl<_IsletmeTanimi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IsletmeTanimiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IsletmeTanimi&&(identical(other.id, id) || other.id == id)&&(identical(other.ad, ad) || other.ad == ad)&&(identical(other.sermaye, sermaye) || other.sermaye == sermaye)&&const DeepCollectionEquality().equals(other._gelirler, _gelirler)&&const DeepCollectionEquality().equals(other._giderler, _giderler)&&(identical(other.yonetimYuku, yonetimYuku) || other.yonetimYuku == yonetimYuku)&&(identical(other.prestij, prestij) || other.prestij == prestij)&&const DeepCollectionEquality().equals(other._baslangicStatlari, _baslangicStatlari)&&const DeepCollectionEquality().equals(other._olayHavuzu, _olayHavuzu)&&(identical(other.girisSarti, girisSarti) || other.girisSarti == girisSarti)&&(identical(other.ceoMaasi, ceoMaasi) || other.ceoMaasi == ceoMaasi)&&(identical(other.ceoEtkinligi, ceoEtkinligi) || other.ceoEtkinligi == ceoEtkinligi)&&(identical(other.degerCarpani, degerCarpani) || other.degerCarpani == degerCarpani)&&(identical(other.satisSuresiTur, satisSuresiTur) || other.satisSuresiTur == satisSuresiTur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ad,sermaye,const DeepCollectionEquality().hash(_gelirler),const DeepCollectionEquality().hash(_giderler),yonetimYuku,prestij,const DeepCollectionEquality().hash(_baslangicStatlari),const DeepCollectionEquality().hash(_olayHavuzu),girisSarti,ceoMaasi,ceoEtkinligi,degerCarpani,satisSuresiTur);

@override
String toString() {
  return 'IsletmeTanimi(id: $id, ad: $ad, sermaye: $sermaye, gelirler: $gelirler, giderler: $giderler, yonetimYuku: $yonetimYuku, prestij: $prestij, baslangicStatlari: $baslangicStatlari, olayHavuzu: $olayHavuzu, girisSarti: $girisSarti, ceoMaasi: $ceoMaasi, ceoEtkinligi: $ceoEtkinligi, degerCarpani: $degerCarpani, satisSuresiTur: $satisSuresiTur)';
}


}

/// @nodoc
abstract mixin class _$IsletmeTanimiCopyWith<$Res> implements $IsletmeTanimiCopyWith<$Res> {
  factory _$IsletmeTanimiCopyWith(_IsletmeTanimi value, $Res Function(_IsletmeTanimi) _then) = __$IsletmeTanimiCopyWithImpl;
@override @useResult
$Res call({
 String id, String ad, int sermaye, List<Kalem> gelirler, List<Kalem> giderler, int yonetimYuku, double prestij, Map<String, int> baslangicStatlari, List<String> olayHavuzu, IsletmeGirisSarti girisSarti, int ceoMaasi, double ceoEtkinligi, double degerCarpani, int satisSuresiTur
});


@override $IsletmeGirisSartiCopyWith<$Res> get girisSarti;

}
/// @nodoc
class __$IsletmeTanimiCopyWithImpl<$Res>
    implements _$IsletmeTanimiCopyWith<$Res> {
  __$IsletmeTanimiCopyWithImpl(this._self, this._then);

  final _IsletmeTanimi _self;
  final $Res Function(_IsletmeTanimi) _then;

/// Create a copy of IsletmeTanimi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ad = null,Object? sermaye = null,Object? gelirler = null,Object? giderler = null,Object? yonetimYuku = null,Object? prestij = null,Object? baslangicStatlari = null,Object? olayHavuzu = null,Object? girisSarti = null,Object? ceoMaasi = null,Object? ceoEtkinligi = null,Object? degerCarpani = null,Object? satisSuresiTur = null,}) {
  return _then(_IsletmeTanimi(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ad: null == ad ? _self.ad : ad // ignore: cast_nullable_to_non_nullable
as String,sermaye: null == sermaye ? _self.sermaye : sermaye // ignore: cast_nullable_to_non_nullable
as int,gelirler: null == gelirler ? _self._gelirler : gelirler // ignore: cast_nullable_to_non_nullable
as List<Kalem>,giderler: null == giderler ? _self._giderler : giderler // ignore: cast_nullable_to_non_nullable
as List<Kalem>,yonetimYuku: null == yonetimYuku ? _self.yonetimYuku : yonetimYuku // ignore: cast_nullable_to_non_nullable
as int,prestij: null == prestij ? _self.prestij : prestij // ignore: cast_nullable_to_non_nullable
as double,baslangicStatlari: null == baslangicStatlari ? _self._baslangicStatlari : baslangicStatlari // ignore: cast_nullable_to_non_nullable
as Map<String, int>,olayHavuzu: null == olayHavuzu ? _self._olayHavuzu : olayHavuzu // ignore: cast_nullable_to_non_nullable
as List<String>,girisSarti: null == girisSarti ? _self.girisSarti : girisSarti // ignore: cast_nullable_to_non_nullable
as IsletmeGirisSarti,ceoMaasi: null == ceoMaasi ? _self.ceoMaasi : ceoMaasi // ignore: cast_nullable_to_non_nullable
as int,ceoEtkinligi: null == ceoEtkinligi ? _self.ceoEtkinligi : ceoEtkinligi // ignore: cast_nullable_to_non_nullable
as double,degerCarpani: null == degerCarpani ? _self.degerCarpani : degerCarpani // ignore: cast_nullable_to_non_nullable
as double,satisSuresiTur: null == satisSuresiTur ? _self.satisSuresiTur : satisSuresiTur // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of IsletmeTanimi
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IsletmeGirisSartiCopyWith<$Res> get girisSarti {
  
  return $IsletmeGirisSartiCopyWith<$Res>(_self.girisSarti, (value) {
    return _then(_self.copyWith(girisSarti: value));
  });
}
}


/// @nodoc
mixin _$Isletme {

/// Örnek kimliği — aynı türden iki kafe ayırt edilebilsin.
 String get id; String get tanimId;/// Kaçıncı turda kuruldu.
 int get kurulusTuru;/// Güncel özel statlar (0-100).
 Map<String, int> get statlar;/// Genel müdür atandı mı. İlgi yükünü düşürür, kârı da düşürür,
/// zimmet riski getirir.
 bool get ceoVar;/// Son turun net kârı (nominal TL). UI ve satış değeri bunu okur.
 int get sonNetKar;/// Son 12 turun net kâr toplamı — satış değerinin tabanı.
 int get yillikNetKar;/// Motorun her tur yazdığı güncel değerleme (nominal TL). Net değer
/// hesabı katalogsuz yapılabilsin diye örneğin üstünde tutuluyor;
/// [OyunDurumu] tanım dosyasını tanımaz.
 int get guncelDeger;/// Üst üste kaç turdur yeterli ilgi görmedi. Kriz ihtimali buna bakar.
 int get ihmalTuru;/// Satışa çıkarıldıysa kalan tur.
 int? get satisKalanTur;
/// Create a copy of Isletme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IsletmeCopyWith<Isletme> get copyWith => _$IsletmeCopyWithImpl<Isletme>(this as Isletme, _$identity);

  /// Serializes this Isletme to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Isletme&&(identical(other.id, id) || other.id == id)&&(identical(other.tanimId, tanimId) || other.tanimId == tanimId)&&(identical(other.kurulusTuru, kurulusTuru) || other.kurulusTuru == kurulusTuru)&&const DeepCollectionEquality().equals(other.statlar, statlar)&&(identical(other.ceoVar, ceoVar) || other.ceoVar == ceoVar)&&(identical(other.sonNetKar, sonNetKar) || other.sonNetKar == sonNetKar)&&(identical(other.yillikNetKar, yillikNetKar) || other.yillikNetKar == yillikNetKar)&&(identical(other.guncelDeger, guncelDeger) || other.guncelDeger == guncelDeger)&&(identical(other.ihmalTuru, ihmalTuru) || other.ihmalTuru == ihmalTuru)&&(identical(other.satisKalanTur, satisKalanTur) || other.satisKalanTur == satisKalanTur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tanimId,kurulusTuru,const DeepCollectionEquality().hash(statlar),ceoVar,sonNetKar,yillikNetKar,guncelDeger,ihmalTuru,satisKalanTur);

@override
String toString() {
  return 'Isletme(id: $id, tanimId: $tanimId, kurulusTuru: $kurulusTuru, statlar: $statlar, ceoVar: $ceoVar, sonNetKar: $sonNetKar, yillikNetKar: $yillikNetKar, guncelDeger: $guncelDeger, ihmalTuru: $ihmalTuru, satisKalanTur: $satisKalanTur)';
}


}

/// @nodoc
abstract mixin class $IsletmeCopyWith<$Res>  {
  factory $IsletmeCopyWith(Isletme value, $Res Function(Isletme) _then) = _$IsletmeCopyWithImpl;
@useResult
$Res call({
 String id, String tanimId, int kurulusTuru, Map<String, int> statlar, bool ceoVar, int sonNetKar, int yillikNetKar, int guncelDeger, int ihmalTuru, int? satisKalanTur
});




}
/// @nodoc
class _$IsletmeCopyWithImpl<$Res>
    implements $IsletmeCopyWith<$Res> {
  _$IsletmeCopyWithImpl(this._self, this._then);

  final Isletme _self;
  final $Res Function(Isletme) _then;

/// Create a copy of Isletme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tanimId = null,Object? kurulusTuru = null,Object? statlar = null,Object? ceoVar = null,Object? sonNetKar = null,Object? yillikNetKar = null,Object? guncelDeger = null,Object? ihmalTuru = null,Object? satisKalanTur = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tanimId: null == tanimId ? _self.tanimId : tanimId // ignore: cast_nullable_to_non_nullable
as String,kurulusTuru: null == kurulusTuru ? _self.kurulusTuru : kurulusTuru // ignore: cast_nullable_to_non_nullable
as int,statlar: null == statlar ? _self.statlar : statlar // ignore: cast_nullable_to_non_nullable
as Map<String, int>,ceoVar: null == ceoVar ? _self.ceoVar : ceoVar // ignore: cast_nullable_to_non_nullable
as bool,sonNetKar: null == sonNetKar ? _self.sonNetKar : sonNetKar // ignore: cast_nullable_to_non_nullable
as int,yillikNetKar: null == yillikNetKar ? _self.yillikNetKar : yillikNetKar // ignore: cast_nullable_to_non_nullable
as int,guncelDeger: null == guncelDeger ? _self.guncelDeger : guncelDeger // ignore: cast_nullable_to_non_nullable
as int,ihmalTuru: null == ihmalTuru ? _self.ihmalTuru : ihmalTuru // ignore: cast_nullable_to_non_nullable
as int,satisKalanTur: freezed == satisKalanTur ? _self.satisKalanTur : satisKalanTur // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Isletme].
extension IsletmePatterns on Isletme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Isletme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Isletme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Isletme value)  $default,){
final _that = this;
switch (_that) {
case _Isletme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Isletme value)?  $default,){
final _that = this;
switch (_that) {
case _Isletme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tanimId,  int kurulusTuru,  Map<String, int> statlar,  bool ceoVar,  int sonNetKar,  int yillikNetKar,  int guncelDeger,  int ihmalTuru,  int? satisKalanTur)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Isletme() when $default != null:
return $default(_that.id,_that.tanimId,_that.kurulusTuru,_that.statlar,_that.ceoVar,_that.sonNetKar,_that.yillikNetKar,_that.guncelDeger,_that.ihmalTuru,_that.satisKalanTur);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tanimId,  int kurulusTuru,  Map<String, int> statlar,  bool ceoVar,  int sonNetKar,  int yillikNetKar,  int guncelDeger,  int ihmalTuru,  int? satisKalanTur)  $default,) {final _that = this;
switch (_that) {
case _Isletme():
return $default(_that.id,_that.tanimId,_that.kurulusTuru,_that.statlar,_that.ceoVar,_that.sonNetKar,_that.yillikNetKar,_that.guncelDeger,_that.ihmalTuru,_that.satisKalanTur);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tanimId,  int kurulusTuru,  Map<String, int> statlar,  bool ceoVar,  int sonNetKar,  int yillikNetKar,  int guncelDeger,  int ihmalTuru,  int? satisKalanTur)?  $default,) {final _that = this;
switch (_that) {
case _Isletme() when $default != null:
return $default(_that.id,_that.tanimId,_that.kurulusTuru,_that.statlar,_that.ceoVar,_that.sonNetKar,_that.yillikNetKar,_that.guncelDeger,_that.ihmalTuru,_that.satisKalanTur);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Isletme extends Isletme {
  const _Isletme({required this.id, required this.tanimId, required this.kurulusTuru, final  Map<String, int> statlar = const <String, int>{}, this.ceoVar = false, this.sonNetKar = 0, this.yillikNetKar = 0, this.guncelDeger = 0, this.ihmalTuru = 0, this.satisKalanTur}): _statlar = statlar,super._();
  factory _Isletme.fromJson(Map<String, dynamic> json) => _$IsletmeFromJson(json);

/// Örnek kimliği — aynı türden iki kafe ayırt edilebilsin.
@override final  String id;
@override final  String tanimId;
/// Kaçıncı turda kuruldu.
@override final  int kurulusTuru;
/// Güncel özel statlar (0-100).
 final  Map<String, int> _statlar;
/// Güncel özel statlar (0-100).
@override@JsonKey() Map<String, int> get statlar {
  if (_statlar is EqualUnmodifiableMapView) return _statlar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statlar);
}

/// Genel müdür atandı mı. İlgi yükünü düşürür, kârı da düşürür,
/// zimmet riski getirir.
@override@JsonKey() final  bool ceoVar;
/// Son turun net kârı (nominal TL). UI ve satış değeri bunu okur.
@override@JsonKey() final  int sonNetKar;
/// Son 12 turun net kâr toplamı — satış değerinin tabanı.
@override@JsonKey() final  int yillikNetKar;
/// Motorun her tur yazdığı güncel değerleme (nominal TL). Net değer
/// hesabı katalogsuz yapılabilsin diye örneğin üstünde tutuluyor;
/// [OyunDurumu] tanım dosyasını tanımaz.
@override@JsonKey() final  int guncelDeger;
/// Üst üste kaç turdur yeterli ilgi görmedi. Kriz ihtimali buna bakar.
@override@JsonKey() final  int ihmalTuru;
/// Satışa çıkarıldıysa kalan tur.
@override final  int? satisKalanTur;

/// Create a copy of Isletme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IsletmeCopyWith<_Isletme> get copyWith => __$IsletmeCopyWithImpl<_Isletme>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IsletmeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Isletme&&(identical(other.id, id) || other.id == id)&&(identical(other.tanimId, tanimId) || other.tanimId == tanimId)&&(identical(other.kurulusTuru, kurulusTuru) || other.kurulusTuru == kurulusTuru)&&const DeepCollectionEquality().equals(other._statlar, _statlar)&&(identical(other.ceoVar, ceoVar) || other.ceoVar == ceoVar)&&(identical(other.sonNetKar, sonNetKar) || other.sonNetKar == sonNetKar)&&(identical(other.yillikNetKar, yillikNetKar) || other.yillikNetKar == yillikNetKar)&&(identical(other.guncelDeger, guncelDeger) || other.guncelDeger == guncelDeger)&&(identical(other.ihmalTuru, ihmalTuru) || other.ihmalTuru == ihmalTuru)&&(identical(other.satisKalanTur, satisKalanTur) || other.satisKalanTur == satisKalanTur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tanimId,kurulusTuru,const DeepCollectionEquality().hash(_statlar),ceoVar,sonNetKar,yillikNetKar,guncelDeger,ihmalTuru,satisKalanTur);

@override
String toString() {
  return 'Isletme(id: $id, tanimId: $tanimId, kurulusTuru: $kurulusTuru, statlar: $statlar, ceoVar: $ceoVar, sonNetKar: $sonNetKar, yillikNetKar: $yillikNetKar, guncelDeger: $guncelDeger, ihmalTuru: $ihmalTuru, satisKalanTur: $satisKalanTur)';
}


}

/// @nodoc
abstract mixin class _$IsletmeCopyWith<$Res> implements $IsletmeCopyWith<$Res> {
  factory _$IsletmeCopyWith(_Isletme value, $Res Function(_Isletme) _then) = __$IsletmeCopyWithImpl;
@override @useResult
$Res call({
 String id, String tanimId, int kurulusTuru, Map<String, int> statlar, bool ceoVar, int sonNetKar, int yillikNetKar, int guncelDeger, int ihmalTuru, int? satisKalanTur
});




}
/// @nodoc
class __$IsletmeCopyWithImpl<$Res>
    implements _$IsletmeCopyWith<$Res> {
  __$IsletmeCopyWithImpl(this._self, this._then);

  final _Isletme _self;
  final $Res Function(_Isletme) _then;

/// Create a copy of Isletme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tanimId = null,Object? kurulusTuru = null,Object? statlar = null,Object? ceoVar = null,Object? sonNetKar = null,Object? yillikNetKar = null,Object? guncelDeger = null,Object? ihmalTuru = null,Object? satisKalanTur = freezed,}) {
  return _then(_Isletme(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tanimId: null == tanimId ? _self.tanimId : tanimId // ignore: cast_nullable_to_non_nullable
as String,kurulusTuru: null == kurulusTuru ? _self.kurulusTuru : kurulusTuru // ignore: cast_nullable_to_non_nullable
as int,statlar: null == statlar ? _self._statlar : statlar // ignore: cast_nullable_to_non_nullable
as Map<String, int>,ceoVar: null == ceoVar ? _self.ceoVar : ceoVar // ignore: cast_nullable_to_non_nullable
as bool,sonNetKar: null == sonNetKar ? _self.sonNetKar : sonNetKar // ignore: cast_nullable_to_non_nullable
as int,yillikNetKar: null == yillikNetKar ? _self.yillikNetKar : yillikNetKar // ignore: cast_nullable_to_non_nullable
as int,guncelDeger: null == guncelDeger ? _self.guncelDeger : guncelDeger // ignore: cast_nullable_to_non_nullable
as int,ihmalTuru: null == ihmalTuru ? _self.ihmalTuru : ihmalTuru // ignore: cast_nullable_to_non_nullable
as int,satisKalanTur: freezed == satisKalanTur ? _self.satisKalanTur : satisKalanTur // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
