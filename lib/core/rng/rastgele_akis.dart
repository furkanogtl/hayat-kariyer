import 'dart:math' as math;

/// Tek bir alt sistemin (piyasa, olay motoru, bir işletme...) kullandığı
/// rastgelelik akışı.
///
/// Doğrudan `math.Random` kullanmak yerine bu sınıf kullanılır; böylece
/// tüm zar atışları tek noktadan geçer ve oyun motoru saf/deterministik kalır.
class RastgeleAkis {
  /// Akışın adı (ör. `piyasa`, `olay`, `isletme:kafe_01`). Hata ayıklama için.
  final String ad;

  /// Bu akışın türetildiği tur numarası.
  final int tur;

  /// Akışın türetilmiş tohumu. Kayda yazılırsa akış birebir tekrar üretilir.
  final int tohum;

  final math.Random _random;

  /// Box-Muller ikinci değerini saklar; normal dağılım çağrıları arasında
  /// israfı önler.
  double? _bekleyenNormal;

  RastgeleAkis._(this.ad, this.tur, this.tohum) : _random = math.Random(tohum);

  /// Testler ve tek başına kullanım için doğrudan tohumdan akış üretir.
  factory RastgeleAkis.tohumdan(int tohum, {String ad = 'test', int tur = 0}) =>
      RastgeleAkis._(ad, tur, tohum & 0xffffffff);

  /// [RastgeleKaynak] tarafından kullanılır.
  factory RastgeleAkis.turetilmis({
    required String ad,
    required int tur,
    required int tohum,
  }) =>
      RastgeleAkis._(ad, tur, tohum);

  /// [0.0, 1.0) aralığında düzgün dağılımlı sayı.
  double sonraki() => _random.nextDouble();

  /// [enAz, enCok] aralığında düzgün dağılımlı ondalık sayı (iki uç dahil sayılır).
  double aralikOndalik(double enAz, double enCok) {
    assert(enAz <= enCok, 'aralikOndalik: enAz > enCok ($enAz > $enCok)');
    return enAz + (enCok - enAz) * _random.nextDouble();
  }

  /// [enAz, enCokHaric) aralığında tam sayı.
  int aralik(int enAz, int enCokHaric) {
    assert(enAz < enCokHaric, 'aralik: boş aralık [$enAz, $enCokHaric)');
    return enAz + _random.nextInt(enCokHaric - enAz);
  }

  /// [olasilik] ihtimalle `true` döner. 0.0 hiç, 1.0 her zaman.
  bool sans(double olasilik) {
    if (olasilik <= 0) return false;
    if (olasilik >= 1) return true;
    return _random.nextDouble() < olasilik;
  }

  /// Listeden düzgün dağılımla bir eleman seçer.
  T secim<T>(List<T> secenekler) {
    assert(secenekler.isNotEmpty, 'secim: boş liste');
    return secenekler[_random.nextInt(secenekler.length)];
  }

  /// Ağırlıklı seçim. Olay havuzundaki `weight` ve seçenek `chance`
  /// alanları bunun üzerinden çalışır.
  ///
  /// Ağırlıkların toplamı 1 olmak zorunda değildir; negatif ağırlık kabul
  /// edilmez, 0 ağırlıklı eleman asla seçilmez.
  T agirlikliSecim<T>(List<T> secenekler, double Function(T) agirlik) =>
      secenekler[agirlikliIndeks(secenekler.map(agirlik).toList())];

  /// Ağırlık listesinden indeks seçer. Tüm ağırlıklar 0 ise son indeks döner
  /// (yuvarlama hatasına karşı güvenli çıkış).
  int agirlikliIndeks(List<double> agirliklar) {
    assert(agirliklar.isNotEmpty, 'agirlikliIndeks: boş liste');
    var toplam = 0.0;
    for (final a in agirliklar) {
      assert(a >= 0, 'agirlikliIndeks: negatif ağırlık ($a)');
      toplam += a;
    }
    assert(toplam > 0, 'agirlikliIndeks: tüm ağırlıklar sıfır');
    var esik = _random.nextDouble() * toplam;
    for (var i = 0; i < agirliklar.length; i++) {
      esik -= agirliklar[i];
      if (esik < 0) return i;
    }
    return agirliklar.length - 1;
  }

  /// Standart normal dağılım (Box-Muller). Piyasa simülasyonundaki
  /// GBM şoku bunu kullanır.
  double normal({double ortalama = 0.0, double sapma = 1.0}) {
    final bekleyen = _bekleyenNormal;
    if (bekleyen != null) {
      _bekleyenNormal = null;
      return ortalama + sapma * bekleyen;
    }
    // u1 sıfır olursa log(-sonsuz) patlar; sıfırdan kaçınılır.
    double u1;
    do {
      u1 = _random.nextDouble();
    } while (u1 == 0.0);
    final u2 = _random.nextDouble();
    final r = math.sqrt(-2.0 * math.log(u1));
    final aci = 2.0 * math.pi * u2;
    _bekleyenNormal = r * math.sin(aci);
    return ortalama + sapma * (r * math.cos(aci));
  }

  /// Listeyi yerinde karıştırır (deterministik).
  void karistir<T>(List<T> liste) => liste.shuffle(_random);

  @override
  String toString() => 'RastgeleAkis($ad, tur: $tur, tohum: $tohum)';
}
