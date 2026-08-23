import '../models/ilgi_dagilimi.dart';
import '../models/isletme.dart';
import '../models/isletme_katalogu.dart';
import '../models/piyasa_durumu.dart';
import '../rng/rastgele_akis.dart';

/// İşletme sisteminin denge sabitleri. Hepsi tek yerde.
class IsletmeAyarlari {
  const IsletmeAyarlari();

  /// İlgi oranı bu değerin üstündeyse statlar büyür, altındaysa küçülür.
  /// 0,5 = "yarım ilgi işletmeyi yerinde tutar".
  final double ilgiNotrNoktasi = 0.5;

  /// Tam ilgide turda kazanılan stat puanı (azalan verim öncesi).
  /// Kafenin müşteri tabanı 35'ten 100'e ~3 yılda çıkıyor: yatırımın
  /// karşılığını görmek bir yıldan uzun sürmeli ama ömür boyu sürmemeli.
  final double statKazanci = 3.0;

  /// Hiç ilgi görmeyen işletmenin turda kaybettiği stat puanı.
  /// Kazançtan büyük: bir işletmeyi bırakmak, kurmaktan hızlı çöker.
  final double statKaybi = 4.0;

  /// Stat tavana yaklaştıkça büyüme yavaşlar.
  final double azalanVerimTabani = 115;

  /// İlgi oranı bunun altındaysa ihmal sayacı işler.
  final double ihmalEsigi = 0.5;

  /// Bu kadar tur üst üste ihmal edilen işletmede kriz eşiği AŞILIR.
  /// Uyarı yalnız eşiğin geçildiği turda verilir; her tur verilseydi
  /// bilerek ihmal eden oyuncu bir daha hiç tur atlayamazdı.
  final int ihmalKriziEsigi = 3;

  /// CEO'lu işletme brüt kârının bu kadarını kaybeder. Genel müdür
  /// oyuncunun kendisi kadar iyi yönetmez; bedava ilgi diye bir şey yok.
  final double ceoKarKaybi = 0.15;

  /// CEO'nun her turda zimmete para geçirme ihtimali.
  final double zimmetSansi = 0.008;

  /// Zimmet olursa aylık cironun bu katı kadar kayıp.
  final double zimmetSiddeti = 1.5;

  /// Satış değerinin tabanı: yıllık kâr × tanımdaki çarpan. Zarar eden
  /// işletme sermayenin bu oranına satılır (enkaz bedeli).
  final double enkazOrani = 0.35;

  /// Kuruluşta ödenen sermayenin üstüne gelen devir/noter masrafı.
  final double kurulusMasrafi = 0.04;
}

/// Tek bir işletmenin tur raporu. UI "kafe bu ay ne yaptı" ekranını bundan
/// çizer.
class IsletmeRaporu {
  const IsletmeRaporu({
    required this.isletmeId,
    required this.ad,
    required this.brutGelir,
    required this.giderler,
    required this.netKar,
    required this.ilgiOrani,
    required this.ihmalEdildi,
    required this.krizRiski,
    required this.zimmetOldu,
  });

  final String isletmeId;
  final String ad;

  /// Nominal TL (enflasyon endeksi uygulanmış).
  final int brutGelir;
  final int giderler;
  final int netKar;

  /// Ayrılan ilgi / gereken ilgi. 1,0 = tam.
  final double ilgiOrani;
  final bool ihmalEdildi;

  /// Üst üste ihmal yüzünden kriz kartı beklenmeli mi.
  final bool krizRiski;
  final bool zimmetOldu;
}

/// Bütün işletmelerin turu.
class IsletmeTurSonucu {
  const IsletmeTurSonucu({
    required this.isletmeler,
    required this.netNakit,
    required this.itibarKatkisi,
    required this.raporlar,
    required this.tamamlananSatislar,
  });

  final List<Isletme> isletmeler;

  /// Bütün işletmelerin net kârı toplamı (nominal TL). Negatif olabilir:
  /// zarar eden işletme oyuncunun cebinden yer.
  final int netNakit;

  /// Prestijden gelen itibar değişimi.
  final int itibarKatkisi;
  final List<IsletmeRaporu> raporlar;

  /// Bu turda devri tamamlanan satışlar: işletme id → eline geçen tutar.
  final Map<String, int> tamamlananSatislar;
}

/// İşletmelerin turunu işler.
///
/// TEK MOTOR, TÜM İŞLETMELER. Kafe ile oto galeri arasındaki fark buraya
/// değil `assets/businesses/*.json` dosyasına yazılır; futbol kulübü de
/// aynı yoldan gelecek. Motorda işletme türüne bakan tek bir `if` yok —
/// olduğu an anayasanın en önemli mimari kararı delinmiş olur.
class IsletmeMotoru {
  const IsletmeMotoru({
    required this.katalog,
    this.ayarlar = const IsletmeAyarlari(),
  });

  final IsletmeKatalogu katalog;
  final IsletmeAyarlari ayarlar;

