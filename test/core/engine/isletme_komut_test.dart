import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/isletme_motoru.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/ilgi_dagilimi.dart';
import 'package:hayat_kariyer/core/models/isletme_katalogu.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/meslek_katalogu.dart';
import 'package:hayat_kariyer/core/models/oyun_durumu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/sektor.dart';
import 'package:hayat_kariyer/core/models/zaman_dagilimi.dart';

/// İşletme AÇMA / SATMA / CEO komutları.
///
/// Motorda `kurulusBedeli`, `satisDegeri` ve `ceoVar` baştan vardı ama
/// oyuncunun bunlara ulaşacağı bir kapı yoktu. Buradaki testler kapının
/// sözleşmesini tutuyor.
void main() {
  String oku(String klasor) => Directory(klasor)
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .map((f) => f.readAsStringSync())
      .join('\n---\n');

  final meslekler = MeslekKatalogu.jsonMetinlerinden(
    Directory('assets/careers')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .map((f) => f.readAsStringSync()),
  );
  final isletmeler = IsletmeKatalogu.jsonMetinlerinden(
    Directory('assets/businesses')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .map((f) => f.readAsStringSync()),
  );
  final motor = TurProcessor(
    katalog: meslekler,
    isletme: IsletmeMotoru(katalog: isletmeler),
  );
  final isletmeMotoru = motor.isletme!;

  OyunDurumu baslat({int nakit = 20000000, int itibar = 60}) {
    final oyuncu = Oyuncu.yeni(
      ad: 'Test',
      sehir: Sehir.konya,
      egitim: EgitimSeviyesi.lisans,
    ).copyWith(
      nakit: nakit,
      itibar: itibar,
      baslangicYasi: 30,
      kariyer: const KariyerDurumu.calisan(meslekId: 'yazilim_gelistirici'),
      yetkinlikler: {for (final s in Sektor.values) s: 80},
    );
    return motor.yeniOyun(oyuncu: oyuncu, anaTohum: 77);
  }

  TurSonucu isle(OyunDurumu durum, {IsletmeKomutu? komut}) => motor.turuBitir(
        durum,
        TurGirdisi(
          zaman: ZamanDagilimi.dengeli(),
          isletmeKomutu: komut,
        ),
      );

  final kafe = isletmeler.tumu.first;

  group('açma', () {
    test('işletme kuruluyor, bedel nakitten düşüyor', () {
      final durum = baslat();
      final bedel = isletmeMotoru.kurulusBedeli(kafe, durum.piyasa);
      final sonuc = isle(durum, komut: IsletmeAc(kafe.id));

      expect(sonuc.durum.isletmeler, hasLength(1));
      expect(sonuc.rapor.kurulanIsletmeId, isNotNull);
      expect(sonuc.rapor.isletmeHatasi, isNull);
      // Kuruluş bedeli o turun nakit akışına girmiş olmalı.
      final bedelsiz = isle(durum);
      expect(
        sonuc.durum.oyuncu.nakit,
        lessThan(bedelsiz.durum.oyuncu.nakit - bedel ~/ 2),
      );
    });

    test('kimlik turdan türetiliyor', () {
      // Rastgele kimlik kaydı tekrar üretilemez hale getirirdi.
      final sonuc = isle(baslat(), komut: IsletmeAc(kafe.id));
      expect(sonuc.durum.isletmeler.single.id, '${kafe.id}_1');
      expect(sonuc.durum.isletmeler.single.kurulusTuru, 1);
    });

    test('parası yetmeyen açamıyor ve sebebini öğreniyor', () {
      final sonuc = isle(baslat(nakit: 1000), komut: IsletmeAc(kafe.id));
      expect(sonuc.durum.isletmeler, isEmpty);
      expect(sonuc.rapor.isletmeHatasi, IsletmeHatasi.yetersizNakit);
    });

    test('şartları tutmayan açamıyor', () {
      final sonuc = isle(baslat(itibar: 0), komut: IsletmeAc(kafe.id));
      if (kafe.girisSarti.itibar > 0) {
        expect(sonuc.rapor.isletmeHatasi, IsletmeHatasi.sartlarTutmuyor);
        expect(sonuc.durum.isletmeler, isEmpty);
      }
    });

    test('tanımsız işletme sessizce açılmıyor', () {
      final sonuc = isle(baslat(), komut: const IsletmeAc('yok_boyle'));
      expect(sonuc.rapor.isletmeHatasi, IsletmeHatasi.tanimsizIsletme);
      expect(sonuc.durum.isletmeler, isEmpty);
    });

    test('kuruluş turunda işletme motoru da çalışıyor', () {
      // İlk işletme kurulduğunda liste turun başında boştu; motorun
      // atlanıp durumun yazılmaması sessiz bir kayıp olurdu.
      final sonuc = isle(baslat(), komut: IsletmeAc(kafe.id));
      expect(sonuc.durum.isletmeler.single.guncelDeger, greaterThan(0));
    });
  });

  group('satış', () {
    test('satışa çıkan işletme devir kuyruğuna giriyor', () {
      var durum = isle(baslat(), komut: IsletmeAc(kafe.id)).durum;
      final id = durum.isletmeler.single.id;
      durum = durum.copyWith(ilgi: IlgiDagilimi(puanlar: {id: 2}));

      final sonuc = isle(durum, komut: IsletmeSat(id));
      expect(sonuc.rapor.satisaCikanIsletmeId, id);
      expect(sonuc.durum.isletmeler.single.satista, isTrue);
    });

    test('devir tamamlanınca işletme gidiyor, ilgi serbest kalıyor', () {
      var durum = isle(baslat(), komut: IsletmeAc(kafe.id)).durum;
      final id = durum.isletmeler.single.id;
      durum = durum.copyWith(ilgi: IlgiDagilimi(puanlar: {id: 2}));
      durum = isle(durum, komut: IsletmeSat(id)).durum;

      var devirGeliri = 0;
      for (var t = 0; t < 6 && durum.isletmeler.isNotEmpty; t++) {
        final sonuc = isle(durum);
        durum = sonuc.durum;
        devirGeliri += sonuc.rapor.devredilenIsletmeler.values
            .fold<int>(0, (a, b) => a + b);
      }
      expect(durum.isletmeler, isEmpty);
      expect(devirGeliri, greaterThan(0));
      expect(durum.ilgi.puan(id), 0);
    });

    test('satıştaki işletme ikinci kez satışa çıkarılamıyor', () {
      var durum = isle(baslat(), komut: IsletmeAc(kafe.id)).durum;
      final id = durum.isletmeler.single.id;
      durum = isle(durum, komut: IsletmeSat(id)).durum;
      final kalan = durum.isletmeler.single.satisKalanTur;

      durum = isle(durum, komut: IsletmeSat(id)).durum;
      // Sayaç sıfırlanmamalı: ikinci emir devri baştan başlatmaz.
      expect(durum.isletmeler.single.satisKalanTur, lessThan(kalan!));
    });
  });

  group('CEO', () {
    test('CEO atanıyor ve ilgi yükü düşüyor', () {
      var durum = isle(baslat(), komut: IsletmeAc(kafe.id)).durum;
      final id = durum.isletmeler.single.id;
      final oncekiYuk = isletmeMotoru.gerekenIlgi(durum.isletmeler.single);

      durum = isle(durum, komut: CeoAyarla(id, ceoVar: true)).durum;
      expect(durum.isletmeler.single.ceoVar, isTrue);
      final sonrakiYuk = isletmeMotoru.gerekenIlgi(durum.isletmeler.single);
      expect(sonrakiYuk, lessThan(oncekiYuk));
      // Yük SIFIRLANMIYOR: bedava ilgi diye bir şey yok.
      expect(sonrakiYuk, greaterThan(0));
    });

    test('CEO görevden alınabiliyor', () {
      var durum = isle(baslat(), komut: IsletmeAc(kafe.id)).durum;
      final id = durum.isletmeler.single.id;
      durum = isle(durum, komut: CeoAyarla(id, ceoVar: true)).durum;
      durum = isle(durum, komut: CeoAyarla(id, ceoVar: false)).durum;
      expect(durum.isletmeler.single.ceoVar, isFalse);
    });

    test('satıştaki işletmeye CEO atanmıyor', () {
      // Devri beklerken yönetim değiştirmek yalnız maaş gideri yaratırdı.
      var durum = isle(baslat(), komut: IsletmeAc(kafe.id)).durum;
      final id = durum.isletmeler.single.id;
      durum = isle(durum, komut: IsletmeSat(id)).durum;
      durum = isle(durum, komut: CeoAyarla(id, ceoVar: true)).durum;
      expect(durum.isletmeler.single.ceoVar, isFalse);
    });
  });

  test('işletme komutu tur atlamayı kesiyor', () {
    // Tek seferlik komut 12 kez işlenmemeli; ayrıca kuruluş oyuncunun
    // dönüm noktası, farkında olmadan üstünden geçilmesin.
    final sonuc = motor.turlariAtla(
      baslat(),
      TurGirdisi(
        zaman: ZamanDagilimi.dengeli(),
        isletmeKomutu: IsletmeAc(kafe.id),
      ),
      12,
    );
    expect(sonuc.raporlar, hasLength(1));
    expect(sonuc.durum.isletmeler, hasLength(1));
  });

  test('veri dosyaları okunabiliyor', () {
    expect(oku('assets/businesses'), isNotEmpty);
    expect(isletmeler.tumu.length, greaterThanOrEqualTo(2));
  });
}
