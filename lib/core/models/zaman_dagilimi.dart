import 'package:freezed_annotation/freezed_annotation.dart';

part 'zaman_dagilimi.freezed.dart';
part 'zaman_dagilimi.g.dart';

/// Oyuncunun bir turda zamanını nasıl böldüğü.
///
/// Toplam puan SABİTTİR: her şeyi aynı anda yapamamak oyunun temel
/// kısıtıdır. Çalışmak para ve terfi getirir ama enerji yakar; eğitim
/// geleceği satın alır ama bugünü boşa harcatır; network fırsat kartlarının
/// kalitesini yükseltir; dinlenmek tükenmeyi önler.
///
/// İşletme "ilgi puanı" bundan AYRI bir kaynaktır (bkz. işletme sistemi);
/// aynı havuza konsaydı işletme sahibi olmak kariyeri otomatik bitirirdi.
@freezed
abstract class ZamanDagilimi with _$ZamanDagilimi {
  const ZamanDagilimi._();

  const factory ZamanDagilimi({
    @Default(0) int calisma,
    @Default(0) int egitim,
    @Default(0) int network,
    @Default(0) int dinlenme,
  }) = _ZamanDagilimi;

  factory ZamanDagilimi.fromJson(Map<String, dynamic> json) =>
      _$ZamanDagilimiFromJson(json);

  /// Her turda dağıtılacak toplam puan.
  static const int toplamPuan = 10;

  /// Varsayılan: çalış ağırlıklı, biraz eğitim ve dinlenme.
  factory ZamanDagilimi.dengeli() => const ZamanDagilimi(
        calisma: 5,
        egitim: 2,
        network: 1,
        dinlenme: 2,
      );

  /// Tükenmişliğe giden yol. Test ve "hepsini işe ver" düğmesi için.
  factory ZamanDagilimi.tamMesai() =>
      const ZamanDagilimi(calisma: toplamPuan);

  /// Öğrenci/askerlik gibi çalışmanın mümkün olmadığı durumların varsayılanı.
  factory ZamanDagilimi.calismadan() =>
      const ZamanDagilimi(egitim: 6, network: 1, dinlenme: 3);

  int get toplam => calisma + egitim + network + dinlenme;

  /// Dağıtılmamış puan. Oyuncu isterse boş bırakabilir; boş puan hiçbir şey
  /// yapmaz ama enerji de yakmaz.
  int get bosPuan => toplamPuan - toplam;

  bool get gecerli =>
      calisma >= 0 &&
      egitim >= 0 &&
      network >= 0 &&
      dinlenme >= 0 &&
      toplam <= toplamPuan;

  /// Çalışmaya ayrılan payın oranı (0-1). Performans hesabının girdisi.
  double get calismaOrani => calisma / toplamPuan;

  /// Sınır dışı girdiyi güvenli hale getirir. UI'dan bozuk değer gelirse
  /// motorun çökmemesi için.
  ZamanDagilimi duzelt() {
    var c = calisma < 0 ? 0 : calisma;
    var e = egitim < 0 ? 0 : egitim;
    var n = network < 0 ? 0 : network;
    var d = dinlenme < 0 ? 0 : dinlenme;
    // Fazlalık en son kalemden başlayarak kırpılır.
    var fazla = c + e + n + d - toplamPuan;
    if (fazla > 0) {
      for (final kirp in [
        () {
          final k = d < fazla ? d : fazla;
          d -= k;
          fazla -= k;
        },
        () {
          final k = n < fazla ? n : fazla;
          n -= k;
          fazla -= k;
        },
        () {
          final k = e < fazla ? e : fazla;
          e -= k;
          fazla -= k;
        },
        () {
          final k = c < fazla ? c : fazla;
          c -= k;
          fazla -= k;
        },
      ]) {
        if (fazla <= 0) break;
        kirp();
      }
    }
    return ZamanDagilimi(calisma: c, egitim: e, network: n, dinlenme: d);
  }
}
