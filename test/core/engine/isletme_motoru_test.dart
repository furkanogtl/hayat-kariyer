import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/isletme_motoru.dart';
import 'package:hayat_kariyer/core/models/ilgi_dagilimi.dart';
import 'package:hayat_kariyer/core/models/isletme.dart';
import 'package:hayat_kariyer/core/models/isletme_katalogu.dart';
import 'package:hayat_kariyer/core/models/piyasa_durumu.dart';
import 'package:hayat_kariyer/core/rng/rastgele_kaynak.dart';

const _kafe = IsletmeTanimi(
  id: 'kafe',
  ad: 'Kafe',
  sermaye: 1000000,
  yonetimYuku: 2,
  prestij: 0.3,
  ceoMaasi: 80000,
  ceoEtkinligi: 0.7,
  baslangicStatlari: {'musteriTabani': 40},
  gelirler: [
    Kalem(
      ad: 'Ciro',
      tur: KalemTuru.stataBagli,
      taban: 300000,
      statId: 'musteriTabani',
    ),
  ],
  giderler: [
    Kalem(ad: 'Kira', taban: 40000),
    Kalem(ad: 'Malzeme', tur: KalemTuru.cirodanPay, oran: 0.35),
    Kalem(ad: 'Sigorta', taban: 24000, periyotTur: 12),
  ],
);

/// Motorun işletme türüne bakmadığını kanıtlamak için uydurma bir tanım:
/// başka statlar, başka kalem birleşimi, hiç kod değişmeden çalışmalı.
const _otel = IsletmeTanimi(
  id: 'otel',
  ad: 'Butik Otel',
  sermaye: 8000000,
  yonetimYuku: 4,
  prestij: 1.2,
  ceoMaasi: 200000,
  baslangicStatlari: {'doluluk': 50, 'personelKalitesi': 60},
  gelirler: [
    Kalem(
      ad: 'Oda geliri',
      tur: KalemTuru.stataBagli,
      taban: 2000000,
      statId: 'doluluk',
    ),
    Kalem(
      ad: 'Restoran',
      tur: KalemTuru.stataBagli,
      taban: 400000,
      statId: 'personelKalitesi',
    ),
  ],
  giderler: [
    Kalem(ad: 'İşletme', tur: KalemTuru.cirodanPay, oran: 0.45),
    Kalem(ad: 'Kadro', taban: 350000),
  ],
);

final _katalog = IsletmeKatalogu.listeden([_kafe, _otel]);
final _motor = IsletmeMotoru(katalog: _katalog);

Isletme _ornek({
  String id = 'kafe#1',
  String tanimId = 'kafe',
  Map<String, int> statlar = const {'musteriTabani': 40},
  bool ceoVar = false,
}) =>
    Isletme(
      id: id,
      tanimId: tanimId,
      kurulusTuru: 0,
      statlar: statlar,
      ceoVar: ceoVar,
    );

IsletmeTurSonucu _isle({
  required List<Isletme> isletmeler,
  required IlgiDagilimi ilgi,
  PiyasaDurumu piyasa = const PiyasaDurumu(),
  int tur = 5,
  int tohum = 77,
}) =>
    _motor.turIsle(
      isletmeler: isletmeler,
      ilgi: ilgi,
      piyasa: piyasa,
      tur: tur,
      akis: RastgeleKaynak(tohum).akis('isletme', tur: tur),
    );

