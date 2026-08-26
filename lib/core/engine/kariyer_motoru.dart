import 'dart:math' as math;

import '../models/kariyer_durumu.dart';
import '../models/meslek.dart';
import '../models/meslek_katalogu.dart';
import '../models/oyuncu.dart';
import '../models/piyasa_durumu.dart';
import '../models/varlik.dart';
import '../models/zaman_dagilimi.dart';
import '../rng/rastgele_akis.dart';

/// Kariyer motorunun denge sabitleri. Hepsi tek yerde tutuluyor ki ayarlama
/// sırasında kodun içinde sayı aramak gerekmesin.
class KariyerAyarlari {
  const KariyerAyarlari();

  /// Yetkinlik artışına eğitim ve çalışma puanı başına katkı.
  final double egitimKatkisi = 0.9;
  final double calismaKatkisi = 0.25;

  /// Öğrencilikte eğitim katkısı bu çarpanla artar — okumanın karşılığı.
  final double ogrenciCarpani = 1.8;

  /// İtibar artışına network puanı başına katkı.
  final double networkKatkisi = 1.0;

  /// İtibar her tur mevcut değerinin bu oranı kadar aşınır.
  ///
  /// Önce sabit bir aşınmaydı (0,6) ve YALNIZ network'e puan ayrılmayan
  /// turda işliyordu. Ölçüldü: o kurguda tek network puanı hem büyümeyi
  /// hem aşınma bağışıklığını satın alıyor, ikinci puan tamamen boşa
  /// gidiyordu — network 1 ile network 3 aynı fırsat payını veriyor
  /// (%36,4 ve %36,3) ama ikincisi 3,7M net değer kaybediyordu. Kol bir
  /// merdiven değil ikili bir anahtardı.
  ///
  /// Orantılı aşınma denge noktasını ayrılan network puanına bağlar.
  /// Ölçülen platolar (kartsız, 400 tur): 1 puan → 30, 2 → 47, 3 → 58,
  /// 5 → 71, 8 → 86. Anayasadaki "itibar korunması gereken bir kaynaktır,
  /// bir kez kazanılıp bitmez" cümlesinin sayısal karşılığı budur.
  final double itibarAsinmaOrani = 0.02;

  /// Yetkinlik ve itibar tavana yaklaştıkça artış yavaşlar.
  final double azalanVerimTabani = 110;

  /// Dinlenme puanı başına enerji.
  final double dinlenmeIyilesmesi = 6;

  /// Her tur zaman dağıtımından bağımsız gelen toparlanma. Oyuncu puan
  /// ayırmasa da uyuyor. Bu olmadan enerji maliyeti yüksek meslekler (doktor,
  /// aşçı) zor değil oynanamaz oluyordu: sürekli dinlenmek zorunda kalan
  /// oyuncu terfi edemiyor, en yüksek tavanlı meslek en az kazandırıyordu.
  final double dogalToparlanma = 8;

  final double egitimEnerjisi = 2.0;
  final double networkEnerjisi = 1.5;

  /// Çalışma puanı başına yakılan enerji, mesleğin `enerjiMaliyeti` ile
  /// çarpılır.
  final double calismaEnerjiCarpani = 0.30;

  /// Bu puanın üstünde çalışmak mutluluğu düşürür.
  final int asiriCalismaEsigi = 6;
  final double asiriCalismaCezasi = 2.0;
  /// Dinlenme puanı başına mutluluk. 2,0'dan indirildi: aşağıdaki uyum
  /// mekanizmasıyla birlikte dengeli dağılımın platosunu 100'den 85'e
  /// çekiyor.
  final double dinlenmeMutlulugu = 0.8;
  final double networkMutlulugu = 0.5;

