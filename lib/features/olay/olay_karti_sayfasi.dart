import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/engine/olay_motoru.dart';
import '../../core/models/olay.dart';
import '../../l10n/uygulama_metinleri.dart';
import '../../shared/animasyon/haberci.dart';
import '../../shared/animasyon/haberci_sahnesi.dart';
import '../../shared/animasyon/hareket.dart';
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

  /// Haberci eşyayı uzattı mı. Kart metni ancak o zaman açılıyor;
  /// önce açılsaydı animasyonun anlatısı boşa giderdi.
  bool _teslimEdildi = false;

  @override
  void didUpdateWidget(_KartGovdesi eski) {
    super.didUpdateWidget(eski);
    // Sıradaki karta geçildi: sonuç ekranını ve sahneyi temizle.
    if (eski.kart.id != widget.kart.id) {
      _sonuc = null;
      _secilenIndeks = null;
      _teslimEdildi = false;
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
              // Kartı GETİREN kişi. Kart türüne göre değişiyor; oyuncu
              // kimin geldiğini metni okumadan anlıyor.
              HaberciSahnesi(
                // Kart değişince sahne baştan kurulsun.
                key: ValueKey(kart.id),
                tip: HaberciTipi.olayTurunden(kart.tur),
                onTamamlandi: () {
                  if (mounted) setState(() => _teslimEdildi = true);
                },
              ),
              const SizedBox(height: 16),
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
              // Kart içeriği teslimden sonra açılıyor. AnimatedSize,
              // kâğıdın boyunun zıplamadan büyümesini sağlıyor.
              AnimatedOpacity(
                opacity: _teslimEdildi ? 1 : 0,
                duration: Hareket.sure(context, Hareket.orta),
                curve: Hareket.giris,
                child: AnimatedSlide(
                  offset: _teslimEdildi ? Offset.zero : const Offset(0, 0.06),
                  duration: Hareket.sure(context, Hareket.orta),
                  curve: Hareket.giris,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                          _SecenekDugmesi(
                            etiket: kart.secenekler[i].etiket,
                            renk: turRengi(context, kart.tur),
                            sira: i,
                            acik: _teslimEdildi,
                            onSecildi: () => _sec(i),
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Seçenek düğmesi. Sırayla, hafif gecikmeyle beliriyor: hepsi birden
/// gelirse oyuncunun gözü nereye bakacağını bilemiyor.
class _SecenekDugmesi extends StatelessWidget {
  const _SecenekDugmesi({
    required this.etiket,
    required this.renk,
    required this.sira,
    required this.acik,
    required this.onSecildi,
  });

  final String etiket;

  /// Kartın türünü taşıyan renk. Şeritte ve okta görünüyor: oyuncu neye
  /// dokunduğunu etiketi okumadan da anlıyor.
  final Color renk;

  final int sira;
  final bool acik;
  final VoidCallback onSecildi;

  @override
  Widget build(BuildContext context) {
    final gecikme = Hareket.kapali(context)
        ? Duration.zero
        : Duration(milliseconds: 70 * sira);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AnimatedSlide(
        offset: acik ? Offset.zero : const Offset(0.08, 0),
        duration: Hareket.sure(context, Hareket.orta) + gecikme,
        curve: Hareket.giris,
        child: AnimatedOpacity(
          opacity: acik ? 1 : 0,
          duration: Hareket.sure(context, Hareket.orta) + gecikme,
          // Material'ın varsayılan düğmesi yerine elle kurulmuş satır:
          // kartın en önemli anı bir formun "Gönder" düğmesi gibi
          // durmamalı. Sol şerit türün rengini taşıyor, sağdaki ok
          // dokunulabilir olduğunu söylüyor.
          child: OlaySecenekSatiri(
            key: olaySecenekAnahtari(sira),
            etiket: etiket,
            renk: renk,
            onSecildi: acik ? onSecildi : null,
          ),
        ),
      ),
    );
  }
}

/// Kartın seçenek satırı.
///
/// AÇIK: `tool/kart_onizleme_test.dart` kompozisyonu emülatörsüz basıyor
/// ve önizleme bunu kendi `OutlinedButton`'ıyla taklit ediyordu. Taklit
/// eden önizleme yanlış güven veriyor — gerçek ekran değişince önizleme
/// eski hâli göstermeye devam ediyordu.
class OlaySecenekSatiri extends StatelessWidget {
  const OlaySecenekSatiri({
    super.key,
    required this.etiket,
    required this.renk,
    required this.onSecildi,
  });

  final String etiket;
  final Color renk;
  final VoidCallback? onSecildi;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onSecildi,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: renk.withValues(alpha: 0.35)),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.lerp(
                  tema.colorScheme.surfaceContainerHigh,
                  renk,
                  0.16,
                )!,
                tema.colorScheme.surfaceContainerLow,
              ],
            ),
          ),
          child: Row(
            children: [
              // Sol şerit: satırı bir kutudan bir seçeneğe çeviren şey.
              Container(
                width: 4,
                height: 46,
                decoration: BoxDecoration(
                  color: renk,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(14),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  etiket,
                  style: tema.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: renk.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 10),
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

/// Seçenek satırının test anahtarı.
///
/// Widget testi metin değil WIDGET arıyor; seçenekler Material düğmesi
/// olmaktan çıkınca `find.byType(OutlinedButton)` boşa düştü. Anahtar
/// biçime bağlı olmayan tek tutamak.
Key olaySecenekAnahtari(int sira) => Key('olaySecenek_$sira');

/// Kart türünün rengi. Rozet ve seçenek şeridi AYNI kaynaktan okuyor;
/// iki yerde ayrı yazılsaydı biri değişince diğeri sessizce ayrışırdı.
Color turRengi(BuildContext context, OlayTuru tur) {
  final tema = Theme.of(context);
  return switch (tur) {
    OlayTuru.firsat => tema.oyun.kazanc,
    OlayTuru.kriz => tema.oyun.kayip,
    OlayTuru.teklif => tema.colorScheme.primary,
    OlayTuru.hayat => tema.oyun.notr,
  };
}

class _TurRozeti extends StatelessWidget {
  const _TurRozeti({required this.tur});

  final OlayTuru tur;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final renk = turRengi(context, tur);

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
