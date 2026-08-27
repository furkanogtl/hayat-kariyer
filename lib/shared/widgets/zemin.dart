import 'package:flutter/material.dart';

import '../tema.dart';

/// Ekranların arkasındaki gradyan zemin.
///
/// Düz bir yüzey oyunu form gibi gösteriyordu. Gradyan derinlik veriyor
/// ama ölçülü: amaç dekorasyon değil, kartların üstünde durduğu bir
/// zemin. Kontrast bozulursa metin okunaklığı gider.
class ZeminGradyani extends StatelessWidget {
  const ZeminGradyani({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sema = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // Üstte altına çalan hafif bir sıcaklık, dipte en koyu ton.
            Color.lerp(sema.surface, sema.primary, 0.06)!,
            sema.surface,
            Tema.dipRengi,
          ],
          stops: const [0, 0.4, 1],
        ),
      ),
      child: child,
    );
  }
}
