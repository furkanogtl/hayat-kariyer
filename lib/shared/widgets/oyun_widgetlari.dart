import 'package:flutter/material.dart';

import '../animasyon/hareket.dart';
import '../animasyon/sayi_akisi.dart';
import '../tema.dart';

/// Bir istatistiğin çipi: simge, iri rakam, ince dolum çubuğu.
///
/// Önce "etiket + rakam + ince çubuk" satırıydı ve ekran bir form gibi
/// görünüyordu. Simge ve iri rakam, oyuncunun rakamı OKUMADAN durumu
/// görmesini sağlıyor; renk de eşiğe göre değişiyor.
class StatCubugu extends StatelessWidget {
  const StatCubugu({
    super.key,
    required this.etiket,
    required this.deger,
    required this.simge,
    this.tavan = 100,
    this.renk,
    this.uyariEsigi,
  });

  final String etiket;
  final int deger;
  final IconData simge;
  final int tavan;
  final Color? renk;

  /// Bu değerin altına düşünce çip uyarı rengine geçer (burnout,
  /// tükenmişlik eşikleri).
  final int? uyariEsigi;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esik = uyariEsigi;
    final tehlikede = esik != null && deger < esik;
    // Altın YALNIZ para ve ana eylem için; statlar da altın olursa vurgu
    // ölür. Renk verilmezse nötr bir yeşile düşülüyor.
    final vurgu =
        tehlikede ? tema.oyun.kayip : (renk ?? const Color(0xFF6FB89E));

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: tema.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: tehlikede
              ? vurgu.withValues(alpha: 0.55)
              : tema.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(simge, size: 18, color: vurgu),
              const SizedBox(width: 8),
              SayiAkisi(
                deger: deger,
                bicimle: (v) => v.round().toString(),
                stil: tema.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: tehlikede ? vurgu : tema.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            etiket,
            style: tema.textTheme.labelSmall?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
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
                minHeight: 5,
                backgroundColor: tema.colorScheme.surfaceContainerLowest,
                valueColor: AlwaysStoppedAnimation(vurgu),
              ),
            ),
          ),
        ],
      ),
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
