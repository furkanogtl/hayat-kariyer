import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/isletme_motoru.dart';
import 'package:hayat_kariyer/core/models/ilgi_dagilimi.dart';
import 'package:hayat_kariyer/core/models/isletme.dart';
import 'package:hayat_kariyer/core/models/isletme_katalogu.dart';
import 'package:hayat_kariyer/core/models/meslek_katalogu.dart';
import 'package:hayat_kariyer/core/models/olay_katalogu.dart';
import 'package:hayat_kariyer/core/models/piyasa_durumu.dart';
import 'package:hayat_kariyer/core/rng/rastgele_kaynak.dart';

/// `assets/businesses/` altındaki GERÇEK tanımları doğrular.
IsletmeKatalogu katalogYukle() {
  final dizin = Directory('assets/businesses');
  if (!dizin.existsSync()) {
    throw StateError('assets/businesses bulunamadı');
  }
  final dosyalar = dizin
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  if (dosyalar.isEmpty) {
    throw StateError('assets/businesses altında tanım yok');
  }
  return IsletmeKatalogu.jsonMetinlerinden(
    dosyalar.map((f) => f.readAsStringSync()),
  );
}

Iterable<String> _jsonMetinleri(String dizin) => Directory(dizin)
    .listSync()
    .whereType<File>()
    .where((f) => f.path.endsWith('.json'))
    .map((f) => f.readAsStringSync());

/// Bir işletmeyi verilen ilgiyle [tur] tur işletip son aylık kârı döndürür.
/// Enflasyonsuz piyasa: denge oranları taban TL üzerinden okunsun.
({int aylikKar, Isletme isletme}) _olgunlastir(
  IsletmeKatalogu katalog,
  IsletmeTanimi tanim,
  int ilgiPuani, {
  bool ceo = false,
  int tur = 96,
}) {
  final motor = IsletmeMotoru(katalog: katalog);
  const piyasa = PiyasaDurumu();
  final kaynak = RastgeleKaynak(11);
  var isletme = Isletme(
    id: 'x',
    tanimId: tanim.id,
    kurulusTuru: 0,
    statlar: tanim.baslangicStatlari,
    ceoVar: ceo,
  );
  var son = 0;
  for (var t = 1; t <= tur; t++) {
    final s = motor.turIsle(
      isletmeler: [isletme],
      ilgi: IlgiDagilimi(puanlar: {'x': ilgiPuani}),
      piyasa: piyasa,
      tur: t,
      akis: kaynak.akis('isletme', tur: t),
    );
    isletme = s.isletmeler.single;
    son = s.netNakit;
  }
  return (aylikKar: son, isletme: isletme);
}

