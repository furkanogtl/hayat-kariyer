import 'package:freezed_annotation/freezed_annotation.dart';

import 'oyuncu.dart';
import 'sektor.dart';

part 'isletme.freezed.dart';
part 'isletme.g.dart';

/// Bir gelir/gider kaleminin nasıl hesaplandığı.
///
/// JSON'a FORMÜL DİLİ konmadı. İfade ayrıştırıcısı yazmak hem kayıt
/// uyumluluğunu hem denge testini zorlaştırırdı; kalemler tipli, hesap
/// motorda. Kafe ile otel arasındaki fark bu üç tipin farklı
/// birleşimlerinden çıkıyor.
@JsonEnum(valueField: 'id')
enum KalemTuru {
  /// Taban TL sabit. Kira, maaş, sigorta.
  sabit('sabit'),

  /// Bir özel stata orantılı: `taban * stat / 100`. Otelde doluluk,
  /// kafede müşteri tabanı.
  stataBagli('stata_bagli'),

  /// Ciroya oranlı: `oran * toplamGelir`. Malzeme maliyeti, komisyon.
  cirodanPay('cirodan_pay');

  const KalemTuru(this.id);

  final String id;
}

/// Periyodik gelir ya da gider kalemi.
///
/// İşaret alanın kendisinde değil kullanıldığı listede: [IsletmeTanimi]
/// gelirleri artı, giderleri eksi işler. Aynı sınıfın ikisine de hizmet
/// etmesi, "gideri negatif gelir olarak yaz" gibi bir kaçamağı önlüyor.
@freezed
abstract class Kalem with _$Kalem {
  const Kalem._();

  const factory Kalem({
    required String ad,
    @Default(KalemTuru.sabit) KalemTuru tur,

    /// TABAN TL (2026 ölçeği). Motor enflasyon endeksiyle çarpar.
    /// [KalemTuru.cirodanPay] için kullanılmaz.
    @Default(0) int taban,

    /// [KalemTuru.stataBagli] için: hangi özel stat (0-100).
    String? statId,

    /// [KalemTuru.cirodanPay] için: cironun kaçta kaçı (0-1).
    @Default(0.0) double oran,

    /// Kaç turda bir işler. 1 = her ay, 12 = yılda bir (vergi, sigorta).
    @Default(1) int periyotTur,
  }) = _Kalem;

  factory Kalem.fromJson(Map<String, dynamic> json) => _$KalemFromJson(json);

  /// Bu kalem [tur] turunda işliyor mu.
  bool isliyorMu(int tur) => periyotTur <= 1 || tur % periyotTur == 0;

  List<String> dogrula(String isletmeId, Set<String> tanimliStatlar) {
    final hatalar = <String>[];
    final yer = '$isletmeId/$ad';
    if (ad.isEmpty) hatalar.add('$isletmeId: kalem adı boş');
    if (periyotTur < 1) hatalar.add('$yer: periyot en az 1 olmalı');
    switch (tur) {
      case KalemTuru.sabit:
        if (taban <= 0) hatalar.add('$yer: sabit kalemin tabanı pozitif olmalı');
      case KalemTuru.stataBagli:
        if (taban <= 0) hatalar.add('$yer: tabanı pozitif olmalı');
        if (statId == null) {
          hatalar.add('$yer: stata bağlı kalemde statId yok');
        } else if (!tanimliStatlar.contains(statId)) {
          hatalar.add('$yer: tanımsız stat $statId');
        }
      case KalemTuru.cirodanPay:
        if (oran <= 0 || oran >= 1) {
          hatalar.add('$yer: cirodan pay oranı 0-1 arasında olmalı');
        }
    }
    return hatalar;
  }
}

/// İşletmeyi açabilmek için gereken şartlar.
@freezed
abstract class IsletmeGirisSarti with _$IsletmeGirisSarti {
  const IsletmeGirisSarti._();

  const factory IsletmeGirisSarti({
    /// Sektör yetkinliği: işletmeyi meslekten bağımsız açmak zor olmalı.
    Sektor? sektor,
    @Default(0) int yetkinlik,
    @Default(0) int itibar,
    @Default(18) int enAzYas,
  }) = _IsletmeGirisSarti;

  factory IsletmeGirisSarti.fromJson(Map<String, dynamic> json) =>
      _$IsletmeGirisSartiFromJson(json);

  bool karsilaniyorMu(Oyuncu oyuncu) {
    if (oyuncu.yas < enAzYas) return false;
    if (oyuncu.itibar < itibar) return false;
    final s = sektor;
    if (s != null && (oyuncu.yetkinlikler[s] ?? 0) < yetkinlik) return false;
    return true;
  }
}

/// Bir işletme TÜRÜNÜN tanımı — `assets/businesses/*.json`.
///
/// Anayasa `abstract class Isletme` çiziyordu; soyutlama kalıtımla değil
/// VERİYLE kuruldu. Alt sınıf yazmak, her işletme türü için Dart yazmak
/// demekti — yasaklanan şeyin ta kendisi. Kafe ile futbol kulübü arasındaki
/// fark tek satır kod değil, yalnızca bu tanımın alanları.
@freezed
abstract class IsletmeTanimi with _$IsletmeTanimi {
  const IsletmeTanimi._();

