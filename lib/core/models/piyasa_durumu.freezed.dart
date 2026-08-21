// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'piyasa_durumu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PiyasaDurumu {

 Rejim get rejim;/// Mevcut rejimin kaç turdur sürdüğü. Asgari süre kontrolü buna bakar.
 int get rejimSuresi;/// Oyun başından beri birikmiş fiyat seviyesi. Başlangıç 1.0.
/// Taban TL cinsinden yazılmış her tutar (maaş, kira, gider) bununla
/// çarpılarak o turun nominal değerine çevrilir.
 double get enflasyonEndeksi;/// Son turda gerçekleşen aylık enflasyon (0.03 = %3).
 double get sonAylikEnflasyon;/// Kaç kez paradan sıfır atıldığı. Motor HAM TL ile çalışmaya devam eder;
/// bu yalnızca gösterim ölçeğidir (bkz. [paraOlcegi]).
 int get paraReformuSayisi;/// Sıfır atma bu turda mı oldu. UI/olay kartı bunu duyurmak için okur.
 bool get paraReformuYapildi;/// Varlık kimliği -> birim fiyat (ham TL).
 Map<String, double> get fiyatlar;
/// Create a copy of PiyasaDurumu
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PiyasaDurumuCopyWith<PiyasaDurumu> get copyWith => _$PiyasaDurumuCopyWithImpl<PiyasaDurumu>(this as PiyasaDurumu, _$identity);

  /// Serializes this PiyasaDurumu to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PiyasaDurumu&&(identical(other.rejim, rejim) || other.rejim == rejim)&&(identical(other.rejimSuresi, rejimSuresi) || other.rejimSuresi == rejimSuresi)&&(identical(other.enflasyonEndeksi, enflasyonEndeksi) || other.enflasyonEndeksi == enflasyonEndeksi)&&(identical(other.sonAylikEnflasyon, sonAylikEnflasyon) || other.sonAylikEnflasyon == sonAylikEnflasyon)&&(identical(other.paraReformuSayisi, paraReformuSayisi) || other.paraReformuSayisi == paraReformuSayisi)&&(identical(other.paraReformuYapildi, paraReformuYapildi) || other.paraReformuYapildi == paraReformuYapildi)&&const DeepCollectionEquality().equals(other.fiyatlar, fiyatlar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rejim,rejimSuresi,enflasyonEndeksi,sonAylikEnflasyon,paraReformuSayisi,paraReformuYapildi,const DeepCollectionEquality().hash(fiyatlar));

@override
String toString() {
  return 'PiyasaDurumu(rejim: $rejim, rejimSuresi: $rejimSuresi, enflasyonEndeksi: $enflasyonEndeksi, sonAylikEnflasyon: $sonAylikEnflasyon, paraReformuSayisi: $paraReformuSayisi, paraReformuYapildi: $paraReformuYapildi, fiyatlar: $fiyatlar)';
}


}

