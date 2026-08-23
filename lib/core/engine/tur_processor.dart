import '../models/kariyer_durumu.dart';
import '../models/meslek_katalogu.dart';
import '../models/oyun_durumu.dart';
import '../models/oyuncu.dart';
import '../models/piyasa_durumu.dart';
import '../models/sehir.dart';
import '../models/zaman_dagilimi.dart';
import '../rng/rastgele_kaynak.dart';
import 'kariyer_motoru.dart';
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
///   4. Kira geliri ve olgunlaşan gecikmeli satışlar — YENİ fiyatlarla
///   5. Yaşam gideri düşer — GÜNCEL enflasyonla
///   6. Nakit mahsuplaşır, eksi bakiye faiz işletir, kredi notu güncellenir
///   7. Tur ilerler (yaş, kariyer sayaçları, SGK primi)
///
/// 0. adımın piyasadan ÖNCE olması bilinçli: oyuncu ekranda gördüğü fiyattan
/// alır, sonra piyasa oynar. Aksi halde "aldığım fiyat bu değildi" olurdu.
///
/// 3. ve 5. adımın farklı endeks kullanması da bilinçli: maaş yılda bir
/// zamlanır, market her ay zamlanır. Aradaki makas oyunun ana baskısıdır.
class TurProcessor {
  TurProcessor({
    required this.katalog,
    PiyasaSimulatoru? piyasa,
    PortfoyMotoru? portfoy,
    this.kariyer = const KariyerMotoru(),
    this.ayarlar = const TurAyarlari(),
  })  : piyasa = piyasa ?? PiyasaSimulatoru(),
        portfoy = portfoy ?? PortfoyMotoru();

  final MeslekKatalogu katalog;
  final PiyasaSimulatoru piyasa;
  final PortfoyMotoru portfoy;
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

    // 4. Portföy: kira geliri ve olgunlaşan satışlar — yeni fiyatlarla.
    final portfoySonucu = portfoy.turIsle(guncelPortfoy, yeniPiyasa);
    guncelPortfoy = portfoySonucu.portfoy;
    final satisGeliri = portfoySonucu.satislar
        .fold<int>(0, (toplam, s) => toplam + s.tutar);

    // 5. Yaşam gideri — güncel enflasyonla, maaş endeksiyle DEĞİL.
    final yasamGideri = _yasamGideri(durum.oyuncu.sehir, yeniPiyasa);

    // 6. Mahsuplaşma
    var oyuncu = kariyerSonucu.oyuncu;
    final onceki = durum.oyuncu.nakit;
    var faizGideri = 0;
    final emirSonrasiNakit = onceki + emirSonucu.nakitDegisimi;
    if (emirSonrasiNakit < 0) {
      faizGideri = (-emirSonrasiNakit * ayarlar.eksiBakiyeFaizi).round();
    }
    oyuncu = oyuncu.copyWith(nakit: emirSonrasiNakit).nakitDegistir(
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

    // 7. Tur ilerlet
    oyuncu = oyuncu.turIlerlet();

    final yeniDurum = durum.copyWith(
      oyuncu: oyuncu,
      piyasa: yeniPiyasa,
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
      final sonuc = turuBitir(guncel, girdi);
      guncel = sonuc.durum;
      raporlar.add(sonuc.rapor);
      if (_dikkatGerektirir(sonuc.rapor)) break;
    }
    return (durum: guncel, raporlar: raporlar);
  }

  bool _dikkatGerektirir(TurRaporu r) =>
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
