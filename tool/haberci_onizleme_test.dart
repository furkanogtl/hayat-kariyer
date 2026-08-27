// Haberci çizimini PNG'ye basar — emülatör açmadan görsel kontrol için.
//
//   flutter test tool/haberci_onizleme_test.dart
//
// Çıktı: scratch/haberci.png (gitignore'da; depoya girmez)
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/shared/animasyon/haberci.dart';

void main() {
  test('haberci önizleme', () async {
    const kare = Size(230, 215);
    // Satırlar: yürüyüşün ortası ve eşyayı uzatmış hali.
    const evreler = [
      (0.25, 0.0),
      (0.75, 0.0),
      (1.0, 1.0),
    ];
    final genislik = kare.width * HaberciTipi.values.length;
    final yukseklik = kare.height * evreler.length * 2;

    final kaydedici = ui.PictureRecorder();
    final tuval = Canvas(kaydedici);

    var y = 0.0;
    for (final karanlik in [false, true]) {
      tuval.drawRect(
        Rect.fromLTWH(0, y, genislik, kare.height * evreler.length),
        Paint()
          ..color = karanlik ? const Color(0xFF14201C) : const Color(0xFFF2F7F4),
      );
      for (final (yurume, uzatma) in evreler) {
        var x = 0.0;
        for (final tip in HaberciTipi.values) {
          tuval.save();
          tuval.translate(x, y);
          HaberciCizimi(
            tip: tip,
            yurume: yurume,
            uzatma: uzatma,
            karanlik: karanlik,
          ).paint(tuval, kare);
          tuval.restore();
          x += kare.width;
        }
        y += kare.height;
      }
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