  /// Bir işletmenin gerektirdiği ilgi puanı. CEO yükü azaltır ama
  /// sıfırlamaz: `ceoEtkinligi` 1'e eşit olamaz (veri testiyle sabit).
  int gerekenIlgi(Isletme isletme) {
    final tanim = katalog.bul(isletme.tanimId);
    if (tanim == null) return 0;
    if (!isletme.ceoVar) return tanim.yonetimYuku;
    final azaltilmis = tanim.yonetimYuku * (1 - tanim.ceoEtkinligi);
    return azaltilmis.ceil().clamp(1, tanim.yonetimYuku);
  }

  /// Oyuncunun sahip olduğu işletmelerin toplam ilgi ihtiyacı.
  int toplamGerekenIlgi(Iterable<Isletme> isletmeler) =>
      isletmeler.fold(0, (t, i) => t + gerekenIlgi(i));

  /// Kuruluş/satın alma bedeli (nominal TL, masraf dahil).
  int kurulusBedeli(IsletmeTanimi tanim, PiyasaDurumu piyasa) =>
      piyasa.endeksle((tanim.sermaye * (1 + ayarlar.kurulusMasrafi)).round());

  /// Satıştan eline geçecek tutar (nominal TL).
  ///
  /// Kârlı işletme yıllık kârın katına, zarar eden işletme sermayenin
  /// küçük bir oranına gider. Böylece "batmakta olan işletmeyi sat, paranı
  /// kurtar" bir kaçış yolu değil, zarar realize etmek oluyor.
  int satisDegeri(Isletme isletme, PiyasaDurumu piyasa) {
    final tanim = katalog.bul(isletme.tanimId);
    if (tanim == null) return 0;
    final karliDeger = (isletme.yillikNetKar * tanim.degerCarpani).round();
    final enkaz = piyasa.endeksle(
      (tanim.sermaye * ayarlar.enkazOrani).round(),
    );
    return karliDeger > enkaz ? karliDeger : enkaz;
  }

  IsletmeTurSonucu turIsle({
    required List<Isletme> isletmeler,
    required IlgiDagilimi ilgi,
    required PiyasaDurumu piyasa,
    required int tur,
    required RastgeleAkis akis,
  }) {
    if (isletmeler.isEmpty) {
      return const IsletmeTurSonucu(
        isletmeler: [],
        netNakit: 0,
        itibarKatkisi: 0,
        raporlar: [],
        tamamlananSatislar: {},
      );
    }

    final guncelIsletmeler = <Isletme>[];
    final raporlar = <IsletmeRaporu>[];
    final tamamlananlar = <String, int>{};
    var netNakit = 0;
    var prestijToplami = 0.0;

    // Sıra sabit: aynı kayıt aynı zar dizisini görsün.
    final sirali = [...isletmeler]..sort((a, b) => a.id.compareTo(b.id));

    for (final isletme in sirali) {
      final tanim = katalog.bul(isletme.tanimId);
      if (tanim == null) {
        // Tanım silinmiş: örneği düşürmek yerine olduğu gibi taşı, kayıt
        // sessizce eksilmesin.
        guncelIsletmeler.add(isletme);
        continue;
      }

      final gereken = gerekenIlgi(isletme);
      final ayrilan = ilgi.puan(isletme.id);
      final oran = gereken <= 0 ? 1.0 : (ayrilan / gereken).clamp(0.0, 1.0);

      var guncel = _statlariIsle(isletme, tanim, oran, akis);

      final gelir = _gelirHesapla(guncel, tanim, tur, piyasa);
      var gider = _giderHesapla(guncel, tanim, tur, piyasa, gelir);

      if (guncel.ceoVar) {
        gider += piyasa.endeksle(tanim.ceoMaasi);
      }

      var brutKar = gelir - gider;
      if (guncel.ceoVar && brutKar > 0) {
        brutKar = (brutKar * (1 - ayarlar.ceoKarKaybi)).round();
      }

      var zimmet = false;
      if (guncel.ceoVar && akis.sans(ayarlar.zimmetSansi)) {
        zimmet = true;
        brutKar -= (gelir * ayarlar.zimmetSiddeti).round();
      }

      guncel = guncel.copyWith(
        sonNetKar: brutKar,
        // Yıllık kâr, satış değerinin tabanı. Kayan ortalama: tek kötü ay
        // işletmenin değerini sıfırlamasın.
        yillikNetKar: ((guncel.yillikNetKar * 11 + brutKar * 12) / 12).round(),
      );

      guncel = guncel.copyWith(guncelDeger: satisDegeri(guncel, piyasa));

      final ihmal = oran < ayarlar.ihmalEsigi;
      guncel = guncel.copyWith(ihmalTuru: ihmal ? guncel.ihmalTuru + 1 : 0);

      netNakit += brutKar;
      prestijToplami += tanim.prestij * oran;

      // Satış kuyruğu: emir verildiği turda da sayaç işler (portföydeki
      // gecikmeli satışla aynı semantik).
      final kalan = guncel.satisKalanTur;
      if (kalan != null) {
        if (kalan <= 1) {
          tamamlananlar[guncel.id] = satisDegeri(guncel, piyasa);
          raporlar.add(
            _rapor(guncel, tanim, gelir, gider, brutKar, oran, ihmal, zimmet),
          );
          continue; // İşletme artık oyuncunun değil.
        }
        guncel = guncel.copyWith(satisKalanTur: kalan - 1);
      }

      guncelIsletmeler.add(guncel);
      raporlar.add(
        _rapor(guncel, tanim, gelir, gider, brutKar, oran, ihmal, zimmet),
      );
    }

    return IsletmeTurSonucu(
      isletmeler: guncelIsletmeler,
      netNakit: netNakit,
      itibarKatkisi: _yuvarla(prestijToplami, akis),
      raporlar: raporlar,
      tamamlananSatislar: tamamlananlar,
    );
  }

