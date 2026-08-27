import 'package:flutter/material.dart';

import 'hareket.dart';

/// "Turu Bitir"e basınca oynayan ay geçişi.
///
/// Tur işlemek anlık bir hesap; oyuncuya zamanın aktığını gösteren bir şey
/// yoksa ekran birden değişiyor ve ne olduğu anlaşılmıyor. Bu perde eski
/// ayı yukarı süpürüp yenisini altından getiriyor.
///
/// KISA olmak zorunda: 480 turluk oyunda her tur yarım saniye eklemek
/// oturuma dakikalar bindirir. Tek tur için ~430 ms; çok turlu atlamada
/// biraz uzuyor ama tur başına düşen süre çok daha az.
Future<void> turGecisiniOynat(
  BuildContext context, {
  required String oncekiAy,
  required String sonrakiAy,
  required String altYazi,
  bool cokTur = false,
}) async {
  if (Hareket.kapali(context)) return;

  final katman = Overlay.of(context, rootOverlay: true);
  final denetim = AnimationController(
    vsync: Navigator.of(context),
    duration: cokTur
        ? const Duration(milliseconds: 620)
        : const Duration(milliseconds: 430),
  );

  final girdi = OverlayEntry(
    builder: (context) => _Perde(
      ilerleme: denetim,
      oncekiAy: oncekiAy,
      sonrakiAy: sonrakiAy,
      altYazi: altYazi,
    ),
  );

  katman.insert(girdi);
  try {
    await denetim.forward();
  } finally {
    girdi.remove();
    denetim.dispose();
  }
}

class _Perde extends StatelessWidget {
  const _Perde({
    required this.ilerleme,
    required this.oncekiAy,
    required this.sonrakiAy,
    required this.altYazi,
  });

  final Animation<double> ilerleme;
  final String oncekiAy;
  final String sonrakiAy;
  final String altYazi;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: ilerleme,
        builder: (context, _) {
          final t = ilerleme.value;
          // Perde açılıp kapanıyor: ortada tam opak, uçlarda saydam.
          final ortu = (t < 0.5 ? t / 0.5 : (1 - t) / 0.5).clamp(0.0, 1.0);
          // Ay değişimi tam ortada oluyor, perde en koyuyken.
          final gecti = t >= 0.5;
          final yazi = gecti ? sonrakiAy : oncekiAy;
          final yaziKaymasi = gecti
              ? (1 - (t - 0.5) / 0.5).clamp(0.0, 1.0) * 0.5
              : -(t / 0.5).clamp(0.0, 1.0) * 0.5;

          return Material(
            color: tema.colorScheme.scrim.withValues(alpha: 0.55 * ortu),
            child: Center(
              child: Opacity(
                opacity: ortu,
                child: FractionalTranslation(
                  translation: Offset(0, yaziKaymasi),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        yazi,
                        style: tema.textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        altYazi,
                        style: tema.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
