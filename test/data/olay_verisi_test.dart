import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/rejim.dart';
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

/// Dosya adı → o dosyadaki kart kimlikleri. `olcekli` bayrağının yalnız
/// yaşam kartlarında açılmasını denetlemek için gerekiyor; katalog
/// birleştirilmiş olduğu için kartın hangi dosyadan geldiği orada yok.
Map<String, Set<String>> dosyayaGoreKartlar() {
  final sonuc = <String, Set<String>>{};
  for (final f in Directory('assets/events')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))) {
    final ad = f.uri.pathSegments.last;
    final katalog = OlayKatalogu.jsonMetinlerinden([f.readAsStringSync()]);
    sonuc[ad] = {for (final o in katalog.tumu) o.id};
  }
  return sonuc;
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
  // Öğrencilik 4 yıl sürüyor; tek 18'lik temsilci "staj" ve "değişim
  // programı" gibi 19+ kartlarını ulaşılamaz gösteriyordu.
  'öğrenci (21)': Oyuncu(
    ad: 'test',
    sehir: Sehir.izmir,
    tur: 3 * 12,
    egitim: EgitimSeviyesi.lise,
    kariyer: const KariyerDurumu.ogrenci(
      hedef: EgitimSeviyesi.lisans,
      kalanTur: 12,
    ),
    nakit: 9000,
    itibar: 6,
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
  'asker (22)': Oyuncu(
    ad: 'test',
    sehir: Sehir.konya,
    tur: 4 * 12,
    egitim: EgitimSeviyesi.lise,
    kariyer: const KariyerDurumu.askerlik(kalanTur: 4),
    nakit: 20000,
  ),
  // Dip sisteminin hedefi: nakiti eksi, kredi notu tabanda. Bu temsilci
  // olmadan dip kartlarının koşulları hiç sınanmıyordu.
  'dipteki (33)': Oyuncu(
    ad: 'test',
    sehir: Sehir.istanbul,
    tur: 15 * 12,
    egitim: EgitimSeviyesi.lise,
    kariyer: const KariyerDurumu.calisan(meslekId: 'satis_temsilcisi'),
    nakit: -40000,
    itibar: 8,
    krediNotu: 380,
  ),
  'varlıklı (48)': Oyuncu(
    ad: 'test',
    sehir: Sehir.izmir,
    tur: 30 * 12,
    egitim: EgitimSeviyesi.lisans,
    kariyer: const KariyerDurumu.calisan(meslekId: 'yazilim_gelistirici'),
    nakit: 8000000,
    itibar: 85,
    krediNotu: 1700,
  ),
};

