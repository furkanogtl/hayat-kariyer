import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/engine/borc_motoru.dart';
import '../../core/engine/isletme_motoru.dart';
import '../../core/engine/olay_motoru.dart';
import '../../core/engine/tur_processor.dart';
import '../../core/models/egitim_seviyesi.dart';
import '../../core/models/isletme_katalogu.dart';
import '../../core/models/kariyer_durumu.dart';
import '../../core/models/meslek_katalogu.dart';
import '../../core/models/olay.dart';
import '../../core/models/olay_katalogu.dart';
import '../../core/models/oyun_durumu.dart';
import '../../core/models/oyuncu.dart';
import '../../core/models/sehir.dart';
import '../../core/models/zaman_dagilimi.dart';
import '../../data/isletme_yukleyici.dart';
import '../../data/meslek_yukleyici.dart';
import '../../data/olay_yukleyici.dart';

/// Asset'lerden okunan üç katalog. Oyun boyunca değişmez.
@immutable
class Kataloglar {
  const Kataloglar({
    required this.meslekler,
    required this.olaylar,
    required this.isletmeler,
  });

  final MeslekKatalogu meslekler;
  final OlayKatalogu olaylar;
  final IsletmeKatalogu isletmeler;
}

/// Veri dosyalarını bir kez okur. Uygulama kabuğu bu yüklenmeden ekran
/// açmaz; sonrasında ağacın geri kalanı senkron çalışır.
final kataloglarProvider = FutureProvider<Kataloglar>((ref) async {
  final meslekler = await MeslekYukleyici().yukle();
  final olaylar = await OlayYukleyici().yukle();
  final isletmeler = await IsletmeYukleyici().yukle();
  return Kataloglar(
    meslekler: meslekler,
    olaylar: olaylar,
    isletmeler: isletmeler,
  );
});

/// Tur motoru. Kart→işletme dizini burada bağlanıyor; bağlanmazsa işletme
/// kartları işletmesi olmayan herkese sızar (TurProcessor'daki assert bunu
/// yakalar).
final turProcessorProvider = Provider<TurProcessor>((ref) {
  final k = ref.watch(kataloglarProvider).requireValue;
  final isletmeMotoru = IsletmeMotoru(katalog: k.isletmeler);
  return TurProcessor(
    katalog: k.meslekler,
    olay: OlayMotoru(
      katalog: k.olaylar,
      isletmeKartlari: k.isletmeler.olayHavuzuDizini(),
    ),
    isletme: isletmeMotoru,
    borc: const BorcMotoru(),
  );
});

/// Bir oyun oturumu: kayda yazılan durum + ekranın ihtiyaç duyduğu geçici
/// veriler.
///
/// Raporlar ve bekleyen kartlar kayda GİRMEZ. Deste zaten `desteCek` ile
/// durumdan SAF olarak türetiliyor; kayıttan dönen oyuncu aynı kartları
/// görür. Burada tutulmasının tek sebebi, kartlar cevaplandıkça durumun
/// değişmesi: her seçimden sonra yeniden çekilseydi deste altta değişirdi.
@immutable
class Oturum {
  const Oturum({
    required this.durum,
    this.sonRaporlar = const [],
    this.bekleyenKartlar = const [],
  });

  final OyunDurumu durum;
  final List<TurRaporu> sonRaporlar;

  /// Bu tur oyuncuya sunulan, henüz cevaplanmamış kartlar.
  final List<Olay> bekleyenKartlar;

  bool get kararBekliyor => bekleyenKartlar.isNotEmpty;

  Oturum kopya({
    OyunDurumu? durum,
    List<TurRaporu>? sonRaporlar,
    List<Olay>? bekleyenKartlar,
  }) =>
      Oturum(
        durum: durum ?? this.durum,
        sonRaporlar: sonRaporlar ?? this.sonRaporlar,
        bekleyenKartlar: bekleyenKartlar ?? this.bekleyenKartlar,
      );
}

/// Aktif oyun. `null` = henüz oyun kurulmadı (açılış ekranı).
final oyunProvider = NotifierProvider<OyunNotifier, Oturum?>(OyunNotifier.new);

class OyunNotifier extends Notifier<Oturum?> {
  @override
  Oturum? build() => null;

  TurProcessor get _motor => ref.read(turProcessorProvider);

