import '../models/borc.dart';
import '../models/kariyer_durumu.dart';
import '../models/meslek_katalogu.dart';
import '../models/olay.dart';
import '../models/oyun_durumu.dart';
import '../models/oyuncu.dart';
import '../models/piyasa_durumu.dart';
import '../models/sehir.dart';
import '../models/zaman_dagilimi.dart';
import '../rng/rastgele_kaynak.dart';
import 'borc_motoru.dart';
import 'isletme_motoru.dart';
import 'kariyer_motoru.dart';
import 'olay_motoru.dart';
import 'piyasa_simulatoru.dart';
import 'portfoy_motoru.dart';
import 'rejim.dart';

/// Tur işleyicinin denge sabitleri.
class TurAyarlari {
  const TurAyarlari();

  /// Tek kişilik aylık yaşam gideri (2026 TL, kira dahil). Şehir çarpanı ve
  /// enflasyon endeksiyle çarpılır.
  final int tabanYasamGideri = 22000;

  /// Maaş zammının yapıldığı ay. Ocak.
  final int zamAyi = 1;

  /// Nakit eksideyken her tur işleyen gecikme faizi.
  final double eksiBakiyeFaizi = 0.04;

  /// Nakit eksideyse her tur düşen kredi notu.
  final int borcluKrediNotuDususu = 12;

  /// Nakit artıdayken her tur toparlanan kredi notu.
  final int duzenliKrediNotuArtisi = 3;
}

/// Bir turda ne olduğunun kaydı. UI bu raporu ekrana döker.
class TurRaporu {
  const TurRaporu({
    required this.tur,
    required this.yas,
    required this.ay,
    required this.netGelir,
    required this.yasamGideri,
    required this.faizGideri,
    required this.nakitDegisimi,
    required this.rejim,
    required this.rejimDegisti,
    required this.aylikEnflasyon,
    required this.maasZammiYapildi,
    required this.paraReformuYapildi,
    required this.performans,
    required this.kiraGeliri,
    required this.portfoyDegeri,
    required this.netDeger,
    this.kurulanIsletmeId,
    this.satisaCikanIsletmeId,
    this.isletmeHatasi,
    this.emirSonuclari = const [],
    this.tamamlananSatislar = const [],
    this.acilanOlaylar = const [],
    this.isletmeKari = 0,
    this.odenenTaksit = 0,
    this.cekilenKredi = 0,
    this.celpGeldi = false,
    this.askereAlindi = false,
    this.atamasiCikti = false,
    this.iseGirildi = false,
    this.krediHatasi,
    this.toplamBorc = 0,
    this.kapananKrediler = const [],
    this.gecikenKrediler = const [],
    this.takibeDusenKrediler = const [],
    this.isletmeRaporlari = const [],
    this.devredilenIsletmeler = const {},
    this.terfiEtti = false,
    this.yeniKademeAdi,
    this.istenCikarildi = false,
    this.mezunOldu = false,
    this.askerlikBitti = false,
  });

  final int tur;
  final int yas;
  final int ay;

  final int netGelir;
  final int yasamGideri;
  final int faizGideri;
  final int nakitDegisimi;

  final Rejim rejim;
  final bool rejimDegisti;
  final double aylikEnflasyon;
  final bool maasZammiYapildi;
  final bool paraReformuYapildi;

  final double performans;

  /// Kira ve temettü toplamı.
  final int kiraGeliri;
  final int portfoyDegeri;
  final int netDeger;

  /// Verilen emirlerin sonuçları; reddedilenler dahil.
  final List<EmirSonucu> emirSonuclari;

  /// Bu tur olgunlaşan gecikmeli satışlar.
  final List<TamamlananSatis> tamamlananSatislar;

  /// Turlar önce verilmiş kararlardan bu tur açığa çıkanlar.
  final List<AcigaCikanSonuc> acilanOlaylar;

  /// İşletmelerin bu turdaki toplam net kârı (negatif olabilir).
  final int isletmeKari;

  /// Bu tur ödenen kredi taksiti (nominal TL).
  final int odenenTaksit;

  /// Bu tur çekilen kredi anaparası. 0 = kredi çekilmedi.
  final int cekilenKredi;

