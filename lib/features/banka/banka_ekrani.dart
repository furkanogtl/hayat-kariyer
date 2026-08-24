import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/engine/tur_processor.dart';
import '../../core/models/borc.dart';
import '../../core/models/oyun_durumu.dart';
import '../../core/models/oyuncu.dart';
import '../../l10n/uygulama_metinleri.dart';
import '../../shared/bicimleme.dart';
import '../../shared/etiketler.dart';
import '../../shared/tema.dart';
import '../../shared/widgets/oyun_widgetlari.dart';
import '../oyun/oyun_saglayicilar.dart';
import 'kredi_kagidi.dart';

/// Banka sekmesi: kredi notu, açık borçlar ve kredi teklifleri.
///
/// Teklifler `TurProcessor.krediTeklifleri` ile geliyor — ekran kendi
/// hesabını yapsaydı gösterdiği tutar bankanınkinden farklı çıkar, oyuncu
/// gördüğü krediyi isteyip reddedilirdi.
class BankaEkrani extends ConsumerWidget {
  const BankaEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);
    final durum = ref.watch(oyunProvider)!.durum;
    final motor = ref.watch(turProcessorProvider);
    final teklifler = motor.krediTeklifleri(durum);
    final bekleyen = ref.watch(taleplerProvider).krediTalebi;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _KrediNotuKarti(durum: durum),
        if (bekleyen != null) ...[
          const SizedBox(height: 12),
          _BekleyenKrediKarti(talep: bekleyen, durum: durum),
        ],
        const SizedBox(height: 20),
        BolumBasligi(m.borclarim),
        if (durum.borclar.isEmpty)
          OyunKarti(
            child: Text(
              m.borcYok,
              style: tema.textTheme.bodyMedium?.copyWith(
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          for (final borc in durum.borclar)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _BorcKarti(borc: borc, durum: durum),
            ),
        const SizedBox(height: 20),
        BolumBasligi(m.krediTeklifleri),
        if (teklifler.isEmpty)
          OyunKarti(child: Text(m.krediYok))
        else ...[
          for (final teklif in teklifler)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _TeklifKarti(
                teklif: teklif,
                durum: durum,
                kilitli: bekleyen != null,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            m.krediUyari,
            style: tema.textTheme.bodySmall?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        // Bordro tutarı: teklif limitlerinin dayanağı. Yazılmazsa oyuncu
        // limitin nereden geldiğini anlayamıyor.
        const SizedBox(height: 12),
        Center(
          child: Text(
            '${m.raporGelir}: '
            '${bicim.kisaPara(durum.piyasa.gosterimTutari(
              motor.bordroGeliri(durum),
            ))}',
            style: tema.textTheme.bodySmall?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _KrediNotuKarti extends StatelessWidget {
  const _KrediNotuKarti({required this.durum});

  final OyunDurumu durum;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);
    final not = durum.oyuncu.krediNotu;
    // Findeks benzeri ölçek: 300-1900. Çubuk bu aralığa göre doluyor,
    // 0-100 sanılırsa herkes tavan görünür.
    final oran = (not - Oyuncu.krediNotuTaban) /
        (Oyuncu.krediNotuTavan - Oyuncu.krediNotuTaban);

    return OyunKarti(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            m.krediNotu,
            style: tema.textTheme.labelMedium?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            m.krediNotuOlcegi(not, Oyuncu.krediNotuTavan),
            style: tema.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: oran.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: tema.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(
                oran < 0.35 ? tema.oyun.kayip : tema.colorScheme.primary,
              ),
            ),
          ),
          if (durum.toplamBorc > 0) ...[
            const Divider(height: 20),
            BilgiSatiri(
              etiket: m.borc,
              deger: bicim.kisaPara(
                durum.piyasa.gosterimTutari(durum.toplamBorc),
              ),
              renk: tema.oyun.kayip,
            ),
            BilgiSatiri(
              etiket: m.taksitYuku,
              deger: bicim.kisaPara(
                durum.piyasa.gosterimTutari(durum.taksitYuku),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BekleyenKrediKarti extends ConsumerWidget {
  const _BekleyenKrediKarti({required this.talep, required this.durum});

  final KrediTalebi talep;
  final OyunDurumu durum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);

    return Card(
      color: tema.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                m.krediBekliyor(
                  talep.tur.ad(m),
                  bicim.kisaPara(
                    durum.piyasa.gosterimTutari(talep.anapara),
                  ),
                ),
                style: tema.textTheme.titleSmall?.copyWith(
                  color: tema.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            TextButton(
              onPressed: () =>
                  ref.read(taleplerProvider.notifier).krediTalebi(null),
              child: Text(m.vazgecKomut),
            ),
          ],
        ),
      ),
    );
  }
}

class _BorcKarti extends StatelessWidget {
  const _BorcKarti({required this.borc, required this.durum});

  final Borc borc;
  final OyunDurumu durum;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);

    String para(int ham) =>
        bicim.kisaPara(durum.piyasa.gosterimTutari(ham));

    return OyunKarti(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(borc.tur.ad(m), style: tema.textTheme.titleSmall),
              ),
              if (borc.gecikmede)
                Text(
                  m.gecikmede,
                  style: tema.textTheme.labelMedium
                      ?.copyWith(color: tema.oyun.kayip),
                ),
            ],
          ),
          const SizedBox(height: 6),
          BilgiSatiri(
            etiket: m.kalanAnapara,
            deger: para(borc.kalanAnapara),
          ),
          BilgiSatiri(
            etiket: m.aylikTaksit,
            deger: para(borc.aylikTaksit),
          ),
          BilgiSatiri(
            etiket: m.aylikFaiz,
            deger: bicim.yuzde(borc.aylikFaiz, basamak: 2),
          ),
          Text(
            m.kalanTaksit(borc.kalanTaksit),
            style: tema.textTheme.bodySmall?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
          // Taksitin reel olarak eridiğini göstermek tasarımın kalbi:
          // taksit çekildiği günün parasıyla sabit, enflasyon onu aşındırır.
          const SizedBox(height: 6),
          _TaksitErimesi(borc: borc, durum: durum),
        ],
      ),
    );
  }
}