  void yeniOyun({
    required String ad,
    required Cinsiyet cinsiyet,
    required Sehir sehir,
    required EgitimSeviyesi egitim,
    int? tohum,
  }) {
    final oyuncu = Oyuncu.yeni(
      ad: ad,
      cinsiyet: cinsiyet,
      sehir: sehir,
      egitim: egitim,
    );
    state = _oturumKur(
      _motor.yeniOyun(
        oyuncu: oyuncu,
        // Tohum kayda yazılır; aynı tohum + aynı kararlar = aynı oyun.
        anaTohum: tohum ?? DateTime.now().microsecondsSinceEpoch & 0x7fffffff,
      ),
    );
    ref.read(zamanProvider.notifier).varsayilanaDon(calisiyor: false);
  }

  /// Kayıttan yükleme ve testler için doğrudan durum verir.
  void durumaGec(OyunDurumu durum) {
    final duzeltilmis = durum.duzelt();
    state = _oturumKur(duzeltilmis);
    ref.read(zamanProvider.notifier).varsayilanaDon(
          calisiyor: duzeltilmis.oyuncu.kariyer is Calisan,
        );
  }

  void turuBitir(TurGirdisi girdi) {
    final oturum = state;
    if (oturum == null) return;
    final oncekiTur = oturum.durum.oyuncu.kariyer.turu;
    final sonuc = _motor.turuBitir(oturum.durum, girdi);
    state = _oturumKur(sonuc.durum, raporlar: [sonuc.rapor]);
    _zamaniTazele(oncekiTur, sonuc.durum);
  }

  /// "3 ay atla" / "1 yıl atla". Motor gerektiğinde erken keser; kaç tur
  /// gerçekten işlendiği [Oturum.sonRaporlar] uzunluğundan okunur.
  void turlariAtla(TurGirdisi girdi, int adet) {
    final oturum = state;
    if (oturum == null) return;
    final oncekiTur = oturum.durum.oyuncu.kariyer.turu;
    final sonuc = _motor.turlariAtla(oturum.durum, girdi, adet);
    state = _oturumKur(sonuc.durum, raporlar: sonuc.raporlar);
    _zamaniTazele(oncekiTur, sonuc.durum);
  }

  /// Kariyer TÜRÜ değiştiyse zaman taslağını varsayılana çeker.
  ///
  /// Tür değişmediyse dokunulmaz: oyuncunun elle kurduğu dağılım her ay
  /// silinmesin.
  void _zamaniTazele(KariyerTuru onceki, OyunDurumu yeni) {
    final sonraki = yeni.oyuncu.kariyer;
    if (sonraki.turu == onceki) return;
    ref
        .read(zamanProvider.notifier)
        .varsayilanaDon(calisiyor: sonraki is Calisan);
  }

  /// Yeni duruma geçerken bu turun destesini de çeker.
  ///
  /// Deste durumdan SAF olarak türetiliyor; tek yerden çekilmesi, kartların
  /// hem tur sonunda hem kayıttan dönüşte aynı biçimde gelmesini sağlıyor.
  Oturum _oturumKur(OyunDurumu durum, {List<TurRaporu> raporlar = const []}) =>
      Oturum(
        durum: durum,
        sonRaporlar: raporlar,
        bekleyenKartlar: _motor.desteCek(durum).kartlar,
      );

  /// Oyuncunun bir karta verdiği cevabı uygular.
  ///
  /// Kart desteden BURADA DÜŞMEZ: sonuç metni okunana kadar ekranda
  /// kalması gerekiyor. Düşürme [kartiKapat] ile yapılır.
  ///
  /// Deste yeniden çekilmez; seçim nakdi ve itibarı değiştirdiği için
  /// yeniden çekilseydi kalan kartlar oyuncunun gözü önünde değişirdi.
  SecimSonucu? secimYap(Olay kart, int secenekIndeksi) {
    final oturum = state;
    if (oturum == null) return null;
    final sonuc = _motor.secimUygula(oturum.durum, kart, secenekIndeksi);
    state = oturum.kopya(durum: sonuc.durum);
    return sonuc;
  }

  /// Sıradaki karta geçer.
  void kartiKapat() {
    final oturum = state;
    if (oturum == null || oturum.bekleyenKartlar.isEmpty) return;
    state = oturum.kopya(
      bekleyenKartlar: oturum.bekleyenKartlar.sublist(1),
    );
  }