  /// Celp tebligatı bu turda geldi.
  final bool celpGeldi;

  /// Bu turda askere alındı.
  final bool askereAlindi;

  /// Atama kurası bu turda çıktı.
  final bool atamasiCikti;

  /// İşe giriş talebi bu turda kabul edildi.
  final bool iseGirildi;

  /// Kredi talebi reddedildiyse sebebi.
  final KrediHatasi? krediHatasi;

  /// Tur sonundaki toplam kalan borç.
  final int toplamBorc;
  final List<String> kapananKrediler;
  final List<String> gecikenKrediler;
  final List<String> takibeDusenKrediler;
  final List<IsletmeRaporu> isletmeRaporlari;

  /// Bu turda kurulan işletmenin kimliği.
  final String? kurulanIsletmeId;

  /// Bu turda satışa çıkarılan işletmenin kimliği.
  final String? satisaCikanIsletmeId;

  /// İşletme komutu reddedildiyse sebebi. Sessizce düşen komut oyuncuya
  /// "düğme çalışmıyor" gibi görünürdü.
  final IsletmeHatasi? isletmeHatasi;

  /// Bu turda devri tamamlanan işletmeler: id → eline geçen tutar.
  final Map<String, int> devredilenIsletmeler;

  final bool terfiEtti;
  final String? yeniKademeAdi;
  final bool istenCikarildi;
  final bool mezunOldu;
  final bool askerlikBitti;

  /// Bu tur ay sonunu artıda mı kapattı.
  bool get artidaKapandi => nakitDegisimi >= 0;
}

/// Turun sonucu: yeni durum ve ne olduğunun raporu.
class TurSonucu {
  const TurSonucu({required this.durum, required this.rapor});

  final OyunDurumu durum;
  final TurRaporu rapor;
}

/// Oyuncunun bir turda verdiği kararlar.
///
/// Bütün komutlar tek nesnede toplanıyor: "3 ay atla" gibi toplu ilerlemeyi
/// ve testte senaryo kurmayı bu mümkün kılıyor.
class TurGirdisi {
  const TurGirdisi({
    required this.zaman,
    this.emirler = const [],
    this.krediTalebi,
    this.bedelliOde = false,
    this.iseGirTalebi,
    this.isletmeKomutu,
  });

  TurGirdisi.varsayilan()
      : zaman = ZamanDagilimi.dengeli(),
        emirler = const [],
        krediTalebi = null,
        bedelliOde = false,
        iseGirTalebi = null,
        isletmeKomutu = null;

  final ZamanDagilimi zaman;

  /// Yatırım ekranında verilen alım-satım emirleri.
  final List<Emir> emirler;

  /// Bu turda çekilmek istenen kredi. Emirlerden ÖNCE işlenir: oyuncu
  /// çektiği krediyle aynı turda yatırım yapabilsin.
  final KrediTalebi? krediTalebi;

  /// Celp tebligatı geldiyse bedelli ödensin mi.
  final bool bedelliOde;

  /// Girilmek istenen meslek kimliği. Kamu mesleklerinde atama kuyruğuna
  /// alır, diğerlerinde doğrudan işe başlatır.
  final String? iseGirTalebi;

  /// İşletme açma / satışa çıkarma / CEO komutu. Turda EN FAZLA BİR tane:
  /// işletme kimliği turdan türetildiği için ikisi aynı turda çakışırdı,
  /// ayrıca bu kararlar tek tek verilmeli.
  final IsletmeKomutu? isletmeKomutu;
}

/// İşletme komutları.
sealed class IsletmeKomutu {
  const IsletmeKomutu();
}

/// Yeni işletme kur.
class IsletmeAc extends IsletmeKomutu {
  const IsletmeAc(this.tanimId);

  final String tanimId;
}

/// Satışa çıkar. Devir turlar sürer.
class IsletmeSat extends IsletmeKomutu {
  const IsletmeSat(this.isletmeId);

  final String isletmeId;
}

/// CEO ata ya da görevden al.
class CeoAyarla extends IsletmeKomutu {
  const CeoAyarla(this.isletmeId, {required this.ceoVar});

  final String isletmeId;
  final bool ceoVar;
}

