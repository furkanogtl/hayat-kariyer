import '../models/olay.dart';
import '../models/olay_katalogu.dart';
import '../models/oyun_durumu.dart';
import '../models/portfoy.dart';
import '../rng/rastgele_akis.dart';

/// Olay sisteminin denge sabitleri.
class OlayAyarlari {
  const OlayAyarlari();

  /// Bir turda çıkabilecek en fazla kart. Anayasa: 1-3.
  final int enFazlaKart = 3;

  /// İkinci ve üçüncü kartın çıkma ihtimali.
  final double ikinciKartSansi = 0.35;
  final double ucuncuKartSansi = 0.15;

  /// Bir turda kart çıkma ihtimali.
  ///
  /// Bilerek düşük: 480 turluk bir oyunda her tur kart çıksaydı oyuncu 360
  /// karar verirdi ve 30-45 dakikalık oturum hedefi tutmazdı. %25 ile bir
  /// oyunda ~120 karar düşüyor ve "tur atla" ortalama 4 turda bir kesiliyor —
  /// yani atlamak "bir şey olana kadar ilerle" anlamına geliyor.
  final double kartCikmaSansi = 0.25;

  /// Fırsat kartlarının ağırlığı bu formülle itibara bağlanır:
  /// `agirlik * (firsatTabani + itibar / firsatBoleni)`.
  ///
  /// Anayasadaki "itibar fırsat kartlarının KALİTESİNİ belirler" kuralının
  /// somut karşılığı. İtibarsız oyuncu (0) fırsatları %40 ağırlıkla görür,
  /// itibarı tavan olan (100) 2,4 katıyla.
  final double firsatTabani = 0.4;
  final double firsatBoleni = 50.0;
}

/// Oyuncuya sunulan kart destesi.
class OlayDestesi {
  const OlayDestesi(this.kartlar);

  final List<Olay> kartlar;

  bool get bosMu => kartlar.isEmpty;
}

/// Açığa çıkan gecikmeli sonuç. UI bunu "hatırlıyor musun?" kartı olarak
/// gösterir.
class AcigaCikanSonuc {
  const AcigaCikanSonuc({
    required this.olay,
    required this.secenek,
    required this.sonuc,
  });

  final Olay olay;
  final OlaySecenegi secenek;
  final OlaySonucu sonuc;
}

/// Bir seçimin oyuna yansıması.
class SecimSonucu {
  const SecimSonucu({
    required this.durum,
    this.acilanSonuc,
    this.beklemeyeAlindi = false,
  });

  final OyunDurumu durum;

  /// Anında çözülen dal; gecikmeli seçimlerde null.
  final OlaySonucu? acilanSonuc;

  /// Sonuç turlar sonra açığa çıkacak.
  final bool beklemeyeAlindi;
}

/// Olay kartlarını seçer, sonuçlarını uygular.
///
/// Rastgelelik yalnızca dışarıdan verilen akıştan gelir. Kart çekme işlemi
/// SAF: aynı durumla aynı akış aynı desteyi verir, bu yüzden "atlarken kart
/// var mı" diye bakmak oyunu bozmaz.
class OlayMotoru {
  const OlayMotoru({
    required this.katalog,
    this.ayarlar = const OlayAyarlari(),
  });

  final OlayKatalogu katalog;
  final OlayAyarlari ayarlar;

  /// Oyuncunun şu anda karşılaşabileceği kartlar.
  List<Olay> uygunKartlar(OyunDurumu durum) {
    final sonuc = <Olay>[];
    for (final olay in katalog.tumu) {
      final gorulduguTur = durum.olayGecmisi[olay.id];
      if (gorulduguTur != null) {
        if (olay.tekSeferlik) continue;
        if (durum.tur - gorulduguTur < olay.bekleme) continue;
      }
      if (!olay.kosullar.uygunMu(durum.oyuncu, durum.piyasa)) continue;
      sonuc.add(olay);
    }
    return sonuc;
  }

  /// Bu tur oyuncuya sunulacak kartları seçer.
  ///
  /// Aynı kart bir destede iki kez çıkmaz. Deste boş dönebilir; her tur
  /// karar vermek zorunda kalmak yorucu olurdu.
  OlayDestesi desteCek(OyunDurumu durum, RastgeleAkis akis) {
    if (!akis.sans(ayarlar.kartCikmaSansi)) return const OlayDestesi([]);

    final havuz = uygunKartlar(durum);
    if (havuz.isEmpty) return const OlayDestesi([]);

    var adet = 1;
    if (akis.sans(ayarlar.ikinciKartSansi)) adet++;
    if (adet == 2 && akis.sans(ayarlar.ucuncuKartSansi)) adet++;
    if (adet > ayarlar.enFazlaKart) adet = ayarlar.enFazlaKart;

    final kalanlar = [...havuz];
    final secilenler = <Olay>[];
    for (var i = 0; i < adet && kalanlar.isNotEmpty; i++) {
      final indeks = akis.agirlikliIndeks(
        [for (final o in kalanlar) _agirlik(o, durum)],
      );
      secilenler.add(kalanlar.removeAt(indeks));
    }
    return OlayDestesi(secilenler);
  }

  /// Kartın seçim havuzundaki ağırlığı. Fırsat kartları itibara bağlıdır.
  double _agirlik(Olay olay, OyunDurumu durum) {
    if (olay.tur != OlayTuru.firsat) return olay.agirlik;
    final carpan =
        ayarlar.firsatTabani + durum.oyuncu.itibar / ayarlar.firsatBoleni;
    return olay.agirlik * carpan;
  }

