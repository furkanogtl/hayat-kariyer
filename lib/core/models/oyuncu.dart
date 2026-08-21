import 'package:freezed_annotation/freezed_annotation.dart';

part 'oyuncu.freezed.dart';
part 'oyuncu.g.dart';

/// Oyuncunun tüm durumu. Anayasadaki altı istatistik dışında stat eklenmez.
///
/// Değiştirilemez (immutable) bir yapıdır; her tur motorun ürettiği yeni bir
/// `Oyuncu` örneğiyle ilerlenir. Sınır kontrolleri (clamp) bu sınıfın
/// `...Degistir` metotlarında toplanmıştır — motor içinde elle `copyWith`
/// çağırıp sınır aşmak serbest bırakılmaz.
@freezed
abstract class Oyuncu with _$Oyuncu {
  const Oyuncu._();

  const factory Oyuncu({
    required String ad,

    /// Oyuncunun yaşadığı şehir (İstanbul, Konya, Trabzon, Gaziantep, İzmir).
    required String sehir,

    /// Oynanan tur sayısı. 1 tur = 1 ay. İlk tur 0'dır.
    @Default(0) int tur,

    /// Oyuna başlanan yaş. Yaş buradan ve turdan TÜRETİLİR, ayrıca tutulmaz;
    /// iki alan ayrı tutulsa er ya da geç birbirinden kayar.
    @Default(Oyuncu.baslangicYasiVarsayilan) int baslangicYasi,

    /// Nakit (TL). Kuruş tutulmaz.
    @Default(0) int nakit,

    /// Enerji/Sağlık. 0'a inerse hastalık ve tur kaybı riski.
    @Default(Oyuncu.enerjiTavan) int enerji,

    /// Mutluluk/Stres ekseni. Düşerse burnout, performans düşer.
    @Default(70) int mutluluk,

    /// İtibar/Network. Fırsat kartlarının KALİTESİNİ belirler.
    @Default(5) int itibar,

    /// Kredi notu. Borçlanma limiti ve faiz oranını belirler.
    @Default(Oyuncu.krediNotuBaslangic) int krediNotu,

    /// Sektör kimliği -> yetkinlik (0-100). Sektör listesi veri katmanında
    /// tanımlanır; model belirli bir sektör kümesine bağlanmaz.
    @Default(<String, int>{}) Map<String, int> yetkinlikler,
  }) = _Oyuncu;

  factory Oyuncu.fromJson(Map<String, dynamic> json) => _$OyuncuFromJson(json);

  /// Yeni oyun başlangıcı.
  factory Oyuncu.yeni({required String ad, required String sehir}) =>
      Oyuncu(ad: ad, sehir: sehir);

  static const int baslangicYasiVarsayilan = 18;
  static const int enerjiTaban = 0;
  static const int enerjiTavan = 100;
  static const int mutlulukTaban = 0;
  static const int mutlulukTavan = 100;
  static const int itibarTaban = 0;
  static const int itibarTavan = 100;
  static const int yetkinlikTaban = 0;
  static const int yetkinlikTavan = 100;

  /// Findeks benzeri aralık. Kurgusaldır, gerçek bir skorlama modeli değildir.
  static const int krediNotuTaban = 300;
  static const int krediNotuTavan = 1900;
  static const int krediNotuBaslangic = 1000;

  /// Burnout eşiği; altına inince performans cezası uygulanır.
  static const int burnoutEsigi = 20;

  /// Yaş turdan türetilir.
  int get yas => baslangicYasi + tur ~/ 12;

  /// Takvim ayı (1-12). Askerlik, vergi, asgari ücret zammı gibi mevsimsel
  /// olaylar buna bakar.
  int get ay => tur % 12 + 1;

  /// Oyuncu tükenmiş mi (enerji bitti).
  bool get tukenmis => enerji <= enerjiTaban;

  /// Burnout durumu.
  bool get burnout => mutluluk < burnoutEsigi;

  /// Belirli bir sektördeki yetkinlik. Tanımsız sektör 0 sayılır.
  int yetkinlik(String sektorId) => yetkinlikler[sektorId] ?? 0;

  /// En yüksek yetkinliğe sahip sektör; hiç yoksa null.
  String? get anaSektor {
    String? enIyi;
    var enYuksek = 0;
    for (final girdi in yetkinlikler.entries) {
      if (girdi.value > enYuksek) {
        enYuksek = girdi.value;
        enIyi = girdi.key;
      }
    }
    return enIyi;
  }

  /// Net değer. Varlık ve borç toplamları dışarıdan verilir; oyuncu modeli
  /// portföyü tanımaz (bağımlılık yönü: engine -> model).
  int netDeger({int varliklar = 0, int borclar = 0}) =>
      nakit + varliklar - borclar;

  Oyuncu nakitDegistir(int fark) => copyWith(nakit: nakit + fark);

  Oyuncu enerjiDegistir(int fark) =>
      copyWith(enerji: _sinirla(enerji + fark, enerjiTaban, enerjiTavan));

  Oyuncu mutlulukDegistir(int fark) => copyWith(
        mutluluk: _sinirla(mutluluk + fark, mutlulukTaban, mutlulukTavan),
      );

  Oyuncu itibarDegistir(int fark) =>
      copyWith(itibar: _sinirla(itibar + fark, itibarTaban, itibarTavan));

  Oyuncu krediNotuDegistir(int fark) => copyWith(
        krediNotu: _sinirla(krediNotu + fark, krediNotuTaban, krediNotuTavan),
      );

  Oyuncu yetkinlikDegistir(String sektorId, int fark) {
    final guncel = yetkinlik(sektorId);
    return copyWith(
      yetkinlikler: {
        ...yetkinlikler,
        sektorId: _sinirla(guncel + fark, yetkinlikTaban, yetkinlikTavan),
      },
    );
  }

  /// Bir sonraki aya geçer. Yaş ilerlemesi buradan otomatik gelir.
  Oyuncu turIlerlet() => copyWith(tur: tur + 1);

  /// Kayıttan yüklenen ya da elle üretilmiş veriyi sınırlara çeker.
  /// Bozuk/eski kayıtlara karşı savunma hattıdır.
  Oyuncu duzelt() => copyWith(
        tur: tur < 0 ? 0 : tur,
        enerji: _sinirla(enerji, enerjiTaban, enerjiTavan),
        mutluluk: _sinirla(mutluluk, mutlulukTaban, mutlulukTavan),
        itibar: _sinirla(itibar, itibarTaban, itibarTavan),
        krediNotu: _sinirla(krediNotu, krediNotuTaban, krediNotuTavan),
        yetkinlikler: {
          for (final g in yetkinlikler.entries)
            g.key: _sinirla(g.value, yetkinlikTaban, yetkinlikTavan),
        },
      );
}

int _sinirla(int deger, int taban, int tavan) =>
    deger < taban ? taban : (deger > tavan ? tavan : deger);