/// Oyuncunun kredi talebi.
class KrediTalebi {
  const KrediTalebi({required this.tur, required this.anapara});

  final BorcTuru tur;
  final int anapara;
}

/// "Turu bitir" düğmesinin arkasındaki boru hattı.
///
/// SIRA SÖZLEŞMEDİR ve testle sabitlenmiştir:
///   0. Alım-satım emirleri — OYUNCUNUN GÖRDÜĞÜ fiyatlarla
///   1. Piyasa hareket eder (rejim, enflasyon, fiyatlar)
///   2. Ocaksa maaş endeksi güncellenir (zam)
///   3. Kariyer işlenir (gelir, terfi, statlar) — maaş GEÇEN yılın endeksiyle
///   4. Gecikmeli olay sonuçları açığa çıkar
///   5. Kira geliri ve olgunlaşan gecikmeli satışlar — YENİ fiyatlarla
///   6. İşletmeler işler (ilgi, statlar, kâr/zarar, devirler)
///   7. Kredi taksitleri ödenir — YAŞAM GİDERİNDEN ÖNCE
///   8. Yaşam gideri düşer — GÜNCEL enflasyonla
///   9. Nakit mahsuplaşır, eksi bakiye faiz işletir, kredi notu güncellenir
///  10. Tur ilerler (yaş, kariyer sayaçları, SGK primi)
///
/// 0. adımın piyasadan ÖNCE olması bilinçli: oyuncu ekranda gördüğü fiyattan
/// alır, sonra piyasa oynar. Aksi halde "aldığım fiyat bu değildi" olurdu.
///
/// 7. adımın giderden önce olması bilinçli: banka maaş hesabından payını
/// önce çeker. Taksit yalnız artıda kalan nakitten ödenir; eksiye düşerek
/// taksit ödenemez, yoksa gecikme diye bir şey olmazdı.
///
/// 3. ve 8. adımın farklı endeks kullanması da bilinçli: maaş yılda bir
/// zamlanır, market her ay zamlanır. Aradaki makas oyunun ana baskısıdır.
class TurProcessor {
  TurProcessor({
    required this.katalog,
    PiyasaSimulatoru? piyasa,
    PortfoyMotoru? portfoy,
    this.olay,
    this.isletme,
    this.borc = const BorcMotoru(),
    this.kariyer = const KariyerMotoru(),
    this.ayarlar = const TurAyarlari(),
  })  : piyasa = piyasa ?? PiyasaSimulatoru(),
        portfoy = portfoy ?? PortfoyMotoru() {
    // Sessiz bağlama hatası: işletme tanımları kart havuzu bildirdiği halde
    // olay motoruna kart→işletme dizini verilmemişse o kartlar İŞLETMESİ
    // OLMAYAN herkese çıkar. Testte patlasın, oyunda değil.
    assert(
      olay == null ||
          isletme == null ||
          isletme!.katalog.olayHavuzuDizini().isEmpty ||
          olay!.isletmeKartlari.isNotEmpty,
      'OlayMotoru.isletmeKartlari boş: '
      'IsletmeKatalogu.olayHavuzuDizini() geçilmeli',
    );
  }

  final MeslekKatalogu katalog;
  final PiyasaSimulatoru piyasa;
  final PortfoyMotoru portfoy;

  /// Olay motoru isteğe bağlı: kart sistemi olmadan da tur işlenebilir
  /// (denge simülasyonları kartsız çalışıyor).
  final OlayMotoru? olay;

  /// İşletme motoru isteğe bağlı: işletmesiz oyun da işlenebilir, denge
  /// simülasyonlarının çoğu işletmesiz koşuyor.
  final IsletmeMotoru? isletme;

  /// Borç motoru her zaman var: borcu olmayan oyuncuda hiçbir şey yapmaz.
  final BorcMotoru? borc;
  final KariyerMotoru kariyer;
  final TurAyarlari ayarlar;

  /// Yeni oyun başlangıç durumu.
  OyunDurumu yeniOyun({
    required Oyuncu oyuncu,
    required int anaTohum,
    Rejim baslangicRejimi = Rejim.buyume,
  }) =>
      OyunDurumu(
        anaTohum: anaTohum,
        oyuncu: oyuncu,
        piyasa: piyasa.baslangic(rejim: baslangicRejimi),
      );

