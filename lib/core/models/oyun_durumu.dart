import 'package:freezed_annotation/freezed_annotation.dart';

import 'borc.dart';
import 'ilgi_dagilimi.dart';
import 'isletme.dart';
import 'olay.dart';
import 'oyuncu.dart';
import 'piyasa_durumu.dart';
import 'portfoy.dart';

part 'oyun_durumu.freezed.dart';
part 'oyun_durumu.g.dart';

/// Kayıt dosyasının kökü. Tek JSON dokümanı olarak diske yazılır.
///
/// Tur sayacı BURADA TUTULMAZ; `oyuncu.tur` tek kaynaktır. İki yerde tutulsa
/// er ya da geç birbirinden kayardı — yaş/tur ilişkisinde verilen kararın
/// aynısı.
@freezed
abstract class OyunDurumu with _$OyunDurumu {
  const OyunDurumu._();

  const factory OyunDurumu({
    /// Oyunun tohumu. Aynı tohum + aynı kararlar = aynı oyun.
    /// Bug tekrar üretimi buna bağlı.
    required int anaTohum,
    required Oyuncu oyuncu,
    required PiyasaDurumu piyasa,
    @Default(Portfoy()) Portfoy portfoy,

    /// Oyuncunun sahip olduğu işletmeler.
    @Default(<Isletme>[]) List<Isletme> isletmeler,

    /// Bu turda işletmelere ayrılan ilgi. Zaman dağılımından AYRI kaynak.
    @Default(IlgiDagilimi()) IlgiDagilimi ilgi,

    /// Açık krediler. Tutarları NOMİNAL TL.
    @Default(<Borc>[]) List<Borc> borclar,

    /// Sonucu bekleyen kararlar.
    @Default(<BekleyenOlay>[]) List<BekleyenOlay> bekleyenOlaylar,

    /// Olay kimliği -> en son görüldüğü tur. Aynı kartın üst üste çıkmasını
    /// ve tek seferlik kartların tekrarını bu engelliyor.
    @Default(<String, int>{}) Map<String, int> olayGecmisi,

    /// Maaşların bağlı olduğu fiyat endeksi.
    ///
    /// Enflasyon endeksinden ayrı tutuluyor çünkü maaş yılda bir (ocakta)
    /// zamlanır, giderler her ay artar. Aradaki makas oyunun en gerçekçi
    /// baskısı: yıl ortasında alım gücü erir, ocakta düzelir.
    @Default(1.0) double maasEndeksi,

    /// Kayıt biçimi sürümü. İleride şema değişirse göç buradan yönetilir.
    @Default(1) int kayitSurumu,
  }) = _OyunDurumu;

  factory OyunDurumu.fromJson(Map<String, dynamic> json) =>
      _$OyunDurumuFromJson(json);

  /// Oynanan tur (ay). `oyuncu.tur` ile aynı; kolaylık için.
  int get tur => oyuncu.tur;

  int get yas => oyuncu.yas;

  int get ay => oyuncu.ay;

  /// Maaşın enflasyon karşısında ne kadar geride kaldığı (0.15 = %15 erimiş).
  /// Ocakta sıfırlanır.
  double get alimGucuKaybi =>
      1 - maasEndeksi / piyasa.enflasyonEndeksi;

  /// İşletmelerin toplam değeri (ham TL). Motorun her tur yazdığı
  /// değerlemeden okunur; katalog burada bilinmez.
  int get isletmeDegeri =>
      isletmeler.fold(0, (t, i) => t + i.guncelDeger);

  /// Portföyün güncel piyasa değeri (ham TL).
  int get portfoyDegeri => portfoy.piyasaDegeri(piyasa.fiyatlar).round();

  /// Kalan toplam borç (ham TL).
  int get toplamBorc => borclar.fold(0, (t, b) => t + b.kalanAnapara);

  /// Aylık taksit yükü (ham TL). UI ve banka kapısı bunu okur.
  int get taksitYuku =>
      borclar.where((b) => !b.kapandi).fold(0, (t, b) => t + b.aylikTaksit);

  /// Ana skor.
  int get netDeger => oyuncu.netDeger(
        varliklar: portfoyDegeri + isletmeDegeri,
        borclar: toplamBorc,
      );

  /// Net değerin oyun başı parasına indirgenmiş hali. Skor ekranı bunu
  /// gösterir; nominal rakam enflasyonla şişip anlamsızlaşır.
  int get reelNetDeger => piyasa.reeleCevir(netDeger);

  /// Kayıttan yüklenen veriyi güvenli hale getirir.
  OyunDurumu duzelt() => copyWith(
        oyuncu: oyuncu.duzelt(),
        portfoy: portfoy.duzelt(),
        isletmeler: [for (final i in isletmeler) i.duzelt()],
        ilgi: ilgi.duzelt(),
        borclar: [
          for (final b in borclar)
            if (!b.duzelt().kapandi) b.duzelt(),
        ],
        bekleyenOlaylar: [
          for (final b in bekleyenOlaylar)
            if (b.kalanTur >= 0) b else b.copyWith(kalanTur: 0),
        ],
        maasEndeksi: maasEndeksi <= 0 ? 1.0 : maasEndeksi,
      );
}
