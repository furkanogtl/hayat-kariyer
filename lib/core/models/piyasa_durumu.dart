import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../engine/rejim.dart';

part 'piyasa_durumu.freezed.dart';
part 'piyasa_durumu.g.dart';

/// Piyasanın o turdaki durumu. Kayda yazılır.
@freezed
abstract class PiyasaDurumu with _$PiyasaDurumu {
  const PiyasaDurumu._();

  const factory PiyasaDurumu({
    @Default(Rejim.buyume) Rejim rejim,

    /// Mevcut rejimin kaç turdur sürdüğü. Asgari süre kontrolü buna bakar.
    @Default(0) int rejimSuresi,

    /// Oyun başından beri birikmiş fiyat seviyesi. Başlangıç 1.0.
    /// Taban TL cinsinden yazılmış her tutar (maaş, kira, gider) bununla
    /// çarpılarak o turun nominal değerine çevrilir.
    @Default(1.0) double enflasyonEndeksi,

    /// Son turda gerçekleşen aylık enflasyon (0.03 = %3).
    @Default(0.0) double sonAylikEnflasyon,

    /// Kaç kez paradan sıfır atıldığı. Motor HAM TL ile çalışmaya devam eder;
    /// bu yalnızca gösterim ölçeğidir (bkz. [paraOlcegi]).
    @Default(0) int paraReformuSayisi,

    /// Sıfır atma bu turda mı oldu. UI/olay kartı bunu duyurmak için okur.
    @Default(false) bool paraReformuYapildi,

    /// Varlık kimliği -> birim fiyat (ham TL).
    @Default(<String, double>{}) Map<String, double> fiyatlar,

    /// Varlık kimliği -> son [fiyatGecmisiPenceresi] turun REEL fiyatı.
    ///
    /// Grafik için var, hesap için değil. Reel tutuluyor çünkü 40 yıllık
    /// nominal seri hokey sopasına dönüyor ve oyuncunun sorduğu soru
    /// "enflasyonu yendi mi" — reel seride bu doğrudan okunuyor.
    ///
    /// Pencere SINIRLI: sınırsız olsa 480 turluk oyunda kayıt dosyası 12
    /// varlık × 480 sayıyla gereksiz şişerdi. Kayda yazılıyor çünkü UI'da
    /// tutulsaydı kayıttan dönen oyuncunun grafiği boş gelirdi.
    @Default(<String, List<double>>{}) Map<String, List<double>> gecmis,
  }) = _PiyasaDurumu;

  factory PiyasaDurumu.fromJson(Map<String, dynamic> json) =>
      _$PiyasaDurumuFromJson(json);

  /// Son aylık enflasyonun yıllıklandırılmış hali. Yalnızca gösterim içindir.
  double get yillikEnflasyon => math.pow(1 + sonAylikEnflasyon, 12) - 1;

  /// Taban TL tutarını bu turun nominal değerine çevirir.
  /// Maaş, kira, sabit gider — hepsi buradan geçer.
  int endeksle(int tabanTutar) => (tabanTutar * enflasyonEndeksi).round();

  /// Nominal tutarı bugünkü (oyun başı) paraya indirger. Skor ekranında
  /// "reel servet" göstermek için.
  int reeleCevir(int nominalTutar) => (nominalTutar / enflasyonEndeksi).round();

  /// Rejim değişimi için asgari süre doldu mu.
  bool get rejimDegisebilir => rejimSuresi >= rejimEnAzSure;

  /// Gösterim böleni. Her para reformunda [paraReformuSifirSayisi] sıfır
  /// atılır, yani bölen o kadar büyür.
  double get paraOlcegi =>
      math.pow(10, paraReformuSifirSayisi * paraReformuSayisi).toDouble();

  /// Oyuncunun ekranda gördüğü fiyat seviyesi. Reform sonrası 1'e yakın
  /// bir yerden devam eder.
  double get gosterimEndeksi => enflasyonEndeksi / paraOlcegi;

  /// Ham TL tutarını ekranda gösterilecek tutara çevirir.
  /// Motor içindeki hesaplar HAM tutarla yapılır; bu yalnızca sunum içindir.
  double gosterimTutari(int hamTutar) => hamTutar / paraOlcegi;

  /// Sıfır atma zamanı geldi mi.
  bool get paraReformuGerekli => gosterimEndeksi > paraReformuEsigi;

  /// Varlığın ham TL birim fiyatı. Tanımsız varlık için 0.
  double fiyat(String varlikId) => fiyatlar[varlikId] ?? 0;

  /// Bir varlığın reel fiyat serisi (eskiden yeniye). Tanımsızsa boş.
  List<double> seri(String varlikId) => gecmis[varlikId] ?? const [];

  /// Serinin başından sonuna reel değişim oranı (0.25 = %25 arttı).
  /// Yeterli veri yoksa null.
  double? reelDegisim(String varlikId, {int tur = 12}) {
    final s = seri(varlikId);
    if (s.length < 2) return null;
    final baslangic = s[s.length - 1 - (tur.clamp(1, s.length - 1))];
    if (baslangic <= 0) return null;
    return s.last / baslangic - 1;
  }

  /// Bu turun reel fiyatlarını geçmişe ekler, pencereyi taşanı atar.
  ///
  /// Piyasa simülatörü her tur çağırır. Ayrı metot olması bilinçli:
  /// geçmiş bir HESAP GİRDİSİ değil, kayıt altına alınan bir gözlem.
  PiyasaDurumu gecmiseYaz() {
    if (enflasyonEndeksi <= 0) return this;
    final yeni = <String, List<double>>{};
    for (final g in fiyatlar.entries) {
      final eski = gecmis[g.key] ?? const <double>[];
      final seri = [...eski, g.value / enflasyonEndeksi];
      yeni[g.key] = seri.length > fiyatGecmisiPenceresi
          ? seri.sublist(seri.length - fiyatGecmisiPenceresi)
          : seri;
    }
    return copyWith(gecmis: yeni);
  }

  /// Bir varlığın fiyatını çarpanla değiştirir.
  ///
  /// Olay kartlarının piyasaya müdahale kapısıdır: "arsanıza imar çıktı"
  /// kartı `fiyatiCarp('arsa', 6.0)` çağırır. Motor bu tür sıçramaları
  /// kendi üretmez.
  PiyasaDurumu fiyatiCarp(String varlikId, double carpan) {
    final mevcut = fiyatlar[varlikId];
    if (mevcut == null) return this;
    return copyWith(fiyatlar: {...fiyatlar, varlikId: mevcut * carpan});
  }
}

/// Reel fiyat serisinde tutulan tur sayısı (5 yıl).
const int fiyatGecmisiPenceresi = 60;

/// Sıfır atma eşiği: gösterim endeksi bunu aşınca para reformu yapılır.
const double paraReformuEsigi = 1000;

/// Her reformda atılan sıfır sayısı.
///
/// Tarihsel olarak 2005'te ALTI sıfır atıldı. Oyunda üç sıfır kullanılıyor:
/// 40 yıllık bir oyunda endeks medyanı ~78.000x, yani altı sıfırlık reform
/// ya hiç tetiklenmez ya da aşırı düzeltir. Üç sıfırla tipik bir oyunda
/// bir kez reform olur ve rakamlar okunabilir kalır.
const int paraReformuSifirSayisi = 3;
