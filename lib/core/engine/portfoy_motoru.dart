import '../models/piyasa_durumu.dart';
import '../models/portfoy.dart';
import '../models/varlik.dart';

/// Alım-satım emri.
sealed class Emir {
  const Emir(this.varlikId, this.adet);

  final String varlikId;
  final double adet;
}

class Alim extends Emir {
  const Alim(super.varlikId, super.adet);
}

class Satim extends Emir {
  const Satim(super.varlikId, super.adet);
}

/// Emrin reddedilme sebebi. UI kullanıcıya bunu gösterir.
enum EmirHatasi {
  tanimsizVarlik,
  gecersizAdet,
  bolunemez,
  yetersizNakit,
  yetersizVarlik,
}

/// Bir emrin sonucu.
class EmirSonucu {
  const EmirSonucu.basarili({
    required this.emir,
    required this.gerceklesenAdet,
    required this.tutar,
    required this.komisyon,
    this.satisaCikarildi = false,
  }) : hata = null;

  const EmirSonucu.basarisiz(this.emir, this.hata)
      : gerceklesenAdet = 0,
        tutar = 0,
        komisyon = 0,
        satisaCikarildi = false;

  final Emir emir;
  final EmirHatasi? hata;
  final double gerceklesenAdet;

  /// Nakite etkisi: alımda negatif, satımda pozitif (komisyon düşülmüş).
  final int tutar;
  final int komisyon;

  /// Likit olmayan varlıkta satış hemen gerçekleşmez, kuyruğa girer.
  final bool satisaCikarildi;

  bool get basarili => hata == null;
}

/// Tamamlanan gecikmeli satış. Raporda gösterilir.
class TamamlananSatis {
  const TamamlananSatis({
    required this.varlikId,
    required this.adet,
    required this.tutar,
    required this.komisyon,
  });

  final String varlikId;
  final double adet;
  final int tutar;
  final int komisyon;
}

/// Portföyün bir turunu ve alım-satım emirlerini işler.
///
/// Saf ve deterministik; rastgelelik kullanmaz. Fiyatlar dışarıdan gelir.
class PortfoyMotoru {
  PortfoyMotoru({List<VarlikTanimi>? varliklar})
      : varliklar = {
          for (final v in varliklar ?? piyasaVarliklari) v.id: v,
        };

  final Map<String, VarlikTanimi> varliklar;

  /// Emirleri OYUNCUNUN GÖRDÜĞÜ fiyatlarla işler.
  ///
  /// Bu yüzden `TurProcessor` emirleri piyasa hareket etmeden ÖNCE çalıştırır:
  /// oyuncu ekranda gördüğü fiyattan alır, sonra piyasa oynar. Aksi halde
  /// "aldığım fiyat bu değildi" hissi oluşurdu.
  ({Portfoy portfoy, int nakitDegisimi, List<EmirSonucu> sonuclar})
      emirleriIsle(
    Portfoy portfoy,
    int nakit,
    PiyasaDurumu piyasa,
    List<Emir> emirler,
  ) {
    var guncel = portfoy;
    var kalanNakit = nakit;
    final sonuclar = <EmirSonucu>[];

    for (final emir in emirler) {
      final tanim = varliklar[emir.varlikId];
      if (tanim == null) {
        sonuclar.add(EmirSonucu.basarisiz(emir, EmirHatasi.tanimsizVarlik));
        continue;
      }
      final fiyat = piyasa.fiyat(emir.varlikId);
      if (emir.adet <= 0 || fiyat <= 0) {
        sonuclar.add(EmirSonucu.basarisiz(emir, EmirHatasi.gecersizAdet));
        continue;
      }
      if (!tanim.bolunebilir && emir.adet != emir.adet.roundToDouble()) {
        sonuclar.add(EmirSonucu.basarisiz(emir, EmirHatasi.bolunemez));
        continue;
      }

      switch (emir) {
        case Alim():
          final brut = emir.adet * fiyat;
          final komisyon = brut * tanim.islemMaliyeti;
          final toplam = (brut + komisyon).round();
          if (toplam > kalanNakit) {
            sonuclar.add(EmirSonucu.basarisiz(emir, EmirHatasi.yetersizNakit));
            continue;
          }
          kalanNakit -= toplam;
          guncel = _pozisyonEkle(
            guncel,
            emir.varlikId,
            emir.adet,
            toplam,
            piyasa.enflasyonEndeksi,
          );
          sonuclar.add(
            EmirSonucu.basarili(
              emir: emir,
              gerceklesenAdet: emir.adet,
              tutar: -toplam,
              komisyon: komisyon.round(),
            ),
          );

        case Satim():
          if (emir.adet > guncel.satilabilirAdet(emir.varlikId) + 1e-9) {
            sonuclar.add(EmirSonucu.basarisiz(emir, EmirHatasi.yetersizVarlik));
            continue;
          }
          if (!tanim.likit) {
            // Kuyruğa girer; fiyat riski satıcıda kalır. Sayaç emrin
            // verildiği turun sonunda da azalır, yani oyuncu toplam
            // `satisSuresiTur` kez "turu bitir" der.
            guncel = guncel.copyWith(
              bekleyenSatislar: [
                ...guncel.bekleyenSatislar,
                BekleyenSatis(
                  varlikId: emir.varlikId,
                  adet: emir.adet,
                  kalanTur: tanim.satisSuresiTur,
                ),
              ],
            );
            sonuclar.add(
              EmirSonucu.basarili(
                emir: emir,
                gerceklesenAdet: emir.adet,
                tutar: 0,
                komisyon: 0,
                satisaCikarildi: true,
              ),
            );
            continue;
          }
          final (:net, :komisyon) = _satisTutari(tanim, emir.adet, fiyat);
          kalanNakit += net;
          guncel = _pozisyonAzalt(guncel, emir.varlikId, emir.adet);
          sonuclar.add(
            EmirSonucu.basarili(
              emir: emir,
              gerceklesenAdet: emir.adet,
              tutar: net,
              komisyon: komisyon,
            ),
          );
      }
    }

    return (
      portfoy: guncel,
      nakitDegisimi: kalanNakit - nakit,
      sonuclar: sonuclar,
    );
  }

