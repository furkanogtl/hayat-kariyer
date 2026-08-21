import 'package:json_annotation/json_annotation.dart';

import '../engine/rejim.dart';

/// Yatırım aracı türleri. Her türün oynanış içindeki rolü farklıdır.
@JsonEnum(valueField: 'id')
enum VarlikTuru {
  /// Faiz getirisi, oynaklık yok denecek kadar az. Güvenli ama enflasyonun
  /// altında kalır — "hiçbir şey yapmama" seçeneğinin bedeli.
  mevduat('mevduat'),

  /// Krizde ters korelasyon: herkes kaybederken kazandırır.
  altin('altin'),

  /// Borsa sektörleri. Ortak piyasa şokunu paylaşırlar.
  hisse('hisse'),

  /// Enflasyona ve kur şokuna bağlı.
  doviz('doviz'),

  /// Düşük oynaklık, kira geliri, satışı turlar sürer.
  gayrimenkul('gayrimenkul'),

  /// Likit değil, gelir yok; imar haberiyle sıçrar.
  arsa('arsa'),

  /// Aşırı oynaklık.
  kripto('kripto');

  const VarlikTuru(this.id);

  final String id;

  static VarlikTuru? bul(String id) {
    for (final t in VarlikTuru.values) {
      if (t.id == id) return t;
    }
    return null;
  }
}

/// Varlıkların paylaştığı şok kaynağı.
///
/// Bunlar olmadan her varlık bağımsız zar atardı ve kriz turunda bazı
/// sektörler yükselirdi — piyasa çöküşü hissi oluşmazdı.
enum OrtakFaktor {
  /// Genel piyasa iştahı. Hisse sektörleri ve kripto buna bağlı.
  piyasa,

  /// Kur şoku. Döviz ve altın buna bağlı.
  kur,

  /// Bağımsız hareket eder.
  yok,
}

/// Bir varlığın belirli bir rejimdeki GBM parametreleri.
///
/// [drift] AYLIK BİLEŞİK (logaritmik) GETİRİDİR: 0.05 = fiyat ayda ortalama
/// e^0.05 ≈ %5,1 katlanarak büyür.
///
/// Basit beklenen getiri yerine bileşik getiri kullanılıyor, çünkü oyuncu
/// ortalamayı değil TEK BİR YOLU yaşar. Basit getiri tanımı, oynaklığı
/// yüksek varlıklarda (kripto, hisse) tabloda yazandan sistematik olarak
/// daha kötü bir bileşik sonuç üretiyordu — volatilite sürüklenmesi.
/// Bu tanımla tablodaki sayı doğrudan uzun vadeli büyüme hızıdır.
class GbmParametresi {
  const GbmParametresi(this.drift, this.oynaklik);

  final double drift;
  final double oynaklik;
}

/// Bir yatırım aracının tanımı.
class VarlikTanimi {
  const VarlikTanimi({
    required this.id,
    required this.tur,
    required this.baslangicFiyati,
    required this.parametreler,
    this.ortakFaktor = OrtakFaktor.yok,
    this.ortakAgirlik = 0.0,
    this.aylikGetiriOrani = 0.0,
    this.satisSuresiTur = 0,
  });

  final String id;
  final VarlikTuru tur;

  /// Oyun başındaki birim fiyat (TL). Birim: altın gram, döviz 1 USD,
  /// hisse 1 lot, gayrimenkul bir daire, arsa bir parsel.
  final double baslangicFiyati;

  final Map<Rejim, GbmParametresi> parametreler;

  final OrtakFaktor ortakFaktor;

  /// Ortak şokun toplam oynaklık içindeki payı (0-1). Kalanı varlığa özgü.
  final double ortakAgirlik;

  /// Fiyatın üzerine binen aylık nakit getiri (kira, temettü). Gayrimenkulde
  /// dolu, arsada sıfır — arsanın gelir üretmemesi bilinçli bir kısıttır.
  final double aylikGetiriOrani;

  /// Satış emrinin gerçekleşmesi kaç tur sürer. 0 = anında.
  final int satisSuresiTur;

  bool get likit => satisSuresiTur == 0;

  GbmParametresi parametre(Rejim rejim) => parametreler[rejim]!;
}

/// Borsa sektörü. Kendi tablosunu yazmak yerine rejimin piyasa drift ve
/// oynaklığına [beta] ve [oynaklikCarpani] ile bağlanır.
///
/// Sebebi: rejim tablosundaki bir sayıyı değiştirdiğimizde altı sektörün
/// hepsi tutarlı biçimde kaysın. Altı ayrı tablo tutulsaydı denge ayarı
/// sırasında birbirinden kopardı.
class HisseSektoru {
  const HisseSektoru({
    required this.id,
    required this.beta,
    required this.oynaklikCarpani,
  });

  final String id;

  /// Borsanın ENFLASYON ÜSTÜ getirisine duyarlılık. 0.6 defansif, 1.4
  /// agresif. Nominal getiriye değil reel prime uygulanır; böylece defansif
  /// sektör de enflasyonu yener, sadece daha az kazandırır.
  final double beta;

  /// Piyasa oynaklığına çarpan.
  final double oynaklikCarpani;