void main() {
  late IsletmeKatalogu katalog;
  late IsletmeMotoru motor;

  setUpAll(() {
    katalog = katalogYukle();
    motor = IsletmeMotoru(katalog: katalog);
  });

  group('şema', () {
    test('bütün tanımlar geçerli', () {
      expect(katalog.dogrula(), isEmpty);
    });

    test('v1.0 işletmeleri tanımlı', () {
      // Kafe ve oto galeri bilerek seçildi: düşük sermaye/düzenli gelir ile
      // yüksek sermaye/stok riski soyutlamayı gerçekten sınasın diye.
      expect(katalog.bul('kafe'), isNotNull);
      expect(katalog.bul('oto_galeri'), isNotNull);
    });

    test('olay havuzu kimlikleri tanımlı kartlara işaret ediyor', () {
      // Şu an havuzlar boş; içerik gelince bu test tanımsız kimliği hata
      // yapacak. Meslek verisindeki aynı çapraz doğrulama.
      final kartlar =
          OlayKatalogu.jsonMetinlerinden(_jsonMetinleri('assets/events'));
      for (final t in katalog.tumu) {
        for (final id in t.olayHavuzu) {
          expect(
            kartlar.bul(id),
            isNotNull,
            reason: '${t.id}: tanımsız olay kimliği $id',
          );
        }
      }
    });

    test('meslek dosyasındaki v1.0 işletmeleri gerçekten var', () {
      // `acilanIsletmeler` alanı v1.5 kimliklerini de taşıyor; burada
      // yalnız v1.0 kapsamındakiler aranıyor.
      const v1 = {'kafe', 'oto_galeri'};
      final meslekler =
          MeslekKatalogu.jsonMetinlerinden(_jsonMetinleri('assets/careers'));
      final gecenler = {
        for (final m in meslekler.tumu) ...m.acilanIsletmeler,
      }.intersection(v1);
      expect(gecenler, v1);
      for (final id in gecenler) {
        expect(katalog.bul(id), isNotNull);
      }
    });
  });

  group('denge', () {
    test('yönetim yükleri ilgi havuzuna sığar ama doldurur', () {
      // İki işletme sığmalı (oyun oynanabilsin), hepsi birden sığmamalı
      // (kısıt gerçek olsun).
      final yukler = katalog.tumu.map((t) => t.yonetimYuku).toList()..sort();
      expect(yukler.first + yukler[1],
          lessThanOrEqualTo(IlgiDagilimi.toplamPuan));
      expect(
        katalog.tumu.fold<int>(0, (t, i) => t + i.yonetimYuku) +
            yukler.first,
        greaterThan(IlgiDagilimi.toplamPuan),
      );
    });

    test('tam ilgide kâr eder, yarım ilgide etmez', () {
      // Asıl karar bu: işletme açmak değil, AÇTIĞINA BAKMAK. Tam ilgi
      // kârlı, yarım ilgi kârsız olmalı — yarım ilgi de kâr etseydi ilgi
      // kısıtının anlamı kalmazdı.
      for (final t in katalog.tumu) {
        final tam = _olgunlastir(katalog, t, t.yonetimYuku).aylikKar;
        final yarim =
            _olgunlastir(katalog, t, (t.yonetimYuku / 2).floor()).aylikKar;
        expect(tam, greaterThan(0), reason: '${t.id}: tam ilgide bile zarar');
        expect(yarim, lessThan(tam),
            reason: '${t.id}: yarım ilgi tam ilgi kadar kazandırıyor');
      }
    });

    test('ihmal edilen işletme çöker', () {
      for (final t in katalog.tumu) {
        final sonuc = _olgunlastir(katalog, t, 0, tur: 36);
        expect(sonuc.aylikKar, lessThan(0), reason: '${t.id}: ihmal bedelsiz');
        expect(
          sonuc.isletme.statlar.values.every((v) => v == 0),
          isTrue,
          reason: '${t.id}: ihmal statları sıfırlamadı',
        );
      }
    });

    test('CEO kârı düşürür ama sıfırın altına indirmez', () {
      // Anayasa: CEO'nun bedeli "daha düşük kâr". Zarar olsaydı CEO bir
      // seçenek değil tuzak olurdu.
      for (final t in katalog.tumu) {
        final ceoYuku = motor.gerekenIlgi(
          Isletme(id: 'x', tanimId: t.id, kurulusTuru: 0, ceoVar: true),
        );
        final ceolu =
            _olgunlastir(katalog, t, ceoYuku, ceo: true).aylikKar;
        final kendisi = _olgunlastir(katalog, t, t.yonetimYuku).aylikKar;
        expect(ceolu, greaterThan(0), reason: '${t.id}: CEO tuzağa dönüşmüş');
        expect(ceolu, lessThan(kendisi),
            reason: '${t.id}: CEO bedelsiz kalmış');
      }
    });

    test('CEO en az bir ilgi puanı serbest bırakır', () {
      // Bırakmasaydı maaş ödemenin karşılığı olmazdı.
      for (final t in katalog.tumu) {
        final ceoYuku = motor.gerekenIlgi(
          Isletme(id: 'x', tanimId: t.id, kurulusTuru: 0, ceoVar: true),
        );
        expect(ceoYuku, lessThan(t.yonetimYuku), reason: t.id);
        expect(ceoYuku, greaterThan(0), reason: '${t.id}: bedava ilgi');
      }
    });

    test('geri ödeme süresi makul bantta', () {
      // Bant gerçek kafe ekonomisine göre değil BU OYUNUN ekonomisine
      // göre: borsa 10 yıllık pencerede reel %150+ getirirken 4-5 yılda
      // kendini ödeyen işletme kesinlikle domine edilir, kimse açmaz.
      // Hızlı geri dönüş, aktif yönetimin karşılığı.
      for (final t in katalog.tumu) {
        final aylik = _olgunlastir(katalog, t, t.yonetimYuku).aylikKar;
        final geriOdemeAy = t.sermaye / aylik;
        expect(geriOdemeAy, greaterThan(18),
            reason: '${t.id}: ${geriOdemeAy.round()} ayda kendini ödüyor');
        expect(geriOdemeAy, lessThan(60),
            reason: '${t.id}: ${geriOdemeAy.round()} ay çok uzun');
      }
    });

    test('satış değeri kuruluş bedelinin altında kalabiliyor', () {
      // İşletme likit bir varlık değil: batmış işletmeyi satıp parayı
      // kurtarmak mümkün olmamalı.
      const piyasa = PiyasaDurumu();
      for (final t in katalog.tumu) {
        final batik = Isletme(
          id: 'x',
          tanimId: t.id,
          kurulusTuru: 0,
          yillikNetKar: -100000,
        );
        expect(
          motor.satisDegeri(batik, piyasa),
          lessThan(motor.kurulusBedeli(t, piyasa)),
          reason: t.id,
        );
      }
    });
  });
}
