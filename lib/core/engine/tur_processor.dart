import '../models/kariyer_durumu.dart';
import '../models/meslek_katalogu.dart';
import '../models/oyun_durumu.dart';
import '../models/oyuncu.dart';
import '../models/piyasa_durumu.dart';
import '../models/sehir.dart';
import '../models/zaman_dagilimi.dart';
import '../rng/rastgele_kaynak.dart';
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
    this.emirSonuclari = const [],
    this.tamamlananSatislar = const [],
    this.acilanOlaylar = const [],
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
/// Şimdilik yalnızca zaman dağıtımı; olay kararları ve alım-satım emirleri
/// eklendikçe buraya girecek. Girdinin tek bir nesnede toplanması, "3 ay
/// atla" gibi toplu ilerlemeyi ve testte senaryo kurmayı kolaylaştırıyor.
class TurGirdisi {
  const TurGirdisi({required this.zaman, this.emirler = const []});

  TurGirdisi.varsayilan()
      : zaman = ZamanDagilimi.dengeli(),
        emirler = const [];

  final ZamanDagilimi zaman;

  /// Yatırım ekranında verilen alım-satım emirleri.
  final List<Emir> emirler;
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
///   6. Yaşam gideri düşer — GÜNCEL enflasyonla
///   7. Nakit mahsuplaşır, eksi bakiye faiz işletir, kredi notu güncellenir
///   8. Tur ilerler (yaş, kariyer sayaçları, SGK primi)
///
/// 0. adımın piyasadan ÖNCE olması bilinçli: oyuncu ekranda gördüğü fiyattan
/// alır, sonra piyasa oynar. Aksi halde "aldığım fiyat bu değildi" olurdu.
///
/// 3. ve 6. adımın farklı endeks kullanması da bilinçli: maaş yılda bir
/// zamlanır, market her ay zamlanır. Aradaki makas oyunun ana baskısıdır.
class TurProcessor {
  TurProcessor({
    required this.katalog,
    PiyasaSimulatoru? piyasa,
    PortfoyMotoru? portfoy,
    this.olay,
    this.kariyer = const KariyerMotoru(),
    this.ayarlar = const TurAyarlari(),
  })  : piyasa = piyasa ?? PiyasaSimulatoru(),
        portfoy = portfoy ?? PortfoyMotoru();

  final MeslekKatalogu katalog;
  final PiyasaSimulatoru piyasa;
  final PortfoyMotoru portfoy;

  /// Olay motoru isteğe bağlı: kart sistemi olmadan da tur işlenebilir
  /// (denge simülasyonları kartsız çalışıyor).
  final OlayMotoru? olay;
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

    // 0. Emirler — oyuncunun gördüğü fiyatlarla, piyasa oynamadan önce.
    final emirSonucu = portfoy.emirleriIsle(
      durum.portfoy,
      durum.oyuncu.nakit,
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
      oyuncu: durum.oyuncu,
      katalog: katalog,
      piyasa: yeniPiyasa,
      zaman: girdi.zaman,
      akis: kaynak.akis('kariyer', tur: sonrakiTur),
      maasEndeksi: maasEndeksi,
    );

    // 4. Gecikmeli olay sonuçları. Kariyerden sonra, gider mahsuplaşmasından
    //    önce: açığa çıkan para bu ayın bilançosuna girsin.
    var araDurum = durum.copyWith(
      oyuncu: kariyerSonucu.oyuncu,
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

    // 6. Yaşam gideri — güncel enflasyonla, maaş endeksiyle DEĞİL.
    final yasamGideri = _yasamGideri(durum.oyuncu.sehir, yeniPiyasa);

    // 7. Mahsuplaşma
    var oyuncu = araDurum.oyuncu;
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
              satisGeliri -
              yasamGideri -
              faizGideri,
        );
    oyuncu = oyuncu.krediNotuDegistir(
      oyuncu.nakit < 0
          ? -ayarlar.borcluKrediNotuDususu
          : ayarlar.duzenliKrediNotuArtisi,
    );

    // 8. Tur ilerlet
    oyuncu = oyuncu.turIlerlet();

    final yeniDurum = araDurum.copyWith(
      oyuncu: oyuncu,
      portfoy: guncelPortfoy,
      maasEndeksi: maasEndeksi,
    );

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
        terfiEtti: kariyerSonucu.terfiEtti,
        yeniKademeAdi: kariyerSonucu.yeniKademeAdi,
        istenCikarildi: kariyerSonucu.istenCikarildi,
        mezunOldu: kariyerSonucu.mezunOldu,
        askerlikBitti: kariyerSonucu.askerlikBitti,
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

  bool _dikkatGerektirir(TurRaporu r) =>
      r.acilanOlaylar.isNotEmpty ||
      r.tamamlananSatislar.isNotEmpty ||
      r.istenCikarildi ||
      r.terfiEtti ||
      r.mezunOldu ||
      r.askerlikBitti ||
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
