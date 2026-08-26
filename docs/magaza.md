# Mağaza hazırlığı

Play Store ve App Store için gereken metinler ve kontrol listesi.
Metinler taslaktır — Furkan'ın onayından geçecek.

## Kimlik

| Alan | Değer |
|---|---|
| Uygulama adı | Hayat & Kariyer |
| Android paket | `com.furkanogutlu.hayat_kariyer` |
| iOS bundle | `com.furkanogutlu.hayatKariyer` |
| Sürüm | `1.0.0+1` (`pubspec.yaml`) |
| Kategori | Oyun › Simülasyon |
| Yaş sınırı | 12+ (kumar YOK, ama borç/icra ve alkolsüz yetişkin temaları var) |

**Yaş sınırı notu:** Play Store'un içerik anketinde "simüle edilmiş kumar"
sorusu var. Oyunda kumar mekaniği yok; borsa ve kripto **yatırım** olarak
modelleniyor, bahis olarak değil. Yine de dolandırıcılık, icra ve senetle
borç kartları olduğu için 12+ öneriliyor.

## Kısa açıklama (Play Store, en fazla 80 karakter)

```
18 yaşında başla, kariyerini kur, yatırım yap, servet imparatorluğu kur.
```
(72 karakter)

## Uzun açıklama

```
Hayat & Kariyer, tamamen Türkiye'de geçen, tur tabanlı bir hayat ve
kariyer simülasyonudur. 18 yaşında başlarsın; her tur bir aydır.

ZAMANINI DAĞIT
Her ay 10 puanın var: çalış, eğitim al, çevre edin, dinlen. Çalışmaya
yüklenirsen para gelir ama tükenirsin. Dinlenmezsen performansın düşer.
Çevrene yatırım yapmazsan iyi fırsatlar kapını çalmaz.

KARİYERİNİ KUR
14 meslek, çok kademeli terfi merdivenleri. Yazılımcı, doktor, avukat,
öğretmen, aşçı, emlakçı, çiftçi... Her mesleğin girişi, tavanı ve riski
farklı. Memur güvenlidir ama tavanı düşüktür; doktor geç başlar, en
yükseğe çıkar.

PARANI KORU
Yıllık enflasyon oyunun en büyük baskısı. Nakit tutmak kaybettirir.
Mevduat, altın, döviz, gayrimenkul, arsa, kripto ve altı borsa sektörü
arasında seçim yaparsın. Piyasa dört rejim arasında gezinir: büyüme,
durgunluk, kriz, enflasyon. Krizde altın kazandırır, borsa çöker.

İŞLETME AÇ
Kafe ya da oto galeri kur. Ama her işletme aylık "ilgi" ister; yeterince
bakmadığın işletmenin geliri düşer ve kriz kartları çıkmaya başlar. CEO
atayabilirsin — yükü azaltır, kârı da azaltır, zimmet riski getirir.

KARAR VER
140'tan fazla olay kartı: kira zammı, düğün takısı, dayıdan borç isteği,
imar söylentisi, kur şoku, ortaklık teklifi. Bazı kararların sonucu aylar
sonra açığa çıkar. İtibarın yükseldikçe daha büyük fırsatlar görürsün.

DİP DE VAR
Borcunu ödeyemezsen kemer sıkarsın, sonra icra gelir. Ama iflas bir
bitiş değil bir diptir: toparlanabilirsin.

65 yaşında oyun biter ve ne olduğunu görürsün.

Her oyun bir tohumdan üretilir; aynı tohum, aynı kararlar, aynı hayat.

Bu bir oyundur, yatırım tavsiyesi değildir. Oyundaki şirket, banka,
kulüp ve kişi isimlerinin tamamı kurgusaldır.
```

## Paket boyutu

`flutter build appbundle --release` → **41,3 MB** (`app-release.aab`).
Bu rakam yanıltıcı, panik gerektirmiyor:

| Bileşen | Boyut | Cihaza iner mi |
|---|---|---|
| Hata ayıklama sembolleri | 46,7 MB | **Hayır** — Play Console çökme çözümlemesi için |
| Yerel kütüphaneler (3 mimari) | 50,1 MB | Yalnız **biri** (~11 MB arm64) |
| dex | 0,9 MB | Evet |
| Varlıklar (kart/meslek JSON'ları) | 0,5 MB | Evet |

Play, AAB'den her cihaza kendi mimarisini üretiyor; gerçek indirme boyutu
**~15 MB**. Karşılaştırma için `flutter build apk --release` tek dosyada
bütün mimarileri taşıdığı için 50,9 MB.

## Ekran görüntüleri (çekilecek)

Play Store en az 2, en fazla 8 telefon görüntüsü istiyor. Önerilen sıra:

1. **Özet** — gösterge paneli, reel net değer, zaman dağıtımı
2. **Olay kartı** — karar anı (fırsat kartı, üç seçenekli)
3. **Piyasa** — 12 yatırım aracı ve reel yüzdeler
4. **Varlık detayı** — fiyat grafiği + alım/satım
5. **İşletme** — kafe, ilgi puanı, aylık bilanço
6. **Banka** — kredi teklifleri ve taksit özeti
7. **Tur raporu** — bilanço ve bildirimler
8. **Skor** — oyun sonu ünvanı

## Yayın öncesi kontrol listesi

- [x] Uygulama adı (`AndroidManifest` label, iOS `CFBundleDisplayName`)
- [x] `pubspec.yaml` açıklaması
- [x] Uygulama simgesi (Android uyarlanabilir + iOS alfasız 1024)
- [x] Sürüm `1.0.0+1`
- [x] Yayın imzası yapılandırması (`android/key.properties`, depoya girmez)
- [x] R8 + kaynak kırpma açık
- [x] "Bu bir oyundur, yatırım tavsiyesi değildir" uyarısı uygulamada
      (yeni oyun ekranı + Özet ekranı)
- [ ] **Anahtar üret**: `android/key.properties.ornek` dosyasını
      `key.properties` olarak kopyala, keystore oluştur (Furkan)
- [ ] Ekran görüntüleri
- [ ] Play Console feature graphic (1024×500)
- [ ] Gizlilik politikası URL'i — **gerekli mi?** Uygulama internete
      çıkmıyor, veri toplamıyor, kayıt yalnız cihazda. Play Console yine de
      bir URL istiyor; "veri toplanmıyor" diyen tek sayfalık bir metin yeter.
- [ ] Veri güvenliği formu: "Veri toplanmıyor / paylaşılmıyor"
- [ ] İçerik derecelendirme anketi

## Hukuki

Anayasa gereği ve kontrol edildi:

- Gerçek şirket, marka, banka, futbol kulübü ya da futbolcu ismi
  KULLANILMIYOR. Meslekler ve olay kartları jenerik ("bir firma", "banka",
  "tanıdığın müteahhit").
- "Bu bir oyundur, yatırım tavsiyesi değildir" uygulamada iki yerde.
- Gerçek piyasa verisi çekilmiyor; bütün fiyatlar prosedürel üretiliyor.
