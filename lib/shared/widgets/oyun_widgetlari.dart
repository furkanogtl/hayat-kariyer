import 'package:flutter/material.dart';

import '../animasyon/hareket.dart';
import '../animasyon/sayi_akisi.dart';
import '../tema.dart';

/// 0-tavan aralığındaki bir istatistiğin çubuğu (enerji, mutluluk, itibar).
class StatCubugu extends StatelessWidget {
  const StatCubugu({
    super.key,
    required this.etiket,
    required this.deger,
    this.tavan = 100,
    this.renk,
    this.uyariEsigi,
  });

  final String etiket;
  final int deger;
  final int tavan;
  final Color? renk;

  /// Bu değerin altına düşünce çubuk uyarı rengine geçer (burnout,
  /// tükenmişlik eşikleri).
  final int? uyariEsigi;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esik = uyariEsigi;
    final tehlikede = esik != null && deger < esik;
    final cubukRengi = tehlikede
        ? tema.oyun.kayip
        : (renk ?? tema.colorScheme.primary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(etiket, style: tema.textTheme.labelMedium),
            SayiAkisi(
              deger: deger,
              bicimle: (v) => v.round().toString(),
              stil: tema.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: tehlikede ? tema.oyun.kayip : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          // Çubuk da sayıyla birlikte akıyor; ikisi ayrı hızda giderse
          // göz tutarsızlığı yakalıyor.
          child: TweenAnimationBuilder<double>(
            tween: Tween(
              end: tavan == 0 ? 0 : (deger / tavan).clamp(0.0, 1.0),
            ),
            duration: Hareket.sure(context, Hareket.sayac),
            curve: Hareket.giris,
            builder: (context, oran, _) => LinearProgressIndicator(
              value: oran,
              minHeight: 6,
              backgroundColor: tema.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(cubukRengi),
            ),
          ),
        ),
      ],
    );
  }
}

/// Etiket + değer satırı. Rapor ve özet listelerinde kullanılıyor.
class BilgiSatiri extends StatelessWidget {
  const BilgiSatiri({
    super.key,
    required this.etiket,
    required this.deger,
    this.renk,
    this.kalin = false,
  });

  final String etiket;
  final String deger;
  final Color? renk;
  final bool kalin;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              etiket,
              style: tema.textTheme.bodyMedium?.copyWith(
                color: tema.colorScheme.onSurfaceVariant,
                fontWeight: kalin ? FontWeight.w600 : null,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            deger,
            style: tema.textTheme.bodyMedium?.copyWith(
              fontWeight: kalin ? FontWeight.w700 : FontWeight.w600,
              color: renk,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ekran içi bölüm başlığı.
class BolumBasligi extends StatelessWidget {
  const BolumBasligi(this.metin, {super.key, this.sag});

  final String metin;
  final Widget? sag;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            metin,
            style: tema.textTheme.titleSmall?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
          ?sag,
        ],
      ),
    );
  }
}

/// İçeriği kenar boşluğuyla saran standart kart.
class OyunKarti extends StatelessWidget {
  const OyunKarti({super.key, required this.child, this.dolgu = 16});

  final Widget child;
  final double dolgu;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: EdgeInsets.all(dolgu),
          child: child,
        ),
      );
}
