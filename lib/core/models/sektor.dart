import 'package:json_annotation/json_annotation.dart';

/// Kariyer sektörleri. Yetkinlik SEKTÖR bazında birikir: yazılımcıdan veri
/// bilimciye geçiş yetkinliği korur, yazılımcıdan avukatlığa geçiş sıfırdan
/// başlatır.
///
/// Liste sabittir; yeni sektör eklemek kod değişikliğidir. Meslekler ise
/// veridir (`assets/careers/*.json`) ve serbestçe eklenir.
@JsonEnum(valueField: 'id')
enum Sektor {
  saglik('saglik'),
  teknoloji('teknoloji'),
  hukukKamu('hukuk_kamu'),
  finans('finans'),
  ticaret('ticaret'),
  esnaf('esnaf'),
  medya('medya'),
  lojistik('lojistik'),
  tarim('tarim'),
  turizm('turizm');

  const Sektor(this.id);

  /// JSON ve kayıt dosyasında kullanılan sabit kimlik. Enum adı değişse bile
  /// bu değişmez — eski kayıtlar okunabilir kalır.
  final String id;

  /// Kimlikten sektör bulur; tanınmayan kimlik için null döner.
  /// Veri dosyası doğrulaması bunu kullanır.
  static Sektor? bul(String id) {
    for (final s in Sektor.values) {
      if (s.id == id) return s;
    }
    return null;
  }
}