  /// Oyuncunun bir seçeneği seçmesini işler.
  SecimSonucu secimYap(
    OyunDurumu durum,
    Olay olay,
    int secenekIndeksi,
    RastgeleAkis akis,
  ) {
    final secenek =
        olay.secenekler[secenekIndeksi.clamp(0, olay.secenekler.length - 1)];

    var guncel = _etkileriUygula(durum, secenek.etkiler);
    guncel = guncel.copyWith(
      olayGecmisi: {...guncel.olayGecmisi, olay.id: durum.tur},
    );

    if (!secenek.dallaniyor) {
      return SecimSonucu(durum: guncel);
    }

    if (secenek.gecikmeli) {
      return SecimSonucu(
        durum: guncel.copyWith(
          bekleyenOlaylar: [
            ...guncel.bekleyenOlaylar,
            BekleyenOlay(
              olayId: olay.id,
              secenekIndeksi: secenekIndeksi,
              kalanTur: secenek.gecikmeTuru,
            ),
          ],
        ),
        beklemeyeAlindi: true,
      );
    }

    final sonuc = _dalSec(secenek, akis);
    return SecimSonucu(
      durum: _etkileriUygula(guncel, sonuc.etkiler),
      acilanSonuc: sonuc,
    );
  }

  /// Bekleyen kararların sayacını ilerletir, zamanı gelenleri çözer.
  ({OyunDurumu durum, List<AcigaCikanSonuc> sonuclar}) bekleyenleriIsle(
    OyunDurumu durum,
    RastgeleAkis akis,
  ) {
    if (durum.bekleyenOlaylar.isEmpty) {
      return (durum: durum, sonuclar: const []);
    }

    var guncel = durum;
    final kalanlar = <BekleyenOlay>[];
    final acilanlar = <AcigaCikanSonuc>[];

    for (final bekleyen in durum.bekleyenOlaylar) {
      final ilerlemis = bekleyen.turIlerlet();
      if (!ilerlemis.zamaniGeldi) {
        kalanlar.add(ilerlemis);
        continue;
      }
      final olay = katalog.bul(bekleyen.olayId);
      if (olay == null) continue; // Kart silinmiş: sessizce düşür.
      final secenek = olay.secenekler[
          bekleyen.secenekIndeksi.clamp(0, olay.secenekler.length - 1)];
      final sonuc = _dalSec(secenek, akis);
      guncel = _etkileriUygula(guncel, sonuc.etkiler);
      acilanlar.add(
        AcigaCikanSonuc(olay: olay, secenek: secenek, sonuc: sonuc),
      );
    }

    return (
      durum: guncel.copyWith(bekleyenOlaylar: kalanlar),
      sonuclar: acilanlar,
    );
  }

  OlaySonucu _dalSec(OlaySecenegi secenek, RastgeleAkis akis) =>
      secenek.sonuclar[
          akis.agirlikliIndeks([for (final s in secenek.sonuclar) s.sans])];

  /// Etkileri oyun durumuna uygular.
  ///
  /// Para tutarları TABAN TL yazıldığı için enflasyon endeksiyle çarpılır;
  /// stat değişimleri doğrudan uygulanır (onlar zaten ölçeksiz).
  OyunDurumu _etkileriUygula(OyunDurumu durum, OlayEtkileri etkiler) {
    if (etkiler.bosMu) return durum;

    var oyuncu = durum.oyuncu;
    if (etkiler.nakit != 0) {
      oyuncu = oyuncu.nakitDegistir(durum.piyasa.endeksle(etkiler.nakit));
    }
    if (etkiler.enerji != 0) oyuncu = oyuncu.enerjiDegistir(etkiler.enerji);
    if (etkiler.mutluluk != 0) {
      oyuncu = oyuncu.mutlulukDegistir(etkiler.mutluluk);
    }
    if (etkiler.itibar != 0) oyuncu = oyuncu.itibarDegistir(etkiler.itibar);
    if (etkiler.krediNotu != 0) {
      oyuncu = oyuncu.krediNotuDegistir(etkiler.krediNotu);
    }
    for (final g in etkiler.yetkinlik.entries) {
      oyuncu = oyuncu.yetkinlikDegistir(g.key, g.value);
    }

    var piyasa = durum.piyasa;
    for (final g in etkiler.fiyatCarpani.entries) {
      piyasa = piyasa.fiyatiCarp(g.key, g.value);
    }

    var portfoy = durum.portfoy;
    for (final g in etkiler.varlik.entries) {
      portfoy = _varlikDegistir(portfoy, g.key, g.value, piyasa.fiyat(g.key));
    }

    return durum.copyWith(oyuncu: oyuncu, piyasa: piyasa, portfoy: portfoy);
  }

  /// Olayla gelen (ya da giden) varlık. Hediye edilen varlığın maliyeti
  /// güncel piyasa fiyatı sayılır; böylece kâr/zarar göstergesi bozulmaz.
  Portfoy _varlikDegistir(
    Portfoy portfoy,
    String varlikId,
    double adet,
    double fiyat,
  ) {
    final mevcut = portfoy.pozisyonlar[varlikId];
    final yeniAdet = (mevcut?.adet ?? 0) + adet;
    if (yeniAdet <= 1e-9) {
      final kalanlar = {...portfoy.pozisyonlar}..remove(varlikId);
      return portfoy.copyWith(pozisyonlar: kalanlar);
    }
    final yeniMaliyet = adet > 0
        ? ((mevcut?.maliyet() ?? 0) + adet * fiyat) / yeniAdet
        : (mevcut?.ortalamaMaliyet ?? fiyat);
    return portfoy.copyWith(
      pozisyonlar: {
        ...portfoy.pozisyonlar,
        varlikId: Pozisyon(adet: yeniAdet, ortalamaMaliyet: yeniMaliyet),
      },
    );
  }
}
