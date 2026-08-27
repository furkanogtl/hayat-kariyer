import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/models/olay.dart';

/// Kartı getiren kişinin tipi. Kart türünden türetilir; oyuncu kimin
/// geldiğini metni okumadan anlasın diye.
enum HaberciTipi {
  /// Takım elbiseli, çantalı. Fırsat kartları.
  isInsani,

  /// Resmî görünüşlü, elinde tebligat. Kriz kartları.
  memur,

  /// Dosyalı, temkinli. Teklif kartları.
  temsilci,

  /// Gündelik kıyafetli komşu. Hayat kartları.
  komsu;

  static HaberciTipi olayTurunden(OlayTuru tur) => switch (tur) {
        OlayTuru.firsat => HaberciTipi.isInsani,
        OlayTuru.kriz => HaberciTipi.memur,
        OlayTuru.teklif => HaberciTipi.temsilci,
        OlayTuru.hayat => HaberciTipi.komsu,
      };
}

/// Habercinin renk paleti.
@immutable
class _Palet {
  const _Palet({
    required this.ust,
    required this.alt,
    required this.ten,
    required this.sac,
    required this.esya,
    required this.esyaVurgu,
  });

  final Color ust;
  final Color alt;
  final Color ten;
  final Color sac;
  final Color esya;
  final Color esyaVurgu;

  static _Palet of(HaberciTipi tip, bool karanlik) {
    const ten = Color(0xFFE0AC79);
    const tenKoyu = Color(0xFFC98F5E);
    final t = karanlik ? tenKoyu : ten;
    return switch (tip) {
      HaberciTipi.isInsani => _Palet(
          ust: const Color(0xFF1F5F4E),
          alt: const Color(0xFF163F35),
          ten: t,
          sac: const Color(0xFF2B2118),
          esya: const Color(0xFF7A4B22),
          esyaVurgu: const Color(0xFFD8A657),
        ),
      HaberciTipi.memur => _Palet(
          ust: const Color(0xFF4A5159),
          alt: const Color(0xFF32373C),
          ten: t,
          sac: const Color(0xFF3A3A3A),
          esya: const Color(0xFFF3F1EA),
          esyaVurgu: const Color(0xFFB3261E),
        ),
      HaberciTipi.temsilci => _Palet(
          ust: const Color(0xFF2E5A86),
          alt: const Color(0xFF23405E),
          ten: t,
          sac: const Color(0xFF241C14),
          esya: const Color(0xFFE8C15C),
          esyaVurgu: const Color(0xFF8A6A1F),
        ),
      HaberciTipi.komsu => _Palet(
          ust: const Color(0xFFB2603A),
          alt: const Color(0xFF5C4433),
          ten: t,
          sac: const Color(0xFF463126),
          esya: const Color(0xFFF3F1EA),
          esyaVurgu: const Color(0xFF9AA0A6),
        ),
    };
  }
}

/// Kartı getiren kişiyi çizer.
///
/// Rive/Lottie yerine `CustomPainter`: hazır animasyon dosyası indirmek
/// hem yeni bağımlılık hem hukuki belirsizlik getirirdi (anayasadaki
/// "gerçek marka kullanılmaz" sınırı varlıklar için de geçerli). Vektör
/// çizim her çözünürlükte keskin ve tema rengine uyum sağlıyor.
class HaberciCizimi extends CustomPainter {
  const HaberciCizimi({
    required this.tip,
    required this.yurume,
    required this.uzatma,
    required this.karanlik,
  });

  final HaberciTipi tip;

  /// Yürüme evresi (0-1). Bacaklar ve kollar buna göre salınır.
  final double yurume;

  /// Öndeki kolun uzanışı (0 = yanda, 1 = eşyayı uzatmış).
  final double uzatma;

  final bool karanlik;

  /// Çizimin tasarlandığı kutu; gerçek boyuta ölçekleniyor.
  ///
  /// Genişlik gövdenin ihtiyacından fazla: kol tam uzandığında eşya
  /// sağa taşıyor ve dar kutuda kırpılıyordu. Fazlalık sağda kalınca
  /// karakter sola yaslanıyor, eşya da kartın metnine doğru uzanıyor —
  /// istenen kompozisyon zaten bu.
  static const Size tasarim = Size(215, 200);