  /// Mutluluğun çekildiği nötr seviye ve her turdaki uyum oranı.
  ///
  /// Mutluluk önce tek yönlü bir cırcırdı: `dengeli()` her tur +4,5
  /// veriyor, hiçbir aşınma yoktu. Ölçüldü — bir dinlenme puanı ayıran
  /// oyuncu 7 turda 100'e yapışıp orada kalıyor, hiç ayırmayan birkaç
  /// yılda 0'a çakılıyordu; arada bant yoktu. Sonuç: aşırı çalışmanın
  /// bedeli yoktu, `calisma: 8` hem en yüksek serveti (18,5M) hem rahat
  /// mutluluğu (74) veriyordu.
  ///
  /// Uyum, kazancı seviyeye bağlar (hedonik uyum): plato, ayrılan dinlenme
  /// puanıyla belirlenir. Anayasadaki "Mutluluk/Stres — düşerse burnout,
  /// performans düşer" kuralı ancak böyle işliyor; `burnout` eşiği (20)
  /// daha önce hiç görülmüyordu.
  final int mutlulukTabani = 50;
  final double mutlulukUyumOrani = 0.06;

  /// Enerji bu seviyenin altına inince ek mutluluk kaybı.
  final int dusukEnerjiEsigi = 25;
  final double dusukEnerjiCezasi = 4.0;

  final int issizlikMutlulukKaybi = 5;
  final int askerlikMutlulukKaybi = 3;
  final int askerlikEnerjiKaybi = 8;

  /// Er olarak askerlik süresi (tur). Bedelli tek tur.
  final int askerlikSuresi = 6;
  final int bedelliSuresi = 1;

  /// Bedelli bedeli — TABAN TL, enflasyon endeksiyle çarpılır.
  /// Stajyer maaşının (~18.000) 15 katı: genç oyuncu için gerçek bir
  /// engel, orta kariyer için iki aylık maaş.
  final int bedelliBedeli = 280000;

  /// Celp yaş aralığı. Öğrencilik otomatik tecil sayılır.
  final int celpEnAzYas = 21;
  final int celpEnCokYas = 29;

  /// Tebligat geldikten sonra bedelli ödemek için kalan tur.
  /// Oyuncu parayı denkleştirsin ya da yatırımını bozsun diye var;
  /// sıfır olsaydı karar değil bildirim olurdu.
  final int celpTebligatTuru = 3;

  /// KPSS/atama beklemesi (tur). Öğretmen ve memur bu kapıdan geçer:
  /// düşük tavanlarının karşılığı "garantili ama yavaş başlar".
  final int atamaEnAzTur = 3;
  final int atamaEnCokTur = 18;
  final int kovulmaMutlulukKaybi = 8;
  final int mezuniyetMutlulugu = 6;
  final int terhisMutlulugu = 10;
  final int atamaMutlulugu = 12;

  /// Kayıt dışı çalışanın eline geçen fazla pay. Bedeli: SGK primi yok.
  final double kayitDisiPrimi = 1.20;

  /// Performansın sınırları ve enerji eşiği.
  final double enDusukPerformans = 0.35;
  final double enYuksekPerformans = 1.35;
  final int performansEnerjiEsigi = 40;
  final double burnoutPerformansCarpani = 0.85;

  /// Performans bu değerin altındaysa kovulma riski başlar.
  final double kovulmaEsigi = 0.70;
  final double kovulmaKatsayisi = 0.6;

  /// Gelir çarpanının güvenlik sınırları. Sayısal uç durumlar içindir;
  /// normal oyunda bu sınırlara değinilmez.
  final double enDusukGelirCarpani = 0.1;
  final double enYuksekGelirCarpani = 6.0;
}

/// Bir turun kariyer tarafındaki sonucu. UI raporu ve testler bunu okur.
class KariyerTurSonucu {
  const KariyerTurSonucu({
    required this.oyuncu,
    required this.netGelir,
    required this.performans,
    this.terfiEtti = false,
    this.yeniKademeAdi,
    this.istenCikarildi = false,
    this.mezunOldu = false,
    this.askerlikBitti = false,
    this.celpGeldi = false,
    this.askereAlindi = false,
    this.atamasiCikti = false,
  });

  /// Turun sonundaki oyuncu. Nakit HENÜZ EKLENMEMİŞTİR; gelir/gider
  /// mahsuplaşmasını `TurProcessor` yapar.
  final Oyuncu oyuncu;

  /// Bu tur elde edilen nominal net gelir (TL).
  final int netGelir;

  final double performans;
  final bool terfiEtti;
  final String? yeniKademeAdi;
  final bool istenCikarildi;
  final bool mezunOldu;
  final bool askerlikBitti;

  /// Bu turda celp tebligatı geldi.
  final bool celpGeldi;

