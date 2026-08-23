import 'package:flutter_test/flutter_test.dart';
import 'package:hayat_kariyer/core/engine/borc_motoru.dart';
import 'package:hayat_kariyer/core/models/borc.dart';
import 'package:hayat_kariyer/core/models/kariyer_durumu.dart';
import 'package:hayat_kariyer/core/models/oyuncu.dart';
import 'package:hayat_kariyer/core/models/piyasa_durumu.dart';
import 'package:hayat_kariyer/core/models/sehir.dart';
import 'package:hayat_kariyer/core/rng/rastgele_kaynak.dart';

const _motor = BorcMotoru();
const _ayarlar = BorcAyarlari();

Oyuncu _oyuncu({int krediNotu = Oyuncu.krediNotuBaslangic}) => Oyuncu(
      ad: 'Test',
      sehir: Sehir.konya,
      tur: 12 * 12,
      krediNotu: krediNotu,
      kariyer: const KariyerDurumu.calisan(meslekId: 'memur'),
    );

/// Enflasyonsuz piyasa: faizin kredi notu bileşeni yalın okunsun.
const _sakinPiyasa = PiyasaDurumu();
const _enflasyonlu = PiyasaDurumu(sonAylikEnflasyon: 0.03);

BorcTurSonucu _isle(List<Borc> borclar, int nakit, {int tur = 1}) =>
    _motor.turIsle(
      borclar: borclar,
      odenebilirNakit: nakit,
      akis: RastgeleKaynak(5).akis('borc', tur: tur),
    );

Borc _kredi({
  int anapara = 300000,
  double faiz = 0.02,
  int vade = 12,
  int gecikme = 0,
  String id = 'k1',
}) =>
    Borc(
      id: id,
      tur: BorcTuru.ihtiyac,
      anapara: anapara,
      kalanAnapara: anapara,
      aylikTaksit: taksitHesapla(anapara, faiz, vade),
      aylikFaiz: faiz,
      kalanTaksit: vade,
      cekildigiTur: 0,
      gecikmeTuru: gecikme,
    );

