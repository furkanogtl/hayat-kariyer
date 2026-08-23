import 'package:freezed_annotation/freezed_annotation.dart';

import 'egitim_seviyesi.dart';

part 'kariyer_durumu.freezed.dart';
part 'kariyer_durumu.g.dart';

/// Kariyer durumunun türü.
///
/// Sealed sınıfın kendisi motorda `switch` ile ele alınır; bu enum yalnızca
/// VERİ dosyalarının (olay kartı koşulları) duruma referans verebilmesi için
/// var. JSON'a enum yazmak, kart yazarken `"durumlar": ["issiz"]` demeyi
/// mümkün kılıyor.
@JsonEnum(valueField: 'id')
enum KariyerTuru {
  ogrenci('ogrenci'),
  calisan('calisan'),
  issiz('issiz'),
  askerlik('askerlik'),
  emekli('emekli');

  const KariyerTuru(this.id);

  final String id;

  static KariyerTuru? bul(String id) {
    for (final t in KariyerTuru.values) {
      if (t.id == id) return t;
    }
    return null;
  }
}

/// Oyuncunun o anki kariyer durumu.
///
/// "Meslek" nullable bir alan olarak tutulmaz; öğrencilik, işsizlik, askerlik
/// ve emeklilik de birer durumdur ve her birinin kendi verisi vardır.
/// Sealed sınıf sayesinde motor `switch` ile tüm durumları ele almaya
/// derleyici tarafından zorlanır — yeni durum eklendiğinde unutulan yer
/// derleme hatası verir.
///
/// JSON ayrımı sabit `durum` anahtarıyla yapılır; enum adı değişse bile eski
/// kayıtlar okunur.
@Freezed(unionKey: 'durum')
sealed class KariyerDurumu with _$KariyerDurumu {
  const KariyerDurumu._();

  /// Okuyor. Gelir yok, KYK borcu birikir, yetkinlik hızlı artar.
  @FreezedUnionValue('ogrenci')
  const factory KariyerDurumu.ogrenci({
    required EgitimSeviyesi hedef,

    /// Mezuniyete kalan tur.
    required int kalanTur,
  }) = Ogrenci;

  /// Çalışıyor.
  @FreezedUnionValue('calisan')
  const factory KariyerDurumu.calisan({
    /// `assets/careers/*.json` içindeki meslek kimliği.
    required String meslekId,

    /// Kariyer merdivenindeki basamak indeksi.
    @Default(0) int kademeIndeksi,

    /// Bu kademede geçirilen tur sayısı. Terfinin kıdem kapısı buna bakar.
    @Default(0) int kademeTuru,

    /// Kayıt dışı çalışma: net gelir yüksek, SGK primi yok, koruma yok.
    @Default(false) bool kayitDisi,
  }) = Calisan;

  /// İşsiz. Gelir yok, giderler devam eder.
  @FreezedUnionValue('issiz')
  const factory KariyerDurumu.issiz({
    @Default(0) int gecenTur,

    /// Atama bekleyen öğretmen/memur bu bayrakla işaretlenir; işsizlikten
    /// farklı olay havuzu ve farklı çıkış yolu kullanır.
    @Default(false) bool atamaBekliyor,

    /// Ataması beklenen meslek. Kura çıkınca oyuncu doğrudan bu mesleğe
    /// başlar; sınavı kazandığı meslek ile atandığı meslek ayrışmasın.
    String? bekleyenMeslekId,
  }) = Issiz;

  /// Askerlik. Kariyer durur.
  @FreezedUnionValue('askerlik')
  const factory KariyerDurumu.askerlik({
    required int kalanTur,

    /// Bedelli askerlik mi (para ödendi, süre kısa).
    @Default(false) bool bedelli,

    /// Askere alınmadan önceki iş. Terhiste İŞE İADE edilir — gerçek
    /// hayatta da yasal hak. Yoksa askerlik "6 ay gelir kaybı" değil
    /// "kariyeri sıfırla" cezası olurdu.
    String? oncekiMeslekId,
    @Default(0) int oncekiKademeIndeksi,
  }) = Askerlik;

  /// Emekli. Maaş prim gün sayısından hesaplanıp burada dondurulur.
  @FreezedUnionValue('emekli')
  const factory KariyerDurumu.emekli({
    /// Emeklilik anında hesaplanan taban aylık (enflasyon endeksi ayrıca
    /// uygulanır).
    required int tabanAylik,
  }) = Emekli;

  factory KariyerDurumu.fromJson(Map<String, dynamic> json) =>
      _$KariyerDurumuFromJson(json);

  /// Durumun veri dosyalarında kullanılan türü.
  KariyerTuru get turu => switch (this) {
        Ogrenci() => KariyerTuru.ogrenci,
        Calisan() => KariyerTuru.calisan,
        Issiz() => KariyerTuru.issiz,
        Askerlik() => KariyerTuru.askerlik,
        Emekli() => KariyerTuru.emekli,
      };

  /// Aktif olarak bir meslekte çalışıyor mu.
  bool get calisiyorMu => this is Calisan;

  /// Maaş/gelir üretiyor mu (emekli aylığı dahil).
  bool get gelirVarMi => switch (this) {
        Calisan() => true,
        Emekli() => true,
        Ogrenci() => false,
        Issiz() => false,
        Askerlik() => false,
      };

  /// SGK primi yatıyor mu. Kayıt dışı çalışan ve öğrenci için hayır.
  bool get primYatiyorMu => switch (this) {
        Calisan(:final kayitDisi) => !kayitDisi,
        Askerlik() => false,
        Ogrenci() => false,
        Issiz() => false,
        Emekli() => false,
      };

  /// Çalışılan meslek kimliği; çalışmıyorsa null.
  String? get meslekId => switch (this) {
        Calisan(:final meslekId) => meslekId,
        _ => null,
      };

  /// Süresi dolmuş mu (öğrencilik/askerlik gibi geri sayımlı durumlar için).
  /// Süresiz durumlarda daima false.
  bool get suresiDoldu => switch (this) {
        Ogrenci(:final kalanTur) => kalanTur <= 0,
        Askerlik(:final kalanTur) => kalanTur <= 0,
        _ => false,
      };

  /// Bir tur ilerlet: geri sayımları azaltır, sayaçları artırır.
  /// Durum geçişlerine KARAR VERMEZ — o motorun işidir.
  ///
  /// Her dal `copyWith` kullanır, elle yeniden kurmaz. Önce elle
  /// kuruluyordu ve `Askerlik`'e `oncekiMeslekId` eklendiğinde alan
  /// sessizce düştü: askerden dönen oyuncu işine iade edilmiyor, işsiz
  /// kalıyordu. Hiçbir yerde patlamayan, yalnız 40 yıllık simülasyonda
  /// görünen bir hataydı.
  KariyerDurumu turIlerlet() => switch (this) {
        Ogrenci d => d.copyWith(kalanTur: d.kalanTur - 1),
        Askerlik d => d.copyWith(kalanTur: d.kalanTur - 1),
        Calisan d => d.copyWith(kademeTuru: d.kademeTuru + 1),
        Issiz d => d.copyWith(gecenTur: d.gecenTur + 1),
        Emekli() => this,
      };
}