void main() {
  group('ilgi kısıtı', () {
    test('CEO yükü azaltır ama sıfırlamaz', () {
      expect(_motor.gerekenIlgi(_ornek()), 2);
      expect(_motor.gerekenIlgi(_ornek(ceoVar: true)), 1);
      // Anayasanın kaldırılamaz kısıtı: bedava ilgi yok.
      expect(_motor.gerekenIlgi(_ornek(ceoVar: true)), greaterThan(0));
    });

    test('toplam ihtiyaç ilgi havuzunu aşabiliyor', () {
      // Aşamasaydı ilgi bir kısıt değil süs olurdu.
      final hepsi = [
        _ornek(id: 'a'),
        _ornek(id: 'b'),
        _ornek(id: 'c', tanimId: 'otel', statlar: {'doluluk': 50}),
      ];
      expect(
        _motor.toplamGerekenIlgi(hepsi),
        greaterThan(IlgiDagilimi.toplamPuan),
      );
    });

    test('tam ilgi statı büyütür, ilgisizlik çökertir', () {
      final tamIlgi = _isle(
        isletmeler: [_ornek()],
        ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 2}),
      );
      final ilgisiz = _isle(
        isletmeler: [_ornek()],
        ilgi: const IlgiDagilimi(),
      );
      expect(tamIlgi.isletmeler.single.stat('musteriTabani'),
          greaterThan(40));
      expect(ilgisiz.isletmeler.single.stat('musteriTabani'), lessThan(40));
    });

    test('yarım ilgi işletmeyi yerinde tutar', () {
      final sonuc = _isle(
        isletmeler: [_ornek()],
        ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 1}),
      );
      expect(sonuc.isletmeler.single.stat('musteriTabani'), 40);
    });

    test('ihmal sayacı birikir ve ilgi gelince sıfırlanır', () {
      var isletme = _ornek();
      for (var t = 0; t < 4; t++) {
        isletme = _isle(
          isletmeler: [isletme],
          ilgi: const IlgiDagilimi(),
          tur: t,
        ).isletmeler.single;
      }
      expect(isletme.ihmalTuru, 4);

      final duzelen = _isle(
        isletmeler: [isletme],
        ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 2}),
      ).isletmeler.single;
      expect(duzelen.ihmalTuru, 0);
    });

    test('kriz uyarısı yalnız eşik turunda verilir', () {
      // Her tur verilseydi bilerek ihmal eden oyuncu bir daha hiç tur
      // atlayamazdı: "1 yıl atla" sonsuza kadar ilk turda kesilirdi.
      var isletme = _ornek();
      final uyarilar = <bool>[];
      for (var t = 0; t < 6; t++) {
        final s = _isle(
          isletmeler: [isletme],
          ilgi: const IlgiDagilimi(),
          tur: t,
        );
        isletme = s.isletmeler.single;
        uyarilar.add(s.raporlar.single.krizRiski);
      }
      expect(uyarilar.where((u) => u).length, 1);
      expect(uyarilar.indexOf(true), 2); // ihmalTuru 3'e çıktığı tur
    });

    test('çöküş büyümeden hızlı', () {
      // Bir işletmeyi bırakmak, kurmaktan hızlı olmalı: aksi halde
      // "aç, unut, sonra ilgilen" bedelsiz bir strateji olurdu.
      var buyuyen = _ornek();
      var coken = _ornek();
      for (var t = 0; t < 5; t++) {
        buyuyen = _isle(
          isletmeler: [buyuyen],
          ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 2}),
          tur: t,
        ).isletmeler.single;
        coken = _isle(
          isletmeler: [coken],
          ilgi: const IlgiDagilimi(),
          tur: t,
        ).isletmeler.single;
      }
      final kazanc = buyuyen.stat('musteriTabani') - 40;
      final kayip = 40 - coken.stat('musteriTabani');
      expect(kayip, greaterThan(kazanc));
    });
  });

  group('CEO', () {
    test('maaşı gidere girer, kârı düşürür', () {
      final kendisi = _isle(
        isletmeler: [_ornek(statlar: {'musteriTabani': 90})],
        ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 2}),
      );
      final ceolu = _isle(
        isletmeler: [_ornek(statlar: {'musteriTabani': 90}, ceoVar: true)],
        ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 1}),
      );
      expect(ceolu.netNakit, lessThan(kendisi.netNakit));
      expect(ceolu.raporlar.single.giderler,
          greaterThan(kendisi.raporlar.single.giderler));
    });

    test('zimmet yalnız CEO varken olur', () {
      var ceosuzZimmet = false;
      for (var t = 0; t < 400; t++) {
        final s = _isle(
          isletmeler: [_ornek(statlar: {'musteriTabani': 90})],
          ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 2}),
          tur: t,
          tohum: 1000 + t,
        );
        if (s.raporlar.single.zimmetOldu) ceosuzZimmet = true;
      }
      expect(ceosuzZimmet, isFalse);

      var ceoluZimmet = 0;
      for (var t = 0; t < 400; t++) {
        final s = _isle(
          isletmeler: [
            _ornek(statlar: {'musteriTabani': 90}, ceoVar: true)
          ],
          ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 1}),
          tur: t,
          tohum: 1000 + t,
        );
        if (s.raporlar.single.zimmetOldu) ceoluZimmet++;
      }
      expect(ceoluZimmet, greaterThan(0));
    });
  });

  group('hesap', () {
    test('stata bağlı gelir stata orantılı', () {
      int ciro(int stat) => _isle(
            isletmeler: [_ornek(statlar: {'musteriTabani': stat})],
            ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 1}),
          ).raporlar.single.brutGelir;
      expect(ciro(50), closeTo(2 * ciro(25), 2));
    });

    test('yıllık kalem yalnız 12nin katında işler', () {
      int gider(int tur) => _isle(
            isletmeler: [_ornek()],
            ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 1}),
            tur: tur,
          ).raporlar.single.giderler;
      expect(gider(12) - gider(11), 24000);
    });

    test('gelir ve gider enflasyonla ölçeklenir', () {
      final rapor1 = _isle(
        isletmeler: [_ornek()],
        ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 1}),
      ).raporlar.single;
      final rapor2 = _isle(
        isletmeler: [_ornek()],
        ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 1}),
        piyasa: const PiyasaDurumu(enflasyonEndeksi: 4.0),
      ).raporlar.single;
      expect(rapor2.brutGelir, closeTo(rapor1.brutGelir * 4, 4));
      expect(rapor2.netKar, closeTo(rapor1.netKar * 4, 8));
    });

    test('zarar eden işletme oyuncunun cebinden yer', () {
      final sonuc = _isle(
        isletmeler: [_ornek(statlar: {'musteriTabani': 5})],
        ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 2}),
      );
      expect(sonuc.netNakit, lessThan(0));
    });

    test('prestij itibara katkı verir, ilgisizlikte kesilir', () {
      var ilgili = 0;
      var ilgisiz = 0;
      for (var t = 0; t < 60; t++) {
        ilgili += _isle(
          isletmeler: [_ornek()],
          ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 2}),
          tur: t,
          tohum: 5000 + t,
        ).itibarKatkisi;
        ilgisiz += _isle(
          isletmeler: [_ornek()],
          ilgi: const IlgiDagilimi(),
          tur: t,
          tohum: 5000 + t,
        ).itibarKatkisi;
      }
      expect(ilgili, greaterThan(0));
      expect(ilgisiz, 0);
    });
  });

  group('satış', () {
    test('satış süre dolunca tamamlanır ve işletme listeden çıkar', () {
      var isletme = _ornek(statlar: {'musteriTabani': 90})
          .copyWith(satisKalanTur: 3, yillikNetKar: 1200000);
      for (var t = 0; t < 2; t++) {
        final s = _isle(
          isletmeler: [isletme],
          ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 2}),
          tur: t,
        );
        expect(s.tamamlananSatislar, isEmpty);
        isletme = s.isletmeler.single;
      }
      final son = _isle(
        isletmeler: [isletme],
        ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 2}),
      );
      expect(son.isletmeler, isEmpty);
      expect(son.tamamlananSatislar.keys, ['kafe#1']);
      expect(son.tamamlananSatislar['kafe#1'], greaterThan(0));
    });

    test('kârlı işletme yıllık kârın katına, batık enkaza gider', () {
      const piyasa = PiyasaDurumu();
      final karli = _ornek().copyWith(yillikNetKar: 2000000);
      final batik = _ornek().copyWith(yillikNetKar: -500000);
      expect(_motor.satisDegeri(karli, piyasa), 6000000);
      // Enkaz bedeli: sermayenin %35'i. Zarar realize edilir, kaçış yok.
      expect(_motor.satisDegeri(batik, piyasa), 350000);
    });

    test('kuruluş bedeli sermayenin üstüne masraf ekler', () {
      expect(_motor.kurulusBedeli(_kafe, const PiyasaDurumu()), 1040000);
      expect(
        _motor.kurulusBedeli(_kafe, const PiyasaDurumu(enflasyonEndeksi: 2)),
        2080000,
      );
    });
  });

  group('soyutlama', () {
    test('motor işletme türüne bakmıyor', () {
      // Otel tanımı yalnız JSON'da var; iki statı, iki gelir kalemi ve
      // ciro payı gideri olan bu türü motor hiç tanımadan işleyebilmeli.
      // Bu test kırılırsa motora tür bilen bir dal girmiş demektir.
      final sonuc = _isle(
        isletmeler: [
          _ornek(
            id: 'otel#1',
            tanimId: 'otel',
            statlar: {'doluluk': 50, 'personelKalitesi': 60},
          ),
        ],
        ilgi: const IlgiDagilimi(puanlar: {'otel#1': 4}),
      );
      final otel = sonuc.isletmeler.single;
      expect(otel.stat('doluluk'), greaterThan(50));
      expect(otel.stat('personelKalitesi'), greaterThan(60));
      expect(sonuc.raporlar.single.brutGelir, greaterThan(0));
      expect(sonuc.raporlar.single.ad, 'Butik Otel');
    });

    test('birden fazla işletme aynı turda işlenir', () {
      final sonuc = _isle(
        isletmeler: [
          _ornek(id: 'kafe#1', statlar: {'musteriTabani': 80}),
          _ornek(
            id: 'otel#1',
            tanimId: 'otel',
            statlar: {'doluluk': 70, 'personelKalitesi': 60},
          ),
        ],
        ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 2, 'otel#1': 4}),
      );
      expect(sonuc.isletmeler, hasLength(2));
      expect(sonuc.raporlar, hasLength(2));
      expect(
        sonuc.netNakit,
        sonuc.raporlar.fold<int>(0, (t, r) => t + r.netKar),
      );
    });

    test('tanımı silinmiş işletme kayıttan düşmez', () {
      final sonuc = _isle(
        isletmeler: [_ornek(id: 'hayalet#1', tanimId: 'yok_boyle')],
        ilgi: const IlgiDagilimi(),
      );
      expect(sonuc.isletmeler.single.id, 'hayalet#1');
      expect(sonuc.raporlar, isEmpty);
    });
  });

  test('aynı tohum aynı sonucu verir', () {
    List<int> calistir() {
      var isletme = _ornek(ceoVar: true, statlar: {'musteriTabani': 60});
      final karlar = <int>[];
      for (var t = 0; t < 30; t++) {
        final s = _isle(
          isletmeler: [isletme],
          ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 1}),
          tur: t,
          tohum: 4242,
        );
        isletme = s.isletmeler.single;
        karlar.add(s.netNakit);
      }
      return karlar;
    }

    expect(calistir(), calistir());
  });
}
