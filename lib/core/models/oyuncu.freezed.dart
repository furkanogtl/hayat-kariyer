// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'oyuncu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Oyuncu {

 String get ad;/// Oyuncunun yaşadığı şehir. Yaşam gideri çarpanı buradan gelir.
 Sehir get sehir;/// Oynanan tur sayısı. 1 tur = 1 ay. İlk tur 0'dır.
 int get tur;/// Oyuna başlanan yaş. Yaş buradan ve turdan TÜRETİLİR, ayrıca tutulmaz;
/// iki alan ayrı tutulsa er ya da geç birbirinden kayar.
 int get baslangicYasi;/// Tek mekanik etkisi askerliktir.
 Cinsiyet get cinsiyet;/// Mesleklere giriş ön koşulu.
 EgitimSeviyesi get egitim;/// Öğrenci / çalışan / işsiz / askerlik / emekli.
 KariyerDurumu get kariyer;/// Nakit (TL). Kuruş tutulmaz.
 int get nakit;/// Enerji/Sağlık. 0'a inerse hastalık ve tur kaybı riski.
 int get enerji;/// Mutluluk/Stres ekseni. Düşerse burnout, performans düşer.
 int get mutluluk;/// İtibar/Network. Fırsat kartlarının KALİTESİNİ belirler.
 int get itibar;/// Kredi notu. Borçlanma limiti ve faiz oranını belirler.
 int get krediNotu;/// Sektör -> yetkinlik (0-100). Yetkinlik meslek değil SEKTÖR bazında
/// birikir: sektör içi geçiş bilgiyi korur, sektör dışına geçiş sıfırlar.
 Map<Sektor, int> get yetkinlikler;/// Yatan SGK primi (ay). Emekli aylığı buna bağlıdır; kayıt dışı çalışan
/// oyuncu geç oyunda bunun bedelini öder.
 int get sgkPrimAyi;
/// Create a copy of Oyuncu
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OyuncuCopyWith<Oyuncu> get copyWith => _$OyuncuCopyWithImpl<Oyuncu>(this as Oyuncu, _$identity);

  /// Serializes this Oyuncu to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Oyuncu&&(identical(other.ad, ad) || other.ad == ad)&&(identical(other.sehir, sehir) || other.sehir == sehir)&&(identical(other.tur, tur) || other.tur == tur)&&(identical(other.baslangicYasi, baslangicYasi) || other.baslangicYasi == baslangicYasi)&&(identical(other.cinsiyet, cinsiyet) || other.cinsiyet == cinsiyet)&&(identical(other.egitim, egitim) || other.egitim == egitim)&&(identical(other.kariyer, kariyer) || other.kariyer == kariyer)&&(identical(other.nakit, nakit) || other.nakit == nakit)&&(identical(other.enerji, enerji) || other.enerji == enerji)&&(identical(other.mutluluk, mutluluk) || other.mutluluk == mutluluk)&&(identical(other.itibar, itibar) || other.itibar == itibar)&&(identical(other.krediNotu, krediNotu) || other.krediNotu == krediNotu)&&const DeepCollectionEquality().equals(other.yetkinlikler, yetkinlikler)&&(identical(other.sgkPrimAyi, sgkPrimAyi) || other.sgkPrimAyi == sgkPrimAyi));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ad,sehir,tur,baslangicYasi,cinsiyet,egitim,kariyer,nakit,enerji,mutluluk,itibar,krediNotu,const DeepCollectionEquality().hash(yetkinlikler),sgkPrimAyi);

@override
String toString() {
  return 'Oyuncu(ad: $ad, sehir: $sehir, tur: $tur, baslangicYasi: $baslangicYasi, cinsiyet: $cinsiyet, egitim: $egitim, kariyer: $kariyer, nakit: $nakit, enerji: $enerji, mutluluk: $mutluluk, itibar: $itibar, krediNotu: $krediNotu, yetkinlikler: $yetkinlikler, sgkPrimAyi: $sgkPrimAyi)';
}


}

