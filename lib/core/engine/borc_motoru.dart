import '../models/borc.dart';
import '../models/oyuncu.dart';
import '../models/piyasa_durumu.dart';
import '../rng/rastgele_akis.dart';

/// Borç sisteminin denge sabitleri.
class BorcAyarlari {
  const BorcAyarlari();

  /// Aylık taksitlerin toplamı, aylık gelirin bu oranını geçemez.
  /// Bankanın "gelir belgesi" kapısı. Oyuncunun kendini tek turda
  /// boğmasını da engelliyor.
  final double taksitGelirOrani = 0.5;

  /// Kredi limiti aylık gelirin kaç katı (kredi notu 100'de en yüksek).
  final double limitGelirKatiEnCok = 18.0;
  final double limitGelirKatiEnAz = 2.0;

  /// Kredi notu bu değerin altındaysa banka kredi vermez.
  /// Ölçek Findeks'e benziyor: 300-1900, başlangıç 1000 (bkz. [Oyuncu]).
  final int enAzKrediNotu = 700;

  /// Enflasyonun üstüne binen AYLIK reel marj — kredi notu 100'de en
  /// düşük, 0'da en yüksek.
  ///
  /// Faizin enflasyona bağlanması tasarımın kalbi: kredi ÇEKİLDİĞİ turdaki
  /// rejime göre fiyatlanır, sonra sabitlenir. Düşük enflasyon döneminde
  /// çekip enflasyon rejimine yakalanmak oyuncunun kazandığı, tersi
  /// kaybettiği durum.
  final double reelMarjEnAz = 0.004;
  final double reelMarjEnCok = 0.020;

  /// Tür başına ek marj ve vade.
  final Map<BorcTuru, ({double ekMarj, int vade})> turAyarlari = const {
    BorcTuru.ihtiyac: (ekMarj: 0.010, vade: 36),
    BorcTuru.tasit: (ekMarj: 0.006, vade: 48),
    BorcTuru.konut: (ekMarj: 0.002, vade: 120),
    BorcTuru.kartBorcu: (ekMarj: 0.025, vade: 12),
  };

  /// Konut kredisi limit ayrıcalığı: ipotekli olduğu için banka cömert.
  final double konutLimitCarpani = 2.5;

  /// Ödenemeyen taksitte anaparaya eklenen gecikme cezası.
  final double gecikmeCezasi = 0.05;

  /// Ödenemeyen her taksitte düşen kredi notu. 1600 puanlık ölçekte 60,
  /// eksi bakiye cezasından (12) belirgin biçimde ağır — taksit kaçırmak
  /// hesabın kırmızıya düşmesinden ciddi bir olaydır.
  final int gecikmeKrediNotuDususu = 60;

  /// Kapanan her kredide artan kredi notu.
  final int kapanisKrediNotuArtisi = 40;

  /// Bu kadar tur üst üste ödenmezse takip başlar.
  final int takipEsigi = 3;
}

/// Bir turda borçlarda ne olduğu.
class BorcTurSonucu {
  const BorcTurSonucu({
    required this.borclar,
    required this.odenenTaksit,
    required this.krediNotuDegisimi,
    required this.kapananlar,
    required this.gecikenler,
    required this.takibeDusenler,
  });

  final List<Borc> borclar;

  /// Bu tur ödenen toplam taksit (nominal TL). Nakitten düşülür.
  final int odenenTaksit;
  final int krediNotuDegisimi;

  /// Bu tur biten krediler.
  final List<String> kapananlar;

  /// Taksiti ödenemeyen krediler.
  final List<String> gecikenler;

  /// Üst üste gecikip takibe düşenler.
  final List<String> takibeDusenler;
}

/// Kredi çekme sonucu.
class KrediSonucu {
  const KrediSonucu({this.borc, this.hata});

  final Borc? borc;
  final KrediHatasi? hata;

  bool get basarili => borc != null;
}

enum KrediHatasi {
  krediNotuYetersiz,
  limitAsildi,
  taksitGeliriAsiyor,
  gecersizTutar,
  gecikmedeKrediVerilmez,
}

/// Kredi verir, taksit tahsil eder, gecikmeyi işler.
///
/// SAF: nakde kendisi dokunmaz, tutarı döndürür. Nakit mahsuplaşması
/// tur boru hattının işi.
class BorcMotoru {
  const BorcMotoru({this.ayarlar = const BorcAyarlari()});

  final BorcAyarlari ayarlar;

