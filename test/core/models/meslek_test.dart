import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/meslek.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/sektor.dart';

/// docs/meslekler.md içindeki örnek şemanın birebir karşılığı.
/// `yetkinlikGerek: 120` yerine 95 — yetkinlik tavanı 100.
const _yazilimJson = '''
{
  "id": "yazilim_gelistirici",
  "ad": "Yazılım Geliştirici",
  "sektor": "teknoloji",
  "girisSarti": { "egitim": "lisans", "yetkinlik": 10, "yas": [21, 99] },
  "kademeler": [
    { "ad": "Stajyer",      "maas": 18000,  "yetkinlikGerek": 0,  "sureTur": 6 },
    { "ad": "Junior",       "maas": 45000,  "yetkinlikGerek": 15, "sureTur": 18 },
    { "ad": "Mid",          "maas": 85000,  "yetkinlikGerek": 40, "sureTur": 24 },
    { "ad": "Senior",       "maas": 150000, "yetkinlikGerek": 70, "sureTur": 30 },
    { "ad": "Takım Lideri", "maas": 220000, "yetkinlikGerek": 85, "sureTur": 36 },
    { "ad": "CTO",          "maas": 400000, "yetkinlikGerek": 95, "sureTur": null }
  ],
  "yetkinlikArtisHizi": 1.2,
  "networkArtisi": 0.8,
  "enerjiMaliyeti": 3,
  "gelirVaryansi": 0.15,
  "dovizOrani": 0.0,
  "acilanIsletmeler": ["yazilim_studyosu", "saas_urunu"],
  "olayHavuzu": ["tech_01", "tech_02"]
}
''';

Meslek yazilimci() =>
    Meslek.fromJson(jsonDecode(_yazilimJson) as Map<String, dynamic>);

/// Doğrulama testleri için asgari geçerli meslek.
Meslek gecerliMeslek({
  List<Kademe>? kademeler,
  GirisSarti girisSarti = const GirisSarti(),
  double yetkinlikArtisHizi = 1.0,
  double gelirVaryansi = 0.0,
  double dovizOrani = 0.0,
}) =>
    Meslek(
      id: 'test_meslek',
      ad: 'Test',
      sektor: Sektor.esnaf,
      girisSarti: girisSarti,
      kademeler: kademeler ??
          const [
            Kademe(ad: 'Çırak', maas: 20000, sureTur: 12),
            Kademe(ad: 'Usta', maas: 60000, yetkinlikGerek: 40),
          ],
      yetkinlikArtisHizi: yetkinlikArtisHizi,
      gelirVaryansi: gelirVaryansi,
      dovizOrani: dovizOrani,
    );

