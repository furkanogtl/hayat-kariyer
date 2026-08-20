import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// `core/` katmanının saf Dart kalmasını zorlayan mimari testi.
///
/// Bunun için hazır bir lint kuralı yok; en ucuz ve en güvenilir yol
/// kaynakları taramak. Bu test kırılırsa çözüm importu kaldırmaktır,
/// testi gevşetmek değil: motor Flutter'a bağlanırsa binlerce turluk
/// denge simülasyonu çalıştırılamaz.
void main() {
  test('core/ katmanı Flutter ve platform bağımlılığı içermez', () {
    final yasakli = <RegExp, String>{
      RegExp(r'''import\s+['"]package:flutter/'''): 'package:flutter',
      RegExp(r'''import\s+['"]package:flutter_\w+/'''): 'flutter paketleri',
      RegExp(r'''import\s+['"]dart:ui'''): 'dart:ui',
      RegExp(r'''import\s+['"]dart:io'''): 'dart:io (dosya erişimi data/ katmanına ait)',
    };

    final ihlaller = <String>[];
    final coreDizini = Directory('lib/core');
    expect(coreDizini.existsSync(), isTrue, reason: 'lib/core bulunamadı');

    for (final dosya in coreDizini
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      final icerik = dosya.readAsStringSync();
      for (final girdi in yasakli.entries) {
        if (girdi.key.hasMatch(icerik)) {
          ihlaller.add('${dosya.path} -> ${girdi.value}');
        }
      }
    }

    expect(ihlaller, isEmpty, reason: 'core/ katmanında yasaklı import:\n${ihlaller.join('\n')}');
  });
}