/// Taksitin çekildiği güne göre reel olarak ne kadar eridiği.
class _TaksitErimesi extends StatelessWidget {
  const _TaksitErimesi({required this.borc, required this.durum});

  final Borc borc;
  final OyunDurumu durum;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);
    // Çekildiği turdaki endeks kayıtta yok; seriden değil, geçen tur
    // sayısı ve bugünkü endeksten yaklaşık bir şey üretmek yanıltıcı
    // olurdu. Bunun yerine taksitin BUGÜNKÜ reel karşılığı yazılıyor.
    final reel = durum.piyasa.reeleCevir(borc.aylikTaksit);
    return Text(
      '${m.reelNetDeger}: ${bicim.kisaPara(reel)}',
      style: tema.textTheme.bodySmall?.copyWith(
        color: tema.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _TeklifKarti extends StatelessWidget {
  const _TeklifKarti({
    required this.teklif,
    required this.durum,
    required this.kilitli,
  });

  final KrediTeklifi teklif;
  final OyunDurumu durum;
  final bool kilitli;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);

    return OyunKarti(
      dolgu: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: kilitli ? null : () => krediKagidiniGoster(context, teklif),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(teklif.tur.ad(m), style: tema.textTheme.titleSmall),
              const SizedBox(height: 4),
              BilgiSatiri(
                etiket: m.enYuksekTutar,
                deger: bicim.kisaPara(
                  durum.piyasa.gosterimTutari(teklif.enYuksekTutar),
                ),
              ),
              BilgiSatiri(
                etiket: m.aylikFaiz,
                deger: bicim.yuzde(teklif.aylikFaiz, basamak: 2),
              ),
              BilgiSatiri(
                etiket: m.vade,
                deger: m.vadeAy(teklif.vadeTur),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
