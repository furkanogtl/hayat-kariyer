import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/olay_motoru.dart';
import 'package:hayat_kariyer/core/engine/piyasa_simulatoru.dart';
import 'package:hayat_kariyer/core/engine/rejim.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/olay.dart';
import 'package:hayat_kariyer/core/models/olay_katalogu.dart';
import 'package:hayat_kariyer/core/models/oyun_durumu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/piyasa_durumu.dart';
import 'package:hayat_kariyer/core/models/portfoy.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/sektor.dart';
import 'package:hayat_kariyer/core/rng/rng.dart';

OlayKatalogu gercekKatalog() => OlayKatalogu.jsonMetinlerinden(
      Directory('assets/events')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .map((f) => f.readAsStringSync()),
    );

/// Testte kullanılan basit kartlar.
const _sadeKart = '''
{
  "id": "sade", "baslik": "Sade kart", "metin": "Bir şey oldu.",
  "tur": "hayat", "agirlik": 10,
  "secenekler": [
    { "etiket": "Kabul", "etkiler": { "nakit": -1000, "mutluluk": 2 } },
    { "etiket": "Ret", "etkiler": { "itibar": -1 } }
  ]
}
''';

const _dalliKart = '''
{
  "id": "dalli", "baslik": "Dallı kart", "metin": "Zar atılacak.",
  "tur": "hayat", "agirlik": 10,
  "secenekler": [
    {
      "etiket": "Dene",
      "etkiler": { "nakit": -5000 },
      "sonuclar": [
        { "sans": 0.5, "metin": "Tuttu.", "etkiler": { "nakit": 20000 } },
        { "sans": 0.5, "metin": "Tutmadı.", "etkiler": { "mutluluk": -5 } }
      ]
    }
  ]
}
''';

const _gecikmeliKart = '''
{
  "id": "gecikmeli", "baslik": "Gecikmeli", "metin": "Sonucu sonra belli olacak.",
  "tur": "teklif", "agirlik": 10,
  "secenekler": [
    {
      "etiket": "Yatır",
      "etkiler": { "nakit": -10000 },
      "gecikmeTuru": 3,
      "sonuclar": [
        { "sans": 0.5, "metin": "Kazandın.", "etkiler": { "nakit": 50000 } },
        { "sans": 0.5, "metin": "Battı.", "etkiler": { "mutluluk": -8 } }
      ]
    }
  ]
}
''';

const _firsatKart = '''
{
  "id": "firsat_x", "baslik": "Fırsat", "metin": "Kapı açıldı.",
  "tur": "firsat", "agirlik": 10,
  "secenekler": [{ "etiket": "Al", "etkiler": { "nakit": 1000 } }]
}
''';

const _kosulluKart = '''
{
  "id": "kosullu", "baslik": "Koşullu", "metin": "Sadece bazıları görür.",
  "tur": "hayat", "agirlik": 10,
  "kosullar": {
    "enAzItibar": 40, "yas": [30, 40], "sehirler": ["istanbul"],
    "durumlar": ["calisan"], "rejimler": ["kriz"], "cinsiyet": "kadin"
  },
  "secenekler": [{ "etiket": "Tamam", "etkiler": {} }]
}
''';

