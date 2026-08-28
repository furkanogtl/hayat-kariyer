import 'package:flutter/material.dart';

import '../../core/engine/olay_motoru.dart';
import '../../core/engine/tur_processor.dart';
import '../../l10n/uygulama_metinleri.dart';
import '../../shared/bicimleme.dart';
import '../../shared/etiketler.dart';
import '../../shared/tema.dart';
import '../../shared/widgets/oyun_widgetlari.dart';

/// Rapor kâğıdının test anahtarı.
///
/// Rapor ve olay kartı aynı anda açılabildiği için (rapor kapanınca kart
/// geliyor) ikisi tipe bakarak ayırt edilemiyor.
const Key turRaporuAnahtari = Key('turRaporu');

/// Tur sonu raporunu alttan açılan kâğıt olarak gösterir.
///
/// Tek tur işlendiyse o ayın bilançosu, atlama yapıldıysa toplamı ve
/// atlamayı kesen olay gösterilir — oyuncu "neden durdu" diye sormasın.
Future<void> turRaporunuGoster(
  BuildContext context,
  List<TurRaporu> raporlar,
) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _TurRaporuKagidi(
        key: turRaporuAnahtari,
        raporlar: raporlar,
      ),
    );

/// Rapor satırlarının gösterim tutarı.
///
/// ÖLÇEK: NOMİNAL — oyuncunun cebine giren/çıkan gerçek tutar.
///
/// Reele çevirmek cazip görünüyor ama BİLANÇO TUTMAZ: rapor "+2 Mn" derken
/// Özet'teki nakit de aynı 2 Mn artmalı. Reel gösterilseydi ikisi hiçbir
/// zaman denk gelmezdi, çünkü mevcut bakiye de enflasyonla eriyor.
/// Enflasyonun görünmesi gereken yer ana skor; oradaki rakam reel ve öyle
/// etiketli.
///
/// Toplarken deflate EDİLMİYOR: 12 aylık atlama bir hesap özetidir.
/// Uygulanan tek şey para reformu ölçeği — o uygulanmadığında rapor
/// reformdan sonra eski parayla yazmaya devam ediyordu (1000 kat sapma).
///
/// Widget'tan ayrı duruyor: ölçek sözleşmesi metin aramadan test edilebilsin.
double raporToplami(
  List<TurRaporu> raporlar,
  int Function(TurRaporu) alan,
) {
  var sonuc = 0.0;
  for (final r in raporlar) {
    sonuc += alan(r);
  }
  return sonuc / raporlar.last.paraOlcegi;
}

class _TurRaporuKagidi extends StatelessWidget {
  const _TurRaporuKagidi({super.key, required this.raporlar});

  final List<TurRaporu> raporlar;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final son = raporlar.last;
    final coklu = raporlar.length > 1;
    double toplam(int Function(TurRaporu) alan) =>
        raporToplami(raporlar, alan);