  TurSonucu turuBitir(OyunDurumu durum, TurGirdisi girdi) {
    final kaynak = RastgeleKaynak(durum.anaTohum);
    final sonrakiTur = durum.tur + 1;

    // 0a. Kredi — emirlerden önce, çekilen para aynı turda yatırılabilsin.
    //     Banka BORDROYA bakar: bu turun şoklu geliri henüz bilinmiyor,
    //     zaten kredi kararı gerçekleşen gelire değil maaş belgesine
    //     bakılarak verilir.
    var oyuncuBaslangic = durum.oyuncu;
    var guncelBorclar = durum.borclar;
    var krediSonucu = const KrediSonucu(hata: null);
    final talep = girdi.krediTalebi;
    final borcMotoru = borc;
    if (talep != null && borcMotoru != null) {
      krediSonucu = borcMotoru.krediCek(
        oyuncu: durum.oyuncu,
        borclar: durum.borclar,
        piyasa: durum.piyasa,
        aylikGelir: bordroGeliri(durum),
        tur: talep.tur,
        anapara: talep.anapara,
        simdikiTur: durum.tur,
      );
      final yeniBorc = krediSonucu.borc;
      if (yeniBorc != null) {
        guncelBorclar = [...durum.borclar, yeniBorc];
        oyuncuBaslangic = oyuncuBaslangic.nakitDegistir(yeniBorc.anapara);
      }
    }

    // 0b. İşe giriş talebi. Kariyerden önce: aynı turda çalışmaya başlasın
    //     (kamu mesleğinde atama kuyruğuna girsin).
    var iseGirildi = false;
    final isTalebi = girdi.iseGirTalebi;
    if (isTalebi != null) {
      final meslek = katalog.bul(isTalebi);
      final yeniDurumu =
          meslek == null ? null : kariyer.iseGir(oyuncuBaslangic, meslek);
      if (yeniDurumu != null) {
        oyuncuBaslangic = oyuncuBaslangic.kariyerDegistir(yeniDurumu);
        iseGirildi = true;
      }
    }

    // 0c. İşletme komutu — emirlerden ÖNCE. Kuruluş bedeli nakitten
    //     düşüyor; oyuncu aynı turda hem işletme açıp hem o parayla
    //     yatırım yapamasın.
    var guncelIsletmeler = durum.isletmeler;
    var guncelIlgi = durum.ilgi;
    IsletmeHatasi? isletmeHatasi;
    String? kurulanIsletmeId;
    String? satisaCikanIsletmeId;
    final isletmeMotoruYerel = isletme;
    final komut = girdi.isletmeKomutu;
    if (komut != null && isletmeMotoruYerel != null) {
      switch (komut) {
        case IsletmeAc(:final tanimId):
          final sonuc = isletmeMotoruYerel.kur(
            tanimId: tanimId,
            oyuncu: oyuncuBaslangic,
            piyasa: durum.piyasa,
            tur: sonrakiTur,
            mevcutlar: guncelIsletmeler,
          );
          isletmeHatasi = sonuc.hata;
          final yeni = sonuc.isletme;
          if (yeni != null) {
            guncelIsletmeler = [...guncelIsletmeler, yeni];
            oyuncuBaslangic = oyuncuBaslangic.nakitDegistir(-sonuc.bedel);
            kurulanIsletmeId = yeni.id;
          }

        case IsletmeSat(:final isletmeId):
          guncelIsletmeler = [
            for (final i in guncelIsletmeler)
              if (i.id == isletmeId)
                isletmeMotoruYerel.satisaCikar(i) ?? i
              else
                i,
          ];
          satisaCikanIsletmeId = isletmeId;

        case CeoAyarla(:final isletmeId, :final ceoVar):
          guncelIsletmeler = [
            for (final i in guncelIsletmeler)
              if (i.id == isletmeId)
                isletmeMotoruYerel.ceoAyarla(i, ceoVar: ceoVar) ?? i
              else
                i,
          ];
      }
      // İlgi dağılımı işletme listesi değiştikçe geçerliliğini yitirebilir:
      // satılan işletmenin puanı boşa gider, yeni işletme sıfır puanla
      // başlar. `duzelt` fazlalığı en çok puan alandan kırpıyor.
      guncelIlgi = guncelIlgi.duzelt();
    }

    // 0d. Emirler — oyuncunun gördüğü fiyatlarla, piyasa oynamadan önce.
    final emirSonucu = portfoy.emirleriIsle(
      durum.portfoy,
      oyuncuBaslangic.nakit,
      durum.piyasa,
      girdi.emirler,
    );
    var guncelPortfoy = emirSonucu.portfoy;

    // 1. Piyasa
    final yeniPiyasa = piyasa.turIsle(
      durum.piyasa,
      kaynak.akis('piyasa', tur: sonrakiTur),
    );
    final rejimDegisti = yeniPiyasa.rejim != durum.piyasa.rejim;

    // 2. Maaş zammı: yalnızca ocak ayında. Oyuncunun GİRECEĞİ ayın ocak
    //    olması aranıyor; zam yeni yılın ilk maaşında geçerli olsun diye.
    final girilecekAy = sonrakiTur % 12 + 1;
    final zamZamani = girilecekAy == ayarlar.zamAyi;
    final maasEndeksi =
        zamZamani ? yeniPiyasa.enflasyonEndeksi : durum.maasEndeksi;

    // 3. Kariyer
    final kariyerSonucu = kariyer.turIsle(
      // Kredi çekildiyse nakit zaten eklendi; boru hattı buradan devam
      // etmeli, yoksa çekilen para sessizce kaybolur.
      oyuncu: oyuncuBaslangic,
      katalog: katalog,
      piyasa: yeniPiyasa,
      zaman: girdi.zaman,
      akis: kaynak.akis('kariyer', tur: sonrakiTur),
      maasEndeksi: maasEndeksi,
      bedelliOde: girdi.bedelliOde,
    );

    // 4. Gecikmeli olay sonuçları. Kariyerden sonra, gider mahsuplaşmasından
    //    önce: açığa çıkan para bu ayın bilançosuna girsin.
    var araDurum = durum.copyWith(
      oyuncu: kariyerSonucu.oyuncu,
      borclar: guncelBorclar,
      piyasa: yeniPiyasa,
      portfoy: guncelPortfoy,
    );
    var acilanOlaylar = const <AcigaCikanSonuc>[];
    if (olay != null) {
      final olaySonucu = olay!.bekleyenleriIsle(
        araDurum,
        kaynak.akis('olay', tur: sonrakiTur),
      );
      araDurum = olaySonucu.durum;
      acilanOlaylar = olaySonucu.sonuclar;
    }
    guncelPortfoy = araDurum.portfoy;

    // 5. Portföy: kira geliri ve olgunlaşan satışlar — yeni fiyatlarla.
    final portfoySonucu = portfoy.turIsle(guncelPortfoy, araDurum.piyasa);
    guncelPortfoy = portfoySonucu.portfoy;
    final satisGeliri = portfoySonucu.satislar
        .fold<int>(0, (toplam, s) => toplam + s.tutar);

    // 6. İşletmeler — güncel endeksle. Kariyer maaşı geçen ocağın
    // endeksini kullanır ama işletme cirosu bu ayın fiyatlarıyla oluşur.
    final isletmeMotoru = isletme;
    final isletmeSonucu = isletmeMotoru == null || guncelIsletmeler.isEmpty
        ? null
        : isletmeMotoru.turIsle(
            isletmeler: guncelIsletmeler,
            ilgi: guncelIlgi,
            piyasa: yeniPiyasa,
            tur: sonrakiTur,
            akis: kaynak.akis('isletme', tur: sonrakiTur),
          );
    final isletmeKari = isletmeSonucu?.netNakit ?? 0;
    final isletmeDevirGeliri = isletmeSonucu?.tamamlananSatislar.values
            .fold<int>(0, (t, v) => t + v) ??
        0;

    // 7. Kredi taksitleri — YAŞAM GİDERİNDEN ÖNCE, çünkü banka maaş
    //    hesabından kendi payını önce çeker.
    //
    //    Taksit yalnız ARTIDA KALAN nakitten ödenir; eksiye düşerek taksit
    //    ödenemez. Aksi halde gecikme diye bir şey olmazdı: oyuncu sonsuza
    //    kadar eksi bakiyeye yazdırıp borcunu çevirirdi.
    final borcMotoruYerel = borc;
    final taksitOncesiNakit = araDurum.oyuncu.nakit +
        emirSonucu.nakitDegisimi +
        kariyerSonucu.netGelir +
        portfoySonucu.kiraGeliri +
        satisGeliri +
        isletmeKari +
        isletmeDevirGeliri;
    final borcSonucu = borcMotoruYerel == null || guncelBorclar.isEmpty
        ? null
        : borcMotoruYerel.turIsle(
            borclar: guncelBorclar,
            odenebilirNakit: taksitOncesiNakit < 0 ? 0 : taksitOncesiNakit,
            akis: kaynak.akis('borc', tur: sonrakiTur),
          );
    final odenenTaksit = borcSonucu?.odenenTaksit ?? 0;

    // 8. Yaşam gideri — güncel enflasyonla, maaş endeksiyle DEĞİL.
    final yasamGideri = _yasamGideri(durum.oyuncu.sehir, yeniPiyasa);

    // 9. Mahsuplaşma
    var oyuncu = araDurum.oyuncu;
    // Karşılaştırma tabanı kredi ÖNCESİ nakit: rapor "bu tur cebine ne
    // girdi" sorusunu yanıtlıyor, kredi de bir giriş.
    final onceki = durum.oyuncu.nakit;
    // Emirler ve olaylar nakiti zaten değiştirdi; faiz bunlardan sonraki
    // bakiyeye işler.
    final mahsupOncesi = oyuncu.nakit + emirSonucu.nakitDegisimi;
    var faizGideri = 0;
    if (mahsupOncesi < 0) {
      faizGideri = (-mahsupOncesi * ayarlar.eksiBakiyeFaizi).round();
    }
    oyuncu = oyuncu.copyWith(nakit: mahsupOncesi).nakitDegistir(
          kariyerSonucu.netGelir +
              portfoySonucu.kiraGeliri +
              satisGeliri +
              isletmeKari +
              isletmeDevirGeliri -
              odenenTaksit -
              yasamGideri -
              faizGideri,
        );
    if (isletmeSonucu != null && isletmeSonucu.itibarKatkisi != 0) {
      oyuncu = oyuncu.itibarDegistir(isletmeSonucu.itibarKatkisi);
    }
    if (borcSonucu != null && borcSonucu.krediNotuDegisimi != 0) {
      oyuncu = oyuncu.krediNotuDegistir(borcSonucu.krediNotuDegisimi);
    }
    oyuncu = oyuncu.krediNotuDegistir(
      oyuncu.nakit < 0
          ? -ayarlar.borcluKrediNotuDususu
          : ayarlar.duzenliKrediNotuArtisi,
    );

    // 10. Tur ilerlet
    oyuncu = oyuncu.turIlerlet();

    var yeniDurum = araDurum.copyWith(
      oyuncu: oyuncu,
      portfoy: guncelPortfoy,
      maasEndeksi: maasEndeksi,
    );
    yeniDurum = yeniDurum.copyWith(
      borclar: borcSonucu?.borclar ?? guncelBorclar,
    );
    if (isletmeSonucu != null) {
      // Devredilen işletmenin ilgi puanı da serbest kalmalı; yoksa oyuncu
      // sattığı işletmeye puan ayırmaya devam eder.
      var ilgi = guncelIlgi;
      for (final id in isletmeSonucu.tamamlananSatislar.keys) {
        ilgi = ilgi.kaldir(id);
      }
      yeniDurum = yeniDurum.copyWith(
        isletmeler: isletmeSonucu.isletmeler,
        ilgi: ilgi,
      );
    } else {
      // Motor çalışmadıysa (ilk işletme bu turda kuruldu ve listede
      // başka yoktu) komutun sonucu yine de duruma girmeli.
      yeniDurum = yeniDurum.copyWith(
        isletmeler: guncelIsletmeler,
        ilgi: guncelIlgi,
      );
    }

    return TurSonucu(
      durum: yeniDurum,
      rapor: TurRaporu(
        tur: sonrakiTur,
        yas: oyuncu.yas,
        ay: oyuncu.ay,
        netGelir: kariyerSonucu.netGelir,
        yasamGideri: yasamGideri,
        faizGideri: faizGideri,
        nakitDegisimi: oyuncu.nakit - onceki,
        rejim: yeniPiyasa.rejim,
        rejimDegisti: rejimDegisti,
        aylikEnflasyon: yeniPiyasa.sonAylikEnflasyon,
        maasZammiYapildi: zamZamani,
        paraReformuYapildi: yeniPiyasa.paraReformuYapildi,
        performans: kariyerSonucu.performans,
        kiraGeliri: portfoySonucu.kiraGeliri,
        portfoyDegeri: yeniDurum.portfoyDegeri,
        netDeger: yeniDurum.netDeger,
        emirSonuclari: emirSonucu.sonuclar,
        tamamlananSatislar: portfoySonucu.satislar,
        acilanOlaylar: acilanOlaylar,
        isletmeKari: isletmeKari,
        odenenTaksit: odenenTaksit,
        cekilenKredi: krediSonucu.borc?.anapara ?? 0,
        celpGeldi: kariyerSonucu.celpGeldi,
        askereAlindi: kariyerSonucu.askereAlindi,
        atamasiCikti: kariyerSonucu.atamasiCikti,
        iseGirildi: iseGirildi,
        krediHatasi: krediSonucu.hata,
        toplamBorc: yeniDurum.toplamBorc,
        kapananKrediler: borcSonucu?.kapananlar ?? const [],
        gecikenKrediler: borcSonucu?.gecikenler ?? const [],
        takibeDusenKrediler: borcSonucu?.takibeDusenler ?? const [],
        isletmeRaporlari: isletmeSonucu?.raporlar ?? const [],
        devredilenIsletmeler: isletmeSonucu?.tamamlananSatislar ?? const {},
        terfiEtti: kariyerSonucu.terfiEtti,
        yeniKademeAdi: kariyerSonucu.yeniKademeAdi,
        istenCikarildi: kariyerSonucu.istenCikarildi,
        mezunOldu: kariyerSonucu.mezunOldu,
        askerlikBitti: kariyerSonucu.askerlikBitti,
        kurulanIsletmeId: kurulanIsletmeId,
        satisaCikanIsletmeId: satisaCikanIsletmeId,
        isletmeHatasi: isletmeHatasi,
      ),
    );
  }

