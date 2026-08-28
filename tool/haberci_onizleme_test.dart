// Haberci sahnesini PNG'ye basar — emülatör açmadan görsel kontrol için.
//
//   flutter test tool/haberci_onizleme_test.dart
//
// Çıktı: scratch/haberci.png (gitignore'da; depoya girmez)
//
// Zemin de çiziliyor: figürü tek başına bakıp onaylamak yanıltıcıydı,
// asıl soru koyu sahnede nasıl durduğu.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/shared/animasyon/haberci.dart';
import 'package:hayat_kariyer/shared/animasyon/haberci_sahnesi.dart';
import 'package:hayat_kariyer/shared/tema.dart';

void main() {
  test('haberci önizleme', () async {
    // Telefon genişliğinde bir bant: sahne oyunda böyle görünüyor.
    const kare = Size(360, 210);
    const evreler = [(0.30, 0.0), (0.80, 0.0), (1.0, 1.0)];

    final sema = Tema.oyun().colorScheme;
    final genislik = kare.width * evreler.length;
    final yukseklik = kare.height * HaberciTipi.values.length;

    final kaydedici = ui.PictureRecorder();
    final tuval = Canvas(kaydedici);
    tuval.drawRect(
      Rect.fromLTWH(0, 0, genislik, yukseklik),
      Paint()..color = Tema.dipRengi,
    );

    var y = 0.0;
    for (final tip in HaberciTipi.values) {
      var x = 0.0;
      for (final (yurume, uzatma) in evreler) {
        tuval
          ..save()
          ..translate(x + 8, y + 8)
          ..clipRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(0, 0, kare.width - 16, kare.height - 16),
              const Radius.circular(20),
            ),
          );
        final ic = Size(kare.width - 16, kare.height - 16);
        sahneZemini(
          taban: sema.surfaceContainerLowest,
          ust: sema.surfaceContainerHigh,
          siluet: sema.surfaceContainerLow,
          isik: sema.primary,
          kaydir: yurume.clamp(0.0, 1.0),
          isikGucu: uzatma,
        ).paint(tuval, ic);
        HaberciCizimi(
          tip: tip,
          yurume: yurume,
          uzatma: uzatma,
          karanlik: true,
        ).paint(tuval, ic);
        tuval.restore();
        x += kare.width;
      }
      y += kare.height;
    }

    final resim = await kaydedici
        .endRecording()
        .toImage(genislik.round(), yukseklik.round());
    final veri = await resim.toByteData(format: ui.ImageByteFormat.png);
    final dosya = File('scratch/haberci.png');
    await dosya.parent.create(recursive: true);
    await dosya.writeAsBytes(veri!.buffer.asUint8List());
    // ignore: avoid_print
    print('${dosya.path} yazıldı '
        '(${genislik.round()}x${yukseklik.round()}, '
        '${veri.lengthInBytes ~/ 1024} KB)');
  });
}
