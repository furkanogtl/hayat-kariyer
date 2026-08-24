import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/engine/portfoy_motoru.dart';
import '../../core/models/oyun_durumu.dart';
import '../../core/models/varlik.dart';
import '../../l10n/uygulama_metinleri.dart';
import '../../shared/bicimleme.dart';
import '../../shared/etiketler.dart';
import '../../shared/tema.dart';
import '../../shared/widgets/oyun_widgetlari.dart';
import '../oyun/oyun_saglayicilar.dart';
import 'fiyat_grafigi.dart';
import 'varlik_detay_kagidi.dart';

/// Piyasa sekmesi: portföy özeti, bekleyen emirler ve yatırım araçları.
class PiyasaEkrani extends ConsumerWidget {
  const PiyasaEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final durum = ref.watch(oyunProvider)!.durum;
    final emirler = ref.watch(taleplerProvider).emirler;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _PortfoyKarti(durum: durum),
        if (emirler.isNotEmpty) ...[
          const SizedBox(height: 20),
          BolumBasligi(m.bekleyenEmirler),
          _EmirListesi(emirler: emirler),
        ],
        const SizedBox(height: 20),
        BolumBasligi(m.varliklar),
        for (final tanim in piyasaVarliklari)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _VarlikSatiri(tanim: tanim, durum: durum),
          ),
      ],
    );
  }
}

class _PortfoyKarti extends StatelessWidget {
  const _PortfoyKarti({required this.durum});

  final OyunDurumu durum;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);
    final portfoy = durum.portfoy;

    // ÖLÇEK KURALI — bu ekran bir işlem ekranı:
    // TUTARLAR NOMİNAL, çünkü oyuncu birim fiyatla adedi çarpıp tutarı
    // bulabilmeli. Reel gösterilseydi aritmetik tutmazdı.
    // YÜZDELER REEL, çünkü enflasyon yalanı orada saklanıyor: 20 yıl
    // tutulan mevduat nominal olarak "+%300 kâr" gösterir, reel olarak
    // kaybettirir.
    String para(num ham) => bicim.kisaPara(
          durum.piyasa.gosterimTutari(ham.round()),
        );

    if (portfoy.bosMu) {
      return OyunKarti(
        child: Text(
          m.portfoyBos,
          style: tema.textTheme.bodyMedium?.copyWith(
            color: tema.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final endeks = durum.piyasa.enflasyonEndeksi;
    final deger = portfoy.piyasaDegeri(durum.piyasa.fiyatlar);
    final reelKar = portfoy.pozisyonlar.entries.fold<double>(
      0,
      (t, g) => t + g.value.reelKarZarar(durum.piyasa.fiyat(g.key), endeks),
    );

    return OyunKarti(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            m.portfoyDegeri,
            style: tema.textTheme.labelMedium?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            para(deger),
            style: tema.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          BilgiSatiri(
            etiket: m.reelKarZarar,
            deger: bicim.imzaliPara(durum.piyasa.gosterimTutari(
              reelKar.round(),
            )),
            renk: tema.oyun.tutar(reelKar),
          ),
          const Divider(height: 20),
          for (final g in portfoy.pozisyonlar.entries)
            _PozisyonSatiri(
              varlikId: g.key,
              adet: g.value.adet,
              deger: g.value.deger(durum.piyasa.fiyat(g.key)),
              reelKar: g.value.reelKarZarar(durum.piyasa.fiyat(g.key), endeks),
              reelMaliyet: g.value.reelMaliyet(endeks),
              gosterim: para,
            ),
          for (final s in portfoy.bekleyenSatislar)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Icon(Icons.schedule, size: 15, color: tema.oyun.uyari),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${m.satista}: ${varlikAdi(m, s.varlikId)} '
                      '${bicim.ondalik(s.adet)}',
                      style: tema.textTheme.bodySmall,
                    ),
                  ),
                  Text(
                    m.satisTamamlanir(s.kalanTur),
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: tema.oyun.uyari,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PozisyonSatiri extends StatelessWidget {
  const _PozisyonSatiri({
    required this.varlikId,
    required this.adet,
    required this.deger,
    required this.reelKar,
    required this.reelMaliyet,
    required this.gosterim,
  });

  final String varlikId;
  final double adet;

  /// Nominal piyasa değeri.
  final double deger;

  /// Enflasyondan arındırılmış kâr/zarar.
  final double reelKar;

  /// Maliyetin bugünkü paraya çevrilmiş hali; oran bunun üstünden.
  final double reelMaliyet;
  final String Function(num) gosterim;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);
    final tanim = varlikTanimi(varlikId);
    final oran = reelMaliyet == 0 ? 0.0 : reelKar / reelMaliyet;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(varlikAdi(m, varlikId)),
                Text(
                  '${bicim.ondalik(adet)} '
                  '${tanim?.tur.birim(m) ?? m.birimAdet}',
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: tema.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                gosterim(deger),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                bicim.yuzde(oran),
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.oyun.tutar(reelKar),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmirListesi extends ConsumerWidget {
  const _EmirListesi({required this.emirler});

  final List<Emir> emirler;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);

    return OyunKarti(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < emirler.length; i++)
            Row(
              children: [
                Expanded(
                  child: Text(_metin(m, bicim, emirler[i])),
                ),
                IconButton(
                  onPressed: () =>
                      ref.read(taleplerProvider.notifier).emirSil(i),
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
          Text(
            m.emirNotu,
            style: tema.textTheme.bodySmall?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _metin(UygulamaMetinleri m, Bicim bicim, Emir emir) {
    final ad = varlikAdi(m, emir.varlikId);
    return switch (emir) {
      Alim() => m.emirAlim(bicim.ondalik(emir.adet), ad),
      Satim() => m.emirSatim(bicim.ondalik(emir.adet), ad),
    };
  }
}

class _VarlikSatiri extends StatelessWidget {
  const _VarlikSatiri({required this.tanim, required this.durum});

  final VarlikTanimi tanim;
  final OyunDurumu durum;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);
    final piyasa = durum.piyasa;
    final degisim = piyasa.reelDegisim(tanim.id);
    final sahip = durum.portfoy.adet(tanim.id) > 0;

    return OyunKarti(
      dolgu: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => varlikDetayiniGoster(context, tanim),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          varlikAdi(m, tanim.id),
                          style: tema.textTheme.titleSmall,
                        ),
                        if (sahip) ...[
                          const SizedBox(width: 6),
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: tema.colorScheme.primary,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      tanim.tur.ad(m),
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: tema.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 70,
                height: 28,
                child: MiniGrafik(seri: piyasa.seri(tanim.id)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    bicim.kisaPara(piyasa.gosterimTutari(
                      piyasa.fiyat(tanim.id).round(),
                    )),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    degisim == null ? m.veriYok : bicim.yuzde(degisim),
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: degisim == null
                          ? tema.oyun.notr
                          : tema.oyun.tutar(degisim),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kimlikten varlık tanımı. Tanımsızsa null.
VarlikTanimi? varlikTanimi(String id) {
  for (final v in piyasaVarliklari) {
    if (v.id == id) return v;
  }
  return null;
}
