// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'uygulama_metinleri.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class UygulamaMetinleriTr extends UygulamaMetinleri {
  UygulamaMetinleriTr([String locale = 'tr']) : super(locale);

  @override
  String get uygulamaAdi => 'Hayat & Kariyer';

  @override
  String get yasalUyari => 'Bu bir oyundur, yatırım tavsiyesi değildir.';

  @override
  String get yeniOyun => 'Yeni Oyun';

  @override
  String get oyunaBasla => 'Hayata Başla';

  @override
  String get adinNe => 'Adın';

  @override
  String get adVarsayilan => 'Oyuncu';

  @override
  String get cinsiyet => 'Cinsiyet';

  @override
  String get cinsiyetErkek => 'Erkek';

  @override
  String get cinsiyetKadin => 'Kadın';

  @override
  String get sehir => 'Şehir';

  @override
  String get sehirIstanbul => 'İstanbul';

  @override
  String get sehirIzmir => 'İzmir';

  @override
  String get sehirGaziantep => 'Gaziantep';

  @override
  String get sehirTrabzon => 'Trabzon';

  @override
  String get sehirKonya => 'Konya';

  @override
  String giderCarpani(String carpan) {
    return 'Yaşam gideri ×$carpan';
  }

  @override
  String get egitim => 'Eğitim';

  @override
  String get egitimIlkogretim => 'İlköğretim';

  @override
  String get egitimLise => 'Lise';

  @override
  String get egitimOnlisans => 'Ön lisans';

  @override
  String get egitimLisans => 'Lisans';

  @override
  String get egitimYuksekLisans => 'Yüksek lisans';

  @override
  String get egitimDoktora => 'Doktora';

  @override
  String get sekmeOzet => 'Özet';

  @override
  String get sekmePiyasa => 'Piyasa';

  @override
  String get sekmeKariyer => 'Kariyer';

  @override
  String get sekmeIsletme => 'İşletme';

  @override
  String get sekmeYakinda => 'Bu ekran henüz yazılmadı.';

  @override
  String get nakit => 'Nakit';

  @override
  String get netDeger => 'Net Değer';

  @override
  String get reelNetDeger => 'Reel net değer';

  @override
  String get enerji => 'Enerji';

  @override
  String get mutluluk => 'Mutluluk';

  @override
  String get itibar => 'İtibar';

  @override
  String get krediNotu => 'Kredi notu';

  @override
  String get yetkinlik => 'Yetkinlik';

  @override
  String get borc => 'Borç';

  @override
  String get taksitYuku => 'Aylık taksit';

  @override
  String yasBilgisi(int yas) {
    return '$yas yaşında';
  }

  @override
  String turBilgisi(String ay, int yil) {
    return '$ay $yil. yıl';
  }

  @override
  String get ayOcak => 'Ocak';

  @override
  String get aySubat => 'Şubat';

  @override
  String get ayMart => 'Mart';

  @override
  String get ayNisan => 'Nisan';

  @override
  String get ayMayis => 'Mayıs';

  @override
  String get ayHaziran => 'Haziran';

  @override
  String get ayTemmuz => 'Temmuz';

  @override
  String get ayAgustos => 'Ağustos';

  @override
  String get ayEylul => 'Eylül';

  @override
  String get ayEkim => 'Ekim';

  @override
  String get ayKasim => 'Kasım';

  @override
  String get ayAralik => 'Aralık';

  @override
  String get rejimBuyume => 'Büyüme';

  @override
  String get rejimDurgunluk => 'Durgunluk';

  @override
  String get rejimKriz => 'Kriz';

  @override
  String get rejimEnflasyon => 'Enflasyon';

  @override
  String get ekonomi => 'Ekonomi';

  @override
  String get rejim => 'Dönem';

  @override
  String get yillikEnflasyon => 'Yıllık enflasyon';

  @override
  String alimGucuKaybi(String oran) {
    return 'Maaşın $oran geride';
  }

  @override
  String get durumOgrenci => 'Öğrenci';

  @override
  String get durumIssiz => 'İşsiz';

  @override
  String get durumAtamaBekliyor => 'Atama bekliyor';

  @override
  String get durumAskerlik => 'Askerlik';

  @override
  String get durumBedelli => 'Bedelli askerlik';

  @override
  String get durumEmekli => 'Emekli';

  @override
  String kalanTur(int tur) {
    return '$tur tur kaldı';
  }

  @override
  String get zamanDagilimi => 'Bu ay ne yapacaksın?';

  @override
  String get zamanCalisma => 'Çalış';

  @override
  String get zamanEgitim => 'Eğitim';

  @override
  String get zamanNetwork => 'Network';

  @override
  String get zamanDinlenme => 'Dinlen';

  @override
  String kalanPuan(int puan) {
    return '$puan puan boşta';
  }

  @override
  String get dagilimDengeli => 'Dengeli';

  @override
  String get dagilimTamMesai => 'Tam mesai';

  @override
  String get turuBitir => 'Turu Bitir';

  @override
  String get ucAyAtla => '3 ay atla';

  @override
  String get birYilAtla => '1 yıl atla';

  @override
  String turRaporu(String ay) {
    return '$ay raporu';
  }

  @override
  String atlananTur(int sayi) {
    return '$sayi ay geçildi';
  }

  @override
  String get raporGelir => 'Gelir';

  @override
  String get raporYasamGideri => 'Yaşam gideri';

  @override
  String get raporTaksit => 'Kredi taksiti';

  @override
  String get raporFaiz => 'Eksi bakiye faizi';

  @override
  String get raporKira => 'Kira ve temettü';

  @override
  String get raporIsletme => 'İşletme kârı';

  @override
  String get raporNakitDegisimi => 'Aylık bakiye';

  @override
  String get kapat => 'Kapat';

  @override
  String get devam => 'Devam';

  @override
  String olayTerfi(String kademe) {
    return 'Terfi ettin: $kademe';
  }

  @override
  String get olayIstenCikarildi => 'İşten çıkarıldın.';

  @override
  String get olayMezunOldu => 'Mezun oldun.';

  @override
  String get olayAskerlikBitti => 'Terhis oldun.';

  @override
  String get olayCelpGeldi => 'Askerlik tebligatın geldi.';

  @override
  String get olayAskereAlindi => 'Askere alındın.';

  @override
  String get olayAtamasiCikti => 'Ataman çıktı.';

  @override
  String get olayMaasZammi => 'Maaşlara zam yapıldı.';

  @override
  String get olayParaReformu => 'Paradan üç sıfır atıldı.';

  @override
  String olayRejimDegisti(String rejim) {
    return 'Ekonomi $rejim dönemine girdi.';
  }

  @override
  String olayIsletmeKrizi(String isletme) {
    return '$isletme ilgi bekliyor.';
  }

  @override
  String get acikPozisyonlar => 'Girebileceğin işler';

  @override
  String get uygunIsYok =>
      'Şu an girebileceğin bir iş yok. Eğitim ve yetkinlik kapıları açıldıkça burası dolar.';

  @override
  String get basvur => 'Bu işe gir';

  @override
  String get vazgec => 'Vazgeç';

  @override
  String basvuruYapildi(String meslek) {
    return '$meslek işine başladın sayılır: turu bitirince göreve başlıyorsun.';
  }

  @override
  String baslangicMaasi(String tutar) {
    return 'Başlangıç $tutar';
  }

  @override
  String kademeSayisi(int sayi) {
    return '$sayi kademe';
  }

  @override
  String get kariyerMerdiveni => 'Kariyer merdiveni';

  @override
  String get yetkinlikler => 'Yetkinlikler';

  @override
  String get sektorSaglik => 'Sağlık';

  @override
  String get sektorTeknoloji => 'Teknoloji';

  @override
  String get sektorHukukKamu => 'Hukuk ve kamu';

  @override
  String get sektorFinans => 'Finans';

  @override
  String get sektorTicaret => 'Ticaret';

  @override
  String get sektorEsnaf => 'Esnaf';

  @override
  String get sektorMedya => 'Medya';

  @override
  String get sektorLojistik => 'Lojistik';

  @override
  String get sektorTarim => 'Tarım';

  @override
  String get sektorTurizm => 'Turizm';

  @override
  String sartEgitim(String seviye) {
    return 'En az $seviye';
  }

  @override
  String sartYetkinlik(String sektor, int deger) {
    return '$sektor yetkinliği $deger';
  }

  @override
  String sartYas(int enAz, int enCok) {
    return '$enAz-$enCok yaş';
  }

  @override
  String kararBekliyor(int sayi) {
    return '$sayi karar bekliyor';
  }

  @override
  String get kararlariGor => 'Kararı ver';

  @override
  String get kartTuruFirsat => 'Fırsat';

  @override
  String get kartTuruKriz => 'Kriz';

  @override
  String get kartTuruTeklif => 'Teklif';

  @override
  String get kartTuruHayat => 'Hayat';

  @override
  String sonucBekliyor(int tur) {
    return 'Sonucu $tur ay sonra belli olacak.';
  }

  @override
  String get gecmisKararlar => 'Geçmiş kararların';

  @override
  String kartKaldi(int sayi) {
    return '$sayi kart daha var';
  }

  @override
  String get kararVermedenTurBitmez => 'Önce bekleyen kararı ver.';

  @override
  String get portfoy => 'Portföy';

  @override
  String get portfoyBos =>
      'Henüz yatırımın yok. Nakit tutmak enflasyona karşı kaybettirir.';

  @override
  String get portfoyDegeri => 'Portföy değeri';

  @override
  String get reelKarZarar => 'Reel kâr/zarar';

  @override
  String get karZarar => 'Kâr/zarar';

  @override
  String get maliyet => 'Maliyet';

  @override
  String get satista => 'Satışta';

  @override
  String satisTamamlanir(int tur) {
    return '$tur tur sonra';
  }

  @override
  String get varliklar => 'Yatırım araçları';

  @override
  String get birimFiyat => 'Birim fiyat';

  @override
  String get yillikDegisim => '12 ay reel';

  @override
  String get veriYok => '—';

  @override
  String get al => 'Al';

  @override
  String get sat => 'Sat';

  @override
  String get adet => 'Adet';

  @override
  String get tumu => 'Tümü';

  @override
  String get toplamTutar => 'Toplam';

  @override
  String get komisyon => 'Komisyon';

  @override
  String get emirSiraya => 'Emir sıraya alındı';

  @override
  String get bekleyenEmirler => 'Bekleyen emirler';

  @override
  String emirAlim(String adet, String birim) {
    return '$adet $birim al';
  }

  @override
  String emirSatim(String adet, String birim) {
    return '$adet $birim sat';
  }

  @override
  String get emirNotu =>
      'Emirler tur bitince, ekranda gördüğün fiyattan işlenir.';

  @override
  String satisGecikmesi(int tur) {
    return 'Satış $tur tur sürer; fiyat riski sende kalır.';
  }

  @override
  String get bolunemez => 'Tam sayı alınır.';

  @override
  String grafikBasligi(int tur) {
    return 'Reel fiyat (son $tur ay)';
  }

  @override
  String get birimGram => 'gram';

  @override
  String get birimLot => 'lot';

  @override
  String get birimAdet => 'adet';

  @override
  String get birimDolar => 'USD';

  @override
  String get birimDaire => 'daire';

  @override
  String get birimParsel => 'parsel';

  @override
  String get varlikMevduat => 'Mevduat';

  @override
  String get varlikAltin => 'Altın';

  @override
  String get varlikDoviz => 'Döviz';

  @override
  String get varlikGayrimenkul => 'Daire';

  @override
  String get varlikArsa => 'Arsa';

  @override
  String get varlikKripto => 'Kripto';

  @override
  String get varlikHisseBankacilik => 'Bankacılık';

  @override
  String get varlikHisseSanayi => 'Sanayi';

  @override
  String get varlikHisseTeknoloji => 'Teknoloji';

  @override
  String get varlikHisseGida => 'Gıda';

  @override
  String get varlikHisseInsaat => 'İnşaat';

  @override
  String get varlikHisseEnerji => 'Enerji';

  @override
  String get turMevduat => 'Mevduat';

  @override
  String get turAltin => 'Kıymetli maden';

  @override
  String get turHisse => 'Borsa';

  @override
  String get turDoviz => 'Döviz';

  @override
  String get turGayrimenkul => 'Gayrimenkul';

  @override
  String get turArsa => 'Arsa';

  @override
  String get turKripto => 'Kripto';

  @override
  String get hataBaslik => 'Bir şeyler ters gitti';

  @override
  String get yukleniyor => 'Yükleniyor…';
}