  /// "3 ay atla" / "1 yıl atla": aynı kararla birden çok tur işler.
  ///
  /// Oyuncunun dikkatini gerektiren bir şey olursa (kovulma, terfi, mezuniyet,
  /// para reformu) atlama ERKEN BİTER — oyuncu farkında olmadan hayatının
  /// dönüm noktasını geçmesin.
  ({OyunDurumu durum, List<TurRaporu> raporlar}) turlariAtla(
    OyunDurumu durum,
    TurGirdisi girdi,
    int adet,
  ) {
    var guncel = durum;
    final raporlar = <TurRaporu>[];
    for (var i = 0; i < adet; i++) {
      // Karar kartı çıkacaksa atlamadan önce dur; oyuncu görmeden geçmesin.
      // Kart çekme saf olduğu için buradaki bakış oyunu bozmaz: aynı akış
      // sonradan tekrar çekildiğinde aynı desteyi verir.
      if (i > 0 && _kartVar(guncel)) break;
      final sonuc = turuBitir(guncel, girdi);
      guncel = sonuc.durum;
      raporlar.add(sonuc.rapor);
      if (_dikkatGerektirir(sonuc.rapor)) break;
    }
    return (durum: guncel, raporlar: raporlar);
  }

  /// Bu turda oyuncuya kart çıkacak mı.
  bool _kartVar(OyunDurumu durum) {
    final motor = olay;
    if (motor == null) return false;
    final akis =
        RastgeleKaynak(durum.anaTohum).akis('olay_deste', tur: durum.tur + 1);
    return !motor.desteCek(durum, akis).bosMu;
  }