void main() {
  group('faiz ve limit', () {
    test('kredi notu yükseldikçe faiz düşer', () {
      final kotu = _motor.aylikFaiz(BorcTuru.ihtiyac, 700, _sakinPiyasa);
      final iyi = _motor.aylikFaiz(BorcTuru.ihtiyac, 1700, _sakinPiyasa);
      expect(iyi, lessThan(kotu));
    });

    test('kredi notu ölçeği 0-100 DEĞİL', () {
      // İlk yazımda 0-100 varsayılmıştı; 1000 puanlık başlangıç notu
      // tavana kırpıldığı için herkes en iyi faizi alıyordu. Bu test
      // ölçeği modele bağlıyor.
      expect(_motor.notOrani(Oyuncu.krediNotuTaban), 0.0);
      expect(_motor.notOrani(Oyuncu.krediNotuTavan), 1.0);
      expect(_motor.notOrani(Oyuncu.krediNotuBaslangic), closeTo(0.4375, 1e-6));
      // Başlangıç notu ne tavanda ne tabanda olmalı: oyuncunun kredi
      // notunu iyileştirmesinin de kötüleştirmesinin de karşılığı var.
      expect(
        _motor.aylikFaiz(
          BorcTuru.ihtiyac,
          Oyuncu.krediNotuBaslangic,
          _sakinPiyasa,
        ),
        allOf(
          greaterThan(
            _motor.aylikFaiz(
              BorcTuru.ihtiyac,
              Oyuncu.krediNotuTavan,
              _sakinPiyasa,
            ),
          ),
          lessThan(
            _motor.aylikFaiz(
              BorcTuru.ihtiyac,
              Oyuncu.krediNotuTaban,
              _sakinPiyasa,
            ),
          ),
        ),
      );
    });

    test('kredi notu yükseldikçe limit artar', () {
      expect(_motor.limitKati(1700), greaterThan(_motor.limitKati(700)));
      expect(_motor.limitKati(Oyuncu.krediNotuTaban),
          _ayarlar.limitGelirKatiEnAz);
      expect(_motor.limitKati(Oyuncu.krediNotuTavan),
          _ayarlar.limitGelirKatiEnCok);
    });

    test('faiz enflasyona endeksli, kredi çekildiği anda sabitlenir', () {
      // Tasarımın kalbi: banka geçmişe bakıp fiyatlıyor. Düşük enflasyon
      // döneminde çekilen kredi, enflasyon rejiminde ucuz kalıyor.
      final sakin = _motor.aylikFaiz(BorcTuru.konut, 1000, _sakinPiyasa);
      final yuksek = _motor.aylikFaiz(BorcTuru.konut, 1000, _enflasyonlu);
      expect(yuksek - sakin, closeTo(0.03, 1e-9));
    });

    test('konut en ucuz, kart borcu en pahalı', () {
      double f(BorcTuru t) => _motor.aylikFaiz(t, 1000, _sakinPiyasa);
      expect(f(BorcTuru.konut), lessThan(f(BorcTuru.tasit)));
      expect(f(BorcTuru.tasit), lessThan(f(BorcTuru.ihtiyac)));
      expect(f(BorcTuru.ihtiyac), lessThan(f(BorcTuru.kartBorcu)));
    });
  });

  group('teklifler', () {
    List<KrediTeklifi> teklif({
      int krediNotu = Oyuncu.krediNotuBaslangic,
      int gelir = 80000,
      List<Borc> borclar = const [],
    }) =>
        _motor.teklifler(
          oyuncu: _oyuncu(krediNotu: krediNotu),
          borclar: borclar,
          piyasa: _sakinPiyasa,
          aylikGelir: gelir,
        );

    test('düşük kredi notuna banka kredi vermez', () {
      expect(teklif(krediNotu: _ayarlar.enAzKrediNotu - 1), isEmpty);
      expect(teklif(krediNotu: _ayarlar.enAzKrediNotu), isNotEmpty);
    });

    test('gelirsize kredi yok', () {
      expect(teklif(gelir: 0), isEmpty);
    });

    test('gecikmedeki borçlu yeni kredi alamaz', () {
      expect(teklif(borclar: [_kredi(gecikme: 1)]), isEmpty);
    });

    test('kart borcu teklif edilmez, yalnız oluşur', () {
      expect(
        teklif().map((t) => t.tur),
        isNot(contains(BorcTuru.kartBorcu)),
      );
    });

    test('konut limiti en yüksek, vadesi en uzun', () {
      final hepsi = {for (final t in teklif()) t.tur: t};
      expect(
        hepsi[BorcTuru.konut]!.enYuksekTutar,
        greaterThan(hepsi[BorcTuru.ihtiyac]!.enYuksekTutar),
      );
      expect(hepsi[BorcTuru.konut]!.vadeTur, 120);
    });

    test('mevcut taksit yükü limiti daraltır', () {
      final bos = teklif().firstWhere((t) => t.tur == BorcTuru.ihtiyac);
      final yuklu = teklif(borclar: [_kredi(anapara: 200000)])
          .firstWhere((t) => t.tur == BorcTuru.ihtiyac);
      expect(yuklu.enYuksekTutar, lessThan(bos.enYuksekTutar));
    });

    test('taksit gelirin yarısını geçemez', () {
      const gelir = 80000;
      for (final t in teklif(gelir: gelir)) {
        expect(
          t.taksit(t.enYuksekTutar),
          lessThanOrEqualTo((gelir * _ayarlar.taksitGelirOrani).round()),
          reason: '${t.tur}',
        );
      }
    });
  });

  group('kredi çekme', () {
    KrediSonucu cek({
      int anapara = 100000,
      int krediNotu = Oyuncu.krediNotuBaslangic,
    }) =>
        _motor.krediCek(
          oyuncu: _oyuncu(krediNotu: krediNotu),
          borclar: const [],
          piyasa: _sakinPiyasa,
          aylikGelir: 80000,
          tur: BorcTuru.ihtiyac,
          anapara: anapara,
          simdikiTur: 7,
        );

    test('geçerli kredi çekilir', () {
      final s = cek();
      expect(s.basarili, isTrue);
      expect(s.borc!.kalanAnapara, 100000);
      expect(s.borc!.kalanTaksit, 36);
      expect(s.borc!.cekildigiTur, 7);
    });

    test('limit üstü reddedilir', () {
      expect(cek(anapara: 99999999).hata, KrediHatasi.limitAsildi);
    });

    test('sıfır ve negatif tutar reddedilir', () {
      expect(cek(anapara: 0).hata, KrediHatasi.gecersizTutar);
      expect(cek(anapara: -5).hata, KrediHatasi.gecersizTutar);
    });

    test('kredi notu yetersizse reddedilir', () {
      expect(cek(krediNotu: 500).hata, KrediHatasi.krediNotuYetersiz);
    });
  });

  group('taksit', () {
    test('ödenen taksit anaparayı eritir', () {
      final borc = _kredi(anapara: 120000, faiz: 0.02, vade: 12);
      final sonuc = _isle([borc], 1000000);
      final kalan = sonuc.borclar.single;
      expect(sonuc.odenenTaksit, borc.aylikTaksit);
      expect(kalan.kalanAnapara, lessThan(borc.kalanAnapara));
      expect(kalan.kalanTaksit, 11);
    });

    test('vade sonunda kredi kapanır ve kredi notu artar', () {
      var borclar = [_kredi(anapara: 120000, faiz: 0.02, vade: 12)];
      var kapanis = 0;
      var notArtisi = 0;
      for (var t = 0; t < 12; t++) {
        final s = _isle(borclar, 1000000, tur: t);
        borclar = s.borclar;
        kapanis += s.kapananlar.length;
        notArtisi += s.krediNotuDegisimi;
      }
      expect(borclar, isEmpty);
      expect(kapanis, 1);
      expect(notArtisi, _ayarlar.kapanisKrediNotuArtisi);
    });

    test('anüite: toplam ödeme anaparadan büyük', () {
      final borc = _kredi(anapara: 120000, faiz: 0.02, vade: 12);
      expect(borc.aylikTaksit * 12, greaterThan(borc.anapara));
    });

    test('faizsiz kredide taksit düz bölme', () {
      expect(taksitHesapla(120000, 0, 12), 10000);
    });
  });

  group('gecikme', () {
    test('nakit yetmezse gecikmeye düşer, borç büyür', () {
      final borc = _kredi(anapara: 300000);
      final sonuc = _isle([borc], 0);
      final kalan = sonuc.borclar.single;
      expect(sonuc.odenenTaksit, 0);
      expect(sonuc.gecikenler, [borc.id]);
      expect(kalan.gecikmeTuru, 1);
      expect(kalan.kalanAnapara, greaterThan(borc.kalanAnapara));
      expect(sonuc.krediNotuDegisimi, -_ayarlar.gecikmeKrediNotuDususu);
    });

    test('üst üste gecikme takibe düşürür', () {
      var borclar = [_kredi()];
      var takip = <String>[];
      for (var t = 0; t < _ayarlar.takipEsigi; t++) {
        final s = _isle(borclar, 0, tur: t);
        borclar = s.borclar;
        takip = s.takibeDusenler;
      }
      expect(takip, hasLength(1));
      expect(borclar.single.gecikmeTuru, _ayarlar.takipEsigi);
    });

    test('ödeme yapılınca gecikme sayacı sıfırlanır', () {
      final geciken = _isle([_kredi()], 0).borclar.single;
      expect(geciken.gecikmeTuru, 1);
      final duzelen = _isle([geciken], 1000000).borclar.single;
      expect(duzelen.gecikmeTuru, 0);
    });

    test('gecikme borcu büyüttüğü için spiral kurar', () {
      // Ödenmeyen kredi kendi kendine büyümeli; yoksa "ödeme, bekle"
      // bedelsiz bir strateji olurdu.
      var borc = _kredi(anapara: 300000);
      for (var t = 0; t < 6; t++) {
        borc = _isle([borc], 0, tur: t).borclar.single;
      }
      expect(borc.kalanAnapara, greaterThan(300000 * 1.3));
    });
  });

  group('ödeme sırası', () {
    test('nakit yetmezse önce pahalı faizli ödenir', () {
      // Tersi olsaydı ucuz kredi kapanırken pahalı olan çürürdü.
      final ucuz = _kredi(id: 'ucuz', faiz: 0.01, anapara: 200000);
      final pahali = _kredi(id: 'pahali', faiz: 0.05, anapara: 200000);
      final sonuc = _isle([ucuz, pahali], pahali.aylikTaksit);
      expect(sonuc.gecikenler, ['ucuz']);
      expect(sonuc.odenenTaksit, pahali.aylikTaksit);
    });

    test('sonuç listesi kimlik sırasında — kayıt kararlı', () {
      final s = _isle(
        [_kredi(id: 'z'), _kredi(id: 'a'), _kredi(id: 'm')],
        1000000,
      );
      expect(s.borclar.map((b) => b.id), ['a', 'm', 'z']);
    });
  });

  group('model', () {
    test('erken kapama bedeli anapara + bir dönem faizi', () {
      final borc = _kredi(anapara: 100000, faiz: 0.02);
      expect(borc.erkenKapamaBedeli, 102000);
    });

    test('bozuk kayıt düzeltilir', () {
      const bozuk = Borc(
        id: 'x',
        tur: BorcTuru.ihtiyac,
        anapara: 1000,
        kalanAnapara: -50,
        aylikTaksit: 100,
        aylikFaiz: 0.02,
        kalanTaksit: -3,
        cekildigiTur: 0,
        gecikmeTuru: -1,
      );
      final duzgun = bozuk.duzelt();
      expect(duzgun.kalanAnapara, 0);
      expect(duzgun.kalanTaksit, 0);
      expect(duzgun.gecikmeTuru, 0);
      expect(duzgun.kapandi, isTrue);
    });

    test('JSON round-trip', () {
      final borc = _kredi(gecikme: 2);
      expect(Borc.fromJson(borc.toJson()), borc);
    });
  });
}
