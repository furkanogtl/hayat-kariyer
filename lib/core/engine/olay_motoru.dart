import '../models/isletme.dart';
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

  /// Ölçek 1,0'ın karşılığı: kariyer başı bir aylık gelir, TABAN TL.
  ///
  /// Kart tutarları bu maaşa göre yazıldı. 2026 ölçeğinde asgari ücret
  /// ~26.000 varsayıldığı için referans onun biraz üstü.
  final int olcekReferansGeliri = 35000;

  /// Ölçek çarpanının tavanı.
  final double olcekTavani = 8.0;

  /// Ölçek üssü — gelirle DOĞRUSAL değil, altdoğrusal büyür.
  ///
  /// Doğrusal (üs 1) denendi ve fazla sertti: ölçüldü, 33 yıllık yatırım
  /// yapan oyuncunun reel net değeri kartsız 96,2M iken kartlarla 6,1M'ye
  /// iniyordu. Kartların bedeli %94. Sebep yalnız tutar değil bileşiklenme:
  /// karta giden her lira on yıllarca büyümüyor.
  ///
  /// Altdoğrusal olması aynı zamanda daha doğru: düğün takısı gelirle
  /// birlikte büyür, bozulan buzdolabı pek büyümez. Geliri 14 katına çıkan
  /// oyuncunun kart bedeli ~5 katına çıkıyor.
  final double olcekUssu = 0.65;

  /// Serveti gelire çeviren bölen. Çalışmayan ama zengin oyuncunun
  /// (emekli, işini bırakmış yatırımcı) ölçeği sıfıra düşmesin diye:
  /// yıllık %4 çekim ≈ servetin 300'de biri aylık.
  final int servetGelirBoleni = 300;

  /// Bahsi oyuncunun ölçeğine göre önemsiz kalan kartın ağırlığı buraya
  /// kadar söner. SIFIR DEĞİL: zengin adamın da buzdolabı bozulur, ama
  /// bu ayın ana olayı o olmamalı.
  final double onemsizAgirlikTabani = 0.15;

  /// Kartın tam ağırlığı koruması için bahsinin aylık ölçeğe oranı.
  /// Bunun altında sönüm başlar.
  final double onemsizlikEsigi = 0.30;
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
    this.isletmeKartlari = const {},
    this.ayarlar = const OlayAyarlari(),
  });

  final OlayKatalogu katalog;

  /// Olay kimliği → işletme tanım kimliği.
  /// `IsletmeKatalogu.olayHavuzuDizini()` üretir. Boşsa işletme kartı yok
  /// demektir; motor işletme sistemi olmadan da çalışır.
  final Map<String, String> isletmeKartlari;

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
      if (!olay.kosullar.uygunMu(
        durum.oyuncu,
        durum.piyasa,
        reelNetDeger: durum.reelNetDeger,
      )) {
        continue;
      }
      // İşletme kartı, o işletmeye sahip olmayana çıkmaz.
      if (isletmeKartlari.containsKey(olay.id) &&
          hedefIsletme(olay, durum) == null) {
        continue;
      }
      sonuc.add(olay);
    }
    return sonuc;
  }

  /// Bu tur oyuncuya sunulacak kartları seçer.
  ///
  /// Aynı kart bir destede iki kez çıkmaz. Deste boş dönebilir; her tur
  /// karar vermek zorunda kalmak yorucu olurdu.
  OlayDestesi desteCek(
    OyunDurumu durum,
    RastgeleAkis akis, {
    double olcek = 1.0,
  }) {
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
        [for (final o in kalanlar) _agirlik(o, durum, olcek)],
      );
      secilenler.add(kalanlar.removeAt(indeks));
    }
    return OlayDestesi(secilenler);
  }

  /// Kartın hedef aldığı işletme örneği. İşletme kartı değilse ya da uygun
  /// örnek yoksa null.
  ///
  /// Aynı türden iki işletme varsa en çok ihmal edileni seçilir; kart zaten
  /// çoğunlukla ihmalin bedelini anlatıyor. Eşitlikte kimlik sırası —
  /// seçim belirlenimli olmalı, kayıt tekrar üretilebilsin.
  Isletme? hedefIsletme(Olay olay, OyunDurumu durum) {
    final tanimId = isletmeKartlari[olay.id];
    if (tanimId == null) return null;

    final adaylar = durum.isletmeler
        .where((i) => i.tanimId == tanimId && !i.satista)
        .where((i) =>
            olay.kosullar.enAzIhmalTuru == null ||
            i.ihmalTuru >= olay.kosullar.enAzIhmalTuru!)
        .toList()
      ..sort((a, b) {
        final fark = b.ihmalTuru.compareTo(a.ihmalTuru);
        return fark != 0 ? fark : a.id.compareTo(b.id);
      });
    return adaylar.isEmpty ? null : adaylar.first;
  }

  /// Kartın seçim havuzundaki ağırlığı.
  ///
  /// İki çarpan var: fırsat kartları itibara bağlı (anayasa: "itibar fırsat
  /// kartlarının KALİTESİNİ belirler"), ve bahsi oyuncunun ölçeğine göre
  /// önemsiz kalan kartlar sönüyor.
  double _agirlik(Olay olay, OyunDurumu durum, double olcek) {
    var agirlik = olay.agirlik;
    if (olay.tur == OlayTuru.firsat) {
      agirlik *=
          ayarlar.firsatTabani + durum.oyuncu.itibar / ayarlar.firsatBoleni;
    }
    return agirlik * _onemKatsayisi(olay, olcek);
  }

  /// Kartın bahsi oyuncunun ölçeğine göre ne kadar anlamlı.
  ///
  /// Ölçüldü: 141 kartın 85'i 50.000 taban TL'nin altında bahis taşıyor.
  /// Bu kartlar oyunun ilk 8 yılı için yazıldı; oyuncunun geliri 20 katına
  /// çıktıktan sonra da tam ağırlıkla çıkmaya devam ediyorlardı ve "her yıl
  /// aynı sıkıntılar" hissini üreten şey buydu.
  ///
  /// Sönüm SIFIRA gitmiyor: zengin adamın da buzdolabı bozulur. Değişen,
  /// o ayın ana olayının bu olmaması.
  ///
  /// Bahsi olmayan kart (yalnız mutluluk/enerji/itibar) hiç sönmez —
  /// onların ölçekle bir işi yok. Ölçeklenen kart da sönmez, bahsi zaten
  /// oyuncuyla birlikte büyüyor.
  double _onemKatsayisi(Olay olay, double olcek) {
    if (olay.olcekli) return 1;
    final bahis = olay.parasalBuyukluk;
    if (bahis == 0) return 1;

    final aylik = ayarlar.olcekReferansGeliri * olcek;
    final oran = bahis / (aylik * ayarlar.onemsizlikEsigi);
    if (oran >= 1) return 1;
    return ayarlar.onemsizAgirlikTabani +
        (1 - ayarlar.onemsizAgirlikTabani) * oran;
  }

  /// Oyuncunun bir seçeneği seçmesini işler.
  SecimSonucu secimYap(
    OyunDurumu durum,
    Olay olay,
    int secenekIndeksi,
    RastgeleAkis akis, {
    double olcek = 1.0,
  }) {
    final secenek =
        olay.secenekler[secenekIndeksi.clamp(0, olay.secenekler.length - 1)];
    final hedefId = hedefIsletme(olay, durum)?.id;
    final nakitCarpani = olay.olcekli ? olcek : 1.0;

    var guncel =
        _etkileriUygula(durum, secenek.etkiler, hedefId, nakitCarpani);
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
              hedefIsletmeId: hedefId,
            ),
          ],
        ),
        beklemeyeAlindi: true,
      );
    }

    final sonuc = _dalSec(secenek, akis);
    return SecimSonucu(
      durum: _etkileriUygula(guncel, sonuc.etkiler, hedefId, nakitCarpani),
      acilanSonuc: sonuc,
    );
  }

  /// Bekleyen kararların sayacını ilerletir, zamanı gelenleri çözer.
  ({OyunDurumu durum, List<AcigaCikanSonuc> sonuclar}) bekleyenleriIsle(
    OyunDurumu durum,
    RastgeleAkis akis, {
    double olcek = 1.0,
  }) {
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
      // Ölçek AÇIĞA ÇIKTIĞI andaki: para bugün eline geçiyor. Karar
      // anındaki ölçeği saklamak kayda bir alan daha eklerdi ve ölçeklenen
      // kartlar zaten gecikmesiz hayat kartları.
      guncel = _etkileriUygula(
        guncel,
        sonuc.etkiler,
        bekleyen.hedefIsletmeId,
        olay.olcekli ? olcek : 1.0,
      );
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
  OyunDurumu _etkileriUygula(
    OyunDurumu durum,
    OlayEtkileri etkiler, [
    String? hedefIsletmeId,
    double nakitCarpani = 1.0,
  ]) {
    if (etkiler.bosMu) return durum;

    var oyuncu = durum.oyuncu;
    if (etkiler.nakit != 0) {
      final taban = (etkiler.nakit * nakitCarpani).round();
      oyuncu = oyuncu.nakitDegistir(durum.piyasa.endeksle(taban));
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

    var isletmeler = durum.isletmeler;
    if (etkiler.isletmeStat.isNotEmpty && hedefIsletmeId != null) {
      isletmeler = [
        for (final i in isletmeler)
          if (i.id != hedefIsletmeId)
            i
          else
            etkiler.isletmeStat.entries.fold(
              i,
              (guncel, g) => guncel.statDegistir(g.key, g.value),
            ),
      ];
    }

    return durum.copyWith(
      oyuncu: oyuncu,
      piyasa: piyasa,
      portfoy: portfoy,
      isletmeler: isletmeler,
    );
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