  /// Bu turda askere alındı (tebligat süresi doldu).
  final bool askereAlindi;

  /// Atama bekleyen oyuncunun kurası çıktı.
  final bool atamasiCikti;

  /// Yalnız motorun kendi içinde kullanılıyor: durum işleyicileri sonucu
  /// üretiyor, askerlik kapısı üstüne kendi bayraklarını yazıyor.
  KariyerTurSonucu copyWith({
    Oyuncu? oyuncu,
    int? netGelir,
    bool? celpGeldi,
    bool? askereAlindi,
  }) =>
      KariyerTurSonucu(
        oyuncu: oyuncu ?? this.oyuncu,
        netGelir: netGelir ?? this.netGelir,
        performans: performans,
        terfiEtti: terfiEtti,
        yeniKademeAdi: yeniKademeAdi,
        istenCikarildi: istenCikarildi,
        mezunOldu: mezunOldu,
        askerlikBitti: askerlikBitti,
        celpGeldi: celpGeldi ?? this.celpGeldi,
        askereAlindi: askereAlindi ?? this.askereAlindi,
        atamasiCikti: atamasiCikti,
      );
}

/// Kariyerin bir turunu işler: gelir, terfi, yetkinlik, itibar, enerji.
///
/// Nakit AKTARMAZ ve tur sayacını ilerletmez — o `TurProcessor`'ın işidir.
/// Böylece bu motor tek başına test edilebilir.
///
/// Rastgelelik yalnızca dışarıdan verilen akıştan gelir; motorda saklı durum
/// yoktur, aynı girdi aynı çıktıyı verir.
class KariyerMotoru {
  const KariyerMotoru({this.ayarlar = const KariyerAyarlari()});

  final KariyerAyarlari ayarlar;

  KariyerTurSonucu turIsle({
    required Oyuncu oyuncu,
    required MeslekKatalogu katalog,
    required PiyasaDurumu piyasa,
    required ZamanDagilimi zaman,
    required RastgeleAkis akis,

    /// Maaşların bağlı olduğu fiyat endeksi. Enflasyon endeksinden AYRI
    /// verilir: maaş yılda bir zamlanır, giderler her ay artar. Boş
    /// bırakılırsa maaş anlık enflasyona endekslenir (test kolaylığı).
    double? maasEndeksi,

    /// Oyuncu bu turda bedelli ödemek istiyor mu.
    bool bedelliOde = false,
  }) {
    final z = zaman.duzelt();
    final endeks = maasEndeksi ?? piyasa.enflasyonEndeksi;

    // Askerlik kapısı kariyer işlenmeden ÖNCE: celp geldiği tur oyuncu
    // hâlâ çalışıyor, askere alındığı tur artık çalışmıyor.
    final askerlikSonucu = _askerlikKapisi(oyuncu, piyasa, akis, bedelliOde);
    final guncelOyuncu = askerlikSonucu.oyuncu;

    final temel = switch (guncelOyuncu.kariyer) {
      Calisan durum =>
        _calisan(guncelOyuncu, durum, katalog, piyasa, z, akis, endeks),
      Ogrenci durum => _ogrenci(guncelOyuncu, durum, z, akis),
      Issiz durum => _issiz(guncelOyuncu, durum, katalog, z, akis),
      Askerlik durum => _askerlik(guncelOyuncu, durum),
      Emekli durum => _emekli(guncelOyuncu, durum, z, akis, endeks),
    };

    return temel.copyWith(
      // Bedelli bedeli kariyer gelirinden düşülür: nakit hareketini
      // TurProcessor yapıyor, motor yalnız tutarı bildiriyor.
      netGelir: temel.netGelir - askerlikSonucu.bedelliBedeli,
      celpGeldi: askerlikSonucu.celpGeldi,
      askereAlindi: askerlikSonucu.askereAlindi,
    );
  }

  /// Bu meslek atama kurası gerektiriyor mu.
  ///
  /// Veriye bakıyor, isim listesi tutmuyor: kamu mesleklerinin işareti
  /// `atamaGerektirir` alanı. Yeni bir kamu mesleği eklendiğinde motora
  /// dokunmak gerekmesin.
  bool atamaGerektirirMi(Meslek meslek) => meslek.atamaGerektirir;

