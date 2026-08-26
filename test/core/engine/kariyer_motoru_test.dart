import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/kariyer_motoru.dart';
import 'package:hayat_kariyer/core/engine/piyasa_simulatoru.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/meslek_katalogu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/piyasa_durumu.dart';
import 'package:hayat_kariyer/core/models/sektor.dart';
import 'package:hayat_kariyer/core/models/zaman_dagilimi.dart';
import 'package:hayat_kariyer/core/rng/rng.dart';

MeslekKatalogu gercekKatalog() => MeslekKatalogu.jsonMetinlerinden(
      Directory('assets/careers')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .map((f) => f.readAsStringSync()),
    );

void main() {
  const motor = KariyerMotoru();
  final ayarlar = const KariyerAyarlari();
  final katalog = gercekKatalog();
  final piyasaMotoru = PiyasaSimulatoru();
  final piyasa = piyasaMotoru.baslangic();

  RastgeleAkis akis([int tohum = 1, int tur = 1]) =>
      RastgeleKaynak(tohum).akis('kariyer', tur: tur);

  Oyuncu calisan(
    String meslekId, {
    int kademe = 0,
    int kademeTuru = 0,
    int yetkinlik = 20,
    int enerji = 100,
    int mutluluk = 70,
    bool kayitDisi = false,
    Sektor sektor = Sektor.teknoloji,
  }) =>
      Oyuncu.yeni(ad: 'Test', sehir: Sehir.konya, egitim: EgitimSeviyesi.lisans)
          .yetkinlikDegistir(sektor, yetkinlik)
          .copyWith(
            enerji: enerji,
            mutluluk: mutluluk,
            kariyer: KariyerDurumu.calisan(
              meslekId: meslekId,
              kademeIndeksi: kademe,
              kademeTuru: kademeTuru,
              kayitDisi: kayitDisi,
            ),
          );

  KariyerTurSonucu isle(
    Oyuncu oyuncu, {
    ZamanDagilimi? zaman,
    PiyasaDurumu? p,
    int tohum = 1,
    int tur = 1,
  }) =>
      motor.turIsle(
        oyuncu: oyuncu,
        katalog: katalog,
        piyasa: p ?? piyasa,
        zaman: zaman ?? ZamanDagilimi.dengeli(),
        akis: akis(tohum, tur),
      );

  group('ZamanDagilimi', () {
    test('varsayılan dağılımlar geçerli', () {
      expect(ZamanDagilimi.dengeli().gecerli, isTrue);
      expect(ZamanDagilimi.tamMesai().gecerli, isTrue);
      expect(ZamanDagilimi.calismadan().gecerli, isTrue);
      expect(ZamanDagilimi.dengeli().toplam, ZamanDagilimi.toplamPuan);
      expect(ZamanDagilimi.calismadan().calisma, 0);
    });

    test('toplam puan aşılamaz', () {
      const asiri = ZamanDagilimi(calisma: 8, egitim: 8, dinlenme: 8);
      expect(asiri.gecerli, isFalse);
      final duzeltilmis = asiri.duzelt();
      expect(duzeltilmis.gecerli, isTrue);
      expect(duzeltilmis.toplam, ZamanDagilimi.toplamPuan);
      expect(
        duzeltilmis.calisma,
        8,
        reason: 'kırpma en son kalemden başlamalı, çalışma korunmalı',
      );
    });

    test('negatif değerler sıfırlanır', () {
      const bozuk = ZamanDagilimi(calisma: -5, egitim: 3);
      expect(bozuk.duzelt().calisma, 0);
      expect(bozuk.duzelt().egitim, 3);
    });

    test('boş puan bırakılabilir', () {
      const az = ZamanDagilimi(calisma: 3);
      expect(az.gecerli, isTrue);
      expect(az.bosPuan, 7);
    });
  });

  group('Maaş', () {
    test('enflasyon endeksiyle çarpılır', () {
      final o = calisan('memur', sektor: Sektor.hukukKamu);
      final ucuz = isle(o).netGelir;
      final pahali = isle(
        o,
        p: piyasa.copyWith(enflasyonEndeksi: 4.0),
      ).netGelir;
      expect(pahali, closeTo(ucuz * 4, ucuz * 0.05));
    });

    test('memurun maaşı sabit, emlakçınınki oynar', () {
      final memurGelirleri = [
        for (var t = 1; t <= 40; t++)
          isle(calisan('memur', sektor: Sektor.hukukKamu), tur: t).netGelir,
      ];
      final emlakGelirleri = [
        for (var t = 1; t <= 40; t++)
          isle(calisan('emlak_danismani', sektor: Sektor.ticaret), tur: t)
              .netGelir,
      ];
      expect(memurGelirleri.toSet(), hasLength(1), reason: 'varyans 0');
      expect(emlakGelirleri.toSet().length, greaterThan(20));
    });

    test('döviz payı olan meslek kur şokunda kazanır', () {
      final normalPiyasa = piyasa;
      final kurSoku = piyasa.copyWith(
        fiyatlar: {...piyasa.fiyatlar, 'doviz': piyasa.fiyat('doviz') * 3},
      );

      final pilot = calisan('pilot', sektor: Sektor.lojistik, yetkinlik: 10);
      final memur = calisan('memur', sektor: Sektor.hukukKamu);

      final pilotArtis = isle(pilot, p: kurSoku).netGelir /
          isle(pilot, p: normalPiyasa).netGelir;
      final memurArtis = isle(memur, p: kurSoku).netGelir /
          isle(memur, p: normalPiyasa).netGelir;

      expect(pilotArtis, greaterThan(1.5), reason: 'dovizOrani 0.5');
      expect(memurArtis, closeTo(1.0, 0.01), reason: 'dovizOrani 0');
    });

    test('kayıt dışı çalışan daha çok alır', () {
      final kayitli = isle(calisan('asci', sektor: Sektor.esnaf)).netGelir;
      final kayitDisi =
          isle(calisan('asci', sektor: Sektor.esnaf, kayitDisi: true)).netGelir;
      expect(kayitDisi, greaterThan(kayitli));
      expect(kayitDisi / kayitli, closeTo(ayarlar.kayitDisiPrimi, 0.01));
    });

    test('performans maaşı doğrudan etkiler', () {
      final tamMesai = isle(
        calisan('memur', sektor: Sektor.hukukKamu),
        zaman: ZamanDagilimi.tamMesai(),
      );
      final tembel = isle(
        calisan('memur', sektor: Sektor.hukukKamu),
        zaman: const ZamanDagilimi(dinlenme: 10),
      );
      expect(tamMesai.performans, greaterThan(tembel.performans));
      expect(tamMesai.netGelir, greaterThan(tembel.netGelir));
    });

    test('düşük enerji performansı düşürür', () {
      final dinc = isle(calisan('memur', sektor: Sektor.hukukKamu, enerji: 100));
      final bitkin = isle(calisan('memur', sektor: Sektor.hukukKamu, enerji: 5));
      expect(bitkin.performans, lessThan(dinc.performans));
    });
  });

  group('Gelir şoku log-normal', () {
    List<int> gelirSerisi(String meslekId, Sektor sektor, {int adet = 3000}) => [
          for (var t = 1; t <= adet; t++)
            isle(calisan(meslekId, sektor: sektor), tur: t).netGelir,
        ];

    test('ortalama sapmasız: taban maaşı sistematik aşmaz', () {
      // Yüksek varyanslı meslek, düşük varyanslıya göre haksız kazanç
      // sağlamamalı. Eski kırpmalı modelde emlakçı bu yüzden fazla alıyordu.
      final seri = gelirSerisi('emlak_danismani', Sektor.ticaret);
      final ortalama = seri.reduce((a, b) => a + b) / seri.length;
      final varyanssiz =
          isle(calisan('memur', sektor: Sektor.hukukKamu)).netGelir;
      final meslek = katalog.bul('emlak_danismani')!;
      final memur = katalog.bul('memur')!;
      final beklenen = varyanssiz *
          meslek.ilkKademe.maas /
          memur.ilkKademe.maas;
      expect(ortalama / beklenen, closeTo(1.0, 0.06));
    });

    test('medyan ortalamanın altında: çoğu ay vasat, arada büyük ay gelir', () {
      final seri = gelirSerisi('icerik_ureticisi', Sektor.medya)..sort();
      final medyan = seri[seri.length ~/ 2];
      final ortalama = seri.reduce((a, b) => a + b) / seri.length;
      expect(medyan, lessThan(ortalama * 0.85));
      expect(seri.last, greaterThan(ortalama * 2));
    });

    test('gelir hiçbir zaman negatif olmaz', () {
      for (final g in gelirSerisi('icerik_ureticisi', Sektor.medya)) {
        expect(g, greaterThanOrEqualTo(0));
      }
    });

    test('varyansı sıfır olan meslekte şok yok', () {
      final seri = gelirSerisi('ogretmen', Sektor.hukukKamu, adet: 200);
      expect(seri.toSet(), hasLength(1));
    });
  });

  group('Terfi', () {
    test('kıdem ve yetkinlik birlikte sağlanınca terfi olur', () {
      // Yazılımcı: Stajyer -> Junior, sureTur 6, yetkinlikGerek 15
      final hazir = calisan(
        'yazilim_gelistirici',
        kademeTuru: 6,
        yetkinlik: 20,
      );
      final sonuc = isle(hazir);
      expect(sonuc.terfiEtti, isTrue);
      expect(sonuc.yeniKademeAdi, 'Junior');
      expect((sonuc.oyuncu.kariyer as Calisan).kademeIndeksi, 1);
      expect((sonuc.oyuncu.kariyer as Calisan).kademeTuru, 0);
    });

    test('kıdem yetmezse terfi yok', () {
      final sonuc =
          isle(calisan('yazilim_gelistirici', kademeTuru: 3, yetkinlik: 90));
      expect(sonuc.terfiEtti, isFalse);
    });

    test('yetkinlik yetmezse terfi yok', () {
      final sonuc =
          isle(calisan('yazilim_gelistirici', kademeTuru: 60, yetkinlik: 5));
      expect(sonuc.terfiEtti, isFalse);
    });

    test('son kademede terfi olmaz', () {
      final meslek = katalog.bul('yazilim_gelistirici')!;
      final sonuc = isle(
        calisan(
          'yazilim_gelistirici',
          kademe: meslek.kademeler.length - 1,
          kademeTuru: 200,
          yetkinlik: 100,
        ),
      );
      expect(sonuc.terfiEtti, isFalse);
      expect(
        (sonuc.oyuncu.kariyer as Calisan).kademeIndeksi,
        meslek.kademeler.length - 1,
      );
    });
  });

  group('Kovulma', () {
    test('performans yüksekken kimse kovulmaz', () {
      for (var t = 1; t <= 200; t++) {
        final sonuc = isle(
          calisan('memur', sektor: Sektor.hukukKamu),
          zaman: ZamanDagilimi.tamMesai(),
          tur: t,
        );
        expect(sonuc.istenCikarildi, isFalse);
      }
    });

    test('hiç çalışmayan ve bitkin oyuncu er ya da geç kovulur', () {
      var kovulma = 0;
      for (var t = 1; t <= 200; t++) {
        final sonuc = isle(
          calisan('memur', sektor: Sektor.hukukKamu, enerji: 5, mutluluk: 5),
          zaman: const ZamanDagilimi(dinlenme: 10),
          tur: t,
        );
        if (sonuc.istenCikarildi) kovulma++;
      }
      expect(kovulma, greaterThan(10));
      expect(kovulma, lessThan(120), reason: 'her tur kovulmak da abartı');
    });

    test('kovulan işsiz kalır ve mutluluğu düşer', () {
      var bulundu = false;
      for (var t = 1; t <= 200 && !bulundu; t++) {
        final o = calisan('memur', sektor: Sektor.hukukKamu, enerji: 5);
        final sonuc = isle(o, zaman: const ZamanDagilimi(dinlenme: 10), tur: t);
        if (sonuc.istenCikarildi) {
          bulundu = true;
          expect(sonuc.oyuncu.kariyer, isA<Issiz>());
          expect(sonuc.netGelir, greaterThan(0), reason: 'son maaş ödenir');
        }
      }
      expect(bulundu, isTrue);
    });
  });

  group('Yetkinlik ve itibar', () {
    test('eğitim yetkinliği çalışmadan hızlı artırır', () {
      final o = calisan('yazilim_gelistirici', yetkinlik: 0);
      final egitimli = isle(o, zaman: const ZamanDagilimi(egitim: 10));
      final calismali = isle(o, zaman: ZamanDagilimi.tamMesai());
      expect(
        egitimli.oyuncu.yetkinlik(Sektor.teknoloji),
        greaterThan(calismali.oyuncu.yetkinlik(Sektor.teknoloji)),
      );
    });

    test('yetkinlik tavana yaklaştıkça artış yavaşlar', () {
      int artis(int baslangic) {
        var toplam = 0;
        for (var t = 1; t <= 60; t++) {
          final o = calisan('yazilim_gelistirici', yetkinlik: baslangic);
          final s = isle(o, zaman: const ZamanDagilimi(egitim: 10), tur: t);
          toplam += s.oyuncu.yetkinlik(Sektor.teknoloji) - baslangic;
        }
        return toplam;
      }

      expect(artis(90), lessThan(artis(10)));
    });

    test('yetkinlik mesleğin sektörüne yazılır', () {
      final o = calisan('asci', sektor: Sektor.esnaf, yetkinlik: 10);
      final sonuc = isle(o, zaman: const ZamanDagilimi(egitim: 10));
      expect(sonuc.oyuncu.yetkinlik(Sektor.esnaf), greaterThan(10));
      expect(sonuc.oyuncu.yetkinlik(Sektor.teknoloji), 0);
    });

    test('network itibarı artırır, ihmal edilirse aşınır', () {
      final o = calisan('avukat', sektor: Sektor.hukukKamu, yetkinlik: 20)
          .itibarDegistir(30);
      final aglayan = isle(o, zaman: const ZamanDagilimi(network: 10));
      expect(aglayan.oyuncu.itibar, greaterThan(o.itibar));

      var itibar = o.itibar;
      var dusus = 0;
      for (var t = 1; t <= 40; t++) {
        final s = isle(
          o.itibarDegistir(itibar - o.itibar),
          zaman: ZamanDagilimi.tamMesai(),
          tur: t,
        );
        if (s.oyuncu.itibar < itibar) dusus++;
        itibar = s.oyuncu.itibar;
      }
      expect(dusus, greaterThan(15), reason: 'network ihmal edilince aşınmalı');
    });

    test('itibar platosu ayrılan network puanıyla belirleniyor', () {
      // Aşınma önce SABİTTİ (0,6) ve yalnız `network == 0` turunda
      // işliyordu. O kurguda tek puan hem büyümeyi hem aşınma
      // bağışıklığını satın alıyor, ikinci puan boşa gidiyordu; ölçüldü:
      // network 1 ile network 3 aynı fırsat payını veriyor (%36,4 ve
      // %36,3) ama ikincisi 3,7M net değer kaybediyordu. İtibar bir
      // merdiven değil ikili bir anahtardı.
      //
      // Orantılı aşınmayla her puan AYRI bir platoya oturmalı.
      int plato(int network) {
        var o = calisan(
          'yazilim_gelistirici',
          sektor: Sektor.teknoloji,
        );
        final kalan = 10 - network;
        final z = ZamanDagilimi(
          calisma: kalan >= 4 ? 4 : kalan,
          network: network,
          dinlenme: kalan >= 4 ? kalan - 4 : 0,
        );
        // 250 tur: platoya oturmak için fazlasıyla yeterli (ölçümde 100.
        // turda sabitleniyor).
        for (var t = 1; t <= 250; t++) {
          o = motor
              .turIsle(
                oyuncu: o,
                katalog: katalog,
                piyasa: piyasa,
                zaman: z,
                maasEndeksi: 1.0,
                akis: akis(99, t),
              )
              .oyuncu;
        }
        return o.itibar;
      }

      final p0 = plato(0);
      final p1 = plato(1);
      final p3 = plato(3);
      final p5 = plato(5);

      expect(p0, lessThan(5), reason: 'network ayırmayan itibarını koruyamaz');
      expect(p1, greaterThan(p0));
      expect(p3, greaterThan(p1 + 10),
          reason: 'ikinci ve üçüncü puan boşa gitmemeli: $p1 -> $p3');
      expect(p5, greaterThan(p3),
          reason: 'plato artmaya devam etmeli: $p3 -> $p5');
    });

    test('yüksek itibar bakım ister, kendiliğinden durmaz', () {
      // "İtibar korunması gereken bir kaynaktır, bir kez kazanılıp
      // bitmez" — tavana yakın itibar, tek network puanıyla tutulamaz.
      final tepede = calisan('yazilim_gelistirici', sektor: Sektor.teknoloji)
          .itibarDegistir(95);
      final sonuc = motor.turIsle(
        oyuncu: tepede,
        katalog: katalog,
        piyasa: piyasa,
        zaman: const ZamanDagilimi(calisma: 5, network: 1, dinlenme: 4),
        maasEndeksi: 1.0,
        akis: akis(3, 1),
      );
      expect(sonuc.oyuncu.itibar, lessThan(tepede.itibar));
    });

    test('avukatın itibar kazanımı yazılımcıdan yüksek', () {
      int kazanc(String meslekId, Sektor s) {
        var toplam = 0;
        for (var t = 1; t <= 50; t++) {
          final o = calisan(meslekId, sektor: s, yetkinlik: 20);
          final r = isle(o, zaman: const ZamanDagilimi(network: 10), tur: t);
          toplam += r.oyuncu.itibar - o.itibar;
        }
        return toplam;
      }

      expect(
        kazanc('avukat', Sektor.hukukKamu),
        greaterThan(kazanc('yazilim_gelistirici', Sektor.teknoloji)),
      );
    });
  });

  group('Enerji ve mutluluk', () {
    /// Verilen dağılımla uzun vadede oturduğu mutluluk.
    int mutlulukPlatosu(ZamanDagilimi z) {
      var o = calisan('yazilim_gelistirici', sektor: Sektor.teknoloji);
      for (var t = 1; t <= 200; t++) {
        o = motor
            .turIsle(
              oyuncu: o,
              katalog: katalog,
              piyasa: piyasa,
              zaman: z,
              maasEndeksi: 1.0,
              akis: akis(5, t),
            )
            .oyuncu;
      }
      return o.mutluluk;
    }

    test('mutluluk platosu ayrılan dinlenme puanıyla belirleniyor', () {
      // Mutluluk önce tek yönlü bir cırcırdı: dinlenmeye bir puan ayıran
      // oyuncu 7 turda 100'e yapışıp orada kalıyordu. Ölçüldü — `dengeli()`
      // her tur +4,5 veriyor, hiçbir aşınma yoktu. Hedonik uyumla her
      // dinlenme seviyesi AYRI bir platoya oturmalı.
      final az = mutlulukPlatosu(
          const ZamanDagilimi(calisma: 6, egitim: 3, dinlenme: 1));
      final orta = mutlulukPlatosu(ZamanDagilimi.dengeli());
      final cok = mutlulukPlatosu(
          const ZamanDagilimi(calisma: 4, egitim: 1, dinlenme: 5));

      expect(orta, greaterThan(az), reason: '$az -> $orta');
      expect(cok, greaterThan(orta), reason: '$orta -> $cok');
      // Dengeli dağılım tavana YAPIŞMAMALI: yapışırsa mutluluğu harcayan
      // kartların ve aşırı çalışmanın hiçbir etkisi kalmaz.
      expect(orta, lessThan(Oyuncu.mutlulukTavan));
    });

    test('aşırı çalışma burnout getiriyor, dengeli dağılım getirmiyor', () {
      // Anayasa: "Mutluluk/Stres — düşerse burnout, performans düşer."
      // Eşik (20) daha önce hiç görülmüyordu; ölçüldü: `calisma: 8`
      // oyuncusu hem en yüksek serveti hem 74 mutluluğu alıyordu, yani
      // aşırı çalışmanın bedeli yoktu.
      expect(
        mutlulukPlatosu(const ZamanDagilimi(calisma: 8, dinlenme: 2)),
        lessThan(Oyuncu.burnoutEsigi),
      );
      expect(
        mutlulukPlatosu(ZamanDagilimi.dengeli()),
        greaterThan(Oyuncu.burnoutEsigi),
      );
    });

    test('tam mesai enerji yakar, dinlenme doldurur', () {
      final o = calisan('asci', sektor: Sektor.esnaf, enerji: 60);
      expect(isle(o, zaman: ZamanDagilimi.tamMesai()).oyuncu.enerji,
          lessThan(60));
      expect(isle(o, zaman: const ZamanDagilimi(dinlenme: 10)).oyuncu.enerji,
          greaterThan(60));
    });

    test('yorucu meslek daha çok enerji yakar', () {
      final asci = calisan('asci', sektor: Sektor.esnaf, enerji: 80);
      final yazilimci = calisan('yazilim_gelistirici', enerji: 80);
      expect(
        isle(asci, zaman: ZamanDagilimi.tamMesai()).oyuncu.enerji,
        lessThan(isle(yazilimci, zaman: ZamanDagilimi.tamMesai()).oyuncu.enerji),
      );
    });

    test('aşırı çalışma mutluluğu düşürür', () {
      final o = calisan('memur', sektor: Sektor.hukukKamu, mutluluk: 60);
      expect(
        isle(o, zaman: ZamanDagilimi.tamMesai()).oyuncu.mutluluk,
        lessThan(60),
      );
    });

    test('sürekli tam mesai tükenmişliğe götürür', () {
      var o = calisan('doktor', sektor: Sektor.saglik, yetkinlik: 30);
      for (var t = 1; t <= 12; t++) {
        o = isle(o, zaman: ZamanDagilimi.tamMesai(), tur: t).oyuncu;
      }
      expect(o.enerji, lessThan(20));
      expect(o.burnout, isTrue);
    });
  });

  group('Çalışan olmayan durumlar', () {
    test('öğrenci gelir üretmez ama hızlı öğrenir', () {
      final o = Oyuncu.yeni(ad: 'Test', sehir: Sehir.izmir)
          .yetkinlikDegistir(Sektor.saglik, 5)
          .kariyerDegistir(
            const KariyerDurumu.ogrenci(
              hedef: EgitimSeviyesi.lisans,
              kalanTur: 24,
            ),
          );
      final sonuc = isle(o, zaman: ZamanDagilimi.calismadan());
      expect(sonuc.netGelir, 0);
      expect(sonuc.oyuncu.yetkinlik(Sektor.saglik), greaterThan(5));
      expect(sonuc.mezunOldu, isFalse);
    });

    test('son turda mezun olur ve eğitim seviyesi yükselir', () {
      final o = Oyuncu.yeni(ad: 'Test', sehir: Sehir.izmir).kariyerDegistir(
        const KariyerDurumu.ogrenci(hedef: EgitimSeviyesi.lisans, kalanTur: 1),
      );
      final sonuc = isle(o, zaman: ZamanDagilimi.calismadan());
      expect(sonuc.mezunOldu, isTrue);
      expect(sonuc.oyuncu.egitim, EgitimSeviyesi.lisans);
      expect(sonuc.oyuncu.kariyer, isA<Issiz>());
    });

    test('işsizlik mutluluğu düşürür, gelir yok', () {
      final o = Oyuncu.yeni(ad: 'Test', sehir: Sehir.izmir).copyWith(mutluluk: 60);
      final sonuc = isle(o, zaman: const ZamanDagilimi(dinlenme: 2));
      expect(sonuc.netGelir, 0);
      expect(sonuc.oyuncu.mutluluk, lessThan(60));
    });

    test('askerlikte zaman dağıtımı işlemez', () {
      final o = Oyuncu.yeni(ad: 'Test', sehir: Sehir.konya)
          .yetkinlikDegistir(Sektor.teknoloji, 40)
          .copyWith(enerji: 80, mutluluk: 60)
          .kariyerDegistir(const KariyerDurumu.askerlik(kalanTur: 6));
      final sonuc = isle(o, zaman: const ZamanDagilimi(egitim: 10));
      expect(sonuc.oyuncu.yetkinlik(Sektor.teknoloji), 40);
      expect(sonuc.oyuncu.enerji, lessThan(80));
      expect(sonuc.askerlikBitti, isFalse);
    });

    test('askerlik bitince terhis olur', () {
      final o = Oyuncu.yeni(ad: 'Test', sehir: Sehir.konya)
          .kariyerDegistir(const KariyerDurumu.askerlik(kalanTur: 1));
      final sonuc = isle(o);
      expect(sonuc.askerlikBitti, isTrue);
      expect(sonuc.oyuncu.kariyer, isA<Issiz>());
    });

    test('emekli aylığı enflasyona endekslenir', () {
      final o = Oyuncu.yeni(ad: 'Test', sehir: Sehir.izmir)
          .kariyerDegistir(const KariyerDurumu.emekli(tabanAylik: 20000));
      expect(isle(o).netGelir, 20000);
      expect(
        isle(o, p: piyasa.copyWith(enflasyonEndeksi: 5.0)).netGelir,
        100000,
      );
    });

    test('bozuk kayıttaki tanımsız meslek çökmez, işsizliğe düşer', () {
      final o = Oyuncu.yeni(ad: 'Test', sehir: Sehir.izmir)
          .kariyerDegistir(const KariyerDurumu.calisan(meslekId: 'yok_boyle'));
      final sonuc = isle(o);
      expect(sonuc.oyuncu.kariyer, isA<Issiz>());
      expect(sonuc.netGelir, 0);
    });
  });

  group('Determinizm', () {
    test('aynı girdi aynı sonucu verir', () {
      final o = calisan('emlak_danismani', sektor: Sektor.ticaret);
      final a = isle(o, tohum: 77, tur: 9);
      final b = isle(o, tohum: 77, tur: 9);
      expect(a.oyuncu, b.oyuncu);
      expect(a.netGelir, b.netGelir);
    });

    test('farklı tohum farklı sonuç verir', () {
      final o = calisan('emlak_danismani', sektor: Sektor.ticaret);
      final gelirler = {
        for (var tohum = 0; tohum < 20; tohum++)
          isle(o, tohum: tohum, tur: 9).netGelir,
      };
      expect(gelirler.length, greaterThan(10));
    });

    test('kesirli yuvarlama uzun vadede sapmasız', () {
      // 0.4'lük artışlar round() ile hep sıfıra düşerdi; stokastik
      // yuvarlamayla ~40 turda ~16 puan birikmeli.
      var o = calisan('memur', sektor: Sektor.hukukKamu, yetkinlik: 0);
      for (var t = 1; t <= 40; t++) {
        o = isle(o, zaman: const ZamanDagilimi(calisma: 2), tur: t).oyuncu;
      }
      expect(o.yetkinlik(Sektor.hukukKamu), greaterThan(8));
    });
  });
}
