import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';

void main() {
  Oyuncu yeniOyuncu() => Oyuncu.yeni(ad: 'Furkan', sehir: 'Konya');

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
          .yetkinlikDegistir('yazilim', 40)
          .yetkinlikDegistir('insaat', 15)
          .yetkinlikDegistir('yazilim', 999);
      expect(o.yetkinlik('yazilim'), Oyuncu.yetkinlikTavan);
      expect(o.yetkinlik('insaat'), 15);
      expect(o.yetkinlik('tanimsiz'), 0);
      expect(o.anaSektor, 'yazilim');
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
          .yetkinlikDegistir('yazilim', 44)
          .yetkinlikDegistir('finans', 8)
          .turIlerlet()
          .turIlerlet();

      final geri = Oyuncu.fromJson(
        jsonDecode(jsonEncode(o.toJson())) as Map<String, dynamic>,
      );

      expect(geri, o);
      expect(geri.yas, o.yas);
      expect(geri.yetkinlik('yazilim'), 44);
    });

    test('eksik alanlar varsayılana düşer', () {
      final geri = Oyuncu.fromJson({'ad': 'Ayşe', 'sehir': 'Trabzon'});
      expect(geri, Oyuncu.yeni(ad: 'Ayşe', sehir: 'Trabzon'));
    });
  });

  group('duzelt: bozuk kayıt savunması', () {
    test('sınır dışı değerler geri çekilir', () {
      const bozuk = Oyuncu(
        ad: 'Bozuk',
        sehir: 'İzmir',
        tur: -5,
        enerji: 320,
        mutluluk: -40,
        itibar: 900,
        krediNotu: 99999,
        yetkinlikler: {'yazilim': 250, 'insaat': -10},
      );
      final d = bozuk.duzelt();
      expect(d.tur, 0);
      expect(d.enerji, Oyuncu.enerjiTavan);
      expect(d.mutluluk, Oyuncu.mutlulukTaban);
      expect(d.itibar, Oyuncu.itibarTavan);
      expect(d.krediNotu, Oyuncu.krediNotuTavan);
      expect(d.yetkinlik('yazilim'), Oyuncu.yetkinlikTavan);
      expect(d.yetkinlik('insaat'), Oyuncu.yetkinlikTaban);
    });

    test('geçerli kayıt değişmez', () {
      final o = yeniOyuncu().nakitDegistir(1234).yetkinlikDegistir('finans', 30);
      expect(o.duzelt(), o);
    });
  });
}
