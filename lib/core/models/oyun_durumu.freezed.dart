// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'oyun_durumu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OyunDurumu {

/// Oyunun tohumu. Aynı tohum + aynı kararlar = aynı oyun.
/// Bug tekrar üretimi buna bağlı.
 int get anaTohum; Oyuncu get oyuncu; PiyasaDurumu get piyasa; Portfoy get portfoy;/// Maaşların bağlı olduğu fiyat endeksi.
///
/// Enflasyon endeksinden ayrı tutuluyor çünkü maaş yılda bir (ocakta)
/// zamlanır, giderler her ay artar. Aradaki makas oyunun en gerçekçi
/// baskısı: yıl ortasında alım gücü erir, ocakta düzelir.
 double get maasEndeksi;/// Kayıt biçimi sürümü. İleride şema değişirse göç buradan yönetilir.
 int get kayitSurumu;
/// Create a copy of OyunDurumu
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OyunDurumuCopyWith<OyunDurumu> get copyWith => _$OyunDurumuCopyWithImpl<OyunDurumu>(this as OyunDurumu, _$identity);

  /// Serializes this OyunDurumu to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OyunDurumu&&(identical(other.anaTohum, anaTohum) || other.anaTohum == anaTohum)&&(identical(other.oyuncu, oyuncu) || other.oyuncu == oyuncu)&&(identical(other.piyasa, piyasa) || other.piyasa == piyasa)&&(identical(other.portfoy, portfoy) || other.portfoy == portfoy)&&(identical(other.maasEndeksi, maasEndeksi) || other.maasEndeksi == maasEndeksi)&&(identical(other.kayitSurumu, kayitSurumu) || other.kayitSurumu == kayitSurumu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,anaTohum,oyuncu,piyasa,portfoy,maasEndeksi,kayitSurumu);

@override
String toString() {
  return 'OyunDurumu(anaTohum: $anaTohum, oyuncu: $oyuncu, piyasa: $piyasa, portfoy: $portfoy, maasEndeksi: $maasEndeksi, kayitSurumu: $kayitSurumu)';
}


}

