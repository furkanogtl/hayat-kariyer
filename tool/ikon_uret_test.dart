// Uygulama simgesini üretir. Test DEĞİL, bir çizim betiği: `dart:ui`
// zaten Flutter test koşucusunda hazır olduğu için ayrı bir görüntü
// kütüphanesi (PIL, ImageMagick) gerekmiyor.
//
//   flutter test tool/ikon_uret_test.dart
//
// `test/` ALTINDA DEĞİL: orada olsaydı her `flutter test` koşuşunda
// simgeler yeniden yazılır, çalışma ağacı kirlenirdi. Adının `_test.dart`
// ile bitmesi zorunlu — flutter test yalnız o kalıbı çalıştırıyor.
//
// Çıktı: assets/icon/ikon.png (1024, tam simge — iOS ve eski Android)
//        assets/icon/ikon_on.png (1024, saydam zemin — Android uyarlanabilir)
//
// Üretilen PNG'ler depoda tutuluyor: simge yeniden üretilebilir olmalı ama
// her derlemede çizilmesi gerekmiyor.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

const int _boyut = 1024;

/// Tema tohumundan türeyen koyu yeşil zemin.
const ui.Color _zemin = ui.Color(0xFF10362D);
const ui.Color _zeminAlt = ui.Color(0xFF0A241E);
const ui.Color _altinUst = ui.Color(0xFFF6C453);
const ui.Color _altinAlt = ui.Color(0xFFC98A18);
const ui.Color _cizgi = ui.Color(0xFF6FD48B);

/// Simgeyi çizer. [zeminVar] false ise yalnız çizim kalır (uyarlanabilir
/// simgenin ön katmanı); o katmanda çizim güvenli alana sığmalı, çünkü
/// Android kenarları kırpıyor.
void _ciz(ui.Canvas tuval, {required bool zeminVar}) {
  const merkez = _boyut / 2;

  if (zeminVar) {
    tuval.drawRect(
      ui.Rect.fromLTWH(0, 0, _boyut.toDouble(), _boyut.toDouble()),
      ui.Paint()
        ..shader = ui.Gradient.linear(
          const ui.Offset(0, 0),
          ui.Offset(_boyut.toDouble(), _boyut.toDouble()),
          [_zemin, _zeminAlt],
        ),
    );
  }

  // Çizimin kendi sınır kutusu (para sol-altta, ok sağ-üstte) tuvalin
  // merkezinde DEĞİL. Önce kutuyu ortalıyoruz, sonra ölçekliyoruz; yoksa
  // uyarlanabilir simge tuval merkezine göre küçülüp yamuk oturuyor.
  const kutu = ui.Rect.fromLTRB(180, 290, 880, 840);
  final kaydir = ui.Offset(merkez - kutu.center.dx, merkez - kutu.center.dy);

  // Uyarlanabilir simgede güvenli alan merkezin ~%66'sı; çizimi küçültüyoruz.
  final olcek = zeminVar ? 1.0 : 0.66;
  tuval
    ..save()
    ..translate(merkez, merkez)
    ..scale(olcek)
    ..translate(-merkez, -merkez)
    ..translate(kaydir.dx, kaydir.dy);

  // Yükselen çizgi paranın ARKASINDAN geçiyor: önce çiziliyor ve alt ucu
  // paranın içinde başlıyor, böylece dışarı sarkan bir kuyruk kalmıyor.
  final yol = ui.Path()
    ..moveTo(430, 640)
    ..lineTo(560, 520)
    ..lineTo(660, 590)
    ..lineTo(830, 360);
  final cizgiBoyasi = ui.Paint()
    ..style = ui.PaintingStyle.stroke
    ..strokeWidth = 54
    ..strokeCap = ui.StrokeCap.round
    ..strokeJoin = ui.StrokeJoin.round
    ..color = _cizgi;
  tuval.drawPath(yol, cizgiBoyasi);

  // Ok başı.
  final ok = ui.Path()
    ..moveTo(872, 300)
    ..lineTo(846, 470)
    ..lineTo(716, 352)
    ..close();
  tuval.drawPath(ok, ui.Paint()..color = _cizgi);

  // Madeni para.
  const paraMerkezi = ui.Offset(392, 628);
  const yaricap = 212.0;
  tuval
    ..drawCircle(
      paraMerkezi,
      yaricap,
      ui.Paint()
        ..shader = ui.Gradient.linear(
          paraMerkezi - const ui.Offset(yaricap, yaricap),
          paraMerkezi + const ui.Offset(yaricap, yaricap),
          [_altinUst, _altinAlt],
        ),
    )
    // İç halka: paraya madeni his veriyor.
    ..drawCircle(
      paraMerkezi,
      yaricap - 32,
      ui.Paint()
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 11
        ..color = _altinAlt.withValues(alpha: 0.5),
    );

  // ₺ işareti VEKTÖR olarak çiziliyor, metin olarak değil: test koşucusunda
  // bu glifi taşıyan font yok ve tofu kutusu çıkıyordu. Simgenin bir font
  // dosyasına bağlı olmaması ayrıca daha sağlam.
  //
  // Harf: dik gövde, tepesi sağa kıvrılır, iki eğik kol gövdeyi keser.
  final lira = ui.Path()
    // Gövde: yukarıdan aşağı, tepesi sağa doğru eğik.
    ..moveTo(paraMerkezi.dx + 6, paraMerkezi.dy - 132)
    ..lineTo(paraMerkezi.dx - 34, paraMerkezi.dy - 96)
    ..lineTo(paraMerkezi.dx - 34, paraMerkezi.dy + 132);
  final liraBoyasi = ui.Paint()
    ..style = ui.PaintingStyle.stroke
    ..strokeWidth = 34
    ..strokeCap = ui.StrokeCap.round
    ..strokeJoin = ui.StrokeJoin.round
    ..color = _zeminAlt;
  tuval.drawPath(lira, liraBoyasi);

  // İki eğik kol.
  for (final dy in [-46.0, 26.0]) {
    tuval.drawLine(
      ui.Offset(paraMerkezi.dx - 104, paraMerkezi.dy + dy + 34),
      ui.Offset(paraMerkezi.dx + 78, paraMerkezi.dy + dy - 38),
      liraBoyasi,
    );
  }

  tuval.restore();
}

Future<void> _yaz(String yol, {required bool zeminVar}) async {
  final kaydedici = ui.PictureRecorder();
  final tuval = ui.Canvas(kaydedici);
  _ciz(tuval, zeminVar: zeminVar);
  final resim = await kaydedici.endRecording().toImage(_boyut, _boyut);
  final veri = await resim.toByteData(format: ui.ImageByteFormat.png);
  final dosya = File(yol);
  await dosya.parent.create(recursive: true);
  await dosya.writeAsBytes(veri!.buffer.asUint8List());
  // ignore: avoid_print
  print('$yol yazıldı (${veri.lengthInBytes ~/ 1024} KB)');
}

void main() {
  test('simge üret', () async {
    await _yaz('assets/icon/ikon.png', zeminVar: true);
    await _yaz('assets/icon/ikon_on.png', zeminVar: false);
    expect(File('assets/icon/ikon.png').existsSync(), isTrue);
  });
}
