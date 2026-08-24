import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/engine/isletme_motoru.dart';
import '../../core/engine/tur_processor.dart';
import '../../core/models/ilgi_dagilimi.dart';
import '../../core/models/isletme.dart';
import '../../core/models/isletme_katalogu.dart';
import '../../core/models/oyun_durumu.dart';
import '../../l10n/uygulama_metinleri.dart';
import '../../shared/bicimleme.dart';
import '../../shared/etiketler.dart';
import '../../shared/tema.dart';
import '../../shared/widgets/oyun_widgetlari.dart';
import '../oyun/oyun_saglayicilar.dart';

/// İşletme sekmesi: sahip olunan işletmeler, ilgi dağılımı ve açılabilecek
/// işletmeler.
///
/// İLGİ PUANI oyunun strateji derinliğinin temeli: turda 6 puan var,
/// zaman dağılımından AYRI kaynak. Kafe 2, oto galeri 3 puan istiyor;
/// üçüncü işletme matematiksel olarak sığmıyor. Bu kısıt bilerek böyle.
class IsletmeEkrani extends ConsumerWidget {
  const IsletmeEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final durum = ref.watch(oyunProvider)!.durum;
    final katalog = ref.watch(kataloglarProvider).requireValue.isletmeler;
    final motor = ref.watch(turProcessorProvider).isletme!;
    final komut = ref.watch(taleplerProvider).isletmeKomutu;

    final acilabilir = katalog
        .acilabilirler(durum.oyuncu)
        .where((t) => t.girisSarti.karsilaniyorMu(durum.oyuncu))
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        if (komut != null) ...[
          _KomutKarti(komut: komut, katalog: katalog),
          const SizedBox(height: 12),
        ],
        if (durum.isletmeler.isEmpty)
          OyunKarti(
            child: Text(
              m.isletmeYok,
              style: tema.textTheme.bodyMedium?.copyWith(
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else ...[
          _IlgiOzeti(durum: durum, motor: motor),
          const SizedBox(height: 12),
          for (final isletme in durum.isletmeler)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _IsletmeKarti(
                isletme: isletme,
                durum: durum,
                motor: motor,
              ),
            ),
        ],
        const SizedBox(height: 20),
        BolumBasligi(m.acilabilirIsletmeler),
        if (acilabilir.isEmpty)
          OyunKarti(child: Text(m.acilabilirYok))
        else
          for (final tanim in acilabilir)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _AcilabilirKarti(
                tanim: tanim,
                durum: durum,
                motor: motor,
                kilitli: komut != null,
              ),
            ),
      ],
    );
  }
}

/// Turda bekleyen işletme komutu. Tek komut hakkı olduğu için ekran bunu
/// açıkça gösteriyor ve geri almaya izin veriyor.
class _KomutKarti extends ConsumerWidget {
  const _KomutKarti({required this.komut, required this.katalog});

  final IsletmeKomutu komut;
  final IsletmeKatalogu katalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final metin = switch (komut) {
      IsletmeAc(:final tanimId) =>
        '${m.isletmeAc}: ${katalog.bul(tanimId)?.ad ?? tanimId}',
      IsletmeSat() => m.isletmeSat,
      CeoAyarla(:final ceoVar) => ceoVar ? m.ceoAta : m.ceoKaldir,
    };

    return Card(
      color: tema.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metin,
                    style: tema.textTheme.titleSmall?.copyWith(
                      color: tema.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    m.isletmeKomutBekliyor,
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: tema.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () =>
                  ref.read(taleplerProvider.notifier).isletmeKomutu(null),
              child: Text(m.vazgecKomut),
            ),
          ],
        ),
      ),
    );
  }
}

class _IlgiOzeti extends StatelessWidget {
  const _IlgiOzeti({required this.durum, required this.motor});

  final OyunDurumu durum;
  final IsletmeMotoru motor;

  @override
  Widget build(BuildContext context) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final gereken = motor.toplamGerekenIlgi(durum.isletmeler);
    final dagitilan = durum.ilgi.toplam;