/// @nodoc
abstract mixin class $OyunDurumuCopyWith<$Res>  {
  factory $OyunDurumuCopyWith(OyunDurumu value, $Res Function(OyunDurumu) _then) = _$OyunDurumuCopyWithImpl;
@useResult
$Res call({
 int anaTohum, Oyuncu oyuncu, PiyasaDurumu piyasa, Portfoy portfoy, double maasEndeksi, int kayitSurumu
});


$OyuncuCopyWith<$Res> get oyuncu;$PiyasaDurumuCopyWith<$Res> get piyasa;$PortfoyCopyWith<$Res> get portfoy;

}
/// @nodoc
class _$OyunDurumuCopyWithImpl<$Res>
    implements $OyunDurumuCopyWith<$Res> {
  _$OyunDurumuCopyWithImpl(this._self, this._then);

  final OyunDurumu _self;
  final $Res Function(OyunDurumu) _then;

/// Create a copy of OyunDurumu
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? anaTohum = null,Object? oyuncu = null,Object? piyasa = null,Object? portfoy = null,Object? maasEndeksi = null,Object? kayitSurumu = null,}) {
  return _then(_self.copyWith(
anaTohum: null == anaTohum ? _self.anaTohum : anaTohum // ignore: cast_nullable_to_non_nullable
as int,oyuncu: null == oyuncu ? _self.oyuncu : oyuncu // ignore: cast_nullable_to_non_nullable
as Oyuncu,piyasa: null == piyasa ? _self.piyasa : piyasa // ignore: cast_nullable_to_non_nullable
as PiyasaDurumu,portfoy: null == portfoy ? _self.portfoy : portfoy // ignore: cast_nullable_to_non_nullable
as Portfoy,maasEndeksi: null == maasEndeksi ? _self.maasEndeksi : maasEndeksi // ignore: cast_nullable_to_non_nullable
as double,kayitSurumu: null == kayitSurumu ? _self.kayitSurumu : kayitSurumu // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of OyunDurumu
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OyuncuCopyWith<$Res> get oyuncu {
  
  return $OyuncuCopyWith<$Res>(_self.oyuncu, (value) {
    return _then(_self.copyWith(oyuncu: value));
  });
}/// Create a copy of OyunDurumu
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PiyasaDurumuCopyWith<$Res> get piyasa {
  
  return $PiyasaDurumuCopyWith<$Res>(_self.piyasa, (value) {
    return _then(_self.copyWith(piyasa: value));
  });
}/// Create a copy of OyunDurumu
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortfoyCopyWith<$Res> get portfoy {
  
  return $PortfoyCopyWith<$Res>(_self.portfoy, (value) {
    return _then(_self.copyWith(portfoy: value));
  });
}
}


/// Adds pattern-matching-related methods to [OyunDurumu].
extension OyunDurumuPatterns on OyunDurumu {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OyunDurumu value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OyunDurumu() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OyunDurumu value)  $default,){
final _that = this;
switch (_that) {
case _OyunDurumu():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OyunDurumu value)?  $default,){
final _that = this;
switch (_that) {
case _OyunDurumu() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int anaTohum,  Oyuncu oyuncu,  PiyasaDurumu piyasa,  Portfoy portfoy,  double maasEndeksi,  int kayitSurumu)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OyunDurumu() when $default != null:
return $default(_that.anaTohum,_that.oyuncu,_that.piyasa,_that.portfoy,_that.maasEndeksi,_that.kayitSurumu);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int anaTohum,  Oyuncu oyuncu,  PiyasaDurumu piyasa,  Portfoy portfoy,  double maasEndeksi,  int kayitSurumu)  $default,) {final _that = this;
switch (_that) {
case _OyunDurumu():
return $default(_that.anaTohum,_that.oyuncu,_that.piyasa,_that.portfoy,_that.maasEndeksi,_that.kayitSurumu);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int anaTohum,  Oyuncu oyuncu,  PiyasaDurumu piyasa,  Portfoy portfoy,  double maasEndeksi,  int kayitSurumu)?  $default,) {final _that = this;
switch (_that) {
case _OyunDurumu() when $default != null:
return $default(_that.anaTohum,_that.oyuncu,_that.piyasa,_that.portfoy,_that.maasEndeksi,_that.kayitSurumu);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OyunDurumu extends OyunDurumu {
  const _OyunDurumu({required this.anaTohum, required this.oyuncu, required this.piyasa, this.portfoy = const Portfoy(), this.maasEndeksi = 1.0, this.kayitSurumu = 1}): super._();
  factory _OyunDurumu.fromJson(Map<String, dynamic> json) => _$OyunDurumuFromJson(json);

/// Oyunun tohumu. Aynı tohum + aynı kararlar = aynı oyun.
/// Bug tekrar üretimi buna bağlı.
@override final  int anaTohum;
@override final  Oyuncu oyuncu;
@override final  PiyasaDurumu piyasa;
@override@JsonKey() final  Portfoy portfoy;
/// Maaşların bağlı olduğu fiyat endeksi.
///
/// Enflasyon endeksinden ayrı tutuluyor çünkü maaş yılda bir (ocakta)
/// zamlanır, giderler her ay artar. Aradaki makas oyunun en gerçekçi
/// baskısı: yıl ortasında alım gücü erir, ocakta düzelir.
@override@JsonKey() final  double maasEndeksi;
/// Kayıt biçimi sürümü. İleride şema değişirse göç buradan yönetilir.
@override@JsonKey() final  int kayitSurumu;

/// Create a copy of OyunDurumu
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OyunDurumuCopyWith<_OyunDurumu> get copyWith => __$OyunDurumuCopyWithImpl<_OyunDurumu>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OyunDurumuToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OyunDurumu&&(identical(other.anaTohum, anaTohum) || other.anaTohum == anaTohum)&&(identical(other.oyuncu, oyuncu) || other.oyuncu == oyuncu)&&(identical(other.piyasa, piyasa) || other.piyasa == piyasa)&&(identical(other.portfoy, portfoy) || other.portfoy == portfoy)&&(identical(other.maasEndeksi, maasEndeksi) || other.maasEndeksi == maasEndeksi)&&(identical(other.kayitSurumu, kayitSurumu) || other.kayitSurumu == kayitSurumu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,anaTohum,oyuncu,piyasa,portfoy,maasEndeksi,kayitSurumu);

@override
String toString() {
  return 'OyunDurumu(anaTohum: $anaTohum, oyuncu: $oyuncu, piyasa: $piyasa, portfoy: $portfoy, maasEndeksi: $maasEndeksi, kayitSurumu: $kayitSurumu)';
}


}

/// @nodoc
abstract mixin class _$OyunDurumuCopyWith<$Res> implements $OyunDurumuCopyWith<$Res> {
  factory _$OyunDurumuCopyWith(_OyunDurumu value, $Res Function(_OyunDurumu) _then) = __$OyunDurumuCopyWithImpl;
@override @useResult
$Res call({
 int anaTohum, Oyuncu oyuncu, PiyasaDurumu piyasa, Portfoy portfoy, double maasEndeksi, int kayitSurumu
});


@override $OyuncuCopyWith<$Res> get oyuncu;@override $PiyasaDurumuCopyWith<$Res> get piyasa;@override $PortfoyCopyWith<$Res> get portfoy;

}
/// @nodoc
class __$OyunDurumuCopyWithImpl<$Res>
    implements _$OyunDurumuCopyWith<$Res> {
  __$OyunDurumuCopyWithImpl(this._self, this._then);

  final _OyunDurumu _self;
  final $Res Function(_OyunDurumu) _then;

/// Create a copy of OyunDurumu
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? anaTohum = null,Object? oyuncu = null,Object? piyasa = null,Object? portfoy = null,Object? maasEndeksi = null,Object? kayitSurumu = null,}) {
  return _then(_OyunDurumu(
anaTohum: null == anaTohum ? _self.anaTohum : anaTohum // ignore: cast_nullable_to_non_nullable
as int,oyuncu: null == oyuncu ? _self.oyuncu : oyuncu // ignore: cast_nullable_to_non_nullable
as Oyuncu,piyasa: null == piyasa ? _self.piyasa : piyasa // ignore: cast_nullable_to_non_nullable
as PiyasaDurumu,portfoy: null == portfoy ? _self.portfoy : portfoy // ignore: cast_nullable_to_non_nullable
as Portfoy,maasEndeksi: null == maasEndeksi ? _self.maasEndeksi : maasEndeksi // ignore: cast_nullable_to_non_nullable
as double,kayitSurumu: null == kayitSurumu ? _self.kayitSurumu : kayitSurumu // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of OyunDurumu
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OyuncuCopyWith<$Res> get oyuncu {
  
  return $OyuncuCopyWith<$Res>(_self.oyuncu, (value) {
    return _then(_self.copyWith(oyuncu: value));
  });
}/// Create a copy of OyunDurumu
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PiyasaDurumuCopyWith<$Res> get piyasa {
  
  return $PiyasaDurumuCopyWith<$Res>(_self.piyasa, (value) {
    return _then(_self.copyWith(piyasa: value));
  });
}/// Create a copy of OyunDurumu
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortfoyCopyWith<$Res> get portfoy {
  
  return $PortfoyCopyWith<$Res>(_self.portfoy, (value) {
    return _then(_self.copyWith(portfoy: value));
  });
}
}

// dart format on
