import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/piyasa_simulatoru.dart';
import 'package:hayat_kariyer/core/engine/rejim.dart';
import 'package:hayat_kariyer/core/models/piyasa_durumu.dart';
import 'package:hayat_kariyer/core/models/varlik.dart';
import 'package:hayat_kariyer/core/rng/rng.dart';

/// Rejimi sabit tutarak tur getirilerini ölçer.
///
/// `rejimSuresi` her adımda sıfırlandığı için asgari süre kuralı devreye
/// girer ve rejim değişemez; böylece tek bir rejimin davranışı izole edilir.
Map<String, List<double>> rejimGetirileri(Rejim rejim, int ornek) {
  final motor = PiyasaSimulatoru();
  final getiriler = <String, List<double>>{
    for (final v in motor.varliklar) v.id: <double>[],
  };
  var durum = motor.baslangic(rejim: rejim);
  for (var tur = 1; tur <= ornek; tur++) {
    final akis = RastgeleKaynak(90210).akis('piyasa', tur: tur);
    final sonraki = motor.turIsle(durum.copyWith(rejimSuresi: 0), akis);
    for (final v in motor.varliklar) {
      getiriler[v.id]!.add(sonraki.fiyat(v.id) / durum.fiyat(v.id) - 1);
    }
    durum = sonraki;
  }
  return getiriler;
}

double ortalama(List<double> x) => x.reduce((a, b) => a + b) / x.length;

double standartSapma(List<double> x) {
  final m = ortalama(x);
  return math.sqrt(
    x.map((v) => (v - m) * (v - m)).reduce((a, b) => a + b) / x.length,
  );
}

double korelasyon(List<double> a, List<double> b) {
  final ma = ortalama(a);
  final mb = ortalama(b);
  var kov = 0.0;
  var va = 0.0;
  var vb = 0.0;
  for (var i = 0; i < a.length; i++) {
    kov += (a[i] - ma) * (b[i] - mb);
    va += (a[i] - ma) * (a[i] - ma);
    vb += (b[i] - mb) * (b[i] - mb);
  }
  return kov / math.sqrt(va * vb);
}

/// Serbest simülasyon: rejimler kendi akışında değişir.
({Map<String, double> aylikGetiri, double aylikEnflasyon}) uzunVade(
  int tohumSayisi,
  int turSayisi,
) {
  final motor = PiyasaSimulatoru();
  final logToplam = <String, double>{for (final v in motor.varliklar) v.id: 0};
  var enflasyonLog = 0.0;
  for (var tohum = 0; tohum < tohumSayisi; tohum++) {
    final kaynak = RastgeleKaynak(tohum);
    var durum = motor.baslangic();
    final ilk = durum;
    for (var tur = 1; tur <= turSayisi; tur++) {
      durum = motor.turIsle(durum, kaynak.akis('piyasa', tur: tur));
    }
    for (final v in motor.varliklar) {
      logToplam[v.id] =
          logToplam[v.id]! + math.log(durum.fiyat(v.id) / ilk.fiyat(v.id));
    }
    enflasyonLog += math.log(durum.enflasyonEndeksi);
  }
  final n = tohumSayisi * turSayisi;
  return (
    aylikGetiri: {
      for (final v in motor.varliklar)
        v.id: math.exp(logToplam[v.id]! / n) - 1,
    },
    aylikEnflasyon: math.exp(enflasyonLog / n) - 1,
  );
}

