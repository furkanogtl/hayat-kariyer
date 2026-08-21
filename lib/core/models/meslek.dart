import 'package:freezed_annotation/freezed_annotation.dart';

import 'egitim_seviyesi.dart';
import 'oyuncu.dart';
import 'sektor.dart';

part 'meslek.freezed.dart';
part 'meslek.g.dart';

/// Bir mesleğe girebilmek için gereken ön koşullar.
@freezed
abstract class GirisSarti with _$GirisSarti {
  const GirisSarti._();

  const factory GirisSarti({
    @Default(EgitimSeviyesi.lise) EgitimSeviyesi egitim,

    /// Mesleğin sektöründe gereken asgari yetkinlik (0-100).
    @Default(0) int yetkinlik,

    /// `[enAz, enCok]` — JSON'da iki elemanlı dizi olarak tutulur.
    @JsonKey(name: 'yas') @Default(<int>[18, 99]) List<int> yasAraligi,
  }) = _GirisSarti;

  factory GirisSarti.fromJson(Map<String, dynamic> json) =>
      _$GirisSartiFromJson(json);

  int get yasEnAz => yasAraligi.isNotEmpty ? yasAraligi.first : 0;
  int get yasEnCok => yasAraligi.length > 1 ? yasAraligi[1] : 999;
}

/// Kariyer merdiveninin bir basamağı.
///
/// Terfi ÇİFT KAPILIDIR: hem [yetkinlikGerek] hem [sureTur] karşılanmalıdır.
/// Tek kapı olsaydı oyuncu ya sadece bekleyerek ya da tek turda yetkinlik
/// basarak tepeye çıkardı.
@freezed
abstract class Kademe with _$Kademe {
  const Kademe._();

  const factory Kademe({
    required String ad,

    /// Bugünkü TL cinsinden TABAN maaş. Motor bunu enflasyon endeksiyle
    /// çarpar; sabit tutulursa 20 tur sonra anlamsızlaşır.
    required int maas,

    /// Bu kademeye geçmek için gereken sektör yetkinliği (0-100).
    @Default(0) int yetkinlikGerek,

    /// Bu kademede geçirilmesi gereken asgari tur. Son kademede null.
    int? sureTur,
  }) = _Kademe;

  factory Kademe.fromJson(Map<String, dynamic> json) => _$KademeFromJson(json);

  /// Merdivenin sonu mu (üstüne terfi yok).
  bool get sonKademe => sureTur == null;
}

/// Bir meslek tanımı. Kod değil VERİDİR: `assets/careers/*.json`.
@freezed
abstract class Meslek with _$Meslek {
  const Meslek._();

  const factory Meslek({
    required String id,
    required String ad,
    required Sektor sektor,
    @Default(GirisSarti()) GirisSarti girisSarti,
    required List<Kademe> kademeler,

    /// Turda kazanılan yetkinlik çarpanı.
    @Default(1.0) double yetkinlikArtisHizi,

    /// Turda kazanılan itibar/network çarpanı.
    @Default(0.5) double networkArtisi,

    /// Her turda yakılan enerji.
    @Default(3) int enerjiMaliyeti,

    /// Maaşın tur bazında oynaklığı (0 = memur, 0.6 = emlakçı).
    @Default(0.0) double gelirVaryansi,

    /// Gelirin dövize endeksli oranı (0-1). Kur şokunda koruma sağlar.
    @Default(0.0) double dovizOrani,

    /// Bu meslekle açılabilen işletme kimlikleri.
    @Default(<String>[]) List<String> acilanIsletmeler,

    /// Bu mesleğe özel olay kartı kimlikleri.
    @Default(<String>[]) List<String> olayHavuzu,
  }) = _Meslek;

  factory Meslek.fromJson(Map<String, dynamic> json) => _$MeslekFromJson(json);

  Kademe get ilkKademe => kademeler.first;

  Kademe get sonKademe => kademeler.last;

  /// Kademe indeksini sınırlar içinde tutar; bozuk kayda karşı savunma.
  Kademe kademe(int indeks) =>
      kademeler[indeks.clamp(0, kademeler.length - 1)];