/// @nodoc
abstract mixin class $OyuncuCopyWith<$Res>  {
  factory $OyuncuCopyWith(Oyuncu value, $Res Function(Oyuncu) _then) = _$OyuncuCopyWithImpl;
@useResult
$Res call({
 String ad, Sehir sehir, int tur, int baslangicYasi, Cinsiyet cinsiyet, EgitimSeviyesi egitim, KariyerDurumu kariyer, int nakit, int enerji, int mutluluk, int itibar, int krediNotu, Map<Sektor, int> yetkinlikler, int sgkPrimAyi
});


$KariyerDurumuCopyWith<$Res> get kariyer;

}
/// @nodoc
class _$OyuncuCopyWithImpl<$Res>
    implements $OyuncuCopyWith<$Res> {
  _$OyuncuCopyWithImpl(this._self, this._then);

  final Oyuncu _self;
  final $Res Function(Oyuncu) _then;

/// Create a copy of Oyuncu
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ad = null,Object? sehir = null,Object? tur = null,Object? baslangicYasi = null,Object? cinsiyet = null,Object? egitim = null,Object? kariyer = null,Object? nakit = null,Object? enerji = null,Object? mutluluk = null,Object? itibar = null,Object? krediNotu = null,Object? yetkinlikler = null,Object? sgkPrimAyi = null,}) {
  return _then(_self.copyWith(
ad: null == ad ? _self.ad : ad // ignore: cast_nullable_to_non_nullable
as String,sehir: null == sehir ? _self.sehir : sehir // ignore: cast_nullable_to_non_nullable
as Sehir,tur: null == tur ? _self.tur : tur // ignore: cast_nullable_to_non_nullable
as int,baslangicYasi: null == baslangicYasi ? _self.baslangicYasi : baslangicYasi // ignore: cast_nullable_to_non_nullable
as int,cinsiyet: null == cinsiyet ? _self.cinsiyet : cinsiyet // ignore: cast_nullable_to_non_nullable
as Cinsiyet,egitim: null == egitim ? _self.egitim : egitim // ignore: cast_nullable_to_non_nullable
as EgitimSeviyesi,kariyer: null == kariyer ? _self.kariyer : kariyer // ignore: cast_nullable_to_non_nullable
as KariyerDurumu,nakit: null == nakit ? _self.nakit : nakit // ignore: cast_nullable_to_non_nullable
as int,enerji: null == enerji ? _self.enerji : enerji // ignore: cast_nullable_to_non_nullable
as int,mutluluk: null == mutluluk ? _self.mutluluk : mutluluk // ignore: cast_nullable_to_non_nullable
as int,itibar: null == itibar ? _self.itibar : itibar // ignore: cast_nullable_to_non_nullable
as int,krediNotu: null == krediNotu ? _self.krediNotu : krediNotu // ignore: cast_nullable_to_non_nullable
as int,yetkinlikler: null == yetkinlikler ? _self.yetkinlikler : yetkinlikler // ignore: cast_nullable_to_non_nullable
as Map<Sektor, int>,sgkPrimAyi: null == sgkPrimAyi ? _self.sgkPrimAyi : sgkPrimAyi // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Oyuncu
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KariyerDurumuCopyWith<$Res> get kariyer {
  
  return $KariyerDurumuCopyWith<$Res>(_self.kariyer, (value) {
    return _then(_self.copyWith(kariyer: value));
  });
}
}


/// Adds pattern-matching-related methods to [Oyuncu].
extension OyuncuPatterns on Oyuncu {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Oyuncu value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Oyuncu() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Oyuncu value)  $default,){
final _that = this;
switch (_that) {
case _Oyuncu():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Oyuncu value)?  $default,){
final _that = this;
switch (_that) {
case _Oyuncu() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ad,  Sehir sehir,  int tur,  int baslangicYasi,  Cinsiyet cinsiyet,  EgitimSeviyesi egitim,  KariyerDurumu kariyer,  int nakit,  int enerji,  int mutluluk,  int itibar,  int krediNotu,  Map<Sektor, int> yetkinlikler,  int sgkPrimAyi)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Oyuncu() when $default != null:
return $default(_that.ad,_that.sehir,_that.tur,_that.baslangicYasi,_that.cinsiyet,_that.egitim,_that.kariyer,_that.nakit,_that.enerji,_that.mutluluk,_that.itibar,_that.krediNotu,_that.yetkinlikler,_that.sgkPrimAyi);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ad,  Sehir sehir,  int tur,  int baslangicYasi,  Cinsiyet cinsiyet,  EgitimSeviyesi egitim,  KariyerDurumu kariyer,  int nakit,  int enerji,  int mutluluk,  int itibar,  int krediNotu,  Map<Sektor, int> yetkinlikler,  int sgkPrimAyi)  $default,) {final _that = this;
switch (_that) {
case _Oyuncu():
return $default(_that.ad,_that.sehir,_that.tur,_that.baslangicYasi,_that.cinsiyet,_that.egitim,_that.kariyer,_that.nakit,_that.enerji,_that.mutluluk,_that.itibar,_that.krediNotu,_that.yetkinlikler,_that.sgkPrimAyi);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ad,  Sehir sehir,  int tur,  int baslangicYasi,  Cinsiyet cinsiyet,  EgitimSeviyesi egitim,  KariyerDurumu kariyer,  int nakit,  int enerji,  int mutluluk,  int itibar,  int krediNotu,  Map<Sektor, int> yetkinlikler,  int sgkPrimAyi)?  $default,) {final _that = this;
switch (_that) {
case _Oyuncu() when $default != null:
return $default(_that.ad,_that.sehir,_that.tur,_that.baslangicYasi,_that.cinsiyet,_that.egitim,_that.kariyer,_that.nakit,_that.enerji,_that.mutluluk,_that.itibar,_that.krediNotu,_that.yetkinlikler,_that.sgkPrimAyi);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Oyuncu extends Oyuncu {
  const _Oyuncu({required this.ad, required this.sehir, this.tur = 0, this.baslangicYasi = Oyuncu.baslangicYasiVarsayilan, this.cinsiyet = Cinsiyet.erkek, this.egitim = EgitimSeviyesi.lise, this.kariyer = const KariyerDurumu.issiz(), this.nakit = 0, this.enerji = Oyuncu.enerjiTavan, this.mutluluk = 70, this.itibar = 5, this.krediNotu = Oyuncu.krediNotuBaslangic, final  Map<Sektor, int> yetkinlikler = const <Sektor, int>{}, this.sgkPrimAyi = 0}): _yetkinlikler = yetkinlikler,super._();
  factory _Oyuncu.fromJson(Map<String, dynamic> json) => _$OyuncuFromJson(json);

@override final  String ad;
/// Oyuncunun yaşadığı şehir. Yaşam gideri çarpanı buradan gelir.
@override final  Sehir sehir;
/// Oynanan tur sayısı. 1 tur = 1 ay. İlk tur 0'dır.
@override@JsonKey() final  int tur;
/// Oyuna başlanan yaş. Yaş buradan ve turdan TÜRETİLİR, ayrıca tutulmaz;
/// iki alan ayrı tutulsa er ya da geç birbirinden kayar.
@override@JsonKey() final  int baslangicYasi;
/// Tek mekanik etkisi askerliktir.
@override@JsonKey() final  Cinsiyet cinsiyet;
/// Mesleklere giriş ön koşulu.
@override@JsonKey() final  EgitimSeviyesi egitim;
/// Öğrenci / çalışan / işsiz / askerlik / emekli.
@override@JsonKey() final  KariyerDurumu kariyer;
/// Nakit (TL). Kuruş tutulmaz.
@override@JsonKey() final  int nakit;
/// Enerji/Sağlık. 0'a inerse hastalık ve tur kaybı riski.
@override@JsonKey() final  int enerji;
/// Mutluluk/Stres ekseni. Düşerse burnout, performans düşer.
@override@JsonKey() final  int mutluluk;
/// İtibar/Network. Fırsat kartlarının KALİTESİNİ belirler.
@override@JsonKey() final  int itibar;
/// Kredi notu. Borçlanma limiti ve faiz oranını belirler.
@override@JsonKey() final  int krediNotu;
/// Sektör -> yetkinlik (0-100). Yetkinlik meslek değil SEKTÖR bazında
/// birikir: sektör içi geçiş bilgiyi korur, sektör dışına geçiş sıfırlar.
 final  Map<Sektor, int> _yetkinlikler;
/// Sektör -> yetkinlik (0-100). Yetkinlik meslek değil SEKTÖR bazında
/// birikir: sektör içi geçiş bilgiyi korur, sektör dışına geçiş sıfırlar.
@override@JsonKey() Map<Sektor, int> get yetkinlikler {
  if (_yetkinlikler is EqualUnmodifiableMapView) return _yetkinlikler;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_yetkinlikler);
}

/// Yatan SGK primi (ay). Emekli aylığı buna bağlıdır; kayıt dışı çalışan
/// oyuncu geç oyunda bunun bedelini öder.
@override@JsonKey() final  int sgkPrimAyi;

/// Create a copy of Oyuncu
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OyuncuCopyWith<_Oyuncu> get copyWith => __$OyuncuCopyWithImpl<_Oyuncu>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OyuncuToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Oyuncu&&(identical(other.ad, ad) || other.ad == ad)&&(identical(other.sehir, sehir) || other.sehir == sehir)&&(identical(other.tur, tur) || other.tur == tur)&&(identical(other.baslangicYasi, baslangicYasi) || other.baslangicYasi == baslangicYasi)&&(identical(other.cinsiyet, cinsiyet) || other.cinsiyet == cinsiyet)&&(identical(other.egitim, egitim) || other.egitim == egitim)&&(identical(other.kariyer, kariyer) || other.kariyer == kariyer)&&(identical(other.nakit, nakit) || other.nakit == nakit)&&(identical(other.enerji, enerji) || other.enerji == enerji)&&(identical(other.mutluluk, mutluluk) || other.mutluluk == mutluluk)&&(identical(other.itibar, itibar) || other.itibar == itibar)&&(identical(other.krediNotu, krediNotu) || other.krediNotu == krediNotu)&&const DeepCollectionEquality().equals(other._yetkinlikler, _yetkinlikler)&&(identical(other.sgkPrimAyi, sgkPrimAyi) || other.sgkPrimAyi == sgkPrimAyi));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ad,sehir,tur,baslangicYasi,cinsiyet,egitim,kariyer,nakit,enerji,mutluluk,itibar,krediNotu,const DeepCollectionEquality().hash(_yetkinlikler),sgkPrimAyi);

