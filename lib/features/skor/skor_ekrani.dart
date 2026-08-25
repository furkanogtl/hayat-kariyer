import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/engine/skor.dart';
import '../../l10n/uygulama_metinleri.dart';
import '../../shared/bicimleme.dart';
import '../../shared/etiketler.dart';
import '../../shared/tema.dart';
import '../../shared/widgets/oyun_widgetlari.dart';
import '../oyun/oyun_saglayicilar.dart';

/// Oyun sonu ekranı. `OyunDurumu.oyunBitti` olunca kabuk yerine bu açılır.
///
/// Ana skor REEL net değer: nominal rakam 40 yılda enflasyonla şişip
/// anlamsızlaşıyor, oyuncu kendini oyun başı parasıyla ölçmeli.
class SkorEkrani extends ConsumerWidget {
  const SkorEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);
    final durum = ref.watch(oyunProvider)!.durum;
    final katalog = ref.watch(kataloglarProvider).requireValue.meslekler;
    final ozet = OyunSonuOzeti.durumdan(durum);

    String para(int reelTutar) =>
        bicim.kisaPara(durum.piyasa.gosterimTutari(reelTutar));

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
          children: [
            Text(
              m.oyunSonu,
              style: tema.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              m.oyunSonuAltBaslik(ozet.yas),
              style: tema.textTheme.bodyMedium?.copyWith(
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            OyunKarti(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ozet.unvan.ad(m),
                    style: tema.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: tema.colorScheme.primary,
                    ),
                  ),
                  Text(
                    m.unvanAcikla,
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: tema.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Divider(height: 24),
                  BilgiSatiri(
                    etiket: m.skorNetDeger,
                    deger: para(ozet.reelNetDeger),
                    renk: tema.oyun.tutar(ozet.reelNetDeger),
                    kalin: true,
                  ),
                  BilgiSatiri(
                    etiket: m.skorZirve,
                    deger: para(ozet.zirveNetDeger),
                  ),
                  BilgiSatiri(
                    etiket: m.skorKariyer,
                    deger: kariyerBasligi(durum.oyuncu.kariyer, m, katalog),
                  ),
                  if (ozet.isletmeSayisi > 0)
                    BilgiSatiri(
                      etiket: m.skorIsletme,
                      deger: m.skorIsletmeSayisi(ozet.isletmeSayisi),
                    ),
                  if (ozet.iflasSayisi > 0)
                    BilgiSatiri(
                      etiket: m.skorIflas,
                      deger: m.skorIflasSayisi(ozet.iflasSayisi),
                      renk: tema.oyun.kayip,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => ref.read(oyunProvider.notifier).oyunuBitir(),
              child: Text(m.yeniOyunaBasla),
            ),
            const SizedBox(height: 16),
            // Tohum: aynı tohum + aynı kararlar = aynı oyun. Oyuncu
            // ilginç bir hayatı tekrar oynamak isterse gerekiyor.
            Center(
              child: Text(
                '${m.skorTohum}: ${ozet.tohum}',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
