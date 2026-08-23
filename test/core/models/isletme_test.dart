import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/models/isletme.dart';
import 'package:hayat_kariyer/core/models/isletme_katalogu.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/sektor.dart';

const _gecerliTanim = IsletmeTanimi(
  id: 'kafe',
  ad: 'Kafe',
  sermaye: 1000000,
  ceoMaasi: 80000,
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
  ],
);

void main() {
  group('Kalem', () {
    test('periyot 1 her turda işler', () {
      const k = Kalem(ad: 'Kira', taban: 1000);
      expect([for (var t = 0; t < 5; t++) k.isliyorMu(t)],
          everyElement(isTrue));
    });

    test('yıllık kalem yalnız 12 turda bir işler', () {
      const k = Kalem(ad: 'Sigorta', taban: 30000, periyotTur: 12);
      expect(k.isliyorMu(12), isTrue);
      expect(k.isliyorMu(24), isTrue);
      expect(k.isliyorMu(13), isFalse);
      expect([for (var t = 1; t < 12; t++) k.isliyorMu(t)],
          everyElement(isFalse));
    });

    test('stata bağlı kalemde statId zorunlu', () {
      const k = Kalem(ad: 'Ciro', tur: KalemTuru.stataBagli, taban: 100);
      expect(k.dogrula('x', {}), contains(contains('statId yok')));
    });

    test('tanımsız stata gönderme yakalanır', () {
      const k = Kalem(
        ad: 'Ciro',
        tur: KalemTuru.stataBagli,
        taban: 100,
        statId: 'doluluk',
      );
      expect(
        k.dogrula('x', {'musteriTabani'}),
        contains(contains('tanımsız stat doluluk')),
      );
    });

    test('ciro payı 0-1 dışında olamaz', () {
      const k = Kalem(ad: 'Malzeme', tur: KalemTuru.cirodanPay, oran: 1.4);
      expect(k.dogrula('x', {}), isNotEmpty);
    });
  });

  group('IsletmeTanimi.dogrula', () {
    test('geçerli tanım hata vermez', () {
      expect(_gecerliTanim.dogrula(), isEmpty);
    });

    test('gelirsiz işletme reddedilir', () {
      expect(
        _gecerliTanim.copyWith(gelirler: []).dogrula(),
        contains(contains('gelir kalemi yok')),
      );
    });

    test('ciro payları toplamı 1i geçemez', () {
      // Geçseydi işletme cirosu ne olursa olsun her ay zarar ederdi;
      // veri hatası oyunu sessizce oynanamaz kılardı.
      final t = _gecerliTanim.copyWith(
        giderler: const [
          Kalem(ad: 'a', tur: KalemTuru.cirodanPay, oran: 0.6),
          Kalem(ad: 'b', tur: KalemTuru.cirodanPay, oran: 0.5),
        ],
      );
      expect(t.dogrula(), contains(contains('cirodan pay giderleri')));
    });

    test('stat 0-100 dışında olamaz', () {
      final t = _gecerliTanim
          .copyWith(baslangicStatlari: {'musteriTabani': 140});
      expect(t.dogrula(), contains(contains('0-100 dışında')));
    });

    test('yönetim yükü en az 1', () {
      // Sıfır yüklü işletme "bedava gelir" demektir; anayasanın ilgi
      // kısıtını veri dosyasından delmenin yolu kapalı olmalı.
      expect(
        _gecerliTanim.copyWith(yonetimYuku: 0).dogrula(),
        contains(contains('yönetim yükü')),
      );
    });

    test('ceo etkinliği 1 olamaz', () {
      // 1 olsaydı CEO yönetim yükünü tamamen sıfırlardı: para ödeyen
      // oyuncu sınırsız işletme açardı.
      expect(
        _gecerliTanim.copyWith(ceoEtkinligi: 1.0).dogrula(),
        contains(contains('ceoEtkinligi')),
      );
    });
  });

  group('IsletmeGirisSarti', () {
    final oyuncu = Oyuncu(
      ad: 'test',
      sehir: Sehir.konya,
      tur: 12 * 12,
      kariyer: const KariyerDurumu.calisan(meslekId: 'asci'),
      itibar: 25,
      yetkinlikler: const {Sektor.esnaf: 40},
    );

    test('şartsız giriş herkese açık', () {
      expect(const IsletmeGirisSarti().karsilaniyorMu(oyuncu), isTrue);
    });

    test('yaş, itibar ve yetkinlik ayrı ayrı kapı', () {
      expect(
        const IsletmeGirisSarti(enAzYas: 40).karsilaniyorMu(oyuncu),
        isFalse,
      );
      expect(
        const IsletmeGirisSarti(itibar: 50).karsilaniyorMu(oyuncu),
        isFalse,
      );
      expect(
        const IsletmeGirisSarti(sektor: Sektor.esnaf, yetkinlik: 60)
            .karsilaniyorMu(oyuncu),
        isFalse,
      );
      expect(
        const IsletmeGirisSarti(sektor: Sektor.esnaf, yetkinlik: 30)
            .karsilaniyorMu(oyuncu),
        isTrue,
      );
    });

    test('başka sektörün yetkinliği işe yaramaz', () {
      expect(
        const IsletmeGirisSarti(sektor: Sektor.finans, yetkinlik: 10)
            .karsilaniyorMu(oyuncu),
        isFalse,
      );
    });
  });

  group('Isletme örneği', () {
    const ornek = Isletme(
      id: 'kafe#1',
      tanimId: 'kafe',
      kurulusTuru: 40,
      statlar: {'musteriTabani': 35},
    );

    test('stat sınırları korunur', () {
      expect(ornek.statDegistir('musteriTabani', 90).stat('musteriTabani'), 100);
      expect(ornek.statDegistir('musteriTabani', -90).stat('musteriTabani'), 0);
    });

    test('tanımsız stat sıfırdan başlar', () {
      expect(ornek.stat('doluluk'), 0);
      expect(ornek.statDegistir('doluluk', 20).stat('doluluk'), 20);
    });

    test('satışa çıkmamış işletme satışta değil', () {
      expect(ornek.satista, isFalse);
      expect(ornek.copyWith(satisKalanTur: 3).satista, isTrue);
    });

    test('bozuk kayıt düzeltilir', () {
      const bozuk = Isletme(
        id: 'x',
        tanimId: 'kafe',
        kurulusTuru: 0,
        statlar: {'a': 250, 'b': -30},
        ihmalTuru: -5,
      );
      final duzgun = bozuk.duzelt();
      expect(duzgun.stat('a'), 100);
      expect(duzgun.stat('b'), 0);
      expect(duzgun.ihmalTuru, 0);
    });

    test('JSON round-trip', () {
      final d = ornek.copyWith(ceoVar: true, satisKalanTur: 2, sonNetKar: -4000);
      expect(Isletme.fromJson(d.toJson()), d);
    });
  });

  group('IsletmeKatalogu', () {
    test('JSON dizisinden okur', () {
      final k = IsletmeKatalogu.jsonMetinlerinden([
        '[{"id":"kafe","ad":"Kafe","sermaye":1000,"ceoMaasi":100,'
            '"gelirler":[{"ad":"Ciro","taban":500}]}]',
      ]);
      expect(k.uzunluk, 1);
      expect(k.bul('kafe')?.ad, 'Kafe');
      expect(k.bul('yok'), isNull);
    });

    test('yinelenen kimlik yakalanır', () {
      final k = IsletmeKatalogu.listeden([
        _gecerliTanim,
        _gecerliTanim.copyWith(ad: 'İkinci Kafe'),
      ]);
      expect(k.cakisanKimlikler, ['kafe']);
      expect(k.dogrula(), contains(contains('yinelenen')));
    });

    test('acilabilirler yalnız şartı tutanları verir', () {
      final oyuncu = Oyuncu(
        ad: 'test',
        sehir: Sehir.konya,
        tur: 12 * 12,
        itibar: 15,
      );
      final k = IsletmeKatalogu.listeden([
        _gecerliTanim,
        _gecerliTanim.copyWith(
          id: 'otel',
          girisSarti: const IsletmeGirisSarti(itibar: 60),
        ),
      ]);
      expect(k.acilabilirler(oyuncu).map((t) => t.id), ['kafe']);
    });

    test('sermaye acilabilirleri filtrelemez', () {
      // Parası olmayan oyuncu da neyin var olduğunu görmeli: hedef
      // koyabilmesi için liste görünür, satın alma ayrı kapı.
      final beszParasiz = Oyuncu(
        ad: 'test',
        sehir: Sehir.konya,
        tur: 12 * 12,
        nakit: 0,
        itibar: 15,
      );
      final k = IsletmeKatalogu.listeden([_gecerliTanim]);
      expect(k.acilabilirler(beszParasiz), hasLength(1));
    });
  });
}
