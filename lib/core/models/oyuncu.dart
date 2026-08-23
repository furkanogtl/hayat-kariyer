import 'package:freezed_annotation/freezed_annotation.dart';

import 'egitim_seviyesi.dart';
import 'kariyer_durumu.dart';
import 'sehir.dart';
import 'sektor.dart';

part 'oyuncu.freezed.dart';
part 'oyuncu.g.dart';

/// Oyuncunun tüm durumu. Anayasadaki altı istatistik dışında stat eklenmez.
///
/// `egitim`, `cinsiyet` ve `kariyer` birer istatistik değil DURUM alanıdır;
/// mesleklere giriş şartı ve askerlik mekaniği bunlara bağlıdır.
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

    /// Oyuncunun yaşadığı şehir. Yaşam gideri çarpanı buradan gelir.
    required Sehir sehir,

    /// Oynanan tur sayısı. 1 tur = 1 ay. İlk tur 0'dır.
    @Default(0) int tur,

    /// Oyuna başlanan yaş. Yaş buradan ve turdan TÜRETİLİR, ayrıca tutulmaz;
    /// iki alan ayrı tutulsa er ya da geç birbirinden kayar.
    @Default(Oyuncu.baslangicYasiVarsayilan) int baslangicYasi,

    /// Tek mekanik etkisi askerliktir.
    @Default(Cinsiyet.erkek) Cinsiyet cinsiyet,

    /// Mesleklere giriş ön koşulu.
    @Default(EgitimSeviyesi.lise) EgitimSeviyesi egitim,

    /// Öğrenci / çalışan / işsiz / askerlik / emekli.
    @Default(KariyerDurumu.issiz()) KariyerDurumu kariyer,

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

    /// Sektör -> yetkinlik (0-100). Yetkinlik meslek değil SEKTÖR bazında
    /// birikir: sektör içi geçiş bilgiyi korur, sektör dışına geçiş sıfırlar.
    @Default(<Sektor, int>{}) Map<Sektor, int> yetkinlikler,

    /// Yatan SGK primi (ay). Emekli aylığı buna bağlıdır; kayıt dışı çalışan
    /// oyuncu geç oyunda bunun bedelini öder.
    @Default(0) int sgkPrimAyi,

    /// Askerlik tamamlandı mı (bedelli dahil). Kadın oyuncuda hep true
    /// sayılır; kontrol [Cinsiyet.askerlikYukumlusu] üzerinden yapılır.
    @Default(false) bool askerlikYapildi,

    /// Celp tebligatı geldiyse kalan tur. Bu sürede bedelli ödenebilir;
    /// sıfıra inince oyuncu askere alınır. null = tebligat yok.
    int? celpKalanTur,
  }) = _Oyuncu;

  factory Oyuncu.fromJson(Map<String, dynamic> json) => _$OyuncuFromJson(json);

  /// Yeni oyun başlangıcı.
  factory Oyuncu.yeni({
    required String ad,
    required Sehir sehir,
    Cinsiyet cinsiyet = Cinsiyet.erkek,
    EgitimSeviyesi egitim = EgitimSeviyesi.lise,
  }) =>
      Oyuncu(ad: ad, sehir: sehir, cinsiyet: cinsiyet, egitim: egitim);

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

  /// Askerlik yükümlüsü mü (henüz yapmadıysa ilgili olaylar tetiklenir).
  bool get askerlikYukumlusu => cinsiyet.askerlikYukumlusu;

  /// Belirli bir sektördeki yetkinlik. Tanımsız sektör 0 sayılır.
  int yetkinlik(Sektor sektor) => yetkinlikler[sektor] ?? 0;

  /// En yüksek yetkinliğe sahip sektör; hiç yoksa null.
  Sektor? get anaSektor {
    Sektor? enIyi;
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

  Oyuncu yetkinlikDegistir(Sektor sektor, int fark) => copyWith(
        yetkinlikler: {
          ...yetkinlikler,
          sektor: _sinirla(
            yetkinlik(sektor) + fark,
            yetkinlikTaban,
            yetkinlikTavan,
          ),
        },
      );

  /// Kariyer durumunu değiştirir. Geçişin geçerliliğine motor karar verir.
  Oyuncu kariyerDegistir(KariyerDurumu yeniDurum) =>
      copyWith(kariyer: yeniDurum);

  /// Bir sonraki aya geçer: tur artar (yaş buradan gelir) ve kariyer
  /// durumunun sayaçları ilerler.
  Oyuncu turIlerlet() => copyWith(
        tur: tur + 1,
        kariyer: kariyer.turIlerlet(),
        sgkPrimAyi: kariyer.primYatiyorMu ? sgkPrimAyi + 1 : sgkPrimAyi,
      );

  /// Kayıttan yüklenen ya da elle üretilmiş veriyi sınırlara çeker.
  /// Bozuk/eski kayıtlara karşı savunma hattıdır.
  Oyuncu duzelt() => copyWith(
        tur: tur < 0 ? 0 : tur,
        enerji: _sinirla(enerji, enerjiTaban, enerjiTavan),
        mutluluk: _sinirla(mutluluk, mutlulukTaban, mutlulukTavan),
        itibar: _sinirla(itibar, itibarTaban, itibarTavan),
        krediNotu: _sinirla(krediNotu, krediNotuTaban, krediNotuTavan),
        sgkPrimAyi: sgkPrimAyi < 0 ? 0 : sgkPrimAyi,
        yetkinlikler: {
          for (final g in yetkinlikler.entries)
            g.key: _sinirla(g.value, yetkinlikTaban, yetkinlikTavan),
        },
      );
}

int _sinirla(int deger, int taban, int tavan) =>
    deger < taban ? taban : (deger > tavan ? tavan : deger);