    return OyunKarti(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(m.ilgiDagilimi, style: tema.textTheme.titleSmall),
              Text(
                '$dagitilan / ${IlgiDagilimi.toplamPuan}',
                style: tema.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  // Gerekenden az dağıtılmışsa uyarı rengi: oyuncu
                  // işletmesinin çöktüğünü rapor gelene kadar fark etmesin
                  // istemiyoruz.
                  color: dagitilan < gereken ? tema.oyun.uyari : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: dagitilan / IlgiDagilimi.toplamPuan,
              minHeight: 6,
              backgroundColor: tema.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(
                dagitilan < gereken
                    ? tema.oyun.uyari
                    : tema.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IsletmeKarti extends ConsumerWidget {
  const _IsletmeKarti({
    required this.isletme,
    required this.durum,
    required this.motor,
  });

  final Isletme isletme;
  final OyunDurumu durum;
  final IsletmeMotoru motor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);
    final tanim = motor.katalog.bul(isletme.tanimId);
    if (tanim == null) return const SizedBox();

    final gereken = motor.gerekenIlgi(isletme);
    final ayrilan = durum.ilgi.puan(isletme.id);
    final oran = gereken <= 0 ? 1.0 : (ayrilan / gereken).clamp(0.0, 1.0);
    final komutVar = ref.watch(taleplerProvider).isletmeKomutu != null;

    String para(int ham) =>
        bicim.kisaPara(durum.piyasa.gosterimTutari(ham));

    return OyunKarti(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(tanim.ad, style: tema.textTheme.titleMedium),
              ),
              if (isletme.ceoVar)
                Icon(Icons.badge, size: 18, color: tema.colorScheme.primary),
            ],
          ),
          if (isletme.satista)
            Text(
              m.isletmeSatista(isletme.satisKalanTur ?? 0),
              style: tema.textTheme.bodySmall?.copyWith(
                color: tema.oyun.uyari,
              ),
            ),
          const SizedBox(height: 10),
          BilgiSatiri(
            etiket: m.aylikKar,
            deger: bicim.imzaliPara(
              durum.piyasa.gosterimTutari(isletme.sonNetKar),
            ),
            renk: tema.oyun.tutar(isletme.sonNetKar),
          ),
          BilgiSatiri(
            etiket: m.isletmeDegeri,
            deger: para(motor.satisDegeri(isletme, durum.piyasa)),
          ),
          for (final stat in tanim.statlar)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: StatCubugu(
                etiket: stat,
                deger: isletme.stat(stat),
                uyariEsigi: 30,
              ),
            ),
          const Divider(height: 20),
          // İlgi seçici: satıştaki işletmeye puan ayırmak anlamsız.
          if (!isletme.satista)
            _IlgiSecici(
              isletmeId: isletme.id,
              gereken: gereken,
              ayrilan: ayrilan,
            ),
          if (oran < 1 && !isletme.satista)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                oran <= 0 ? m.ilgiYok : m.ilgiKismi,
                style: tema.textTheme.bodySmall?.copyWith(
                  color: oran <= 0 ? tema.oyun.kayip : tema.oyun.uyari,
                ),
              ),
            ),
          if (isletme.ihmalTuru > 0 && !isletme.satista)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                m.isletmeKrizUyarisi,
                style: tema.textTheme.bodySmall
                    ?.copyWith(color: tema.oyun.kayip),
              ),
            ),
          const SizedBox(height: 12),
          if (!isletme.satista)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: komutVar
                        ? null
                        : () => ref
                            .read(taleplerProvider.notifier)
                            .isletmeKomutu(
                              CeoAyarla(
                                isletme.id,
                                ceoVar: !isletme.ceoVar,
                              ),
                            ),
                    child: Text(isletme.ceoVar ? m.ceoKaldir : m.ceoAta),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: komutVar
                      ? null
                      : () => _satisOnayi(context, ref, tanim.satisSuresiTur),
                  child: Text(m.isletmeSat),
                ),
              ],
            ),
          if (!isletme.ceoVar && !isletme.satista)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${m.ceoAcikla} ${m.ceoMaasi}: '
                '${para(durum.piyasa.endeksle(tanim.ceoMaasi))}',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _satisOnayi(
    BuildContext context,
    WidgetRef ref,
    int sure,
  ) async {
    final m = UygulamaMetinleri.of(context);
    // Satış geri alınamaz bir karar: zarar eden işletme enkaz bedeline
    // gider. Onaysız tek dokunuşla yapılmamalı.
    final onay = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(m.isletmeSat),
        content: Text(m.isletmeSatUyari(sure)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(m.vazgec),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(m.isletmeSat),
          ),
        ],
      ),
    );
    if (onay ?? false) {
      ref.read(taleplerProvider.notifier).isletmeKomutu(
            IsletmeSat(isletme.id),
          );
    }
  }
}

