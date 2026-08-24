import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Lokalizasyon dosyalarının makine denetimi.
///
/// Anayasa "lokalizasyon baştan kurulur (TR varsayılan, EN hazır)" diyor.
/// "EN hazır" elle gözden geçirmeye bırakılırsa ilk yoğun günde bozulur:
/// TR'ye eklenen anahtar EN'de unutulur ve İngilizce oynayan Türkçe metin
/// görür. Bu test onu derleme öncesi yakalıyor.
void main() {
  Map<String, dynamic> oku(String dosya) =>
      jsonDecode(File('lib/l10n/$dosya').readAsStringSync())
          as Map<String, dynamic>;

  final tr = oku('app_tr.arb');
  final en = oku('app_en.arb');

  /// `@`-önekli girdiler meta veridir (yer tutucu tanımları), çeviri değil.
  Set<String> anahtarlar(Map<String, dynamic> arb) =>
      arb.keys.where((k) => !k.startsWith('@')).toSet();

  test('EN, TR ile aynı anahtar kümesine sahip', () {
    expect(anahtarlar(en), anahtarlar(tr));
  });

  test('hiçbir metin boş değil', () {
    for (final arb in [tr, en]) {
      for (final anahtar in anahtarlar(arb)) {
        expect(
          (arb[anahtar] as String).trim(),
          isNotEmpty,
          reason: '$anahtar boş',
        );
      }
    }
  });

  test('yer tutucular iki dilde de aynı', () {
    // TR'de {tutar} olup EN'de olmayan bir yer tutucu derlenir ama
    // çalışma zamanında metinden düşer.
    final desen = RegExp(r'\{(\w+)\}');
    Set<String> yerTutucular(String metin) =>
        desen.allMatches(metin).map((e) => e.group(1)!).toSet();

    for (final anahtar in anahtarlar(tr)) {
      expect(
        yerTutucular(en[anahtar] as String),
        yerTutucular(tr[anahtar] as String),
        reason: '$anahtar yer tutucuları uyuşmuyor',
      );
    }
  });

  test('şablon dosyası her yer tutucu için tip bildiriyor', () {
    // gen_l10n tipi bildirilmemiş yer tutucuyu Object olarak üretir ve
    // sayı biçimlemesi sessizce yerelsiz kalır.
    final desen = RegExp(r'\{(\w+)\}');
    for (final anahtar in anahtarlar(tr)) {
      final kullanilan =
          desen.allMatches(tr[anahtar] as String).map((e) => e.group(1)!);
      if (kullanilan.isEmpty) continue;
      final meta = tr['@$anahtar'] as Map<String, dynamic>?;
      expect(meta, isNotNull, reason: '$anahtar için @$anahtar bloğu yok');
      final tanimli =
          (meta!['placeholders'] as Map<String, dynamic>).keys.toSet();
      expect(tanimli, containsAll(kullanilan), reason: anahtar);
    }
  });
}