/// @nodoc
abstract mixin class $PiyasaDurumuCopyWith<$Res>  {
  factory $PiyasaDurumuCopyWith(PiyasaDurumu value, $Res Function(PiyasaDurumu) _then) = _$PiyasaDurumuCopyWithImpl;
@useResult
$Res call({
 Rejim rejim, int rejimSuresi, double enflasyonEndeksi, double sonAylikEnflasyon, int paraReformuSayisi, bool paraReformuYapildi, Map<String, double> fiyatlar
});




}
/// @nodoc
class _$PiyasaDurumuCopyWithImpl<$Res>
    implements $PiyasaDurumuCopyWith<$Res> {
  _$PiyasaDurumuCopyWithImpl(this._self, this._then);

  final PiyasaDurumu _self;
  final $Res Function(PiyasaDurumu) _then;

/// Create a copy of PiyasaDurumu
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rejim = null,Object? rejimSuresi = null,Object? enflasyonEndeksi = null,Object? sonAylikEnflasyon = null,Object? paraReformuSayisi = null,Object? paraReformuYapildi = null,Object? fiyatlar = null,}) {
  return _then(_self.copyWith(
rejim: null == rejim ? _self.rejim : rejim // ignore: cast_nullable_to_non_nullable
as Rejim,rejimSuresi: null == rejimSuresi ? _self.rejimSuresi : rejimSuresi // ignore: cast_nullable_to_non_nullable
as int,enflasyonEndeksi: null == enflasyonEndeksi ? _self.enflasyonEndeksi : enflasyonEndeksi // ignore: cast_nullable_to_non_nullable
as double,sonAylikEnflasyon: null == sonAylikEnflasyon ? _self.sonAylikEnflasyon : sonAylikEnflasyon // ignore: cast_nullable_to_non_nullable
as double,paraReformuSayisi: null == paraReformuSayisi ? _self.paraReformuSayisi : paraReformuSayisi // ignore: cast_nullable_to_non_nullable
as int,paraReformuYapildi: null == paraReformuYapildi ? _self.paraReformuYapildi : paraReformuYapildi // ignore: cast_nullable_to_non_nullable
as bool,fiyatlar: null == fiyatlar ? _self.fiyatlar : fiyatlar // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [PiyasaDurumu].
extension PiyasaDurumuPatterns on PiyasaDurumu {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PiyasaDurumu value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PiyasaDurumu() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PiyasaDurumu value)  $default,){
final _that = this;
switch (_that) {
case _PiyasaDurumu():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PiyasaDurumu value)?  $default,){
final _that = this;
switch (_that) {
case _PiyasaDurumu() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Rejim rejim,  int rejimSuresi,  double enflasyonEndeksi,  double sonAylikEnflasyon,  int paraReformuSayisi,  bool paraReformuYapildi,  Map<String, double> fiyatlar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PiyasaDurumu() when $default != null:
return $default(_that.rejim,_that.rejimSuresi,_that.enflasyonEndeksi,_that.sonAylikEnflasyon,_that.paraReformuSayisi,_that.paraReformuYapildi,_that.fiyatlar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Rejim rejim,  int rejimSuresi,  double enflasyonEndeksi,  double sonAylikEnflasyon,  int paraReformuSayisi,  bool paraReformuYapildi,  Map<String, double> fiyatlar)  $default,) {final _that = this;
switch (_that) {
case _PiyasaDurumu():
return $default(_that.rejim,_that.rejimSuresi,_that.enflasyonEndeksi,_that.sonAylikEnflasyon,_that.paraReformuSayisi,_that.paraReformuYapildi,_that.fiyatlar);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Rejim rejim,  int rejimSuresi,  double enflasyonEndeksi,  double sonAylikEnflasyon,  int paraReformuSayisi,  bool paraReformuYapildi,  Map<String, double> fiyatlar)?  $default,) {final _that = this;
switch (_that) {
case _PiyasaDurumu() when $default != null:
return $default(_that.rejim,_that.rejimSuresi,_that.enflasyonEndeksi,_that.sonAylikEnflasyon,_that.paraReformuSayisi,_that.paraReformuYapildi,_that.fiyatlar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PiyasaDurumu extends PiyasaDurumu {
  const _PiyasaDurumu({this.rejim = Rejim.buyume, this.rejimSuresi = 0, this.enflasyonEndeksi = 1.0, this.sonAylikEnflasyon = 0.0, this.paraReformuSayisi = 0, this.paraReformuYapildi = false, final  Map<String, double> fiyatlar = const <String, double>{}}): _fiyatlar = fiyatlar,super._();
  factory _PiyasaDurumu.fromJson(Map<String, dynamic> json) => _$PiyasaDurumuFromJson(json);

@override@JsonKey() final  Rejim rejim;
/// Mevcut rejimin kaç turdur sürdüğü. Asgari süre kontrolü buna bakar.
@override@JsonKey() final  int rejimSuresi;
/// Oyun başından beri birikmiş fiyat seviyesi. Başlangıç 1.0.
/// Taban TL cinsinden yazılmış her tutar (maaş, kira, gider) bununla
/// çarpılarak o turun nominal değerine çevrilir.
@override@JsonKey() final  double enflasyonEndeksi;
/// Son turda gerçekleşen aylık enflasyon (0.03 = %3).
@override@JsonKey() final  double sonAylikEnflasyon;
/// Kaç kez paradan sıfır atıldığı. Motor HAM TL ile çalışmaya devam eder;
/// bu yalnızca gösterim ölçeğidir (bkz. [paraOlcegi]).
@override@JsonKey() final  int paraReformuSayisi;
/// Sıfır atma bu turda mı oldu. UI/olay kartı bunu duyurmak için okur.
@override@JsonKey() final  bool paraReformuYapildi;
/// Varlık kimliği -> birim fiyat (ham TL).
 final  Map<String, double> _fiyatlar;
/// Varlık kimliği -> birim fiyat (ham TL).
@override@JsonKey() Map<String, double> get fiyatlar {
  if (_fiyatlar is EqualUnmodifiableMapView) return _fiyatlar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fiyatlar);
}


/// Create a copy of PiyasaDurumu
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PiyasaDurumuCopyWith<_PiyasaDurumu> get copyWith => __$PiyasaDurumuCopyWithImpl<_PiyasaDurumu>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PiyasaDurumuToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PiyasaDurumu&&(identical(other.rejim, rejim) || other.rejim == rejim)&&(identical(other.rejimSuresi, rejimSuresi) || other.rejimSuresi == rejimSuresi)&&(identical(other.enflasyonEndeksi, enflasyonEndeksi) || other.enflasyonEndeksi == enflasyonEndeksi)&&(identical(other.sonAylikEnflasyon, sonAylikEnflasyon) || other.sonAylikEnflasyon == sonAylikEnflasyon)&&(identical(other.paraReformuSayisi, paraReformuSayisi) || other.paraReformuSayisi == paraReformuSayisi)&&(identical(other.paraReformuYapildi, paraReformuYapildi) || other.paraReformuYapildi == paraReformuYapildi)&&const DeepCollectionEquality().equals(other._fiyatlar, _fiyatlar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rejim,rejimSuresi,enflasyonEndeksi,sonAylikEnflasyon,paraReformuSayisi,paraReformuYapildi,const DeepCollectionEquality().hash(_fiyatlar));

@override
String toString() {
  return 'PiyasaDurumu(rejim: $rejim, rejimSuresi: $rejimSuresi, enflasyonEndeksi: $enflasyonEndeksi, sonAylikEnflasyon: $sonAylikEnflasyon, paraReformuSayisi: $paraReformuSayisi, paraReformuYapildi: $paraReformuYapildi, fiyatlar: $fiyatlar)';
}


}

/// @nodoc
abstract mixin class _$PiyasaDurumuCopyWith<$Res> implements $PiyasaDurumuCopyWith<$Res> {
  factory _$PiyasaDurumuCopyWith(_PiyasaDurumu value, $Res Function(_PiyasaDurumu) _then) = __$PiyasaDurumuCopyWithImpl;
@override @useResult
$Res call({
 Rejim rejim, int rejimSuresi, double enflasyonEndeksi, double sonAylikEnflasyon, int paraReformuSayisi, bool paraReformuYapildi, Map<String, double> fiyatlar
});




}
/// @nodoc
class __$PiyasaDurumuCopyWithImpl<$Res>
    implements _$PiyasaDurumuCopyWith<$Res> {
  __$PiyasaDurumuCopyWithImpl(this._self, this._then);

  final _PiyasaDurumu _self;
  final $Res Function(_PiyasaDurumu) _then;

/// Create a copy of PiyasaDurumu
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rejim = null,Object? rejimSuresi = null,Object? enflasyonEndeksi = null,Object? sonAylikEnflasyon = null,Object? paraReformuSayisi = null,Object? paraReformuYapildi = null,Object? fiyatlar = null,}) {
  return _then(_PiyasaDurumu(
rejim: null == rejim ? _self.rejim : rejim // ignore: cast_nullable_to_non_nullable
as Rejim,rejimSuresi: null == rejimSuresi ? _self.rejimSuresi : rejimSuresi // ignore: cast_nullable_to_non_nullable
as int,enflasyonEndeksi: null == enflasyonEndeksi ? _self.enflasyonEndeksi : enflasyonEndeksi // ignore: cast_nullable_to_non_nullable
as double,sonAylikEnflasyon: null == sonAylikEnflasyon ? _self.sonAylikEnflasyon : sonAylikEnflasyon // ignore: cast_nullable_to_non_nullable
as double,paraReformuSayisi: null == paraReformuSayisi ? _self.paraReformuSayisi : paraReformuSayisi // ignore: cast_nullable_to_non_nullable
as int,paraReformuYapildi: null == paraReformuYapildi ? _self.paraReformuYapildi : paraReformuYapildi // ignore: cast_nullable_to_non_nullable
as bool,fiyatlar: null == fiyatlar ? _self._fiyatlar : fiyatlar // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}


}

// dart format on
