import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/models/olay.dart';

/// Kartı getiren kişinin tipi. Kart türünden türetilir; oyuncu kimin
/// geldiğini metni okumadan anlasın diye.
enum HaberciTipi {
  /// Takım elbiseli, çantalı. Fırsat kartları.
  isInsani,

  /// Kasketli, elinde tebligat. Kriz kartları.
  memur,

  /// Dosyalı, takım elbiseli. Teklif kartları.
  temsilci,

  /// Ceketsiz, gündelik. Hayat kartları.
  komsu;

  static HaberciTipi olayTurunden(OlayTuru tur) => switch (tur) {
        OlayTuru.firsat => HaberciTipi.isInsani,
        OlayTuru.kriz => HaberciTipi.memur,
        OlayTuru.teklif => HaberciTipi.temsilci,
        OlayTuru.hayat => HaberciTipi.komsu,
      };

  /// Ceket giyiyor mu — siluetin omuz ve bel çizgisini bu belirliyor.
  bool get takimElbiseli => this != HaberciTipi.komsu;

  /// Başında kasket var mı.
  bool get kasketli => this == HaberciTipi.memur;
}

/// Habercinin renkleri.
///
/// SİLUET: gövdenin tamamı TEK koyu renk. Önceki sürüm ten rengi yüz, kahve
/// saç, renkli ceket çiziyordu ve oyundan çok bir kurumsal illüstrasyona
/// benziyordu. Siluet hem daha oyun gibi duruyor hem koyu temayla
/// çakışmıyor: figür zeminden ışıkla ayrılıyor, renkle değil.
@immutable
class _Stil {
  const _Stil({
    required this.govde,
    required this.kenarIsigi,
    required this.gomlek,
    required this.kravat,
    required this.esya,
    required this.esyaVurgu,
  });

  /// Siluetin dolgu rengi. Tipler arasında yalnız TON farkı var; şekil
  /// ayırt ediyor, renk değil.
  final Color govde;

  /// Sağ üstten gelen ışığın gövde kenarında bıraktığı çizgi. Siluete
  /// derinlik veren tek şey bu.
  final Color kenarIsigi;

  final Color gomlek;
  final Color kravat;
  final Color esya;
  final Color esyaVurgu;

  static _Stil of(HaberciTipi tip) => switch (tip) {
        HaberciTipi.isInsani => const _Stil(
            govde: Color(0xFF0B1A16),
            kenarIsigi: Color(0xFFE8B84B),
            gomlek: Color(0xFFDCE7E1),
            kravat: Color(0xFFC8A03C),
            esya: Color(0xFF6B4523),
            esyaVurgu: Color(0xFFE8B84B),
          ),
        HaberciTipi.memur => const _Stil(
            govde: Color(0xFF10171C),
            kenarIsigi: Color(0xFF8FB6D6),
            gomlek: Color(0xFFDDE6EC),
            kravat: Color(0xFF3E5871),
            esya: Color(0xFFF1EFE8),
            esyaVurgu: Color(0xFFC4382C),
          ),
        HaberciTipi.temsilci => const _Stil(
            govde: Color(0xFF0C1520),
            kenarIsigi: Color(0xFFD9B65E),
            gomlek: Color(0xFFDCE4EC),
            kravat: Color(0xFF2E5A86),
            esya: Color(0xFFE8C15C),
            esyaVurgu: Color(0xFF6F531A),
          ),
        HaberciTipi.komsu => const _Stil(
            // 0xFF17120E denendi: koyu yeşil zeminde figür kayboluyordu.
            // Diğerlerinden bir tık açık; ceketsiz siluetin zaten daha az
            // ayırt edici olan biçimi bunu telafi etmeli.
            govde: Color(0xFF2A211A),
            kenarIsigi: Color(0xFFE0A96B),
            gomlek: Color(0xFFD8CFC4),
            kravat: Color(0xFF8A6244),
            esya: Color(0xFFF1EFE8),
            esyaVurgu: Color(0xFFB8863F),
          ),
      };
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

  /// Oyunun tek teması koyu; alan açık zeminli önizleme için duruyor.
  final bool karanlik;

  /// Çizimin tasarlandığı kutu; gerçek boyuta ölçekleniyor.
  ///
  /// Genişlik gövdenin ihtiyacından fazla: kol tam uzandığında eşya
  /// sağa taşıyor ve dar kutuda kırpılıyordu.
  static const Size tasarim = Size(215, 200);

  static const double _zemin = 194;