  VarlikTanimi tanim() => VarlikTanimi(
        id: id,
        tur: VarlikTuru.hisse,
        baslangicFiyati: 100,
        ortakFaktor: OrtakFaktor.piyasa,
        ortakAgirlik: 0.7,
        parametreler: {
          for (final r in Rejim.values)
            r: GbmParametresi(
              r.parametreler.sektorDrifti(beta),
              r.parametreler.piyasaOynakligi * oynaklikCarpani,
            ),
        },
      );
}

/// Borsa sektörleri. Anayasadaki "5-6 sektör" gereği.
const List<HisseSektoru> hisseSektorleri = [
  HisseSektoru(id: 'hisse_bankacilik', beta: 1.3, oynaklikCarpani: 1.2),
  HisseSektoru(id: 'hisse_sanayi', beta: 1.0, oynaklikCarpani: 1.0),
  HisseSektoru(id: 'hisse_teknoloji', beta: 1.2, oynaklikCarpani: 1.4),
  HisseSektoru(id: 'hisse_gida', beta: 0.6, oynaklikCarpani: 0.6),
  HisseSektoru(id: 'hisse_insaat', beta: 1.4, oynaklikCarpani: 1.3),
  HisseSektoru(id: 'hisse_enerji', beta: 0.8, oynaklikCarpani: 0.9),
];

/// Hisse dışı varlıklar. Bunların rejim davranışı sektörlerden bağımsız
/// olduğu için tabloları açıkça yazıldı.
const List<VarlikTanimi> temelVarliklar = [
  // Mevduat her rejimde enflasyonun ALTINDA getiri verir. "Parayı bankada
  // tut" stratejisi güvenlidir ama reel olarak kaybettirir; oyunun temel
  // baskısı budur.
  VarlikTanimi(
    id: 'mevduat',
    tur: VarlikTuru.mevduat,
    baslangicFiyati: 100,
    parametreler: {
      Rejim.buyume: GbmParametresi(0.013, 0.0005),
      Rejim.durgunluk: GbmParametresi(0.008, 0.0005),
      Rejim.kriz: GbmParametresi(0.020, 0.0010),
      Rejim.enflasyon: GbmParametresi(0.030, 0.0010),
    },
  ),
  // Altın: krizde ve enflasyonda patlar, büyümede geride kalır.
  VarlikTanimi(
    id: 'altin',
    tur: VarlikTuru.altin,
    baslangicFiyati: 4500,
    ortakFaktor: OrtakFaktor.kur,
    ortakAgirlik: 0.6,
    parametreler: {
      Rejim.buyume: GbmParametresi(0.008, 0.035),
      Rejim.durgunluk: GbmParametresi(0.012, 0.030),
      Rejim.kriz: GbmParametresi(0.050, 0.060),
      Rejim.enflasyon: GbmParametresi(0.042, 0.045),
    },
  ),
  VarlikTanimi(
    id: 'doviz',
    tur: VarlikTuru.doviz,
    baslangicFiyati: 42,
    ortakFaktor: OrtakFaktor.kur,
    ortakAgirlik: 0.9,
    parametreler: {
      Rejim.buyume: GbmParametresi(0.006, 0.020),
      Rejim.durgunluk: GbmParametresi(0.008, 0.020),
      Rejim.kriz: GbmParametresi(0.050, 0.070),
      Rejim.enflasyon: GbmParametresi(0.038, 0.035),
    },
  ),
  // Gayrimenkul: düşük oynaklık + kira geliri, ama satışı üç tur sürer.
  VarlikTanimi(
    id: 'gayrimenkul',
    tur: VarlikTuru.gayrimenkul,
    baslangicFiyati: 3500000,
    aylikGetiriOrani: 0.004,
    satisSuresiTur: 3,
    parametreler: {
      Rejim.buyume: GbmParametresi(0.028, 0.012),
      Rejim.durgunluk: GbmParametresi(0.014, 0.010),
      Rejim.kriz: GbmParametresi(0.000, 0.020),
      Rejim.enflasyon: GbmParametresi(0.050, 0.015),
    },
  ),
  // Arsa: gelir yok, likit değil. Değeri imar olayıyla sıçrar.
  VarlikTanimi(
    id: 'arsa',
    tur: VarlikTuru.arsa,
    baslangicFiyati: 1200000,
    satisSuresiTur: 3,
    parametreler: {
      Rejim.buyume: GbmParametresi(0.026, 0.020),
      Rejim.durgunluk: GbmParametresi(0.012, 0.015),
      Rejim.kriz: GbmParametresi(-0.005, 0.030),
      Rejim.enflasyon: GbmParametresi(0.045, 0.025),
    },
  ),
  VarlikTanimi(
    id: 'kripto',
    tur: VarlikTuru.kripto,
    baslangicFiyati: 3500000,
    ortakFaktor: OrtakFaktor.piyasa,
    ortakAgirlik: 0.4,
    parametreler: {
      Rejim.buyume: GbmParametresi(0.090, 0.250),
      Rejim.durgunluk: GbmParametresi(0.000, 0.200),
      Rejim.kriz: GbmParametresi(-0.120, 0.350),
      Rejim.enflasyon: GbmParametresi(0.090, 0.280),
    },
  ),
];

/// Oyundaki tüm yatırım araçları. Sıra SABİTTİR — zar atma sırası buna
/// bağlı olduğu için değişirse eski kayıtlar farklı fiyat üretir.
final List<VarlikTanimi> piyasaVarliklari = List.unmodifiable([
  ...temelVarliklar,
  ...hisseSektorleri.map((s) => s.tanim()),
]);
