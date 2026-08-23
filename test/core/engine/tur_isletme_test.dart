import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/isletme_motoru.dart';
import 'package:hayat_kariyer/core/engine/olay_motoru.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/ilgi_dagilimi.dart';
import 'package:hayat_kariyer/core/models/isletme.dart';
import 'package:hayat_kariyer/core/models/isletme_katalogu.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/meslek_katalogu.dart';
import 'package:hayat_kariyer/core/models/olay_katalogu.dart';
import 'package:hayat_kariyer/core/models/oyun_durumu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/zaman_dagilimi.dart';
import 'package:hayat_kariyer/core/rng/rastgele_kaynak.dart';

/// İşletme sisteminin boru hattına bağlandığını doğrular: modeller ve motor
/// ayrı ayrı çalışsa da "turu bitir"e basınca gerçekten para hareket etmeli.
MeslekKatalogu _meslekler() => MeslekKatalogu.jsonMetinlerinden(
      Directory('assets/careers')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .map((f) => f.readAsStringSync()),
    );

IsletmeKatalogu _isletmeler() => IsletmeKatalogu.jsonMetinlerinden(
      Directory('assets/businesses')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .map((f) => f.readAsStringSync()),
    );

OlayKatalogu _kartlar() => OlayKatalogu.jsonMetinlerinden(
      Directory('assets/events')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .map((f) => f.readAsStringSync()),
    );

