import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/engine/tur_processor.dart';
import '../../core/models/borc.dart';
import '../../l10n/uygulama_metinleri.dart';
import '../../shared/bicimleme.dart';
import '../../shared/etiketler.dart';
import '../../shared/tema.dart';
import '../../shared/widgets/oyun_widgetlari.dart';
import '../oyun/oyun_saglayicilar.dart';

/// Kredi kâğıdının test anahtarı.
const Key krediKagidiAnahtari = Key('krediKagidi');

/// Bir kredi teklifinin tutar seçimi ve özeti.
Future<void> krediKagidiniGoster(BuildContext context, KrediTeklifi teklif) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _KrediKagidi(key: krediKagidiAnahtari, teklif: teklif),
      ),
    );

class _KrediKagidi extends ConsumerStatefulWidget {
  const _KrediKagidi({super.key, required this.teklif});

  final KrediTeklifi teklif;

  @override
  ConsumerState<_KrediKagidi> createState() => _KrediKagidiDurumu();
}

class _KrediKagidiDurumu extends ConsumerState<_KrediKagidi> {
  late int _tutar = widget.teklif.enYuksekTutar;
  final _denetleyici = TextEditingController();

  @override
  void initState() {
    super.initState();
    _denetleyici.text = _tutar.toString();
  }

  @override
  void dispose() {
    _denetleyici.dispose();
    super.dispose();
  }

  void _tutarAyarla(int deger) {
    setState(() {
      _tutar = deger.clamp(0, widget.teklif.enYuksekTutar);
      _denetleyici.text = _tutar.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);
    final durum = ref.watch(oyunProvider)!.durum;
    final teklif = widget.teklif;

    String para(int ham) =>
        bicim.kisaPara(durum.piyasa.gosterimTutari(ham));

    final taksit = teklif.taksit(_tutar);
    final toplam = teklif.toplamOdeme(_tutar);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                teklif.tur.ad(m),
                style: tema.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${m.aylikFaiz} ${bicim.yuzde(teklif.aylikFaiz, basamak: 2)}'
                ' · ${m.vadeAy(teklif.vadeTur)}',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _denetleyici,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (metin) => setState(
                  () => _tutar = (int.tryParse(metin) ?? 0)
                      .clamp(0, teklif.enYuksekTutar),
                ),
                decoration: InputDecoration(
                  labelText: m.krediTutari,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              Slider(
                value: _tutar.toDouble(),
                max: teklif.enYuksekTutar.toDouble(),
                onChanged: (deger) => _tutarAyarla(deger.round()),
              ),
              OyunKarti(
                dolgu: 12,
                child: Column(
                  children: [
                    BilgiSatiri(
                      etiket: m.enYuksekTutar,
                      deger: para(teklif.enYuksekTutar),
                    ),
                    BilgiSatiri(
                      etiket: m.aylikTaksit,
                      deger: para(taksit),
                      kalin: true,
                    ),
                    BilgiSatiri(
                      etiket: m.toplamOdeme,
                      deger: para(toplam),
                      // Toplam geri ödeme anaparanın çok üstünde; kırmızı
                      // olmasa oyuncu faizin büyüklüğünü fark etmiyor.
                      renk: tema.oyun.kayip,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                m.krediUyari,
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _tutar <= 0 ? null : _talepVer,
                child: Text(m.krediCek),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _talepVer() {
    // Talep: tur bitene kadar uygulanmıyor. Motor krediyi emirlerden önce
    // işlediği için oyuncu aynı turda çektiği parayla yatırım yapabiliyor.
    ref.read(taleplerProvider.notifier).krediTalebi(
          KrediTalebi(tur: widget.teklif.tur, anapara: _tutar),
        );
    Navigator.of(context).pop();
  }
}
