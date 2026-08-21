import 'package:flutter/services.dart';

import '../core/models/meslek_katalogu.dart';

/// `assets/careers/` altındaki meslek dosyalarını okuyup katalog üretir.
///
/// Tek sorumluluğu METNİ GETİRMEK. Ayrıştırma ve doğrulama `core` içindeki
/// [MeslekKatalogu] işidir; bu sayede motor testleri Flutter'a bağlanmadan
/// aynı veriyi okuyabilir.
class MeslekYukleyici {
  MeslekYukleyici({AssetBundle? paket}) : _paket = paket ?? rootBundle;

  final AssetBundle _paket;

  static const String dizin = 'assets/careers/';

  Future<MeslekKatalogu> yukle() async {
    final manifest = await AssetManifest.loadFromAssetBundle(_paket);
    final yollar = manifest
        .listAssets()
        .where((yol) => yol.startsWith(dizin) && yol.endsWith('.json'))
        .toList()
      // Yükleme sırası deterministik olsun: yinelenen kimlik varsa hangi
      // dosyanın kazandığı platforma göre değişmesin.
      ..sort();

    final metinler = <String>[];
    for (final yol in yollar) {
      metinler.add(await _paket.loadString(yol));
    }
    return MeslekKatalogu.jsonMetinlerinden(metinler);
  }
}