void main() {
  final piyasaMotoru = PiyasaSimulatoru();
  final piyasa = piyasaMotoru.baslangic();

  OyunDurumu durumKur({
    int nakit = 500000,
    int itibar = 20,
    int tur = 0,
    Sehir sehir = Sehir.konya,
    PiyasaDurumu? p,
  }) =>
      OyunDurumu(
        anaTohum: 1,
        oyuncu: Oyuncu.yeni(ad: 'Test', sehir: sehir).copyWith(
          nakit: nakit,
          itibar: itibar,
          tur: tur,
        ),
        piyasa: p ?? piyasa,
      );

  RastgeleAkis akis([int tohum = 7, int tur = 1]) =>
      RastgeleKaynak(tohum).akis('olay', tur: tur);

  OlayMotoru motorlu(String json) => OlayMotoru(
        katalog: OlayKatalogu.jsonMetinlerinden([json]),
      );

  group('Gerçek kart dosyaları', () {
    final katalog = gercekKatalog();

    test('tüm kartlar şemaya uygun', () {
      expect(katalog.dogrula(), isEmpty);
    });

    test('kartlar birden fazla dosyadan okunuyor', () {
      expect(katalog.uzunluk, greaterThanOrEqualTo(10));
      expect(katalog.turdeki(OlayTuru.firsat), isNotEmpty);
      expect(katalog.turdeki(OlayTuru.kriz), isNotEmpty);
      expect(katalog.turdeki(OlayTuru.hayat), isNotEmpty);
      expect(katalog.turdeki(OlayTuru.teklif), isNotEmpty);
    });

    test('metinler mobil için kısa', () {
      for (final o in katalog.tumu) {
        expect(o.metin.length, lessThanOrEqualTo(220), reason: o.id);
        expect(o.secenekler.length, inInclusiveRange(2, 4), reason: o.id);
      }
    });

    test('gecikmeli kararların sonuç dalı var', () {
      for (final o in katalog.tumu) {
        for (final s in o.secenekler.where((s) => s.gecikmeli)) {
          expect(s.sonuclar, isNotEmpty, reason: '${o.id}/${s.etiket}');
        }
      }
    });

    test('imar kartı arsayı çarpıyor (piyasa müdahale kapısı)', () {
      final imar = katalog.bul('imar_soylentisi_01')!;
      final dallar = imar.secenekler.first.sonuclar;
      expect(dallar.any((d) => d.etkiler.fiyatCarpani.containsKey('arsa')),
          isTrue);
    });
  });

  group('Koşullar', () {
    final motor = motorlu(_kosulluKart);

    test('şartları sağlamayan oyuncu kartı görmez', () {
      expect(motor.uygunKartlar(durumKur()), isEmpty);
    });

    test('tüm şartlar sağlanınca görünür', () {
      final uygun = OyunDurumu(
        anaTohum: 1,
        oyuncu: Oyuncu.yeni(
          ad: 'Ayşe',
          sehir: Sehir.istanbul,
          cinsiyet: Cinsiyet.kadin,
        ).copyWith(
          itibar: 45,
          tur: 12 * 14, // 32 yaş
          kariyer: const KariyerDurumu.calisan(meslekId: 'memur'),
        ),
        piyasa: piyasaMotoru.baslangic(rejim: Rejim.kriz),
      );
      expect(motor.uygunKartlar(uygun).single.id, 'kosullu');
    });

    test('nakit koşulu reel olarak karşılaştırılır', () {
      final kart = motorlu('''
        {"id":"z","baslik":"z","metin":"z","agirlik":5,
         "kosullar":{"enAzNakit":100000},
         "secenekler":[{"etiket":"a","etkiler":{}}]}
      ''');
      // Nominal 150.000 ama endeks 3 -> reel 50.000: yetmez.
      final enflasyonlu = durumKur(nakit: 150000).copyWith(
        piyasa: piyasa.copyWith(enflasyonEndeksi: 3),
      );
      expect(kart.uygunKartlar(enflasyonlu), isEmpty);
      expect(kart.uygunKartlar(durumKur(nakit: 150000)), hasLength(1));
    });
  });

  group('Kart çekme', () {
    test('deste en fazla üç kart içerir ve tekrar etmez', () {
      final motor = motorlu('[$_sadeKart,$_dalliKart,$_firsatKart]');
      for (var t = 1; t <= 200; t++) {
        final deste = motor.desteCek(durumKur(), akis(t, t));
        expect(deste.kartlar.length, lessThanOrEqualTo(3));
        expect(
          deste.kartlar.map((k) => k.id).toSet().length,
          deste.kartlar.length,
          reason: 'aynı kart destede iki kez',
        );
      }
    });

    test('turların çoğunda kart çıkmaz', () {
      // Oturum süresi hedefi: 480 turluk oyunda ~120 karar.
      final motor = motorlu(_sadeKart);
      const deneme = 3000;
      var kartli = 0;
      for (var t = 1; t <= deneme; t++) {
        // Motorun gerçek kullanımı: tek oyun tohumu, değişen tur.
        if (!motor.desteCek(durumKur(), akis(4242, t)).bosMu) kartli++;
      }
      expect(kartli / deneme, closeTo(0.25, 0.02));
    });

    test('itibarlı oyuncu fırsat kartlarını daha sık görür', () {
      // Havuzda çok sayıda sıradan kart olmalı; iki kartlık havuzda deste
      // zaten ikisini de alır ve ağırlık farkı görünmez.
      final sirdanlar = [
        for (var i = 0; i < 6; i++)
          '{"id":"sade_$i","baslik":"s","metin":"s","tur":"hayat",'
              '"agirlik":10,"secenekler":[{"etiket":"a","etkiler":{}}]}',
      ].join(',');
      final motor = motorlu('[$sirdanlar,$_firsatKart]');
      int firsatSayisi(int itibar) {
        var sayac = 0;
        for (var t = 1; t <= 400; t++) {
          final deste = motor.desteCek(durumKur(itibar: itibar), akis(t, t));
          sayac += deste.kartlar.where((k) => k.tur == OlayTuru.firsat).length;
        }
        return sayac;
      }

      final itibarsiz = firsatSayisi(0);
      final itibarli = firsatSayisi(100);
      expect(
        itibarli,
        greaterThan(itibarsiz * 2),
        reason: 'itibarsız $itibarsiz, itibarlı $itibarli',
      );
    });

    test('tek seferlik kart bir daha çıkmaz', () {
      final motor = motorlu('''
        {"id":"tek","baslik":"t","metin":"t","agirlik":10,"tekSeferlik":true,
         "secenekler":[{"etiket":"a","etkiler":{}}]}
      ''');
      final gorulmus = durumKur().copyWith(olayGecmisi: const {'tek': 0});
      expect(motor.uygunKartlar(gorulmus), isEmpty);
    });

    test('bekleme süresi dolmadan aynı kart çıkmaz', () {
      final motor = motorlu('''
        {"id":"bek","baslik":"b","metin":"b","agirlik":10,"bekleme":24,
         "secenekler":[{"etiket":"a","etkiler":{}}]}
      ''');
      final yeni = durumKur(tur: 20).copyWith(olayGecmisi: const {'bek': 0});
      expect(motor.uygunKartlar(yeni), isEmpty);
      final eski = durumKur(tur: 30).copyWith(olayGecmisi: const {'bek': 0});
      expect(motor.uygunKartlar(eski), hasLength(1));
    });

    test('aynı durum ve akış aynı desteyi verir', () {
      final motor = motorlu('[$_sadeKart,$_dalliKart,$_firsatKart]');
      final a = motor.desteCek(durumKur(), akis(5, 9));
      final b = motor.desteCek(durumKur(), akis(5, 9));
      expect(a.kartlar.map((k) => k.id), b.kartlar.map((k) => k.id));
    });
  });

  group('Seçim uygulama', () {
    test('anında etkiler uygulanır ve geçmişe yazılır', () {
      final motor = motorlu(_sadeKart);
      final olay = motor.katalog.bul('sade')!;
      final sonuc = motor.secimYap(durumKur(tur: 7), olay, 0, akis());

      expect(sonuc.durum.oyuncu.nakit, 500000 - 1000);
      expect(sonuc.durum.oyuncu.mutluluk, durumKur().oyuncu.mutluluk + 2);
      expect(sonuc.durum.olayGecmisi['sade'], 7);
      expect(sonuc.acilanSonuc, isNull);
    });

    test('para tutarları enflasyona endekslenir', () {
      final motor = motorlu(_sadeKart);
      final olay = motor.katalog.bul('sade')!;
      final enflasyonlu = durumKur().copyWith(
        piyasa: piyasa.copyWith(enflasyonEndeksi: 4),
      );
      final sonuc = motor.secimYap(enflasyonlu, olay, 0, akis());
      expect(sonuc.durum.oyuncu.nakit, 500000 - 4000);
    });

    test('dallanan seçenek hemen çözülür', () {
      final motor = motorlu(_dalliKart);
      final olay = motor.katalog.bul('dalli')!;
      final sonuc = motor.secimYap(durumKur(), olay, 0, akis());
      expect(sonuc.acilanSonuc, isNotNull);
      expect(sonuc.beklemeyeAlindi, isFalse);
      // Ya 20.000 kazandı ya mutluluk kaybetti; nakit her hâlükârda düştü.
      expect(sonuc.durum.oyuncu.nakit, isNot(500000));
    });

    test('iki dal da uzun vadede çıkar', () {
      final motor = motorlu(_dalliKart);
      final olay = motor.katalog.bul('dalli')!;
      final metinler = <String>{};
      for (var t = 1; t <= 60; t++) {
        metinler.add(
          motor.secimYap(durumKur(), olay, 0, akis(t, t)).acilanSonuc!.metin,
        );
      }
      expect(metinler, {'Tuttu.', 'Tutmadı.'});
    });

    test('geçersiz seçenek indeksi sınırlanır', () {
      final motor = motorlu(_sadeKart);
      final olay = motor.katalog.bul('sade')!;
      expect(
        () => motor.secimYap(durumKur(), olay, 99, akis()),
        returnsNormally,
      );
    });
  });

  group('Gecikmeli sonuçlar', () {
    final motor = motorlu(_gecikmeliKart);
    final olay = motor.katalog.bul('gecikmeli')!;

    test('seçim anında para gider, sonuç beklemeye alınır', () {
      final sonuc = motor.secimYap(durumKur(), olay, 0, akis());
      expect(sonuc.beklemeyeAlindi, isTrue);
      expect(sonuc.acilanSonuc, isNull);
      expect(sonuc.durum.oyuncu.nakit, 500000 - 10000);
      expect(sonuc.durum.bekleyenOlaylar.single.kalanTur, 3);
    });

    test('üç tur sonra açığa çıkar', () {
      var d = motor.secimYap(durumKur(), olay, 0, akis()).durum;
      var acilanlar = <AcigaCikanSonuc>[];
      for (var i = 1; i <= 3; i++) {
        final sonuc = motor.bekleyenleriIsle(d, akis(3, i));
        d = sonuc.durum;
        acilanlar = sonuc.sonuclar;
        if (i < 3) {
          expect(acilanlar, isEmpty, reason: '$i. turda açılmamalı');
          expect(d.bekleyenOlaylar, hasLength(1));
        }
      }
      expect(acilanlar, hasLength(1));
      expect(acilanlar.single.olay.id, 'gecikmeli');
      expect(d.bekleyenOlaylar, isEmpty);
    });

    test('sonuç zarı bekleme bitince atılır, seçim anında değil', () {
      // Aynı seçim, farklı bekleme akışı -> farklı sonuçlar çıkabilmeli.
      final secim = motor.secimYap(durumKur(), olay, 0, akis()).durum;
      final metinler = <String>{};
      for (var tohum = 1; tohum <= 40; tohum++) {
        var d = secim;
        for (var i = 1; i <= 3; i++) {
          final s = motor.bekleyenleriIsle(d, akis(tohum, i));
          d = s.durum;
          if (s.sonuclar.isNotEmpty) metinler.add(s.sonuclar.single.sonuc.metin);
        }
      }
      expect(metinler.length, 2);
    });

    test('bekleyen yoksa durum değişmez', () {
      final d = durumKur();
      final sonuc = motor.bekleyenleriIsle(d, akis());
      expect(sonuc.durum, d);
      expect(sonuc.sonuclar, isEmpty);
    });

    test('kayıt round-trip bekleyenleri korur', () {
      final d = motor.secimYap(durumKur(), olay, 0, akis()).durum;
      final geri = OyunDurumu.fromJson(
        jsonDecode(jsonEncode(d.toJson())) as Map<String, dynamic>,
      );
      expect(geri.bekleyenOlaylar, d.bekleyenOlaylar);
      expect(geri.olayGecmisi, d.olayGecmisi);
    });

    test('kayıttan silinmiş karta ait bekleyen sessizce düşer', () {
      final d = motor.secimYap(durumKur(), olay, 0, akis()).durum.copyWith(
            bekleyenOlaylar: const [
              BekleyenOlay(olayId: 'yok_boyle', secenekIndeksi: 0, kalanTur: 1),
            ],
          );
      final sonuc = motor.bekleyenleriIsle(d, akis());
      expect(sonuc.sonuclar, isEmpty);
      expect(sonuc.durum.bekleyenOlaylar, isEmpty);
    });
  });

  group('Etki türleri', () {
    test('fiyat çarpanı piyasaya işler', () {
      final motor = motorlu('''
        {"id":"imar","baslik":"i","metin":"i","agirlik":5,
         "secenekler":[{"etiket":"a","etkiler":{"fiyatCarpani":{"arsa":6.0}}}]}
      ''');
      final d = durumKur();
      final oncekiArsa = d.piyasa.fiyat('arsa');
      final sonuc = motor.secimYap(d, motor.katalog.bul('imar')!, 0, akis());
      expect(sonuc.durum.piyasa.fiyat('arsa'), oncekiArsa * 6);
      expect(sonuc.durum.piyasa.fiyat('altin'), d.piyasa.fiyat('altin'));
    });

    test('varlık hediyesi portföye girer', () {
      final motor = motorlu('''
        {"id":"miras","baslik":"m","metin":"m","agirlik":5,
         "secenekler":[{"etiket":"a","etkiler":{"varlik":{"altin":50.0}}}]}
      ''');
      final sonuc =
          motor.secimYap(durumKur(), motor.katalog.bul('miras')!, 0, akis());
      expect(sonuc.durum.portfoy.adet('altin'), 50);
      expect(sonuc.durum.portfoyDegeri, greaterThan(0));
    });

    test('negatif varlık etkisi pozisyonu azaltır', () {
      final motor = motorlu('''
        {"id":"kayip","baslik":"k","metin":"k","agirlik":5,
         "secenekler":[{"etiket":"a","etkiler":{"varlik":{"altin":-30.0}}}]}
      ''');
      final baslangic = durumKur().copyWith(
        portfoy: const Portfoy(
          pozisyonlar: {'altin': Pozisyon(adet: 50, ortalamaMaliyet: 4000)},
        ),
      );
      final sonuc =
          motor.secimYap(baslangic, motor.katalog.bul('kayip')!, 0, akis());
      expect(sonuc.durum.portfoy.adet('altin'), 20);
    });

    test('yetkinlik sektöre yazılır', () {
      final motor = motorlu('''
        {"id":"kurs","baslik":"k","metin":"k","agirlik":5,
         "secenekler":[{"etiket":"a","etkiler":{"yetkinlik":{"finans":5}}}]}
      ''');
      final sonuc =
          motor.secimYap(durumKur(), motor.katalog.bul('kurs')!, 0, akis());
      expect(sonuc.durum.oyuncu.yetkinlik(Sektor.finans), 5);
    });

    test('statlar sınırların dışına taşmaz', () {
      final motor = motorlu('''
        {"id":"asiri","baslik":"a","metin":"a","agirlik":5,
         "secenekler":[{"etiket":"a","etkiler":{"mutluluk":500,"itibar":-500}}]}
      ''');
      final sonuc =
          motor.secimYap(durumKur(), motor.katalog.bul('asiri')!, 0, akis());
      expect(sonuc.durum.oyuncu.mutluluk, Oyuncu.mutlulukTavan);
      expect(sonuc.durum.oyuncu.itibar, Oyuncu.itibarTaban);
    });
  });

  group('Katalog', () {
    test('yinelenen kimlik doğrulamada yakalanır', () {
      final k = OlayKatalogu.jsonMetinlerinden([_sadeKart, _sadeKart]);
      expect(k.uzunluk, 1);
      expect(k.dogrula().first, contains('yinelenen olay kimliği'));
    });

    test('şansları toplamı 1 olmayan kart yakalanır', () {
      final k = OlayKatalogu.jsonMetinlerinden(['''
        {"id":"bozuk","baslik":"b","metin":"b","agirlik":5,
         "secenekler":[{"etiket":"a","sonuclar":[
           {"sans":0.5,"metin":"x"},{"sans":0.2,"metin":"y"}]}]}
      ''']);
      expect(k.dogrula().single, contains('sonuç şansları toplamı'));
    });

    test('gecikmeli ama dalsız seçenek yakalanır', () {
      final k = OlayKatalogu.jsonMetinlerinden(['''
        {"id":"bos","baslik":"b","metin":"b","agirlik":5,
         "secenekler":[{"etiket":"a","gecikmeTuru":5,"etkiler":{"nakit":-100}}]}
      ''']);
      expect(k.dogrula().single, contains('sonuç dalı olmalı'));
    });

    test('uzun metin yakalanır', () {
      final uzun = 'a' * 300;
      final k = OlayKatalogu.jsonMetinlerinden(['''
        {"id":"uzun","baslik":"u","metin":"$uzun","agirlik":5,
         "secenekler":[{"etiket":"a","etkiler":{}}]}
      ''']);
      expect(k.dogrula().single, contains('karakter'));
    });
  });
}