  /// Aylık nominal faiz = beklenen enflasyon + kredi notu marjı + tür marjı.
  ///
  /// Beklenti olarak son gerçekleşen aylık enflasyon kullanılıyor: banka da
  /// geleceği bilmiyor, geçmişe bakıp fiyatlıyor. Rejim değişimini
  /// öngöremediği için oyuncuya arbitraj kapısı açık kalıyor — bilerek.
  double aylikFaiz(BorcTuru tur, int krediNotu, PiyasaDurumu piyasa) {
    final oran = notOrani(krediNotu);
    final marj = ayarlar.reelMarjEnCok -
        (ayarlar.reelMarjEnCok - ayarlar.reelMarjEnAz) * oran;
    final ek = ayarlar.turAyarlari[tur]!.ekMarj;
    final beklenen = piyasa.sonAylikEnflasyon;
    return (beklenen < 0 ? 0.0 : beklenen) + marj + ek;
  }

  /// Kredi notunun ölçek içindeki yeri (0-1).
  ///
  /// Ölçek 0-100 DEĞİL: [Oyuncu.krediNotuTaban]-[Oyuncu.krediNotuTavan]
  /// (300-1900). İlk yazımda 0-100 varsayılmıştı ve 1000 puanlık başlangıç
  /// notu tavana kırpılıyordu — herkes en iyi faizi alıyordu.
  double notOrani(int krediNotu) => ((krediNotu - Oyuncu.krediNotuTaban) /
          (Oyuncu.krediNotuTavan - Oyuncu.krediNotuTaban))
      .clamp(0.0, 1.0);

  /// Kredi notundan limit katsayısı (aylık gelirin kaç katı).
  double limitKati(int krediNotu) {
    final oran = notOrani(krediNotu);
    return ayarlar.limitGelirKatiEnAz +
        (ayarlar.limitGelirKatiEnCok - ayarlar.limitGelirKatiEnAz) * oran;
  }

  /// Mevcut aylık taksit yükü (nominal TL).
  int taksitYuku(Iterable<Borc> borclar) =>
      borclar.where((b) => !b.kapandi).fold(0, (t, b) => t + b.aylikTaksit);

  /// Toplam kalan borç (nominal TL). Net değer hesabı bunu düşer.
  int toplamBorc(Iterable<Borc> borclar) =>
      borclar.fold(0, (t, b) => t + b.kalanAnapara);

  /// Oyuncunun bu tur alabileceği teklifler.
  List<KrediTeklifi> teklifler({
    required Oyuncu oyuncu,
    required List<Borc> borclar,
    required PiyasaDurumu piyasa,
    required int aylikGelir,
  }) {
    if (oyuncu.krediNotu < ayarlar.enAzKrediNotu) return const [];
    if (borclar.any((b) => b.gecikmede)) return const [];
    if (aylikGelir <= 0) return const [];

    final kapasite =
        (aylikGelir * ayarlar.taksitGelirOrani).round() - taksitYuku(borclar);
    if (kapasite <= 0) return const [];

    final sonuc = <KrediTeklifi>[];
    for (final tur in BorcTuru.values) {
      // Kart borcu çekilmez, oluşur: olay kartları yazar.
      if (tur == BorcTuru.kartBorcu) continue;

      final ayar = ayarlar.turAyarlari[tur]!;
      final faiz = aylikFaiz(tur, oyuncu.krediNotu, piyasa);

      // İki kapı: gelir katı ve taksit/gelir oranı. Hangisi küçükse bağlar.
      var kat = limitKati(oyuncu.krediNotu);
      if (tur == BorcTuru.konut) kat *= ayarlar.konutLimitCarpani;
      final katLimiti = (aylikGelir * kat).round();
      final taksitLimiti = _anaparaCoz(kapasite, faiz, ayar.vade);

      final limit = katLimiti < taksitLimiti ? katLimiti : taksitLimiti;
      if (limit <= 0) continue;

      sonuc.add(
        KrediTeklifi(
          tur: tur,
          enYuksekTutar: limit,
          aylikFaiz: faiz,
          vadeTur: ayar.vade,
        ),
      );
    }
    return sonuc;
  }

