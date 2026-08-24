import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/engine/olay_motoru.dart';
import '../../core/models/olay.dart';
import '../../l10n/uygulama_metinleri.dart';
import '../../shared/etiketler.dart';
import '../../shared/tema.dart';
import '../oyun/oyun_saglayicilar.dart';

/// Olay kartı kâğıdının test anahtarı. Bkz. [turRaporuAnahtari].
const Key olayKartiAnahtari = Key('olayKarti');

/// Bekleyen kartları sırayla gösterir; hepsi cevaplanınca kapanır.
///
/// Kart metinleri VERİDEN gelir (`assets/events/*.json`), ARB'den değil.
/// Burada yalnız çerçeve yerelleştirilmiştir.
Future<void> olayKartlariniGoster(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => const _OlayAkisi(key: olayKartiAnahtari),
    );

class _OlayAkisi extends ConsumerWidget {
  const _OlayAkisi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kartlar = ref.watch(oyunProvider)?.bekleyenKartlar ?? const <Olay>[];
    if (kartlar.isEmpty) {
      // Son kart da cevaplandı: kâğıdı kapat.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) Navigator.of(context).maybePop();
      });
      return const SizedBox(height: 120);
    }
    return _KartGovdesi(kart: kartlar.first, kalan: kartlar.length - 1);
  }
}

class _KartGovdesi extends ConsumerStatefulWidget {
  const _KartGovdesi({required this.kart, required this.kalan});

  final Olay kart;
  final int kalan;

  @override
  ConsumerState<_KartGovdesi> createState() => _KartGovdesiDurumu();
}

class _KartGovdesiDurumu extends ConsumerState<_KartGovdesi> {
  /// Seçim yapıldıktan sonra gösterilen sonuç; null ise kart hâlâ açık.
  SecimSonucu? _sonuc;
  int? _secilenIndeks;

  @override
  void didUpdateWidget(_KartGovdesi eski) {
    super.didUpdateWidget(eski);
    // Sıradaki karta geçildi: sonuç ekranını temizle.
    if (eski.kart.id != widget.kart.id) {
      _sonuc = null;
      _secilenIndeks = null;
    }
  }

  void _sec(int indeks) {
    // Durum burada DEĞİŞTİRİLİYOR ama kart desteden hemen düşmüyor;
    // önce sonucu gösteriyoruz, oyuncu "Devam" deyince sıradakine geçiyor.
    setState(() {
      _secilenIndeks = indeks;
      _sonuc = ref.read(oyunProvider.notifier).secimYap(widget.kart, indeks);
    });
  }

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final kart = widget.kart;
    final sonuc = _sonuc;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _TurRozeti(tur: kart.tur),
                  const Spacer(),
                  if (widget.kalan > 0)
                    Text(
                      m.kartKaldi(widget.kalan),
                      style: tema.textTheme.labelSmall?.copyWith(
                        color: tema.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                kart.baslik,
                style: tema.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(kart.metin, style: tema.textTheme.bodyMedium),
              const SizedBox(height: 20),
              if (sonuc == null)
                for (var i = 0; i < kart.secenekler.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OutlinedButton(
                      onPressed: () => _sec(i),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(kart.secenekler[i].etiket),
                      ),
                    ),
                  )
              else
                _SonucGovdesi(
                  secenek: kart.secenekler[_secilenIndeks!],
                  sonuc: sonuc,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SonucGovdesi extends ConsumerWidget {
  const _SonucGovdesi({required this.secenek, required this.sonuc});

  final OlaySecenegi secenek;
  final SecimSonucu sonuc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: tema.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            // Gecikmeli seçimde sonuç HENÜZ BELLİ DEĞİL: zar bekleme
            // bitince atılıyor, karar anında değil.
            sonuc.beklemeyeAlindi
                ? m.sonucBekliyor(secenek.gecikmeTuru)
                : (sonuc.acilanSonuc?.metin ?? secenek.etiket),
            style: tema.textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          // Kart burada desteden düşürülüyor: sonucu okumadan sıradaki
          // karta atlanmasın.
          onPressed: () => ref.read(oyunProvider.notifier).kartiKapat(),
          child: Text(m.devam),
        ),
      ],
    );
  }
}

class _TurRozeti extends StatelessWidget {
  const _TurRozeti({required this.tur});

  final OlayTuru tur;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final renk = switch (tur) {
      OlayTuru.firsat => tema.oyun.kazanc,
      OlayTuru.kriz => tema.oyun.kayip,
      OlayTuru.teklif => tema.colorScheme.primary,
      OlayTuru.hayat => tema.oyun.notr,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tur.ad(m),
        style: tema.textTheme.labelSmall?.copyWith(
          color: renk,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
