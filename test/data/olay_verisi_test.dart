import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/models/isletme_katalogu.dart';
import 'package:hayat_kariyer/core/models/meslek_katalogu.dart';
import 'package:hayat_kariyer/core/models/olay.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/olay_katalogu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/piyasa_durumu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/varlik.dart';

/// `assets/events/` altındaki GERÇEK kart dosyalarını doğrular.
///
/// Kartlar elle yazılan JSON'dur ve sayısı yüzü bulacak. Şema hatası da
/// denge hatası da çalışma zamanında değil burada yakalanmalıdır. Dosyalar
/// diskten okunur (asset bundle değil) — test Flutter bağlamına muhtaç
/// kalmasın diye.
OlayKatalogu katalogYukle() {
  final dizin = Directory('assets/events');
  if (!dizin.existsSync()) {
    throw StateError('assets/events bulunamadı (çalışma dizini proje kökü mü?)');
  }
  final dosyalar = dizin
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  if (dosyalar.isEmpty) {
    throw StateError('assets/events altında kart dosyası yok');
  }
  return OlayKatalogu.jsonMetinlerinden(
    dosyalar.map((f) => f.readAsStringSync()),
  );
}

/// İşletmelerin `olayHavuzu` alanlarında geçen kart kimlikleri. Bunlar
/// yalnız o işletmeye sahip oyuncuya çıkar; genel havuz sayımına girmemeli.
Set<String> isletmeKartlari() => IsletmeKatalogu.jsonMetinlerinden(
      Directory('assets/businesses')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .map((f) => f.readAsStringSync()),
    ).olayHavuzuDizini().keys.toSet();

MeslekKatalogu meslekKatalogYukle() {
  final dizin = Directory('assets/careers');
  final dosyalar = dizin
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'));
  return MeslekKatalogu.jsonMetinlerinden(
    dosyalar.map((f) => f.readAsStringSync()),
  );
}

/// Bir seçeneğin tüm dallarındaki (ve anlık) taban TL etkileri.
Iterable<OlayEtkileri> _tumEtkiler(OlaySecenegi s) sync* {
  yield s.etkiler;
  for (final sonuc in s.sonuclar) {
    yield sonuc.etkiler;
  }
}

/// Kart havuzunun kapsamını ölçmek için temsilci oyuncular. Koşullar bir
/// oyuncu tipini kartsız bırakmamalı.
final _piyasa = const PiyasaDurumu();

final _ornekOyuncular = <String, Oyuncu>{
  'öğrenci (18)': const Oyuncu(
    ad: 'test',
    sehir: Sehir.konya,
    egitim: EgitimSeviyesi.lise,
    kariyer: KariyerDurumu.ogrenci(hedef: EgitimSeviyesi.lisans, kalanTur: 48),
    nakit: 5000,
  ),
  'çalışan (30)': Oyuncu(
    ad: 'test',
    sehir: Sehir.istanbul,
    tur: 12 * 12,
    egitim: EgitimSeviyesi.lisans,
    kariyer: const KariyerDurumu.calisan(meslekId: 'yazilim_gelistirici'),
    nakit: 200000,
    itibar: 30,
  ),
  'işsiz (26)': Oyuncu(
    ad: 'test',
    sehir: Sehir.izmir,
    tur: 8 * 12,
    egitim: EgitimSeviyesi.lisans,
    kariyer: const KariyerDurumu.issiz(),
    nakit: 30000,
    itibar: 15,
  ),
  'emekli (66)': Oyuncu(
    ad: 'test',
    sehir: Sehir.trabzon,
    tur: 48 * 12,
    egitim: EgitimSeviyesi.lise,
    kariyer: const KariyerDurumu.emekli(tabanAylik: 20000),
    nakit: 100000,
    itibar: 25,
  ),
};

