import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/piyasa_simulatoru.dart';
import 'package:hayat_kariyer/core/engine/portfoy_motoru.dart';
import 'package:hayat_kariyer/core/models/piyasa_durumu.dart';
import 'package:hayat_kariyer/core/models/portfoy.dart';
import 'package:hayat_kariyer/core/models/varlik.dart';

void main() {
  final motor = PortfoyMotoru();
  final piyasa = PiyasaSimulatoru().baslangic();

  VarlikTanimi tanim(String id) =>
      piyasaVarliklari.firstWhere((v) => v.id == id);

  double fiyat(String id) => piyasa.fiyat(id);

  ({Portfoy portfoy, int nakitDegisimi, List<EmirSonucu> sonuclar}) isle(
    List<Emir> emirler, {
    Portfoy? portfoy,
    int nakit = 10000000,
    PiyasaDurumu? p,
  }) =>
      motor.emirleriIsle(
        portfoy ?? const Portfoy(),
        nakit,
        p ?? piyasa,
        emirler,
      );

  group('Alım', () {
    test('nakit düşer, pozisyon açılır, komisyon alınır', () {
      final altinFiyati = fiyat('altin');
      final sonuc = isle([const Alim('altin', 100)]);
      final beklenenKomisyon = 100 * altinFiyati * tanim('altin').islemMaliyeti;

      expect(sonuc.sonuclar.single.basarili, isTrue);
      expect(sonuc.portfoy.adet('altin'), 100);
      expect(
        sonuc.nakitDegisimi,
        -(100 * altinFiyati + beklenenKomisyon).round(),
      );
      expect(sonuc.sonuclar.single.komisyon, beklenenKomisyon.round());
    });

    test('ortalama maliyet komisyon dahil hesaplanır', () {
      final sonuc = isle([const Alim('altin', 10)]);
      final p = sonuc.portfoy.pozisyonlar['altin']!;
      expect(
        p.ortalamaMaliyet,
        greaterThan(fiyat('altin')),
        reason: 'komisyon maliyete binmeli',
      );
      // Alır almaz satarsan komisyon kadar zarardasın.
      expect(p.karZarar(fiyat('altin')), lessThan(0));
    });

    test('iki alım ortalama maliyeti harmanlar', () {
      var sonuc = isle([const Alim('hisse_sanayi', 100)]);
      final pahaliPiyasa = piyasa.copyWith(
        fiyatlar: {...piyasa.fiyatlar, 'hisse_sanayi': fiyat('hisse_sanayi') * 2},
      );
      sonuc = motor.emirleriIsle(
        sonuc.portfoy,
        10000000,
        pahaliPiyasa,
        [const Alim('hisse_sanayi', 100)],
      );
      final p = sonuc.portfoy.pozisyonlar['hisse_sanayi']!;
      expect(p.adet, 200);
      expect(
        p.ortalamaMaliyet,
        closeTo(fiyat('hisse_sanayi') * 1.5 * 1.002, 1),
      );
    });

    test('yetersiz nakitte emir reddedilir, portföy bozulmaz', () {
      final sonuc = isle([const Alim('gayrimenkul', 1)], nakit: 1000);
      expect(sonuc.sonuclar.single.hata, EmirHatasi.yetersizNakit);
      expect(sonuc.portfoy.bosMu, isTrue);
      expect(sonuc.nakitDegisimi, 0);
    });

    test('bölünemez varlık kesirli alınamaz', () {
      expect(
        isle([const Alim('gayrimenkul', 0.5)]).sonuclar.single.hata,
        EmirHatasi.bolunemez,
      );
      expect(
        isle([const Alim('altin', 12.5)]).sonuclar.single.basarili,
        isTrue,
        reason: 'altın gram gram alınır',
      );
    });

    test('tanımsız varlık ve geçersiz adet reddedilir', () {
      expect(
        isle([const Alim('bitcoin_maks', 1)]).sonuclar.single.hata,
        EmirHatasi.tanimsizVarlik,
      );
      expect(
        isle([const Alim('altin', 0)]).sonuclar.single.hata,
        EmirHatasi.gecersizAdet,
      );
      expect(
        isle([const Alim('altin', -5)]).sonuclar.single.hata,
        EmirHatasi.gecersizAdet,
      );
    });

    test('bir emrin reddi sonrakileri engellemez', () {
      final sonuc = isle([
        const Alim('yok_boyle', 1),
        const Alim('altin', 10),
      ]);
      expect(sonuc.sonuclar.first.basarili, isFalse);
      expect(sonuc.sonuclar.last.basarili, isTrue);
      expect(sonuc.portfoy.adet('altin'), 10);
    });
  });

  group('Likit satım', () {
    test('anında gerçekleşir, komisyon düşülür', () {
      final alindi = isle([const Alim('altin', 100)]).portfoy;
      final sonuc = isle([const Satim('altin', 40)], portfoy: alindi);
      final brut = 40 * fiyat('altin');
      expect(sonuc.portfoy.adet('altin'), 60);
      expect(
        sonuc.nakitDegisimi,
        (brut - brut * tanim('altin').islemMaliyeti).round(),
      );
    });

    test('tamamı satılınca pozisyon kapanır', () {
      final alindi = isle([const Alim('altin', 100)]).portfoy;
      final sonuc = isle([const Satim('altin', 100)], portfoy: alindi);
      expect(sonuc.portfoy.pozisyonlar.containsKey('altin'), isFalse);
    });

    test('elde olmayanı satmak reddedilir', () {
      final alindi = isle([const Alim('altin', 10)]).portfoy;
      expect(
        isle([const Satim('altin', 11)], portfoy: alindi).sonuclar.single.hata,
        EmirHatasi.yetersizVarlik,
      );
    });

    test('al-sat turu komisyon yüzünden zarardır', () {
      final baslangic = 10000000;
      final alim = isle([const Alim('altin', 100)], nakit: baslangic);
      final satim = motor.emirleriIsle(
        alim.portfoy,
        baslangic + alim.nakitDegisimi,
        piyasa,
        [const Satim('altin', 100)],
      );
      final sonNakit =
          baslangic + alim.nakitDegisimi + satim.nakitDegisimi;
      expect(sonNakit, lessThan(baslangic));
    });
  });

  group('Gecikmeli satış', () {
    test('gayrimenkul satışı kuyruğa girer, nakit hemen gelmez', () {
      final alindi = isle([const Alim('gayrimenkul', 1)]).portfoy;
      final sonuc = isle([const Satim('gayrimenkul', 1)], portfoy: alindi);

      expect(sonuc.sonuclar.single.satisaCikarildi, isTrue);
      expect(sonuc.nakitDegisimi, 0);
      expect(sonuc.portfoy.adet('gayrimenkul'), 1, reason: 'tapu hâlâ sende');
      expect(sonuc.portfoy.satilabilirAdet('gayrimenkul'), 0);
      expect(sonuc.portfoy.bekleyenSatislar.single.kalanTur, 3);
    });

    test('aynı daire iki kez satılamaz', () {
      final alindi = isle([const Alim('gayrimenkul', 1)]).portfoy;
      final satista = isle([const Satim('gayrimenkul', 1)], portfoy: alindi);
      expect(
        isle([const Satim('gayrimenkul', 1)], portfoy: satista.portfoy)
            .sonuclar
            .single
            .hata,
        EmirHatasi.yetersizVarlik,
      );
    });

    test('üç tur sonra kapanır ve nakit gelir', () {
      var p = isle([const Alim('arsa', 1)]).portfoy;
      p = isle([const Satim('arsa', 1)], portfoy: p).portfoy;

      var tamamlanan = <TamamlananSatis>[];
      for (var i = 0; i < 3; i++) {
        final sonuc = motor.turIsle(p, piyasa);
        p = sonuc.portfoy;
        tamamlanan = sonuc.satislar;
        if (i < 2) {
          expect(tamamlanan, isEmpty, reason: '${i + 1}. turda kapanmamalı');
          expect(p.adet('arsa'), 1);
        }
      }
      expect(tamamlanan, hasLength(1));
      expect(p.adet('arsa'), 0);
      expect(p.bekleyenSatislar, isEmpty);
      expect(tamamlanan.single.tutar, greaterThan(0));
    });

    test('fiyat riski satıcıda kalır: beklerken piyasa çökerse az alırsın', () {
      var p = isle([const Alim('gayrimenkul', 1)]).portfoy;
      p = isle([const Satim('gayrimenkul', 1)], portfoy: p).portfoy;

      final cokmus = piyasa.copyWith(
        fiyatlar: {
          ...piyasa.fiyatlar,
          'gayrimenkul': fiyat('gayrimenkul') * 0.6,
        },
      );

      var normalP = p;
      var cokmusP = p;
      var normalTutar = 0;
      var cokmusTutar = 0;
      for (var i = 0; i < 3; i++) {
        final a = motor.turIsle(normalP, piyasa);
        final b = motor.turIsle(cokmusP, cokmus);
        normalP = a.portfoy;
        cokmusP = b.portfoy;
        if (a.satislar.isNotEmpty) normalTutar = a.satislar.single.tutar;
        if (b.satislar.isNotEmpty) cokmusTutar = b.satislar.single.tutar;
      }
      expect(cokmusTutar, lessThan(normalTutar));
      expect(cokmusTutar / normalTutar, closeTo(0.6, 0.01));
    });
  });

  group('Kira geliri', () {
    test('gayrimenkul kira üretir, arsa üretmez', () {
      final ev = isle([const Alim('gayrimenkul', 2)]).portfoy;
      final arsa = isle([const Alim('arsa', 2)]).portfoy;
      expect(
        motor.turIsle(ev, piyasa).kiraGeliri,
        (2 * fiyat('gayrimenkul') * tanim('gayrimenkul').aylikGetiriOrani)
            .round(),
      );
      expect(motor.turIsle(arsa, piyasa).kiraGeliri, 0);
    });

    test('satışta bekleyen daire de kira üretmeye devam eder', () {
      var p = isle([const Alim('gayrimenkul', 1)]).portfoy;
      p = isle([const Satim('gayrimenkul', 1)], portfoy: p).portfoy;
      expect(motor.turIsle(p, piyasa).kiraGeliri, greaterThan(0));
    });

    test('hisse ve altın kira üretmez', () {
      final p = isle([
        const Alim('hisse_sanayi', 100),
        const Alim('altin', 100),
      ]).portfoy;
      expect(motor.turIsle(p, piyasa).kiraGeliri, 0);
    });
  });

  group('Portföy modeli', () {
    test('piyasa değeri fiyatlarla çarpılır', () {
      final p = isle([
        const Alim('altin', 100),
        const Alim('hisse_sanayi', 50),
      ]).portfoy;
      expect(
        p.piyasaDegeri(piyasa.fiyatlar),
        closeTo(100 * fiyat('altin') + 50 * fiyat('hisse_sanayi'), 1),
      );
    });

    test('JSON round-trip', () {
      var p = isle([const Alim('gayrimenkul', 1)]).portfoy;
      p = isle([const Satim('gayrimenkul', 1)], portfoy: p).portfoy;
      final geri = Portfoy.fromJson(
        jsonDecode(jsonEncode(p.toJson())) as Map<String, dynamic>,
      );
      expect(geri, p);
    });

    test('duzelt bozuk pozisyonları temizler', () {
      const bozuk = Portfoy(
        pozisyonlar: {
          'altin': Pozisyon(adet: 0, ortalamaMaliyet: 100),
          'arsa': Pozisyon(adet: 2, ortalamaMaliyet: -5),
        },
        bekleyenSatislar: [
          BekleyenSatis(varlikId: 'arsa', adet: 0, kalanTur: 2),
          BekleyenSatis(varlikId: 'arsa', adet: 1, kalanTur: -4),
        ],
      );
      final d = bozuk.duzelt();
      expect(d.pozisyonlar.containsKey('altin'), isFalse);
      expect(d.pozisyonlar['arsa']!.ortalamaMaliyet, 0);
      expect(d.bekleyenSatislar, hasLength(1));
      expect(d.bekleyenSatislar.single.kalanTur, 0);
    });
  });
}
