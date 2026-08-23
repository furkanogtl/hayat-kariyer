import 'package:flutter/services.dart';

import '../core/models/olay_katalogu.dart';

/// `assets/events/` altındaki olay kartlarını okuyup katalog üretir.
///
/// Meslek yükleyicisiyle aynı ayrım: bu sınıf yalnızca METNİ getirir,
/// ayrıştırma ve doğrulama `core` içindeki [OlayKatalogu] işidir.
class OlayYukleyici {
  OlayYukleyici({AssetBundle? paket}) : _paket = paket ?? rootBundle;

  final AssetBundle _paket;

  static const String dizin = 'assets/events/';

  Future<OlayKatalogu> yukle() async {
    final manifest = await AssetManifest.loadFromAssetBundle(_paket);
    final yollar = manifest
        .listAssets()
        .where((yol) => yol.startsWith(dizin) && yol.endsWith('.json'))
        .toList()
      // Yükleme sırası deterministik olsun.
      ..sort();

    final metinler = <String>[];
    for (final yol in yollar) {
      metinler.add(await _paket.loadString(yol));
    }
    return OlayKatalogu.jsonMetinlerinden(metinler);
  }
}
