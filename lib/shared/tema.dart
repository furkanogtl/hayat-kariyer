import 'package:flutter/material.dart';

/// Uygulama teması.
///
/// Kart tabanlı, menü ağırlıklı bir oyun; Flame yok, normal Material
/// widget'ları kullanılıyor. Renkler anlam taşır ve tek yerden gelir:
/// kazanç yeşil, kayıp kırmızı, kriz turuncu — bu üçü ekranlarda elle
/// yazılmaz, [OyunRenkleri] üzerinden okunur.
abstract final class Tema {
  static const Color _tohum = Color(0xFF1F6F5C);

  static ThemeData acik() => _kur(Brightness.light);

  static ThemeData koyu() => _kur(Brightness.dark);

  static ThemeData _kur(Brightness parlaklik) {
    final sema = ColorScheme.fromSeed(
      seedColor: _tohum,
      brightness: parlaklik,
    );
    final karanlik = parlaklik == Brightness.dark;
    return ThemeData(
      colorScheme: sema,
      useMaterial3: true,
      scaffoldBackgroundColor: sema.surface,
      // Kartlar düz beyaz lekeler halinde duruyordu. Hafif bir kenarlık
      // ve gölge, ekranı katmanlı gösteriyor; yükseltiyi büyütmek yerine
      // kenarlık kullanıldı çünkü koyu temada gölge görünmüyor.
      cardTheme: CardThemeData(
        elevation: karanlik ? 0 : 1,
        shadowColor: sema.shadow.withValues(alpha: 0.5),
        color: sema.surfaceContainerLow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: sema.outlineVariant.withValues(alpha: karanlik ? 0.5 : 0.7),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      extensions: [
        karanlik ? OyunRenkleri.koyu : OyunRenkleri.acik,
      ],
    );
  }
}

/// Anlam taşıyan renkler. `Theme.of(context).oyun` ile okunur.
@immutable
class OyunRenkleri extends ThemeExtension<OyunRenkleri> {
  const OyunRenkleri({
    required this.kazanc,
    required this.kayip,
    required this.uyari,
    required this.notr,
  });

  static const acik = OyunRenkleri(
    kazanc: Color(0xFF1B7F3B),
    kayip: Color(0xFFB3261E),
    uyari: Color(0xFFB26A00),
    notr: Color(0xFF5F6368),
  );

  static const koyu = OyunRenkleri(
    kazanc: Color(0xFF6FD48B),
    kayip: Color(0xFFFF8A80),
    uyari: Color(0xFFFFB74D),
    notr: Color(0xFF9AA0A6),
  );

  final Color kazanc;
  final Color kayip;
  final Color uyari;
  final Color notr;

  /// Tutarın yönüne göre renk. Sıfır nötr kalır.
  Color tutar(num deger) =>
      deger > 0 ? kazanc : (deger < 0 ? kayip : notr);

  @override
  OyunRenkleri copyWith({
    Color? kazanc,
    Color? kayip,
    Color? uyari,
    Color? notr,
  }) =>
      OyunRenkleri(
        kazanc: kazanc ?? this.kazanc,
        kayip: kayip ?? this.kayip,
        uyari: uyari ?? this.uyari,
        notr: notr ?? this.notr,
      );

  @override
  OyunRenkleri lerp(ThemeExtension<OyunRenkleri>? diger, double t) {
    if (diger is! OyunRenkleri) return this;
    return OyunRenkleri(
      kazanc: Color.lerp(kazanc, diger.kazanc, t)!,
      kayip: Color.lerp(kayip, diger.kayip, t)!,
      uyari: Color.lerp(uyari, diger.uyari, t)!,
      notr: Color.lerp(notr, diger.notr, t)!,
    );
  }
}

extension OyunTemasi on ThemeData {
  OyunRenkleri get oyun => extension<OyunRenkleri>() ?? OyunRenkleri.acik;
}
