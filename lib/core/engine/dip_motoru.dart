import '../models/borc.dart';
import '../models/oyuncu.dart';
import '../models/piyasa_durumu.dart';
import '../models/portfoy.dart';

/// Oyunun DİBİ: parası biten ve borcunu ödeyemeyen oyuncuya ne olduğu.
///
/// Bu sistem olmadan oyunun kaybetme hâli TANIMSIZDI. Ölçüldü: borcu
/// olmayan işsiz bir oyuncu bile 20 yılda -12,5M reel net değere,
/// kredili olan -408M'ye iniyordu — eksi bakiye faizi sınırsız
/// bileşikleniyor, yaşam gideri hiç durmuyordu. Gerçek hayatta o noktada
/// icra, haciz ve gideri kısma var; oyunda sayaç sonsuza akıyordu.
///
/// Üç kademe:
///   1. [kisitliYasamda]  — yumuşak dip: gider düşer, mutluluk erir
///   2. [iflasGerekiyorMu] — sert dip: haciz, borç silme, kredi yasağı
///   3. `oyunSonuYasi`     — bitiş
class DipAyarlari {
  const DipAyarlari();

  /// Nakit bunun altındayken oyuncu kemer sıkar (aileye dönme, ev
  /// küçültme). Sıfır: hesap eksiye düşer düşmez.
  final int kisitliYasamEsigi = 0;

  /// Kısıtlı yaşamda yaşam giderinin çarpanı.
  ///
  /// Bedava kurtuluş DEĞİL: gider düşerken mutluluk da eriyor. Yoksa
  /// oyuncu için "parasız kalmak" bir tasarruf stratejisine dönüşürdü.
  final double kisitliGiderCarpani = 0.55;

  /// Kısıtlı yaşamın her turdaki mutluluk bedeli.
  final int kisitliMutlulukKaybi = 3;

  /// Bir borç bu kadar tur üst üste ödenmezse haciz gelir.
  /// `BorcAyarlari.takipEsigi` (3) takibi başlatıyor; bu onun iki katı.
  final int iflasEsigi = 6;

  /// Hacizde varlıklar bu iskontoyla elden çıkar. İcra satışı piyasa
  /// fiyatından olmaz.
  final double hacizIskontosu = 0.20;

  /// Haciz sonrası kredi notu buraya iner.
  final int iflasKrediNotu = Oyuncu.krediNotuTaban;

  /// Haciz sonrası kaç tur kredi kapalı kalır.
  final int krediYasagiTuru = 24;

  final int iflasItibarKaybi = 15;
  final int iflasMutlulukKaybi = 25;

  /// Oyun bu yaşta biter ve skor ekranı gelir.
  final int oyunSonuYasi = 65;
}

/// Bir haciz olayının sonucu.
class IflasSonucu {
  const IflasSonucu({
    required this.portfoy,
    required this.hacizGeliri,
    required this.silinenBorc,
  });

  /// Haciz sonrası (boş) portföy.
  final Portfoy portfoy;

  /// Varlıkların icra satışından gelen tutar (nominal TL).
  final int hacizGeliri;

  /// Haciz geliri yetmediği için SİLİNEN borç (nominal TL).
  final int silinenBorc;
}

/// Dip mekaniklerini işler. SAF: nakde kendisi dokunmaz, tutarları döner.
class DipMotoru {
  const DipMotoru({this.ayarlar = const DipAyarlari()});

  final DipAyarlari ayarlar;

  /// Oyuncu kemer sıkma hâlinde mi.
  bool kisitliYasamda(int nakit) => nakit < ayarlar.kisitliYasamEsigi;

  /// Kısıtlı yaşam uygulandıktan sonraki yaşam gideri.
  int yasamGideri(int tamGider, int nakit) => kisitliYasamda(nakit)
      ? (tamGider * ayarlar.kisitliGiderCarpani).round()
      : tamGider;

  /// Haciz zamanı geldi mi.
  ///
  /// Tek bir borcun eşiği aşması yeter: icra tek alacaklıyla başlar.
  bool iflasGerekiyorMu(Iterable<Borc> borclar) =>
      borclar.any((b) => b.gecikmeTuru >= ayarlar.iflasEsigi);

  /// Haczi uygular: portföy elden çıkar, kalan borç silinir.
  ///
  /// Likit olmayan varlık da gider: icrada tapu ilk hacizlenendir, bu
  /// yüzden `satisSuresiTur` beklenmiyor.
  ///
  /// İŞLETMELERE DOKUNULMUYOR. Gerçek icrada işletme de hacizlenirdi ama
  /// oyuncunun toparlanacak bir dayanağı kalmalı; her şeyi kaybetmek
  /// oyunu bitirir, oysa iflas bir bitiş değil bir dip olmalı.
  IflasSonucu hacizUygula({
    required Portfoy portfoy,
    required Iterable<Borc> borclar,
    required PiyasaDurumu piyasa,
    required int nakit,
  }) {
    var gelir = 0.0;
    for (final g in portfoy.pozisyonlar.entries) {
      final fiyat = piyasa.fiyat(g.key);
      gelir += g.value.adet * fiyat * (1 - ayarlar.hacizIskontosu);
    }
    final hacizGeliri = gelir.round();

    // Borç kapatma sırası: haciz geliri + varsa artıda kalan nakit.
    final toplamBorc = borclar.fold<int>(0, (t, b) => t + b.kalanAnapara);
    final odenebilir = hacizGeliri + (nakit > 0 ? nakit : 0);
    final silinen = toplamBorc - odenebilir;

    return IflasSonucu(
      portfoy: Portfoy.bos,
      hacizGeliri: hacizGeliri,
      silinenBorc: silinen < 0 ? 0 : silinen,
    );
  }

  /// Haciz sonrası oyuncunun hâli.
  Oyuncu oyuncuyuGuncelle(Oyuncu oyuncu) => oyuncu
      .copyWith(krediNotu: ayarlar.iflasKrediNotu)
      .itibarDegistir(-ayarlar.iflasItibarKaybi)
      .mutlulukDegistir(-ayarlar.iflasMutlulukKaybi);

  /// Oyun bitti mi.
  bool oyunBitti(int yas) => yas >= ayarlar.oyunSonuYasi;
}