void main() {
  final isletmeKatalogu = _isletmeler();
  final isletmeMotoru = IsletmeMotoru(katalog: isletmeKatalogu);
  final motor = TurProcessor(
    katalog: _meslekler(),
    isletme: isletmeMotoru,
  );
  final kafeTanimi = isletmeKatalogu.bul('kafe')!;

  Oyuncu oyuncu({int nakit = 2000000}) => Oyuncu.yeni(
        ad: 'Test',
        sehir: Sehir.konya,
        egitim: EgitimSeviyesi.lisans,
      ).copyWith(
        nakit: nakit,
        itibar: 30,
        kariyer: const KariyerDurumu.calisan(meslekId: 'memur'),
      );

  Isletme kafe({int musteri = 60, bool ceo = false}) => Isletme(
        id: 'kafe#1',
        tanimId: 'kafe',
        kurulusTuru: 0,
        statlar: {...kafeTanimi.baslangicStatlari, 'musteriTabani': musteri},
        ceoVar: ceo,
      );

  OyunDurumu baslat({
    List<Isletme> isletmeler = const [],
    IlgiDagilimi ilgi = const IlgiDagilimi(),
    int nakit = 2000000,
  }) =>
      motor
          .yeniOyun(oyuncu: oyuncu(nakit: nakit), anaTohum: 909)
          .copyWith(isletmeler: isletmeler, ilgi: ilgi);

  TurSonucu tek(OyunDurumu d) =>
      motor.turuBitir(d, TurGirdisi(zaman: ZamanDagilimi.dengeli()));

  group('boru hattı', () {
    test('işletmesiz oyun etkilenmez', () {
      final rapor = tek(baslat()).rapor;
      expect(rapor.isletmeKari, 0);
      expect(rapor.isletmeRaporlari, isEmpty);
    });

    test('kârlı işletme nakite yansır', () {
      final ilgili = tek(
        baslat(
          isletmeler: [kafe(musteri: 100)],
          ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 2}),
        ),
      );
      final isletmesiz = tek(baslat());
      expect(ilgili.rapor.isletmeKari, greaterThan(0));
      expect(
        ilgili.rapor.nakitDegisimi,
        isletmesiz.rapor.nakitDegisimi + ilgili.rapor.isletmeKari,
      );
    });

    test('zarar eden işletme nakitten yer', () {
      final sonuc = tek(
        baslat(
          isletmeler: [kafe(musteri: 10)],
          ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 2}),
        ),
      );
      expect(sonuc.rapor.isletmeKari, lessThan(0));
      expect(sonuc.durum.oyuncu.nakit, lessThan(2000000));
    });

    test('işletme değeri net değere girer', () {
      final durum = baslat(
        isletmeler: [kafe(musteri: 100)],
        ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 2}),
      );
      final sonra = tek(durum).durum;
      expect(sonra.isletmeDegeri, greaterThan(0));
      expect(
        sonra.netDeger,
        sonra.oyuncu.nakit + sonra.portfoyDegeri + sonra.isletmeDegeri,
      );
    });

    test('prestij itibarı yükseltir', () {
      // Mutlak artış aranmıyor: network'e puan ayrılmayan turda itibar
      // zaten aşınıyor (-0,6/tur) ve kafenin prestiji (0,3/tur) bunu tek
      // başına karşılamıyor. Doğru soru "işletme olmasaydı ne olurdu".
      int itibarSonu({required bool isletmeliMi}) {
        var durum = baslat(
          isletmeler: isletmeliMi ? [kafe()] : const [],
          ilgi: isletmeliMi
              ? const IlgiDagilimi(puanlar: {'kafe#1': 2})
              : const IlgiDagilimi(),
        );
        for (var t = 0; t < 24; t++) {
          durum = motor
              .turuBitir(
                durum,
                const TurGirdisi(
                  zaman: ZamanDagilimi(calisma: 6, dinlenme: 4),
                ),
              )
              .durum;
        }
        return durum.oyuncu.itibar;
      }

      expect(
        itibarSonu(isletmeliMi: true),
        greaterThan(itibarSonu(isletmeliMi: false)),
      );
    });
  });

  group('satış', () {
    test('devir tamamlanınca para gelir, ilgi puanı serbest kalır', () {
      var durum = baslat(
        isletmeler: [
          kafe(musteri: 100).copyWith(
            satisKalanTur: kafeTanimi.satisSuresiTur,
            yillikNetKar: 900000,
          ),
        ],
        ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 2}),
      );

      TurSonucu sonuc;
      var devirTuru = -1;
      for (var t = 0; t < kafeTanimi.satisSuresiTur; t++) {
        sonuc = tek(durum);
        durum = sonuc.durum;
        if (sonuc.rapor.devredilenIsletmeler.isNotEmpty) {
          devirTuru = t;
          expect(sonuc.rapor.devredilenIsletmeler['kafe#1'], greaterThan(0));
          break;
        }
      }
      expect(devirTuru, kafeTanimi.satisSuresiTur - 1);
      expect(durum.isletmeler, isEmpty);
      // Satılan işletmeye puan ayırmaya devam edilmemeli.
      expect(durum.ilgi.puan('kafe#1'), 0);
      expect(durum.ilgi.bosPuan, IlgiDagilimi.toplamPuan);
    });
  });

  group('tur atlama', () {
    test('ihmal krizi atlamayı keser', () {
      // Oyuncu farkında olmadan işletmesini batırmasın: kriz eşiğine
      // gelince "1 yıl atla" durur.
      final durum = baslat(
        isletmeler: [kafe()],
        ilgi: const IlgiDagilimi(),
      );
      final sonuc = motor.turlariAtla(
        durum,
        TurGirdisi(zaman: ZamanDagilimi.dengeli()),
        12,
      );
      expect(sonuc.raporlar.length, lessThan(12));
      expect(sonuc.raporlar.last.isletmeRaporlari.single.krizRiski, isTrue);
    });

    test('ilgi gören işletme atlamayı kesmez', () {
      final durum = baslat(
        isletmeler: [kafe()],
        ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 2}),
      );
      final sonuc = motor.turlariAtla(
        durum,
        TurGirdisi(zaman: ZamanDagilimi.dengeli()),
        12,
      );
      expect(sonuc.raporlar.length, 12);
    });
  });

  group('işletme kartları', () {
    final olayKatalogu = _kartlar();
    final olayMotoru = OlayMotoru(
      katalog: olayKatalogu,
      isletmeKartlari: isletmeKatalogu.olayHavuzuDizini(),
    );
    final denetim = olayKatalogu.bul('kafe_zabita_denetimi_01')!;
    final baristaKarti = olayKatalogu.bul('kafe_usta_barista_ayrildi_01')!;

    test('işletmesi olmayana işletme kartı çıkmaz', () {
      final havuz = olayMotoru.uygunKartlar(baslat());
      expect(havuz.map((o) => o.id), isNot(contains(denetim.id)));
      // Genel kartlar etkilenmemeli.
      expect(havuz, isNotEmpty);
    });

    test('kafesi olana çıkar, galeri kartı yine çıkmaz', () {
      final havuz = olayMotoru.uygunKartlar(
        baslat(isletmeler: [kafe()]),
      );
      final kimlikler = havuz.map((o) => o.id);
      expect(kimlikler, contains(denetim.id));
      expect(kimlikler, isNot(contains('galeri_stok_bayatladi_01')));
    });

    test('ihmal kartı yalnız ihmal edilmiş işletmeye çıkar', () {
      final bakilan = baslat(isletmeler: [kafe()]);
      final ihmalEdilen =
          baslat(isletmeler: [kafe().copyWith(ihmalTuru: 3)]);
      expect(
        olayMotoru.uygunKartlar(bakilan).map((o) => o.id),
        isNot(contains(baristaKarti.id)),
      );
      expect(
        olayMotoru.uygunKartlar(ihmalEdilen).map((o) => o.id),
        contains(baristaKarti.id),
      );
    });

    test('seçim hedef işletmenin statını değiştirir', () {
      final durum = baslat(isletmeler: [kafe(musteri: 70)]);
      final sonuc = olayMotoru.secimYap(
        durum,
        olayKatalogu.bul('kafe_tedarikci_zammi_01')!,
        0, // "Menüye yansıt": musteriTabani -5
        RastgeleKaynak(1).akis('olay', tur: 1),
      );
      expect(sonuc.durum.isletmeler.single.stat('musteriTabani'), 65);
    });

    test('gecikmeli sonuç aynı işletmeye vurur', () {
      // Oyuncu bu arada ikinci bir kafe açmış olabilir; sonuç kararın
      // verildiği işletmeye uygulanmalı.
      var durum = baslat(isletmeler: [kafe(musteri: 70)]);
      final akis = RastgeleKaynak(7).akis('olay', tur: 1);
      durum = olayMotoru
          .secimYap(durum, olayKatalogu.bul('kafe_sahne_gecesi_01')!, 0, akis)
          .durum;
      expect(durum.bekleyenOlaylar.single.hedefIsletmeId, 'kafe#1');

      // İkinci kafe açılıyor ve bekleme bitiyor.
      durum = durum.copyWith(
        isletmeler: [
          ...durum.isletmeler,
          kafe(musteri: 40).copyWith(id: 'kafe#2'),
        ],
        bekleyenOlaylar: [
          durum.bekleyenOlaylar.single.copyWith(kalanTur: 1),
        ],
      );
      final sonuc = olayMotoru.bekleyenleriIsle(
        durum,
        RastgeleKaynak(7).akis('olay_bekleyen', tur: 2),
      );
      expect(sonuc.sonuclar, hasLength(1));
      expect(
        sonuc.durum.isletmeler.firstWhere((i) => i.id == 'kafe#2').stat(
              'musteriTabani',
            ),
        40,
        reason: 'sonuç yanlış işletmeye uygulanmış',
      );
      expect(
        sonuc.durum.isletmeler
            .firstWhere((i) => i.id == 'kafe#1')
            .stat('musteriTabani'),
        isNot(70),
      );
    });

    test('satıştaki işletme kart hedefi olmaz', () {
      final durum = baslat(
        isletmeler: [kafe().copyWith(satisKalanTur: 2)],
      );
      expect(
        olayMotoru.uygunKartlar(durum).map((o) => o.id),
        isNot(contains(denetim.id)),
      );
    });

    test('eksik bağlama derlemede değil testte patlar', () {
      // Dizin verilmezse işletme kartları herkese sızar; bu sessiz bir
      // hata olurdu.
      expect(
        () => TurProcessor(
          katalog: _meslekler(),
          isletme: isletmeMotoru,
          olay: OlayMotoru(katalog: olayKatalogu),
        ),
        throwsA(isA<AssertionError>()),
      );
      // Doğru bağlandığında sorun yok.
      expect(
        TurProcessor(
          katalog: _meslekler(),
          isletme: isletmeMotoru,
          olay: olayMotoru,
        ),
        isNotNull,
      );
    });

    test('havuzdaki her kart gerçekten bir işletmeye bağlı', () {
      final dizin = isletmeKatalogu.olayHavuzuDizini();
      for (final girdi in dizin.entries) {
        expect(olayKatalogu.bul(girdi.key), isNotNull, reason: girdi.key);
        expect(isletmeKatalogu.bul(girdi.value), isNotNull);
      }
      expect(dizin, isNotEmpty);
    });
  });

  test('kayıt round-trip işletmeleri taşır', () {
    final durum = tek(
      baslat(
        isletmeler: [kafe(musteri: 80, ceo: true)],
        ilgi: const IlgiDagilimi(puanlar: {'kafe#1': 1}),
      ),
    ).durum;
    final geri = OyunDurumu.fromJson(
        jsonDecode(jsonEncode(durum)) as Map<String, dynamic>);
    expect(geri, durum);
    expect(geri.isletmeler.single.ceoVar, isTrue);
    expect(geri.ilgi.puan('kafe#1'), 1);
  });
}