  /// Turun portföy tarafı: kira/temettü geliri ve olgunlaşan satışlar.
  ///
  /// Piyasa hareket ETTİKTEN sonra çağrılır; bekleyen satış tamamlandığı
  /// turun fiyatından kapanır.
  ({Portfoy portfoy, int kiraGeliri, List<TamamlananSatis> satislar}) turIsle(
    Portfoy portfoy,
    PiyasaDurumu piyasa,
  ) {
    // Kira / temettü
    var kira = 0.0;
    for (final girdi in portfoy.pozisyonlar.entries) {
      final tanim = varliklar[girdi.key];
      if (tanim == null || tanim.aylikGetiriOrani <= 0) continue;
      kira += girdi.value.adet *
          piyasa.fiyat(girdi.key) *
          tanim.aylikGetiriOrani;
    }

    // Bekleyen satışlar
    var guncel = portfoy;
    final tamamlananlar = <TamamlananSatis>[];
    final kalanlar = <BekleyenSatis>[];
    for (final satis in portfoy.bekleyenSatislar) {
      final ilerlemis = satis.turIlerlet();
      if (!ilerlemis.tamamlandi) {
        kalanlar.add(ilerlemis);
        continue;
      }
      final tanim = varliklar[satis.varlikId];
      final fiyat = piyasa.fiyat(satis.varlikId);
      if (tanim == null || fiyat <= 0) continue;
      final (:net, :komisyon) = _satisTutari(tanim, satis.adet, fiyat);
      guncel = _pozisyonAzalt(guncel, satis.varlikId, satis.adet);
      tamamlananlar.add(
        TamamlananSatis(
          varlikId: satis.varlikId,
          adet: satis.adet,
          tutar: net,
          komisyon: komisyon,
        ),
      );
    }

    return (
      portfoy: guncel.copyWith(bekleyenSatislar: kalanlar),
      kiraGeliri: kira.round(),
      satislar: tamamlananlar,
    );
  }

  ({int net, int komisyon}) _satisTutari(
    VarlikTanimi tanim,
    double adet,
    double fiyat,
  ) {
    final brut = adet * fiyat;
    final komisyon = brut * tanim.islemMaliyeti;
    return (net: (brut - komisyon).round(), komisyon: komisyon.round());
  }

  Portfoy _pozisyonEkle(
    Portfoy portfoy,
    String varlikId,
    double adet,
    int odenen,
    double endeks,
  ) {
    final mevcut = portfoy.pozisyonlar[varlikId];
    final eskiMaliyet = mevcut?.maliyet() ?? 0;
    final yeniAdet = (mevcut?.adet ?? 0) + adet;
    final yeniMaliyet = (eskiMaliyet + odenen) / yeniAdet;
    // Endeks TUTARLA ağırlıklı: 1000 TL'lik eski alım ile 100.000 TL'lik
    // yeni alım ortalamaya eşit katkı yapmamalı.
    final toplamMaliyet = eskiMaliyet + odenen;
    final yeniEndeks = toplamMaliyet <= 0
        ? endeks
        : (eskiMaliyet * (mevcut?.ortalamaEndeks ?? endeks) + odenen * endeks) /
            toplamMaliyet;
    return portfoy.copyWith(
      pozisyonlar: {
        ...portfoy.pozisyonlar,
        varlikId: Pozisyon(
          adet: yeniAdet,
          ortalamaMaliyet: yeniMaliyet,
          ortalamaEndeks: yeniEndeks,
        ),
      },
    );
  }

  Portfoy _pozisyonAzalt(Portfoy portfoy, String varlikId, double adet) {
    final mevcut = portfoy.pozisyonlar[varlikId];
    if (mevcut == null) return portfoy;
    final kalan = mevcut.adet - adet;
    final yeniPozisyonlar = {...portfoy.pozisyonlar};
    if (kalan <= 1e-9) {
      yeniPozisyonlar.remove(varlikId);
    } else {
      // Ortalama maliyet satışta değişmez; gerçekleşen kâr/zarar ayrı konu.
      yeniPozisyonlar[varlikId] = mevcut.copyWith(adet: kalan);
    }
    return portfoy.copyWith(pozisyonlar: yeniPozisyonlar);
  }
}
