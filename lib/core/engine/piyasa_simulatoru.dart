import '../models/piyasa_durumu.dart';
import '../rng/rastgele_akis.dart';
import 'rejim.dart';

/// Makro ekonomiyi yürüten motor: rejim geçişleri ve enflasyon.
///
/// Saf ve deterministiktir — aynı `PiyasaDurumu` ve aynı akış aynı sonucu
/// verir. Rastgeleliği kendi üretmez, dışarıdan verilen [RastgeleAkis]'i
/// kullanır; böylece binlerce turluk denge simülasyonu tekrar üretilebilir.
///
/// Her tur için akıştan çekilen zar sayısı DEĞİŞKENDİR (rejim değişimi olup
/// olmamasına göre). Bu sorun değil: `RastgeleKaynak` her tur için ayrı akış
/// türetir, bir turdaki fazladan zar sonraki turları kaydırmaz.
class PiyasaSimulatoru {
  const PiyasaSimulatoru();

  /// Enflasyonun inebileceği alt sınır. Türkiye bağlamında kalıcı deflasyon
  /// gerçekçi değil; gürültü aşırıya kaçarsa buradan kesilir.
  static const double enAzAylikEnflasyon = -0.005;

  PiyasaDurumu baslangic({Rejim rejim = Rejim.buyume}) =>
      PiyasaDurumu(rejim: rejim);

  /// Bir turu işler: önce rejim geçişi, sonra o rejimin enflasyonu.
  PiyasaDurumu turIsle(PiyasaDurumu onceki, RastgeleAkis akis) {
    final rejim = _sonrakiRejim(onceki, akis);
    final rejimDegisti = rejim != onceki.rejim;
    final parametre = rejim.parametreler;

    var aylik = akis.normal(
      ortalama: parametre.aylikEnflasyon,
      sapma: parametre.enflasyonOynakligi,
    );
    if (aylik < enAzAylikEnflasyon) aylik = enAzAylikEnflasyon;

    return onceki.copyWith(
      rejim: rejim,
      rejimSuresi: rejimDegisti ? 1 : onceki.rejimSuresi + 1,
      enflasyonEndeksi: onceki.enflasyonEndeksi * (1 + aylik),
      sonAylikEnflasyon: aylik,
    );
  }

  Rejim _sonrakiRejim(PiyasaDurumu onceki, RastgeleAkis akis) {
    if (!onceki.rejimDegisebilir) return onceki.rejim;
    if (!akis.sans(rejimDegisimSansi)) return onceki.rejim;

    final agirliklar = onceki.rejim.parametreler.gecisAgirliklari;
    final adaylar = agirliklar.keys.toList();
    return akis.agirlikliSecim(adaylar, (r) => agirliklar[r]!);
  }
}