  @override
  void paint(Canvas tuval, Size boyut) {
    final olcek = math.min(
      boyut.width / tasarim.width,
      boyut.height / tasarim.height,
    );
    // SOLA yaslanıyor: bant telefon genişliğinde ve figür ortada kalınca
    // iki yanı boş bir tabloya dönüşüyordu. Solda durunca uzanan kol da
    // sağa, kartın metnine doğru bakıyor.
    tuval
      ..save()
      ..translate(boyut.width * 0.09, boyut.height - tasarim.height * olcek)
      ..scale(olcek);

    final s = _Stil.of(tip);
    // Yürürken gövde hafif inip kalkıyor; adım hissini bu veriyor.
    final zipla = math.sin(yurume * math.pi * 2) * 2.0;

    _golge(tuval);
    tuval
      ..save()
      ..translate(0, zipla);

    // İKİ GEÇİŞ. Önce ARKADAN IŞIK: aynı şekiller dışa doğru bulanık bir
    // halka bırakacak şekilde basılıyor, sonra gövde üstüne geliyor.
    //
    // İlk denemede halka yerine 3 piksel kaydırılmış sert bir kopya
    // vardı; çıkartma konturu gibi duruyor ve arka kol ikizleniyordu
    // (kopya, öndeki kolun boşluğundan görünüyordu). Bulanık halka hem
    // ikizlemiyor hem koyu zeminde figürü ayıran şey oluyor.
    tuval
      ..save()
      ..translate(1.5, -2);
    _figur(tuval, s.kenarIsigi, hale: true);
    tuval
      ..restore()
      ..save();
    _figur(tuval, s.govde);
    tuval.restore();

    // Gömlek, kravat ve eşya siluetin ÜSTÜNDE: tek renk gövdede "takım
    // elbiseli" okunmasını sağlayan tek detay bu.
    _gomlek(tuval, s);
    _esya(tuval, s, _elKonumu());
    tuval
      ..restore()
      ..restore();
  }

  /// Siluetin tamamı tek renkte. Parçalar üst üste bindiği için ayrı ayrı
  /// çizilmeleri tek bir gövde gibi görünüyor; `Path.combine` her karede
  /// birleştirme yapmak zorunda kalırdı.
  void _figur(Canvas tuval, Color renk, {bool hale = false}) {
    final maske =
        hale ? const MaskFilter.blur(BlurStyle.outer, 5) : null;
    final boya = Paint()
      ..color = renk
      ..maskFilter = maske;
    _bacaklar(tuval, boya, renk, maske);
    _arkaKol(tuval, renk, maske);
    _govde(tuval, boya);
    _bas(tuval, boya);
    _onKol(tuval, renk, maske);
  }

