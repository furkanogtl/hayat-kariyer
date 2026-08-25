import '../models/oyun_durumu.dart';

/// Oyun sonu ünvanı. Skor ekranı bunu gösteriyor.
///
/// Eşikler ölçümlere dayanıyor: hiç yatırım yapmayan bir oyuncu 40 yılda
/// 3-21M reel biriktiriyor, borsaya yatıran 600M+ görebiliyor. Bantlar bu
/// aralığı anlamlı parçalara bölüyor.
enum OyunSonuUnvani {
  /// Eksiyle bitirdi.
  ucuUcuna,

  /// Haciz gördü ama toparlandı.
  dipteDonen,

  orta,
  rahat,
  zengin,
  imparator;

  /// Reel net değer eşikleri (oyun başı parasıyla).
  static const int ortaEsigi = 0;
  static const int rahatEsigi = 10000000;
  static const int zenginEsigi = 100000000;
  static const int imparatorEsigi = 1000000000;

  /// Haciz görmüş oyuncunun "dipten döndü" sayılması için gereken taban.
  static const int dipteDonenEsigi = rahatEsigi;
}

/// Oyunun nasıl bittiğinin özeti. Saf: durumdan türetiliyor, kayda girmiyor.
class OyunSonuOzeti {
  const OyunSonuOzeti({
    required this.reelNetDeger,
    required this.zirveNetDeger,
    required this.yas,
    required this.isletmeSayisi,
    required this.iflasSayisi,
    required this.unvan,
    required this.tohum,
  });

  factory OyunSonuOzeti.durumdan(OyunDurumu durum) {
    final net = durum.reelNetDeger;
    return OyunSonuOzeti(
      reelNetDeger: net,
      // Zirve hiç yazılmadıysa (eski kayıt) son değer kullanılıyor.
      zirveNetDeger:
          durum.zirveNetDeger > net ? durum.zirveNetDeger : net,
      yas: durum.yas,
      isletmeSayisi: durum.isletmeler.length,
      iflasSayisi: durum.iflasSayisi,
      unvan: unvanHesapla(net, durum.iflasSayisi),
      tohum: durum.anaTohum,
    );
  }

  final int reelNetDeger;
  final int zirveNetDeger;
  final int yas;
  final int isletmeSayisi;
  final int iflasSayisi;
  final OyunSonuUnvani unvan;
  final int tohum;
}

/// Reel net değer ve haciz sayısından ünvan.
///
/// Haciz görüp yine de toparlanmak ayrı bir başarı sayılıyor: aynı serveti
/// hiç düşmeden kuran ile dipten dönen aynı ünvanı almamalı.
OyunSonuUnvani unvanHesapla(int reelNetDeger, int iflasSayisi) {
  if (reelNetDeger < OyunSonuUnvani.ortaEsigi) return OyunSonuUnvani.ucuUcuna;
  if (iflasSayisi > 0 && reelNetDeger >= OyunSonuUnvani.dipteDonenEsigi) {
    return OyunSonuUnvani.dipteDonen;
  }
  if (reelNetDeger >= OyunSonuUnvani.imparatorEsigi) {
    return OyunSonuUnvani.imparator;
  }
  if (reelNetDeger >= OyunSonuUnvani.zenginEsigi) {
    return OyunSonuUnvani.zengin;
  }
  if (reelNetDeger >= OyunSonuUnvani.rahatEsigi) return OyunSonuUnvani.rahat;
  return OyunSonuUnvani.orta;
}
