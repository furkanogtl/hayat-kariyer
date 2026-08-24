// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'uygulama_metinleri.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class UygulamaMetinleriEn extends UygulamaMetinleri {
  UygulamaMetinleriEn([String locale = 'en']) : super(locale);

  @override
  String get uygulamaAdi => 'Life & Career';

  @override
  String get yasalUyari => 'This is a game, not investment advice.';

  @override
  String get yeniOyun => 'New Game';

  @override
  String get oyunaBasla => 'Start Life';

  @override
  String get adinNe => 'Your name';

  @override
  String get adVarsayilan => 'Player';

  @override
  String get cinsiyet => 'Gender';

  @override
  String get cinsiyetErkek => 'Male';

  @override
  String get cinsiyetKadin => 'Female';

  @override
  String get sehir => 'City';

  @override
  String get sehirIstanbul => 'Istanbul';

  @override
  String get sehirIzmir => 'Izmir';

  @override
  String get sehirGaziantep => 'Gaziantep';

  @override
  String get sehirTrabzon => 'Trabzon';

  @override
  String get sehirKonya => 'Konya';

  @override
  String giderCarpani(String carpan) {
    return 'Cost of living ×$carpan';
  }

  @override
  String get egitim => 'Education';

  @override
  String get egitimIlkogretim => 'Primary';

  @override
  String get egitimLise => 'High school';

  @override
  String get egitimOnlisans => 'Associate';

  @override
  String get egitimLisans => 'Bachelor';

  @override
  String get egitimYuksekLisans => 'Master';

  @override
  String get egitimDoktora => 'PhD';

  @override
  String get sekmeOzet => 'Summary';

  @override
  String get sekmePiyasa => 'Market';

  @override
  String get sekmeKariyer => 'Career';

  @override
  String get sekmeIsletme => 'Business';

  @override
  String get sekmeYakinda => 'This screen is not built yet.';

  @override
  String get nakit => 'Cash';

  @override
  String get netDeger => 'Net Worth';

  @override
  String get reelNetDeger => 'Real net worth';

  @override
  String get enerji => 'Energy';

  @override
  String get mutluluk => 'Happiness';

  @override
  String get itibar => 'Reputation';

  @override
  String get krediNotu => 'Credit score';

  @override
  String get yetkinlik => 'Competence';

  @override
  String get borc => 'Debt';

  @override
  String get taksitYuku => 'Monthly instalment';

  @override
  String yasBilgisi(int yas) {
    return 'Age $yas';
  }

  @override
  String turBilgisi(String ay, int yil) {
    return '$ay, year $yil';
  }

  @override
  String get ayOcak => 'January';

  @override
  String get aySubat => 'February';

  @override
  String get ayMart => 'March';

  @override
  String get ayNisan => 'April';

  @override
  String get ayMayis => 'May';

  @override
  String get ayHaziran => 'June';

  @override
  String get ayTemmuz => 'July';

  @override
  String get ayAgustos => 'August';

  @override
  String get ayEylul => 'September';

  @override
  String get ayEkim => 'October';

  @override
  String get ayKasim => 'November';

  @override
  String get ayAralik => 'December';

  @override
  String get rejimBuyume => 'Growth';

  @override
  String get rejimDurgunluk => 'Stagnation';

  @override
  String get rejimKriz => 'Crisis';

  @override
  String get rejimEnflasyon => 'Inflation';

  @override
  String get ekonomi => 'Economy';

  @override
  String get rejim => 'Regime';

  @override
  String get yillikEnflasyon => 'Annual inflation';

  @override
  String alimGucuKaybi(String oran) {
    return 'Pay is $oran behind';
  }

  @override
  String get durumOgrenci => 'Student';

  @override
  String get durumIssiz => 'Unemployed';

  @override
  String get durumAtamaBekliyor => 'Awaiting placement';

  @override
  String get durumAskerlik => 'Military service';

  @override
  String get durumBedelli => 'Paid exemption service';

  @override
  String get durumEmekli => 'Retired';

  @override
  String kalanTur(int tur) {
    return '$tur turns left';
  }

  @override
  String get zamanDagilimi => 'What will you do this month?';

  @override
  String get zamanCalisma => 'Work';

  @override
  String get zamanEgitim => 'Study';

  @override
  String get zamanNetwork => 'Network';

  @override
  String get zamanDinlenme => 'Rest';

  @override
  String kalanPuan(int puan) {
    return '$puan points unused';
  }

  @override
  String get dagilimDengeli => 'Balanced';

  @override
  String get dagilimTamMesai => 'Full time';

  @override
  String get turuBitir => 'End Turn';

  @override
  String get ucAyAtla => 'Skip 3 months';

  @override
  String get birYilAtla => 'Skip 1 year';

  @override
  String turRaporu(String ay) {
    return '$ay report';
  }

  @override
  String atlananTur(int sayi) {
    return '$sayi months passed';
  }

  @override
  String get raporGelir => 'Income';

  @override
  String get raporYasamGideri => 'Cost of living';

  @override
  String get raporTaksit => 'Loan instalment';

  @override
  String get raporFaiz => 'Overdraft interest';

  @override
  String get raporKira => 'Rent and dividends';

  @override
  String get raporIsletme => 'Business profit';

  @override
  String get raporNakitDegisimi => 'Monthly balance';

  @override
  String get kapat => 'Close';

  @override
  String get devam => 'Continue';

  @override
  String olayTerfi(String kademe) {
    return 'Promoted: $kademe';
  }

  @override
  String get olayIstenCikarildi => 'You were laid off.';

  @override
  String get olayMezunOldu => 'You graduated.';

  @override
  String get olayAskerlikBitti => 'You were discharged.';

  @override
  String get olayCelpGeldi => 'Your draft notice arrived.';

  @override
  String get olayAskereAlindi => 'You were drafted.';

  @override
  String get olayAtamasiCikti => 'Your placement came through.';

  @override
  String get olayMaasZammi => 'Salaries were raised.';

  @override
  String get olayParaReformu => 'Three zeros were dropped from the currency.';

  @override
  String olayRejimDegisti(String rejim) {
    return 'The economy entered a $rejim period.';
  }

  @override
  String olayIsletmeKrizi(String isletme) {
    return '$isletme needs your attention.';
  }

  @override
  String get acikPozisyonlar => 'Jobs you can take';

  @override
  String get uygunIsYok =>
      'No job is open to you right now. This fills up as education and competence gates open.';

  @override
  String get basvur => 'Take this job';

  @override
  String get vazgec => 'Cancel';

  @override
  String basvuruYapildi(String meslek) {
    return 'You are as good as hired at $meslek: you start when the turn ends.';
  }

  @override
  String baslangicMaasi(String tutar) {
    return 'Starts at $tutar';
  }

  @override
  String kademeSayisi(int sayi) {
    return '$sayi grades';
  }

  @override
  String get kariyerMerdiveni => 'Career ladder';

  @override
  String get yetkinlikler => 'Competences';

  @override
  String get sektorSaglik => 'Health';

  @override
  String get sektorTeknoloji => 'Technology';

  @override
  String get sektorHukukKamu => 'Law and public sector';

  @override
  String get sektorFinans => 'Finance';

  @override
  String get sektorTicaret => 'Trade';

  @override
  String get sektorEsnaf => 'Small business';

  @override
  String get sektorMedya => 'Media';

  @override
  String get sektorLojistik => 'Logistics';

  @override
  String get sektorTarim => 'Agriculture';

  @override
  String get sektorTurizm => 'Tourism';

  @override
  String sartEgitim(String seviye) {
    return 'At least $seviye';
  }

  @override
  String sartYetkinlik(String sektor, int deger) {
    return '$sektor competence $deger';
  }

  @override
  String sartYas(int enAz, int enCok) {
    return 'Ages $enAz-$enCok';
  }

  @override
  String kararBekliyor(int sayi) {
    return '$sayi decision pending';
  }

  @override
  String get kararlariGor => 'Decide';

  @override
  String get kartTuruFirsat => 'Opportunity';

  @override
  String get kartTuruKriz => 'Crisis';

  @override
  String get kartTuruTeklif => 'Offer';

  @override
  String get kartTuruHayat => 'Life';

  @override
  String sonucBekliyor(int tur) {
    return 'The outcome will be clear in $tur months.';
  }

  @override
  String get gecmisKararlar => 'Your past decisions';

  @override
  String kartKaldi(int sayi) {
    return '$sayi more cards';
  }

  @override
  String get kararVermedenTurBitmez => 'Answer the pending decision first.';

  @override
  String get portfoy => 'Portfolio';

  @override
  String get portfoyBos =>
      'You hold no investments yet. Holding cash loses to inflation.';

  @override
  String get portfoyDegeri => 'Portfolio value';

  @override
  String get reelKarZarar => 'Real profit/loss';

  @override
  String get karZarar => 'Profit/loss';

  @override
  String get maliyet => 'Cost';

  @override
  String get satista => 'Listed for sale';

  @override
  String satisTamamlanir(int tur) {
    return 'in $tur turns';
  }

  @override
  String get varliklar => 'Investments';

  @override
  String get birimFiyat => 'Unit price';

  @override
  String get yillikDegisim => '12m real';

  @override
  String get veriYok => '—';

  @override
  String get al => 'Buy';

  @override
  String get sat => 'Sell';

  @override
  String get adet => 'Quantity';

  @override
  String get tumu => 'All';

  @override
  String get toplamTutar => 'Total';

  @override
  String get komisyon => 'Fee';

  @override
  String get emirSiraya => 'Order queued';

  @override
  String get bekleyenEmirler => 'Queued orders';

  @override
  String emirAlim(String adet, String birim) {
    return 'Buy $adet $birim';
  }

  @override
  String emirSatim(String adet, String birim) {
    return 'Sell $adet $birim';
  }

  @override
  String get emirNotu =>
      'Orders execute when the turn ends, at the price shown here.';

  @override
  String satisGecikmesi(int tur) {
    return 'The sale takes $tur turns; the price risk stays with you.';
  }

  @override
  String get bolunemez => 'Whole units only.';

  @override
  String grafikBasligi(int tur) {
    return 'Real price (last $tur months)';
  }

  @override
  String get birimGram => 'g';

  @override
  String get birimLot => 'lots';

  @override
  String get birimAdet => 'units';

  @override
  String get birimDolar => 'USD';

  @override
  String get birimDaire => 'flats';

  @override
  String get birimParsel => 'plots';

  @override
  String get varlikMevduat => 'Deposit';

  @override
  String get varlikAltin => 'Gold';

  @override
  String get varlikDoviz => 'Foreign currency';

  @override
  String get varlikGayrimenkul => 'Flat';

  @override
  String get varlikArsa => 'Land';

  @override
  String get varlikKripto => 'Crypto';

  @override
  String get varlikHisseBankacilik => 'Banking';

  @override
  String get varlikHisseSanayi => 'Industry';

  @override
  String get varlikHisseTeknoloji => 'Technology';

  @override
  String get varlikHisseGida => 'Food';

  @override
  String get varlikHisseInsaat => 'Construction';

  @override
  String get varlikHisseEnerji => 'Energy';

  @override
  String get turMevduat => 'Deposit';

  @override
  String get turAltin => 'Precious metal';

  @override
  String get turHisse => 'Stocks';

  @override
  String get turDoviz => 'Currency';

  @override
  String get turGayrimenkul => 'Real estate';

  @override
  String get turArsa => 'Land';

  @override
  String get turKripto => 'Crypto';

  @override
  String get hataBaslik => 'Something went wrong';

  @override
  String get yukleniyor => 'Loading…';
}
