import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/uygulama_metinleri.dart';
import '../../shared/etiketler.dart';
import '../banka/banka_ekrani.dart';
import '../isletme/isletme_ekrani.dart';
import '../kariyer/kariyer_ekrani.dart';
import '../ozet/ozet_ekrani.dart';
import '../piyasa/piyasa_ekrani.dart';
import '../oyun/oyun_saglayicilar.dart';

/// Oyun kabuğu: üstte tarih/durum, altta sekmeler.
///
/// Piyasa ve işletme sekmeleri sonraki dilimlerde doldurulacak; şimdilik
/// yerlerini tutuyorlar ki gezinme yapısı baştan otursun.
class AnaKabuk extends ConsumerStatefulWidget {
  const AnaKabuk({super.key});

  @override
  ConsumerState<AnaKabuk> createState() => _AnaKabukDurumu();
}

class _AnaKabukDurumu extends ConsumerState<AnaKabuk> {
  int _sekme = 0;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final durum = ref.watch(oyunProvider)!.durum;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(durum.oyuncu.ad),
            Text(
              '${m.turBilgisi(ayAdi(m, durum.ay), durum.tur ~/ 12 + 1)}'
              ' · ${m.yasBilgisi(durum.yas)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: switch (_sekme) {
          0 => const OzetEkrani(),
          1 => const PiyasaEkrani(),
          2 => const BankaEkrani(),
          3 => const KariyerEkrani(),
          _ => const IsletmeEkrani(),
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _sekme,
        onDestinationSelected: (i) => setState(() => _sekme = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: m.sekmeOzet,
          ),
          NavigationDestination(
            icon: const Icon(Icons.show_chart),
            label: m.sekmePiyasa,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_outlined),
            selectedIcon: const Icon(Icons.account_balance),
            label: m.sekmeBanka,
          ),
          NavigationDestination(
            icon: const Icon(Icons.work_outline),
            selectedIcon: const Icon(Icons.work),
            label: m.sekmeKariyer,
          ),
          NavigationDestination(
            icon: const Icon(Icons.storefront_outlined),
            selectedIcon: const Icon(Icons.storefront),
            label: m.sekmeIsletme,
          ),
        ],
      ),
    );
  }
}
