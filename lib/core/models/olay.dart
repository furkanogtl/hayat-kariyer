import 'package:freezed_annotation/freezed_annotation.dart';

import '../engine/rejim.dart';
import 'egitim_seviyesi.dart';
import 'kariyer_durumu.dart';
import 'oyuncu.dart';
import 'piyasa_durumu.dart';
import 'sehir.dart';
import 'sektor.dart';

part 'olay.freezed.dart';
part 'olay.g.dart';

/// Olay kartının türü. Yalnızca fırsat kartları itibardan etkilenir.
@JsonEnum(valueField: 'id')
enum OlayTuru {
  /// Kazanç kapısı. Çıkma ihtimali oyuncunun itibarıyla artar.
  firsat('firsat'),

  /// Beklenmedik gider ya da kayıp.
  kriz('kriz'),

  /// İş/ortaklık teklifi.
  teklif('teklif'),

  /// Gündelik hayat: kira zammı, düğün, hastalık.
  hayat('hayat');

  const OlayTuru(this.id);

  final String id;

  static OlayTuru? bul(String id) {
    for (final t in OlayTuru.values) {
      if (t.id == id) return t;
    }
    return null;
  }
}

/// Bir seçeneğin ya da sonucun oyuna etkisi.
///
/// Para tutarları TABAN TL'dir (2026 ölçeği) ve motor tarafından enflasyon
/// endeksiyle çarpılır. Aksi halde 150.000 TL'lik bir teklif 20 yıl sonra
/// harçlık kalırdı.
@freezed
abstract class OlayEtkileri with _$OlayEtkileri {
  const OlayEtkileri._();

  const factory OlayEtkileri({
    @Default(0) int nakit,
    @Default(0) int enerji,
    @Default(0) int mutluluk,
    @Default(0) int itibar,
    @Default(0) int krediNotu,

    /// Sektör bazlı yetkinlik değişimi.
    @Default(<Sektor, int>{}) Map<Sektor, int> yetkinlik,

    /// Piyasaya müdahale: `{"arsa": 6.0}` imar haberi.
    @Default(<String, double>{}) Map<String, double> fiyatCarpani,

    /// Portföye eklenen (ya da eksiyle çıkarılan) adet.
    @Default(<String, double>{}) Map<String, double> varlik,
  }) = _OlayEtkileri;

  factory OlayEtkileri.fromJson(Map<String, dynamic> json) =>
      _$OlayEtkileriFromJson(json);

  bool get bosMu =>
      nakit == 0 &&
      enerji == 0 &&
      mutluluk == 0 &&
      itibar == 0 &&
      krediNotu == 0 &&
      yetkinlik.isEmpty &&
      fiyatCarpani.isEmpty &&
      varlik.isEmpty;
}

/// Bir seçeneğin olası sonuçlarından biri.
@freezed
abstract class OlaySonucu with _$OlaySonucu {
  const OlaySonucu._();

  const factory OlaySonucu({
    /// Bu dalın çıkma ihtimali. Bir seçenekteki payların toplamı 1 olmalı.
    required double sans,
    required String metin,
    @Default(OlayEtkileri()) OlayEtkileri etkiler,
  }) = _OlaySonucu;

  factory OlaySonucu.fromJson(Map<String, dynamic> json) =>
      _$OlaySonucuFromJson(json);
}

/// Oyuncunun seçebileceği bir cevap.
@freezed
abstract class OlaySecenegi with _$OlaySecenegi {
  const OlaySecenegi._();

  const factory OlaySecenegi({
    required String etiket,

    /// Seçildiği anda uygulanan etkiler.
    @Default(OlayEtkileri()) OlayEtkileri etkiler,

    /// Rastgele dallanan sonuçlar. Boşsa yalnızca [etkiler] işler.
    @Default(<OlaySonucu>[]) List<OlaySonucu> sonuclar,

    /// Sonucun kaç tur sonra açığa çıkacağı. 0 = anında.
    /// Gerilimin kaynağı: parayı bugün verirsin, sonucu altı ay sonra
    /// öğrenirsin.
    @Default(0) int gecikmeTuru,
  }) = _OlaySecenegi;

  factory OlaySecenegi.fromJson(Map<String, dynamic> json) =>
      _$OlaySecenegiFromJson(json);

  bool get dallaniyor => sonuclar.isNotEmpty;

  bool get gecikmeli => gecikmeTuru > 0;
}

/// Kartın çıkabilmesi için gereken koşullar. Hepsi isteğe bağlıdır.
@freezed
abstract class OlayKosullari with _$OlayKosullari {
  const OlayKosullari._();

  const factory OlayKosullari({
    int? enAzItibar,

    /// Asgari nakit — TABAN TL. Oyuncunun nakiti enflasyondan arındırılarak
    /// karşılaştırılır.
    int? enAzNakit,
    int? enAzEnerji,
    int? enAzMutluluk,
    int? enAzKrediNotu,

    /// `[enAz, enCok]`.
    @JsonKey(name: 'yas') List<int>? yasAraligi,
    List<Sehir>? sehirler,
    List<String>? meslekler,
    List<Sektor>? sektorler,
    List<Rejim>? rejimler,
    List<KariyerTuru>? durumlar,
    Cinsiyet? cinsiyet,
    EgitimSeviyesi? enAzEgitim,
  }) = _OlayKosullari;

  factory OlayKosullari.fromJson(Map<String, dynamic> json) =>
      _$OlayKosullariFromJson(json);

