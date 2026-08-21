import 'dart:convert';

import 'meslek.dart';
import 'oyuncu.dart';
import 'sektor.dart';

/// Tüm meslek tanımlarının bellekteki dizini.
///
/// Ayrıştırma SAF DART'tır: girdi JSON metnidir, dosya sistemi ya da asset
/// bundle bilinmez. Böylece motor testleri veriyi doğrudan okuyup binlerce
/// tur simüle edebilir; Flutter tarafındaki yükleyici (`data/`) yalnızca
/// metni getirmekle sorumludur.
class MeslekKatalogu {
  MeslekKatalogu._(this._meslekler, this.cakisanKimlikler);

  final Map<String, Meslek> _meslekler;

  /// Aynı kimlikle birden fazla kez tanımlanmış meslekler. `dogrula` bunu
  /// hataya çevirir; sessizce üzerine yazmak veri kaybıdır.
  final List<String> cakisanKimlikler;

  static final MeslekKatalogu bos = MeslekKatalogu._(const {}, const []);

  factory MeslekKatalogu.listeden(Iterable<Meslek> meslekler) {
    final dizin = <String, Meslek>{};
    final cakisan = <String>[];
    for (final m in meslekler) {
      if (dizin.containsKey(m.id)) {
        cakisan.add(m.id);
      }
      dizin[m.id] = m;
    }
    return MeslekKatalogu._(dizin, cakisan);
  }

  /// Her metin ya tek bir meslek nesnesi ya da meslek dizisi olabilir;
  /// `assets/careers/` altındaki dosyalar ikisini de kullanabilsin diye.
  factory MeslekKatalogu.jsonMetinlerinden(Iterable<String> metinler) {
    final meslekler = <Meslek>[];
    for (final metin in metinler) {
      final cozulmus = jsonDecode(metin);
      if (cozulmus is List) {
        for (final girdi in cozulmus) {
          meslekler.add(Meslek.fromJson(girdi as Map<String, dynamic>));
        }
      } else if (cozulmus is Map<String, dynamic>) {
        meslekler.add(Meslek.fromJson(cozulmus));
      } else {
        throw FormatException(
          'Meslek dosyası nesne ya da dizi olmalı, ${cozulmus.runtimeType} geldi',
        );
      }
    }
    return MeslekKatalogu.listeden(meslekler);
  }

  int get uzunluk => _meslekler.length;

  bool get bosMu => _meslekler.isEmpty;

  List<Meslek> get tumu => List.unmodifiable(_meslekler.values);

  /// Kimlikten meslek; tanınmayan kimlik için null.
  /// Kayıttaki `KariyerDurumu.calisan.meslekId` bununla çözülür.
  Meslek? bul(String id) => _meslekler[id];

  List<Meslek> sektordeki(Sektor sektor) =>
      _meslekler.values.where((m) => m.sektor == sektor).toList();

  /// Oyuncunun şu anda girebileceği meslekler. İş ilanı ekranının kaynağı.
  List<Meslek> girilebilirler(Oyuncu oyuncu) =>
      _meslekler.values.where((m) => m.girebilirMi(oyuncu)).toList();

  /// Tüm katalogun şema doğrulaması. Boş liste = geçerli.
  List<String> dogrula() {
    final hatalar = <String>[
      for (final id in cakisanKimlikler) 'yinelenen meslek kimliği: $id',
    ];
    for (final m in _meslekler.values) {
      hatalar.addAll(m.dogrula());
    }
    return hatalar;
  }
}
