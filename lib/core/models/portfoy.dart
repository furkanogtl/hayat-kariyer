import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfoy.freezed.dart';
part 'portfoy.g.dart';

/// Tek bir varlıktaki pozisyon.
@freezed
abstract class Pozisyon with _$Pozisyon {
  const Pozisyon._();

  const factory Pozisyon({
    required double adet,

    /// Birim başına ortalama alış maliyeti (ham TL, komisyon dahil).
    /// Kâr/zarar göstergesi buna bakar.
    required double ortalamaMaliyet,
  }) = _Pozisyon;

  factory Pozisyon.fromJson(Map<String, dynamic> json) =>
      _$PozisyonFromJson(json);

  double maliyet() => adet * ortalamaMaliyet;

  double deger(double birimFiyat) => adet * birimFiyat;

  /// Gerçekleşmemiş kâr/zarar.
  double karZarar(double birimFiyat) => deger(birimFiyat) - maliyet();
}

/// Henüz sonuçlanmamış satış emri.
///
/// Gayrimenkul ve arsa turlar sonra satılır. Bu sürede fiyat riski SATICIDA
/// kalır: emir verildiği anda değil, tamamlandığı turdaki fiyattan satılır.
/// "Evi satışa çıkardım, piyasa çakıldı" durumu bu yüzden mümkün.
@freezed
abstract class BekleyenSatis with _$BekleyenSatis {
  const BekleyenSatis._();

  const factory BekleyenSatis({
    required String varlikId,
    required double adet,
    required int kalanTur,
  }) = _BekleyenSatis;

  factory BekleyenSatis.fromJson(Map<String, dynamic> json) =>
      _$BekleyenSatisFromJson(json);

  bool get tamamlandi => kalanTur <= 0;

  BekleyenSatis turIlerlet() => copyWith(kalanTur: kalanTur - 1);
}

/// Oyuncunun yatırım portföyü.
@freezed
abstract class Portfoy with _$Portfoy {
  const Portfoy._();

  const factory Portfoy({
    /// Varlık kimliği -> pozisyon.
    @Default(<String, Pozisyon>{}) Map<String, Pozisyon> pozisyonlar,

    /// Satışa çıkarılmış ama henüz sonuçlanmamış emirler.
    @Default(<BekleyenSatis>[]) List<BekleyenSatis> bekleyenSatislar,
  }) = _Portfoy;

  factory Portfoy.fromJson(Map<String, dynamic> json) =>
      _$PortfoyFromJson(json);

  static const Portfoy bos = Portfoy();

  bool get bosMu => pozisyonlar.isEmpty && bekleyenSatislar.isEmpty;

  double adet(String varlikId) => pozisyonlar[varlikId]?.adet ?? 0;

  /// Satışa çıkarılmış ama henüz elden çıkmamış adet.
  /// Aynı daireyi iki kez satmayı bu engelliyor.
  double satistakiAdet(String varlikId) => bekleyenSatislar
      .where((s) => s.varlikId == varlikId)
      .fold<double>(0, (toplam, s) => toplam + s.adet);

  /// Şu anda satılabilir adet.
  double satilabilirAdet(String varlikId) =>
      adet(varlikId) - satistakiAdet(varlikId);

  /// Portföyün piyasa değeri. Fiyatlar dışarıdan verilir; portföy modeli
  /// piyasayı tanımaz.
  double piyasaDegeri(Map<String, double> fiyatlar) {
    var toplam = 0.0;
    for (final girdi in pozisyonlar.entries) {
      toplam += girdi.value.deger(fiyatlar[girdi.key] ?? 0);
    }
    return toplam;
  }

  double toplamMaliyet() => pozisyonlar.values
      .fold<double>(0, (toplam, p) => toplam + p.maliyet());

  /// Bozuk/eski kayda karşı savunma: negatif ve sıfır pozisyonları temizler.
  Portfoy duzelt() => Portfoy(
        pozisyonlar: {
          for (final g in pozisyonlar.entries)
            if (g.value.adet > 0)
              g.key: Pozisyon(
                adet: g.value.adet,
                ortalamaMaliyet:
                    g.value.ortalamaMaliyet < 0 ? 0 : g.value.ortalamaMaliyet,
              ),
        },
        bekleyenSatislar: [
          for (final s in bekleyenSatislar)
            if (s.adet > 0) s.copyWith(kalanTur: s.kalanTur < 0 ? 0 : s.kalanTur),
        ],
      );
}
