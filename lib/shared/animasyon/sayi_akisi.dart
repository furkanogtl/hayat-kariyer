import 'package:flutter/material.dart';

import 'hareket.dart';

/// Değişen bir sayıyı zıplatmadan akıtarak gösterir.
///
/// Net değer ve statlar her turda değişiyor; anlık sıçrayınca oyuncu ne
/// kadar değiştiğini göremiyor. Akan sayı hem değişimi hissettiriyor hem
/// gözü doğru yere çekiyor.
///
/// Biçimlendirme dışarıdan geliyor ([bicimle]): para, yüzde ve tam sayı
/// aynı widget'ı kullanabilsin ve yerelleştirme tek yerde kalsın.
class SayiAkisi extends StatelessWidget {
  const SayiAkisi({
    super.key,
    required this.deger,
    required this.bicimle,
    this.stil,
    this.sure,
  });

  final num deger;
  final String Function(num) bicimle;
  final TextStyle? stil;
  final Duration? sure;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: deger.toDouble()),
      duration: Hareket.sure(context, sure ?? Hareket.sayac),
      curve: Hareket.giris,
      builder: (context, v, _) => Text(bicimle(v), style: stil),
    );
  }
}