  /// İşe giriş talebi. Şartlar tutmuyorsa null döner.
  ///
  /// Kamu mesleklerinde oyuncu doğrudan işe değil ATAMA KUYRUĞUNA girer:
  /// öğretmen ve memurun düşük tavanının karşılığı "garantili ama yavaş
  /// başlar".
  KariyerDurumu? iseGir(Oyuncu oyuncu, Meslek meslek) {
    if (!meslek.girebilirMi(oyuncu)) return null;
    if (oyuncu.kariyer is Askerlik) return null;
    return atamaGerektirirMi(meslek)
        ? KariyerDurumu.issiz(atamaBekliyor: true, bekleyenMeslekId: meslek.id)
        : KariyerDurumu.calisan(meslekId: meslek.id);
  }

  /// Celp, tecil, bedelli ve askere alınma.
  ///
  /// Öğrencilik otomatik tecildir: tebligat yalnız okumayan, askerliğini
  /// yapmamış, yaşı tutan erkek oyuncuya gelir.
  ({
    Oyuncu oyuncu,
    int bedelliBedeli,
    bool celpGeldi,
    bool askereAlindi,
  }) _askerlikKapisi(
    Oyuncu oyuncu,
    PiyasaDurumu piyasa,
    RastgeleAkis akis,
    bool bedelliOde,
  ) {
    if (oyuncu.askerlikYapildi ||
        !oyuncu.cinsiyet.askerlikYukumlusu ||
        oyuncu.kariyer is Askerlik) {
      return (
        oyuncu: oyuncu,
        bedelliBedeli: 0,
        celpGeldi: false,
        askereAlindi: false,
      );
    }

    // Öğrencilik tecil: tebligat gelmez, gelmişse askıya alınır.
    if (oyuncu.kariyer is Ogrenci) {
      return (
        oyuncu: oyuncu.celpKalanTur == null
            ? oyuncu
            : oyuncu.copyWith(celpKalanTur: null),
        bedelliBedeli: 0,
        celpGeldi: false,
        askereAlindi: false,
      );
    }

    final kalan = oyuncu.celpKalanTur;

    // Tebligat henüz gelmedi: yaş tutuyorsa gelsin.
    if (kalan == null) {
      final yasTutuyor = oyuncu.yas >= ayarlar.celpEnAzYas &&
          oyuncu.yas <= ayarlar.celpEnCokYas;
      if (!yasTutuyor) {
        return (
          oyuncu: oyuncu,
          bedelliBedeli: 0,
          celpGeldi: false,
          askereAlindi: false,
        );
      }
      return (
        oyuncu: oyuncu.copyWith(celpKalanTur: ayarlar.celpTebligatTuru),
        bedelliBedeli: 0,
        celpGeldi: true,
        askereAlindi: false,
      );
    }

    // Bedelli ödeniyor mu? Nakit yetmiyorsa talep sessizce düşer:
    // oyuncu parayı denkleştiremediyse askere gider.
    if (bedelliOde) {
      final bedel = piyasa.endeksle(ayarlar.bedelliBedeli);
      if (oyuncu.nakit >= bedel) {
        return (
          oyuncu: oyuncu.copyWith(
            celpKalanTur: null,
            kariyer: KariyerDurumu.askerlik(
              kalanTur: ayarlar.bedelliSuresi,
              bedelli: true,
              oncekiMeslekId: _meslekId(oyuncu.kariyer),
              oncekiKademeIndeksi: _kademeIndeksi(oyuncu.kariyer),
            ),
          ),
          bedelliBedeli: bedel,
          celpGeldi: false,
          askereAlindi: true,
        );
      }
    }

    if (kalan > 1) {
      return (
        oyuncu: oyuncu.copyWith(celpKalanTur: kalan - 1),
        bedelliBedeli: 0,
        celpGeldi: false,
        askereAlindi: false,
      );
    }

    // Süre doldu: er olarak askere alınır.
    return (
      oyuncu: oyuncu.copyWith(
        celpKalanTur: null,
        kariyer: KariyerDurumu.askerlik(
          kalanTur: ayarlar.askerlikSuresi,
          oncekiMeslekId: _meslekId(oyuncu.kariyer),
          oncekiKademeIndeksi: _kademeIndeksi(oyuncu.kariyer),
        ),
      ),
      bedelliBedeli: 0,
      celpGeldi: false,
      askereAlindi: true,
    );
  }