  /// Rapor kartı kapatıldığında çağrılır.
  void raporlariTemizle() {
    final oturum = state;
    if (oturum == null || oturum.sonRaporlar.isEmpty) return;
    state = oturum.kopya(sonRaporlar: const []);
  }

  void oyunuBitir() => state = null;
}

/// Oyuncunun bu tur için biriktirdiği komutlar.
///
/// Zaman dağılımı gibi TASLAKTIR: turu bitirene kadar oyun durumunun
/// parçası değildir, tur işlenince temizlenir. Kredi talebi, emirler ve
/// bedelli ödemesi sonraki dilimlerde buraya eklenecek; hepsi aynı
/// `TurGirdisi` kapısından geçiyor.
@immutable
class TurTalepleri {
  const TurTalepleri({this.iseGirTalebi});

  /// Girilmek istenen mesleğin kimliği.
  final String? iseGirTalebi;

  bool get bosMu => iseGirTalebi == null;

  TurTalepleri kopya({String? iseGirTalebi, bool isiTemizle = false}) =>
      TurTalepleri(
        iseGirTalebi: isiTemizle ? null : (iseGirTalebi ?? this.iseGirTalebi),
      );
}

final taleplerProvider =
    NotifierProvider<TalepNotifier, TurTalepleri>(TalepNotifier.new);

class TalepNotifier extends Notifier<TurTalepleri> {
  @override
  TurTalepleri build() => const TurTalepleri();

  void iseGir(String? meslekId) {
    state = TurTalepleri(iseGirTalebi: meslekId);
    if (meslekId != null) ref.read(zamanProvider.notifier).iseHazirlan();
  }

  void temizle() => state = const TurTalepleri();
}

/// Oyuncunun bu tur için hazırladığı zaman dağılımı.
///
/// Kayda yazılmaz: turu bitirene kadar süren bir TASLAKTIR, oyun durumunun
/// parçası değildir.
///
/// Taslak YAPIŞKANDIR: oyuncunun kurduğu dağılım turlar boyunca yerinde
/// kalır, her ay yeniden kurmak zorunda değildir. Yalnızca kariyer TÜRÜ
/// değişince (işe girme, kovulma, askere alınma, mezuniyet) varsayılana
/// döner ve bunu [OyunNotifier] ile [TalepNotifier] açıkça tetikler.
///
/// Bu tazeleme önce `ref.watch` ile türetiliyordu; sağlayıcı kendini
/// widget'ın build'i sırasında geçersiz kılınca Riverpod "build sırasında
/// setState" hatası veriyordu. Açık çağrı hem çalışıyor hem de taslağın
/// ne zaman sıfırlandığını okunur kılıyor.
final zamanProvider =
    NotifierProvider<ZamanNotifier, ZamanDagilimi>(ZamanNotifier.new);

class ZamanNotifier extends Notifier<ZamanDagilimi> {
  @override
  ZamanDagilimi build() => ZamanDagilimi.calismadan();

  /// Kariyer durumu değişti: duruma uygun varsayılana dön.
  void varsayilanaDon({required bool calisiyor}) =>
      state = calisiyor ? ZamanDagilimi.dengeli() : ZamanDagilimi.calismadan();

  /// İşe giriş talebi verildi.
  ///
  /// İşsizin varsayılanı çalışma 0; oyuncu işe girdiği turda o dağılımla
  /// turu bitirirse performansı sıfır olduğu için İLK AY kovulur. Oyuncunun
  /// göremeyeceği bir tuzaktı. Elle çalışmaya puan ayırmışsa dokunulmuyor.
  void iseHazirlan() {
    if (state.calisma > 0) return;
    state = ZamanDagilimi.dengeli();
  }

  void ayarla(ZamanDagilimi yeni) => state = yeni.duzelt();

  /// Tek kalemi değiştirir; toplam sınırını aşacaksa yok sayar.
  void artir(ZamanAlani alan, int fark) {
    final yeni = switch (alan) {
      ZamanAlani.calisma => state.copyWith(calisma: state.calisma + fark),
      ZamanAlani.egitim => state.copyWith(egitim: state.egitim + fark),
      ZamanAlani.network => state.copyWith(network: state.network + fark),
      ZamanAlani.dinlenme => state.copyWith(dinlenme: state.dinlenme + fark),
    };
    if (!yeni.gecerli) return;
    state = yeni;
  }
}

enum ZamanAlani { calisma, egitim, network, dinlenme }
