# Meslek Listesi ve Kariyer Ağaçları

Bu dosya kariyer sisteminin TASARIM KAYNAĞIDIR. `assets/careers/*.json`
içindeki sayılar buradaki eksenlerden türetilir. Denge değişirse önce burası
güncellenir.

## Tasarım İlkesi

Meslekler oyunda sadece "farklı maaş rakamı" olmamalı. Her biri **farklı bir
oynanış deneyimi** vermeli. Bunu 6 eksenle kur:

| Eksen | Açıklama |
|---|---|
| **Giriş Bariyeri** | Eğitim süresi, sınav (TUS/KPSS), sermaye. Yüksek bariyer = kaybedilen erken yıllar |
| **Başlangıç Maaşı** | İlk yılların nakit akışı |
| **Tavan** | Kariyerin ulaşabileceği maksimum gelir |
| **Varyans** | Gelirin öngörülebilirliği. Memur=0, emlakçı=çok yüksek |
| **Network Kazanımı** | Fırsat kartlarının kalitesini belirler — bazı meslekler para vermez ama kapı açar |
| **Stres/Enerji Maliyeti** | Her turda yakılan enerji |
| **İşletmeye Geçiş** | Kendi işini kurabilir mi? (`Isletme` sistemine bağlanır) |

**Kritik denge kuralı:** Hiçbir meslek her eksende üstün olmamalı. Doktor
yüksek tavan alıyorsa 8 yılını kaybetmeli ve stresi çok olmalı. Memur güvenli
ise tavanı düşük olmalı. Emlakçı zengin olabiliyorsa iflas da edebilmeli.

**Değerler 1-5 ölçeğinde**, oyun içi denge için başlangıç noktası; bot
testleriyle ayarlanır.

---

## 1. SAĞLIK — Yüksek bariyer, yüksek tavan, yüksek stres

Sektör kimliği: **Geç başlarsın ama geç oyunda kimse yetişemez.** 24-26 yaşına
kadar hiç para kazanmaz, borç birikir; 35'ten sonra muayenehane/klinik açarak
patlama yapar.

| Meslek | Bariyer | Başlangıç | Tavan | Varyans | Network | Stres | İşletme |
|---|---|---|---|---|---|---|---|
| Doktor (uzman) | 5 | 2 | 5 | 2 | 5 | 5 | Muayenehane / özel klinik |
| Doktor (pratisyen) | 4 | 3 | 3 | 1 | 3 | 4 | — |
| Diş Hekimi | 4 | 3 | 5 | 2 | 3 | 3 | Diş kliniği (en kârlısı) |
| Eczacı | 4 | 3 | 4 | 2 | 3 | 2 | Eczane (ruhsat/sermaye engeli) |
| Veteriner | 3 | 2 | 3 | 3 | 2 | 3 | Veteriner kliniği |
| Fizyoterapist | 3 | 2 | 3 | 2 | 2 | 3 | Rehabilitasyon merkezi |
| Hemşire | 2 | 2 | 2 | 1 | 2 | 5 | — |
| Psikolog | 3 | 2 | 4 | 3 | 3 | 4 | Terapi merkezi |

**Kariyer merdiveni (Doktor):** Tıp Öğrencisi → İntörn → Pratisyen →
**TUS Sınavı** → Asistan → Uzman → Başhekim / Muayenehane Sahibi →
Özel Hastane Ortağı

**Özel mekanik: TUS.** Şansa ve yetkinliğe bağlı sınav. Kazanamazsan bir yıl
daha hazırlanırsın (para kaybı) veya pratisyen kalırsın (tavan düşer).

---

## 2. MÜHENDİSLİK VE TEKNOLOJİ — Dengeli, esnek, en kolay girişimci

Sektör kimliği: **Erken para kazanır, orta tavana hızlı ulaşır, girişimciliğe
en kolay geçen sektör.** Yazılımcı "döviz bazlı gelir" ile enflasyona karşı
doğal koruma sağlar — Türkiye'ye çok özgü bir avantaj.