  String? _meslekId(KariyerDurumu durum) =>
      durum is Calisan ? durum.meslekId : null;

  int _kademeIndeksi(KariyerDurumu durum) =>
      durum is Calisan ? durum.kademeIndeksi : 0;

  // --- Durum bazlı işleyiciler -------------------------------------------

  KariyerTurSonucu _calisan(
    Oyuncu oyuncu,
    Calisan durum,
    MeslekKatalogu katalog,
    PiyasaDurumu piyasa,
    ZamanDagilimi z,
    RastgeleAkis akis,
    double maasEndeksi,
  ) {
    final meslek = katalog.bul(durum.meslekId);
    if (meslek == null) {
      // Kayıtta olmayan mesleğe referans. Veri dosyası testte doğrulandığı
      // için bu yol yalnızca bozuk kayıt içindir: oyuncu işsiz sayılır.
      return _issiz(
        oyuncu.kariyerDegistir(const KariyerDurumu.issiz()),
        const Issiz(),
        katalog,
        z,
        akis,
      );
    }

    final kademe = meslek.kademe(durum.kademeIndeksi);
    final performans = _performans(oyuncu, z);
    final netGelir =
        _maas(meslek, kademe, durum, piyasa, performans, akis, maasEndeksi);

    var guncel = _ortakEtkiler(oyuncu, z, akis, meslek: meslek);

    // Terfi: hem kıdem hem yetkinlik.
    var terfiEtti = false;
    String? yeniKademeAdi;
    final sonrakiIndeks = durum.kademeIndeksi + 1;
    if (!kademe.sonKademe && sonrakiIndeks < meslek.kademeler.length) {
      final sonraki = meslek.kademeler[sonrakiIndeks];
      final kidemTamam = durum.kademeTuru >= (kademe.sureTur ?? 0);
      final yetkinlikTamam =
          guncel.yetkinlik(meslek.sektor) >= sonraki.yetkinlikGerek;
      if (kidemTamam && yetkinlikTamam) {
        terfiEtti = true;
        yeniKademeAdi = sonraki.ad;
        guncel = guncel.kariyerDegistir(
          durum.copyWith(kademeIndeksi: sonrakiIndeks, kademeTuru: 0),
        );
      }
    }

    // Kovulma: performans eşiğin altındaysa risk doğar. Terfi alan kovulmaz.
    var istenCikarildi = false;
    if (!terfiEtti && performans < ayarlar.kovulmaEsigi) {
      final risk =
          (ayarlar.kovulmaEsigi - performans) * ayarlar.kovulmaKatsayisi;
      if (akis.sans(risk)) {
        istenCikarildi = true;
        guncel = guncel
            .kariyerDegistir(const KariyerDurumu.issiz())
            .mutlulukDegistir(-ayarlar.kovulmaMutlulukKaybi);
      }
    }

    return KariyerTurSonucu(
      oyuncu: guncel,
      // Kovulsa bile o ayın maaşı ödenir.
      netGelir: netGelir,
      performans: performans,
      terfiEtti: terfiEtti,
      yeniKademeAdi: yeniKademeAdi,
      istenCikarildi: istenCikarildi,
    );
  }

  KariyerTurSonucu _ogrenci(
    Oyuncu oyuncu,
    Ogrenci durum,
    ZamanDagilimi z,
    RastgeleAkis akis,
  ) {
    var guncel = _ortakEtkiler(oyuncu, z, akis, ogrenci: true);
    final mezunOldu = durum.kalanTur <= 1;
    if (mezunOldu) {
      guncel = guncel
          .copyWith(egitim: durum.hedef)
          .kariyerDegistir(const KariyerDurumu.issiz())
          .mutlulukDegistir(ayarlar.mezuniyetMutlulugu);
    }
    return KariyerTurSonucu(
      oyuncu: guncel,
      netGelir: 0,
      performans: 1,
      mezunOldu: mezunOldu,
    );
  }