  @override
  void paint(Canvas tuval, Size boyut) {
    final olcek = math.min(boyut.width / tasarim.width,
        boyut.height / tasarim.height);
    // SOLA yaslanıyor, ortalanmıyor: bant telefon genişliğinde ve figür
    // ortada kalınca iki yanı boş bir tabloya dönüşüyordu. Solda durunca
    // uzanan kol da sağa, kartın metnine doğru bakıyor.
    final solBosluk = boyut.width * 0.10;
    tuval
      ..save()
      ..translate(
        solBosluk,
        boyut.height - tasarim.height * olcek,
      )
      ..scale(olcek);

    final p = _Palet.of(tip, karanlik);
    // Yürürken gövde hafif inip kalkıyor; adım hissini bu veriyor.
    final zipla = math.sin(yurume * math.pi * 2) * 2.0;

    _golge(tuval);
    tuval
      ..save()
      ..translate(0, zipla);
    _bacaklar(tuval, p);
    _arkaKol(tuval, p);
    _govde(tuval, p);
    _bas(tuval, p);
    _onKol(tuval, p);
    tuval
      ..restore()
      ..restore();
  }

  void _golge(Canvas tuval) {
    tuval.drawOval(
      const Rect.fromLTWH(38, 182, 84, 14),
      Paint()..color = Colors.black.withValues(alpha: karanlik ? 0.35 : 0.13),
    );
  }

  /// Kalın yuvarlak uçlu çizgi: düz tasarımda uzuv için en temiz yol.
  Paint _uzuv(Color renk, double kalinlik) => Paint()
    ..color = renk
    ..strokeWidth = kalinlik
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  /// [kok] noktasından [aci] yönünde [uzunluk] kadar giden nokta.
  /// Açı derece, 0 = aşağı, pozitif = sağa doğru.
  Offset _uc(Offset kok, double aci, double uzunluk) {
    final r = aci * math.pi / 180;
    return Offset(kok.dx + math.sin(r) * uzunluk, kok.dy + math.cos(r) * uzunluk);
  }

