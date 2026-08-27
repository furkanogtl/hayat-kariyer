import 'package:flutter/material.dart';

import 'haberci.dart';
import 'hareket.dart';

/// Kartı getiren kişinin sahneye girip eşyayı uzattığı bant.
///
/// Zaman çizelgesi tek bir denetleyicide: 0–0,55 yürüyerek girer,
/// 0,55–1 kolunu uzatır. Bittiğinde [onTamamlandi] çağrılır ve kart
/// içeriği açılır.
///
/// SAHNEYE DOKUNMAK ANİMASYONU BİTİRİR. Oyun 480 tur; aynı girişi
/// yüzlerce kez izlemek isteyen olmaz.
class HaberciSahnesi extends StatefulWidget {
  const HaberciSahnesi({
    super.key,
    required this.tip,
    required this.onTamamlandi,
    this.yukseklik = 210,
  });

  final HaberciTipi tip;
  final VoidCallback onTamamlandi;

  /// Sahne bandının yüksekliği. Figür yüksekliğe göre ölçekleniyor, yani
  /// bu değer doğrudan figürün boyu demek; 172'de bant içinde küçük
  /// kalıyordu.
  final double yukseklik;

  @override
  State<HaberciSahnesi> createState() => _HaberciSahnesiDurumu();
}

class _HaberciSahnesiDurumu extends State<HaberciSahnesi>
    with SingleTickerProviderStateMixin {
  late final AnimationController _denetim = AnimationController(
    vsync: this,
    duration: Hareket.uzun + Hareket.orta,
  );
  bool _bildirildi = false;

  @override
  void initState() {
    super.initState();
    _denetim.addStatusListener((durum) {
      if (durum == AnimationStatus.completed) _bildir();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (Hareket.kapali(context)) {
        _denetim.value = 1;
      } else {
        _denetim.forward();
      }
    });
  }

  void _bildir() {
    if (_bildirildi) return;
    _bildirildi = true;
    widget.onTamamlandi();
  }

  /// Dokununca sona atla.
  void _atla() {
    if (_denetim.isCompleted) return;
    _denetim.value = 1;
  }

  @override
  void dispose() {
    _denetim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Oyunun tek teması koyu; haberci paletini de ona göre alıyor.
    const karanlik = true;

    return GestureDetector(
      onTap: _atla,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: widget.yukseklik,
        child: AnimatedBuilder(
          animation: _denetim,
          builder: (context, _) {
            final t = _denetim.value;
            // Girişin bittiği an: buradan sonra kol uzanmaya başlıyor.
            const girisSonu = 0.55;
            final giris = (t / girisSonu).clamp(0.0, 1.0);
            final uzatma =
                ((t - girisSonu) / (1 - girisSonu)).clamp(0.0, 1.0);

            final kayma = (1 - Curves.easeOutCubic.transform(giris)) * -0.85;
            // Yürüyüş yalnız girişte; sonra ayaklar sabit.
            final yurume = giris < 1 ? giris * 2 : 0.0;

            return Stack(
              fit: StackFit.expand,
              children: [
                _Zemin(karanlik: karanlik),
                FractionalTranslation(
                  translation: Offset(kayma, 0),
                  child: Opacity(
                    opacity: giris.clamp(0.0, 1.0),
                    child: CustomPaint(
                      painter: HaberciCizimi(
                        tip: widget.tip,
                        yurume: yurume,
                        uzatma: Curves.easeOutBack.transform(uzatma).clamp(0.0, 1.0),
                        karanlik: karanlik,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Karakterin üstünde durduğu zemin. Düz beyaz yerine derinlik veriyor.
class _Zemin extends StatelessWidget {
  const _Zemin({required this.karanlik});

  final bool karanlik;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // Oyunun ana rengiyle hafifçe tonlanıyor: nötr gri bir kutu
            // sahneden çok yer tutucu gibi duruyordu.
            Color.lerp(
              tema.colorScheme.surfaceContainerHighest,
              tema.colorScheme.primary,
              karanlik ? 0.14 : 0.10,
            )!,
            Color.lerp(
              tema.colorScheme.surfaceContainerHighest,
              tema.colorScheme.primary,
              karanlik ? 0.05 : 0.02,
            )!,
          ],
        ),
      ),
      child: Align(
        alignment: const Alignment(0, 0.86),
        child: FractionallySizedBox(
          widthFactor: 0.86,
          child: Container(
            height: 1.5,
            color: tema.colorScheme.onSurfaceVariant.withValues(alpha: 0.18),
          ),
        ),
      ),
    );
  }
}
