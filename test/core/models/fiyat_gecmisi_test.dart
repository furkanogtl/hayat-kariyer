import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/piyasa_simulatoru.dart';
import 'package:hayat_kariyer/core/models/piyasa_durumu.dart';
import 'package:hayat_kariyer/core/rng/rastgele_kaynak.dart';

/// Grafik için tutulan reel fiyat serisi.
///
/// Seri bir HESAP GİRDİSİ değil, kayda alınan bir gözlemdir: motorun hiçbir
/// kararı buna bakmaz. Buradaki testler serinin doğru ölçekte, sınırlı ve
/// kayıttan geri okunabilir olduğunu tutuyor.
void main() {
  final simulator = PiyasaSimulatoru();

  PiyasaDurumu oyna(int tur, {int tohum = 7}) {
    var durum = simulator.baslangic();
    final kaynak = RastgeleKaynak(tohum);
    for (var t = 1; t <= tur; t++) {
      durum = simulator.turIsle(durum, kaynak.akis('piyasa', tur: t));
    }
    return durum;
  }

  test('ilk turdan önce bile seri var', () {
    // Yeni oyunda grafiğin dayanağı olsun.
    final durum = simulator.baslangic();
    expect(durum.seri('altin'), hasLength(1));
    expect(durum.seri('altin').single, 4500);
  });

  test('her tur bir nokta ekleniyor', () {
    expect(oyna(10).seri('altin'), hasLength(11));
  });

  test('pencere aşılmıyor', () {
    // Sınırsız olsaydı 480 turluk oyunda kayıt 12 varlık × 480 sayıyla
    // gereksiz şişerdi.
    final durum = oyna(fiyatGecmisiPenceresi * 3);
    for (final id in durum.fiyatlar.keys) {
      expect(durum.seri(id), hasLength(fiyatGecmisiPenceresi));
    }
  });

  test('seri REEL: son nokta ham fiyatın deflate edilmişi', () {
    final durum = oyna(24);
    for (final g in durum.fiyatlar.entries) {
      expect(
        durum.seri(g.key).last,
        closeTo(g.value / durum.enflasyonEndeksi, 1e-9),
      );
    }
  });

  test('mevduat reel olarak geriliyor', () {
    // "Güvenli" seçeneğin bedeli grafikte de görünmeli: nominal seri
    // yükselirken reel seri düşüyor.
    final durum = oyna(120);
    final seri = durum.seri('mevduat');
    expect(seri.last, lessThan(seri.first));
    expect(durum.fiyat('mevduat'), greaterThan(100));
  });

  test('reelDegisim seriden okunuyor', () {
    final durum = oyna(24);
    final seri = durum.seri('altin');
    expect(
      durum.reelDegisim('altin', tur: 12),
      closeTo(seri.last / seri[seri.length - 13] - 1, 1e-9),
    );
    // Veri yetmezse null; ekran boş gösterecek, uydurmayacak.
    expect(simulator.baslangic().reelDegisim('altin'), isNull);
  });

  test('para reformu seriyi bozmuyor', () {
    // Reform yalnız gösterim ölçeği; reel seri ham TL ölçeğinden bağımsız.
    var durum = simulator.baslangic();
    final kaynak = RastgeleKaynak(3);
    var reformOldu = false;
    for (var t = 1; t <= 400 && !reformOldu; t++) {
      durum = simulator.turIsle(durum, kaynak.akis('piyasa', tur: t));
      reformOldu = durum.paraReformuYapildi;
    }
    expect(reformOldu, isTrue, reason: '400 turda reform tetiklenmedi');
    final seri = durum.seri('altin');
    // Reform turunda seride 1000 kat bir sıçrama OLMAMALI.
    expect(seri.last / seri[seri.length - 2], lessThan(2));
    expect(seri.last / seri[seri.length - 2], greaterThan(0.5));
  });

  test('kayıt round-trip seriyi taşıyor', () {
    final durum = oyna(30);
    final geri = PiyasaDurumu.fromJson(
      jsonDecode(jsonEncode(durum)) as Map<String, dynamic>,
    );
    expect(geri, durum);
    expect(geri.seri('kripto'), durum.seri('kripto'));
  });
}