  void _bacaklar(Canvas tuval, _Palet p) {
    // Bacaklar zıt fazda salınıyor.
    final salinim = math.sin(yurume * math.pi * 2) * 17;
    final boya = _uzuv(p.alt, 15);
    const solKalca = Offset(72, 126);
    const sagKalca = Offset(90, 126);
    final solAyak = _uc(solKalca, salinim, 58);
    final sagAyak = _uc(sagKalca, -salinim, 58);
    tuval
      ..drawLine(solKalca, solAyak, boya)
      ..drawLine(sagKalca, sagAyak, boya);
    // Ayakkabılar.
    final ayakkabi = Paint()..color = p.sac;
    for (final a in [solAyak, sagAyak]) {
      tuval.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(a.dx - 11, a.dy - 3, 24, 10),
          const Radius.circular(5),
        ),
        ayakkabi,
      );
    }
  }

  void _govde(Canvas tuval, _Palet p) {
    // Omuzları geniş, bele doğru daralan bir gövde: ceket hissi.
    final govde = Path()
      ..moveTo(56, 78)
      ..lineTo(106, 78)
      ..lineTo(101, 130)
      ..lineTo(61, 130)
      ..close();
    tuval.drawPath(govde, Paint()..color = p.ust);

    // Yaka: gövdeyi ikiye bölen açık üçgen.
    final yaka = Path()
      ..moveTo(74, 78)
      ..lineTo(81, 96)
      ..lineTo(88, 78)
      ..close();
    tuval.drawPath(
      yaka,
      Paint()..color = Colors.white.withValues(alpha: karanlik ? 0.55 : 0.85),
    );
  }

  void _bas(Canvas tuval, _Palet p) {
    const merkez = Offset(81, 52);
    // Boyun.
    tuval
      ..drawLine(const Offset(81, 66), const Offset(81, 76), _uzuv(p.ten, 13))
      ..drawCircle(merkez, 22, Paint()..color = p.ten);

    // Saç: başın üst yarısını örten yay.
    final sac = Path()
      ..addArc(
        Rect.fromCircle(center: merkez, radius: 22),
        math.pi,
        math.pi,
      )
      ..close();
    tuval.drawPath(sac, Paint()..color = p.sac);

    // Memurun şapkası: resmiyeti tek bakışta veren detay.
    if (tip == HaberciTipi.memur) {
      tuval
        ..drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(57, 32, 48, 12),
            const Radius.circular(4),
          ),
          Paint()..color = p.alt,
        )
        ..drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(63, 22, 36, 14),
            const Radius.circular(5),
          ),
          Paint()..color = p.ust,
        );
    }
  }

  void _arkaKol(Canvas tuval, _Palet p) {
    final salinim = math.sin(yurume * math.pi * 2) * -14;
    const omuz = Offset(62, 84);
    tuval.drawLine(omuz, _uc(omuz, salinim, 44), _uzuv(p.alt, 13));
  }

  void _onKol(Canvas tuval, _Palet p) {
    // Kol, yandan (aşağı) uzatılmış (öne) konuma dönüyor.
    const omuz = Offset(100, 84);
    final yandaAci = 14 + math.sin(yurume * math.pi * 2) * 14;
    const uzatilmisAci = 78.0;
    final aci = yandaAci + (uzatilmisAci - yandaAci) * uzatma;
    final el = _uc(omuz, aci, 46);

    tuval.drawLine(omuz, el, _uzuv(p.ust, 13));
    _esya(tuval, p, el);
    // El, eşyanın üstünde kalsın.
    tuval.drawCircle(el, 7, Paint()..color = p.ten);
  }

  /// Elindeki şey: kart türünü metni okumadan ele veren detay.
  void _esya(Canvas tuval, _Palet p, Offset el) {
    switch (tip) {
      case HaberciTipi.isInsani:
        // Evrak çantası.
        tuval
          ..drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: el.translate(0, 20), width: 46, height: 34),
              const Radius.circular(5),
            ),
            Paint()..color = p.esya,
          )
          ..drawRect(
            Rect.fromCenter(center: el.translate(0, 20), width: 46, height: 6),
            Paint()..color = p.esyaVurgu,
          )
          ..drawLine(
            el.translate(-7, 3),
            el.translate(7, 3),
            _uzuv(p.esyaVurgu, 4),
          );

      case HaberciTipi.memur:
        // Tebligat: üstünde kırmızı bant olan kâğıt.
        final kagit = Rect.fromCenter(
          center: el.translate(10, 6),
          width: 38,
          height: 48,
        );
        tuval
          ..save()
          ..translate(kagit.center.dx, kagit.center.dy)
          ..rotate(-0.12)
          ..translate(-kagit.center.dx, -kagit.center.dy)
          ..drawRRect(
            RRect.fromRectAndRadius(kagit, const Radius.circular(3)),
            Paint()..color = p.esya,
          )
          ..drawRect(
            Rect.fromLTWH(kagit.left, kagit.top + 7, kagit.width, 6),
            Paint()..color = p.esyaVurgu,
          );
        for (var i = 0; i < 3; i++) {
          tuval.drawRect(
            Rect.fromLTWH(kagit.left + 6, kagit.top + 22 + i * 8.0,
                kagit.width - 12, 3),
            Paint()..color = p.esyaVurgu.withValues(alpha: 0.35),
          );
        }
        tuval.restore();

      case HaberciTipi.temsilci:
        // Dosya.
        final dosya = Rect.fromCenter(
          center: el.translate(8, 8),
          width: 42,
          height: 50,
        );
        tuval
          ..drawRRect(
            RRect.fromRectAndRadius(dosya, const Radius.circular(4)),
            Paint()..color = p.esya,
          )
          ..drawRect(
            Rect.fromLTWH(dosya.left, dosya.top, dosya.width, 9),
            Paint()..color = p.esyaVurgu,
          );

      case HaberciTipi.komsu:
        // Zarf.
        final zarf = Rect.fromCenter(
          center: el.translate(8, 3),
          width: 44,
          height: 30,
        );
        final kapak = Path()
          ..moveTo(zarf.left, zarf.top)
          ..lineTo(zarf.center.dx, zarf.center.dy + 2)
          ..lineTo(zarf.right, zarf.top);
        tuval
          ..drawRRect(
            RRect.fromRectAndRadius(zarf, const Radius.circular(3)),
            Paint()..color = p.esya,
          )
          ..drawPath(
            kapak,
            Paint()
              ..color = p.esyaVurgu
              ..strokeWidth = 2.5
              ..style = PaintingStyle.stroke,
          );
    }
  }

  @override
  bool shouldRepaint(HaberciCizimi eski) =>
      eski.yurume != yurume ||
      eski.uzatma != uzatma ||
      eski.tip != tip ||
      eski.karanlik != karanlik;
}
