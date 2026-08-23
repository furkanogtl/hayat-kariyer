import 'dart:convert';

import 'olay.dart';

/// Tüm olay kartlarının bellekteki dizini.
///
/// Meslek katalogunda olduğu gibi ayrıştırma SAF DART'tır; dosya sistemi ve
/// asset bundle bilinmez. Motor testleri kartları doğrudan okuyup binlerce
/// tur simüle edebilir.
class OlayKatalogu {
  OlayKatalogu._(this._olaylar, this.cakisanKimlikler);

  final Map<String, Olay> _olaylar;

  /// Aynı kimlikle birden fazla tanımlanmış kartlar.
  final List<String> cakisanKimlikler;

  static final OlayKatalogu bos = OlayKatalogu._(const {}, const []);

  factory OlayKatalogu.listeden(Iterable<Olay> olaylar) {
    final dizin = <String, Olay>{};
    final cakisan = <String>[];
    for (final o in olaylar) {
      if (dizin.containsKey(o.id)) cakisan.add(o.id);
      dizin[o.id] = o;
    }
    return OlayKatalogu._(dizin, cakisan);
  }

  /// Her metin tek bir kart ya da kart dizisi olabilir.
  factory OlayKatalogu.jsonMetinlerinden(Iterable<String> metinler) {
    final olaylar = <Olay>[];
    for (final metin in metinler) {
      final cozulmus = jsonDecode(metin);
      if (cozulmus is List) {
        for (final girdi in cozulmus) {
          olaylar.add(Olay.fromJson(girdi as Map<String, dynamic>));
        }
      } else if (cozulmus is Map<String, dynamic>) {
        olaylar.add(Olay.fromJson(cozulmus));
      } else {
        throw FormatException(
          'Olay dosyası nesne ya da dizi olmalı, ${cozulmus.runtimeType} geldi',
        );
      }
    }
    return OlayKatalogu.listeden(olaylar);
  }

  int get uzunluk => _olaylar.length;

  bool get bosMu => _olaylar.isEmpty;

  List<Olay> get tumu => List.unmodifiable(_olaylar.values);

  Olay? bul(String id) => _olaylar[id];

  List<Olay> turdeki(OlayTuru tur) =>
      _olaylar.values.where((o) => o.tur == tur).toList();

  List<String> dogrula() {
    final hatalar = <String>[
      for (final id in cakisanKimlikler) 'yinelenen olay kimliği: $id',
    ];
    for (final o in _olaylar.values) {
      hatalar.addAll(o.dogrula());
    }
    return hatalar;
  }
}
