import 'package:flutter/material.dart';

/// Ekranların arkasındaki gradyan zemin.
///
/// Düz beyaz bir yüzey oyunu form gibi gösteriyordu. Gradyan ÇOK hafif
/// tutuluyor: amaç dekorasyon değil, kartların üstünde durduğu bir
/// derinlik oluşturmak. Kontrast bozulursa metin okunaklığı gider.
class ZeminGradyani extends StatelessWidget {
  const ZeminGradyani({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sema = Theme.of(context).colorScheme;
    final karanlik = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(
              sema.surface,
              sema.primary,
              karanlik ? 0.07 : 0.05,
            )!,
            sema.surface,
            Color.lerp(
              sema.surface,
              sema.primary,
              karanlik ? 0.04 : 0.03,
            )!,
          ],
          stops: const [0, 0.45, 1],
        ),
      ),
      child: child,
    );
  }
}
