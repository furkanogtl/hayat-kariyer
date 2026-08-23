import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/kariyer_motoru.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/meslek_katalogu.dart';
import 'package:hayat_kariyer/core/models/oyun_durumu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/sektor.dart';
import 'package:hayat_kariyer/core/models/zaman_dagilimi.dart';

MeslekKatalogu _meslekler() => MeslekKatalogu.jsonMetinlerinden(
      Directory('assets/careers')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .map((f) => f.readAsStringSync()),
    );

const _ayarlar = KariyerAyarlari();

void main() {
  final katalog = _meslekler();
  final motor = TurProcessor(katalog: katalog);
  const kariyerMotoru = KariyerMotoru();

  Oyuncu oyuncu({
    int yas = 21,
    Cinsiyet cinsiyet = Cinsiyet.erkek,
    KariyerDurumu? kariyer,
    int nakit = 100000,
    bool askerlikYapildi = false,
  }) =>
      Oyuncu.yeni(
        ad: 'Test',
        sehir: Sehir.konya,
        cinsiyet: cinsiyet,
        egitim: EgitimSeviyesi.lisans,
      ).yetkinlikDegistir(Sektor.teknoloji, 40)
          .yetkinlikDegistir(Sektor.hukukKamu, 20)
          .copyWith(
            // Yaş turdan türetiliyor; başlangıç yaşını oynatarak kuruyoruz.
            baslangicYasi: yas,
            nakit: nakit,
            askerlikYapildi: askerlikYapildi,
            kariyer: kariyer ??
                const KariyerDurumu.calisan(meslekId: 'yazilim_gelistirici'),
          );

  OyunDurumu baslat({Oyuncu? o, int tohum = 42}) =>
      motor.yeniOyun(oyuncu: o ?? oyuncu(), anaTohum: tohum);

  TurSonucu tek(OyunDurumu d, {bool bedelliOde = false, String? iseGir}) =>
      motor.turuBitir(
        d,
        TurGirdisi(
          zaman: ZamanDagilimi.dengeli(),
          bedelliOde: bedelliOde,
          iseGirTalebi: iseGir,
        ),
      );

  group('celp', () {
    test('yaşı tutan erkek çalışana tebligat gelir', () {
      final sonuc = tek(baslat());
      expect(sonuc.rapor.celpGeldi, isTrue);
      expect(sonuc.durum.oyuncu.celpKalanTur, _ayarlar.celpTebligatTuru);
    });

    test('kadın oyuncuya gelmez', () {
      final sonuc = tek(baslat(o: oyuncu(cinsiyet: Cinsiyet.kadin)));
      expect(sonuc.rapor.celpGeldi, isFalse);
      expect(sonuc.durum.oyuncu.celpKalanTur, isNull);
    });

    test('öğrencilik tecil sayılır', () {
      final ogrenci = oyuncu(
        kariyer: const KariyerDurumu.ogrenci(
          hedef: EgitimSeviyesi.lisans,
          kalanTur: 24,
        ),
      );
      expect(tek(baslat(o: ogrenci)).rapor.celpGeldi, isFalse);
    });

    test('gelmiş tebligat öğrenciliğe dönünce askıya alınır', () {
      // Oyuncu tebligat aldıktan sonra yüksek lisansa başlarsa sayaç durur.
      var durum = baslat();
      durum = tek(durum).durum;
      expect(durum.oyuncu.celpKalanTur, isNotNull);

      durum = durum.copyWith(
        oyuncu: durum.oyuncu.kariyerDegistir(
          const KariyerDurumu.ogrenci(
            hedef: EgitimSeviyesi.yuksekLisans,
            kalanTur: 24,
          ),
        ),
      );
      expect(tek(durum).durum.oyuncu.celpKalanTur, isNull);
    });

    test('yaş aralığı dışına gelmez', () {
      expect(tek(baslat(o: oyuncu(yas: 19))).rapor.celpGeldi, isFalse);
      expect(
        tek(baslat(o: oyuncu(yas: _ayarlar.celpEnCokYas + 1))).rapor.celpGeldi,
        isFalse,
      );
    });

    test('askerliğini yapmışa gelmez', () {
      final sonuc = tek(baslat(o: oyuncu(askerlikYapildi: true)));
      expect(sonuc.rapor.celpGeldi, isFalse);
    });
  });

  group('askere alınma', () {
    test('tebligat süresi dolunca er olarak alınır', () {
      var durum = baslat();
      var alindi = false;
      for (var t = 0; t <= _ayarlar.celpTebligatTuru; t++) {
        final s = tek(durum);
        durum = s.durum;
        alindi = alindi || s.rapor.askereAlindi;
      }
      expect(alindi, isTrue);
      final askerlik = durum.oyuncu.kariyer;
      expect(askerlik, isA<Askerlik>());
      expect((askerlik as Askerlik).bedelli, isFalse);
      expect(askerlik.oncekiMeslekId, 'yazilim_gelistirici');
    });

    test('askerlikte gelir kesilir', () {
      var durum = baslat();
      for (var t = 0; t <= _ayarlar.celpTebligatTuru; t++) {
        durum = tek(durum).durum;
      }
      expect(durum.oyuncu.kariyer, isA<Askerlik>());
      expect(tek(durum).rapor.netGelir, 0);
    });

    test('terhiste eski işine iade edilir', () {
      // İşe iade olmasaydı askerlik "6 ay gelir kaybı" değil "kariyeri
      // sıfırla" cezası olurdu.
      var durum = baslat(
        o: oyuncu(
          kariyer: const KariyerDurumu.calisan(
            meslekId: 'yazilim_gelistirici',
            kademeIndeksi: 1,
          ),
        ),
      );
      var terhis = false;
      for (var t = 0; t < 20; t++) {
        final s = tek(durum);
        durum = s.durum;
        terhis = terhis || s.rapor.askerlikBitti;
        if (terhis) break;
      }
      expect(terhis, isTrue);
      final kariyer = durum.oyuncu.kariyer;
      expect(kariyer, isA<Calisan>());
      expect((kariyer as Calisan).meslekId, 'yazilim_gelistirici');
      expect(kariyer.kademeIndeksi, 1, reason: 'kademe korunmalı');
      expect(durum.oyuncu.askerlikYapildi, isTrue);
    });

    test('askerlik 6 tur gelir kesiyor', () {
      // Ölçüt "kaç tur Askerlik durumunda kaldı" değil "kaç tur geliri
      // kesildi": terhis turunda da maaş yok, ama tur sonunda durum
      // çoktan Çalışan'a dönmüş oluyor.
      var durum = baslat();
      var gelirsizTur = 0;
      for (var t = 0; t < 20; t++) {
        final s = tek(durum);
        durum = s.durum;
        if (durum.oyuncu.kariyer is Askerlik || s.rapor.askerlikBitti) {
          gelirsizTur++;
          expect(s.rapor.netGelir, 0);
        }
      }
      expect(gelirsizTur, _ayarlar.askerlikSuresi);
    });

    test('bir kez yapılır, ikinci celp gelmez', () {
      var durum = baslat();
      for (var t = 0; t < 60; t++) {
        durum = tek(durum).durum;
      }
      expect(durum.oyuncu.askerlikYapildi, isTrue);
      expect(durum.oyuncu.celpKalanTur, isNull);
      expect(durum.oyuncu.kariyer, isA<Calisan>());
    });
  });

  group('bedelli', () {
    test('parası olan tek turda kurtulur', () {
      // Bedelli süresi 1 tur: askere alınma ve terhis AYNI turda olur,
      // oyuncu bir aylık gelirini ve bedeli kaybeder.
      var durum = baslat(o: oyuncu(nakit: 400000));
      durum = tek(durum).durum; // tebligat

      final s = tek(durum, bedelliOde: true);
      expect(s.rapor.askereAlindi, isTrue);
      expect(s.rapor.askerlikBitti, isTrue);
      expect(s.durum.oyuncu.askerlikYapildi, isTrue);
      expect(s.durum.oyuncu.kariyer, isA<Calisan>());
      // Bedel gelirden düşer: o turun net geliri eksiye geçer.
      expect(s.rapor.netGelir, lessThan(0));
    });

    test('bedelli ödemesi taban TL, enflasyonla ölçeklenir', () {
      int bedel(double endeks) {
        var durum = baslat(o: oyuncu(nakit: 100000000));
        durum = tek(durum).durum;
        durum = durum.copyWith(
          piyasa: durum.piyasa.copyWith(enflasyonEndeksi: endeks),
        );
        return -tek(durum, bedelliOde: true).rapor.netGelir;
      }

      final tek1 = bedel(1.0);
      final tek4 = bedel(4.0);
      expect(tek4, greaterThan(tek1 * 3));
    });

    test('parası yetmeyen er olarak gider', () {
      var durum = baslat(o: oyuncu(nakit: 1000));
      durum = tek(durum).durum;
      for (var t = 0; t < _ayarlar.celpTebligatTuru; t++) {
        durum = tek(durum, bedelliOde: true).durum;
      }
      final askerlik = durum.oyuncu.kariyer;
      expect(askerlik, isA<Askerlik>(), reason: 'parası yetmeyen askere gider');
      expect((askerlik as Askerlik).bedelli, isFalse);
    });

    test('bedelli 5 tur gelir kurtarıyor', () {
      int gelirsizTur(bool bedelli) {
        var durum = baslat(o: oyuncu(nakit: 400000));
        durum = tek(durum).durum;
        var sayac = 0;
        for (var t = 0; t < 20; t++) {
          final s = tek(durum, bedelliOde: bedelli);
          durum = s.durum;
          if (durum.oyuncu.kariyer is Askerlik || s.rapor.askerlikBitti) {
            sayac++;
          }
        }
        return sayac;
      }

      expect(gelirsizTur(true), _ayarlar.bedelliSuresi);
      expect(gelirsizTur(false), _ayarlar.askerlikSuresi);
    });
  });

  group('işe giriş ve atama', () {
    test('kamu mesleği atama kuyruğuna alır', () {
      final durum = baslat(
        o: oyuncu(
          yas: 30, // celp yaşı dışında: askerlik karışmasın
          kariyer: const KariyerDurumu.issiz(),
        ),
      );
      final sonuc = tek(durum, iseGir: 'ogretmen');
      expect(sonuc.rapor.iseGirildi, isTrue);
      final kariyer = sonuc.durum.oyuncu.kariyer;
      expect(kariyer, isA<Issiz>());
      expect((kariyer as Issiz).atamaBekliyor, isTrue);
      expect(kariyer.bekleyenMeslekId, 'ogretmen');
    });

    test('özel sektör doğrudan işe başlatır', () {
      final durum = baslat(
        o: oyuncu(yas: 30, kariyer: const KariyerDurumu.issiz()),
      );
      final sonuc = tek(durum, iseGir: 'yazilim_gelistirici');
      expect(sonuc.durum.oyuncu.kariyer, isA<Calisan>());
    });

    test('şartı tutmayan meslek reddedilir', () {
      final durum = baslat(
        o: Oyuncu.yeni(ad: 'T', sehir: Sehir.konya, egitim: EgitimSeviyesi.lise)
            .copyWith(baslangicYasi: 30, kariyer: const KariyerDurumu.issiz()),
      );
      final sonuc = tek(durum, iseGir: 'doktor');
      expect(sonuc.rapor.iseGirildi, isFalse);
      expect(sonuc.durum.oyuncu.kariyer, isA<Issiz>());
    });

    test('askerdeyken işe girilemez', () {
      final durum = baslat(
        o: oyuncu(kariyer: const KariyerDurumu.askerlik(kalanTur: 4)),
      );
      expect(tek(durum, iseGir: 'yazilim_gelistirici').rapor.iseGirildi,
          isFalse);
    });

    test('atama en geç üst sınırda çıkar', () {
      var durum = baslat(
        o: oyuncu(
          yas: 30,
          kariyer: const KariyerDurumu.issiz(
            atamaBekliyor: true,
            bekleyenMeslekId: 'memur',
          ),
        ),
      );
      var atamaTuru = -1;
      for (var t = 0; t < 30; t++) {
        final s = tek(durum);
        durum = s.durum;
        if (s.rapor.atamasiCikti) {
          atamaTuru = t;
          break;
        }
      }
      expect(atamaTuru, greaterThanOrEqualTo(0));
      expect(atamaTuru, lessThanOrEqualTo(_ayarlar.atamaEnCokTur));
      expect(durum.oyuncu.kariyer, isA<Calisan>());
      expect((durum.oyuncu.kariyer as Calisan).meslekId, 'memur');
    });

    test('atama beklerken gelir yok', () {
      final durum = baslat(
        o: oyuncu(
          yas: 30,
          kariyer: const KariyerDurumu.issiz(
            atamaBekliyor: true,
            bekleyenMeslekId: 'memur',
          ),
        ),
      );
      expect(tek(durum).rapor.netGelir, 0);
    });

    test('atama süresi dağılımı 3-18 aralığında', () {
      final sureler = <int>[];
      for (var tohum = 0; tohum < 40; tohum++) {
        var durum = baslat(
          tohum: 5000 + tohum,
          o: oyuncu(
            yas: 30,
            kariyer: const KariyerDurumu.issiz(
              atamaBekliyor: true,
              bekleyenMeslekId: 'memur',
            ),
          ),
        );
        for (var t = 1; t <= 30; t++) {
          final s = tek(durum);
          durum = s.durum;
          if (s.rapor.atamasiCikti) {
            sureler.add(t);
            break;
          }
        }
      }
      expect(sureler, hasLength(40));
      expect(sureler.reduce((a, b) => a < b ? a : b),
          greaterThanOrEqualTo(_ayarlar.atamaEnAzTur));
      expect(sureler.reduce((a, b) => a > b ? a : b),
          lessThanOrEqualTo(_ayarlar.atamaEnCokTur + 1));
    });
  });

  group('tur atlama', () {
    test('celp ve askere alınma atlamayı keser', () {
      final sonuc = motor.turlariAtla(
        baslat(),
        TurGirdisi(zaman: ZamanDagilimi.dengeli()),
        12,
      );
      expect(sonuc.raporlar.length, lessThan(12));
      expect(sonuc.raporlar.last.celpGeldi, isTrue);
    });
  });

  group('durum taşınması', () {
    test('turIlerlet askerlik alanlarını kaybetmez', () {
      // Bu alanlar elle yeniden kurulurken düşüyordu; hata yalnız
      // "askerden dönen işsiz kaldı" olarak görünüyordu.
      const askerlik = KariyerDurumu.askerlik(
        kalanTur: 5,
        bedelli: true,
        oncekiMeslekId: 'asci',
        oncekiKademeIndeksi: 2,
      );
      final sonraki = askerlik.turIlerlet() as Askerlik;
      expect(sonraki.kalanTur, 4);
      expect(sonraki.bedelli, isTrue);
      expect(sonraki.oncekiMeslekId, 'asci');
      expect(sonraki.oncekiKademeIndeksi, 2);
    });

    test('turIlerlet atama alanlarını kaybetmez', () {
      const issiz = KariyerDurumu.issiz(
        gecenTur: 3,
        atamaBekliyor: true,
        bekleyenMeslekId: 'memur',
      );
      final sonraki = issiz.turIlerlet() as Issiz;
      expect(sonraki.gecenTur, 4);
      expect(sonraki.atamaBekliyor, isTrue);
      expect(sonraki.bekleyenMeslekId, 'memur');
    });
  });

  test('iseGir saf: motor durumu değiştirmez', () {
    final o = oyuncu(yas: 30, kariyer: const KariyerDurumu.issiz());
    final meslek = katalog.bul('ogretmen')!;
    final sonuc = kariyerMotoru.iseGir(o, meslek);
    expect(sonuc, isNotNull);
    expect(o.kariyer, isA<Issiz>());
    expect((o.kariyer as Issiz).atamaBekliyor, isFalse);
  });
}