  void _golge(Canvas tuval) {
    // Ayakların dibinde sıkı, dışa doğru yumuşayan bir leke.
    final merkez = const Offset(80, _zemin + 4);
    tuval.drawOval(
      Rect.fromCenter(center: merkez, width: 96, height: 17),
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.black.withValues(alpha: karanlik ? 0.55 : 0.22),
            Colors.black.withValues(alpha: 0),
          ],
        ).createShader(
          Rect.fromCenter(center: merkez, width: 96, height: 17),
        ),
    );
  }

  /// Kalın yuvarlak uçlu çizgi: uzuvlar gövdeyle kaynaşsın diye.
  Paint _uzuv(Color renk, double kalinlik, [MaskFilter? maske]) => Paint()
    ..color = renk
    ..strokeWidth = kalinlik
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..maskFilter = maske;

  /// [kok] noktasından [aci] yönünde [uzunluk] kadar giden nokta.
  /// Açı derece, 0 = aşağı, pozitif = sağa doğru.
  Offset _uc(Offset kok, double aci, double uzunluk) {
    final r = aci * math.pi / 180;
    return Offset(
      kok.dx + math.sin(r) * uzunluk,
      kok.dy + math.cos(r) * uzunluk,
    );
  }

  void _bacaklar(Canvas tuval, Paint boya, Color renk, MaskFilter? maske) {
    // 16 derece denendi: adim fazla aciliyor ve figur cokuyor gibi
    // duruyordu. Dizsiz duz bacakta genis acinin karsiligi yok.
    final salinim = math.sin(yurume * math.pi * 2) * 11;
    // Pantolon paçası bilekte hafif genişliyor: iki kalınlıkta çizgi.
    const solKalca = Offset(71, 122);
    const sagKalca = Offset(89, 122);
    final solAyak = _uc(solKalca, salinim, 62);
    final sagAyak = _uc(sagKalca, -salinim, 62);
    tuval
      ..drawLine(solKalca, solAyak, _uzuv(renk, 17, maske))
      ..drawLine(sagKalca, sagAyak, _uzuv(renk, 17, maske));

    // Ayakkabı: öne doğru uzayan yassı bir biçim, topuk hizası zeminde.
    for (final a in [solAyak, sagAyak]) {
      final taban = Path()
        ..moveTo(a.dx - 10, a.dy + 5)
        ..lineTo(a.dx + 17, a.dy + 5)
        ..quadraticBezierTo(a.dx + 20, a.dy - 1, a.dx + 10, a.dy - 4)
        ..lineTo(a.dx - 8, a.dy - 4)
        ..close();
      tuval.drawPath(taban, boya);
    }
  }

  void _govde(Canvas tuval, Paint boya) {
    final ceket = tip.takimElbiseli;
    // Ceketli siluet: omuzlar keskin ve geniş, bele doğru daralıyor,
    // etek ucu hafif dışa açılıyor. Ceketsiz siluet: omuz yuvarlak,
    // gövde düz iniyor.
    final govde = Path();
    if (ceket) {
      govde
        ..moveTo(78, 70)
        ..lineTo(103, 78)
        ..quadraticBezierTo(108, 82, 106, 96)
        ..lineTo(101, 126)
        ..lineTo(59, 126)
        ..lineTo(54, 96)
        ..quadraticBezierTo(52, 82, 57, 78)
        ..close();
    } else {
      govde
        ..moveTo(80, 72)
        ..quadraticBezierTo(100, 74, 102, 90)
        ..lineTo(100, 128)
        ..lineTo(60, 128)
        ..lineTo(58, 90)
        ..quadraticBezierTo(60, 74, 80, 72)
        ..close();
    }
    tuval.drawPath(govde, boya);
  }

  void _bas(Canvas tuval, Paint boya) {
    // Boyun kısa ve kalın: siluette ince boyun kopuk görünüyor.
    tuval
      ..drawRect(const Rect.fromLTWH(73, 58, 14, 18), boya)
      // Baş hafif oval; tam daire çocuksu duruyordu.
      ..drawOval(
        Rect.fromCenter(center: const Offset(80, 42), width: 38, height: 43),
        boya,
      );

    if (tip.kasketli) {
      // Kasket: siluetin resmiyeti tek bakışta veren parçası. Siperlik
      // öne doğru uzuyor, bu yüzden profil hemen okunuyor.
      final kasket = Path()
        ..moveTo(61, 26)
        ..quadraticBezierTo(80, 8, 99, 26)
        ..lineTo(99, 30)
        ..lineTo(61, 30)
        ..close();
      tuval
        ..drawPath(kasket, boya)
        ..drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(60, 28, 52, 7),
            const Radius.circular(3.5),
          ),
          boya,
        );
    } else {
      // Saç: başın üst kenarına oturan hafif hacim.
      final sac = Path()
        ..moveTo(62, 38)
        ..quadraticBezierTo(66, 17, 82, 20)
        ..quadraticBezierTo(98, 22, 98, 40)
        ..quadraticBezierTo(92, 28, 62, 38)
        ..close();
      tuval.drawPath(sac, boya);
    }
  }

  /// Yakadan görünen gömlek üçgeni ve kravat.
  ///
  /// Siluette "takım elbise" bilgisini taşıyan tek işaret bu. Ceketsiz
  /// tipte yalnız yaka açıklığı var, kravat yok.
  void _gomlek(Canvas tuval, _Stil s) {
    final v = Path()
      ..moveTo(72, 74)
      ..lineTo(80, 96)
      ..lineTo(88, 74)
      ..close();
    tuval.drawPath(v, Paint()..color = s.gomlek);

    if (!tip.takimElbiseli) return;

    final kravat = Path()
      ..moveTo(80, 82)
      ..lineTo(84, 88)
      ..lineTo(81, 108)
      ..lineTo(77, 106)
      ..lineTo(76, 88)
      ..close();
    tuval.drawPath(kravat, Paint()..color = s.kravat);
  }

  void _arkaKol(Canvas tuval, Color renk, MaskFilter? maske) {
    final salinim = math.sin(yurume * math.pi * 2) * -15;
    const omuz = Offset(60, 84);
    final dirsek = _uc(omuz, salinim, 26);
    final el = _uc(dirsek, salinim * 0.5, 24);
    tuval
      ..drawLine(omuz, dirsek, _uzuv(renk, 14, maske))
      ..drawLine(dirsek, el, _uzuv(renk, 12, maske));
  }

  /// Öndeki kolun bilek noktası. Eşya da buraya oturuyor.
  Offset _elKonumu() {
    const omuz = Offset(100, 84);
    final yandaAci = 14 + math.sin(yurume * math.pi * 2) * 14;
    const uzatilmisAci = 76.0;
    final aci = yandaAci + (uzatilmisAci - yandaAci) * uzatma;
    final dirsek = _uc(omuz, aci, 26);
    // Uzanırken önkol daha da öne açılıyor: dümdüz kol robot gibi duruyordu.
    return _uc(dirsek, aci + 14 * uzatma, 24);
  }

  void _onKol(Canvas tuval, Color renk, MaskFilter? maske) {
    const omuz = Offset(100, 84);
    final yandaAci = 14 + math.sin(yurume * math.pi * 2) * 14;
    const uzatilmisAci = 76.0;
    final aci = yandaAci + (uzatilmisAci - yandaAci) * uzatma;
    final dirsek = _uc(omuz, aci, 26);
    final el = _elKonumu();
    tuval
      ..drawLine(omuz, dirsek, _uzuv(renk, 14, maske))
      ..drawLine(dirsek, el, _uzuv(renk, 12, maske));
  }

  /// Elindeki şey: kart türünü metni okumadan ele veren detay.
  ///
  /// Sahnedeki TEK doygun renk burası. Siluet koyu olduğu için göz
  /// doğrudan eşyaya gidiyor — kartın içeriği de oradan açılıyor.
  void _esya(Canvas tuval, _Stil s, Offset el) {
    switch (tip) {
      case HaberciTipi.isInsani:
        final govde = Rect.fromCenter(
          center: el.translate(2, 19),
          width: 48,
          height: 35,
        );
        tuval
          // Sap: elin üstünden geçen ince kemer.
          ..drawArc(
            Rect.fromCenter(center: el.translate(2, 2), width: 22, height: 20),
            math.pi,
            math.pi,
            false,
            Paint()
              ..color = s.esya
              ..strokeWidth = 4
              ..style = PaintingStyle.stroke,
          )
          ..drawRRect(
            RRect.fromRectAndRadius(govde, const Radius.circular(5)),
            Paint()..color = s.esya,
          )
          ..drawRect(
            Rect.fromLTWH(govde.left, govde.center.dy - 3, govde.width, 5),
            Paint()..color = s.esyaVurgu,
          )
          ..drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: govde.center.translate(0, -1),
                width: 9,
                height: 8,
              ),
              const Radius.circular(2),
            ),
            Paint()..color = s.esyaVurgu,
          );

      case HaberciTipi.memur:
        // Tebligat: kırmızı bantlı resmî kâğıt.
        final kagit = Rect.fromCenter(
          center: el.translate(11, 7),
          width: 40,
          height: 50,
        );
        tuval
          ..save()
          ..translate(kagit.center.dx, kagit.center.dy)
          ..rotate(-0.14)
          ..translate(-kagit.center.dx, -kagit.center.dy)
          ..drawRRect(
            RRect.fromRectAndRadius(kagit, const Radius.circular(3)),
            Paint()..color = s.esya,
          )
          ..drawRect(
            Rect.fromLTWH(kagit.left, kagit.top + 8, kagit.width, 7),
            Paint()..color = s.esyaVurgu,
          );
        for (var i = 0; i < 3; i++) {
          tuval.drawRect(
            Rect.fromLTWH(
              kagit.left + 7,
              kagit.top + 24 + i * 8.0,
              kagit.width - 14,
              3,
            ),
            Paint()..color = s.esyaVurgu.withValues(alpha: 0.3),
          );
        }
        tuval.restore();

      case HaberciTipi.temsilci:
        final dosya = Rect.fromCenter(
          center: el.translate(9, 9),
          width: 44,
          height: 52,
        );
        tuval
          ..drawRRect(
            RRect.fromRectAndRadius(dosya, const Radius.circular(4)),
            Paint()..color = s.esya,
          )
          ..drawRect(
            Rect.fromLTWH(dosya.left, dosya.top, dosya.width, 10),
            Paint()..color = s.esyaVurgu,
          )
          // Dosyadan taşan kâğıt ucu: durağan dikdörtgeni kırıyor.
          ..drawRect(
            Rect.fromLTWH(dosya.left + 6, dosya.top - 4, 16, 6),
            Paint()..color = s.esya.withValues(alpha: 0.75),
          );

      case HaberciTipi.komsu:
        final zarf = Rect.fromCenter(
          center: el.translate(9, 4),
          width: 46,
          height: 31,
        );
        final kapak = Path()
          ..moveTo(zarf.left, zarf.top)
          ..lineTo(zarf.center.dx, zarf.center.dy + 3)
          ..lineTo(zarf.right, zarf.top);
        tuval
          ..drawRRect(
            RRect.fromRectAndRadius(zarf, const Radius.circular(3)),
            Paint()..color = s.esya,
          )
          ..drawPath(
            kapak,
            Paint()
              ..color = s.esyaVurgu
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