  /// Krediyi çeker. Nakit AKTARILMAZ; çağıran anaparayı nakde ekler.
  KrediSonucu krediCek({
    required Oyuncu oyuncu,
    required List<Borc> borclar,
    required PiyasaDurumu piyasa,
    required int aylikGelir,
    required BorcTuru tur,
    required int anapara,
    required int simdikiTur,
  }) {
    if (anapara <= 0) {
      return const KrediSonucu(hata: KrediHatasi.gecersizTutar);
    }
    if (oyuncu.krediNotu < ayarlar.enAzKrediNotu) {
      return const KrediSonucu(hata: KrediHatasi.krediNotuYetersiz);
    }
    if (borclar.any((b) => b.gecikmede)) {
      return const KrediSonucu(hata: KrediHatasi.gecikmedeKrediVerilmez);
    }

    KrediTeklifi? teklif;
    for (final t in teklifler(
      oyuncu: oyuncu,
      borclar: borclar,
      piyasa: piyasa,
      aylikGelir: aylikGelir,
    )) {
      if (t.tur == tur) teklif = t;
    }
    if (teklif == null || anapara > teklif.enYuksekTutar) {
      return const KrediSonucu(hata: KrediHatasi.limitAsildi);
    }

    final taksit = teklif.taksit(anapara);
    if (taksitYuku(borclar) + taksit >
        (aylikGelir * ayarlar.taksitGelirOrani).round()) {
      return const KrediSonucu(hata: KrediHatasi.taksitGeliriAsiyor);
    }

    return KrediSonucu(
      borc: Borc(
        id: '${tur.id}_$simdikiTur',
        tur: tur,
        anapara: anapara,
        kalanAnapara: anapara,
        aylikTaksit: taksit,
        aylikFaiz: teklif.aylikFaiz,
        kalanTaksit: teklif.vadeTur,
        cekildigiTur: simdikiTur,
      ),
    );
  }

  /// Taksitleri işler.
  ///
  /// [odenebilirNakit] taksitlere ayrılabilecek tutar. Yetmezse krediler
  /// SIRAYLA ödenir: önce en yüksek faizli. Sıra oyuncunun lehine seçildi;
  /// tersi olsaydı ucuz kredi kapanırken pahalı olan çürürdü.
  BorcTurSonucu turIsle({
    required List<Borc> borclar,
    required int odenebilirNakit,
    required RastgeleAkis akis,
  }) {
    if (borclar.isEmpty) {
      return const BorcTurSonucu(
        borclar: [],
        odenenTaksit: 0,
        krediNotuDegisimi: 0,
        kapananlar: [],
        gecikenler: [],
        takibeDusenler: [],
      );
    }

    final sirali = [...borclar]..sort((a, b) {
        final fark = b.aylikFaiz.compareTo(a.aylikFaiz);
        return fark != 0 ? fark : a.id.compareTo(b.id);
      });

    final guncel = <Borc>[];
    final kapananlar = <String>[];
    final gecikenler = <String>[];
    final takibeDusenler = <String>[];
    var odenen = 0;
    var kalanNakit = odenebilirNakit;
    var krediNotu = 0;

    for (final borc in sirali) {
      if (borc.kapandi) {
        kapananlar.add(borc.id);
        continue;
      }

      if (kalanNakit >= borc.aylikTaksit) {
        kalanNakit -= borc.aylikTaksit;
        odenen += borc.aylikTaksit;

        final anaparaPayi = borc.aylikTaksit - borc.donemFaizi;
        final yeniAnapara = borc.kalanAnapara - anaparaPayi;
        final yeni = borc.copyWith(
          // Son taksitte yuvarlama artığı kalmasın.
          kalanAnapara:
              borc.kalanTaksit <= 1 || yeniAnapara < 0 ? 0 : yeniAnapara,
          kalanTaksit: borc.kalanTaksit - 1,
          gecikmeTuru: 0,
        );
        if (yeni.kapandi) {
          kapananlar.add(yeni.id);
          krediNotu += ayarlar.kapanisKrediNotuArtisi;
        } else {
          guncel.add(yeni);
        }
      } else {
        // Ödenemedi: gecikme cezası anaparaya biner, borç büyür.
        final ceza = (borc.kalanAnapara * ayarlar.gecikmeCezasi).round();
        final yeni = borc.copyWith(
          kalanAnapara: borc.kalanAnapara + ceza,
          gecikmeTuru: borc.gecikmeTuru + 1,
        );
        gecikenler.add(yeni.id);
        krediNotu -= ayarlar.gecikmeKrediNotuDususu;
        if (yeni.gecikmeTuru >= ayarlar.takipEsigi) {
          takibeDusenler.add(yeni.id);
        }
        guncel.add(yeni);
      }
    }

    guncel.sort((a, b) => a.id.compareTo(b.id));
    return BorcTurSonucu(
      borclar: guncel,
      odenenTaksit: odenen,
      krediNotuDegisimi: krediNotu,
      kapananlar: kapananlar,
      gecikenler: gecikenler,
      takibeDusenler: takibeDusenler,
    );
  }

  /// Anüite formülünün tersi: taksitten anapara.
  int _anaparaCoz(int taksit, double aylikFaiz, int vade) {
    if (vade <= 0) return 0;
    if (aylikFaiz <= 0) return taksit * vade;
    var carpan = 1.0;
    for (var i = 0; i < vade; i++) {
      carpan *= 1 + aylikFaiz;
    }
    return (taksit * (1 - 1 / carpan) / aylikFaiz).floor();
  }
}
