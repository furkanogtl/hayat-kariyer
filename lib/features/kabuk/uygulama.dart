import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/uygulama_metinleri.dart';
import '../../shared/tema.dart';
import '../baslangic/yeni_oyun_ekrani.dart';
import '../oyun/oyun_saglayicilar.dart';
import '../skor/skor_ekrani.dart';
import 'ana_kabuk.dart';

class HayatKariyerUygulamasi extends StatelessWidget {
  const HayatKariyerUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => UygulamaMetinleri.of(context).uygulamaAdi,
      localizationsDelegates: const [
        UygulamaMetinleri.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: UygulamaMetinleri.supportedLocales,
      // TR varsayılan: cihaz dili desteklenmiyorsa Türkçeye düşer.
      locale: const Locale('tr'),
      theme: Tema.acik(),
      darkTheme: Tema.koyu(),
      home: const _Giris(),
    );
  }
}

/// Katalogları yükler, sonra oyun var mı yok mu diye bakar.
///
/// Katalog yüklenmeden hiçbir ekran açılmıyor; böylece ağacın geri kalanı
/// `requireValue` ile senkron çalışabiliyor.
class _Giris extends ConsumerWidget {
  const _Giris();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    return ref.watch(kataloglarProvider).when(
          loading: () => Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(m.yukleniyor),
                ],
              ),
            ),
          ),
          error: (hata, iz) => Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      m.hataBaslik,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text('$hata', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
          data: (_) {
            final oturum = ref.watch(oyunProvider);
            if (oturum == null) return const YeniOyunEkrani();
            // Oyun bitince kabuk yerine skor ekranı; sekmelere dönüş yok,
            // hayat bitti.
            return oturum.durum.oyunBitti
                ? const SkorEkrani()
                : const AnaKabuk();
          },
        );
  }
}