  const factory IsletmeTanimi({
    required String id,
    required String ad,

    /// Kuruluş/satın alma maliyeti — TABAN TL.
    required int sermaye,
    @Default(<Kalem>[]) List<Kalem> gelirler,
    @Default(<Kalem>[]) List<Kalem> giderler,

    /// Oyuncunun her tur ayırması gereken ilgi puanı. Oyunun strateji
    /// derinliğinin temeli: ilgi sınırlı bir kaynaktır, işletme sayısı
    /// bununla sınırlanır.
    @Default(1) int yonetimYuku,

    /// İtibara aylık katkı.
    @Default(0.0) double prestij,

    /// Özel statların başlangıç değerleri (hepsi 0-100 ölçeğinde).
    /// Ölçek ortak olmasaydı denge testi yazılamazdı.
    @Default(<String, int>{}) Map<String, int> baslangicStatlari,

    /// Bu işletmeye özel olay kartı kimlikleri.
    @Default(<String>[]) List<String> olayHavuzu,
    @Default(IsletmeGirisSarti()) IsletmeGirisSarti girisSarti,

    /// CEO/genel müdür aylığı — TABAN TL.
    required int ceoMaasi,

    /// CEO'nun düşürdüğü yönetim yükü oranı (0-1).
    @Default(0.7) double ceoEtkinligi,

    /// Satışta yıllık kârın kaç katı isteniyor.
    @Default(3.0) double degerCarpani,

    /// Satışın tamamlanması kaç tur sürer.
    @Default(3) int satisSuresiTur,
  }) = _IsletmeTanimi;

  factory IsletmeTanimi.fromJson(Map<String, dynamic> json) =>
      _$IsletmeTanimiFromJson(json);

  Set<String> get statlar => baslangicStatlari.keys.toSet();

  /// Veri dosyası doğrulaması. Boş liste = geçerli.
  List<String> dogrula() {
    final hatalar = <String>[];
    if (id.isEmpty) hatalar.add('işletme id boş');
    if (ad.isEmpty) hatalar.add('$id: ad boş');
    if (sermaye <= 0) hatalar.add('$id: sermaye pozitif olmalı');
    if (ceoMaasi <= 0) hatalar.add('$id: ceoMaasi pozitif olmalı');
    if (yonetimYuku < 1) hatalar.add('$id: yönetim yükü en az 1 olmalı');
    if (ceoEtkinligi <= 0 || ceoEtkinligi >= 1) {
      hatalar.add('$id: ceoEtkinligi 0-1 arasında olmalı');
    }
    if (gelirler.isEmpty) hatalar.add('$id: gelir kalemi yok');
    if (degerCarpani <= 0) hatalar.add('$id: degerCarpani pozitif olmalı');
    if (satisSuresiTur < 1) hatalar.add('$id: satış süresi en az 1 tur');

    for (final g in baslangicStatlari.entries) {
      if (g.value < 0 || g.value > 100) {
        hatalar.add('$id: ${g.key} statı 0-100 dışında (${g.value})');
      }
    }
    for (final k in [...gelirler, ...giderler]) {
      hatalar.addAll(k.dogrula(id, statlar));
    }

    // Ciro payı toplamı 1'i geçerse işletme her ay kesin zarar eder.
    final ciroPayi = giderler
        .where((k) => k.tur == KalemTuru.cirodanPay)
        .fold<double>(0, (t, k) => t + k.oran);
    if (ciroPayi >= 1) {
      hatalar.add('$id: cirodan pay giderleri toplamı $ciroPayi (1 altında olmalı)');
    }
    return hatalar;
  }
}

/// Oyuncunun sahip olduğu işletme ÖRNEĞİ. Kayıt dosyasına bu girer.
///
/// Tanım kayda yazılmaz: denge güncellemesi (kira arttı, marj daraldı) eski
/// kayıtları bozmasın diye. Meslek/KariyerDurumu ayrımının aynısı.
@freezed
abstract class Isletme with _$Isletme {
  const Isletme._();

  const factory Isletme({
    /// Örnek kimliği — aynı türden iki kafe ayırt edilebilsin.
    required String id,
    required String tanimId,

    /// Kaçıncı turda kuruldu.
    required int kurulusTuru,

    /// Güncel özel statlar (0-100).
    @Default(<String, int>{}) Map<String, int> statlar,

    /// Genel müdür atandı mı. İlgi yükünü düşürür, kârı da düşürür,
    /// zimmet riski getirir.
    @Default(false) bool ceoVar,

    /// Son turun net kârı (nominal TL). UI ve satış değeri bunu okur.
    @Default(0) int sonNetKar,

    /// Son 12 turun net kâr toplamı — satış değerinin tabanı.
    @Default(0) int yillikNetKar,

    /// Motorun her tur yazdığı güncel değerleme (nominal TL). Net değer
    /// hesabı katalogsuz yapılabilsin diye örneğin üstünde tutuluyor;
    /// [OyunDurumu] tanım dosyasını tanımaz.
    @Default(0) int guncelDeger,

    /// Üst üste kaç turdur yeterli ilgi görmedi. Kriz ihtimali buna bakar.
    @Default(0) int ihmalTuru,

    /// Satışa çıkarıldıysa kalan tur.
    int? satisKalanTur,
  }) = _Isletme;

  factory Isletme.fromJson(Map<String, dynamic> json) =>
      _$IsletmeFromJson(json);

  bool get satista => satisKalanTur != null;

  int stat(String id) => statlar[id] ?? 0;

  /// Statı 0-100 aralığında tutarak değiştirir. Sınır kontrolü tek yerde
  /// olsun diye motor doğrudan map'e yazmıyor.
  Isletme statDegistir(String statId, int delta) {
    final yeni = (stat(statId) + delta).clamp(0, 100);
    return copyWith(statlar: {...statlar, statId: yeni});
  }

  Isletme duzelt() => copyWith(
        statlar: {
          for (final g in statlar.entries) g.key: g.value.clamp(0, 100),
        },
        ihmalTuru: ihmalTuru < 0 ? 0 : ihmalTuru,
      );
}
