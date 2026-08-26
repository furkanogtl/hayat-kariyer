import '../core/engine/borc_motoru.dart';
import '../core/engine/isletme_motoru.dart';
import '../core/engine/rejim.dart';
import '../core/engine/skor.dart';
import '../core/models/borc.dart';
import '../core/models/egitim_seviyesi.dart';
import '../core/models/kariyer_durumu.dart';
import '../core/models/meslek_katalogu.dart';
import '../core/models/olay.dart';
import '../core/models/sehir.dart';
import '../core/models/sektor.dart';
import '../core/models/varlik.dart';
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

extension OlayTuruEtiketi on OlayTuru {
  String ad(UygulamaMetinleri m) => switch (this) {
        OlayTuru.firsat => m.kartTuruFirsat,
        OlayTuru.kriz => m.kartTuruKriz,
        OlayTuru.teklif => m.kartTuruTeklif,
        OlayTuru.hayat => m.kartTuruHayat,
      };
}

/// Varlık kimliği -> ekran adı.
///
/// Varlıklar VERİ DEĞİL KOD (`piyasaVarliklari` sabiti), o yüzden adları
/// ARB'de. Tanımsız kimlik gelirse kimliğin kendisi gösteriliyor: yeni
/// varlık eklenip metni unutulursa ekran boş kalmasın.
String varlikAdi(UygulamaMetinleri m, String varlikId) => switch (varlikId) {
      'mevduat' => m.varlikMevduat,
      'altin' => m.varlikAltin,
      'doviz' => m.varlikDoviz,
      'gayrimenkul' => m.varlikGayrimenkul,
      'arsa' => m.varlikArsa,
      'kripto' => m.varlikKripto,
      'hisse_bankacilik' => m.varlikHisseBankacilik,
      'hisse_sanayi' => m.varlikHisseSanayi,
      'hisse_teknoloji' => m.varlikHisseTeknoloji,
      'hisse_gida' => m.varlikHisseGida,
      'hisse_insaat' => m.varlikHisseInsaat,
      'hisse_enerji' => m.varlikHisseEnerji,
      _ => varlikId,
    };

extension VarlikTuruEtiketi on VarlikTuru {
  String ad(UygulamaMetinleri m) => switch (this) {
        VarlikTuru.mevduat => m.turMevduat,
        VarlikTuru.altin => m.turAltin,
        VarlikTuru.hisse => m.turHisse,
        VarlikTuru.doviz => m.turDoviz,
        VarlikTuru.gayrimenkul => m.turGayrimenkul,
        VarlikTuru.arsa => m.turArsa,
        VarlikTuru.kripto => m.turKripto,
      };

  /// Alım satımda kullanılan birim. "1 adet daire" yerine "1 daire".
  String birim(UygulamaMetinleri m) => switch (this) {
        VarlikTuru.altin => m.birimGram,
        VarlikTuru.hisse => m.birimLot,
        VarlikTuru.doviz => m.birimDolar,
        VarlikTuru.gayrimenkul => m.birimDaire,
        VarlikTuru.arsa => m.birimParsel,
        VarlikTuru.mevduat => m.birimAdet,
        VarlikTuru.kripto => m.birimAdet,
      };
}

extension BorcTuruEtiketi on BorcTuru {
  String ad(UygulamaMetinleri m) => switch (this) {
        BorcTuru.ihtiyac => m.borcTuruIhtiyac,
        BorcTuru.tasit => m.borcTuruTasit,
        BorcTuru.konut => m.borcTuruKonut,
        BorcTuru.kartBorcu => m.borcTuruKartBorcu,
      };
}

extension UnvanEtiketi on OyunSonuUnvani {
  String ad(UygulamaMetinleri m) => switch (this) {
        OyunSonuUnvani.ucuUcuna => m.unvanZorGecen,
        OyunSonuUnvani.dipteDonen => m.unvanSerefliIflas,
        OyunSonuUnvani.orta => m.unvanOrta,
        OyunSonuUnvani.rahat => m.unvanRahat,
        OyunSonuUnvani.zengin => m.unvanZengin,
        OyunSonuUnvani.imparator => m.unvanImparator,
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

/// Reddedilen kredinin sebebi.
///
/// Motor bunu üretiyordu ama hiçbir ekran göstermiyordu: oyuncunun kredisi
/// sessizce düşüyor, düğme çalışmıyor gibi görünüyordu.
extension KrediHatasiEtiketi on KrediHatasi {
  String ad(UygulamaMetinleri m) => switch (this) {
        KrediHatasi.krediNotuYetersiz => m.krediHatasiNotYetersiz,
        KrediHatasi.limitAsildi => m.krediHatasiLimitAsildi,
        KrediHatasi.taksitGeliriAsiyor => m.krediHatasiTaksitGeliriAsiyor,
        KrediHatasi.gecersizTutar => m.krediHatasiGecersizTutar,
        KrediHatasi.gecikmedeKrediVerilmez => m.krediHatasiGecikmede,
        KrediHatasi.krediYasagi => m.krediHatasiYasak,
      };
}

/// Uygulanamayan işletme komutunun sebebi.
extension IsletmeHatasiEtiketi on IsletmeHatasi {
  String ad(UygulamaMetinleri m) => switch (this) {
        IsletmeHatasi.tanimsizIsletme => m.isletmeHatasiTanimsiz,
        IsletmeHatasi.sartlarTutmuyor => m.isletmeHatasiSartlar,
        IsletmeHatasi.yetersizNakit => m.isletmeHatasiNakit,
      };
}