  /// Bu turun destesi. UI turu başlatırken çağırır.
  OlayDestesi desteCek(OyunDurumu durum) {
    final motor = olay;
    if (motor == null) return const OlayDestesi([]);
    return motor.desteCek(
      durum,
      RastgeleKaynak(durum.anaTohum).akis('olay_deste', tur: durum.tur + 1),
    );
  }

  /// Bankanın oyuncuya bugün sunduğu krediler.
  ///
  /// UI'ın ayrıca hesap yapmaması için burada: ekran başka bir gelirle
  /// teklif üretseydi oyuncu gördüğü tutarı isteyip reddedilirdi.
  /// `krediCek` ile AYNI gelir tabanını (bordro) kullanıyor.
  List<KrediTeklifi> krediTeklifleri(OyunDurumu durum) {
    final motor = borc;
    if (motor == null) return const [];
    return motor.teklifler(
      oyuncu: durum.oyuncu,
      borclar: durum.borclar,
      piyasa: durum.piyasa,
      aylikGelir: bordroGeliri(durum),
    );
  }

  /// Bankanın baktığı maaş belgesi tutarı.
  int bordroGeliri(OyunDurumu durum) => kariyer.bordroMaasi(
        durum.oyuncu,
        katalog,
        durum.piyasa,
        durum.maasEndeksi,
      );