| Meslek | Bariyer | Başlangıç | Tavan | Varyans | Network | Stres | İşletme |
|---|---|---|---|---|---|---|---|
| Yazılım Geliştirici | 2 | 4 | 5 | 3 | 3 | 3 | Yazılım stüdyosu / SaaS |
| Yurtdışına Uzaktan Çalışan | 3 | 5 | 5 | 3 | 2 | 3 | — (döviz geliri!) |
| Veri Bilimci / YZ Uzmanı | 3 | 4 | 5 | 3 | 3 | 3 | Danışmanlık |
| İnşaat Mühendisi | 3 | 3 | 5 | 4 | 4 | 4 | **İnşaat firması / müteahhitlik** |
| Makine Mühendisi | 3 | 3 | 4 | 2 | 3 | 3 | Fabrika / atölye |
| Elektrik-Elektronik Müh. | 3 | 3 | 4 | 2 | 3 | 3 | Taahhüt firması |
| Endüstri Mühendisi | 3 | 3 | 4 | 2 | 4 | 3 | Danışmanlık |
| Harita/Jeoloji Müh. | 3 | 3 | 3 | 3 | 3 | 3 | — (arsa bilgisi avantajı) |
| Siber Güvenlik Uzmanı | 3 | 4 | 4 | 2 | 2 | 4 | Güvenlik firması |
| Mimar | 3 | 2 | 4 | 4 | 4 | 4 | Mimarlık ofisi |

**Kariyer merdiveni (Yazılım):** Stajyer → Junior → Mid → Senior → Takım
Lideri → Yazılım Mimarı / Müdür → CTO → Kurucu

**Özel mekanik:** İnşaat ve harita mühendisi **arsa yatırımında bilgi
avantajı** alır (imar olay kartını önceden görme şansı).

---

## 3. HUKUK, KAMU VE EĞİTİM — Güvenli taban, sınav kapıları

Sektör kimliği: **Düşük varyans, yüksek network, düşük tavan.** Memur zengin
olamaz ama iflas da etmez — riskli yatırım için sağlam taban sunar. Oyuncuya
"güvenli maaş + agresif portföy" stratejisini açar.

| Meslek | Bariyer | Başlangıç | Tavan | Varyans | Network | Stres | İşletme |
|---|---|---|---|---|---|---|---|
| Avukat (serbest) | 4 | 2 | 5 | 5 | 5 | 4 | **Hukuk bürosu** |
| Avukat (şirket içi) | 4 | 3 | 4 | 1 | 4 | 3 | — |
| Hakim / Savcı | 5 | 3 | 3 | 1 | 5 | 4 | — (yasak) |
| Noter | 5 | 5 | 5 | 1 | 4 | 1 | — (geç oyun ödülü) |
| Kaymakam | 5 | 3 | 3 | 1 | 5 | 4 | — |
| Müfettiş / Uzman (kamu) | 4 | 3 | 3 | 1 | 4 | 2 | — |
| Memur (genel) | 2 | 2 | 2 | 1 | 2 | 2 | Yan iş yapabilir |
| Öğretmen | 2 | 2 | 2 | 1 | 3 | 3 | **Dershane / kurs** |
| Akademisyen | 5 | 2 | 3 | 1 | 4 | 3 | Danışmanlık |
| Polis | 2 | 2 | 3 | 1 | 3 | 5 | — |
| Subay | 3 | 3 | 4 | 1 | 4 | 4 | — |

**Türkiye'ye özgü mekanikler — mutlaka:**
- **KPSS / atama bekleme:** Öğretmen mezun olur ama atanamaz. 1-3 tur "atama
  bekleme" durumu — ya işsizdir ya özel okulda düşük maaşla çalışır.
- **Tayin / doğu görevi:** Kamu görevlisi olay kartıyla başka şehre gönderilir.
  Kabul (kariyer ilerler, mutluluk düşer, taşınma maliyeti) veya ret (kariyer
  durur).
- **Noter:** Kura ve kıdemle gelen çok kârlı geç oyun pozisyonu. Avukat/hakim
  kariyerinin "jackpot" ucu.

---

## 4. FİNANS VE MUHASEBE — Para sistemleriyle en entegre sektör

Sektör kimliği: **Yatırım sistemine bilgi avantajı sağlar.** Bu sektörde
çalışan oyuncu piyasa rejim değişimini bir tur önceden sezer (tam bilmez,
ipucu alır).

| Meslek | Bariyer | Başlangıç | Tavan | Varyans | Network | Stres | İşletme |
|---|---|---|---|---|---|---|---|
| Mali Müşavir (SMMM) | 4 | 3 | 4 | 2 | 5 | 3 | **Muhasebe ofisi** |
| Yeminli Mali Müşavir | 5 | 4 | 5 | 2 | 5 | 3 | Büyük ofis |
| Bankacı (şube) | 2 | 3 | 3 | 2 | 4 | 4 | — |
| Bankacı (genel müdürlük) | 3 | 3 | 5 | 2 | 5 | 4 | — |
| Portföy Yöneticisi | 4 | 4 | 5 | 4 | 4 | 5 | Portföy şirketi |
| Aktüer | 4 | 4 | 4 | 1 | 2 | 2 | — |
| Denetçi | 3 | 3 | 4 | 2 | 4 | 4 | Denetim firması |
| Sigorta Acentesi | 1 | 2 | 4 | 4 | 4 | 3 | **Acente (kolay giriş)** |
| Bağımsız Yatırım Danışmanı | 3 | 2 | 5 | 5 | 4 | 4 | Danışmanlık |