  KariyerTurSonucu _issiz(
    Oyuncu oyuncu,
    Issiz durum,
    MeslekKatalogu katalog,
    ZamanDagilimi z,
    RastgeleAkis akis,
  ) {
    var guncel = _ortakEtkiler(oyuncu, z, akis)
        .mutlulukDegistir(-ayarlar.issizlikMutlulukKaybi);

    // Atama kurası: KPSS'yi kazanmış oyuncu atanana kadar bekler.
    // Her tur sabit şansla çıkar; beklenen süre atamaEnAz-atamaEnCok
    // aralığının ortasına oturuyor.
    var atandi = false;
    if (durum.atamaBekliyor && durum.bekleyenMeslekId != null) {
      final gecen = durum.gecenTur;
      if (gecen >= ayarlar.atamaEnCokTur) {
        atandi = true;
      } else if (gecen >= ayarlar.atamaEnAzTur) {
        final kalanPencere = ayarlar.atamaEnCokTur - gecen;
        atandi = akis.sans(1 / kalanPencere);
      }
      if (atandi) {
        final meslek = katalog.bul(durum.bekleyenMeslekId!);
        guncel = guncel
            .kariyerDegistir(
              meslek == null
                  ? const KariyerDurumu.issiz()
                  : KariyerDurumu.calisan(meslekId: meslek.id),
            )
            .mutlulukDegistir(ayarlar.atamaMutlulugu);
      }
    }

    return KariyerTurSonucu(
      oyuncu: guncel,
      netGelir: 0,
      performans: 0,
      atamasiCikti: atandi,
    );
  }

  KariyerTurSonucu _askerlik(Oyuncu oyuncu, Askerlik durum) {
    // Askerlikte zaman dağıtımı işlemez; kariyer durur.
    var guncel = oyuncu
        .enerjiDegistir(-ayarlar.askerlikEnerjiKaybi)
        .mutlulukDegistir(-ayarlar.askerlikMutlulukKaybi);
    final bitti = durum.kalanTur <= 1;
    if (bitti) {
      // İŞE İADE: askerden dönen oyuncu eski işine, eski kademesine
      // döner. Gerçek hayatta da yasal hak; olmasaydı askerlik "6 ay
      // gelir kaybı" değil "kariyeri sıfırla" cezası olurdu.
      final oncekiIs = durum.oncekiMeslekId;
      guncel = guncel
          .copyWith(askerlikYapildi: true)
          .kariyerDegistir(
            oncekiIs == null
                ? const KariyerDurumu.issiz()
                : KariyerDurumu.calisan(
                    meslekId: oncekiIs,
                    kademeIndeksi: durum.oncekiKademeIndeksi,
                  ),
          )
          .mutlulukDegistir(ayarlar.terhisMutlulugu);
    }
    return KariyerTurSonucu(
      oyuncu: guncel,
      netGelir: 0,
      performans: 0,
      askerlikBitti: bitti,
    );
  }

  KariyerTurSonucu _emekli(
    Oyuncu oyuncu,
    Emekli durum,
    ZamanDagilimi z,
    RastgeleAkis akis,
    double maasEndeksi,
  ) =>
      KariyerTurSonucu(
        oyuncu: _ortakEtkiler(oyuncu, z, akis),
        // Emekli aylığı da maaş gibi yılda bir zamlanır.
        netGelir: (durum.tabanAylik * maasEndeksi).round(),
        performans: 1,
      );

  // --- Ortak hesaplar ----------------------------------------------------

  /// İş performansı: çalışmaya ayrılan pay, enerji ve burnout.
  double _performans(Oyuncu oyuncu, ZamanDagilimi z) {
    final temel = 0.5 + z.calismaOrani;
    final enerjiCarpani = oyuncu.enerji >= ayarlar.performansEnerjiEsigi
        ? 1.0
        : 0.5 + 0.5 * oyuncu.enerji / ayarlar.performansEnerjiEsigi;
    var p = temel * enerjiCarpani;
    if (oyuncu.burnout) p *= ayarlar.burnoutPerformansCarpani;
    return p.clamp(ayarlar.enDusukPerformans, ayarlar.enYuksekPerformans);
  }

