import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/meslek_katalogu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/sektor.dart';

const _tekMeslek = '''
{
  "id": "memur", "ad": "Memur", "sektor": "hukuk_kamu",
  "girisSarti": { "egitim": "lise", "yetkinlik": 0, "yas": [20, 99] },
  "kademeler": [{ "ad": "Memur", "maas": 38000 }]
}
''';

const _ikiMeslek = '''
[
  {
    "id": "asci", "ad": "Aşçı", "sektor": "esnaf",
    "girisSarti": { "egitim": "ilkogretim" },
    "kademeler": [{ "ad": "Komi", "maas": 14000 }]
  },
  {
    "id": "ciftci", "ad": "Çiftçi", "sektor": "tarim",
    "girisSarti": { "egitim": "ilkogretim" },
    "kademeler": [{ "ad": "Çiftçi", "maas": 12000 }]
  }
]
''';

void main() {
  group('Ayrıştırma', () {
    test('tek nesne ve dizi biçimlerinin ikisi de okunur', () {
      final k = MeslekKatalogu.jsonMetinlerinden([_tekMeslek, _ikiMeslek]);
      expect(k.uzunluk, 3);
      expect(k.bul('memur')?.ad, 'Memur');
      expect(k.bul('asci')?.sektor, Sektor.esnaf);
      expect(k.bul('yok'), isNull);
    });

    test('boş katalog', () {
      expect(MeslekKatalogu.bos.bosMu, isTrue);
      expect(MeslekKatalogu.jsonMetinlerinden(const []).uzunluk, 0);
    });

    test('nesne ya da dizi olmayan içerik hata verir', () {
      expect(
        () => MeslekKatalogu.jsonMetinlerinden(['42']),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('Yinelenen kimlik', () {
    test('sessizce üzerine yazılmaz, doğrulamada hata olur', () {
      final k = MeslekKatalogu.jsonMetinlerinden([_tekMeslek, _tekMeslek]);
      expect(k.uzunluk, 1);
      expect(k.cakisanKimlikler, ['memur']);
      expect(k.dogrula().first, contains('yinelenen meslek kimliği: memur'));
    });
  });

  group('Sorgular', () {
    final katalog = MeslekKatalogu.jsonMetinlerinden([_tekMeslek, _ikiMeslek]);

    test('sektöre göre süzme', () {
      expect(katalog.sektordeki(Sektor.esnaf).single.id, 'asci');
      expect(katalog.sektordeki(Sektor.saglik), isEmpty);
    });

    test('girilebilir meslekler oyuncunun durumuna göre süzülür', () {
      final ilkokul = Oyuncu.yeni(
        ad: 'Test',
        sehir: 'Konya',
        egitim: EgitimSeviyesi.ilkogretim,
      );
      // Memur lise + 20 yaş istiyor; diğer ikisi şartsız.
      expect(
        katalog.girilebilirler(ilkokul).map((m) => m.id).toSet(),
        {'asci', 'ciftci'},
      );

      final liseli = Oyuncu.yeni(ad: 'Test', sehir: 'Konya')
          .copyWith(tur: 24); // 20 yaşında
      expect(katalog.girilebilirler(liseli).map((m) => m.id), contains('memur'));
    });

    test('tumu değiştirilemez liste döner', () {
      expect(() => katalog.tumu.add(katalog.tumu.first), throwsUnsupportedError);
    });
  });
}