    bool varMi(int Function(TurRaporu) alan) =>
        raporlar.any((r) => alan(r) != 0);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                coklu
                    ? m.atlananTur(raporlar.length)
                    : m.turRaporu(ayAdi(m, son.ay)),
                style: tema.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                m.yasBilgisi(son.yas),
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              OyunKarti(
                child: Column(
                  children: [
                    _Satir(m.raporGelir, toplam((r) => r.netGelir)),
                    _Satir(m.raporYasamGideri, -toplam((r) => r.yasamGideri)),
                    if (varMi((r) => r.odenenTaksit))
                      _Satir(m.raporTaksit, -toplam((r) => r.odenenTaksit)),
                    if (varMi((r) => r.faizGideri))
                      _Satir(m.raporFaiz, -toplam((r) => r.faizGideri)),
                    if (varMi((r) => r.kiraGeliri))
                      _Satir(m.raporKira, toplam((r) => r.kiraGeliri)),
                    if (varMi((r) => r.isletmeKari))
                      _Satir(m.raporIsletme, toplam((r) => r.isletmeKari)),
                    const Divider(height: 20),
                    _Satir(
                      m.raporNakitDegisimi,
                      toplam((r) => r.nakitDegisimi),
                      kalin: true,
                    ),
                  ],
                ),
              ),
              // Turlar önce verilmiş kararların açığa çıkan sonuçları.
              // Gecikmeli kartın zarı burada atıldı; oyuncu ne olduğunu
              // ancak bu satırdan öğreniyor.
              if (_acilanlar.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  m.gecmisKararlar,
                  style: tema.textTheme.titleSmall?.copyWith(
                    color: tema.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                for (final a in _acilanlar)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OyunKarti(
                      dolgu: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.olay.baslik,
                            style: tema.textTheme.labelMedium?.copyWith(
                              color: tema.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(a.sonuc.metin),
                        ],
                      ),
                    ),
                  ),
              ],
              // Uygulanamayan komutlar önce: oyuncu istediği krediyi ya da
              // işletme işlemini alamadıysa bunu bilanço satırlarından önce
              // görmeli. Söylenmezse "düğme çalışmıyor" sanır.
              ..._uyarilar(m).map(
                (metin) => Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Icon(
                          Icons.error_outline,
                          size: 16,
                          color: tema.oyun.uyari,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          metin,
                          style: TextStyle(color: tema.oyun.uyari),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ..._olaylar(m).map(
                (metin) => Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Icon(
                          Icons.circle,
                          size: 6,
                          color: tema.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(metin)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(m.devam),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bu turlarda açığa çıkan gecikmeli sonuçlar.
  List<AcigaCikanSonuc> get _acilanlar =>
      [for (final r in raporlar) ...r.acilanOlaylar];

  /// Oyuncunun verdiği ama uygulanamayan komutlar.
  ///
  /// Motor bunları baştan beri raporluyordu, arayüz hiç göstermiyordu.
  /// Sessizce düşen komut oyuncuya "düğme bozuk" gibi görünür; en sık
  /// karşılaşılacağı yer, kredi teklifini gördükten SONRA cevaplanan bir
  /// kartın kredi notunu düşürmesi.
  List<String> _uyarilar(UygulamaMetinleri m) {
    final satirlar = <String>[];
    for (final r in raporlar) {
      final kredi = r.krediHatasi;
      if (kredi != null) satirlar.add(m.uyariKrediReddedildi(kredi.ad(m)));
      final isletme = r.isletmeHatasi;
      if (isletme != null) satirlar.add(m.uyariIsletmeKomutu(isletme.ad(m)));
    }
    return satirlar;
  }

  /// Bu turlarda olan dikkat çekici şeyler. Atlamayı kesen olay da
  /// burada görünür.
  List<String> _olaylar(UygulamaMetinleri m) {
    final satirlar = <String>[];
    for (final r in raporlar) {
      if (r.terfiEtti) satirlar.add(m.olayTerfi(r.yeniKademeAdi ?? ''));
      if (r.istenCikarildi) satirlar.add(m.olayIstenCikarildi);
      if (r.mezunOldu) satirlar.add(m.olayMezunOldu);
      if (r.celpGeldi) satirlar.add(m.olayCelpGeldi);
      if (r.askereAlindi) satirlar.add(m.olayAskereAlindi);
      if (r.askerlikBitti) satirlar.add(m.olayAskerlikBitti);
      if (r.atamasiCikti) satirlar.add(m.olayAtamasiCikti);
      if (r.maasZammiYapildi) satirlar.add(m.olayMaasZammi);
      if (r.paraReformuYapildi) satirlar.add(m.olayParaReformu);
      if (r.rejimDegisti) satirlar.add(m.olayRejimDegisti(r.rejim.ad(m)));
    }
    return satirlar;
  }
}

class _Satir extends StatelessWidget {
  const _Satir(this.etiket, this.tutar, {this.kalin = false});

  final String etiket;
  final double tutar;
  final bool kalin;

  @override
  Widget build(BuildContext context) {
    final bicim = Bicim(Localizations.localeOf(context).languageCode);
    return BilgiSatiri(
      etiket: etiket,
      deger: bicim.imzaliPara(tutar),
      renk: Theme.of(context).oyun.tutar(tutar),
      kalin: kalin,
    );
  }
}
