import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/egitim_seviyesi.dart';
import '../../core/models/sehir.dart';
import '../../l10n/uygulama_metinleri.dart';
import '../../shared/bicimleme.dart';
import '../../shared/etiketler.dart';
import '../oyun/oyun_saglayicilar.dart';

/// Oyun kurulum ekranı: ad, cinsiyet, şehir, eğitim.
///
/// Dördü de mekanik seçim; dekor değil. Şehir yaşam gideri çarpanını,
/// eğitim meslek giriş kapısını, cinsiyet askerlik yükümlülüğünü belirler.
class YeniOyunEkrani extends ConsumerStatefulWidget {
  const YeniOyunEkrani({super.key});

  @override
  ConsumerState<YeniOyunEkrani> createState() => _YeniOyunEkraniDurumu();
}

class _YeniOyunEkraniDurumu extends ConsumerState<YeniOyunEkrani> {
  final _adDenetleyici = TextEditingController();
  Cinsiyet _cinsiyet = Cinsiyet.erkek;
  Sehir _sehir = Sehir.konya;
  EgitimSeviyesi _egitim = EgitimSeviyesi.lise;

  @override
  void dispose() {
    _adDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
          children: [
            Text(
              m.uygulamaAdi,
              style: tema.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              m.yasalUyari,
              style: tema.textTheme.bodySmall?.copyWith(
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            // Yarım kalmış oyun varsa önce o sunuluyor: mobilde oyuncu
            // uygulamayı kapatıp döndüğünde kaldığı yerden devam etmeli.
            const _DevamKarti(),
            const SizedBox(height: 8),
            TextField(
              controller: _adDenetleyici,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: m.adinNe,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            _Baslik(m.cinsiyet),
            SegmentedButton<Cinsiyet>(
              segments: [
                for (final c in Cinsiyet.values)
                  ButtonSegment(value: c, label: Text(c.ad(m))),
              ],
              selected: {_cinsiyet},
              onSelectionChanged: (secim) =>
                  setState(() => _cinsiyet = secim.first),
            ),
            const SizedBox(height: 24),
            _Baslik(m.sehir),
            for (final s in Sehir.values)
              RadioListTile<Sehir>(
                value: s,
                // ignore: deprecated_member_use
                groupValue: _sehir,
                // ignore: deprecated_member_use
                onChanged: (secim) => setState(() => _sehir = secim!),
                contentPadding: EdgeInsets.zero,
                title: Text(s.ad(m)),
                subtitle: Text(
                  m.giderCarpani(bicim.ondalik(s.giderCarpani)),
                ),
              ),
            const SizedBox(height: 16),
            _Baslik(m.egitim),
            DropdownButtonFormField<EgitimSeviyesi>(
              initialValue: _egitim,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: [
                for (final e in EgitimSeviyesi.values)
                  DropdownMenuItem(value: e, child: Text(e.ad(m))),
              ],
              onChanged: (secim) => setState(() => _egitim = secim!),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => ref.read(oyunProvider.notifier).yeniOyun(
                    ad: _adDenetleyici.text.trim().isEmpty
                        ? m.adVarsayilan
                        : _adDenetleyici.text.trim(),
                    cinsiyet: _cinsiyet,
                    sehir: _sehir,
                    egitim: _egitim,
                  ),
              child: Text(m.oyunaBasla),
            ),
          ],
        ),
      ),
    );
  }
}

/// Diskte kayıt varsa gösterilen devam kartı.
class _DevamKarti extends ConsumerWidget {
  const _DevamKarti();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final varMi = ref.watch(kayitVarMiProvider).value ?? false;
    if (!varMi) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: tema.colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                m.kayitVar,
                style: tema.textTheme.bodyMedium?.copyWith(
                  color: tema.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () async {
                  final yuklendi = await ref
                      .read(oyunProvider.notifier)
                      .kayittanYukle();
                  // Bozuk kayıt: kart kaybolsun, oyuncu yeni oyuna geçsin.
                  if (!yuklendi) ref.invalidate(kayitVarMiProvider);
                },
                child: Text(m.devamEt),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Baslik extends StatelessWidget {
  const _Baslik(this.metin);

  final String metin;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          metin,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
}
