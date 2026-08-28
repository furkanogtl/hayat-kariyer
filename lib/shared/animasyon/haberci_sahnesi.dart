import 'package:flutter/material.dart';

import 'haberci.dart';
import 'hareket.dart';

/// Kartı getiren kişinin sahneye girip eşyayı uzattığı bant.
///
/// Zaman çizelgesi tek bir denetleyicide: 0–0,55 yürüyerek girer,
/// 0,55–1 kolunu uzatır. Bittiğinde [onTamamlandi] çağrılır ve kart
/// içeriği açılır.
///
/// SAHNEYE DOKUNMAK ANİMASYONU BİTİRİR. Oyun 480 tur; aynı girişi
/// yüzlerce kez izlemek isteyen olmaz.
class HaberciSahnesi extends StatefulWidget {
  const HaberciSahnesi({
    super.key,
    required this.tip,
    required this.onTamamlandi,
    this.yukseklik = 210,
  });

  final HaberciTipi tip;
  final VoidCallback onTamamlandi;

  /// Sahne bandının yüksekliği. Figür yüksekliğe göre ölçekleniyor, yani
  /// bu değer doğrudan figürün boyu demek.
  final double yukseklik;

  @override
  State<HaberciSahnesi> createState() => _HaberciSahnesiDurumu();
}

