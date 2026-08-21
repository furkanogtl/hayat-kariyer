import 'package:json_annotation/json_annotation.dart';

/// Ekonomik rejim. Tüm varlıkların drift ve oynaklık değerlerini ve aylık
/// enflasyonu bu belirler.
///
/// Rejim oyunun en büyük "makro" kaldıracıdır: oyuncu tek tek varlıkları
/// değil, hangi rejimde hangi pozisyonda olduğunu yönetir.
@JsonEnum(valueField: 'id')
enum Rejim {
  buyume('buyume'),
  durgunluk('durgunluk'),
  kriz('kriz'),
  enflasyon('enflasyon');

  const Rejim(this.id);

  final String id;

  static Rejim? bul(String id) {
    for (final r in Rejim.values) {
      if (r.id == id) return r;
    }
    return null;
  }

  RejimParametreleri get parametreler => rejimTablosu[this]!;
}

/// Bir rejimin ekonomik davranışı.
///
/// Drift ve oynaklık AYLIK LOGARİTMİK değerlerdir (GBM adımı için).
class RejimParametreleri {
  const RejimParametreleri({
    required this.aylikEnflasyon,
    required this.enflasyonOynakligi,
    required this.piyasaDrift,
    required this.piyasaOynakligi,
    required this.gecisAgirliklari,
  });

  /// Beklenen aylık enflasyon (0.03 = %3).
  final double aylikEnflasyon;

  /// Aylık enflasyonun standart sapması.
  final double enflasyonOynakligi;

  /// Beta 1 olan bir borsa sektörünün aylık bileşik NOMİNAL getirisi.
  ///
  /// Sektörler buna beta ile bağlanır ama beta NOMİNALE değil, enflasyon
  /// ÜSTÜ getiriye uygulanır: `piyasaDrift - aylikEnflasyon`. Nominale
  /// uygulansaydı yıllık %32 enflasyonda düşük betalı sektörler enflasyonun
  /// çok altında kalır, yüksek betalılar ise reel %18 kazandırırdı —
  /// defansif sektör oynanamaz, agresif sektör tek doğru cevap olurdu.
  final double piyasaDrift;

  /// Bu rejimde borsanın enflasyon üstü (reel) beklentisi.
  double get piyasaReelPrimi => piyasaDrift - aylikEnflasyon;

  /// Beta katsayısına göre sektör drift'i.
  double sektorDrifti(double beta) => aylikEnflasyon + beta * piyasaReelPrimi;

  /// Hisse senedi piyasasının baz aylık oynaklığı.
  final double piyasaOynakligi;

  /// Rejim değişirse hangi rejime geçileceğinin ağırlıkları.
  /// Kendine geçiş yoktur — değişim kararı ayrı verilir.
  final Map<Rejim, double> gecisAgirliklari;
}

/// Rejim en az bu kadar tur sürer. Olmazsa rejim her tur zıplar ve oyuncu
/// strateji kuramaz.
const int rejimEnAzSure = 4;

/// Asgari süre dolduktan sonra her turdaki değişim ihtimali.
/// 4 + 1/0.15 ≈ 11 tur ortalama; anayasadaki "8-12 tur" hedefini tutturur.
const double rejimDegisimSansi = 0.15;

/// Rejim davranış tablosu.
///
/// Enflasyon oranları Türkiye ölçeğinde tutuldu: büyümede bile yıllık ~%20,
/// enflasyon rejiminde ~%70. Nakit tutmak her rejimde kaybettirir; mesele
/// ne kadar kaybettirdiğidir.
const Map<Rejim, RejimParametreleri> rejimTablosu = {
  Rejim.buyume: RejimParametreleri(
    aylikEnflasyon: 0.015,
    enflasyonOynakligi: 0.004,
    piyasaDrift: 0.065,
    piyasaOynakligi: 0.070,
    gecisAgirliklari: {
      Rejim.durgunluk: 0.45,
      Rejim.enflasyon: 0.40,
      Rejim.kriz: 0.15,
    },
  ),
  Rejim.durgunluk: RejimParametreleri(
    aylikEnflasyon: 0.010,
    enflasyonOynakligi: 0.003,
    piyasaDrift: 0.015,
    piyasaOynakligi: 0.060,
    gecisAgirliklari: {
      Rejim.buyume: 0.45,
      Rejim.enflasyon: 0.30,
      Rejim.kriz: 0.25,
    },
  ),
  Rejim.kriz: RejimParametreleri(
    aylikEnflasyon: 0.030,
    enflasyonOynakligi: 0.010,
    piyasaDrift: -0.050,
    piyasaOynakligi: 0.120,
    gecisAgirliklari: {
      Rejim.durgunluk: 0.55,
      Rejim.enflasyon: 0.35,
      Rejim.buyume: 0.10,
    },
  ),
  Rejim.enflasyon: RejimParametreleri(
    aylikEnflasyon: 0.045,
    enflasyonOynakligi: 0.012,
    piyasaDrift: 0.058,
    piyasaOynakligi: 0.090,
    gecisAgirliklari: {
      Rejim.durgunluk: 0.40,
      Rejim.buyume: 0.30,
      Rejim.kriz: 0.30,
    },
  ),
};