/// Bir kartın çıkabileceği aday durumlar: temsilci oyuncular x rejimler.
///
/// Kart bir mesleğe bağlıysa o mesleği taşıyan varyant da denenir; yoksa
/// meslek kartları "ulaşılamaz" görünürdü.
Iterable<(Oyuncu, PiyasaDurumu)> _adayDurumlar(Olay olay) sync* {
  final oyuncular = <Oyuncu>[
    ..._ornekOyuncular.values,
    for (final id in olay.kosullar.meslekler ?? const <String>[])
      for (final temel in _ornekOyuncular.values)
        temel.copyWith(kariyer: KariyerDurumu.calisan(meslekId: id)),
  ];
  for (final oyuncu in oyuncular) {
    for (final rejim in Rejim.values) {
      yield (oyuncu, PiyasaDurumu(rejim: rejim));
    }
  }
}

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
    // Kart tutarları taban TL ve kariyer başındaki bir maaşa göre yazıldı.
    // Ölçüldü: geç oyunda çekilen kartların bahsi aylık maaşın MEDYAN
    // %6'sıydı, üçte ikisi %10'un altındaydı — kartlar bildirime dönüşüyordu.
    // `olcekli` bunu düzeltiyor ama her karta açılamaz.
    test('olcekli yalnız yaşam giderlerinde açık', () {
      final dosyalar = dosyayaGoreKartlar();
      // Fırsat kartlarının ödülü itibar kademesine göre elle dengelendi
      // (kapılar 25-80). Ölçeklenirlerse o merdiven bozulur.
      // Meslek kartları mesleğe göre, işletme kartları işletme ekonomisine
      // göre ayarlı. Dip kartları parasızlığı anlatıyor; büyütmek
      // mekaniğin kendisini geri alır.
      const yasak = {
        'firsat.json',
        'meslek.json',
        'isletme.json',
        'dip.json',
        'genclik.json',
      };
      final hatalar = <String>[];
      for (final olay in katalog.tumu) {
        if (!olay.olcekli) continue;
        for (final girdi in dosyalar.entries) {
          if (yasak.contains(girdi.key) && girdi.value.contains(olay.id)) {
            hatalar.add('${girdi.key}/${olay.id}');
          }
        }
      }
      expect(hatalar, isEmpty,
          reason: 'bu dosyalardaki kartlar elle dengelendi, ölçeklenemez');
    });

    test('yaşam kartlarının çoğu ölçekleniyor', () {
      // Ters yön: hayat kartları ölçeklenmezse geç oyun yine bildirime
      // döner. Tamamı şart değil (trafik cezası kanunla belli), ama
      // çoğunluk olmalı.
      final hayat = dosyayaGoreKartlar()['hayat.json']!;
      final parali = katalog.tumu
          .where((o) => hayat.contains(o.id) && o.parasalBuyukluk > 0);
      final olcekli = parali.where((o) => o.olcekli).length;
      expect(olcekli / parali.length, greaterThan(0.7),
          reason: 'paralı hayat kartlarının çoğu oyuncuyla büyümeli');
    });

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

    test('itibar arttıkça fırsat havuzu büyümeye devam ediyor', () {
      // Anayasa: "itibar fırsat kartlarının KALİTESİNİ belirler". Ölçümde
      // havuzun itibar 20'den sonra SABİTLENDİĞİ çıktı: 13 fırsat kartından
      // yalnız ikisinin itibar kapısı vardı, üst uçta biriken itibarın
      // karşılığı yalnız ağırlık çarpanıydı. Kademeli kapılar eklendi.
      //
      // Nakit sabit ve bol tutuluyor: ölçülen tek değişken itibar olmalı,
      // yoksa sermaye de isteyen üst kademe kartları sonucu bulandırır.
      int havuz(int itibar) {
        final oyuncu = Oyuncu(
          ad: 'test',
          sehir: Sehir.istanbul,
          tur: 15 * 12,
          egitim: EgitimSeviyesi.lisans,
          kariyer: const KariyerDurumu.calisan(
            meslekId: 'yazilim_gelistirici',
          ),
          nakit: 3000000,
          itibar: itibar,
        );
        return katalog.tumu
            .where((o) => o.tur == OlayTuru.firsat || o.tur == OlayTuru.teklif)
            .where((o) => o.kosullar.uygunMu(oyuncu, _piyasa))
            .length;
      }

      const kademeler = [0, 25, 50, 75];
      final sayilar = [for (final i in kademeler) havuz(i)];
      for (var i = 1; i < sayilar.length; i++) {
        expect(
          sayilar[i],
          greaterThan(sayilar[i - 1]),
          reason: 'itibar ${kademeler[i - 1]} -> ${kademeler[i]}: '
              'havuz ${sayilar[i - 1]} -> ${sayilar[i]}, büyümüyor',
        );
      }
      // İtibarsız oyuncu da tamamen fırsatsız kalmamalı.
      expect(sayilar.first, greaterThanOrEqualTo(4));
    });

    test('yazılan her kart en az bir oyuncuya çıkabiliyor', () {
      // Koşulları hiçbir durumda tutmayan kart, yazılıp hiç görülmeyen
      // içeriktir ve hiçbir yerde patlamaz. Ölçümde 480 turluk oyunda
      // havuzun yarısının hiç çıkmadığı görülünce bu kural yazıldı: o
      // ölçüm bir defalık, bu kural kalıcı.
      //
      // İşletme kartları hariç; onların kapısı işletme sahibi olmak ve
      // `isletme_verisi_test` tarafından ayrıca doğrulanıyor.
      final isletmeninkiler = isletmeKartlari();
      final ulasilamayan = <String>[];
      for (final olay in katalog.tumu) {
        if (isletmeninkiler.contains(olay.id)) continue;
        final ulasilir = _adayDurumlar(olay).any(
          (d) => olay.kosullar.uygunMu(d.$1, d.$2),
        );
        if (!ulasilir) ulasilamayan.add(olay.id);
      }
      expect(
        ulasilamayan,
        isEmpty,
        reason: 'koşulları hiçbir temsilcide tutmuyor: $ulasilamayan',
      );
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
          // Eşik 8'di; havuz genişletildikten sonra en dar temsilci 22
          // kart görüyor. 20'ye çekildi: bir havuzun çökmesini yakalar,
          // yeni temsilci eklemeyi gereksiz yere zorlaştırmaz.
          greaterThanOrEqualTo(20),
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
