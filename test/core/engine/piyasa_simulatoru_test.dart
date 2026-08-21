import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/piyasa_simulatoru.dart';
import 'package:hayat_kariyer/core/engine/rejim.dart';
import 'package:hayat_kariyer/core/models/piyasa_durumu.dart';
import 'package:hayat_kariyer/core/rng/rng.dart';

/// Bir oyunu baştan sona simüle eder ve her turun durumunu döndürür.
List<PiyasaDurumu> simulasyon(int tohum, int turSayisi, {Rejim? baslangic}) {
  final motor = PiyasaSimulatoru();
  final kaynak = RastgeleKaynak(tohum);
  var durum = motor.baslangic(rejim: baslangic ?? Rejim.buyume);
  final gecmis = <PiyasaDurumu>[durum];
  for (var tur = 1; tur <= turSayisi; tur++) {
    durum = motor.turIsle(durum, kaynak.akis('piyasa', tur: tur));
    gecmis.add(durum);
  }
  return gecmis;
}

void main() {
  group('Rejim tablosu tutarlılığı', () {
    test('her rejimin geçiş ağırlıkları toplamı 1', () {
      for (final r in Rejim.values) {
        final toplam = r.parametreler.gecisAgirliklari.values
            .fold<double>(0, (a, b) => a + b);
        expect(toplam, closeTo(1.0, 1e-9), reason: r.id);
      }
    });

    test('rejim kendine geçemez', () {
      for (final r in Rejim.values) {
        expect(r.parametreler.gecisAgirliklari.containsKey(r), isFalse);
      }
    });

    test('her rejim her rejimden erişilebilir', () {
      for (final hedef in Rejim.values) {
        final erisenler = Rejim.values.where(
          (r) => r.parametreler.gecisAgirliklari.containsKey(hedef),
        );
        expect(erisenler, isNotEmpty, reason: '${hedef.id} çıkmaz sokakta');
      }
    });

    test('kriz en yüksek oynaklığa, durgunluk en düşük drift\'e sahip', () {
      final oynakliklar = {
        for (final r in Rejim.values) r: r.parametreler.piyasaOynakligi,
      };
      expect(
        oynakliklar.entries.reduce((a, b) => a.value > b.value ? a : b).key,
        Rejim.kriz,
      );
      expect(Rejim.kriz.parametreler.piyasaDrift, lessThan(0));
      expect(Rejim.buyume.parametreler.piyasaDrift, greaterThan(0));
    });

    test('enflasyon rejimi en yüksek fiyat artışını üretir', () {
      final enYuksek = Rejim.values
          .reduce(
            (a, b) => a.parametreler.aylikEnflasyon >
                    b.parametreler.aylikEnflasyon
                ? a
                : b,
          );
      expect(enYuksek, Rejim.enflasyon);
    });

    test('kimlikler benzersiz ve geri bulunabilir', () {
      expect(Rejim.bul('kriz'), Rejim.kriz);
      expect(Rejim.bul('yok'), isNull);
      expect(
        Rejim.values.map((r) => r.id).toSet(),
        hasLength(Rejim.values.length),
      );
    });
  });

  group('Determinizm', () {
    test('aynı tohum aynı ekonomiyi üretir', () {
      final a = simulasyon(20260821, 200);
      final b = simulasyon(20260821, 200);
      expect(
        a.map((d) => '${d.rejim.id}:${d.enflasyonEndeksi}'),
        b.map((d) => '${d.rejim.id}:${d.enflasyonEndeksi}'),
      );
    });

    test('farklı tohum farklı ekonomi üretir', () {
      final a = simulasyon(1, 200);
      final b = simulasyon(2, 200);
      expect(
        a.map((d) => d.rejim).toList(),
        isNot(b.map((d) => d.rejim).toList()),
      );
    });
  });

  group('Rejim geçişleri', () {
    test('asgari süre dolmadan rejim değişmez', () {
      for (var tohum = 0; tohum < 40; tohum++) {
        final gecmis = simulasyon(tohum, 60);
        var suren = 0;
        for (var i = 1; i < gecmis.length; i++) {
          if (gecmis[i].rejim != gecmis[i - 1].rejim) {
            expect(
              suren,
              greaterThanOrEqualTo(rejimEnAzSure),
              reason: 'tohum $tohum, tur $i: rejim $suren turda değişti',
            );
            suren = 1;
          } else {
            suren++;
          }
        }
      }
    });

    test('rejimSuresi sayacı doğru ilerler', () {
      final gecmis = simulasyon(7, 80);
      for (var i = 1; i < gecmis.length; i++) {
        if (gecmis[i].rejim == gecmis[i - 1].rejim) {
          expect(gecmis[i].rejimSuresi, gecmis[i - 1].rejimSuresi + 1);
        } else {
          expect(gecmis[i].rejimSuresi, 1);
        }
      }
    });

    test('ortalama rejim ömrü 8-12 tur bandında', () {
      final omurler = <int>[];
      for (var tohum = 0; tohum < 60; tohum++) {
        final gecmis = simulasyon(tohum, 600);
        var suren = 1;
        for (var i = 1; i < gecmis.length; i++) {
          if (gecmis[i].rejim != gecmis[i - 1].rejim) {
            omurler.add(suren);
            suren = 1;
          } else {
            suren++;
          }
        }
      }
      expect(omurler.length, greaterThan(1000), reason: 'örneklem küçük');
      final ortalama = omurler.reduce((a, b) => a + b) / omurler.length;
      expect(ortalama, inInclusiveRange(8, 12), reason: 'ortalama $ortalama');
    });

    test('uzun vadede dört rejim de görülür', () {
      final gorulen = simulasyon(99, 600).map((d) => d.rejim).toSet();
      expect(gorulen, containsAll(Rejim.values));
    });
  });

  group('Enflasyon', () {
    test('endeks her tur artar, nakit tutmak cezalandırılır', () {
      final gecmis = simulasyon(3, 480);
      for (var i = 1; i < gecmis.length; i++) {
        expect(
          gecmis[i].enflasyonEndeksi,
          greaterThan(gecmis[i - 1].enflasyonEndeksi * 0.999),
        );
      }
      expect(gecmis.last.enflasyonEndeksi, greaterThan(gecmis.first.enflasyonEndeksi));
    });

    test('aylık enflasyon alt sınırın altına inmez', () {
      for (var tohum = 0; tohum < 30; tohum++) {
        for (final d in simulasyon(tohum, 300).skip(1)) {
          expect(
            d.sonAylikEnflasyon,
            greaterThanOrEqualTo(PiyasaSimulatoru.enAzAylikEnflasyon),
          );
        }
      }
    });

    test('kriz ve enflasyon rejimlerinde fiyat artışı daha hızlı', () {
      final toplam = <Rejim, double>{for (final r in Rejim.values) r: 0};
      final adet = <Rejim, int>{for (final r in Rejim.values) r: 0};
      for (var tohum = 0; tohum < 30; tohum++) {
        for (final d in simulasyon(tohum, 600).skip(1)) {
          toplam[d.rejim] = toplam[d.rejim]! + d.sonAylikEnflasyon;
          adet[d.rejim] = adet[d.rejim]! + 1;
        }
      }
      final ortalama = {
        for (final r in Rejim.values) r: toplam[r]! / adet[r]!,
      };
      expect(ortalama[Rejim.enflasyon]!, greaterThan(ortalama[Rejim.kriz]!));
      expect(ortalama[Rejim.kriz]!, greaterThan(ortalama[Rejim.buyume]!));
      expect(ortalama[Rejim.buyume]!, greaterThan(ortalama[Rejim.durgunluk]!));
      for (final r in Rejim.values) {
        expect(
          ortalama[r]!,
          closeTo(r.parametreler.aylikEnflasyon, 0.002),
          reason: '${r.id} beklenen ortalamadan sapıyor',
        );
      }
    });

    test('40 yıllık oyunda endeks sayısal olarak sağlıklı kalır', () {
      for (var tohum = 0; tohum < 20; tohum++) {
        final son = simulasyon(tohum, 480).last;
        expect(son.enflasyonEndeksi.isFinite, isTrue);
        expect(son.enflasyonEndeksi, greaterThan(1));
        // Bant geniş tutuldu; amaç sayısal patlamayı ve tablo değişikliğini
        // fark etmek, dar bir dengeyi kilitlemek değil.
        expect(
          son.enflasyonEndeksi,
          inInclusiveRange(1e3, 1e6),
          reason: 'tohum $tohum: 40 yılda ${son.enflasyonEndeksi}x',
        );
      }
    });
  });

  group('Para reformu (sıfır atma)', () {
    test('eşiğe gelmeden reform olmaz', () {
      for (final d in simulasyon(5, 100)) {
        expect(d.paraReformuSayisi, 0);
        expect(d.paraReformuYapildi, isFalse);
      }
    });

    test('uzun oyunda reform tetiklenir ve gösterim endeksi düşer', () {
      final gecmis = simulasyon(5, 480);
      final reformTuru = gecmis.indexWhere((d) => d.paraReformuYapildi);
      expect(reformTuru, greaterThan(0), reason: '40 yılda reform beklenirdi');

      final oncesi = gecmis[reformTuru - 1];
      final sonrasi = gecmis[reformTuru];
      expect(oncesi.gosterimEndeksi, greaterThan(500));
      expect(sonrasi.gosterimEndeksi, lessThan(2));
      // Ham endeks bozulmaz; reform yalnızca gösterim ölçeğidir.
      expect(
        sonrasi.enflasyonEndeksi,
        greaterThan(oncesi.enflasyonEndeksi),
      );
    });

    test('reform bayrağı yalnızca o tur açık kalır', () {
      final gecmis = simulasyon(5, 480);
      final reformTuru = gecmis.indexWhere((d) => d.paraReformuYapildi);
      expect(gecmis[reformTuru + 1].paraReformuYapildi, isFalse);
      expect(gecmis[reformTuru + 1].paraReformuSayisi, 1);
    });

    test('gösterim endeksi hiçbir turda eşiği aşılı kalmaz', () {
      for (var tohum = 0; tohum < 25; tohum++) {
        for (final d in simulasyon(tohum, 480)) {
          expect(
            d.gosterimEndeksi,
            lessThanOrEqualTo(paraReformuEsigi * 1.1),
            reason: 'tohum $tohum: rakamlar okunamaz büyüklükte kaldı',
          );
        }
      }
    });

    test('reform sonrası maaş okunabilir büyüklükte kalır', () {
      // 38.000 TL taban maaşlı memur, 40 yıl sonra.
      for (var tohum = 0; tohum < 25; tohum++) {
        final son = simulasyon(tohum, 480).last;
        final gosterilen = son.gosterimTutari(son.endeksle(38000));
        expect(
          gosterilen,
          lessThan(1e9),
          reason: 'tohum $tohum: ekranda ${gosterilen.toStringAsFixed(0)} TL',
        );
      }
    });

    test('reform gösterim tutarını böler', () {
      const oncesi = PiyasaDurumu(enflasyonEndeksi: 1000);
      const sonrasi = PiyasaDurumu(
        enflasyonEndeksi: 1000,
        paraReformuSayisi: 1,
      );
      expect(oncesi.gosterimTutari(5000000), 5000000);
      expect(sonrasi.gosterimTutari(5000000), 5000);
      expect(sonrasi.paraOlcegi, 1000);
    });
  });

  group('Endeksleme', () {
    test('taban tutar nominale çevrilir', () {
      const durum = PiyasaDurumu(enflasyonEndeksi: 2.5);
      expect(durum.endeksle(40000), 100000);
      expect(durum.reeleCevir(100000), 40000);
    });

    test('endeks 1 iken tutar değişmez', () {
      const durum = PiyasaDurumu();
      expect(durum.endeksle(38000), 38000);
      expect(durum.reeleCevir(38000), 38000);
    });

    test('yıllık enflasyon aylıktan türetilir', () {
      const durum = PiyasaDurumu(sonAylikEnflasyon: 0.03);
      expect(durum.yillikEnflasyon, closeTo(0.4258, 0.001));
    });
  });

  group('Kayıt', () {
    test('piyasa durumu round-trip edilir', () {
      final durum = simulasyon(11, 50).last;
      final geri = PiyasaDurumu.fromJson(
        jsonDecode(jsonEncode(durum.toJson())) as Map<String, dynamic>,
      );
      expect(geri, durum);
    });

    test('kayıttan devam eden oyun aynı geleceği üretir', () {
      final motor = PiyasaSimulatoru();
      final kaynak = RastgeleKaynak(4242);

      var kesintisiz = motor.baslangic();
      for (var tur = 1; tur <= 40; tur++) {
        kesintisiz = motor.turIsle(kesintisiz, kaynak.akis('piyasa', tur: tur));
      }

      var kayitli = motor.baslangic();
      for (var tur = 1; tur <= 20; tur++) {
        kayitli = motor.turIsle(kayitli, kaynak.akis('piyasa', tur: tur));
      }
      // Kaydet -> yükle
      kayitli = PiyasaDurumu.fromJson(
        jsonDecode(jsonEncode(kayitli.toJson())) as Map<String, dynamic>,
      );
      for (var tur = 21; tur <= 40; tur++) {
        kayitli = motor.turIsle(kayitli, kaynak.akis('piyasa', tur: tur));
      }

      expect(kayitli, kesintisiz);
    });
  });
}
