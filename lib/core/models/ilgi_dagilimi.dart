import 'package:freezed_annotation/freezed_annotation.dart';

part 'ilgi_dagilimi.freezed.dart';
part 'ilgi_dagilimi.g.dart';

/// Oyuncunun bir turda işletmelerine ayırdığı ilgi.
///
/// ANAYASANIN KALDIRILAMAZ KISITI. İlgi puanı [ZamanDagilimi]'ndan AYRI bir
/// kaynaktır — aynı havuza konsaydı işletme sahibi olmak kariyeri otomatik
/// bitirirdi. Ama kendi içinde sınırlıdır: yeterince ilgi görmeyen
/// işletmenin geliri düşer ve kriz olayı ihtimali artar. Oyunun strateji
/// derinliği "kaç işletmeyi aynı anda ayakta tutabilirim" sorusundan gelir;
/// CEO atamak bu yükü paraya çevirir, bedava kaldırmaz.
@freezed
abstract class IlgiDagilimi with _$IlgiDagilimi {
  const IlgiDagilimi._();

  const factory IlgiDagilimi({
    /// İşletme örnek kimliği → ayrılan puan.
    @Default(<String, int>{}) Map<String, int> puanlar,
  }) = _IlgiDagilimi;

  factory IlgiDagilimi.fromJson(Map<String, dynamic> json) =>
      _$IlgiDagilimiFromJson(json);

  /// Her turda dağıtılacak toplam ilgi puanı.
  ///
  /// 6, "iki orta ölçekli işletme rahat, üçüncüsü zorlar" hissini veriyor:
  /// kafenin yükü 2, oto galerininki 3. CEO'suz üç işletme taşımak
  /// matematiksel olarak mümkün değil; bu bilerek böyle.
  static const int toplamPuan = 6;

  int puan(String isletmeId) => puanlar[isletmeId] ?? 0;

  int get toplam => puanlar.values.fold(0, (t, p) => t + p);

  int get bosPuan => toplamPuan - toplam;

  bool get gecerli =>
      puanlar.values.every((p) => p >= 0) && toplam <= toplamPuan;

  IlgiDagilimi ayarla(String isletmeId, int puan) => copyWith(
        puanlar: {...puanlar, isletmeId: puan < 0 ? 0 : puan},
      );

  IlgiDagilimi kaldir(String isletmeId) =>
      copyWith(puanlar: {...puanlar}..remove(isletmeId));

  /// Sınır dışı girdiyi güvenli hale getirir. Fazlalık, en çok puan alan
  /// işletmeden başlayarak kırpılır: oyuncunun az puan ayırdığı işletme
  /// sessizce sıfırlanmasın, büyük yatırım küçüğü ezmesin.
  IlgiDagilimi duzelt() {
    final temiz = <String, int>{
      for (final g in puanlar.entries)
        if (g.value > 0) g.key: g.value,
    };
    var fazla = temiz.values.fold(0, (t, p) => t + p) - toplamPuan;
    if (fazla <= 0) return IlgiDagilimi(puanlar: temiz);

    final sirali = temiz.keys.toList()
      ..sort((a, b) {
        final fark = temiz[b]!.compareTo(temiz[a]!);
        return fark != 0 ? fark : a.compareTo(b); // Belirlenimli sıra.
      });
    for (final id in sirali) {
      if (fazla <= 0) break;
      final kirp = temiz[id]! < fazla ? temiz[id]! : fazla;
      temiz[id] = temiz[id]! - kirp;
      fazla -= kirp;
    }
    temiz.removeWhere((_, v) => v == 0);
    return IlgiDagilimi(puanlar: temiz);
  }
}
