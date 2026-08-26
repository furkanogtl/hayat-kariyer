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
18 yaşında başla, 65'inde ne olduğunu gör. Kariyer ve yatırım simülasyonu.
```
(73 karakter)

Alternatifler:
- `Türkiye'de geçen hayat simülasyonu. Çalış, yatırım yap, işletme kur.` (68)
- `Cebinde para yok, önünde 47 yıl var. Ne yapacağını sen bilirsin.` (63)

## Uzun açıklama

> Play Store 4000 karakter veriyor; aşağıdaki metin ~2100. İlk üç satır
> "devamını oku"dan önce görünen kısım, en çok orası önemli.

```
Konya'da mı kalacaksın, İstanbul'a mı gideceksin? Kira mı ödeyeceksin,
kredi mi çekeceksin? Maaşın yılda bir zamlanıyor, market her ay.

18 yaşında başlıyorsun. Her tur bir ay. 65'inde ne olduğuna bakacağız.

AYIN ON PUANI
Çalış, oku, çevre edin, dinlen. Hepsini birden yapamazsın. Mesaiye
yüklenirsen para gelir ama bir yerden sonra tükenirsin ve performansın
düşer. Kimseyle görüşmezsen kimse sana fırsat getirmez.

MESLEK SEÇ, MERDİVENİ TIRMAN
Yazılımcı, doktor, avukat, öğretmen, aşçı, emlakçı, oto tamircisi,
çiftçi... On dört meslek, her birinin kendi terfi basamakları. Memurluk
güvenlidir ama tavanı alçaktır. Doktorluk geç başlar, en yükseğe çıkar.
Askerlik gelir: er misin, bedelli mi? Öğretmensen atama kurası bekler.

ENFLASYON SENİ BEKLEMİYOR
Nakit tutmak kaybetmektir — bu oyunun ana kuralı. Mevduat, altın, döviz,
gayrimenkul, arsa, kripto ve altı borsa sektörü var. Piyasa dört rejim
arasında dolaşıyor: büyüme, durgunluk, kriz, enflasyon. Kriz gelince
altın seni korur, borsa çöker. Daireyi satmaya karar verdiğinde alıcı üç
tur bekletir; o arada fiyat düşerse zarar senindir.

İŞLETME AÇ, AMA BAKABİLECEĞİN KADAR
Kafe ya da oto galeri. Her işletme her ay senden ilgi ister; ayırmazsan
cirosu düşer, personeli kaçar, zabıta kapıya dayanır. CEO atayabilirsin:
yükü hafifletir, kârı da azaltır, üstüne zimmet riski getirir. Kaç
işletmeyi aynı anda ayakta tutabileceğin bu oyunun asıl sorusu.

KARARLAR KAPINI ÇALIYOR
Yüz kırktan fazla olay kartı. Ev sahibi zam istiyor. Kuzeninin düğününe
ne takacaksın? Dayın borç istiyor, "birkaç aya öderim" diyor. Arsanın
yanından yol geçecekmiş — söylenti mi, bilgi mi? Bazı kararların sonucu
aylar sonra ortaya çıkar; o zamana kadar merak edersin.

Çevren genişledikçe gelen teklifler büyür. Tanınmayan birine kimse
ortaklık önermez.

DİP DE VAR
Parası biten kemer sıkar. Taksitini ödeyemeyen icrayla tanışır: eline ne
varsa satılır, borcun silinir, kredi kapın iki yıl kapanır. Ama bu bir
son değil, bir dip. Oradan da geri dönülür.

Aynı hayatı ikinci kez yaşayamazsın, ama yeni bir tane kurabilirsin.

Bu bir oyundur, yatırım tavsiyesi değildir. Oyundaki bütün şirket, banka,
kulüp ve kişi isimleri kurgusaldır.
```

### Metinde bilerek YAPILMAYANLAR
- "Simülasyon motoru", "prosedürel üretim", "tohum" gibi geliştirici
  terimleri yok: oyuncu bunları umursamıyor.
- Oyunda OLMAYAN hiçbir şey vaat edilmiyor. İki işletme türü var, metin de
  ikisini sayıyor; on dört meslek var, "onlarca" denmiyor.
- Rakamlar veriyle uyumlu: 14 meslek, 141 kart, 12 yatırım aracı, 5 şehir,
  4 rejim, 65 yaş sınırı. Denge değişirse **bu metin de güncellenmeli**.

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