Mali müşavir mükemmel bir "network motoru" — her esnafı tanır. Fırsat kartı
kalitesini en çok yükselten mesleklerden biri olsun.

---

## 5. TİCARET VE SATIŞ — Düşük bariyer, çılgın varyans

Sektör kimliği: **Diplomasız zengin olma yolu.** Üniversite okumadan da
kazanılabileceğini göstermeli, ama iflas riski gerçek olmalı. Gelirin büyük
kısmı prim/komisyon — her tur farklı.

| Meslek | Bariyer | Başlangıç | Tavan | Varyans | Network | Stres | İşletme |
|---|---|---|---|---|---|---|---|
| Emlak Danışmanı | 1 | 1 | 5 | 5 | 5 | 4 | **Emlak ofisi** |
| Satış Temsilcisi | 1 | 2 | 4 | 4 | 4 | 4 | — |
| İhracat / Dış Ticaret Uzmanı | 3 | 3 | 5 | 3 | 4 | 3 | **İhracat firması (döviz!)** |
| Gümrük Müşaviri | 3 | 3 | 4 | 3 | 5 | 3 | Müşavirlik firması |
| Toptancı / Tedarikçi | 2 | 2 | 5 | 5 | 4 | 4 | **Toptan ticaret** |
| Oto Galerici | 2 | 2 | 4 | 5 | 4 | 3 | **Oto galeri** |
| E-ticaret Satıcısı | 1 | 1 | 5 | 5 | 2 | 3 | **E-ticaret markası** |
| Turizm Acentesi | 2 | 2 | 4 | 5 | 4 | 4 | Acente (sezonluk!) |

**Özel mekanik:** Emlakçı **gayrimenkulde indirim ve önalım hakkı** alır.
İhracatçı **döviz geliri** kazanır (kur şoklarında kazanır). Turizmci
**mevsimsel gelir** — yazın patlar, kışın sıfır.

---

## 6. ESNAF VE ZANAAT — En erken başlayan yol

Sektör kimliği: **18'de başlar, 25'te dükkanını açar.** Üniversite okuyanlar
hâlâ okurken bu oyuncu para biriktirmiştir. Tavanı düşük ama zaman avantajı
büyük — bileşik getiri sayesinde rekabetçi kalır. Oyundaki en öğretici
stratejik alternatif.

| Meslek | Bariyer | Başlangıç | Tavan | Varyans | Network | Stres | İşletme |
|---|---|---|---|---|---|---|---|
| Elektrikçi | 1 | 2 | 3 | 3 | 3 | 3 | Taahhüt işleri |
| Tesisatçı / Doğalgazcı | 1 | 2 | 3 | 3 | 3 | 3 | Servis firması |
| Oto Tamircisi | 1 | 2 | 4 | 3 | 3 | 3 | **Servis / oto sanayi** |
| Kaynakçı | 1 | 3 | 3 | 3 | 2 | 4 | Atölye |
| Marangoz / Mobilyacı | 1 | 2 | 4 | 3 | 3 | 3 | **Mobilya atölyesi/fabrikası** |
| Kuaför / Berber | 1 | 1 | 3 | 3 | 4 | 3 | **Salon zinciri** |
| Aşçı / Şef | 2 | 2 | 4 | 3 | 4 | 5 | **Restoran** |
| Fırıncı / Pastacı | 1 | 2 | 3 | 3 | 3 | 4 | Fırın / pastane |
| Terzi | 1 | 1 | 3 | 3 | 2 | 3 | Tekstil atölyesi |
| İnşaat Ustası | 1 | 2 | 4 | 4 | 3 | 5 | **Müteahhitlik** |

**Merdiven:** Çırak → Kalfa → Usta → Kendi Dükkanı → Şube/Zincir → Fabrika

İnşaat ustası → müteahhit geçişi, oyundaki en güçlü "sıfırdan zengin"
hikâyelerinden biri. Yüksek riskli, yüksek ödüllü.

---

## 7. MEDYA, SANAT VE İÇERİK — Piyango mekaniği