class _IlgiSecici extends ConsumerWidget {
  const _IlgiSecici({
    required this.isletmeId,
    required this.gereken,
    required this.ayrilan,
  });

  final String isletmeId;
  final int gereken;
  final int ayrilan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final durum = ref.watch(oyunProvider)!.durum;
    final bos = durum.ilgi.bosPuan;

    void ayarla(int yeni) => ref
        .read(oyunProvider.notifier)
        .ilgiAyarla(isletmeId, yeni.clamp(0, IlgiDagilimi.toplamPuan));

    return Row(
      children: [
        Expanded(child: Text('${m.ilgiPuani} ($ayrilan/$gereken)')),
        IconButton(
          onPressed: ayrilan > 0 ? () => ayarla(ayrilan - 1) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(
          width: 24,
          child: Text(
            '$ayrilan',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        IconButton(
          // Gerekenin üstündeki puan HİÇBİR İŞE YARAMIYOR: motor ilgi
          // oranını 1,0'da kırpıyor. Düğmeyi açık bırakmak oyuncuya
          // olmayan bir seçenek sunardı.
          onPressed:
              bos > 0 && ayrilan < gereken ? () => ayarla(ayrilan + 1) : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

class _AcilabilirKarti extends ConsumerWidget {
  const _AcilabilirKarti({
    required this.tanim,
    required this.durum,
    required this.motor,
    required this.kilitli,
  });

  final IsletmeTanimi tanim;
  final OyunDurumu durum;
  final IsletmeMotoru motor;
  final bool kilitli;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = UygulamaMetinleri.of(context);
    final tema = Theme.of(context);
    final bicim = Bicim(Localizations.localeOf(context).languageCode);
    final bedel = motor.kurulusBedeli(tanim, durum.piyasa);
    final parasiYeter = durum.oyuncu.nakit >= bedel;

    return OyunKarti(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tanim.ad, style: tema.textTheme.titleSmall),
          const SizedBox(height: 4),
          BilgiSatiri(
            etiket: m.kurulusBedeli,
            deger: bicim.kisaPara(durum.piyasa.gosterimTutari(bedel)),
            renk: parasiYeter ? null : tema.oyun.kayip,
          ),
          BilgiSatiri(
            etiket: m.ilgiPuani,
            deger: '${tanim.yonetimYuku}',
          ),
          if (tanim.girisSarti.sektor case final sektor?)
            Text(
              m.sartYetkinlikSektor(
                sektor.ad(m),
                tanim.girisSarti.yetkinlik,
              ),
              style: tema.textTheme.bodySmall?.copyWith(
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
          if (tanim.girisSarti.itibar > 0)
            Text(
              m.sartItibar(tanim.girisSarti.itibar),
              style: tema.textTheme.bodySmall?.copyWith(
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: kilitli || !parasiYeter
                ? null
                : () => ref
                    .read(taleplerProvider.notifier)
                    .isletmeKomutu(IsletmeAc(tanim.id)),
            child: Text(m.isletmeAc),
          ),
          if (!parasiYeter)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                m.isletmeHataNakit,
                style: tema.textTheme.bodySmall
                    ?.copyWith(color: tema.oyun.kayip),
              ),
            ),
        ],
      ),
    );
  }
}
