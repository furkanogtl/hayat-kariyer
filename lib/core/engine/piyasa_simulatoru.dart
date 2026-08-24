import 'dart:math' as math;

import '../models/piyasa_durumu.dart';
import '../models/varlik.dart';
import '../rng/rastgele_akis.dart';
import 'rejim.dart';

/// Makro ekonomiyi ve varlık fiyatlarını yürüten motor.
///
/// Saf ve deterministiktir — aynı `PiyasaDurumu` ve aynı akış aynı sonucu
/// verir. Rastgeleliği kendi üretmez, dışarıdan verilen [RastgeleAkis]'i
/// kullanır; böylece binlerce turluk denge simülasyonu tekrar üretilebilir.
///
/// Her tur için akıştan çekilen zar sayısı DEĞİŞKENDİR (rejim değişimi olup
/// olmamasına göre). Bu sorun değil: `RastgeleKaynak` her tur için ayrı akış
/// türetir, bir turdaki fazladan zar sonraki turları kaydırmaz.
class PiyasaSimulatoru {
  PiyasaSimulatoru({List<VarlikTanimi>? varliklar})
      : varliklar = varliklar ?? piyasaVarliklari;

  /// Fiyatı üretilecek varlıklar. Sıra sabittir; zar atma sırası buna bağlı.
  final List<VarlikTanimi> varliklar;

  /// Enflasyonun inebileceği alt sınır. Türkiye bağlamında kalıcı deflasyon
  /// gerçekçi değil; gürültü aşırıya kaçarsa buradan kesilir.
  static const double enAzAylikEnflasyon = -0.005;

  /// Fiyatın bir turda düşebileceği taban oran. GBM teoride sıfıra inmez ama
  /// aşırı bir şok fiyatı anlamsız kılabilir; oyun için sert bir zemin.
  static const double enAzTurGetirisi = -0.75;

  /// Tek turluk getirinin tavanı.
  ///
  /// Tabanla SİMETRİK olması için var. Yalnızca alttan kırpmak, maaş
  /// şokunda düzeltilen hatanın aynısını yapardı: en kötü sonuçlar
  /// budanır, en iyiler serbest kalır ve oynak varlıklar sistematik
  /// olarak fazladan kazanır. İkisi de ~4 sigma uzaklıkta, yani normal
  /// oyunda hiç devreye girmez.
  static const double enCokTurGetirisi = 3.0;

  PiyasaDurumu baslangic({Rejim rejim = Rejim.buyume}) => PiyasaDurumu(
        rejim: rejim,
        fiyatlar: {for (final v in varliklar) v.id: v.baslangicFiyati},
        // Grafiğin ilk turdan itibaren bir dayanağı olsun.
      ).gecmiseYaz();

  /// Bir turu işler: rejim geçişi → enflasyon → varlık fiyatları → para reformu.
  PiyasaDurumu turIsle(PiyasaDurumu onceki, RastgeleAkis akis) {
    final rejim = _sonrakiRejim(onceki, akis);
    final rejimDegisti = rejim != onceki.rejim;
    final parametre = rejim.parametreler;

    var aylik = akis.normal(
      ortalama: parametre.aylikEnflasyon,
      sapma: parametre.enflasyonOynakligi,
    );
    if (aylik < enAzAylikEnflasyon) aylik = enAzAylikEnflasyon;

    final sonraki = onceki.copyWith(
      rejim: rejim,
      rejimSuresi: rejimDegisti ? 1 : onceki.rejimSuresi + 1,
      enflasyonEndeksi: onceki.enflasyonEndeksi * (1 + aylik),
      sonAylikEnflasyon: aylik,
      paraReformuYapildi: false,
      fiyatlar: _yeniFiyatlar(onceki.fiyatlar, rejim, akis),
    );

    // Sıfır atma: motorun hesapları değişmez, yalnızca gösterim ölçeği kayar.
    // Fiyatlar ve nakit ham TL olarak tutulmaya devam eder.
    if (sonraki.paraReformuGerekli) {
      return sonraki
          .copyWith(
            paraReformuSayisi: sonraki.paraReformuSayisi + 1,
            paraReformuYapildi: true,
          )
          .gecmiseYaz();
    }
    // Geçmiş REEL tutuluyor; para reformu yalnız gösterim ölçeği olduğu
    // için seriye dokunmuyor.
    return sonraki.gecmiseYaz();
  }

  Rejim _sonrakiRejim(PiyasaDurumu onceki, RastgeleAkis akis) {
    if (!onceki.rejimDegisebilir) return onceki.rejim;
    if (!akis.sans(rejimDegisimSansi)) return onceki.rejim;

    final agirliklar = onceki.rejim.parametreler.gecisAgirliklari;
    final adaylar = agirliklar.keys.toList();
    return akis.agirlikliSecim(adaylar, (r) => agirliklar[r]!);
  }

  /// GBM adımı: `fiyat *= exp(drift + sigma*z)`.
  ///
  /// `drift` bileşik (logaritmik) getiri olarak tanımlı, bu yüzden
  /// `-sigma^2/2` düzeltmesi UYGULANMAZ. Uygulansaydı yüksek oynaklıklı
  /// varlıklar tabloda yazandan kalıcı olarak geride kalırdı; hisse senedi
  /// 40 yılda enflasyonun altında kalıyor, yani borsa oyuncu için tuzağa
  /// dönüşüyordu.
  Map<String, double> _yeniFiyatlar(
    Map<String, double> oncekiler,
    Rejim rejim,
    RastgeleAkis akis,
  ) {
    // Ortak şoklar önce çekilir: aynı turda tüm hisseler ve kripto aynı
    // piyasa rüzgârını, döviz ve altın aynı kur rüzgârını yer.
    final ortakSoklar = <OrtakFaktor, double>{
      OrtakFaktor.piyasa: akis.normal(),
      OrtakFaktor.kur: akis.normal(),
      OrtakFaktor.yok: 0.0,
    };

    final yeniler = <String, double>{};
    for (final varlik in varliklar) {
      final p = varlik.parametre(rejim);
      final bireysel = akis.normal();
      final agirlik = varlik.ortakFaktor == OrtakFaktor.yok
          ? 0.0
          : varlik.ortakAgirlik;
      // Toplam varyans 1 kalsın diye bireysel payın ağırlığı sqrt(1-a^2).
      final z = agirlik * ortakSoklar[varlik.ortakFaktor]! +
          math.sqrt(1 - agirlik * agirlik) * bireysel;

      final sigma = p.oynaklik;
      final logGetiri = p.drift + sigma * z;
      final carpan = math
          .exp(logGetiri)
          .clamp(1 + enAzTurGetirisi, 1 + enCokTurGetirisi);

      final mevcut = oncekiler[varlik.id] ?? varlik.baslangicFiyati;
      yeniler[varlik.id] = mevcut * carpan;
    }
    return yeniler;
  }
}