void main() {
  late OlayKatalogu katalog;

  setUpAll(() => katalog = katalogYukle());

  group('şema', () {
    test('bütün kartlar geçerli', () {
      expect(katalog.dogrula(), isEmpty);
    });

    test('kart havuzu oyunu taşıyacak kadar büyük', () {
      // 480 turluk oyunda ~120 kart çıkıyor. Havuz bundan çok küçükse
      // oyuncu aynı kartı ezberler.
      expect(katalog.uzunluk, greaterThanOrEqualTo(60));
    });

    test('her tür temsil ediliyor', () {
      for (final tur in OlayTuru.values) {
        expect(
          katalog.turdeki(tur),
          isNotEmpty,
          reason: '$tur türünde tek kart bile yok',
        );
      }
    });
  });

  group('çapraz referanslar', () {
    test('koşuldaki meslek kimlikleri gerçekten var', () {
      final meslekler = meslekKatalogYukle();
      final tanimli = {for (final m in meslekler.tumu) m.id};
      for (final olay in katalog.tumu) {
        for (final id in olay.kosullar.meslekler ?? const <String>[]) {
          expect(
            tanimli,
            contains(id),
            reason: '${olay.id}: tanımsız meslek kimliği $id',
          );
        }
      }
    });

    test('etkilerdeki varlık kimlikleri gerçekten var', () {
      final tanimli = {for (final v in piyasaVarliklari) v.id};
      for (final olay in katalog.tumu) {
        for (final s in olay.secenekler) {
          for (final e in _tumEtkiler(s)) {
            for (final id in {...e.fiyatCarpani.keys, ...e.varlik.keys}) {
              expect(
                tanimli,
                contains(id),
                reason: '${olay.id}: tanımsız varlık kimliği $id',
              );
            }
          }
        }
      }
    });
  });

  group('denge', () {
    test('bedava büyük para yok', () {
      // Anlık, dalsız VE bedelsiz bir seçenek serbest kazanç demektir.
      // İlk yazımda ölçüt yalnız nakitti; işletme kartları gelince
      // "stokunu eritip 350.000 al" gibi gerçek bedeli olan takaslar
      // haksız yere takıldı. Doğru soru: karşılığında bir şey ödendi mi?
      const tavan = 200000;
      for (final olay in katalog.tumu) {
        for (final s in olay.secenekler) {
          if (s.dallaniyor || s.gecikmeli) continue;
          if (s.etkiler.nakit <= tavan) continue;
          final bedelVar = s.etkiler.enerji < 0 ||
              s.etkiler.mutluluk < 0 ||
              s.etkiler.itibar < 0 ||
              s.etkiler.krediNotu < 0 ||
              s.etkiler.isletmeStat.values.any((v) => v < 0) ||
              s.etkiler.varlik.values.any((v) => v < 0);
          expect(
            bedelVar,
            isTrue,
            reason: '${olay.id}/${s.etiket}: '
                'bedelsiz ${s.etkiler.nakit} TL',
          );
        }
      }
    });

    test('her kartta gerçek bir tercih var', () {
      // Tek seçenekli kart karar değil bildirimdir; bütün seçenekleri aynı
      // yöne çeken kart da öyle. En az bir seçenek diğerinden farklı
      // olmalı.
      for (final olay in katalog.tumu) {
        expect(
          olay.secenekler.length,
          greaterThanOrEqualTo(2),
          reason: '${olay.id}: tek seçenekli kart',
        );
        final imzalar = {
          for (final s in olay.secenekler)
            '${s.etkiler}|${s.sonuclar.length}|${s.gecikmeTuru}',
        };
        expect(
          imzalar.length,
          greaterThan(1),
          reason: '${olay.id}: bütün seçenekler aynı şeyi yapıyor',
        );
      }
    });

    test('fırsat kartı gerçekten fırsat sunuyor', () {
      // Fırsat kartlarının ağırlığı itibarla çarpılıyor. İtibar biriktiren
      // oyuncu karşılığında kazanç görmüyorsa mekanik yalan söylüyor
      // demektir.
      for (final olay in katalog.turdeki(OlayTuru.firsat)) {
        final kazancVar = olay.secenekler.any(
          (s) => _tumEtkiler(s).any(
            (e) =>
                e.nakit > 0 ||
                e.itibar > 0 ||
                e.krediNotu > 0 ||
                e.yetkinlik.values.any((v) => v > 0) ||
                e.fiyatCarpani.values.any((v) => v > 1) ||
                e.varlik.values.any((v) => v > 0),
          ),
        );
        expect(kazancVar, isTrue, reason: '${olay.id}: fırsatta kazanç yok');
      }
    });

    test('kriz kartı bedelsiz atlatılamıyor', () {
      for (final olay in katalog.turdeki(OlayTuru.kriz)) {
        for (final s in olay.secenekler) {
          final bedelVar = _tumEtkiler(s).any(
            (e) =>
                e.nakit < 0 ||
                e.enerji < 0 ||
                e.mutluluk < 0 ||
                e.itibar < 0 ||
                e.krediNotu < 0,
          );
          expect(
            bedelVar,
            isTrue,
            reason: '${olay.id}/${s.etiket}: krizden bedelsiz çıkış',
          );
        }
      }
    });

    test('gecikmeli dallarda hem iyi hem kötü sonuç var', () {
      // Bekleme gerilimi ancak sonuç belirsizse işe yarar. Bütün dalları
      // olumlu olan gecikme, oyuncuyu bekletmenin bahanesidir.
      for (final olay in katalog.tumu) {
        for (final s in olay.secenekler.where((s) => s.gecikmeli)) {
          final degerler = [
            for (final sonuc in s.sonuclar)
              sonuc.etkiler.nakit +
                  sonuc.etkiler.mutluluk * 1000 +
                  sonuc.etkiler.itibar * 1000,
          ];
          expect(
            degerler.reduce((a, b) => a > b ? a : b) >
                degerler.reduce((a, b) => a < b ? a : b),
            isTrue,
            reason: '${olay.id}/${s.etiket}: bütün dallar aynı değerde',
          );
        }
      }
    });

    test('tek seferlik olmayan kartın beklemesi anlamlı', () {
      // Beklemesi kısa bir kart üst üste çıkar; oyuncu aynı metni ezberler.
      for (final olay in katalog.tumu) {
        if (olay.tekSeferlik) continue;
        expect(
          olay.bekleme,
          greaterThanOrEqualTo(4),
          reason: '${olay.id}: bekleme ${olay.bekleme} tur, çok sık çıkar',
        );
      }
    });

    test('kredi notu koşulları doğru ölçekte', () {
      // Kartlar önce 0-100 ölçeğine göre yazılmıştı; gerçek ölçek
      // 300-1900. Yanlış ölçekteki koşul sessizce ya HİÇ ya HER ZAMAN
      // tutar — kart görünmez olur ya da koşulsuza döner.
      for (final olay in katalog.tumu) {
        for (final deger in [
          olay.kosullar.enAzKrediNotu,
          olay.kosullar.enCokKrediNotu,
        ]) {
          if (deger == null) continue;
          expect(
            deger,
            inInclusiveRange(Oyuncu.krediNotuTaban, Oyuncu.krediNotuTavan),
            reason: '${olay.id}: kredi notu $deger ölçek dışı '
                '(${Oyuncu.krediNotuTaban}-${Oyuncu.krediNotuTavan})',
          );
        }
      }
    });

    test('her oyuncu tipi yeterli kart görüyor', () {
      // İlk yazımda "koşulsuz kart sayısı" ölçülüyordu; asıl sorulması
      // gereken bu değil. Kartların hepsi koşulludur ama koşullar bir
      // oyuncu tipini dışarıda bırakmamalı. 18 yaşındaki öğrenci
      // ölçüldüğünde havuzunda 2 kart olduğu ortaya çıktı: oyunun ilk
      // yılları bomboştu.
      final isletmeninkiler = isletmeKartlari();
      for (final ornek in _ornekOyuncular.entries) {
        final havuz = katalog.tumu
            .where((o) => !isletmeninkiler.contains(o.id))
            .where((o) => o.kosullar.uygunMu(ornek.value, _piyasa))
            .length;
        expect(
          havuz,
          greaterThanOrEqualTo(8),
          reason: '${ornek.key}: yalnız $havuz kart görüyor',
        );
      }
    });
  });

  group('metin', () {
    test('başlıklar kısa', () {
      for (final olay in katalog.tumu) {
        expect(
          olay.baslik.length,
          lessThanOrEqualTo(60),
          reason: '${olay.id}: başlık ${olay.baslik.length} karakter',
        );
      }
    });

    test('seçenek etiketleri butona sığıyor', () {
      for (final olay in katalog.tumu) {
        for (final s in olay.secenekler) {
          expect(
            s.etiket.length,
            lessThanOrEqualTo(40),
            reason: '${olay.id}: "${s.etiket}" çok uzun',
          );
        }
      }
    });

    test('sonuç metinleri tek satırlık', () {
      for (final olay in katalog.tumu) {
        for (final s in olay.secenekler) {
          for (final sonuc in s.sonuclar) {
            expect(
              sonuc.metin.length,
              lessThanOrEqualTo(140),
              reason: '${olay.id}: sonuç metni ${sonuc.metin.length} karakter',
            );
          }
        }
      }
    });
  });
}
