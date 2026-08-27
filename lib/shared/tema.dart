import 'package:flutter/material.dart';

/// Oyunun teması.
///
/// TEK TEMA, açık/koyu ikiliği YOK. Bir oyunun sanat yönü vardır; işletim
/// sisteminin tema ayarını takip etmez. İlk sürüm Material'ın varsayılan
/// açık şemasını kullanıyordu ve oyun "bankacılık uygulaması gibi"
/// görünüyordu — beyaz zemin, etiket+rakam satırları, ince çubuklar.
///
/// Yön: koyu yeşil-siyah zemin + altın vurgu. Altın YALNIZ paraya ve ana
/// eyleme ayrıldı; her yere serpilirse vurgu olmaktan çıkar.
///
/// Renkler anlam taşır ve tek yerden gelir: kazanç yeşil, kayıp kırmızı,
/// kriz turuncu. Bunlar ekranlarda elle yazılmaz, [OyunRenkleri] üzerinden
/// okunur.
abstract final class Tema {
  // --- Zemin katmanları: en dipten yüzeye ------------------------------
  static const Color _dip = Color(0xFF0A1F1A);
  static const Color _zemin = Color(0xFF0E2620);
  static const Color _kat1 = Color(0xFF16332B);
  static const Color _kat2 = Color(0xFF1C3E34);
  static const Color _kat3 = Color(0xFF234B3F);

  /// Ana vurgu: para, ana düğme, öne çıkan rakam.
  static const Color altin = Color(0xFFE8B84B);
  static const Color _altinKoyu = Color(0xFF3A2C05);

  static const Color _metin = Color(0xFFE8EFE9);
  static const Color _metinSolgun = Color(0xFF9CB3A8);
  static const Color _cizgi = Color(0xFF2F5548);

  /// Ekranların arkasındaki en koyu ton. Gradyan zemin bundan türüyor.
  static Color get dipRengi => _dip;

  static ThemeData oyun() {
    const sema = ColorScheme.dark(
      primary: altin,
      onPrimary: _altinKoyu,
      primaryContainer: Color(0xFF4A3A0C),
      onPrimaryContainer: Color(0xFFF6DFA4),
      secondary: Color(0xFF5FD48B),
      onSecondary: Color(0xFF06301A),
      surface: _zemin,
      onSurface: _metin,
      surfaceContainerLowest: _dip,
      surfaceContainerLow: _kat1,
      surfaceContainer: _kat1,
      surfaceContainerHigh: _kat2,
      surfaceContainerHighest: _kat3,
      onSurfaceVariant: _metinSolgun,
      outline: _cizgi,
      outlineVariant: Color(0xFF24443A),
      error: Color(0xFFFF6B5E),
      onError: Color(0xFF3B0906),
      scrim: Color(0xFF04120E),
    );

    final taban = ThemeData(colorScheme: sema, useMaterial3: true);

    return taban.copyWith(
      scaffoldBackgroundColor: _zemin,
      // Tipografi: ağırlık ve harf aralığı karakteri veriyor. Font dosyası
      // PAKETLENMEDİ — lisansı denetlenmiş bir yazı tipi elde yok ve
      // `google_fonts` çalışma zamanında indirme yapıyor; oyun tamamen
      // çevrimdışı çalışmalı.
      textTheme: taban.textTheme
          .apply(bodyColor: _metin, displayColor: _metin)
          .copyWith(
            displaySmall: taban.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
            headlineMedium: taban.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
            titleLarge: taban.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
            labelSmall: taban.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: _kat1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFF244639)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          backgroundColor: altin,
          foregroundColor: _altinKoyu,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          // Size.fromHeight genişliği SONSUZ yapıyor; bu düğme Row içinde
          // de kullanılıyor (varlık detayında al/sat) ve orada yerleşim
          // patlıyordu. Yalnız asgari yükseklik veriliyor.
          minimumSize: const Size(0, 50),
          foregroundColor: _metin,
          backgroundColor: _kat2,
          side: const BorderSide(color: _cizgi),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _dip,
        indicatorColor: altin.withValues(alpha: 0.18),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _kat1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
      ),
      // Varsayılan seçili rengi parlak yeşile düşüyor ve altın paletle
      // çakışıyordu.
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: _kat1,
          foregroundColor: _metinSolgun,
          selectedBackgroundColor: altin.withValues(alpha: 0.20),
          selectedForegroundColor: altin,
          side: const BorderSide(color: _cizgi),
        ),
      ),
      dividerTheme: const DividerThemeData(color: _cizgi, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _kat1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _cizgi),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _cizgi),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: altin,
        linearTrackColor: Color(0xFF1C3E34),
      ),
      extensions: const [OyunRenkleri.varsayilan],
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
    required this.vurgu,
  });

  /// Koyu zemine göre ayarlandı: açık temadaki koyu yeşil/kırmızı burada
  /// okunmuyordu.
  static const varsayilan = OyunRenkleri(
    kazanc: Color(0xFF63D68E),
    kayip: Color(0xFFFF7A6B),
    uyari: Color(0xFFFFC163),
    notr: Color(0xFF9CB3A8),
    vurgu: Tema.altin,
  );

  final Color kazanc;
  final Color kayip;
  final Color uyari;
  final Color notr;

  /// Para ve ana eylem rengi.
  final Color vurgu;

  /// Tutarın yönüne göre renk. Sıfır nötr kalır.
  Color tutar(num deger) => deger > 0 ? kazanc : (deger < 0 ? kayip : notr);

  @override
  OyunRenkleri copyWith({
    Color? kazanc,
    Color? kayip,
    Color? uyari,
    Color? notr,
    Color? vurgu,
  }) =>
      OyunRenkleri(
        kazanc: kazanc ?? this.kazanc,
        kayip: kayip ?? this.kayip,
        uyari: uyari ?? this.uyari,
        notr: notr ?? this.notr,
        vurgu: vurgu ?? this.vurgu,
      );

  @override
  OyunRenkleri lerp(ThemeExtension<OyunRenkleri>? diger, double t) {
    if (diger is! OyunRenkleri) return this;
    return OyunRenkleri(
      kazanc: Color.lerp(kazanc, diger.kazanc, t)!,
      kayip: Color.lerp(kayip, diger.kayip, t)!,
      uyari: Color.lerp(uyari, diger.uyari, t)!,
      notr: Color.lerp(notr, diger.notr, t)!,
      vurgu: Color.lerp(vurgu, diger.vurgu, t)!,
    );
  }
}

extension OyunTemasi on ThemeData {
  OyunRenkleri get oyun =>
      extension<OyunRenkleri>() ?? OyunRenkleri.varsayilan;
}