@override
String toString() {
  return 'Oyuncu(ad: $ad, sehir: $sehir, tur: $tur, baslangicYasi: $baslangicYasi, cinsiyet: $cinsiyet, egitim: $egitim, kariyer: $kariyer, nakit: $nakit, enerji: $enerji, mutluluk: $mutluluk, itibar: $itibar, krediNotu: $krediNotu, yetkinlikler: $yetkinlikler, sgkPrimAyi: $sgkPrimAyi)';
}


}

/// @nodoc
abstract mixin class _$OyuncuCopyWith<$Res> implements $OyuncuCopyWith<$Res> {
  factory _$OyuncuCopyWith(_Oyuncu value, $Res Function(_Oyuncu) _then) = __$OyuncuCopyWithImpl;
@override @useResult
$Res call({
 String ad, Sehir sehir, int tur, int baslangicYasi, Cinsiyet cinsiyet, EgitimSeviyesi egitim, KariyerDurumu kariyer, int nakit, int enerji, int mutluluk, int itibar, int krediNotu, Map<Sektor, int> yetkinlikler, int sgkPrimAyi
});


@override $KariyerDurumuCopyWith<$Res> get kariyer;

}
/// @nodoc
class __$OyuncuCopyWithImpl<$Res>
    implements _$OyuncuCopyWith<$Res> {
  __$OyuncuCopyWithImpl(this._self, this._then);

  final _Oyuncu _self;
  final $Res Function(_Oyuncu) _then;

/// Create a copy of Oyuncu
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ad = null,Object? sehir = null,Object? tur = null,Object? baslangicYasi = null,Object? cinsiyet = null,Object? egitim = null,Object? kariyer = null,Object? nakit = null,Object? enerji = null,Object? mutluluk = null,Object? itibar = null,Object? krediNotu = null,Object? yetkinlikler = null,Object? sgkPrimAyi = null,}) {
  return _then(_Oyuncu(
ad: null == ad ? _self.ad : ad // ignore: cast_nullable_to_non_nullable
as String,sehir: null == sehir ? _self.sehir : sehir // ignore: cast_nullable_to_non_nullable
as Sehir,tur: null == tur ? _self.tur : tur // ignore: cast_nullable_to_non_nullable
as int,baslangicYasi: null == baslangicYasi ? _self.baslangicYasi : baslangicYasi // ignore: cast_nullable_to_non_nullable
as int,cinsiyet: null == cinsiyet ? _self.cinsiyet : cinsiyet // ignore: cast_nullable_to_non_nullable
as Cinsiyet,egitim: null == egitim ? _self.egitim : egitim // ignore: cast_nullable_to_non_nullable
as EgitimSeviyesi,kariyer: null == kariyer ? _self.kariyer : kariyer // ignore: cast_nullable_to_non_nullable
as KariyerDurumu,nakit: null == nakit ? _self.nakit : nakit // ignore: cast_nullable_to_non_nullable
as int,enerji: null == enerji ? _self.enerji : enerji // ignore: cast_nullable_to_non_nullable
as int,mutluluk: null == mutluluk ? _self.mutluluk : mutluluk // ignore: cast_nullable_to_non_nullable
as int,itibar: null == itibar ? _self.itibar : itibar // ignore: cast_nullable_to_non_nullable
as int,krediNotu: null == krediNotu ? _self.krediNotu : krediNotu // ignore: cast_nullable_to_non_nullable
as int,yetkinlikler: null == yetkinlikler ? _self._yetkinlikler : yetkinlikler // ignore: cast_nullable_to_non_nullable
as Map<Sektor, int>,sgkPrimAyi: null == sgkPrimAyi ? _self.sgkPrimAyi : sgkPrimAyi // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Oyuncu
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KariyerDurumuCopyWith<$Res> get kariyer {
  
  return $KariyerDurumuCopyWith<$Res>(_self.kariyer, (value) {
    return _then(_self.copyWith(kariyer: value));
  });
}
}

// dart format on