  /// Oyuncunun kart seçimini uygular.
  ///
  /// Akış adına KART KİMLİĞİ giriyor. `RastgeleKaynak.akis` aynı üçlü için
  /// akışı baştan verdiğinden, tek isim kullanılsaydı aynı turdaki iki
  /// kartın dalı aynı zarla çözülür ve sonuçlar birbirine kilitlenirdi.
  ///
  /// Zar, seçilen SEÇENEĞE bağlı değil: oyuncu aynı kartta A yerine B'yi
  /// seçince zar yeniden atılmaz. Kayıt/yükleme geldiğinde "beğenmediğim
  /// sonucu geri al, aynı seçeneği tekrar dene" işe yaramayacak.
  SecimSonucu secimUygula(OyunDurumu durum, Olay kart, int secenekIndeksi) {
    final motor = olay;
    if (motor == null) return SecimSonucu(durum: durum);
    return motor.secimYap(
      durum,
      kart,
      secenekIndeksi,
      RastgeleKaynak(durum.anaTohum)
          .akis('olay_secim:${kart.id}', tur: durum.tur + 1),
    );
  }

  bool _dikkatGerektirir(TurRaporu r) =>
      r.acilanOlaylar.isNotEmpty ||
      r.devredilenIsletmeler.isNotEmpty ||
      // Taksit kaçırmak ve takibe düşmek fark edilmeden geçilmemeli.
      r.gecikenKrediler.isNotEmpty ||
      // Hayatın dönüm noktaları: farkında olmadan geçilmesin.
      r.celpGeldi ||
      r.askereAlindi ||
      r.atamasiCikti ||
      r.kapananKrediler.isNotEmpty ||
      // İhmal edilen işletme kriz eşiğine geldi: oyuncu farkında olmadan
      // işletmesini batırmasın diye atlama burada kesilir.
      r.isletmeRaporlari.any((i) => i.krizRiski) ||
      r.tamamlananSatislar.isNotEmpty ||
      r.istenCikarildi ||
      r.terfiEtti ||
      r.mezunOldu ||
      r.askerlikBitti ||
      // Kurulan ya da satışa çıkarılan işletme oyuncunun dönüm noktası;
      // farkında olmadan üstünden geçilmesin.
      r.kurulanIsletmeId != null ||
      r.satisaCikanIsletmeId != null ||
      r.isletmeHatasi != null ||
      r.paraReformuYapildi;

  /// Aylık yaşam gideri: şehir çarpanı × güncel fiyat seviyesi.
  int _yasamGideri(Sehir sehir, PiyasaDurumu piyasaDurumu) =>
      (ayarlar.tabanYasamGideri *
              sehir.giderCarpani *
              piyasaDurumu.enflasyonEndeksi)
          .round();
}

/// Kariyer durumundan bağımsız yardımcılar için kısayol.
extension OyunDurumuKisayollari on OyunDurumu {
  bool get calisiyor => oyuncu.kariyer is Calisan;
}
