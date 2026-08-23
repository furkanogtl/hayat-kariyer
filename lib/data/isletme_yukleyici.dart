import 'package:flutter/services.dart';

import '../core/models/isletme_katalogu.dart';

/// `assets/businesses/` altındaki işletme tanımlarını okuyup katalog üretir.
///
/// Tek sorumluluğu METNİ GETİRMEK. Ayrıştırma ve doğrulama `core` içindeki
/// [IsletmeKatalogu] işidir; bu sayede motor testleri Flutter'a bağlanmadan
/// aynı veriyi okuyabilir.
class IsletmeYukleyici {
  IsletmeYukleyici({AssetBundle? paket}) : _paket = paket ?? rootBundle;

  final AssetBundle _paket;

  static const String dizin = 'assets/businesses/';

  Future<IsletmeKatalogu> yukle() async {
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
    return IsletmeKatalogu.jsonMetinlerinden(metinler);
  }
}
