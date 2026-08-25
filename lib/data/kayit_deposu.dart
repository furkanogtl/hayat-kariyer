import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../core/models/oyun_durumu.dart';

/// Kayıt dosyasının okunup yazılması.
///
/// Anayasa gereği kayıt bir VERİTABANI DEĞİL, tek JSON dokümanı:
/// `freezed + json_serializable` serileştirmeyi zaten veriyor ve `core/`
/// saf kaldığı için testte round-trip edilebiliyor. Isar/Hive native
/// binary ve şema göçü yükü getirirdi.
///
/// Dosya İ/O `dart:io` gerektirdiği için burada, `core/` içinde değil.
class KayitDeposu {
  KayitDeposu({Directory? dizin}) : _verilenDizin = dizin;

  /// Testler için: verilmezse uygulama belgeler dizini kullanılır.
  final Directory? _verilenDizin;

  static const String dosyaAdi = 'kayit.json';

  /// Okunabilen en yüksek şema sürümü. İleriden gelen kayıt reddedilir;
  /// yarım okunmuş bir kayıt, hiç okunmamış kayıttan kötüdür.
  static const int desteklenenSurum = 1;

  /// Yazma işlemleri sıraya alınıyor: art arda gelen iki tur, birbirinin
  /// üstüne yazıp yarım dosya bırakmasın.
  Future<void> _kuyruk = Future<void>.value();

  Future<Directory> _dizin() async =>
      _verilenDizin ?? await getApplicationDocumentsDirectory();

  Future<File> _dosya() async => File('${(await _dizin()).path}/$dosyaAdi');

  Future<bool> kayitVarMi() async => (await _dosya()).exists();

  /// Kaydı okur. Dosya yoksa, bozuksa ya da sürümü ileriyse null döner.
  ///
  /// Bozuk kayıtta ÇÖKMEK yerine null dönmek bilinçli: oyuncu en kötü
  /// ihtimalle ilerlemesini kaybeder, uygulamayı değil.
  Future<OyunDurumu?> yukle() async {
    try {
      final dosya = await _dosya();
      if (!await dosya.exists()) return null;
      final metin = await dosya.readAsString();
      if (metin.trim().isEmpty) return null;
      final json = jsonDecode(metin);
      if (json is! Map<String, dynamic>) return null;
      final surum = json['kayitSurumu'];
      if (surum is int && surum > desteklenenSurum) return null;
      return OyunDurumu.fromJson(json).duzelt();
    } on Object {
      // FormatException, tip hatası, dosya hatası — hepsi aynı sonuç.
      return null;
    }
  }

  /// Kaydı ATOMİK yazar: önce geçici dosya, sonra yeniden adlandırma.
  ///
  /// Doğrudan üstüne yazılsaydı, yazma sırasında uygulama kapanınca
  /// yarım JSON kalır ve oyuncu bütün ilerlemesini kaybederdi.
  Future<void> yaz(OyunDurumu durum) {
    _kuyruk = _kuyruk.then((_) => _yaz(durum)).catchError((Object _) {});
    return _kuyruk;
  }

  Future<void> _yaz(OyunDurumu durum) async {
    final dizin = await _dizin();
    if (!await dizin.exists()) await dizin.create(recursive: true);
    final gecici = File('${dizin.path}/$dosyaAdi.tmp');
    await gecici.writeAsString(jsonEncode(durum.toJson()), flush: true);
    await gecici.rename('${dizin.path}/$dosyaAdi');
  }

  Future<void> sil() async {
    _kuyruk = _kuyruk.then((_) async {
      final dosya = await _dosya();
      if (await dosya.exists()) await dosya.delete();
    }).catchError((Object _) {});
    return _kuyruk;
  }

  /// Bekleyen yazmalar bitene kadar bekler. Testler ve uygulama kapanışı
  /// için.
  Future<void> bekle() => _kuyruk;
}
