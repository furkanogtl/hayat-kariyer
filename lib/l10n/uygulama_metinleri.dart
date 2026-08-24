import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'uygulama_metinleri_en.dart';
import 'uygulama_metinleri_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of UygulamaMetinleri
/// returned by `UygulamaMetinleri.of(context)`.
///
/// Applications need to include `UygulamaMetinleri.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/uygulama_metinleri.dart';
///
/// return MaterialApp(
///   localizationsDelegates: UygulamaMetinleri.localizationsDelegates,
///   supportedLocales: UygulamaMetinleri.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the UygulamaMetinleri.supportedLocales
/// property.
abstract class UygulamaMetinleri {
  UygulamaMetinleri(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static UygulamaMetinleri of(BuildContext context) {
    return Localizations.of<UygulamaMetinleri>(context, UygulamaMetinleri)!;
  }

  static const LocalizationsDelegate<UygulamaMetinleri> delegate =
      _UygulamaMetinleriDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @uygulamaAdi.
  ///
  /// In tr, this message translates to:
  /// **'Hayat & Kariyer'**
  String get uygulamaAdi;

  /// No description provided for @yasalUyari.
  ///
  /// In tr, this message translates to:
  /// **'Bu bir oyundur, yatırım tavsiyesi değildir.'**
  String get yasalUyari;

  /// No description provided for @yeniOyun.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Oyun'**
  String get yeniOyun;

  /// No description provided for @oyunaBasla.
  ///
  /// In tr, this message translates to:
  /// **'Hayata Başla'**
  String get oyunaBasla;

  /// No description provided for @adinNe.
  ///
  /// In tr, this message translates to:
  /// **'Adın'**
  String get adinNe;

  /// No description provided for @adVarsayilan.
  ///
  /// In tr, this message translates to:
  /// **'Oyuncu'**
  String get adVarsayilan;

  /// No description provided for @cinsiyet.
  ///
  /// In tr, this message translates to:
  /// **'Cinsiyet'**
  String get cinsiyet;

  /// No description provided for @cinsiyetErkek.
  ///
  /// In tr, this message translates to:
  /// **'Erkek'**
  String get cinsiyetErkek;

  /// No description provided for @cinsiyetKadin.
  ///
  /// In tr, this message translates to:
  /// **'Kadın'**
  String get cinsiyetKadin;

  /// No description provided for @sehir.
  ///
  /// In tr, this message translates to:
  /// **'Şehir'**
  String get sehir;

  /// No description provided for @sehirIstanbul.
  ///
  /// In tr, this message translates to:
  /// **'İstanbul'**
  String get sehirIstanbul;

  /// No description provided for @sehirIzmir.
  ///
  /// In tr, this message translates to:
  /// **'İzmir'**
  String get sehirIzmir;

  /// No description provided for @sehirGaziantep.
  ///
  /// In tr, this message translates to:
  /// **'Gaziantep'**
  String get sehirGaziantep;

  /// No description provided for @sehirTrabzon.
  ///
  /// In tr, this message translates to:
  /// **'Trabzon'**
  String get sehirTrabzon;

  /// No description provided for @sehirKonya.
  ///
  /// In tr, this message translates to:
  /// **'Konya'**
  String get sehirKonya;

  /// No description provided for @giderCarpani.
  ///
  /// In tr, this message translates to:
  /// **'Yaşam gideri ×{carpan}'**
  String giderCarpani(String carpan);

  /// No description provided for @egitim.
  ///
  /// In tr, this message translates to:
  /// **'Eğitim'**
  String get egitim;

  /// No description provided for @egitimIlkogretim.
  ///
  /// In tr, this message translates to:
  /// **'İlköğretim'**
  String get egitimIlkogretim;

  /// No description provided for @egitimLise.
  ///
  /// In tr, this message translates to:
  /// **'Lise'**
  String get egitimLise;

  /// No description provided for @egitimOnlisans.
  ///
  /// In tr, this message translates to:
  /// **'Ön lisans'**
  String get egitimOnlisans;

  /// No description provided for @egitimLisans.
  ///
  /// In tr, this message translates to:
  /// **'Lisans'**
  String get egitimLisans;

  /// No description provided for @egitimYuksekLisans.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek lisans'**
  String get egitimYuksekLisans;

  /// No description provided for @egitimDoktora.
  ///
  /// In tr, this message translates to:
  /// **'Doktora'**
  String get egitimDoktora;

  /// No description provided for @sekmeOzet.
  ///
  /// In tr, this message translates to:
  /// **'Özet'**
  String get sekmeOzet;

  /// No description provided for @sekmePiyasa.
  ///
  /// In tr, this message translates to:
  /// **'Piyasa'**
  String get sekmePiyasa;

  /// No description provided for @sekmeBanka.
  ///
  /// In tr, this message translates to:
  /// **'Banka'**
  String get sekmeBanka;

  /// No description provided for @sekmeKariyer.
  ///
  /// In tr, this message translates to:
  /// **'Kariyer'**
  String get sekmeKariyer;

  /// No description provided for @sekmeIsletme.
  ///
  /// In tr, this message translates to:
  /// **'İşletme'**
  String get sekmeIsletme;

  /// No description provided for @nakit.
  ///
  /// In tr, this message translates to:
  /// **'Nakit'**
  String get nakit;

  /// No description provided for @netDeger.
  ///
  /// In tr, this message translates to:
  /// **'Net Değer'**
  String get netDeger;

  /// No description provided for @reelNetDeger.
  ///
  /// In tr, this message translates to:
  /// **'Reel net değer'**
  String get reelNetDeger;

  /// No description provided for @enerji.
  ///
  /// In tr, this message translates to:
  /// **'Enerji'**
  String get enerji;

  /// No description provided for @mutluluk.
  ///
  /// In tr, this message translates to:
  /// **'Mutluluk'**
  String get mutluluk;

  /// No description provided for @itibar.
  ///
  /// In tr, this message translates to:
  /// **'İtibar'**
  String get itibar;

  /// No description provided for @krediNotu.
  ///
  /// In tr, this message translates to:
  /// **'Kredi notu'**
  String get krediNotu;

  /// No description provided for @yetkinlik.
  ///
  /// In tr, this message translates to:
  /// **'Yetkinlik'**
  String get yetkinlik;

  /// No description provided for @borc.
  ///
  /// In tr, this message translates to:
  /// **'Borç'**
  String get borc;

  /// No description provided for @taksitYuku.
  ///
  /// In tr, this message translates to:
  /// **'Aylık taksit'**
  String get taksitYuku;

  /// No description provided for @yasBilgisi.
  ///
  /// In tr, this message translates to:
  /// **'{yas} yaşında'**
  String yasBilgisi(int yas);

  /// No description provided for @turBilgisi.
  ///
  /// In tr, this message translates to:
  /// **'{ay} {yil}. yıl'**
  String turBilgisi(String ay, int yil);

  /// No description provided for @ayOcak.
  ///
  /// In tr, this message translates to:
  /// **'Ocak'**
  String get ayOcak;

  /// No description provided for @aySubat.
  ///
  /// In tr, this message translates to:
  /// **'Şubat'**
  String get aySubat;

  /// No description provided for @ayMart.
  ///
  /// In tr, this message translates to:
  /// **'Mart'**
  String get ayMart;

  /// No description provided for @ayNisan.
  ///
  /// In tr, this message translates to:
  /// **'Nisan'**
  String get ayNisan;

  /// No description provided for @ayMayis.
  ///
  /// In tr, this message translates to:
  /// **'Mayıs'**
  String get ayMayis;

  /// No description provided for @ayHaziran.
  ///
  /// In tr, this message translates to:
  /// **'Haziran'**
  String get ayHaziran;

  /// No description provided for @ayTemmuz.
  ///
  /// In tr, this message translates to:
  /// **'Temmuz'**
  String get ayTemmuz;

  /// No description provided for @ayAgustos.
  ///
  /// In tr, this message translates to:
  /// **'Ağustos'**
  String get ayAgustos;

  /// No description provided for @ayEylul.
  ///
  /// In tr, this message translates to:
  /// **'Eylül'**
  String get ayEylul;

  /// No description provided for @ayEkim.
  ///
  /// In tr, this message translates to:
  /// **'Ekim'**
  String get ayEkim;

  /// No description provided for @ayKasim.
  ///
  /// In tr, this message translates to:
  /// **'Kasım'**
  String get ayKasim;

  /// No description provided for @ayAralik.
  ///
  /// In tr, this message translates to:
  /// **'Aralık'**
  String get ayAralik;

  /// No description provided for @rejimBuyume.
  ///
  /// In tr, this message translates to:
  /// **'Büyüme'**
  String get rejimBuyume;

  /// No description provided for @rejimDurgunluk.
  ///
  /// In tr, this message translates to:
  /// **'Durgunluk'**
  String get rejimDurgunluk;

  /// No description provided for @rejimKriz.
  ///
  /// In tr, this message translates to:
  /// **'Kriz'**
  String get rejimKriz;

  /// No description provided for @rejimEnflasyon.
  ///
  /// In tr, this message translates to:
  /// **'Enflasyon'**
  String get rejimEnflasyon;

  /// No description provided for @ekonomi.
  ///
  /// In tr, this message translates to:
  /// **'Ekonomi'**
  String get ekonomi;

  /// No description provided for @rejim.
  ///
  /// In tr, this message translates to:
  /// **'Dönem'**
  String get rejim;

  /// No description provided for @yillikEnflasyon.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık enflasyon'**
  String get yillikEnflasyon;

  /// No description provided for @alimGucuKaybi.
  ///
  /// In tr, this message translates to:
  /// **'Maaşın {oran} geride'**
  String alimGucuKaybi(String oran);

  /// No description provided for @durumOgrenci.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci'**
  String get durumOgrenci;

  /// No description provided for @durumIssiz.
  ///
  /// In tr, this message translates to:
  /// **'İşsiz'**
  String get durumIssiz;

  /// No description provided for @durumAtamaBekliyor.
  ///
  /// In tr, this message translates to:
  /// **'Atama bekliyor'**
  String get durumAtamaBekliyor;

  /// No description provided for @durumAskerlik.
  ///
  /// In tr, this message translates to:
  /// **'Askerlik'**
  String get durumAskerlik;

  /// No description provided for @durumBedelli.
  ///
  /// In tr, this message translates to:
  /// **'Bedelli askerlik'**
  String get durumBedelli;

  /// No description provided for @durumEmekli.
  ///
  /// In tr, this message translates to:
  /// **'Emekli'**
  String get durumEmekli;

  /// No description provided for @kalanTur.
  ///
  /// In tr, this message translates to:
  /// **'{tur} tur kaldı'**
  String kalanTur(int tur);

  /// No description provided for @zamanDagilimi.
  ///
  /// In tr, this message translates to:
  /// **'Bu ay ne yapacaksın?'**
  String get zamanDagilimi;

  /// No description provided for @zamanCalisma.
  ///
  /// In tr, this message translates to:
  /// **'Çalış'**
  String get zamanCalisma;

  /// No description provided for @zamanEgitim.
  ///
  /// In tr, this message translates to:
  /// **'Eğitim'**
  String get zamanEgitim;

  /// No description provided for @zamanNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Network'**
  String get zamanNetwork;

  /// No description provided for @zamanDinlenme.
  ///
  /// In tr, this message translates to:
  /// **'Dinlen'**
  String get zamanDinlenme;

  /// No description provided for @kalanPuan.
  ///
  /// In tr, this message translates to:
  /// **'{puan} puan boşta'**
  String kalanPuan(int puan);

  /// No description provided for @dagilimDengeli.
  ///
  /// In tr, this message translates to:
  /// **'Dengeli'**
  String get dagilimDengeli;

  /// No description provided for @dagilimTamMesai.
  ///
  /// In tr, this message translates to:
  /// **'Tam mesai'**
  String get dagilimTamMesai;

  /// No description provided for @turuBitir.
  ///
  /// In tr, this message translates to:
  /// **'Turu Bitir'**
  String get turuBitir;

  /// No description provided for @ucAyAtla.
  ///
  /// In tr, this message translates to:
  /// **'3 ay atla'**
  String get ucAyAtla;

  /// No description provided for @birYilAtla.
  ///
  /// In tr, this message translates to:
  /// **'1 yıl atla'**
  String get birYilAtla;

  /// No description provided for @turRaporu.
  ///
  /// In tr, this message translates to:
  /// **'{ay} raporu'**
  String turRaporu(String ay);

  /// No description provided for @atlananTur.
  ///
  /// In tr, this message translates to:
  /// **'{sayi} ay geçildi'**
  String atlananTur(int sayi);

  /// No description provided for @raporGelir.
  ///
  /// In tr, this message translates to:
  /// **'Gelir'**
  String get raporGelir;

  /// No description provided for @raporYasamGideri.
  ///
  /// In tr, this message translates to:
  /// **'Yaşam gideri'**
  String get raporYasamGideri;

  /// No description provided for @raporTaksit.
  ///
  /// In tr, this message translates to:
  /// **'Kredi taksiti'**
  String get raporTaksit;

  /// No description provided for @raporFaiz.
  ///
  /// In tr, this message translates to:
  /// **'Eksi bakiye faizi'**
  String get raporFaiz;

  /// No description provided for @raporKira.
  ///
  /// In tr, this message translates to:
  /// **'Kira ve temettü'**
  String get raporKira;

  /// No description provided for @raporIsletme.
  ///
  /// In tr, this message translates to:
  /// **'İşletme kârı'**
  String get raporIsletme;

  /// No description provided for @raporNakitDegisimi.
  ///
  /// In tr, this message translates to:
  /// **'Aylık bakiye'**
  String get raporNakitDegisimi;

  /// No description provided for @kapat.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get kapat;

  /// No description provided for @devam.
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get devam;

  /// No description provided for @olayTerfi.
  ///
  /// In tr, this message translates to:
  /// **'Terfi ettin: {kademe}'**
  String olayTerfi(String kademe);

  /// No description provided for @olayIstenCikarildi.
  ///
  /// In tr, this message translates to:
  /// **'İşten çıkarıldın.'**
  String get olayIstenCikarildi;

  /// No description provided for @olayMezunOldu.
  ///
  /// In tr, this message translates to:
  /// **'Mezun oldun.'**
  String get olayMezunOldu;

  /// No description provided for @olayAskerlikBitti.
  ///
  /// In tr, this message translates to:
  /// **'Terhis oldun.'**
  String get olayAskerlikBitti;

  /// No description provided for @olayCelpGeldi.
  ///
  /// In tr, this message translates to:
  /// **'Askerlik tebligatın geldi.'**
  String get olayCelpGeldi;

  /// No description provided for @olayAskereAlindi.
  ///
  /// In tr, this message translates to:
  /// **'Askere alındın.'**
  String get olayAskereAlindi;

  /// No description provided for @olayAtamasiCikti.
  ///
  /// In tr, this message translates to:
  /// **'Ataman çıktı.'**
  String get olayAtamasiCikti;

  /// No description provided for @olayMaasZammi.
  ///
  /// In tr, this message translates to:
  /// **'Maaşlara zam yapıldı.'**
  String get olayMaasZammi;

  /// No description provided for @olayParaReformu.
  ///
  /// In tr, this message translates to:
  /// **'Paradan üç sıfır atıldı.'**
  String get olayParaReformu;

  /// No description provided for @olayRejimDegisti.
  ///
  /// In tr, this message translates to:
  /// **'Ekonomi {rejim} dönemine girdi.'**
  String olayRejimDegisti(String rejim);

  /// No description provided for @olayIsletmeKrizi.
  ///
  /// In tr, this message translates to:
  /// **'{isletme} ilgi bekliyor.'**
  String olayIsletmeKrizi(String isletme);

  /// No description provided for @acikPozisyonlar.
  ///
  /// In tr, this message translates to:
  /// **'Girebileceğin işler'**
  String get acikPozisyonlar;

  /// No description provided for @uygunIsYok.
  ///
  /// In tr, this message translates to:
  /// **'Şu an girebileceğin bir iş yok. Eğitim ve yetkinlik kapıları açıldıkça burası dolar.'**
  String get uygunIsYok;

  /// No description provided for @basvur.
  ///
  /// In tr, this message translates to:
  /// **'Bu işe gir'**
  String get basvur;

  /// No description provided for @vazgec.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get vazgec;

  /// No description provided for @basvuruYapildi.
  ///
  /// In tr, this message translates to:
  /// **'{meslek} işine başladın sayılır: turu bitirince göreve başlıyorsun.'**
  String basvuruYapildi(String meslek);

  /// No description provided for @baslangicMaasi.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç {tutar}'**
  String baslangicMaasi(String tutar);

  /// No description provided for @kademeSayisi.
  ///
  /// In tr, this message translates to:
  /// **'{sayi} kademe'**
  String kademeSayisi(int sayi);

  /// No description provided for @kariyerMerdiveni.
  ///
  /// In tr, this message translates to:
  /// **'Kariyer merdiveni'**
  String get kariyerMerdiveni;

  /// No description provided for @yetkinlikler.
  ///
  /// In tr, this message translates to:
  /// **'Yetkinlikler'**
  String get yetkinlikler;

  /// No description provided for @sektorSaglik.
  ///
  /// In tr, this message translates to:
  /// **'Sağlık'**
  String get sektorSaglik;

  /// No description provided for @sektorTeknoloji.
  ///
  /// In tr, this message translates to:
  /// **'Teknoloji'**
  String get sektorTeknoloji;

  /// No description provided for @sektorHukukKamu.
  ///
  /// In tr, this message translates to:
  /// **'Hukuk ve kamu'**
  String get sektorHukukKamu;

  /// No description provided for @sektorFinans.
  ///
  /// In tr, this message translates to:
  /// **'Finans'**
  String get sektorFinans;

  /// No description provided for @sektorTicaret.
  ///
  /// In tr, this message translates to:
  /// **'Ticaret'**
  String get sektorTicaret;

  /// No description provided for @sektorEsnaf.
  ///
  /// In tr, this message translates to:
  /// **'Esnaf'**
  String get sektorEsnaf;

  /// No description provided for @sektorMedya.
  ///
  /// In tr, this message translates to:
  /// **'Medya'**
  String get sektorMedya;

  /// No description provided for @sektorLojistik.
  ///
  /// In tr, this message translates to:
  /// **'Lojistik'**
  String get sektorLojistik;

  /// No description provided for @sektorTarim.
  ///
  /// In tr, this message translates to:
  /// **'Tarım'**
  String get sektorTarim;

  /// No description provided for @sektorTurizm.
  ///
  /// In tr, this message translates to:
  /// **'Turizm'**
  String get sektorTurizm;

  /// No description provided for @sartEgitim.
  ///
  /// In tr, this message translates to:
  /// **'En az {seviye}'**
  String sartEgitim(String seviye);

  /// No description provided for @sartYetkinlik.
  ///
  /// In tr, this message translates to:
  /// **'{sektor} yetkinliği {deger}'**
  String sartYetkinlik(String sektor, int deger);

  /// No description provided for @sartYas.
  ///
  /// In tr, this message translates to:
  /// **'{enAz}-{enCok} yaş'**
  String sartYas(int enAz, int enCok);

  /// No description provided for @kararBekliyor.
  ///
  /// In tr, this message translates to:
  /// **'{sayi} karar bekliyor'**
  String kararBekliyor(int sayi);

  /// No description provided for @kararlariGor.
  ///
  /// In tr, this message translates to:
  /// **'Kararı ver'**
  String get kararlariGor;

  /// No description provided for @kartTuruFirsat.
  ///
  /// In tr, this message translates to:
  /// **'Fırsat'**
  String get kartTuruFirsat;

  /// No description provided for @kartTuruKriz.
  ///
  /// In tr, this message translates to:
  /// **'Kriz'**
  String get kartTuruKriz;

  /// No description provided for @kartTuruTeklif.
  ///
  /// In tr, this message translates to:
  /// **'Teklif'**
  String get kartTuruTeklif;

  /// No description provided for @kartTuruHayat.
  ///
  /// In tr, this message translates to:
  /// **'Hayat'**
  String get kartTuruHayat;

  /// No description provided for @sonucBekliyor.
  ///
  /// In tr, this message translates to:
  /// **'Sonucu {tur} ay sonra belli olacak.'**
  String sonucBekliyor(int tur);

  /// No description provided for @gecmisKararlar.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş kararların'**
  String get gecmisKararlar;

  /// No description provided for @kartKaldi.
  ///
  /// In tr, this message translates to:
  /// **'{sayi} kart daha var'**
  String kartKaldi(int sayi);

  /// No description provided for @kararVermedenTurBitmez.
  ///
  /// In tr, this message translates to:
  /// **'Önce bekleyen kararı ver.'**
  String get kararVermedenTurBitmez;

  /// No description provided for @portfoy.
  ///
  /// In tr, this message translates to:
  /// **'Portföy'**
  String get portfoy;

  /// No description provided for @portfoyBos.
  ///
  /// In tr, this message translates to:
  /// **'Henüz yatırımın yok. Nakit tutmak enflasyona karşı kaybettirir.'**
  String get portfoyBos;

  /// No description provided for @portfoyDegeri.
  ///
  /// In tr, this message translates to:
  /// **'Portföy değeri'**
  String get portfoyDegeri;

  /// No description provided for @reelKarZarar.
  ///
  /// In tr, this message translates to:
  /// **'Reel kâr/zarar'**
  String get reelKarZarar;

  /// No description provided for @karZarar.
  ///
  /// In tr, this message translates to:
  /// **'Kâr/zarar'**
  String get karZarar;

  /// No description provided for @maliyet.
  ///
  /// In tr, this message translates to:
  /// **'Maliyet'**
  String get maliyet;

  /// No description provided for @satista.
  ///
  /// In tr, this message translates to:
  /// **'Satışta'**
  String get satista;

  /// No description provided for @satisTamamlanir.
  ///
  /// In tr, this message translates to:
  /// **'{tur} tur sonra'**
  String satisTamamlanir(int tur);

  /// No description provided for @varliklar.
  ///
  /// In tr, this message translates to:
  /// **'Yatırım araçları'**
  String get varliklar;

  /// No description provided for @birimFiyat.
  ///
  /// In tr, this message translates to:
  /// **'Birim fiyat'**
  String get birimFiyat;

  /// No description provided for @yillikDegisim.
  ///
  /// In tr, this message translates to:
  /// **'12 ay reel'**
  String get yillikDegisim;

  /// No description provided for @veriYok.
  ///
  /// In tr, this message translates to:
  /// **'—'**
  String get veriYok;

  /// No description provided for @al.
  ///
  /// In tr, this message translates to:
  /// **'Al'**
  String get al;

  /// No description provided for @sat.
  ///
  /// In tr, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @adet.
  ///
  /// In tr, this message translates to:
  /// **'Adet'**
  String get adet;

  /// No description provided for @tumu.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get tumu;

  /// No description provided for @toplamTutar.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get toplamTutar;

  /// No description provided for @komisyon.
  ///
  /// In tr, this message translates to:
  /// **'Komisyon'**
  String get komisyon;

  /// No description provided for @emirSiraya.
  ///
  /// In tr, this message translates to:
  /// **'Emir sıraya alındı'**
  String get emirSiraya;

  /// No description provided for @bekleyenEmirler.
  ///
  /// In tr, this message translates to:
  /// **'Bekleyen emirler'**
  String get bekleyenEmirler;

  /// No description provided for @emirAlim.
  ///
  /// In tr, this message translates to:
  /// **'{adet} {birim} al'**
  String emirAlim(String adet, String birim);

  /// No description provided for @emirSatim.
  ///
  /// In tr, this message translates to:
  /// **'{adet} {birim} sat'**
  String emirSatim(String adet, String birim);

  /// No description provided for @emirNotu.
  ///
  /// In tr, this message translates to:
  /// **'Emirler tur bitince, ekranda gördüğün fiyattan işlenir.'**
  String get emirNotu;

  /// No description provided for @satisGecikmesi.
  ///
  /// In tr, this message translates to:
  /// **'Satış {tur} tur sürer; fiyat riski sende kalır.'**
  String satisGecikmesi(int tur);

  /// No description provided for @bolunemez.
  ///
  /// In tr, this message translates to:
  /// **'Tam sayı alınır.'**
  String get bolunemez;

  /// No description provided for @grafikBasligi.
  ///
  /// In tr, this message translates to:
  /// **'Reel fiyat (son {tur} ay)'**
  String grafikBasligi(int tur);

  /// No description provided for @birimGram.
  ///
  /// In tr, this message translates to:
  /// **'gram'**
  String get birimGram;

  /// No description provided for @birimLot.
  ///
  /// In tr, this message translates to:
  /// **'lot'**
  String get birimLot;

  /// No description provided for @birimAdet.
  ///
  /// In tr, this message translates to:
  /// **'adet'**
  String get birimAdet;

  /// No description provided for @birimDolar.
  ///
  /// In tr, this message translates to:
  /// **'USD'**
  String get birimDolar;

  /// No description provided for @birimDaire.
  ///
  /// In tr, this message translates to:
  /// **'daire'**
  String get birimDaire;

  /// No description provided for @birimParsel.
  ///
  /// In tr, this message translates to:
  /// **'parsel'**
  String get birimParsel;

  /// No description provided for @varlikMevduat.
  ///
  /// In tr, this message translates to:
  /// **'Mevduat'**
  String get varlikMevduat;

  /// No description provided for @varlikAltin.
  ///
  /// In tr, this message translates to:
  /// **'Altın'**
  String get varlikAltin;

  /// No description provided for @varlikDoviz.
  ///
  /// In tr, this message translates to:
  /// **'Döviz'**
  String get varlikDoviz;

  /// No description provided for @varlikGayrimenkul.
  ///
  /// In tr, this message translates to:
  /// **'Daire'**
  String get varlikGayrimenkul;

  /// No description provided for @varlikArsa.
  ///
  /// In tr, this message translates to:
  /// **'Arsa'**
  String get varlikArsa;

  /// No description provided for @varlikKripto.
  ///
  /// In tr, this message translates to:
  /// **'Kripto'**
  String get varlikKripto;

  /// No description provided for @varlikHisseBankacilik.
  ///
  /// In tr, this message translates to:
  /// **'Bankacılık'**
  String get varlikHisseBankacilik;

  /// No description provided for @varlikHisseSanayi.
  ///
  /// In tr, this message translates to:
  /// **'Sanayi'**
  String get varlikHisseSanayi;

  /// No description provided for @varlikHisseTeknoloji.
  ///
  /// In tr, this message translates to:
  /// **'Teknoloji'**
  String get varlikHisseTeknoloji;

  /// No description provided for @varlikHisseGida.
  ///
  /// In tr, this message translates to:
  /// **'Gıda'**
  String get varlikHisseGida;

  /// No description provided for @varlikHisseInsaat.
  ///
  /// In tr, this message translates to:
  /// **'İnşaat'**
  String get varlikHisseInsaat;

  /// No description provided for @varlikHisseEnerji.
  ///
  /// In tr, this message translates to:
  /// **'Enerji'**
  String get varlikHisseEnerji;

  /// No description provided for @turMevduat.
  ///
  /// In tr, this message translates to:
  /// **'Mevduat'**
  String get turMevduat;

  /// No description provided for @turAltin.
  ///
  /// In tr, this message translates to:
  /// **'Kıymetli maden'**
  String get turAltin;

  /// No description provided for @turHisse.
  ///
  /// In tr, this message translates to:
  /// **'Borsa'**
  String get turHisse;

  /// No description provided for @turDoviz.
  ///
  /// In tr, this message translates to:
  /// **'Döviz'**
  String get turDoviz;

  /// No description provided for @turGayrimenkul.
  ///
  /// In tr, this message translates to:
  /// **'Gayrimenkul'**
  String get turGayrimenkul;

  /// No description provided for @turArsa.
  ///
  /// In tr, this message translates to:
  /// **'Arsa'**
  String get turArsa;

  /// No description provided for @turKripto.
  ///
  /// In tr, this message translates to:
  /// **'Kripto'**
  String get turKripto;

  /// No description provided for @isletmelerim.
  ///
  /// In tr, this message translates to:
  /// **'İşletmelerim'**
  String get isletmelerim;

  /// No description provided for @isletmeYok.
  ///
  /// In tr, this message translates to:
  /// **'Henüz işletmen yok. İşletme borsayı yener ama ilgi ister.'**
  String get isletmeYok;

  /// No description provided for @isletmeAc.
  ///
  /// In tr, this message translates to:
  /// **'İşletme aç'**
  String get isletmeAc;

  /// No description provided for @acilabilirIsletmeler.
  ///
  /// In tr, this message translates to:
  /// **'Açabileceğin işletmeler'**
  String get acilabilirIsletmeler;

  /// No description provided for @acilabilirYok.
  ///
  /// In tr, this message translates to:
  /// **'Şu an açabileceğin işletme yok. Yetkinlik, itibar ve sermaye gerekiyor.'**
  String get acilabilirYok;

  /// No description provided for @kurulusBedeli.
  ///
  /// In tr, this message translates to:
  /// **'Kuruluş bedeli'**
  String get kurulusBedeli;

  /// No description provided for @ilgiPuani.
  ///
  /// In tr, this message translates to:
  /// **'İlgi puanı'**
  String get ilgiPuani;

  /// No description provided for @ilgiDagilimi.
  ///
  /// In tr, this message translates to:
  /// **'İlgi dağılımı'**
  String get ilgiDagilimi;

  /// No description provided for @ilgiKalan.
  ///
  /// In tr, this message translates to:
  /// **'{puan} puan boşta'**
  String ilgiKalan(int puan);

  /// No description provided for @ilgiYeterli.
  ///
  /// In tr, this message translates to:
  /// **'Tam ilgi'**
  String get ilgiYeterli;

  /// No description provided for @ilgiKismi.
  ///
  /// In tr, this message translates to:
  /// **'Yarım ilgi: gerileme başlıyor'**
  String get ilgiKismi;

  /// No description provided for @ilgiYok.
  ///
  /// In tr, this message translates to:
  /// **'İhmal: işletme çöküyor'**
  String get ilgiYok;

  /// No description provided for @aylikKar.
  ///
  /// In tr, this message translates to:
  /// **'Aylık kâr'**
  String get aylikKar;

  /// No description provided for @yillikKar.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık kâr'**
  String get yillikKar;

  /// No description provided for @isletmeDegeri.
  ///
  /// In tr, this message translates to:
  /// **'Devir değeri'**
  String get isletmeDegeri;

  /// No description provided for @ceo.
  ///
  /// In tr, this message translates to:
  /// **'Genel müdür'**
  String get ceo;

  /// No description provided for @ceoAta.
  ///
  /// In tr, this message translates to:
  /// **'Genel müdür ata'**
  String get ceoAta;

  /// No description provided for @ceoKaldir.
  ///
  /// In tr, this message translates to:
  /// **'Genel müdürü görevden al'**
  String get ceoKaldir;

  /// No description provided for @ceoAcikla.
  ///
  /// In tr, this message translates to:
  /// **'İlgi yükünü düşürür; bedeli maaş, daha düşük kâr ve zimmet riski.'**
  String get ceoAcikla;

  /// No description provided for @ceoMaasi.
  ///
  /// In tr, this message translates to:
  /// **'Aylık maaş'**
  String get ceoMaasi;

  /// No description provided for @isletmeSat.
  ///
  /// In tr, this message translates to:
  /// **'Satışa çıkar'**
  String get isletmeSat;

  /// No description provided for @isletmeSatista.
  ///
  /// In tr, this message translates to:
  /// **'Satışta · {tur} tur kaldı'**
  String isletmeSatista(int tur);

  /// No description provided for @isletmeSatUyari.
  ///
  /// In tr, this message translates to:
  /// **'Devir {tur} tur sürer. Zarar eden işletme enkaz bedeline gider.'**
  String isletmeSatUyari(int tur);

  /// No description provided for @isletmeKrizUyarisi.
  ///
  /// In tr, this message translates to:
  /// **'İhmal ediliyor: kriz kartı beklemelisin.'**
  String get isletmeKrizUyarisi;

  /// No description provided for @isletmeHataSartlar.
  ///
  /// In tr, this message translates to:
  /// **'Yetkinlik, itibar ya da yaş şartı tutmuyor.'**
  String get isletmeHataSartlar;

  /// No description provided for @isletmeHataNakit.
  ///
  /// In tr, this message translates to:
  /// **'Kuruluş bedeli için nakit yetmiyor.'**
  String get isletmeHataNakit;

  /// No description provided for @isletmeHataTanimsiz.
  ///
  /// In tr, this message translates to:
  /// **'Bu işletme tanınmıyor.'**
  String get isletmeHataTanimsiz;

  /// No description provided for @isletmeKomutBekliyor.
  ///
  /// In tr, this message translates to:
  /// **'Bu tur bir işletme kararı bekliyor.'**
  String get isletmeKomutBekliyor;

  /// No description provided for @sart.
  ///
  /// In tr, this message translates to:
  /// **'Şart'**
  String get sart;

  /// No description provided for @sartYetkinlikSektor.
  ///
  /// In tr, this message translates to:
  /// **'{sektor} yetkinliği {deger}'**
  String sartYetkinlikSektor(String sektor, int deger);

  /// No description provided for @sartItibar.
  ///
  /// In tr, this message translates to:
  /// **'İtibar {deger}'**
  String sartItibar(int deger);

  /// No description provided for @vazgecKomut.
  ///
  /// In tr, this message translates to:
  /// **'Kararı geri al'**
  String get vazgecKomut;

  /// No description provided for @borclarim.
  ///
  /// In tr, this message translates to:
  /// **'Borçlarım'**
  String get borclarim;

  /// No description provided for @borcYok.
  ///
  /// In tr, this message translates to:
  /// **'Borcun yok.'**
  String get borcYok;

  /// No description provided for @krediTeklifleri.
  ///
  /// In tr, this message translates to:
  /// **'Kredi teklifleri'**
  String get krediTeklifleri;

  /// No description provided for @krediYok.
  ///
  /// In tr, this message translates to:
  /// **'Şu an sana kredi verilmiyor. Düzenli gelir ve yeterli kredi notu gerekiyor.'**
  String get krediYok;

  /// No description provided for @borcTuruIhtiyac.
  ///
  /// In tr, this message translates to:
  /// **'İhtiyaç kredisi'**
  String get borcTuruIhtiyac;

  /// No description provided for @borcTuruTasit.
  ///
  /// In tr, this message translates to:
  /// **'Taşıt kredisi'**
  String get borcTuruTasit;

  /// No description provided for @borcTuruKonut.
  ///
  /// In tr, this message translates to:
  /// **'Konut kredisi'**
  String get borcTuruKonut;

  /// No description provided for @borcTuruKartBorcu.
  ///
  /// In tr, this message translates to:
  /// **'Kredi kartı borcu'**
  String get borcTuruKartBorcu;

  /// No description provided for @aylikFaiz.
  ///
  /// In tr, this message translates to:
  /// **'Aylık faiz'**
  String get aylikFaiz;

  /// No description provided for @vade.
  ///
  /// In tr, this message translates to:
  /// **'Vade'**
  String get vade;

  /// No description provided for @vadeAy.
  ///
  /// In tr, this message translates to:
  /// **'{ay} ay'**
  String vadeAy(int ay);

  /// No description provided for @enYuksekTutar.
  ///
  /// In tr, this message translates to:
  /// **'En yüksek tutar'**
  String get enYuksekTutar;

  /// No description provided for @kalanAnapara.
  ///
  /// In tr, this message translates to:
  /// **'Kalan anapara'**
  String get kalanAnapara;

  /// No description provided for @kalanTaksit.
  ///
  /// In tr, this message translates to:
  /// **'{sayi} taksit kaldı'**
  String kalanTaksit(int sayi);

  /// No description provided for @aylikTaksit.
  ///
  /// In tr, this message translates to:
  /// **'Aylık taksit'**
  String get aylikTaksit;

  /// No description provided for @toplamOdeme.
  ///
  /// In tr, this message translates to:
  /// **'Toplam geri ödeme'**
  String get toplamOdeme;

  /// No description provided for @krediCek.
  ///
  /// In tr, this message translates to:
  /// **'Krediyi çek'**
  String get krediCek;

  /// No description provided for @krediTutari.
  ///
  /// In tr, this message translates to:
  /// **'Kredi tutarı'**
  String get krediTutari;

  /// No description provided for @krediBekliyor.
  ///
  /// In tr, this message translates to:
  /// **'{tur} · {tutar} sıraya alındı'**
  String krediBekliyor(String tur, String tutar);

  /// No description provided for @gecikmede.
  ///
  /// In tr, this message translates to:
  /// **'Gecikmede'**
  String get gecikmede;

  /// No description provided for @takipte.
  ///
  /// In tr, this message translates to:
  /// **'İcra takibinde'**
  String get takipte;

  /// No description provided for @krediNotuOlcegi.
  ///
  /// In tr, this message translates to:
  /// **'{deger} / {tavan}'**
  String krediNotuOlcegi(int deger, int tavan);

  /// No description provided for @krediUyari.
  ///
  /// In tr, this message translates to:
  /// **'Taksit sabit kalır, enflasyon onu eritir. Ama gelirin keserse borç kalır.'**
  String get krediUyari;

  /// No description provided for @krediHataNot.
  ///
  /// In tr, this message translates to:
  /// **'Kredi notun yetersiz.'**
  String get krediHataNot;

  /// No description provided for @krediHataLimit.
  ///
  /// In tr, this message translates to:
  /// **'İstenen tutar limiti aşıyor.'**
  String get krediHataLimit;

  /// No description provided for @krediHataTaksit.
  ///
  /// In tr, this message translates to:
  /// **'Taksit gelirinin yarısını aşıyor.'**
  String get krediHataTaksit;

  /// No description provided for @krediHataTutar.
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz tutar.'**
  String get krediHataTutar;

  /// No description provided for @krediHataGecikme.
  ///
  /// In tr, this message translates to:
  /// **'Geciken borcun varken yeni kredi verilmez.'**
  String get krediHataGecikme;

  /// No description provided for @hataBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bir şeyler ters gitti'**
  String get hataBaslik;

  /// No description provided for @yukleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor…'**
  String get yukleniyor;
}

class _UygulamaMetinleriDelegate
    extends LocalizationsDelegate<UygulamaMetinleri> {
  const _UygulamaMetinleriDelegate();

  @override
  Future<UygulamaMetinleri> load(Locale locale) {
    return SynchronousFuture<UygulamaMetinleri>(
      lookupUygulamaMetinleri(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_UygulamaMetinleriDelegate old) => false;
}

UygulamaMetinleri lookupUygulamaMetinleri(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return UygulamaMetinleriEn();
    case 'tr':
      return UygulamaMetinleriTr();
  }

  throw FlutterError(
    'UygulamaMetinleri.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