  /// Oyuncu ve piyasa bu koşulları sağlıyor mu.
  bool uygunMu(Oyuncu oyuncu, PiyasaDurumu piyasa) {
    if (enAzItibar != null && oyuncu.itibar < enAzItibar!) return false;
    if (enAzEnerji != null && oyuncu.enerji < enAzEnerji!) return false;
    if (enAzMutluluk != null && oyuncu.mutluluk < enAzMutluluk!) return false;
    if (enAzKrediNotu != null && oyuncu.krediNotu < enAzKrediNotu!) return false;
    if (enAzNakit != null) {
      // Kart tutarları taban TL yazıldığı için karşılaştırma da reel.
      if (piyasa.reeleCevir(oyuncu.nakit) < enAzNakit!) return false;
    }
    if (yasAraligi != null && yasAraligi!.length == 2) {
      if (oyuncu.yas < yasAraligi![0] || oyuncu.yas > yasAraligi![1]) {
        return false;
      }
    }
    if (sehirler != null && !sehirler!.contains(oyuncu.sehir)) return false;
    if (cinsiyet != null && oyuncu.cinsiyet != cinsiyet) return false;
    if (enAzEgitim != null && !oyuncu.egitim.yeterliMi(enAzEgitim!)) {
      return false;
    }
    if (rejimler != null && !rejimler!.contains(piyasa.rejim)) return false;
    if (durumlar != null && !durumlar!.contains(oyuncu.kariyer.turu)) {
      return false;
    }
    if (meslekler != null) {
      final id = oyuncu.kariyer.meslekId;
      if (id == null || !meslekler!.contains(id)) return false;
    }
    if (sektorler != null) {
      final sektor = oyuncu.anaSektor;
      if (sektor == null || !sektorler!.contains(sektor)) return false;
    }
    return true;
  }
}

/// Seçildiği anda sonuçlanmayan, turlar sonra açığa çıkacak karar.
///
/// Oyunun gerilim kaynağı: parayı bugün verirsin, ortaklığın tuttu mu diye
/// altı ay beklersin. Sonuç zarı BEKLEME BİTİNCE atılır; kararın verildiği
/// anda atılıp saklansaydı kayıt dosyasını okuyan sonucu görebilirdi.
@freezed
abstract class BekleyenOlay with _$BekleyenOlay {
  const BekleyenOlay._();

  const factory BekleyenOlay({
    required String olayId,
    required int secenekIndeksi,
    required int kalanTur,
  }) = _BekleyenOlay;

  factory BekleyenOlay.fromJson(Map<String, dynamic> json) =>
      _$BekleyenOlayFromJson(json);

  bool get zamaniGeldi => kalanTur <= 0;

  BekleyenOlay turIlerlet() => copyWith(kalanTur: kalanTur - 1);
}

/// Bir olay kartı. Kod değil VERİDİR: `assets/events/*.json`.
@freezed
abstract class Olay with _$Olay {
  const Olay._();

  const factory Olay({
    required String id,
    required String baslik,

    /// En fazla 2-3 cümle. Mobilde uzun paragraf okunmaz.
    required String metin,
    @Default(OlayTuru.hayat) OlayTuru tur,
    @Default(OlayKosullari()) OlayKosullari kosullar,

    /// Seçim havuzundaki ağırlık.
    @Default(10.0) double agirlik,

    /// Oyun boyunca bir kez mi çıkar.
    @Default(false) bool tekSeferlik,

    /// Tekrar çıkabilmesi için geçmesi gereken tur.
    @Default(60) int bekleme,
    required List<OlaySecenegi> secenekler,
  }) = _Olay;

  factory Olay.fromJson(Map<String, dynamic> json) => _$OlayFromJson(json);

  /// Veri dosyası doğrulaması. Boş liste = geçerli.
  List<String> dogrula() {
    final hatalar = <String>[];
    if (id.isEmpty) hatalar.add('id boş');
    if (baslik.isEmpty) hatalar.add('$id: başlık boş');
    if (metin.isEmpty) hatalar.add('$id: metin boş');
    if (metin.length > 220) {
      hatalar.add('$id: metin ${metin.length} karakter (en fazla 220)');
    }
    if (agirlik <= 0) hatalar.add('$id: ağırlık pozitif olmalı');
    if (bekleme < 0) hatalar.add('$id: bekleme negatif');
    if (secenekler.isEmpty) {
      hatalar.add('$id: seçenek yok');
      return hatalar;
    }
    if (secenekler.length > 4) {
      hatalar.add('$id: ${secenekler.length} seçenek (mobilde en fazla 4)');
    }

    for (final s in secenekler) {
      if (s.etiket.isEmpty) hatalar.add('$id: seçenek etiketi boş');
      if (s.gecikmeTuru < 0) hatalar.add('$id/${s.etiket}: gecikme negatif');
      if (s.gecikmeli && !s.dallaniyor) {
        hatalar.add(
          '$id/${s.etiket}: gecikmeli seçenekte sonuç dalı olmalı, '
          'yoksa bekleyecek bir şey yok',
        );
      }
      if (s.dallaniyor) {
        final toplam = s.sonuclar.fold<double>(0, (t, o) => t + o.sans);
        if ((toplam - 1).abs() > 0.001) {
          hatalar.add(
            '$id/${s.etiket}: sonuç şansları toplamı $toplam (1 olmalı)',
          );
        }
        for (final o in s.sonuclar) {
          if (o.sans <= 0) hatalar.add('$id/${s.etiket}: sıfır şanslı dal');
          if (o.metin.isEmpty) hatalar.add('$id/${s.etiket}: sonuç metni boş');
        }
      }
    }

    if (kosullar.yasAraligi != null && kosullar.yasAraligi!.length != 2) {
      hatalar.add('$id: yas iki elemanlı olmalı');
    }
    return hatalar;
  }
}
