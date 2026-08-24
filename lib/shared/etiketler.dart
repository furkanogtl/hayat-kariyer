import '../core/engine/rejim.dart';
import '../core/models/egitim_seviyesi.dart';
import '../core/models/kariyer_durumu.dart';
import '../core/models/meslek_katalogu.dart';
import '../core/models/sehir.dart';
import '../core/models/sektor.dart';
import '../l10n/uygulama_metinleri.dart';

/// Enum -> ekran metni köprüsü.
///
/// Her biri `switch` ile yazıldı, `Map` ile değil: yeni bir şehir ya da
/// rejim eklendiğinde derleyici burada hata versin, ekranda boş metin
/// çıkmasın.
///
/// Meslek ve olay kartı metinleri BURADA YOK — onlar veri dosyalarında
/// (`assets/careers`, `assets/events`) yaşıyor. ARB yalnızca arayüzü
/// taşır; 93 olay kartını ARB'ye taşımak veriyi ikiye bölerdi.

extension SehirEtiketi on Sehir {
  String ad(UygulamaMetinleri m) => switch (this) {
        Sehir.istanbul => m.sehirIstanbul,
        Sehir.izmir => m.sehirIzmir,
        Sehir.gaziantep => m.sehirGaziantep,
        Sehir.trabzon => m.sehirTrabzon,
        Sehir.konya => m.sehirKonya,
      };
}

extension EgitimEtiketi on EgitimSeviyesi {
  String ad(UygulamaMetinleri m) => switch (this) {
        EgitimSeviyesi.ilkogretim => m.egitimIlkogretim,
        EgitimSeviyesi.lise => m.egitimLise,
        EgitimSeviyesi.onlisans => m.egitimOnlisans,
        EgitimSeviyesi.lisans => m.egitimLisans,
        EgitimSeviyesi.yuksekLisans => m.egitimYuksekLisans,
        EgitimSeviyesi.doktora => m.egitimDoktora,
      };
}

extension CinsiyetEtiketi on Cinsiyet {
  String ad(UygulamaMetinleri m) => switch (this) {
        Cinsiyet.erkek => m.cinsiyetErkek,
        Cinsiyet.kadin => m.cinsiyetKadin,
      };
}

extension SektorEtiketi on Sektor {
  String ad(UygulamaMetinleri m) => switch (this) {
        Sektor.saglik => m.sektorSaglik,
        Sektor.teknoloji => m.sektorTeknoloji,
        Sektor.hukukKamu => m.sektorHukukKamu,
        Sektor.finans => m.sektorFinans,
        Sektor.ticaret => m.sektorTicaret,
        Sektor.esnaf => m.sektorEsnaf,
        Sektor.medya => m.sektorMedya,
        Sektor.lojistik => m.sektorLojistik,
        Sektor.tarim => m.sektorTarim,
        Sektor.turizm => m.sektorTurizm,
      };
}

extension RejimEtiketi on Rejim {
  String ad(UygulamaMetinleri m) => switch (this) {
        Rejim.buyume => m.rejimBuyume,
        Rejim.durgunluk => m.rejimDurgunluk,
        Rejim.kriz => m.rejimKriz,
        Rejim.enflasyon => m.rejimEnflasyon,
      };
}

/// Ay numarası (1-12) -> ay adı.
String ayAdi(UygulamaMetinleri m, int ay) => switch (ay) {
      1 => m.ayOcak,
      2 => m.aySubat,
      3 => m.ayMart,
      4 => m.ayNisan,
      5 => m.ayMayis,
      6 => m.ayHaziran,
      7 => m.ayTemmuz,
      8 => m.ayAgustos,
      9 => m.ayEylul,
      10 => m.ayEkim,
      11 => m.ayKasim,
      _ => m.ayAralik,
    };

/// Kariyer durumunun başlık satırı.
///
/// Çalışan için meslek ve kademe adı KATALOGDAN gelir; o metinler veridir,
/// ARB'de değil.
String kariyerBasligi(
  KariyerDurumu durum,
  UygulamaMetinleri m,
  MeslekKatalogu katalog,
) =>
    switch (durum) {
      Ogrenci(:final hedef) => '${m.durumOgrenci} · ${hedef.ad(m)}',
      Calisan(:final meslekId, :final kademeIndeksi) =>
        _calisanBasligi(meslekId, kademeIndeksi, katalog),
      Issiz(:final atamaBekliyor) =>
        atamaBekliyor ? m.durumAtamaBekliyor : m.durumIssiz,
      Askerlik(:final bedelli) =>
        bedelli ? m.durumBedelli : m.durumAskerlik,
      Emekli() => m.durumEmekli,
    };

String _calisanBasligi(
  String meslekId,
  int kademeIndeksi,
  MeslekKatalogu katalog,
) {
  final meslek = katalog.bul(meslekId);
  if (meslek == null) return meslekId;
  final kademe = kademeIndeksi < meslek.kademeler.length
      ? meslek.kademeler[kademeIndeksi]
      : null;
  return kademe == null ? meslek.ad : '${meslek.ad} · ${kademe.ad}';
}

/// Geri sayımlı durumlarda kalan tur; süresiz durumlarda null.
int? kalanTur(KariyerDurumu durum) => switch (durum) {
      Ogrenci(:final kalanTur) => kalanTur,
      Askerlik(:final kalanTur) => kalanTur,
      _ => null,
    };