  /// Nominal net maaş.
  ///
  /// Bankanın gördüğü maaş: şok ve performans çarpanı OLMADAN, yalnız
  /// kademe tabanı ve endeks.
  ///
  /// Kredi kararı gerçekleşen gelire değil bordroya bakar. Ayrıca kredi
  /// tur işlenmeden ÖNCE çekilir; o turun şoklu geliri henüz bilinmiyor.
  /// Çalışmayan oyuncu için 0.
  int bordroMaasi(
    Oyuncu oyuncu,
    MeslekKatalogu katalog,
    PiyasaDurumu piyasa,
    double maasEndeksi,
  ) {
    final durum = oyuncu.kariyer;
    if (durum is! Calisan) return 0;
    final meslek = katalog.bul(durum.meslekId);
    if (meslek == null) return 0;
    final kademe = meslek.kademeler[
        durum.kademeIndeksi.clamp(0, meslek.kademeler.length - 1)];
    final kurEndeksi = _kurEndeksi(piyasa);
    final endeks = (1 - meslek.dovizOrani) * maasEndeksi +
        meslek.dovizOrani * kurEndeksi;
    final kayitDisiCarpani = durum.kayitDisi ? ayarlar.kayitDisiPrimi : 1.0;
    return (kademe.maas * endeks * kayitDisiCarpani).round();
  }

  /// Maaşın döviz payı enflasyona değil KURA endekslenir. Yazılımcının ve
  /// ihracatçının kur şokunda kazanması, memurun kaybetmesi bu satırdan
  /// çıkıyor — Türkiye bağlamının en somut mekaniklerinden biri.
  int _maas(
    Meslek meslek,
    Kademe kademe,
    Calisan durum,
    PiyasaDurumu piyasa,
    double performans,
    RastgeleAkis akis,
    double maasEndeksi,
  ) {
    final kurEndeksi = _kurEndeksi(piyasa);
    final endeks = (1 - meslek.dovizOrani) * maasEndeksi +
        meslek.dovizOrani * kurEndeksi;

    final sokCarpani = _gelirSoku(meslek.gelirVaryansi, akis);
    final kayitDisiCarpani = durum.kayitDisi ? ayarlar.kayitDisiPrimi : 1.0;

    final tutar =
        kademe.maas * endeks * sokCarpani * performans * kayitDisiCarpani;
    return tutar < 0 ? 0 : tutar.round();
  }

  /// Aylık gelir dalgalanması: log-normal, ortalaması tam olarak 1.
  ///
  /// Önce `1 + N(0, varyans)` kullanılıyordu ama negatif maaşı önlemek için
  /// yapılan kırpma asimetrikti: yüksek varyanslı meslekler (emlakçı, içerik
  /// üreticisi) bu yüzden sistematik olarak fazladan kazanıyordu.
  ///
  /// Log-normal hem negatife düşemez hem de ortalaması sapmasızdır. Yan
  /// etkisi tam olarak istenen his: medyan ay ortalamanın altındadır, arada
  /// bir gelen büyük ay ortalamayı taşır — prim ve komisyonla çalışmak budur.
  double _gelirSoku(double varyans, RastgeleAkis akis) {
    if (varyans <= 0) return 1.0;
    final z = akis.normal();
    final carpan = math.exp(z * varyans - varyans * varyans / 2);
    return carpan.clamp(
      ayarlar.enDusukGelirCarpani,
      ayarlar.enYuksekGelirCarpani,
    );
  }

  double _kurEndeksi(PiyasaDurumu piyasa) {
    final tanim = temelVarliklar.firstWhere((v) => v.id == 'doviz');
    final guncel = piyasa.fiyat(tanim.id);
    if (guncel <= 0) return piyasa.enflasyonEndeksi;
    return guncel / tanim.baslangicFiyati;
  }

