import 'package:flutter/material.dart';

/// Animasyon süreleri ve eğrileri tek yerde.
///
/// Oyun 480 tur sürüyor ve kart ~170 kez açılıyor. Her açılışta yarım
/// saniye fazladan beklemek, oturumun sonunda dakikalara çıkar. Bu yüzden
/// süreler kısa tutuluyor ve her animasyon ATLANABİLİR olmak zorunda:
/// dokunan oyuncu sonu görür, beklemez.
abstract final class Hareket {
  /// Renk/opaklık gibi küçük geçişler.
  static const Duration kisa = Duration(milliseconds: 160);

  /// Kart girişi, panel açılışı.
  static const Duration orta = Duration(milliseconds: 300);

  /// Karakterin sahneye girmesi gibi anlatısal hareketler.
  static const Duration uzun = Duration(milliseconds: 520);

  /// Sayıların akması. Uzun olabilir çünkü oyuncuyu BEKLETMİYOR.
  static const Duration sayac = Duration(milliseconds: 650);

  static const Curve giris = Curves.easeOutCubic;
  static const Curve cikis = Curves.easeInCubic;

  /// Hafif yaylanma. Karakter ve kart girişinde canlılık veriyor.
  static const Curve yay = Curves.easeOutBack;

  /// Cihazda "animasyonları azalt" açıksa hareket kapatılır.
  ///
  /// Erişilebilirlik ayarı; yok saymak vestibüler rahatsızlığı olan
  /// oyuncuyu dışarıda bırakır.
  static bool kapali(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// Hareket kapalıysa sıfır süre döner.
  static Duration sure(BuildContext context, Duration istenen) =>
      kapali(context) ? Duration.zero : istenen;
}
