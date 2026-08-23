import 'dart:convert';

import 'isletme.dart';
import 'oyuncu.dart';

/// İşletme tanımlarının bellekteki dizini.
///
/// Meslek ve olay katalogunda olduğu gibi ayrıştırma SAF DART'tır; dosya
/// sistemi ve asset bundle bilinmez.
class IsletmeKatalogu {
  IsletmeKatalogu._(this._tanimlar, this.cakisanKimlikler);

  final Map<String, IsletmeTanimi> _tanimlar;

  /// Aynı kimlikle birden fazla tanımlanmış işletmeler.
  final List<String> cakisanKimlikler;

  static final IsletmeKatalogu bos = IsletmeKatalogu._(const {}, const []);

  factory IsletmeKatalogu.listeden(Iterable<IsletmeTanimi> tanimlar) {
    final dizin = <String, IsletmeTanimi>{};
    final cakisan = <String>[];
    for (final t in tanimlar) {
      if (dizin.containsKey(t.id)) cakisan.add(t.id);
      dizin[t.id] = t;
    }
    return IsletmeKatalogu._(dizin, cakisan);
  }

  factory IsletmeKatalogu.jsonMetinlerinden(Iterable<String> metinler) {
    final tanimlar = <IsletmeTanimi>[];
    for (final metin in metinler) {
      final cozulmus = jsonDecode(metin);
      if (cozulmus is List) {
        for (final girdi in cozulmus) {
          tanimlar.add(IsletmeTanimi.fromJson(girdi as Map<String, dynamic>));
        }
      } else if (cozulmus is Map<String, dynamic>) {
        tanimlar.add(IsletmeTanimi.fromJson(cozulmus));
      } else {
        throw FormatException(
          'İşletme dosyası nesne ya da dizi olmalı, '
          '${cozulmus.runtimeType} geldi',
        );
      }
    }
    return IsletmeKatalogu.listeden(tanimlar);
  }

  int get uzunluk => _tanimlar.length;

  bool get bosMu => _tanimlar.isEmpty;

  List<IsletmeTanimi> get tumu => List.unmodifiable(_tanimlar.values);

  IsletmeTanimi? bul(String id) => _tanimlar[id];

  /// Oyuncunun giriş şartını karşıladığı işletmeler. Sermayeye BAKILMAZ —
  /// parası olmayan oyuncu da neyin var olduğunu görmeli, hedef koyabilsin.
  List<IsletmeTanimi> acilabilirler(Oyuncu oyuncu) => _tanimlar.values
      .where((t) => t.girisSarti.karsilaniyorMu(oyuncu))
      .toList();

  List<String> dogrula() {
    final hatalar = <String>[
      for (final id in cakisanKimlikler) 'yinelenen işletme kimliği: $id',
    ];
    for (final t in _tanimlar.values) {
      hatalar.addAll(t.dogrula());
    }
    return hatalar;
  }
}