  IsletmeRaporu _rapor(
    Isletme isletme,
    IsletmeTanimi tanim,
    int gelir,
    int gider,
    int netKar,
    double oran,
    bool ihmal,
    bool zimmet,
  ) =>
      IsletmeRaporu(
        isletmeId: isletme.id,
        ad: tanim.ad,
        brutGelir: gelir,
        giderler: gider,
        netKar: netKar,
        ilgiOrani: oran,
        ihmalEdildi: ihmal,
        krizRiski: isletme.ihmalTuru == ayarlar.ihmalKriziEsigi,
        zimmetOldu: zimmet,
      );

  /// İlgi statları büyütür ya da küçültür. Nötr noktanın üstü büyüme,
  /// altı çöküş.
  Isletme _statlariIsle(
    Isletme isletme,
    IsletmeTanimi tanim,
    double oran,
    RastgeleAkis akis,
  ) {
    var guncel = isletme;
    for (final statId in tanim.statlar) {
      final mevcut = guncel.stat(statId);
      final fark = oran - ayarlar.ilgiNotrNoktasi;
      final double delta;
      if (fark >= 0) {
        final hiz = fark / (1 - ayarlar.ilgiNotrNoktasi);
        delta = ayarlar.statKazanci * hiz * _azalanVerim(mevcut.toDouble());
      } else {
        final hiz = fark / ayarlar.ilgiNotrNoktasi; // negatif
        delta = ayarlar.statKaybi * hiz;
      }
      final tam = _yuvarla(delta.abs(), akis) * (delta < 0 ? -1 : 1);
      if (tam != 0) guncel = guncel.statDegistir(statId, tam);
    }
    return guncel;
  }

  int _gelirHesapla(
    Isletme isletme,
    IsletmeTanimi tanim,
    int tur,
    PiyasaDurumu piyasa,
  ) {
    var toplam = 0;
    for (final k in tanim.gelirler) {
      if (!k.isliyorMu(tur)) continue;
      toplam += _kalemDegeri(k, isletme, piyasa, 0);
    }
    return toplam;
  }

  int _giderHesapla(
    Isletme isletme,
    IsletmeTanimi tanim,
    int tur,
    PiyasaDurumu piyasa,
    int ciro,
  ) {
    var toplam = 0;
    for (final k in tanim.giderler) {
      if (!k.isliyorMu(tur)) continue;
      toplam += _kalemDegeri(k, isletme, piyasa, ciro);
    }
    return toplam;
  }

  /// Kalem hesabı. Para tutarları TABAN TL olduğu için enflasyon endeksiyle
  /// çarpılır; ciro payı zaten nominal ciro üzerinden hesaplandığı için
  /// ikinci kez endekslenmez.
  int _kalemDegeri(
    Kalem kalem,
    Isletme isletme,
    PiyasaDurumu piyasa,
    int ciro,
  ) =>
      switch (kalem.tur) {
        KalemTuru.sabit => piyasa.endeksle(kalem.taban),
        KalemTuru.stataBagli =>
          piyasa.endeksle((kalem.taban * isletme.stat(kalem.statId!) / 100)
              .round()),
        KalemTuru.cirodanPay => (ciro * kalem.oran).round(),
      };

  double _azalanVerim(double mevcut) {
    final oran = 1 - mevcut / ayarlar.azalanVerimTabani;
    return oran < 0 ? 0 : oran;
  }

  /// Kesirli artışı seed'li zarla yuvarlar. Her tur `round()` deseydik
  /// 0,4'lük artış sonsuza kadar sıfıra yuvarlanır, sistematik sapma
  /// olurdu (kariyer motorunda da aynı çözüm).
  int _yuvarla(double deger, RastgeleAkis akis) {
    final taban = deger.floor();
    final kesir = deger - taban;
    if (kesir <= 0) return taban;
    return taban + (akis.sans(kesir) ? 1 : 0);
  }
}
