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

  /// No description provided for @sekmeYakinda.
  ///
  /// In tr, this message translates to:
  /// **'Bu ekran henüz yazılmadı.'**
  String get sekmeYakinda;

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
