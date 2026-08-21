import 'package:json_annotation/json_annotation.dart';

/// Eğitim seviyesi. Bir istatistik DEĞİL, mesleklere giriş için ön koşuldur
/// (`Meslek.girisSarti.egitim`).
///
/// Sıralıdır: `yeterliMi` karşılaştırması `index` üzerinden çalışır, bu yüzden
/// sabit listesinin SIRASI korunmalıdır. Araya değer eklemek eski kayıtları
/// bozmaz (JSON değeri isimdir) ama sıralamayı bozarsa denge kayar.
@JsonEnum(valueField: 'id')
enum EgitimSeviyesi {
  ilkogretim('ilkogretim'),
  lise('lise'),
  onlisans('onlisans'),
  lisans('lisans'),
  yuksekLisans('yuksek_lisans'),
  doktora('doktora');

  const EgitimSeviyesi(this.id);

  final String id;

  /// Bu seviye, [gereken] seviyeyi karşılıyor mu?
  bool yeterliMi(EgitimSeviyesi gereken) => index >= gereken.index;

  /// Bir üst seviye; en üstteyse null.
  EgitimSeviyesi? get sonraki =>
      index + 1 < EgitimSeviyesi.values.length
          ? EgitimSeviyesi.values[index + 1]
          : null;

  static EgitimSeviyesi? bul(String id) {
    for (final e in EgitimSeviyesi.values) {
      if (e.id == id) return e;
    }
    return null;
  }
}

/// Cinsiyet. Oyunda tek mekanik etkisi askerliktir (bkz. `KariyerDurumu`).
@JsonEnum(valueField: 'id')
enum Cinsiyet {
  erkek('erkek'),
  kadin('kadin');

  const Cinsiyet(this.id);

  final String id;

  /// Zorunlu askerlik yükümlülüğü.
  bool get askerlikYukumlusu => this == Cinsiyet.erkek;
}
