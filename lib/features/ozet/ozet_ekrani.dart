import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/engine/tur_processor.dart';
import '../../core/models/oyun_durumu.dart';
import '../../core/models/oyuncu.dart';
import '../../core/models/zaman_dagilimi.dart';
import '../../l10n/uygulama_metinleri.dart';
import '../../shared/bicimleme.dart';
import '../../shared/etiketler.dart';
import '../../shared/tema.dart';
import '../../shared/widgets/oyun_widgetlari.dart';
import '../olay/olay_karti_sayfasi.dart';
import '../oyun/oyun_saglayicilar.dart';
import 'tur_raporu_kagidi.dart';

/// Enerji bu değerin altına düşünce çubuk kırmızıya döner. Motor sabiti
/// değil, yalnızca "dinlenmeyi düşün" uyarısı.
const int _enerjiUyariEsigi = 25;

/// Ana ekran: durum özeti + bu turun kararı + turu bitirme.
///
/// Oyunun çekirdek döngüsünün tamamı burada görünür: nerede olduğunu gör,
/// zamanını dağıt, turu bitir, ne olduğunu oku.
class OzetEkrani extends ConsumerWidget {
  const OzetEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final oturum = ref.watch(oyunProvider)!;
    final durum = oturum.durum;
    final oyuncu = durum.oyuncu;
    final katalog = ref.watch(kataloglarProvider).requireValue.meslekler;
    final zaman = ref.watch(zamanProvider);
    final sektor = oyuncu.anaSektor;
    // İşe giriş gibi TEK SEFERLİK komutlar atlama boyunca tekrar tekrar
    // uygulanırdı; bekleyen komut varken yalnız tek tur işlenebilir.
    final atlanabilir = ref.watch(taleplerProvider).bosMu;
    // Karar kartı çıkmışsa tur bitirilemez: çekirdek döngüde kartlar
    // turun bitmesinden ÖNCE gelir. Yoksa oyuncu kartı görmezden gelip
    // ilerler ve içerik boşa gider.
    final kararBekliyor = oturum.kararBekliyor;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        if (kararBekliyor) ...[
          _KararUyarisi(sayi: oturum.bekleyenKartlar.length),
          const SizedBox(height: 12),
        ],
        ServetKarti(durum: durum),
        const SizedBox(height: 12),
        OyunKarti(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kariyerBasligi(oyuncu.kariyer, m, katalog),
                style: tema.textTheme.titleMedium,
              ),
              if (kalanTur(oyuncu.kariyer) case final kalan?)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    m.kalanTur(kalan),
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: tema.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatCubugu(
                      etiket: m.enerji,
                      deger: oyuncu.enerji,
                      uyariEsigi: _enerjiUyariEsigi,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCubugu(
                      etiket: m.mutluluk,
                      deger: oyuncu.mutluluk,
                      uyariEsigi: Oyuncu.burnoutEsigi,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCubugu(etiket: m.itibar, deger: oyuncu.itibar),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: sektor == null
                        // Henüz sektörü yok: boş çubuk yerine boşluk, ama
                        // hizalama bozulmasın diye yer kaplıyor.
                        ? const SizedBox()
                        : StatCubugu(
                            etiket: m.yetkinlik,
                            deger: oyuncu.yetkinlik(sektor),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _EkonomiKarti(durum: durum),
        const SizedBox(height: 20),
        BolumBasligi(
          m.zamanDagilimi,
          sag: zaman.bosPuan > 0
              ? Text(
                  m.kalanPuan(zaman.bosPuan),
                  style: tema.textTheme.labelMedium?.copyWith(
                    color: tema.oyun.uyari,
                  ),
                )
              : null,
        ),
        const _ZamanKarti(),
        const SizedBox(height: 20),
        FilledButton(
          onPressed:
              kararBekliyor ? null : () => _turuIsle(context, ref, 1),
          child: Text(m.turuBitir),
        ),
        // Kapalı düğmenin sebebi yazılmazsa oyuncu neden ilerleyemediğini
        // anlamıyor: oyun kart bekleyerek de başlayabiliyor.
        if (kararBekliyor)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              m.kararVermedenTurBitmez,
              textAlign: TextAlign.center,
              style: tema.textTheme.bodySmall?.copyWith(
                color: tema.oyun.uyari,
              ),
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: atlanabilir && !kararBekliyor
                    ? () => _turuIsle(context, ref, 3)
                    : null,
                child: Text(m.ucAyAtla),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: atlanabilir && !kararBekliyor
                    ? () => _turuIsle(context, ref, 12)
                    : null,
                child: Text(m.birYilAtla),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            m.yasalUyari,
            style: tema.textTheme.bodySmall?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  /// Turu (veya turları) işler ve raporu gösterir.
  ///
  /// `turlariAtla` motor tarafında erken kesilebilir; kaç turun gerçekten
  /// işlendiği rapor listesinin uzunluğundan okunuyor.
  Future<void> _turuIsle(BuildContext context, WidgetRef ref, int adet) async {
    final notifier = ref.read(oyunProvider.notifier);
    final talepler = ref.read(taleplerProvider);
    final girdi = TurGirdisi(
      zaman: ref.read(zamanProvider),
      iseGirTalebi: talepler.iseGirTalebi,
    );
    if (adet == 1) {
      notifier.turuBitir(girdi);
    } else {
      notifier.turlariAtla(girdi, adet);
    }
    ref.read(taleplerProvider.notifier).temizle();
    final raporlar = ref.read(oyunProvider)?.sonRaporlar ?? const <TurRaporu>[];
    if (raporlar.isNotEmpty && context.mounted) {
      await turRaporunuGoster(context, raporlar);
      notifier.raporlariTemizle();
    }
    // Rapordan sonra bu turun kartları: çekirdek döngüde karar kartı
    // turun kapanışını değil AÇILIŞINI karşılar.
    if (context.mounted && (ref.read(oyunProvider)?.kararBekliyor ?? false)) {
      await olayKartlariniGoster(context);
    }
  }
}

/// Bekleyen karar kartı uyarısı. Kart kâğıdı elle kapatılmış olabilir;
/// oyuncu buradan geri dönebilsin.
class _KararUyarisi extends ConsumerWidget {
  const _KararUyarisi({required this.sayi});

  final int sayi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    return Card(
      color: tema.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                m.kararBekliyor(sayi),
                style: tema.textTheme.titleSmall?.copyWith(
                  color: tema.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            TextButton(
              onPressed: () => olayKartlariniGoster(context),
              child: Text(m.kararlariGor),
            ),
          ],
        ),
      ),
    );
  }
}

