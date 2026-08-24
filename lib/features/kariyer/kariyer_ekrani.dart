import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/kariyer_durumu.dart';
import '../../core/models/meslek.dart';
import '../../core/models/oyuncu.dart';
import '../../core/models/sektor.dart';
import '../../l10n/uygulama_metinleri.dart';
import '../../shared/bicimleme.dart';
import '../../shared/etiketler.dart';
import '../../shared/tema.dart';
import '../../shared/widgets/oyun_widgetlari.dart';
import '../oyun/oyun_saglayicilar.dart';

/// Kariyer ekranı: mevcut durum, sektör yetkinlikleri ve girilebilecek
/// işler.
///
/// İşe giriş bir TALEPTİR: turu bitirene kadar uygulanmaz. Kredi talebiyle
/// aynı şablon — bütün komutlar tek `TurGirdisi` kapısından geçiyor.
class KariyerEkrani extends ConsumerWidget {
  const KariyerEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);
    final durum = ref.watch(oyunProvider)!.durum;
    final oyuncu = durum.oyuncu;
    final katalog = ref.watch(kataloglarProvider).requireValue.meslekler;
    final talepler = ref.watch(taleplerProvider);

    // Maaşlar TABAN TL yazılıdır; ekranda bugünkü paranın karşılığı
    // gösteriliyor, yani endeksleme yapılmadan doğrudan reel tutar.
    String tabanPara(int tabanTl) =>
        bicim.kisaPara(durum.piyasa.gosterimTutari(tabanTl));

    final acikIsler = katalog.girilebilirler(oyuncu)
      ..sort((a, b) => a.kademeler.first.maas.compareTo(b.kademeler.first.maas));
    final calisiyor = oyuncu.kariyer is Calisan;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        OyunKarti(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kariyerBasligi(oyuncu.kariyer, m, katalog),
                style: tema.textTheme.titleMedium,
              ),
              if (oyuncu.kariyer case Calisan(:final meslekId))
                if (katalog.bul(meslekId) case final meslek?) ...[
                  const SizedBox(height: 12),
                  _Merdiven(meslek: meslek, oyuncu: oyuncu),
                ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        BolumBasligi(m.yetkinlikler),
        OyunKarti(
          child: Column(
            children: [
              for (final s in Sektor.values)
                if (oyuncu.yetkinlik(s) > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: StatCubugu(
                      etiket: s.ad(m),
                      deger: oyuncu.yetkinlik(s),
                    ),
                  ),
              // Hiç yetkinliği yoksa boş kart yerine açıklama.
              if (Sektor.values.every((s) => oyuncu.yetkinlik(s) == 0))
                Text(
                  m.uygunIsYok,
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: tema.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        BolumBasligi(m.acikPozisyonlar),
        if (talepler.iseGirTalebi case final id?)
          _TalepKarti(
            metin: m.basvuruYapildi(katalog.bul(id)?.ad ?? id),
            iptal: () => ref.read(taleplerProvider.notifier).iseGir(null),
          )
        else if (acikIsler.isEmpty)
          OyunKarti(child: Text(m.uygunIsYok))
        else
          for (final meslek in acikIsler)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _IsKarti(
                meslek: meslek,
                maas: tabanPara(meslek.kademeler.first.maas),
                // Çalışırken de iş değiştirilebilir; sektör dışına geçiş
                // yetkinliği sıfırlar, bu kararın bedeli oyuncunundur.
                mevcutIsMi: calisiyor && oyuncu.kariyer.meslekId == meslek.id,
                sec: () =>
                    ref.read(taleplerProvider.notifier).iseGir(meslek.id),
              ),
            ),
      ],
    );
  }
}

class _Merdiven extends StatelessWidget {
  const _Merdiven({required this.meslek, required this.oyuncu});

  final Meslek meslek;
  final Oyuncu oyuncu;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);
    final mevcut = switch (oyuncu.kariyer) {
      Calisan(:final kademeIndeksi) => kademeIndeksi,
      _ => 0,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          m.kariyerMerdiveni,
          style: tema.textTheme.labelMedium?.copyWith(
            color: tema.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        for (var i = 0; i < meslek.kademeler.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Icon(
                  i < mevcut
                      ? Icons.check_circle
                      : (i == mevcut
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked),
                  size: 16,
                  color: i <= mevcut
                      ? tema.colorScheme.primary
                      : tema.oyun.notr,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    meslek.kademeler[i].ad,
                    style: i == mevcut
                        ? const TextStyle(fontWeight: FontWeight.w700)
                        : null,
                  ),
                ),
                Text(
                  bicim.kisaPara(meslek.kademeler[i].maas),
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: tema.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _IsKarti extends StatelessWidget {
  const _IsKarti({
    required this.meslek,
    required this.maas,
    required this.mevcutIsMi,
    required this.sec,
  });

  final Meslek meslek;
  final String maas;
  final bool mevcutIsMi;
  final VoidCallback sec;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);

    return OyunKarti(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meslek.ad, style: tema.textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  '${meslek.sektor.ad(m)} · '
                  '${m.baslangicMaasi(maas)} · '
                  '${m.kademeSayisi(meslek.kademeler.length)}',
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: tema.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (mevcutIsMi)
            Icon(Icons.work, size: 18, color: tema.colorScheme.primary)
          else
            TextButton(onPressed: sec, child: Text(m.basvur)),
        ],
      ),
    );
  }
}

class _TalepKarti extends StatelessWidget {
  const _TalepKarti({required this.metin, required this.iptal});

  final String metin;
  final VoidCallback iptal;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    return OyunKarti(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(metin),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(onPressed: iptal, child: Text(m.vazgec)),
          ),
        ],
      ),
    );
  }
}