class _HaberciSahnesiDurumu extends State<HaberciSahnesi>
    with SingleTickerProviderStateMixin {
  late final AnimationController _denetim = AnimationController(
    vsync: this,
    duration: Hareket.uzun + Hareket.orta,
  );
  bool _bildirildi = false;

  @override
  void initState() {
    super.initState();
    _denetim.addStatusListener((durum) {
      if (durum == AnimationStatus.completed) _bildir();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (Hareket.kapali(context)) {
        _denetim.value = 1;
      } else {
        _denetim.forward();
      }
    });
  }

  void _bildir() {
    if (_bildirildi) return;
    _bildirildi = true;
    widget.onTamamlandi();
  }

  /// Dokununca sona atla.
  void _atla() {
    if (_denetim.isCompleted) return;
    _denetim.value = 1;
  }

  @override
  void dispose() {
    _denetim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final vurgu = tema.colorScheme.primary;

    return GestureDetector(
      onTap: _atla,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: widget.yukseklik,
          child: AnimatedBuilder(
            animation: _denetim,
            builder: (context, _) {
              final t = _denetim.value;
              // Girişin bittiği an: buradan sonra kol uzanmaya başlıyor.
              const girisSonu = 0.55;
              final giris = (t / girisSonu).clamp(0.0, 1.0);
              final uzatma =
                  ((t - girisSonu) / (1 - girisSonu)).clamp(0.0, 1.0);

              final ilerleme = Curves.easeOutCubic.transform(giris);
              final kayma = (1 - ilerleme) * -0.85;
              // Yürüyüş yalnız girişte; sonra ayaklar sabit.
              final yurume = giris < 1 ? giris * 2 : 0.0;

              return Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(
                    painter: _SahneZemini(
                      taban: tema.colorScheme.surfaceContainerLowest,
                      ust: tema.colorScheme.surfaceContainerHigh,
                      siluet: tema.colorScheme.surfaceContainerLow,
                      isik: vurgu,
                      // Şehir hattı figürden yavaş kayıyor: derinlik
                      // hissini paralaks veriyor, ayrı bir katman değil.
                      kaydir: ilerleme,
                      isikGucu: uzatma,
                    ),
                  ),
                  // Alt boşluk: figürün tabanı bandın en alt pikseline
                  // oturuyordu ve gölgesiyle ayakkabısı yuvarlatılmış
                  // köşeye kırpılıyordu.
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: FractionalTranslation(
                      translation: Offset(kayma, 0),
                      child: Opacity(
                        opacity: giris.clamp(0.0, 1.0),
                        child: CustomPaint(
                          painter: HaberciCizimi(
                            tip: widget.tip,
                            yurume: yurume,
                            uzatma: Curves.easeOutBack
                                .transform(uzatma)
                                .clamp(0.0, 1.0),
                            karanlik: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Habercinin arkasındaki sahne: gökyüzü, şehir silueti, ışık havuzu.
///
/// Önceki sürüm düz bir gradyan kutuydu ve figür boşlukta duruyordu.
/// Sahnenin işi figürü bir yere KOYMAK: şehir hattı Türkiye'de geçen bir
/// oyun olduğunu, ışık havuzu da olayın oyuncuya doğru geldiğini söylüyor.
class _SahneZemini extends CustomPainter {
  const _SahneZemini({
    required this.taban,
    required this.ust,
    required this.siluet,
    required this.isik,
    required this.kaydir,
    required this.isikGucu,
  });

  final Color taban;
  final Color ust;
  final Color siluet;
  final Color isik;

  /// Şehir hattının paralaks kayması (0-1).
  final double kaydir;

  /// Eşya uzatılırken ışık havuzu güçleniyor (0-1).
  final double isikGucu;

  /// Binalar gökyüzünden KOYU olmalı: arkadan aydınlanan bir şehir
  /// hattında siluet karanlıktır. İlk denemede yüzey renginden alınmıştı
  /// ve binalar gökyüzünden açık kalıp yamalı görünüyordu.
  Color get _binaRengi => Color.lerp(siluet, const Color(0xFF03110D), 0.55)!;

  /// Bina yükseklikleri ve genişlikleri. SABİT liste: her karede rastgele
  /// üretilseydi şehir titrerdi.
  /// İlk denemede en yükseği 56 pikseldi; bantta kutucuk gibi duruyor,
  /// şehir okunmuyordu. Yükseklikler bandın yarısına kadar çıkıyor.
  static const List<double> _binalar = [
    64, 42, 96, 56, 34, 110, 48, 78, 38, 88, 52, 70, 44, 102, 60,
  ];

  @override
  void paint(Canvas tuval, Size boyut) {
    final kutu = Offset.zero & boyut;
    final ufuk = boyut.height * 0.86;

    // Gökyüzü.
    tuval.drawRect(
      kutu,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ust, taban],
        ).createShader(kutu),
    );

    // Işık havuzu: figürün arkasından gelen sıcak halka.
    final odak = Offset(boyut.width * 0.26, ufuk);
    final yaricap = boyut.height * 0.85;
    tuval.drawCircle(
      odak,
      yaricap,
      Paint()
        ..shader = RadialGradient(
          colors: [
            isik.withValues(alpha: 0.16 + 0.10 * isikGucu),
            isik.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: odak, radius: yaricap)),
    );

    _sehir(tuval, boyut, ufuk);

    // Zemin ve ufuk çizgisi.
    tuval
      ..drawRect(
        Rect.fromLTRB(0, ufuk, boyut.width, boyut.height),
        Paint()..color = taban,
      )
      ..drawRect(
        Rect.fromLTWH(0, ufuk - 1, boyut.width, 1.5),
        Paint()..color = isik.withValues(alpha: 0.22),
      );

    // Vinyet: kenarlar koyulaşınca bant bir kutu değil bir sahne oluyor.
    tuval.drawRect(
      kutu,
      Paint()
        ..shader = RadialGradient(
          radius: 0.85,
          colors: [
            const Color(0x00000000),
            Colors.black.withValues(alpha: 0.35),
          ],
        ).createShader(kutu),
    );
  }

  void _sehir(Canvas tuval, Size boyut, double ufuk) {
    final boya = Paint()..color = _binaRengi;
    final pencere = Paint()..color = isik.withValues(alpha: 0.30);
    final genislik = boyut.width / 7;
    // Paralaks: figür bir tam ekran gelirken şehir yalnız yarım bina
    // kayıyor. Aynı hızda kaysaydı derinlik değil kayma hissi olurdu.
    final ofset = (1 - kaydir) * genislik * 0.5;

    for (var i = 0; i < _binalar.length; i++) {
      final yukseklik = _binalar[i];
      final x = i * genislik - genislik + ofset;
      if (x > boyut.width) break;
      final bina = Rect.fromLTWH(x, ufuk - yukseklik, genislik * 0.86, yukseklik);
      tuval.drawRect(bina, boya);

      // Birkaç aydınlık pencere: şehrin yaşadığını gösteren tek detay.
      final sira = (yukseklik / 14).floor();
      for (var s = 0; s < sira; s++) {
        for (var k = 0; k < 2; k++) {
          // Belirlenimli desen: (i, s, k) üçlüsünden türüyor, rastgele değil.
          if ((i * 7 + s * 3 + k * 5) % 4 != 0) continue;
          tuval.drawRect(
            Rect.fromLTWH(
              bina.left + 6 + k * (bina.width - 16) / 1.6,
              bina.top + 7 + s * 13.0,
              5,
              6,
            ),
            pencere,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_SahneZemini eski) =>
      eski.kaydir != kaydir ||
      eski.isikGucu != isikGucu ||
      eski.taban != taban ||
      eski.isik != isik;
}

/// Sahne zeminini tek başına çizen boyacı.
///
/// Açık: `tool/haberci_onizleme_test.dart` sahneyi widget ağacı kurmadan
/// PNG'ye basıyor. `@visibleForTesting` denendi ama `tool/` dizini test
/// sayılmıyor ve analiz uyarı veriyordu.
CustomPainter sahneZemini({
  required Color taban,
  required Color ust,
  required Color siluet,
  required Color isik,
  required double kaydir,
  required double isikGucu,
}) =>
    _SahneZemini(
      taban: taban,
      ust: ust,
      siluet: siluet,
      isik: isik,
      kaydir: kaydir,
      isikGucu: isikGucu,
    );