Sektör kimliği: **Çoğu oyuncu için başarısızlık, bazıları için patlama.**
Gelir üstel dağılımlı: %70 ihtimalle asgari ücret civarı, %5 ihtimalle
astronomik. Oyunun "kumar" bölümü ama emekle şansı harmanlamalı.

| Meslek | Bariyer | Başlangıç | Tavan | Varyans | Network | Stres | İşletme |
|---|---|---|---|---|---|---|---|
| İçerik Üreticisi / YouTuber | 1 | 1 | 5 | 5 | 4 | 4 | **Medya kanalı** |
| Grafik Tasarımcı | 2 | 2 | 3 | 3 | 3 | 3 | **Ajans** |
| UI/UX Tasarımcı | 2 | 3 | 4 | 2 | 3 | 3 | Ajans |
| Fotoğrafçı | 1 | 1 | 3 | 4 | 3 | 3 | Stüdyo |
| Gazeteci | 2 | 2 | 3 | 3 | 5 | 4 | **Yerel gazete (prestij)** |
| Müzisyen | 1 | 1 | 5 | 5 | 4 | 4 | Prodüksiyon şirketi |
| Oyuncu / Sunucu | 1 | 1 | 5 | 5 | 5 | 4 | — |
| Yazar | 1 | 1 | 4 | 5 | 3 | 3 | **Yayınevi** |
| Reklamcı | 2 | 2 | 4 | 3 | 5 | 4 | Reklam ajansı |
| Oyun Geliştirici | 2 | 2 | 5 | 5 | 2 | 4 | Oyun stüdyosu |

---

## 8. ULAŞIM VE LOJİSTİK — Yüksek maaş, düşük yaşam kalitesi

Sektör kimliği: **Parayı alırsın ama mutluluğu ödersin.** Pilot ve gemi
kaptanı: yüksek döviz maaşı, sürekli evden uzak. Mutluluk düşüşü ve "aile
krizi" olay kartlarıyla dengelenir.

| Meslek | Bariyer | Başlangıç | Tavan | Varyans | Network | Stres | İşletme |
|---|---|---|---|---|---|---|---|
| Pilot | 5 | 4 | 5 | 1 | 3 | 4 | — (eğitim borcu büyük!) |
| Kabin Memuru | 2 | 3 | 3 | 1 | 3 | 4 | — |
| Uzakyol Gemi Kaptanı | 4 | 4 | 5 | 1 | 2 | 4 | Gemi/filo sahipliği |
| TIR Şoförü (uluslararası) | 2 | 3 | 3 | 2 | 2 | 5 | **Nakliye filosu** |
| Lojistik Uzmanı | 2 | 3 | 4 | 2 | 4 | 3 | Lojistik firması |
| Kurye / Motokurye | 1 | 1 | 2 | 2 | 1 | 4 | Kargo şubesi bayiliği |
| Taksi/Ticari Şoför | 1 | 2 | 3 | 3 | 3 | 4 | Plaka yatırımı / filo |

**Özel mekanik:** Pilot eğitimi çok pahalı ve **kredi ile finanse edilir**.
Oyuncu 25 yaşında yüksek maaşa başlar ama tepesinde büyük bir borç vardır.

---

## 9. TARIM VE ÜRETİM — Sermaye ve sabır

Sektör kimliği: **Gayrimenkul yatırımıyla en çok kesişen sektör.** Toprak hem
üretim aracı hem yatırım. Hava/rekolte olayları gelir varyansını yaratır.

| Meslek | Bariyer | Başlangıç | Tavan | Varyans | Network | Stres | İşletme |
|---|---|---|---|---|---|---|---|
| Çiftçi | 1 | 1 | 4 | 5 | 2 | 4 | **Tarım işletmesi + arsa** |
| Seracı | 2 | 2 | 4 | 4 | 2 | 4 | Sera işletmesi |
| Besici / Hayvancılık | 2 | 2 | 4 | 5 | 2 | 4 | Çiftlik |
| Ziraat Mühendisi | 3 | 2 | 3 | 2 | 3 | 2 | Danışmanlık / tohum ticareti |
| Gıda Mühendisi | 3 | 3 | 4 | 2 | 3 | 3 | **Gıda fabrikası** |
| Arıcı | 1 | 1 | 3 | 4 | 1 | 3 | Bal markası |
| Madenci | 2 | 3 | 3 | 2 | 1 | 5 | — (sağlık riski yüksek) |

---

## 10. TURİZM VE HİZMET