  /// Kariyerin tavan taban maaşı (enflasyon uygulanmamış).
  int get tavanMaas => sonKademe.maas;

  /// Oyuncu bu mesleğe girebilir mi? Yetkinlik mesleğin SEKTÖRÜNDEN okunur.
  bool girebilirMi(Oyuncu oyuncu) =>
      oyuncu.egitim.yeterliMi(girisSarti.egitim) &&
      oyuncu.yetkinlik(sektor) >= girisSarti.yetkinlik &&
      oyuncu.yas >= girisSarti.yasEnAz &&
      oyuncu.yas <= girisSarti.yasEnCok;

  /// Veri dosyası doğrulaması. Boş liste = geçerli.
  ///
  /// Meslekler elle yazılan JSON'dan geldiği için şema hataları çalışma
  /// zamanında değil, testte yakalanmalıdır.
  List<String> dogrula() {
    final hatalar = <String>[];

    if (id.isEmpty) hatalar.add('id boş');
    if (ad.isEmpty) hatalar.add('$id: ad boş');
    if (kademeler.isEmpty) {
      hatalar.add('$id: kademe listesi boş');
      return hatalar;
    }

    for (var i = 0; i < kademeler.length; i++) {
      final k = kademeler[i];
      final son = i == kademeler.length - 1;
      if (k.ad.isEmpty) hatalar.add('$id: kademe $i adsız');
      if (k.maas < 0) hatalar.add('$id/${k.ad}: maaş negatif');
      if (k.yetkinlikGerek < Oyuncu.yetkinlikTaban ||
          k.yetkinlikGerek > Oyuncu.yetkinlikTavan) {
        hatalar.add(
          '$id/${k.ad}: yetkinlikGerek ${k.yetkinlikGerek} '
          '(${Oyuncu.yetkinlikTaban}-${Oyuncu.yetkinlikTavan} olmalı)',
        );
      }
      if (son && k.sureTur != null) {
        hatalar.add('$id/${k.ad}: son kademede sureTur null olmalı');
      }
      if (!son && (k.sureTur == null || k.sureTur! <= 0)) {
        hatalar.add('$id/${k.ad}: sureTur pozitif olmalı');
      }
      if (i > 0) {
        final onceki = kademeler[i - 1];
        if (k.maas < onceki.maas) {
          hatalar.add('$id/${k.ad}: maaş bir önceki kademeden düşük');
        }
        if (k.yetkinlikGerek < onceki.yetkinlikGerek) {
          hatalar.add('$id/${k.ad}: yetkinlikGerek bir önceki kademeden düşük');
        }
      }
    }

    if (girisSarti.yetkinlik < Oyuncu.yetkinlikTaban ||
        girisSarti.yetkinlik > Oyuncu.yetkinlikTavan) {
      hatalar.add('$id: girisSarti.yetkinlik aralık dışı');
    }
    if (girisSarti.yasAraligi.length != 2) {
      hatalar.add('$id: girisSarti.yas iki elemanlı olmalı');
    } else if (girisSarti.yasEnAz > girisSarti.yasEnCok) {
      hatalar.add('$id: girisSarti.yas aralığı ters');
    }
    if (kademeler.first.yetkinlikGerek > girisSarti.yetkinlik &&
        kademeler.first.yetkinlikGerek > 0) {
      hatalar.add(
        '$id: ilk kademe giriş şartından fazla yetkinlik istiyor '
        '(mesleğe girip ilk kademeye çıkamama durumu)',
      );
    }
    if (yetkinlikArtisHizi <= 0) hatalar.add('$id: yetkinlikArtisHizi pozitif olmalı');
    if (networkArtisi < 0) hatalar.add('$id: networkArtisi negatif');
    if (enerjiMaliyeti < 0) hatalar.add('$id: enerjiMaliyeti negatif');
    if (gelirVaryansi < 0 || gelirVaryansi > 1) {
      hatalar.add('$id: gelirVaryansi 0-1 arasında olmalı');
    }
    if (dovizOrani < 0 || dovizOrani > 1) {
      hatalar.add('$id: dovizOrani 0-1 arasında olmalı');
    }

    return hatalar;
  }
}