/// Net değer, nakit, borç. Ana skor REEL net değerdir: nominal rakam 40
/// yılda enflasyonla şişip anlamsızlaşıyor.
class ServetKarti extends StatelessWidget {
  const ServetKarti({super.key, required this.durum});

  final OyunDurumu durum;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);

    // Ham TL -> reel -> gösterim ölçeği (para reformu) -> metin.
    String reel(int ham) => bicim.kisaPara(
          durum.piyasa.gosterimTutari(durum.piyasa.reeleCevir(ham)),
        );

    return OyunKarti(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            m.reelNetDeger,
            style: tema.textTheme.labelMedium?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            reel(durum.netDeger),
            style: tema.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: tema.oyun.tutar(durum.netDeger),
            ),
          ),
          const Divider(height: 24),
          BilgiSatiri(etiket: m.nakit, deger: reel(durum.oyuncu.nakit)),
          if (durum.toplamBorc > 0) ...[
            BilgiSatiri(
              etiket: m.borc,
              deger: reel(durum.toplamBorc),
              renk: tema.oyun.kayip,
            ),
            BilgiSatiri(
              etiket: m.taksitYuku,
              deger: reel(durum.taksitYuku),
            ),
          ],
          BilgiSatiri(
            etiket: m.krediNotu,
            deger: bicim.tamsayi(durum.oyuncu.krediNotu),
          ),
        ],
      ),
    );
  }
}

class _EkonomiKarti extends StatelessWidget {
  const _EkonomiKarti({required this.durum});

  final OyunDurumu durum;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);
    final kayip = durum.alimGucuKaybi;

    return OyunKarti(
      child: Column(
        children: [
          BilgiSatiri(
            etiket: m.rejim,
            deger: durum.piyasa.rejim.ad(m),
            kalin: true,
          ),
          BilgiSatiri(
            etiket: m.yillikEnflasyon,
            deger: bicim.yuzde(durum.piyasa.yillikEnflasyon),
          ),
          // Maaş yılda bir zamlanır, market her ay: aradaki makas oyunun ana
          // baskısı. Ocakta sıfırlandığı için küçük değerler gösterilmiyor.
          if (kayip > 0.01)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Icon(Icons.trending_down, size: 16, color: tema.oyun.uyari),
                  const SizedBox(width: 6),
                  Text(
                    m.alimGucuKaybi(bicim.yuzde(kayip, basamak: 0)),
                    style: tema.textTheme.bodySmall
                        ?.copyWith(color: tema.oyun.uyari),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ZamanKarti extends ConsumerWidget {
  const _ZamanKarti();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final zaman = ref.watch(zamanProvider);
    final notifier = ref.read(zamanProvider.notifier);
    final dolu = zaman.bosPuan == 0;

    return OyunKarti(
      child: Column(
        children: [
          _ZamanSatiri(
            etiket: m.zamanCalisma,
            alan: ZamanAlani.calisma,
            deger: zaman.calisma,
            doluMu: dolu,
          ),
          _ZamanSatiri(
            etiket: m.zamanEgitim,
            alan: ZamanAlani.egitim,
            deger: zaman.egitim,
            doluMu: dolu,
          ),
          _ZamanSatiri(
            etiket: m.zamanNetwork,
            alan: ZamanAlani.network,
            deger: zaman.network,
            doluMu: dolu,
          ),
          _ZamanSatiri(
            etiket: m.zamanDinlenme,
            alan: ZamanAlani.dinlenme,
            deger: zaman.dinlenme,
            doluMu: dolu,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => notifier.ayarla(ZamanDagilimi.dengeli()),
                  child: Text(m.dagilimDengeli),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => notifier.ayarla(ZamanDagilimi.tamMesai()),
                  child: Text(m.dagilimTamMesai),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ZamanSatiri extends ConsumerWidget {
  const _ZamanSatiri({
    required this.etiket,
    required this.alan,
    required this.deger,
    required this.doluMu,
  });

  final String etiket;
  final ZamanAlani alan;
  final int deger;
  final bool doluMu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(zamanProvider.notifier);
    return Row(
      children: [
        Expanded(child: Text(etiket)),
        IconButton(
          onPressed: deger > 0 ? () => notifier.artir(alan, -1) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(
          width: 24,
          child: Text(
            '$deger',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        IconButton(
          onPressed: doluMu ? null : () => notifier.artir(alan, 1),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