void main() {
  final motor = PiyasaSimulatoru();

  group('Varlık tanımları', () {
    test('kimlikler benzersiz ve 12 varlık var', () {
      final kimlikler = motor.varliklar.map((v) => v.id).toList();
      expect(kimlikler.toSet(), hasLength(kimlikler.length));
      expect(kimlikler, hasLength(12));
      expect(hisseSektorleri, hasLength(6));
    });

    test('her varlığın her rejim için parametresi var', () {
      for (final v in motor.varliklar) {
        for (final r in Rejim.values) {
          expect(v.parametreler[r], isNotNull, reason: '${v.id}/${r.id}');
          expect(v.parametre(r).oynaklik, greaterThanOrEqualTo(0));
        }
      }
    });

    test('ortak faktör ağırlıkları geçerli aralıkta', () {
      for (final v in motor.varliklar) {
        expect(v.ortakAgirlik, inInclusiveRange(0, 1), reason: v.id);
        if (v.ortakFaktor == OrtakFaktor.yok) {
          expect(v.ortakAgirlik, 0, reason: v.id);
        }
      }
    });

    test('likidite kuralları: arsa ve gayrimenkul anında satılamaz', () {
      final arsa = motor.varliklar.firstWhere((v) => v.id == 'arsa');
      final ev = motor.varliklar.firstWhere((v) => v.id == 'gayrimenkul');
      expect(arsa.likit, isFalse);
      expect(ev.likit, isFalse);
      expect(ev.satisSuresiTur, inInclusiveRange(2, 3));
      expect(arsa.aylikGetiriOrani, 0, reason: 'arsa gelir üretmemeli');
      expect(ev.aylikGetiriOrani, greaterThan(0), reason: 'kira geliri');
      for (final v in motor.varliklar.where((v) => v.tur == VarlikTuru.hisse)) {
        expect(v.likit, isTrue, reason: v.id);
      }
    });

    test('mevduat her rejimde enflasyonun altında getiri verir', () {
      final mevduat = motor.varliklar.firstWhere((v) => v.id == 'mevduat');
      for (final r in Rejim.values) {
        expect(
          mevduat.parametre(r).drift,
          lessThan(r.parametreler.aylikEnflasyon),
          reason: '${r.id}: mevduat enflasyonu yeniyor, nakit baskısı kalkar',
        );
      }
    });

    test('yüksek beta iyi rejimde daha çok kazanır, krizde daha çok kaybeder', () {
      final sirali = [...hisseSektorleri]
        ..sort((a, b) => a.beta.compareTo(b.beta));
      for (final r in Rejim.values) {
        final primPozitif = r.parametreler.piyasaReelPrimi > 0;
        for (var i = 1; i < sirali.length; i++) {
          final yuksek = r.parametreler.sektorDrifti(sirali[i].beta);
          final dusuk = r.parametreler.sektorDrifti(sirali[i - 1].beta);
          expect(
            primPozitif ? yuksek > dusuk : yuksek < dusuk,
            isTrue,
            reason: '${r.id}: beta ${sirali[i].beta} vs ${sirali[i - 1].beta}',
          );
        }
      }
    });

    test('beta enflasyon üstü getiriye uygulanır, nominale değil', () {
      for (final r in Rejim.values) {
        // Beta 0 olan kurgusal bir sektör tam enflasyon kadar getirir.
        expect(
          r.parametreler.sektorDrifti(0),
          closeTo(r.parametreler.aylikEnflasyon, 1e-12),
          reason: r.id,
        );
        expect(
          r.parametreler.sektorDrifti(1),
          closeTo(r.parametreler.piyasaDrift, 1e-12),
          reason: r.id,
        );
      }
    });

    test('krizde borsanın reel primi negatif, büyümede pozitif', () {
      expect(Rejim.kriz.parametreler.piyasaReelPrimi, lessThan(-0.05));
      expect(Rejim.buyume.parametreler.piyasaReelPrimi, greaterThan(0.03));
    });

    test('kripto her rejimde en oynak varlık', () {
      for (final r in Rejim.values) {
        final enOynak = motor.varliklar.reduce(
          (a, b) => a.parametre(r).oynaklik > b.parametre(r).oynaklik ? a : b,
        );
        expect(enOynak.id, 'kripto', reason: r.id);
      }
    });
  });

  group('Determinizm ve sayısal sağlık', () {
    test('aynı tohum aynı fiyat serisini üretir', () {
      List<double> seri(int tohum) {
        final kaynak = RastgeleKaynak(tohum);
        var d = motor.baslangic();
        final f = <double>[];
        for (var tur = 1; tur <= 120; tur++) {
          d = motor.turIsle(d, kaynak.akis('piyasa', tur: tur));
          f.add(d.fiyat('hisse_sanayi'));
        }
        return f;
      }

      expect(seri(555), seri(555));
      expect(seri(555), isNot(seri(556)));
    });

    test('40 yıl boyunca fiyatlar pozitif ve sonlu kalır', () {
      for (var tohum = 0; tohum < 15; tohum++) {
        final kaynak = RastgeleKaynak(tohum);
        var d = motor.baslangic();
        for (var tur = 1; tur <= 480; tur++) {
          d = motor.turIsle(d, kaynak.akis('piyasa', tur: tur));
          for (final v in motor.varliklar) {
            final f = d.fiyat(v.id);
            expect(f.isFinite, isTrue, reason: '${v.id} tur $tur');
            expect(f, greaterThan(0), reason: '${v.id} tur $tur');
          }
        }
      }
    });

    test('tek turluk getiri iki yönlü de sınırlı', () {
      for (var tohum = 0; tohum < 10; tohum++) {
        final kaynak = RastgeleKaynak(tohum);
        var d = motor.baslangic();
        for (var tur = 1; tur <= 300; tur++) {
          final sonraki = motor.turIsle(d, kaynak.akis('piyasa', tur: tur));
          for (final v in motor.varliklar) {
            final getiri = sonraki.fiyat(v.id) / d.fiyat(v.id) - 1;
            expect(
              getiri,
              inInclusiveRange(
                PiyasaSimulatoru.enAzTurGetirisi - 1e-9,
                PiyasaSimulatoru.enCokTurGetirisi + 1e-9,
              ),
              reason: v.id,
            );
          }
          d = sonraki;
        }
      }
    });

    test('kayıt round-trip fiyatları korur', () {
      final kaynak = RastgeleKaynak(31);
      var d = motor.baslangic();
      for (var tur = 1; tur <= 30; tur++) {
        d = motor.turIsle(d, kaynak.akis('piyasa', tur: tur));
      }
      final geri = PiyasaDurumu.fromJson(d.toJson());
      expect(geri.fiyatlar, d.fiyatlar);
    });
  });

  group('Getiri tablodaki drift ile uyumlu', () {
    test('her rejimde bileşik getiri drift değerine yakın', () {
      for (final rejim in Rejim.values) {
        final getiriler = rejimGetirileri(rejim, 4000);
        for (final v in motor.varliklar) {
          final beklenen = v.parametre(rejim).drift;
          // Tablo BİLEŞİK getiri tanımlıyor; ölçüm de logaritmik olmalı.
          final olculen = ortalama(
            getiriler[v.id]!.map((g) => math.log(1 + g)).toList(),
          );
          final tolerans = 0.002 + v.parametre(rejim).oynaklik * 0.1;
          expect(
            olculen,
            closeTo(beklenen, tolerans),
            reason: '${v.id}/${rejim.id}: beklenen $beklenen, ölçülen $olculen',
          );
        }
      }
    });
  });

  group('Kriz davranışı', () {
    final kriz = rejimGetirileri(Rejim.kriz, 4000);

    test('altın ve döviz krizde kazandırır, hisseler kaybettirir', () {
      expect(ortalama(kriz['altin']!), greaterThan(0.02));
      expect(ortalama(kriz['doviz']!), greaterThan(0.02));
      for (final s in hisseSektorleri) {
        expect(ortalama(kriz[s.id]!), lessThan(0), reason: s.id);
      }
    });

    test('gıda sektörü krizde bankacılıktan az kaybeder', () {
      expect(
        ortalama(kriz['hisse_gida']!),
        greaterThan(ortalama(kriz['hisse_bankacilik']!)),
      );
      expect(
        standartSapma(kriz['hisse_gida']!),
        lessThan(standartSapma(kriz['hisse_insaat']!)),
      );
    });

    test('krizde hisse sektörleri birlikte düşer (ortak şok çalışıyor)', () {
      final k = korelasyon(kriz['hisse_bankacilik']!, kriz['hisse_sanayi']!);
      expect(k, greaterThan(0.3), reason: 'sektörler bağımsız hareket ediyor');
    });

    test('altın ve döviz kur şokunu paylaşır', () {
      expect(korelasyon(kriz['altin']!, kriz['doviz']!), greaterThan(0.3));
    });

    test('mevduat krizden etkilenmez', () {
      expect(standartSapma(kriz['mevduat']!), lessThan(0.005));
    });

    test('gayrimenkul krizde hisseden çok daha az sarsılır', () {
      expect(
        standartSapma(kriz['gayrimenkul']!),
        lessThan(standartSapma(kriz['hisse_sanayi']!) / 3),
      );
    });
  });

  group('Uzun vade reel getiri sıralaması', () {
    final sonuc = uzunVade(40, 480);
    final enflasyon = sonuc.aylikEnflasyon;
    double reel(String id) =>
        (1 + sonuc.aylikGetiri[id]!) / (1 + enflasyon) - 1;

    test('nakit ve mevduat reel olarak kaybettirir', () {
      expect(reel('mevduat'), lessThan(0));
      // Nakit hiç getiri üretmez; enflasyon kadar kaybeder.
      expect(1 / (1 + enflasyon) - 1, lessThan(reel('mevduat')));
    });

    test('gayrimenkul ve hisse reel olarak kazandırır', () {
      final kira = motor.varliklar
          .firstWhere((v) => v.id == 'gayrimenkul')
          .aylikGetiriOrani;
      expect(reel('gayrimenkul') + kira, greaterThan(0));
      expect(reel('hisse_sanayi'), greaterThan(0));
      expect(reel('hisse_bankacilik'), greaterThan(reel('hisse_sanayi')));
    });

    test('altın ve döviz enflasyon korumasıdır, servet kaynağı değil', () {
      expect(reel('altin'), greaterThan(reel('mevduat')));
      expect(reel('altin'), lessThan(reel('hisse_bankacilik')));
      expect(reel('doviz'), inInclusiveRange(-0.004, 0.004));
    });

    test('yüksek betalı sektör düşük betalıdan belirgin fazla kazandırır', () {
      // Komşu betalar arasındaki fark ölçüm gürültüsünün altında kalır;
      // uçlar arasında anlamlı fark aranıyor. Kesin sıralama tablo
      // seviyesinde ayrıca test ediliyor.
      final sirali = [...hisseSektorleri]..sort((a, b) => a.beta.compareTo(b.beta));
      expect(reel(sirali.last.id), greaterThan(reel(sirali.first.id) + 0.001));
    });

    test('defansif sektör bile enflasyonu yener, ama az', () {
      final gida = reel('hisse_gida');
      expect(gida, greaterThan(0), reason: 'defansif sektör oynanamaz hale gelmiş');
      expect(gida, lessThan(reel('hisse_insaat')));
    });

    test('borsa primi makul bandda (buy-and-hold oyunu bitirmemeli)', () {
      // Yıllık reel getiri; aylıktan yıllığa: (1+r)^12 - 1
      double yillik(String id) => math.pow(1 + reel(id), 12) - 1;
      expect(
        yillik('hisse_sanayi'),
        inInclusiveRange(0.03, 0.09),
        reason: 'borsa reel primi ${yillik('hisse_sanayi')}',
      );
    });

    test('gayrimenkul kira ile birlikte borsaya rakip', () {
      final kira = motor.varliklar
          .firstWhere((v) => v.id == 'gayrimenkul')
          .aylikGetiriOrani;
      final ev = reel('gayrimenkul') + kira;
      expect(ev, greaterThan(reel('hisse_gida')));
      expect(ev, lessThan(reel('hisse_insaat') + 0.002));
    });

    test('arsa yavaş kanar; değeri imar olayından gelir', () {
      expect(reel('arsa'), lessThan(0));
      expect(reel('arsa'), greaterThan(reel('mevduat')));
    });

    test('hiçbir varlık her eksende üstün değil', () {
      // En yüksek reel getirili varlık aynı zamanda en düşük oynaklıkta
      // olmamalı; yoksa portföy kararı diye bir şey kalmaz.
      final adaylar = motor.varliklar.map((v) => v.id).toList();
      final enKazancli =
          adaylar.reduce((a, b) => reel(a) > reel(b) ? a : b);
      final krizGetirileri = rejimGetirileri(Rejim.kriz, 1500);
      final enGuvenli = adaylar.reduce(
        (a, b) => standartSapma(krizGetirileri[a]!) <
                standartSapma(krizGetirileri[b]!)
            ? a
            : b,
      );
      expect(enKazancli, isNot(enGuvenli));
    });
  });

  group('Olay müdahalesi', () {
    test('imar haberi arsa fiyatını çarpar, diğerlerini bozmaz', () {
      final oncesi = motor.baslangic();
      final sonrasi = oncesi.fiyatiCarp('arsa', 6.0);
      expect(sonrasi.fiyat('arsa'), oncesi.fiyat('arsa') * 6);
      expect(sonrasi.fiyat('altin'), oncesi.fiyat('altin'));
    });

    test('tanımsız varlık için durum değişmez', () {
      final d = motor.baslangic();
      expect(d.fiyatiCarp('yok_boyle_bir_sey', 2), d);
      expect(d.fiyat('yok_boyle_bir_sey'), 0);
    });
  });
}