| Meslek | Bariyer | Başlangıç | Tavan | Varyans | Network | Stres | İşletme |
|---|---|---|---|---|---|---|---|
| Otel Yöneticisi | 3 | 3 | 4 | 3 | 4 | 4 | **Butik otel → tesis** |
| Turist Rehberi | 2 | 2 | 3 | 5 | 4 | 3 | Tur şirketi |
| Barmen / Garson | 1 | 1 | 2 | 3 | 3 | 4 | Kafe/bar |
| Spor Antrenörü | 2 | 2 | 3 | 3 | 3 | 3 | **Spor salonu** |
| Emlak Yöneticisi (site) | 1 | 2 | 3 | 2 | 3 | 3 | Yönetim firması |

---

## Kariyer Durumları (meslek değil, durum)

- **Öğrenci** — 18-22 arası varsayılan. Gelir yok veya çok az, KYK borcu
  birikir, yetkinlik hızlı artar.
- **İşsizlik** — kovulma veya iflas sonrası geçici durum. Gelir yok, gider
  devam eder, mutluluk düşer. Çıkış için olay kartları.
- **Askerlik** — erkek karakterler için zorunlu kesinti. Bedelli (para) veya
  normal askerlik (zaman kaybı).
- **Emeklilik** — 65'te otomatik veya erken emeklilik. Emekli maaşı prim gün
  sayısına bağlı — SGK primi ödemeyen esnaf oyuncular geç oyunda cezalanır.
- **Kayıt dışı çalışma** — daha yüksek net gelir ama SGK primi yok, emeklilik
  yok, iş kazası korumasız.
- **Meslek değiştirme** — mümkün ama bedelli: yetkinliğin bir kısmı sıfırlanır,
  bir kademe geri düşülür. Yoksa oyuncu sürekli en kârlı mesleğe atlar.

---

## v1.0 Kapsamı — 15 Meslek

Tam liste uzun vadeli hedef. v1.0 için **12-15 meslek yeter**, ama her
arketipten en az bir tane olmalı:

1. Doktor (yüksek bariyer / yüksek tavan)
2. Yazılım Geliştirici (dengeli / döviz geliri)
3. İnşaat Mühendisi (girişimciliğe geçiş)
4. Avukat (network motoru)
5. Öğretmen (güvenli / düşük tavan)
6. Memur (en güvenli taban)
7. Mali Müşavir (finansal bilgi avantajı)
8. Emlak Danışmanı (yüksek varyans / diplomasız)
9. Oto Tamircisi (esnaf / erken başlangıç)
10. Aşçı (esnaf → restoran zinciri)
11. İçerik Üreticisi (piyango mekaniği)
12. Pilot (borçla yüksek maaş)
13. Çiftçi (arsa ile kesişim)
14. Satış Temsilcisi (prim bazlı)
15. İşsiz/Öğrenci (durum, meslek değil)

Meslek sayısını artırmak derinlik katmaz — **her mesleğe özel 5-8 olay kartı
yazmak** katar.

---

## Veri Yapısı

Meslekler de olaylar gibi JSON'da tutulur (`assets/careers/*.json`):

```json
{
  "id": "yazilim_gelistirici",
  "ad": "Yazılım Geliştirici",
  "sektor": "teknoloji",
  "girisSarti": { "egitim": "lisans", "yetkinlik": 10, "yas": [21, 99] },
  "kademeler": [
    { "ad": "Stajyer",      "maas": 18000,  "yetkinlikGerek": 0,   "sureTur": 6 },
    { "ad": "Junior",       "maas": 45000,  "yetkinlikGerek": 15,  "sureTur": 18 },
    { "ad": "Mid",          "maas": 85000,  "yetkinlikGerek": 40,  "sureTur": 24 },
    { "ad": "Senior",       "maas": 150000, "yetkinlikGerek": 70,  "sureTur": 30 },
    { "ad": "Takım Lideri", "maas": 220000, "yetkinlikGerek": 90,  "sureTur": 36 },
    { "ad": "CTO",          "maas": 400000, "yetkinlikGerek": 120, "sureTur": null }
  ],
  "yetkinlikArtisHizi": 1.2,
  "networkArtisi": 0.8,
  "enerjiMaliyeti": 3,
  "gelirVaryansi": 0.15,
  "dovizOrani": 0.0,
  "acilanIsletmeler": ["yazilim_studyosu", "saas_urunu"],
  "olayHavuzu": ["tech_01", "tech_02", "tech_03", "tech_04", "tech_05"]
}
```

Maaş rakamları **enflasyona endekslenir** — sabit tutulursa 20 tur sonra
anlamsızlaşır. Motorda:
`gercekMaas = tabanMaas * enflasyonEndeksi * kademeCarpani`
