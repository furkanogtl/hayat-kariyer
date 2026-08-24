import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/engine/portfoy_motoru.dart';
import '../../core/models/varlik.dart';
import '../../l10n/uygulama_metinleri.dart';
import '../../shared/bicimleme.dart';
import '../../shared/etiketler.dart';
import '../../shared/tema.dart';
import '../../shared/widgets/oyun_widgetlari.dart';
import '../oyun/oyun_saglayicilar.dart';
import 'fiyat_grafigi.dart';

/// Varlık detay kâğıdının test anahtarı.
const Key varlikDetayAnahtari = Key('varlikDetay');

/// Bir yatırım aracının grafiği ve alım/satım kutusu.
Future<void> varlikDetayiniGoster(BuildContext context, VarlikTanimi tanim) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Padding(
        // Klavye açılınca kutu görünsün.
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _VarlikDetayi(key: varlikDetayAnahtari, tanim: tanim),
      ),
    );

class _VarlikDetayi extends ConsumerStatefulWidget {
  const _VarlikDetayi({super.key, required this.tanim});

  final VarlikTanimi tanim;

  @override
  ConsumerState<_VarlikDetayi> createState() => _VarlikDetayiDurumu();
}

class _VarlikDetayiDurumu extends ConsumerState<_VarlikDetayi> {
  final _adetDenetleyici = TextEditingController();
  bool _satim = false;

  @override
  void dispose() {
    _adetDenetleyici.dispose();
    super.dispose();
  }

  double get _adet => double.tryParse(_adetDenetleyici.text.trim()) ?? 0;

  void _adetYaz(double deger) {
    final tam = !widget.tanim.bolunebilir;
    _adetDenetleyici.text = tam
        ? deger.floor().toString()
        : deger.toStringAsFixed(deger >= 100 ? 0 : 2);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);
    final tanim = widget.tanim;
    final durum = ref.watch(oyunProvider)!.durum;
    final piyasa = durum.piyasa;
    final fiyat = piyasa.fiyat(tanim.id);
    final elde = durum.portfoy.satilabilirAdet(tanim.id);
    final degisim = piyasa.reelDegisim(tanim.id);

    String para(num ham) => bicim.kisaPara(piyasa.gosterimTutari(ham.round()));

    final brut = _adet * fiyat;
    final komisyon = brut * tanim.islemMaliyeti;
    final toplam = _satim ? brut - komisyon : brut + komisyon;

    // Alımda azami adet nakit ve komisyona göre; satımda eldeki miktar.
    final azami = _satim
        ? elde
        : (fiyat <= 0
            ? 0.0
            : durum.oyuncu.nakit / (fiyat * (1 + tanim.islemMaliyeti)));
    final gecerli = _adet > 0 &&
        _adet <= azami + 1e-9 &&
        (tanim.bolunebilir || _adet == _adet.roundToDouble());

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                varlikAdi(m, tanim.id),
                style: tema.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                tanim.tur.ad(m),
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    m.grafikBasligi(math.min(60, piyasa.seri(tanim.id).length)),
                    style: tema.textTheme.labelMedium?.copyWith(
                      color: tema.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (degisim != null)
                    Text(
                      bicim.yuzde(degisim),
                      style: tema.textTheme.labelMedium?.copyWith(
                        color: tema.oyun.tutar(degisim),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              FiyatGrafigi(seri: piyasa.seri(tanim.id)),
              const SizedBox(height: 12),
              OyunKarti(
                dolgu: 12,
                child: Column(
                  children: [
                    BilgiSatiri(
                      etiket: '${m.birimFiyat} / ${tanim.tur.birim(m)}',
                      deger: para(fiyat),
                    ),
                    BilgiSatiri(
                      etiket: m.nakit,
                      deger: para(durum.oyuncu.nakit),
                    ),
                    if (elde > 0)
                      BilgiSatiri(
                        etiket: m.portfoy,
                        deger: '${bicim.ondalik(elde)} '
                            '${tanim.tur.birim(m)}',
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(value: false, label: Text(m.al)),
                  ButtonSegment(value: true, label: Text(m.sat)),
                ],
                selected: {_satim},
                onSelectionChanged: (secim) => setState(() {
                  _satim = secim.first;
                  _adetDenetleyici.clear();
                }),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _adetDenetleyici,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: tanim.bolunebilir,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          tanim.bolunebilir
                              ? RegExp(r'[0-9.]')
                              : RegExp(r'[0-9]'),
                        ),
                      ],
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: '${m.adet} (${tanim.tur.birim(m)})',
                        border: const OutlineInputBorder(),
                        isDense: true,
                        helperText: tanim.bolunebilir ? null : m.bolunemez,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: azami <= 0 ? null : () => _adetYaz(azami),
                    child: Text(m.tumu),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              BilgiSatiri(etiket: m.komisyon, deger: para(komisyon)),
              BilgiSatiri(
                etiket: m.toplamTutar,
                deger: para(toplam),
                kalin: true,
              ),
              // Satışı turlar süren varlıkta fiyat riski SATICIDA: emir
              // anındaki fiyattan değil, tamamlandığı turdaki fiyattan
              // satılıyor. Bunu söylemeyen ekran oyuncuyu kandırır.
              if (_satim && !tanim.likit)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    m.satisGecikmesi(tanim.satisSuresiTur),
                    style: tema.textTheme.bodySmall
                        ?.copyWith(color: tema.oyun.uyari),
                  ),
                ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: gecerli ? _emirVer : null,
                child: Text(_satim ? m.sat : m.al),
              ),
              const SizedBox(height: 8),
              Text(
                m.emirNotu,
                textAlign: TextAlign.center,
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _emirVer() {
    final emir = _satim
        ? Satim(widget.tanim.id, _adet)
        : Alim(widget.tanim.id, _adet);
    ref.read(taleplerProvider.notifier).emirEkle(emir);
    Navigator.of(context).pop();
  }
}