  /// Yetkinlik, itibar, enerji ve mutluluk değişimleri. Askerlik dışında her
  /// durumda işler; işsiz oyuncu da kendini geliştirebilir.
  Oyuncu _ortakEtkiler(
    Oyuncu oyuncu,
    ZamanDagilimi z,
    RastgeleAkis akis, {
    Meslek? meslek,
    bool ogrenci = false,
  }) {
    var guncel = oyuncu;

    // Yetkinlik hangi sektöre yazılacak: mesleğin sektörü, yoksa oyuncunun
    // ana sektörü. İkisi de yoksa yazılmaz — sektör seçmeden yetkinlik
    // birikmesi anlamsız olurdu.
    final hedefSektor = meslek?.sektor ?? oyuncu.anaSektor;
    if (hedefSektor != null) {
      final egitimPayi = z.egitim *
          ayarlar.egitimKatkisi *
          (ogrenci ? ayarlar.ogrenciCarpani : 1.0);
      final calismaPayi = z.calisma * ayarlar.calismaKatkisi;
      final hiz = meslek?.yetkinlikArtisHizi ?? 1.0;
      final artis = (egitimPayi + calismaPayi) *
          hiz *
          _azalanVerim(oyuncu.yetkinlik(hedefSektor).toDouble());
      guncel = guncel.yetkinlikDegistir(hedefSektor, _yuvarla(artis, akis));
    }

    // İtibar: network puanı artırır, mevcut itibar HER TUR aşınır.
    //
    // Aşınma network puanına bakmıyor: yüksek itibarı korumak sürekli bir
    // maliyet olmalı. Denge noktası ayrılan puanla belirlenir; bu olmadan
    // birinci puandan sonrası boşa gidiyordu.
    final itibarDegisimi = z.network *
            ayarlar.networkKatkisi *
            (meslek?.networkArtisi ?? 1.0) *
            _azalanVerim(oyuncu.itibar.toDouble()) -
        oyuncu.itibar * ayarlar.itibarAsinmaOrani;
    guncel = guncel.itibarDegistir(_yuvarla(itibarDegisimi, akis));

    // Enerji
    final isYuku =
        z.calisma * (meslek?.enerjiMaliyeti ?? 2) * ayarlar.calismaEnerjiCarpani;
    final enerjiDegisimi = ayarlar.dogalToparlanma +
        z.dinlenme * ayarlar.dinlenmeIyilesmesi -
        isYuku -
        z.egitim * ayarlar.egitimEnerjisi -
        z.network * ayarlar.networkEnerjisi;
    guncel = guncel.enerjiDegistir(_yuvarla(enerjiDegisimi, akis));

    // Mutluluk
    var mutluluk = z.dinlenme * ayarlar.dinlenmeMutlulugu +
        z.network * ayarlar.networkMutlulugu;
    if (z.calisma > ayarlar.asiriCalismaEsigi) {
      mutluluk -=
          (z.calisma - ayarlar.asiriCalismaEsigi) * ayarlar.asiriCalismaCezasi;
    }
    if (guncel.enerji < ayarlar.dusukEnerjiEsigi) {
      mutluluk -= ayarlar.dusukEnerjiCezasi;
    }
    // Hedonik uyum: mutluluk her tur nötr seviyeye doğru çekilir. İtibarın
    // orantılı aşınmasıyla aynı gerekçe — kazanç seviyeye bağlanmazsa stat
    // tek yönlü bir cırcıra dönüşüyor ve tavana yapışıp kalıyor.
    mutluluk -= (oyuncu.mutluluk - ayarlar.mutlulukTabani) *
        ayarlar.mutlulukUyumOrani;
    guncel = guncel.mutlulukDegistir(_yuvarla(mutluluk, akis));

    return guncel;
  }

  /// Tavana yaklaştıkça artışı yavaşlatan çarpan.
  double _azalanVerim(double mevcut) {
    final oran = 1 - mevcut / ayarlar.azalanVerimTabani;
    return oran < 0 ? 0 : oran;
  }

  /// Ondalık değişimi tam sayıya çevirir.
  ///
  /// Her tur `round()` kullanmak sistematik sapma yaratırdı: 0,4'lük artışlar
  /// sonsuza kadar sıfıra yuvarlanır ve yetkinlik hiç artmazdı. Bunun yerine
  /// kesirli kısım kadar ihtimalle yukarı yuvarlanıyor — uzun vadede sapmasız
  /// ve zar seed'li olduğu için yine tekrar üretilebilir.
  int _yuvarla(double deger, RastgeleAkis akis) {
    final taban = deger.floor();
    final kesir = deger - taban;
    if (kesir <= 0) return taban;
    return taban + (akis.sans(kesir) ? 1 : 0);
  }
}
