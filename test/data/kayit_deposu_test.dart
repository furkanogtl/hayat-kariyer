import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/tur_processor.dart';
import 'package:hayat_kariyer/core/models/egitim_seviyesi.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/meslek_katalogu.dart';
import 'package:hayat_kariyer/core/models/oyun_durumu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/models/zaman_dagilimi.dart';
import 'package:hayat_kariyer/data/kayit_deposu.dart';

/// Kayıt dosyası: tek JSON dokümanı, atomik yazım, bozuk kayıt savunması.
void main() {
  final katalog = MeslekKatalogu.jsonMetinlerinden(
    Directory('assets/careers')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .map((f) => f.readAsStringSync()),
  );
  final motor = TurProcessor(katalog: katalog);

  late Directory dizin;
  late KayitDeposu depo;

  setUp(() {
    dizin = Directory.systemTemp.createTempSync('hk_kayit_');
    depo = KayitDeposu(dizin: dizin);
  });

  tearDown(() {
    if (dizin.existsSync()) dizin.deleteSync(recursive: true);
  });

  OyunDurumu oyna(int tur) {
    var durum = motor.yeniOyun(
      oyuncu: Oyuncu.yeni(
        ad: 'Test',
        sehir: Sehir.konya,
        egitim: EgitimSeviyesi.lisans,
      ).copyWith(
        nakit: 250000,
        kariyer: const KariyerDurumu.calisan(meslekId: 'yazilim_gelistirici'),
      ),
      anaTohum: 616,
    );
    for (var t = 0; t < tur; t++) {
      durum = motor
          .turuBitir(durum, TurGirdisi(zaman: ZamanDagilimi.dengeli()))
          .durum;
    }
    return durum;
  }

  File dosya() => File('${dizin.path}/${KayitDeposu.dosyaAdi}');

  test('kayıt yokken null döner', () async {
    expect(await depo.kayitVarMi(), isFalse);
    expect(await depo.yukle(), isNull);
  });

  test('yaz-oku round-trip durumu birebir taşıyor', () async {
    final durum = oyna(24);
    await depo.yaz(durum);
    expect(await depo.kayitVarMi(), isTrue);
    expect(await depo.yukle(), durum);
  });

  test('kayıt tek JSON dosyası', () async {
    await depo.yaz(oyna(3));
    final dosyalar = dizin.listSync().whereType<File>().toList();
    expect(dosyalar, hasLength(1));
    expect(dosyalar.single.path, endsWith(KayitDeposu.dosyaAdi));
    // Geçici dosya arkada kalmamalı.
    expect(File('${dizin.path}/${KayitDeposu.dosyaAdi}.tmp').existsSync(),
        isFalse);
  });

  test('üst üste yazmalar sıraya giriyor, son yazan kazanıyor', () async {
    // Sıra korunmasaydı iki yazma birbirinin üstüne binip yarım dosya
    // bırakabilirdi.
    final ilk = oyna(2);
    final son = oyna(8);
    unawaited(depo.yaz(ilk));
    unawaited(depo.yaz(son));
    await depo.bekle();
    expect(await depo.yukle(), son);
  });

  test('bozuk JSON çökertmiyor, null dönüyor', () async {
    // Oyuncu en kötü ihtimalle ilerlemesini kaybetmeli, uygulamayı değil.
    await depo.yaz(oyna(2));
    dosya().writeAsStringSync('{ bu json degil');
    expect(await depo.yukle(), isNull);
  });

  test('boş dosya null dönüyor', () async {
    await depo.yaz(oyna(2));
    dosya().writeAsStringSync('   ');
    expect(await depo.yukle(), isNull);
  });

  test('eksik alanlı kayıt varsayılanlarla okunuyor', () async {
    // İleride alan eklenirse eski kayıt okunabilir kalmalı.
    final durum = oyna(4);
    final json = jsonDecode(jsonEncode(durum)) as Map<String, dynamic>;
    json.remove('zirveNetDeger');
    json.remove('iflasSayisi');
    dosya().writeAsStringSync(jsonEncode(json));

    final geri = await depo.yukle();
    expect(geri, isNotNull);
    expect(geri!.zirveNetDeger, 0);
    expect(geri.iflasSayisi, 0);
  });

  test('ileri sürümlü kayıt reddediliyor', () async {
    // Yarım okunmuş kayıt, hiç okunmamış kayıttan kötüdür.
    final json = jsonDecode(jsonEncode(oyna(2))) as Map<String, dynamic>;
    json['kayitSurumu'] = KayitDeposu.desteklenenSurum + 1;
    dosya().writeAsStringSync(jsonEncode(json));
    expect(await depo.yukle(), isNull);
  });

  test('bozuk kayıt duzelt() ile onarılıyor', () async {
    final json = jsonDecode(jsonEncode(oyna(2))) as Map<String, dynamic>;
    json['krediYasagiTuru'] = -5;
    json['maasEndeksi'] = 0;
    dosya().writeAsStringSync(jsonEncode(json));

    final geri = await depo.yukle();
    expect(geri!.krediYasagiTuru, 0);
    expect(geri.maasEndeksi, 1.0);
  });

  test('silme kaydı kaldırıyor', () async {
    await depo.yaz(oyna(2));
    await depo.sil();
    expect(await depo.kayitVarMi(), isFalse);
    expect(await depo.yukle(), isNull);
  });

  test('kayıt boyutu 60 turda sabitleniyor', () async {
    // Fiyat geçmişi pencereli olduğu için kayıt sınırsız büyümemeli.
    await depo.yaz(oyna(60));
    await depo.bekle();
    final altmis = dosya().lengthSync();
    await depo.yaz(oyna(180));
    await depo.bekle();
    final yuzSeksen = dosya().lengthSync();
    expect(yuzSeksen, lessThan(altmis * 2));
  });
}