void main() {
  group('JSON şeması (docs/meslekler.md ile uyum)', () {
    test('tasarım dokümanındaki şema olduğu gibi okunur', () {
      final m = yazilimci();
      expect(m.id, 'yazilim_gelistirici');
      expect(m.sektor, Sektor.teknoloji);
      expect(m.girisSarti.egitim, EgitimSeviyesi.lisans);
      expect(m.girisSarti.yetkinlik, 10);
      expect(m.girisSarti.yasEnAz, 21);
      expect(m.girisSarti.yasEnCok, 99);
      expect(m.kademeler.length, 6);
      expect(m.ilkKademe.ad, 'Stajyer');
      expect(m.sonKademe.ad, 'CTO');
      expect(m.sonKademe.sonKademe, isTrue);
      expect(m.ilkKademe.sonKademe, isFalse);
      expect(m.tavanMaas, 400000);
      expect(m.dovizOrani, 0.0);
      expect(m.acilanIsletmeler, ['yazilim_studyosu', 'saas_urunu']);
    });

    test('round-trip', () {
      final m = yazilimci();
      final geri = Meslek.fromJson(
        jsonDecode(jsonEncode(m.toJson())) as Map<String, dynamic>,
      );
      expect(geri, m);
    });

    test('eksik alanlar varsayılana düşer', () {
      final m = Meslek.fromJson({
        'id': 'memur',
        'ad': 'Memur',
        'sektor': 'hukuk_kamu',
        'kademeler': [
          {'ad': 'Memur', 'maas': 30000},
        ],
      });
      expect(m.girisSarti, const GirisSarti());
      expect(m.gelirVaryansi, 0.0);
      expect(m.enerjiMaliyeti, 3);
      expect(m.olayHavuzu, isEmpty);
    });
  });

  group('kademe erişimi', () {
    test('indeks sınırlar içinde tutulur', () {
      final m = yazilimci();
      expect(m.kademe(0).ad, 'Stajyer');
      expect(m.kademe(99).ad, 'CTO');
      expect(m.kademe(-3).ad, 'Stajyer');
    });
  });

  group('girebilirMi', () {
    Oyuncu oyuncu({
      EgitimSeviyesi egitim = EgitimSeviyesi.lisans,
      int yetkinlik = 10,
      int tur = 36,
    }) =>
        Oyuncu.yeni(ad: 'Test', sehir: Sehir.izmir, egitim: egitim)
            .yetkinlikDegistir(Sektor.teknoloji, yetkinlik)
            .copyWith(tur: tur);

    test('tüm şartlar sağlanırsa girilir', () {
      expect(yazilimci().girebilirMi(oyuncu()), isTrue);
    });

    test('eğitim yetmezse girilemez', () {
      expect(
        yazilimci().girebilirMi(oyuncu(egitim: EgitimSeviyesi.lise)),
        isFalse,
      );
    });

    test('yetkinlik yetmezse girilemez', () {
      expect(yazilimci().girebilirMi(oyuncu(yetkinlik: 9)), isFalse);
    });

    test('yaş küçükse girilemez', () {
      expect(yazilimci().girebilirMi(oyuncu(tur: 0)), isFalse);
    });

    test('yetkinlik mesleğin sektöründen okunur', () {
      final baskaSektor =
          Oyuncu.yeni(ad: 'Test', sehir: Sehir.izmir, egitim: EgitimSeviyesi.lisans)
              .yetkinlikDegistir(Sektor.tarim, 90)
              .copyWith(tur: 36);
      expect(yazilimci().girebilirMi(baskaSektor), isFalse);
    });
  });

  group('dogrula: veri dosyası şema kontrolü', () {
    test('geçerli meslek hata vermez', () {
      expect(yazilimci().dogrula(), isEmpty);
      expect(gecerliMeslek().dogrula(), isEmpty);
    });

    test('boş kademe listesi yakalanır', () {
      final hatalar = gecerliMeslek(kademeler: const []).dogrula();
      expect(hatalar, hasLength(1));
      expect(hatalar.first, contains('kademe listesi boş'));
    });

    test('yetkinlikGerek 100 üstü yakalanır', () {
      final hatalar = gecerliMeslek(
        kademeler: const [
          Kademe(ad: 'Alt', maas: 10000, sureTur: 6),
          Kademe(ad: 'Üst', maas: 20000, yetkinlikGerek: 120),
        ],
      ).dogrula();
      expect(hatalar.single, contains('yetkinlikGerek 120'));
    });

    test('maaşın kademe boyunca düşmesi yakalanır', () {
      final hatalar = gecerliMeslek(
        kademeler: const [
          Kademe(ad: 'Alt', maas: 50000, sureTur: 6),
          Kademe(ad: 'Üst', maas: 20000),
        ],
      ).dogrula();
      expect(hatalar.single, contains('maaş bir önceki kademeden düşük'));
    });

    test('son kademede sureTur dolu olması yakalanır', () {
      final hatalar = gecerliMeslek(
        kademeler: const [
          Kademe(ad: 'Alt', maas: 10000, sureTur: 6),
          Kademe(ad: 'Üst', maas: 20000, sureTur: 12),
        ],
      ).dogrula();
      expect(hatalar.single, contains('son kademede sureTur null olmalı'));
    });

    test('ara kademede sureTur eksikliği yakalanır', () {
      final hatalar = gecerliMeslek(
        kademeler: const [
          Kademe(ad: 'Alt', maas: 10000),
          Kademe(ad: 'Üst', maas: 20000),
        ],
      ).dogrula();
      expect(hatalar.single, contains('sureTur pozitif olmalı'));
    });

    test('ters yaş aralığı yakalanır', () {
      final hatalar = gecerliMeslek(
        girisSarti: const GirisSarti(yasAraligi: [40, 25]),
      ).dogrula();
      expect(hatalar.single, contains('girisSarti.yas aralığı ters'));
    });

    test('girilemez meslek yakalanır (ilk kademe giriş şartından ağır)', () {
      final hatalar = gecerliMeslek(
        girisSarti: const GirisSarti(yetkinlik: 5),
        kademeler: const [
          Kademe(ad: 'Alt', maas: 10000, yetkinlikGerek: 50, sureTur: 6),
          Kademe(ad: 'Üst', maas: 20000, yetkinlikGerek: 60),
        ],
      ).dogrula();
      expect(hatalar.single, contains('ilk kademe giriş şartından fazla'));
    });

    test('aralık dışı oranlar yakalanır', () {
      final hatalar = gecerliMeslek(
        yetkinlikArtisHizi: 0,
        gelirVaryansi: 1.5,
        dovizOrani: -0.2,
      ).dogrula();
      expect(hatalar, hasLength(3));
    });
  });

  group('Sektor', () {
    test('kimlikten bulunur ve tüm kimlikler benzersiz', () {
      expect(Sektor.bul('hukuk_kamu'), Sektor.hukukKamu);
      expect(Sektor.bul('uzay_madenciligi'), isNull);
      expect(
        Sektor.values.map((s) => s.id).toSet(),
        hasLength(Sektor.values.length),
      );
    });
  });
}
