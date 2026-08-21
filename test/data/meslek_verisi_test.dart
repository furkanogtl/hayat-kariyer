import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/models/meslek_katalogu.dart';
import 'package:hayat_kariyer/core/models/sektor.dart';

/// `assets/careers/` altındaki GERÇEK veri dosyalarını doğrular.
///
/// Meslek tanımları elle yazılan JSON'dur; şema hatası da denge hatası da
/// çalışma zamanında değil burada yakalanmalıdır. Dosyalar diskten okunur
/// (asset bundle değil) — böylece test Flutter bağlamına ihtiyaç duymaz.
MeslekKatalogu katalogYukle() {
  final dizin = Directory('assets/careers');
  if (!dizin.existsSync()) {
    throw StateError('assets/careers bulunamadı (çalışma dizini proje kökü mü?)');
  }

  final dosyalar = dizin
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  if (dosyalar.isEmpty) {
    throw StateError('assets/careers altında meslek dosyası yok');
  }
  return MeslekKatalogu.jsonMetinlerinden(
    dosyalar.map((f) => f.readAsStringSync()),
  );
}

/// v1.0 kapsamı: docs/meslekler.md içindeki arketip listesi.
const _v1Meslekleri = <String>{
  'doktor',
  'yazilim_gelistirici',
  'insaat_muhendisi',
  'avukat',
  'ogretmen',
  'memur',
  'mali_musavir',
  'emlak_danismani',
  'satis_temsilcisi',
  'oto_tamircisi',
  'asci',
  'icerik_ureticisi',
  'pilot',
  'ciftci',
};

void main() {
  final katalog = katalogYukle();

  group('Şema', () {
    test('tüm meslekler geçerli', () {
      expect(katalog.dogrula(), isEmpty);
    });

    test('v1.0 arketipleri eksiksiz', () {
      final mevcut = katalog.tumu.map((m) => m.id).toSet();
      expect(mevcut, containsAll(_v1Meslekleri));
      expect(
        mevcut.difference(_v1Meslekleri),
        isEmpty,
        reason: 'listede olmayan meslek eklendiyse _v1Meslekleri güncellensin',
      );
    });

    test('kariyer merdivenleri anlamlı uzunlukta', () {
      for (final m in katalog.tumu) {
        expect(
          m.kademeler.length,
          greaterThanOrEqualTo(4),
          reason: '${m.id}: merdiven çok kısa, terfi hissi oluşmaz',
        );
      }
    });
  });

  group('Denge kuralları (docs/meslekler.md)', () {
    // "Hiçbir meslek her eksende üstün olmamalı."

    test('gelir güvencesi olan mesleğin tavanı düşüktür', () {
      for (final m in katalog.tumu.where((m) => m.gelirVaryansi == 0)) {
        expect(
          m.tavanMaas,
          lessThanOrEqualTo(100000),
          reason: '${m.id}: hem sıfır varyans hem yüksek tavan olamaz',
        );
      }
    });

    test('diplomasız girilebilen mesleğin bedeli vardır', () {
      final kolayGiris = katalog.tumu.where(
        (m) => m.girisSarti.yetkinlik == 0 && m.girisSarti.egitim.index <= 1,
      );
      expect(kolayGiris, isNotEmpty, reason: 'diplomasız yol kapanmış');
      for (final m in kolayGiris) {
        final bedelVar = m.gelirVaryansi >= 0.25 || m.tavanMaas <= 300000;
        expect(
          bedelVar,
          isTrue,
          reason: '${m.id}: kolay giriş + düşük risk + yüksek tavan',
        );
      }
    });

    test('yüksek tavanlı mesleklerin girişi ya zor ya riskli', () {
      for (final m in katalog.tumu.where((m) => m.tavanMaas >= 400000)) {
        final zorGiris = m.girisSarti.egitim.index >= 3 ||
            m.girisSarti.yasEnAz >= 21 ||
            m.gelirVaryansi >= 0.4;
        expect(zorGiris, isTrue, reason: '${m.id}: bedelsiz yüksek tavan');
      }
    });

    test('merdiven süresi oyun ömrüne sığar', () {
      for (final m in katalog.tumu) {
        final toplam = m.kademeler
            .map((k) => k.sureTur ?? 0)
            .fold<int>(0, (a, b) => a + b);
        expect(
          toplam,
          inInclusiveRange(60, 240),
          reason: '${m.id}: toplam terfi süresi $toplam tur',
        );
      }
    });

    test('ilk kademe maaşları asgari ücret ölçeğinde', () {
      for (final m in katalog.tumu) {
        expect(
          m.ilkKademe.maas,
          inInclusiveRange(3000, 100000),
          reason: '${m.id}: başlangıç maaşı ölçek dışı',
        );
      }
    });

    test('döviz geliri olan meslek var (enflasyon korunması)', () {
      expect(katalog.tumu.any((m) => m.dovizOrani > 0), isTrue);
      for (final m in katalog.tumu) {
        expect(m.dovizOrani, lessThanOrEqualTo(0.5));
      }
    });
  });

  group('Kapsam', () {
    test('en az yedi sektör temsil ediliyor', () {
      final sektorler = katalog.tumu.map((m) => m.sektor).toSet();
      expect(sektorler.length, greaterThanOrEqualTo(7));
    });

    test('güvenli taban ve piyango uçları birlikte var', () {
      expect(
        katalog.tumu.any((m) => m.gelirVaryansi == 0),
        isTrue,
        reason: 'güvenli maaş + agresif portföy stratejisi için taban gerekli',
      );
      expect(katalog.tumu.any((m) => m.gelirVaryansi >= 0.6), isTrue);
    });

    test('işletmeye geçiş yolu olan meslekler çoğunlukta', () {
      final isletmeAcan =
          katalog.tumu.where((m) => m.acilanIsletmeler.isNotEmpty).length;
      expect(isletmeAcan * 2, greaterThan(katalog.uzunluk));
    });

    test('her mesleğin olay havuzu tanımlı', () {
      for (final m in katalog.tumu) {
        expect(m.olayHavuzu, isNotEmpty, reason: '${m.id}: olay havuzu boş');
      }
    });
  });

  group('Sektör dağılımı', () {
    test('tek sektöre yığılma yok', () {
      for (final s in Sektor.values) {
        final adet = katalog.sektordeki(s).length;
        expect(
          adet,
          lessThanOrEqualTo(4),
          reason: '${s.id} sektöründe $adet meslek — dağılım dengesiz',
        );
      }
    });
  });
}
