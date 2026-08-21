import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/sektor.dart';

void main() {
  Oyuncu yeniOyuncu() => Oyuncu.yeni(ad: 'Furkan', sehir: Sehir.konya);

  group('Başlangıç durumu', () {
    test('yeni oyuncu 18 yaşında ve ilk turda başlar', () {
      final o = yeniOyuncu();
      expect(o.tur, 0);
      expect(o.yas, 18);
      expect(o.ay, 1);
      expect(o.nakit, 0);
      expect(o.enerji, Oyuncu.enerjiTavan);
      expect(o.yetkinlikler, isEmpty);
      expect(o.anaSektor, isNull);
    });
  });

  group('Yaş ve ay turdan türetilir', () {
    test('12 tur = 1 yaş', () {
      var o = yeniOyuncu();
      for (var i = 0; i < 12; i++) {
        o = o.turIlerlet();
      }
      expect(o.tur, 12);
      expect(o.yas, 19);
      expect(o.ay, 1);
    });

    test('ay 1-12 arasında döner', () {
      var o = yeniOyuncu();
      final aylar = <int>[];
      for (var i = 0; i < 25; i++) {
        aylar.add(o.ay);
        o = o.turIlerlet();
      }
      expect(aylar.take(12), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
      expect(aylar[12], 1);
      expect(o.yas, 20);
    });
  });

  group('Sınır kontrolleri', () {
    test('enerji 0-100 dışına çıkamaz', () {
      final o = yeniOyuncu();
      expect(o.enerjiDegistir(50).enerji, Oyuncu.enerjiTavan);
      expect(o.enerjiDegistir(-500).enerji, Oyuncu.enerjiTaban);
      expect(o.enerjiDegistir(-30).enerji, 70);
    });

    test('mutluluk ve itibar sınırlanır', () {
      final o = yeniOyuncu();
      expect(o.mutlulukDegistir(-999).mutluluk, Oyuncu.mutlulukTaban);
      expect(o.mutlulukDegistir(999).mutluluk, Oyuncu.mutlulukTavan);
      expect(o.itibarDegistir(-999).itibar, Oyuncu.itibarTaban);
      expect(o.itibarDegistir(999).itibar, Oyuncu.itibarTavan);
    });

    test('kredi notu 300-1900 aralığında kalır', () {
      final o = yeniOyuncu();
      expect(o.krediNotuDegistir(-9999).krediNotu, Oyuncu.krediNotuTaban);
      expect(o.krediNotuDegistir(9999).krediNotu, Oyuncu.krediNotuTavan);
    });

    test('nakit sınırlanmaz; eksiye düşebilir', () {
      final o = yeniOyuncu().nakitDegistir(-25000);
      expect(o.nakit, -25000);
    });

    test('yetkinlik 0-100 arasında kalır ve sektöre göre ayrılır', () {
      final o = yeniOyuncu()
          .yetkinlikDegistir(Sektor.teknoloji, 40)
          .yetkinlikDegistir(Sektor.lojistik, 15)
          .yetkinlikDegistir(Sektor.teknoloji, 999);
      expect(o.yetkinlik(Sektor.teknoloji), Oyuncu.yetkinlikTavan);
      expect(o.yetkinlik(Sektor.lojistik), 15);
      expect(o.yetkinlik(Sektor.turizm), 0);
      expect(o.anaSektor, Sektor.teknoloji);
    });
  });

  group('Durum eşikleri', () {
    test('enerji bitince tükenmiş sayılır', () {
      expect(yeniOyuncu().tukenmis, isFalse);
      expect(yeniOyuncu().enerjiDegistir(-100).tukenmis, isTrue);
    });

    test('mutluluk eşiğin altına inince burnout', () {
      final o = yeniOyuncu();
      expect(o.burnout, isFalse);
      expect(o.mutlulukDegistir(-51).burnout, isTrue);
      expect(
        o.mutlulukDegistir(-(o.mutluluk - Oyuncu.burnoutEsigi)).burnout,
        isFalse,
      );
    });
  });

  group('Net değer', () {
    test('nakit + varlıklar - borçlar', () {
      final o = yeniOyuncu().nakitDegistir(100000);
      expect(o.netDeger(), 100000);
      expect(o.netDeger(varliklar: 500000, borclar: 250000), 350000);
    });
  });

  group('Değişmezlik', () {
    test('değiştirme metotları özgün nesneyi bozmaz', () {
      final o = yeniOyuncu();
      o.nakitDegistir(1000).enerjiDegistir(-40).turIlerlet();
      expect(o.nakit, 0);
      expect(o.enerji, Oyuncu.enerjiTavan);
      expect(o.tur, 0);
    });
  });

  group('JSON round-trip (kayıt dosyası)', () {
    test('tüm alanlar kayıptan sonra korunur', () {
      final o = yeniOyuncu()
          .nakitDegistir(87500)
          .enerjiDegistir(-35)
          .mutlulukDegistir(-12)
          .itibarDegistir(23)
          .krediNotuDegistir(150)
          .yetkinlikDegistir(Sektor.teknoloji, 44)
          .yetkinlikDegistir(Sektor.finans, 8)
          .turIlerlet()
          .turIlerlet();

      final geri = Oyuncu.fromJson(
        jsonDecode(jsonEncode(o.toJson())) as Map<String, dynamic>,
      );

      expect(geri, o);
      expect(geri.yas, o.yas);
      expect(geri.yetkinlik(Sektor.teknoloji), 44);
    });

    test('eksik alanlar varsayılana düşer', () {
      final geri = Oyuncu.fromJson({'ad': 'Ayşe', 'sehir': 'trabzon'});
      expect(geri, Oyuncu.yeni(ad: 'Ayşe', sehir: Sehir.trabzon));
    });
  });

  group('duzelt: bozuk kayıt savunması', () {
    test('sınır dışı değerler geri çekilir', () {
      const bozuk = Oyuncu(
        ad: 'Bozuk',
        sehir: Sehir.izmir,
        tur: -5,
        enerji: 320,
        mutluluk: -40,
        itibar: 900,
        krediNotu: 99999,
        yetkinlikler: {Sektor.teknoloji: 250, Sektor.lojistik: -10},
      );
      final d = bozuk.duzelt();
      expect(d.tur, 0);
      expect(d.enerji, Oyuncu.enerjiTavan);
      expect(d.mutluluk, Oyuncu.mutlulukTaban);
      expect(d.itibar, Oyuncu.itibarTavan);
      expect(d.krediNotu, Oyuncu.krediNotuTavan);
      expect(d.yetkinlik(Sektor.teknoloji), Oyuncu.yetkinlikTavan);
      expect(d.yetkinlik(Sektor.lojistik), Oyuncu.yetkinlikTaban);
    });

    test('geçerli kayıt değişmez', () {
      final o = yeniOyuncu().nakitDegistir(1234).yetkinlikDegistir(Sektor.finans, 30);
      expect(o.duzelt(), o);
    });
  });

  group('Kariyer durumu ve SGK', () {
    test('yeni oyuncu lise mezunu ve işsiz başlar', () {
      final o = yeniOyuncu();
      expect(o.egitim, EgitimSeviyesi.lise);
      expect(o.kariyer, const KariyerDurumu.issiz());
      expect(o.sgkPrimAyi, 0);
      expect(o.askerlikYukumlusu, isTrue);
    });

    test('tur ilerleyince kariyer sayaçları da ilerler', () {
      final o = yeniOyuncu()
          .kariyerDegistir(
            const KariyerDurumu.calisan(meslekId: 'memur', kademeTuru: 3),
          )
          .turIlerlet();
      expect((o.kariyer as Calisan).kademeTuru, 4);
      expect(o.tur, 1);
    });

    test('kayıtlı çalışanın primi yatar, kayıt dışının yatmaz', () {
      var kayitli = yeniOyuncu().kariyerDegistir(
        const KariyerDurumu.calisan(meslekId: 'memur'),
      );
      var kayitDisi = yeniOyuncu().kariyerDegistir(
        const KariyerDurumu.calisan(meslekId: 'asci', kayitDisi: true),
      );
      for (var i = 0; i < 12; i++) {
        kayitli = kayitli.turIlerlet();
        kayitDisi = kayitDisi.turIlerlet();
      }
      expect(kayitli.sgkPrimAyi, 12);
      expect(kayitDisi.sgkPrimAyi, 0);
    });

    test('işsizken prim yatmaz', () {
      final o = yeniOyuncu().turIlerlet().turIlerlet();
      expect(o.sgkPrimAyi, 0);
      expect((o.kariyer as Issiz).gecenTur, 2);
    });

    test('kadın karakter askerlik yükümlüsü değil', () {
      final o = Oyuncu.yeni(
        ad: 'Ayşe',
        sehir: Sehir.izmir,
        cinsiyet: Cinsiyet.kadin,
      );
      expect(o.askerlikYukumlusu, isFalse);
    });

    test('kariyer durumu kayıtta korunur', () {
      final o = yeniOyuncu().kariyerDegistir(
        const KariyerDurumu.ogrenci(hedef: EgitimSeviyesi.lisans, kalanTur: 48),
      );
      final geri = Oyuncu.fromJson(
        jsonDecode(jsonEncode(o.toJson())) as Map<String, dynamic>,
      );
      expect(geri.kariyer, o.kariyer);
    });
  });
}
