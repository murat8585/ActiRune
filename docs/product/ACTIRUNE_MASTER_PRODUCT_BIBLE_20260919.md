# ACTIRUNE MASTER PRODUCT BIBLE

**v1.0 — 19 Eylül 2026**  
Kilitli Ürün Vizyonu • Oyun Tasarımı • Sistemler • Monetizasyon • Sosyal • Teknik Uygulama Doktrini

> Bu belge ActiRune için ürün, oyun tasarımı ve uygulama otorite belgesidir. LOCKED kararlar, kullanıcı tarafından açıkça değiştirilmedikçe korunur.

## İçindekiler
- 0. Belge Otoritesi ve Kullanım Kuralı [MASTER]
- 1. Ürün Vizyonu ve Tek Cümlelik Tanım [LOCKED]
- 2. Ürün Ne Değildir: Kesin Sınırlar [LOCKED]
- 3. Ana Oyun Döngüsü [LOCKED]
- 4. Günlük, Haftalık ve Uzun Vadeli Döngüler [LOCKED]
- 5. Ana Navigasyon ve Ekran Hiyerarşisi [LOCKED]
- 6. Görsel Dil ve Görsel Otorite [LOCKED]
- 7. Kilitli Ana Dünya Ekranı [LOCKED]
- 8. Kilitli Macera Ekranı [LOCKED]
- 9. Canonical Savaş Akışı [LOCKED]
- 10. Savaşa Hazırlık Ekranı [PENDING VISUAL]
- 11. Kilitli Hareket / Kamera Hazırlık Ekranı [LOCKED]
- 12. Kilitli Canlı Savaş Ekranı [LOCKED]
- 13. Kilitli Form Koçu Overlay [LOCKED]
- 14. Hareket Kütüphanesi ve Oyundaki Anlamı [LOCKED]
- 15. Çok Aşamalı Boss Savaşı Tasarımı [LOCKED]
- 16. Pasif Aktivite ve Aktif Savaş Katmanları [LOCKED]
- 17. Savaş Ekipmanı, İksir ve Aktif Eşya Slotları [LOCKED]
- 18. Ekonomi: Para Birimleri ve Kaynaklar [LOCKED]
- 19. Malzeme Sistemi, Crafting ve Loot [LOCKED]
- 20. Player Level, Hero Level, Lumi ve Movement Mastery [LOCKED]
- 21. Player Level Milestone Tasarımı [LOCKED]
- 22. Daily Quest Engine [LOCKED]
- 23. Weekly Quest Engine: Seviyeye Göre Büyüyen Sistem [LOCKED]
- 24. Story Quest, Quest Chain, Social, Season ve Hidden Quest [LOCKED]
- 25. 7 Günlük Esnek Aktivite Yolu ve Streak [LOCKED]
- 26. Dynamic Difficulty Engine [REQUIRED]
- 27. Recovery ve Sağlık Güvenliği Motoru [REQUIRED]
- 28. İlk Kullanım Kalibrasyonu [REQUIRED]
- 29. World Progression [LOCKED]
- 30. Achievement / Rozet Koleksiyonu [LOCKED]
- 31. Lumi’nin Ürün İçindeki Rolü [LOCKED]
- 32. Sosyal Savaş Yol Haritası [LOCKED]
- 33. İlk Canlı Sosyal Mod: 2 Kişilik Live Boss Raid [LOCKED]
- 34. Ghost Duel ve Live 1v1 Tasarımı [PLANNED]
- 35. Multiplayer Veri ve Anti-Cheat İlkeleri [REQUIRED BEFORE RANKED]
- 36. ActiRune Pro: Satın Alma Nedeni [LOCKED]
- 37. Free / Pro Sınırı [LOCKED]
- 38. Rewarded Ads: Rune Shrine ve PvE Revive [LOCKED]
- 39. Bildirim ve Geri Dönüş Motoru [PLANNED / HIGH]
- 40. LiveOps, Sezon ve İçerik Ritmi [PLANNED]
- 41. Analitik ve Dengeleme Altyapısı [REQUIRED]
- 42. Teknik Ürün Mimarisi [LOCKED DIRECTION / VALIDATE REAL DEVICE]
- 43. Kamera ve Pose Doğrulama İlkeleri [REQUIRED]
- 44. Gizlilik, Adalet ve Güvenlik İlkeleri [LOCKED]
- 45. İçerik ve Dünya Tasarım Çerçevesi [LOCKED DIRECTION]
- 46. 1. Sürüm Öncelik Matrisi [LOCKED]
- 47. İlk Sürümde Özellikle Yapılmayacaklar [LOCKED]
- 48. Ekran Tasarım Kuralı: Her Ekran Tek Soruyu Cevaplar [LOCKED]
- 49. Görsel ve UX Kabul Kriterleri [LOCKED]
- 50. Codex / Geliştirme Çalışma Doktrini [LOCKED]
- 51. Açık Konular ve Bir Sonraki Kilitlenecek Kararlar [NEXT]
- 52. Nihai Ürün Manifestosu [LOCKED]

# 0. Belge Otoritesi ve Kullanım Kuralı

**Durum: MASTER**
Bu belge, erişilebilir ActiRune proje konuşmaları, kilitli tasarım kararları, mevcut V2 uygulama durumu ve son ürün kararlarının tek bir profesyonel ürün tanımında birleştirilmiş halidir.

Amaç, bundan sonra tasarım, Codex geliştirme, test, içerik üretimi ve iş planında “hangi kararı vermiştik?” sorusunu ortadan kaldırmaktır.

Çelişki olduğunda otorite sırası: kullanıcının en son açık talimatı > bu Master Product Bible içindeki LOCKED kararlar > güncel onaylı görsel referanslar > doğrulanmış V2 runtime davranışı > eski ve superseded çalışmalar.

V1.1 görsel dili ve superseded eski ekranlar yeni tasarım otoritesi değildir. Eski Canlı Savaş ekranı ise kullanıcı tarafından özel olarak korunup yeniden kilitlendiği için istisnadır.

- LOCKED: Değiştirilmemesi gereken ürün kararı.
- REQUIRED: Ürünün güvenli/çalışır olması için zorunlu sistem.
- PLANNED: Ana vizyonda var ancak ilk sürüm şartı değil.
- PENDING VISUAL: İşlev ve akış kilitli, nihai görsel seçimi henüz kilitli değil.
- VALIDATE: Ürün kararı var fakat gerçek cihaz / gerçek kullanıcı verisiyle doğrulanması gerekiyor.

# 1. Ürün Vizyonu ve Tek Cümlelik Tanım

**Durum: LOCKED**
ActiRune, gerçek hayattaki günlük hareketleri fantastik bir RPG’de keşif, savaş, karakter gelişimi ve sosyal ilerlemeye dönüştüren “Movement RPG” ürünüdür.

Kullanıcı yalnızca adım saymaz veya egzersiz videosu izlemez. Gerçek hayatta yaptığı hareket, oyunun anlamlı ilerlemesinin doğrudan kaynağıdır.

Kısa marka vaadi: “Gerçekte hareket et. ActiRune’da güçlen.”

Uluslararası kısa ifade: “Walk. Train. Fight. Together.”

- WALK = EXPLORE — Yürüyüş dünyada ilerleme ve keşif üretir.
- WORKOUT = FIGHT — Kamera ile doğrulanan gerçek egzersiz savaş eylemidir.
- CONSISTENCY = GROW — Düzenlilik Player, Hero, Lumi ve Movement Mastery gelişimini üretir.
- Ana ürün yasası: Oyundaki anlamlı ilerlemenin kaynağı gerçek dünya hareketidir.
- Para, reklam veya premium satın alma gerçek hareketi “satın alarak atlama” aracı olamaz.

# 2. Ürün Ne Değildir: Kesin Sınırlar

**Durum: LOCKED**
ActiRune’u güçlü kılacak şey özellik sayısı değil, bütün sistemlerin aynı ana döngüye hizmet etmesidir.

- Sadece adım sayan bir RPG kaplaması değildir.
- Sadece “15 squat yap, +20 XP al” uygulaması değildir.
- Sadece fitness takipçisi veya klasik antrenman video kütüphanesi değildir.
- Pay-to-win değildir; Kristal satın alarak boss geçilemez veya hareket atlanamaz.
- Reklam izleme zorunlu değildir; reklam oyunun akışını kesmez.
- İlk sürümde yüzlerce malzeme, para birimi veya gereksiz crafting çöpü olmayacaktır.
- Günlük görev sistemi kullanıcıya suçluluk/borç hissi veren bir yapılacaklar listesine dönüşmeyecektir.
- Her gün daha fazla tekrar dayatan sağlıksız “grind” tasarımı olmayacaktır.
- Kamera görüntüsü sosyal savaş için rakibe gönderilmeyecektir; mümkün olduğunca cihaz üzerinde işlenecektir.

# 3. Ana Oyun Döngüsü

**Durum: LOCKED**
ActiRune’un bütün sistemleri aşağıdaki çekirdek döngüyü beslemek zorundadır.

- 1) Günlük hayatta yürü / aktif ol.
- 2) Ana Dünya günlük durumunu özetler.
- 3) Hareket Macera haritasında ilerlemeye dönüşür.
- 4) Encounter / sandık / mini boss / boss açılır.
- 5) Savaşa Hazırlık ekranında düşman, hareket, hedef ve ödül görülür.
- 6) Hareket/Kamera Hazırlık ekranı vücut-kadraj ve pose hazırlığını doğrular.
- 7) Canlı Savaşta doğrulanmış gerçek hareket boss’a saldırı/savunma etkisi üretir.
- 8) Form Koçu gerektiğinde anlık düzeltme verir.
- 9) Zafer/Yenilgi sonucunda loot, XP, malzeme ve ilerleme işlenir.
- 10) Crafting / Hero / Lumi / Movement Mastery / Player Level gelişir.
- 11) Yeni görevler, bölgeler, sosyal savaşlar ve içerikler açılır.
- 12) Kullanıcı ertesi gün kişisel macerasına geri döner.

# 4. Günlük, Haftalık ve Uzun Vadeli Döngüler

**Durum: LOCKED**
### Döngü Katmanı

| Katman | Kullanıcı Sorusu | Sistem Cevabı |
| --- | --- | --- |
| Dakikalar | Şimdi ne yapacağım? | Encounter → hareket → savaş → anlık ödül |
| Günlük | Bugün neyi tamamlamalıyım? | Günlük görevler + kişisel macera + Rune Shrine |
| Haftalık | Bu hafta neyin peşindeyim? | Seviyeye göre 6–12 haftalık görev + kademeli ödül |
| Bölgesel | Bu dünyada ne kadar ilerledim? | %0–100 World Progression + boss + gizli içerik |
| Uzun Vadeli | Neden aylarca kalayım? | Player/Hero/Lumi/Mastery + başarılar + yeni dünyalar + sosyal |
| Sezonluk | Bu dönemde özel hedef ne? | Sezon görevleri, hikâye, etkinlik ve kozmetik içerik |

# 5. Ana Navigasyon ve Ekran Hiyerarşisi

**Durum: LOCKED**
Alt ana navigasyon beş öğe olarak korunur. Savaşa Hazırlık Savaş sekmesinin alt akışıdır; Canlı Savaş sırasında ana alt menü gösterilmez.

- Görevler önemli bir ana sistemdir ancak 6. alt menü yapılmaz; Ana Dünya yan girişi, hızlı erişim ve bağımsız Görevler ekranı ile açılır.
- Plus, Mağaza, Sezon, Arkadaş, Başarı, Crafting gibi sistemler ilgili ana sekmelerin alt akışında yer alır.
- Canlı Savaş ve Kamera Hazırlık sırasında alt navigasyon kaldırılır; odak tek akışta tutulur.

### Ana Alt Menü

| Sekme | Ana işlev |
| --- | --- |
| Ana Dünya | Bugün ne yaptım, durumum ne, sıradaki ilerleme ne? |
| Macera | Hareketim beni dünyada nereye götürdü? |
| Savaş | Açılmış karşılaşma / savaş hazırlığı / savaş akışı |
| Kahraman | Hero, ekipman, Rune, loadout ve gelişim |
| Profil | Player Level, başarılar, sosyal kimlik, ayarlar ve geçmiş |

# 6. Görsel Dil ve Görsel Otorite

**Durum: LOCKED**
ActiRune görsel kimliği premium karanlık-fantastik bilimkurgu karışımıdır. Generic Flutter/Material kartlarıyla düzleştirilmemelidir.

Görsel hedef: premium mobil oyun kalitesi, güçlü 3D/2.5D derinlik, sinematik sahne, elektrik mavi/cyan rune parlamaları, kontrollü altın süslemeler ve karanlık lacivert/siyah UI.

- Kahraman, Lumi, ikon dili, çerçeveler ve ışık dili ekranlar arasında tutarlı kalacak.
- Ana sahneler full-bleed çalışacak; sistem barları üzerinde dahi arka plan devam edebilir, etkileşimli kontroller SafeArea içinde tutulur.
- V1.1 ekranları/assetleri yeni tasarımlarda referans değildir.
- Codex yeni görsel icat etmeyecek; kullanıcı tarafından onaylanmış güncel referansı uygulayacak.
- Her yeni ekran önce kilitli önceki ekranlara bakılarak tasarlanacak; tekrar etmeyecek, eksik işlevi tamamlayacak.

# 7. Kilitli Ana Dünya Ekranı

**Durum: LOCKED**
Ana Dünya, sağlık takip uygulaması dashboard’u değil; günlük hareketin oyun dünyasındaki anlamını tek bakışta anlatan ana merkezdir.

- Üst: ActiHero Seviye 12 örneği, ActiRune marka, Günlük Seri.
- Yan hızlı girişler: Mesajlar, Görevler, Etkinlikler, Ayarlar.
- Ana sahne: Yeşil Vadi, Hero ve Lumi.
- Bugünkü Hareketin: adım, doğrulanmış hareket, aktif dakika, Rune Energy.
- Yeşil Vadi mini ilerleme: keşfet/karşılaş/fethet; sıradaki karşılaşmaya kalan adım.
- Dünün Özeti ve Ödüller hızlı kartları.
- Ana soru: “Bugün ne yaptım / ne durumdayım / sıradaki anlamlı ilerleme ne zaman?”
- Kalori ana ilerleme para birimi değildir; gerekiyorsa ikincil “tahmini kalori” metriğidir.

# 8. Kilitli Macera Ekranı

**Durum: LOCKED**
Macera, Ana Dünya’daki günlük ölçümü tekrar etmez. Ana işlevi hareketin oyunda yarattığı coğrafi/öyküsel ilerlemeyi göstermektir.

- Büyük bölge haritası ana görsel odağıdır.
- Kullanıcının “Sen Buradasın” konumu ve ilerlediği rota görünür.
- Keşif Noktası → Karşılaşma → Hazine → Mini Boss → Bölge Bossu gibi node tipleri bulunur.
- “Sonraki karşılaşmaya 1.580 adım” gibi kompakt, güçlü motivasyon bilgisi bulunur.
- Bölge Hikâyesi, Keşif Günlüğü, Bölge Ödülleri ve Dünya Haritası girişleri bulunur.
- Ana Dünya’daki büyük adım/aktif dakika/Rune Energy dashboard’u burada tekrar edilmez.
- Ana soru: “Gerçek hayattaki hareketim beni bu dünyada nereye götürdü?”

# 9. Canonical Savaş Akışı

**Durum: LOCKED**
Savaş akışı ürünün en kritik oyun/fitness birleşimidir ve aşağıdaki sıra değişmeden korunacaktır.

- Macera → encounter açılır.
- Savaşa Hazırlık → düşman + hareket + hedef + tahmini süre + olası ödül.
- SAVAŞA BAŞLA → Hareket/Kamera Hazırlık.
- Hareket/Kamera Hazırlık → squat/lunge/push-up/plank nasıl yapılır + kadraj + kamera + ışık + pose hazırlığı.
- HAZIRIM → eski, güçlü 3D Canlı Savaş ekranı.
- Canlı Savaş içinde gerektiğinde Form Koçu overlay açılır; battle state kaybolmaz.
- Zafer/Yenilgi → ödül/performans → Macera’ya dönüş.
- Standart hikâye savaşında araya ikinci kez “Hareket Seç” ekranı konmaz; hareket encounter tarafından belirlenmiştir.

# 10. Savaşa Hazırlık Ekranı

**Durum: PENDING VISUAL**
İşlev kilitli; nihai tek görsel referans henüz kullanıcı tarafından özel olarak seçilip kilitlenmemiştir.

- Sinematik Hero ↔ düşman karşılaşması baskın olmalı.
- Düşman adı/seviyesi/tehdit bilgisi.
- Gerçek hareket: Squat, Lunge, Push-up veya Plank.
- Hedef: tekrar veya süre.
- Tahmini süre.
- Olası ödüller.
- Büyük tek CTA: SAVAŞA BAŞLA.
- Bu ekran bilgi paneli mezarlığına dönüşmemeli; eski savaş ekranının premium oyun hissini taşımalı.
- Bu ekranda 5’li ana navigasyon gösterilebilir; kullanıcı henüz canlı savaşta değildir.

# 11. Kilitli Hareket / Kamera Hazırlık Ekranı

**Durum: LOCKED**
Kullanıcının yüklediği ve onayladığı kamera/pose hazırlık görseli canonical referanstır.

- Canlı kamera kadrajı ekranın en büyük parçasıdır.
- Vücut üzerinde pose noktaları/iskelet çizgileri görünür.
- Squat veya encounter’ın istediği hareket için kısa form öğretimi bulunur.
- Kamera ✓, Tüm Vücut ✓, Işık ✓, Alan ✓, Pose Algılama ✓ gibi gerçek durum kontrolleri.
- Hazırım düğmesi yalnızca gerekli hazırlık koşulları sağlandığında etkinleşmelidir.
- Alt ana menü yoktur.
- Hareket türü hard-code edilmez; encounter profiline göre içerik dinamik değişir.

# 12. Kilitli Canlı Savaş Ekranı

**Durum: LOCKED**
Kullanıcının “eski güzel savaş ekranı” olarak seçtiği güçlü 3D/2.5D savaş tasarımı korunacaktır. Yeniden düzleştirilmiş generic UI ile değiştirilmez.

- Hero + Lumi + düşman sahnede.
- Boss HP ve savaş fazı görünür.
- Squat/Lunge/Push-up/Plank hedefi ve doğrulanmış ilerleme görünür.
- Combo, Rune Energy, özel saldırı ve gerekli savaş geri bildirimi görünür.
- Doğrulanmış gerçek hareket → hasar/savunma/özel etki.
- Yanlış/eksik form → tekrar sayılmayabilir veya düşük etki; Form Koçu düzeltme verir.
- Pause/resume aynı battle session state’ini korur.
- Alt ana menü yoktur.

# 13. Kilitli Form Koçu Overlay

**Durum: LOCKED**
Kullanıcının seçtiği Form Koçu görseli canonical yönelimdir: savaş görüntüsü kaybolmaz, kamera/pose ve anlık düzeltme savaşın üzerine bindirilir.

- Örnek olumsuz geri bildirim: “Kalçanı geriye gönder”, “Biraz daha aşağı in”.
- Örnek olumlu geri bildirim: “Harika form”, combo/bonus teyidi.
- Tekrar sayısı, boss HP ve battle session sıfırlanmaz.
- Form feedback eyleme dönük, kısa ve güvenli olmalıdır.
- Pro Form Koçu bunun gelişmiş geçmiş/analiz katmanıdır; temel anlık form feedback Free’de kalır.

# 14. Hareket Kütüphanesi ve Oyundaki Anlamı

**Durum: LOCKED**
ActiRune sadece Squat oyunu değildir. İlk çekirdek savaş hareket seti dört harekettir ve her biri oyunda farklı rol üstlenir.

- Her hareket için kolaylaştırılmış alternatif varyasyonlar bulunmalıdır: diz üstü push-up, duvar push-up, destekli lunge, sandalye/yarım squat, diz plankı vb.
- Hız ana skor kriteri değildir. Güvenli form, doğrulama ve tamamlanma hızdan daha değerlidir.
- Yeni hareketler ilk sürüm çekirdeği kanıtlandıktan sonra eklenebilir; ilk aşamada 20 hareketlik gereksiz kütüphane yapılmaz.

### Hareket Profilleri

| Hareket | Ana oyun rolü | Örnek doğrulama | Örnek savaş etkisi |
| --- | --- | --- | --- |
| Squat | Temel saldırı / alt vücut | Tam iniş-çıkış, derinlik, diz/kalça formu | Standart hasar, combo doldurma |
| Lunge | Çeviklik / dodge / kritik | Sağ-sol bacak, diz açısı, iniş, denge | Dodge, kritik pencere, çeviklik saldırısı |
| Push-up / Şınav | Ağır saldırı / zırh kırma | Gövde çizgisi, dirsek bükülmesi, tam tekrar | Armor break, ağır hasar, stun |
| Plank | Savunma / kalkan / dayanıklılık | Gövde hizası, pozisyon koruma, süre | Kalkan, hasar azaltma, takım savunması |

# 15. Çok Aşamalı Boss Savaşı Tasarımı

**Durum: LOCKED**
Final ürün, “15 squat → boss öldü” seviyesinde kalmamalıdır. Bosslar hareketlerin farklı anlamlarını kullanan fazlara sahip olmalıdır.

- Örnek: Taş Golem saldırıya hazırlanır → Plank ile kalkan.
- Zırh açığı oluşur → Push-up ile zırh kırma.
- Kritik pencere → Lunge ile dodge/kritik.
- Final hasar penceresi → Squat combo.
- Savaşlar kısa ve yapılabilir bloklara ayrılır; varsayılan hedef 2–5 dakikalık aktif encounter hissidir.
- Formu bozacak aşırı hız baskısı, kullanıcıyı riskli harekete teşvik eden leaderboard mantığı ve bitmeyen tekrar grind’ı yoktur.

# 16. Pasif Aktivite ve Aktif Savaş Katmanları

**Durum: LOCKED**
- Kullanıcı her oyun eyleminde kamera açmak zorunda kalmaz.
- Kamera; savaş, özel görev, antrenman ve doğrulama gereken yüksek değerli aksiyonlarda kullanılır.
- Bu ayrım hem kullanım sürtünmesini azaltır hem ActiRune’un benzersiz savaş özelliğini korur.

### İki Katmanlı Hareket Sistemi

| Katman | Kaynak | Oyun sonucu |
| --- | --- | --- |
| Pasif günlük aktivite | Adım, aktif dakika, sağlık/aktivite verisi | Keşif, dünya ilerlemesi, günlük durum, bazı görevler |
| Aktif doğrulanmış hareket | Kamera + pose + hareket doğrulayıcı | Savaş hasarı, savunma, form, mastery, yüksek değerli görev/ödül |

# 17. Savaş Ekipmanı, İksir ve Aktif Eşya Slotları

**Durum: LOCKED**
Ekipman ve iksirler savaşa strateji katar, fakat gerçek hareketin yerini almaz.

- Önerilen başlangıç: 3 aktif eşya slotu.
- Can İksiri → HP toparlar.
- Rune İksiri → Rune Energy / özel yetenek enerjisi desteği.
- Koruma Rünü → bir saldırıyı azaltır veya savunma desteği sağlar.
- İleri örnekler: Combo Koruyucu, Kritik Rune, Lumi Desteği.
- Hiçbir eşya “15 squat yerine kullan” işlevi taşımaz.
- PvE’de ekipman etkileri daha serbesttir; Ranked PvP’de normalize/sınırlandırılır.

# 18. Ekonomi: Para Birimleri ve Kaynaklar

**Durum: LOCKED**
Ekonomi sade kalmalıdır. Her sistem için ayrı token üretmek yasaktır.

### Ekonomi Varlıkları

| Varlık | Rol | Satın alınabilirlik / kural |
| --- | --- | --- |
| Altın | Normal oyun parası; crafting, upgrade, sıradan iksir | Oyun içinden bolca kazanılır |
| Kristal | Nadir/premium para; kozmetik, görünüm, bazı premium kolaylıklar | IAP ile alınabilir; pay-to-win olamaz |
| Rune Energy | Savaş içi enerji / güç göstergesi | Para değildir; gerçek hareketle dolar |
| XP | Player/Hero progression girdisi | Para değildir |
| Malzemeler | Crafting ve gelişim girdileri | Bölge, boss, görev ve sandıklardan düşer |

# 19. Malzeme Sistemi, Crafting ve Loot

**Durum: LOCKED**
Malzeme çeşitliliği oyuna RPG derinliği katmalıdır; envanteri çöplüğe çevirmemelidir. Başlangıçta yaklaşık 5–7 ana malzeme ailesi + bölgesel varyasyonlar hedeflenir.

- Rün Parçası → Rune / ekipman geliştirme.
- Kadim Cevher → silah/zırh crafting.
- Canavar Özü → canavar/boss temalı geliştirme.
- Ruh Tozu → özel yetenek / büyü / yüksek seviye crafting.
- Lumi Özü → Lumi gelişimi ve evrimi.
- Boss Çekirdeği → nadir, özel crafting gereksinimi.
- Nadirlik: Normal → Nadir → Epik → Efsanevi.
- Bölgesel örnek: Yeşil Vadi materyalleri, Buz Diyarı için Buz Kristali/Donmuş Cevher, Volkan için Alev Özü/Obsidyen/Titan Çekirdeği.
- Boss, sandık, gizli görev, Rune Shrine ve raid farklı drop tablolarına sahip olmalıdır.
- Nadir drop heyecan yaratmalı; temel progression nadir RNG’ye mahkûm edilmemelidir.

# 20. Player Level, Hero Level, Lumi ve Movement Mastery

**Durum: LOCKED**
Progression tek bir sayı değildir. Dört ayrı gelişim ekseni birbirinden farklı anlam taşır.

- Movement Mastery yalnızca gerçek doğrulanmış hareketle gelişir; satın alınamaz.
- Player Level kalıcıdır; sezon rank’i ayrı sistem olabilir ve sezon sonunda sıfırlanabilir.
- Seviye artışı sadece sayıları büyütmez; yeni sistem/quest/boss/region çeşitliliği açar.

### Progression Katmanları

| Sistem | Ne anlatır? | Ne açar? |
| --- | --- | --- |
| Player Level | Hesabın genel ActiRune deneyimi | Yeni sistem, bölge, görev tipi, sosyal özellik, milestone ödülleri |
| Hero Level | RPG karakterinin savaş gelişimi | Skill, Rune kapasitesi, ekipman ve combat yetenekleri |
| Lumi Bond / Level | Lumi ile bağ ve evrim | Destek yetenekleri, evrim, kozmetik/animasyon |
| Movement Mastery | Gerçek hareket ustalığı | Squat/Lunge/Push-up/Plank ayrı mastery, unvan/kozmetik/mekanik |

# 21. Player Level Milestone Tasarımı

**Durum: LOCKED**
Kesin sayı dengeleri ileride değişebilir; prensip kilitlidir: kullanıcı “bir sonraki seviyede ne açılıyor?” sorusunun cevabını görmelidir.

### Örnek Milestone Yolu

| Seviye | Örnek açılım |
| --- | --- |
| Lv. 5 | İlk Rune slotu |
| Lv. 10 | Yeni bölge / gelişmiş quest havuzu |
| Lv. 15 | Raid erişimi |
| Lv. 20 | İkinci loadout |
| Lv. 25 | Ghost Duel |
| Lv. 30 | Yeni crafting tier |
| Lv. 40 | Yüksek seviye bosslar |
| Lv. 50 | Özel Hero görünümü |
| Lv. 75 | Özel Lumi evrimi |
| Lv. 100 | Prestij / kalıcı özel ödül |

> **Not:** Tablodaki level eşikleri ürün dengeleme aşamasında ayarlanabilir; sistemin kendisi kilitlidir.

# 22. Daily Quest Engine

**Durum: LOCKED**
Günlük görev sistemi ActiRune’un ana retention motorlarından biridir. Görevler kontrol listesi değil, günlük küçük macera olarak tasarlanacaktır.

- Her gün 5 görev adayı hazırlanır.
- 3 görev tamamlamak ana Günlük Rün Sandığını açar.
- 1 görev → küçük İlk Zafer ödülü.
- 3 görev → ana Günlük Rün Sandığı.
- 5/5 → Usta Tamamlama Bonusu / ek drop şansı.
- Kullanıcı 5/5 yapmak zorunda değildir; normal günlük hedef 3/5’tir.
- Görev aileleri: Keşif, Savaş, Ustalık/Form, Gelişim, Sosyal, Recovery.
- Görevler farklı sistemleri keşfettirir; aynı hareketi her gün zorunlu kılmaz.
- Günlük en az 1 ücretsiz görev değiştirme mantığı korunabilir; Pro kişiselleştirme daha gelişmiş olacaktır.

# 23. Weekly Quest Engine: Seviyeye Göre Büyüyen Sistem

**Durum: LOCKED**
Haftalık görevler günlüklerin sadece “7 katı” değildir. Çeşitlilik, devamlılık, boss, sosyal ve ustalık hedeflerini birlikte ölçer.

- Seviye arttıkça sadece adet değil, görev türlerinin karmaşıklığı artar.
- Düşük seviye: adım, temel savaş, basit hareket.
- Orta seviye: farklı aktif günler, birden fazla hareket türü, form hedefleri, mini boss.
- Yüksek seviye: raid, quest chain, farklı bölgeler, boss koşulları, yüksek form, sosyal katkı.
- Ham tekrar sayısını sonsuza kadar büyütmek yerine yeni mekanikler açılır.

### Seviyeye Göre Haftalık Görev Sayısı

| Player Level | Toplam haftalık görev | Ana ödül için minimum |
| --- | --- | --- |
| Lv. 1–9 | 6 | 4 |
| Lv. 10–24 | 8 | 5 |
| Lv. 25–49 | 10 | 6 |
| Lv. 50+ | 12 | 7 |

### Ödül Yolu Örneği

| Tamamlanan | Ödül mantığı |
| --- | --- |
| 2 görev | Altın / küçük kaynak |
| 4 görev | Malzeme sandığı |
| Ana eşik | Haftalık Epik Sandık |
| İleri eşik | Nadir Rune / yüksek değerli malzeme |
| %100 | Usta Tamamlama Ödülü; zorunlu değil |

# 24. Story Quest, Quest Chain, Social, Season ve Hidden Quest

**Durum: LOCKED**
Görev ekranı dört ana içerik alanına ayrılır: Bugün, Haftalık, Macera/Story, Sosyal. Sezonluk içerik üst banner veya ayrı ilerleme yolu olabilir.

- Quest Chain: Kurt Avcısı I → II → III → Alfa Kurt Boss gibi çok adımlı anlatı.
- Bölge görevleri: her dünya kendi görev setine ve malzeme ekonomisine sahip.
- Friend / Rune Bond Quest: iki veya daha fazla oyuncu ortak haftalık hedefe katkı verir.
- Raid Quest: sosyal boss/raid katılımını yönlendirir.
- Season Quest: uzun dönem sezon hedefleri.
- Hidden Quest: nadiren sürpriz olarak açılır; sürekli spam yapılmaz.
- Recovery Quest: hafif yürüyüş/mobilite/dinlenme günü hedefi; streak’i koruyabilir.
- Rune Surge: 1–2 gün ara veren kullanıcı geri döndüğünde ilk görevlerde comeback bonusu; kayıp gün borcu yaratılmaz.

# 25. 7 Günlük Esnek Aktivite Yolu ve Streak

**Durum: LOCKED**
Streak motivasyon verir ancak kullanıcıyı cezalandıran bir FOMO mekanizmasına dönüşmez.

- 7 gün içinde örneğin 5 aktif gün mantığı kullanılabilir; her gün zorunluluğu azaltılır.
- 7. aktif gün / haftalık tamamlama daha büyük ödül verebilir.
- Recovery Day aktif gün sayılabilir.
- Hastalık, seyahat veya dinlenme nedeniyle tek gün kaçırmak kullanıcıyı “her şey bitti” hissine sokmamalıdır.

# 26. Dynamic Difficulty Engine

**Durum: REQUIRED**
Kişiselleştirme slogan değil, ürünün gizli beynidir. Görev ve savaş zorluğu yalnızca Player Level’a göre belirlenmez.

- Girdi: Player Level.
- Girdi: son 7/28 gün hareket ve görev performansı.
- Girdi: form skorları ve hareket bazlı Movement Mastery.
- Girdi: görev tamamlama oranı / başarısızlık paterni.
- Girdi: tercih edilen süre, hedef ve kullanıcı kapasitesi.
- Girdi: zorlanılan veya kullanıcı tarafından uygun görülmeyen hareketler.
- Çıktı: tekrar/süre, encounter zorluğu, boss fazı, görev yoğunluğu ve alternatif hareket.
- Kullanıcı sürekli rahat kazanıyorsa yavaş artış; zorlanıyorsa düşürme/alternatif/recovery.

# 27. Recovery ve Sağlık Güvenliği Motoru

**Durum: REQUIRED**
ActiRune bir fitness ürünü olduğu için retention uğruna aynı kas grubunu her gün zorlayamaz.

- Kas grubu ve hareket geçmişine göre görev dağılımı yapılır.
- İki yoğun alt-vücut gününden sonra yürüyüş + üst vücut + hafif plank/recovery gibi alternatif rota verilebilir.
- Kolay hareket varyasyonları kullanılabilir.
- Kullanıcı ağrı/uygunsuzluk bildirirse hareket alternatifi sunulur; teşhis yapılmaz.
- Recovery Day streak’i bozmaz ve görev sistemi içinde değerli bir gün olarak sayılır.
- Yüksek skor için güvenli olmayan hız veya form bozulması ödüllendirilmez.

# 28. İlk Kullanım Kalibrasyonu

**Durum: REQUIRED**
Kişiselleştirme için ilk gün kısa, anlaşılır ve gerçek bir kalibrasyon yapılmalıdır. Form doldurma tek başına yeterli değildir.

- Hedef: sağlık/fitness amacı, günlük zaman tercihi, deneyim seviyesi.
- Hareket uygunluğu ve tercihleri.
- Kısa kamera/pose tanıtımı.
- Örnek mini test: birkaç Squat, Lunge, kısa Plank; gerektiğinde kolay Push-up varyasyonu.
- Kalibrasyon sonunda ilk mini savaş ile “ActiRune nedir?” kullanıcıya deneyimletilir.
- Sonuç, başlangıç görev ve zorluk profilini oluşturur; tıbbi tanı iddiası taşımaz.

# 29. World Progression

**Durum: LOCKED**
Bölgeler yalnızca açılıp unutulan arka planlar değildir; %0–100 tamamlama ekonomisi ve keşif hissi taşır.

- World Progression girdileri: keşif noktaları, bölge görevleri, gizli sandıklar, mini bosslar, ana boss, özel challenge.
- %100 tamamlama özel kozmetik, Lumi aksesuarı, gizli boss veya koleksiyon ödülü verebilir.
- Eski bölgeler görev, malzeme ve başarı nedeniyle anlamını korur.
- Ana Dünya yalnızca teaser gösterir; ayrıntılı coğrafi ilerleme Macera ekranındadır.

# 30. Achievement / Rozet Koleksiyonu

**Durum: LOCKED**
Görev “şimdi yap” der; başarı “uzun vadede ne başardın?” sorusunu cevaplar.

- İlk savaş / ilk boss.
- 100 km / 1.000 doğrulanmış hareket.
- Yüksek form serileri.
- Raid / arkadaş / sosyal başarılar.
- Lumi Bond milestone’ları.
- Bir bölgeyi %100 tamamlama.
- Gizli başarılar.
- Profilde sergilenebilir rozetler ve seçili unvanlar.

# 31. Lumi’nin Ürün İçindeki Rolü

**Durum: LOCKED**
Lumi yalnızca ekran kenarında duran maskot olmayacaktır. Kullanıcı hareket ettikçe büyüyen, duygusal bağ ve savaş desteği oluşturan ikinci ana progression karakteridir.

- Lumi Bond gerçek devamlılık ve görevlerle artar.
- Evrim seviyeleri görsel ve mekanik fark yaratır.
- Örnek combat tetikleri: 10 doğru tekrar → Lumi Heal; combo → Lumi Shield; Rune %100 → Lumi Ultimate.
- Pro, gelişmiş Lumi evrim yolları ve kozmetik derinliği sunabilir; PvP’de pay-to-win güç üstünlüğü vermez.

# 32. Sosyal Savaş Yol Haritası

**Durum: LOCKED**
Sosyal sistemlerin sırası kullanıcı yoğunluğu ve teknik karmaşıklık gözetilerek kilitlendi.

- 1) Solo savaş.
- 2) Arkadaşla 2 kişilik Live Boss Raid — ilk gerçek zamanlı sosyal savaş.
- 3) Ghost Duel — diğer oyuncunun doğrulanmış performansına asenkron karşılaşma.
- 4) Arkadaşla Live 1v1.
- 5) 4 kişilik Raid.
- 6) Global Ranked Arena.
- 7) World Boss / Guild Wars.

# 33. İlk Canlı Sosyal Mod: 2 Kişilik Live Boss Raid

**Durum: LOCKED**
İlk canlı sosyal mod, global matchmaking yerine arkadaş davetiyle çalışan iki kişilik co-op boss raid olmalıdır.

- Davet kodu / link ile oda oluşturma; başlangıçta global queue şart değil.
- Her kullanıcı kendi kamerasında hareket yapar.
- Rakibe gerçek video gönderilmez; ekranda Hero avatarı ve doğrulanmış oyun eventleri görülür.
- Örnek roller: Squat saldırı, Push-up zırh kırma, Plank takım kalkanı, Lunge kritik/dodge.
- Ortak boss HP iki cihazda senkron olur.
- Takım fazları “PLANK!”, “ZIRH KIRMA!”, “RUNE PENCERESİ!” gibi kısa komutlarla yürütülebilir.
- Canlı video taşıma/moderasyon ihtiyacını ortadan kaldırmak temel teknik tercihidir.

# 34. Ghost Duel ve Live 1v1 Tasarımı

**Durum: PLANNED**
Ghost Duel, oyuncu yoğunluğu düşükken her zaman rakip sağlayan asenkron köprüdür. Live 1v1 daha sonra gelir.

- Ghost profil, doğrulanmış hareket eventlerinin özet performansından oluşur.
- Live 1v1 üç veya daha fazla round içerebilir: Squat, Plank, Lunge vb.
- Skor: doğrulama + form + tamamlanma + güvenli combo; ham hız ana kriter değildir.
- Farklı fitness seviyeleri normalize edilir; herkes aynı ham tekrar sayısına zorlanmaz.
- Ranked PvP ekipman gücü normalize/sınırlandırılır.

# 35. Multiplayer Veri ve Anti-Cheat İlkeleri

**Durum: REQUIRED BEFORE RANKED**
Canlı sosyal savaş adil olmak zorundadır. İstemci kendi kendine hasar yazamaz.

- Kamera → cihaz üzerinde pose → hareket doğrulayıcı → Verified Movement Event.
- Sunucuya minimum olay verisi: hareket tipi, valid/invalid, form özeti, rep/süre, timestamp, session kimliği.
- Server-authoritative combat state: HP, combo, faz ve sonuç merkezi olarak doğrulanır.
- İmkânsız tekrar hızları, tekrar replay paternleri ve anormal event akışı reddedilir.
- Session nonce / sequence / idempotency kullanılır.
- Ranked modda ekipman ve premium güç normalize edilir.
- Gerçek kamera videosu mümkün olduğunca sunucuya veya rakibe gönderilmez.

# 36. ActiRune Pro: Satın Alma Nedeni

**Durum: LOCKED**
Pro “reklam kaldırma” paketi değildir. Kullanıcının bütün ActiRune deneyimini kişisel, derin ve sürekli hale getiren premium katmandır.

- Ek Pro değerleri: reklamsız deneyim, rewarded ad temel ödülünün reklamsız verilmesi, gelişmiş istatistik, uzun dönem trendler, premium sezon hikâyeleri, özel challenge’lar, daha fazla loadout, premium crafting seçenekleri.
- Temel kamera doğrulama ve dört çekirdek hareket Free’de kalır.
- Temel sosyal multiplayer Free havuzunda tutulur; oyuncu havuzu paywall ile bölünmez.
- Yeni temel hareket mekaniği yalnızca Pro’ya kilitlenmemelidir.

### Pro’nun 4 Ana Satış Nedeni

| Özellik | Değer önerisi |
| --- | --- |
| KİŞİSEL GÜNLÜK MACERA | Her gün kullanıcının seviyesi, kapasitesi, son performansı ve süresine göre özel rota/görev/savaş planı |
| PRO FORM KOÇU | Anlık temel uyarının ötesinde form geçmişi, trend, gelişim ve hareket bazlı kişisel analiz |
| TÜM DÜNYALAR & BOSS’LAR | Premium dünyalar, hikâyeler, özel boss zincirleri, raid kampanyaları ve sezon içerikleri |
| HERO & LUMI PROGRESSION+ | Gelişmiş evrim yolları, ekstra derinlik, özel kozmetik/animasyon, gelişmiş loadout ve crafting seçenekleri |

# 37. Free / Pro Sınırı

**Durum: LOCKED**
### Önerilen Ürün Sınırı

| FREE | PRO |
| --- | --- |
| Temel yürüyüş/keşif | Kişisel günlük macera motoru |
| Squat/Lunge/Push-up/Plank | Gelişmiş Pro Form Koçu |
| Temel kamera doğrulama | Tüm premium dünyalar ve boss zincirleri |
| Temel Form Koçu | Gelişmiş Hero/Lumi progression |
| İlk dünya / temel hikâye | Premium raid/sezon hikâyeleri |
| Solo + temel sosyal modlar | Uzun dönem performans analizi |
| Temel crafting/loot | Gelişmiş loadout/crafting kolaylığı |
| Günlük/haftalık görevler | Adaptive Quest Engine |
| Rewarded Ads | Reklamsız + temel ad ödülünü doğrudan alma |

> **Not:** Fiyat ve deneme süresi ürün testi konusudur; nihai fiyat kilitli değildir. Daha önce $9.99/ay ve $49.99/yıl bir test hipotezi olarak önerildi.

# 38. Rewarded Ads: Rune Shrine ve PvE Revive

**Durum: LOCKED**
Reklam zorunlu değil, kullanıcı seçimine bağlı küçük ödül sistemidir.

- Ana Dünya: Rune Shrine / Rün Tapınağı belirli aralıkla parlar.
- “Ücretsiz Rün Hediyesi” → kullanıcı isterse reklam izler → Rün Sandığı açılır.
- Başlangıç kuralı: 4 saatte 1, maksimum 3/gün.
- Ödül: küçük Altın, normal malzeme, iksir, Rune parçası, düşük ihtimal kozmetik.
- Premium Kristal veya Efsanevi progression reklamla dağıtılmaz.
- PvE yenilgide “Son Bir Şans”: savaş başına maksimum 1 reklam ile yaklaşık %25–30 HP / checkpoint devamı.
- Ranked PvP’de reklamla dirilme yok.
- Kamera hazırlığı, canlı savaş, Form Koçu ve zorunlu zafer akışında reklam yok.
- Pro kullanıcı reklam izlemez; uygun temel reklam ödülü günlük/pro avantaj olarak doğrudan verilebilir.

# 39. Bildirim ve Geri Dönüş Motoru

**Durum: PLANNED / HIGH**
Bildirimler retention sağlar ancak spam ürün kalitesini öldürür. Yalnızca anlamlı eventler kullanılmalıdır.

- Göreve 1 kaldı.
- Rune Shrine hazır.
- Arkadaş Raid daveti.
- Boss / bölge encounter açıldı.
- Haftalık ödül eşiğine az kaldı.
- 2–3 gün yokluk sonrası Rune Surge / geri dönüş mesajı.
- Kullanıcının tercihine göre kategoriler aç/kapa; sessiz saatlere saygı.

# 40. LiveOps, Sezon ve İçerik Ritmi

**Durum: PLANNED**
ActiRune bir kez bitirilen uygulama değil, yaşayan ürün olarak tasarlanır. Ancak ilk sürüm çekirdeği kanıtlanmadan içerik operasyonu şişirilmez.

- Sezonluk görevler ve hikâye ana planda vardır.
- 6–10 haftalık sezon yapısı bir test hipotezidir, nihai süre kilitli değildir.
- Yeni boss, quest chain, kozmetik ve sınırlı bölge etkinlikleri retention için kullanılabilir.
- Player Level kalıcıdır; sezon rank/ödül yolu ayrı olabilir.
- İçerik üretim takvimi teknik/operasyonel kapasiteye göre açılmalıdır.

# 41. Analitik ve Dengeleme Altyapısı

**Durum: REQUIRED**
Analitik olmadan zorluk, görev, Pro ve ekonomiyi körlemesine yönetmiş oluruz.

- Onboarding completion ve kalibrasyon dropout.
- D1/D7/D30 retention.
- Günlük/haftalık görev tamamlama dağılımı.
- Quest reroll ve abandon oranı.
- Hareket bazında başarı/form/invalid rep oranı.
- Boss başarı, tekrar deneme, revive kullanım oranı.
- World progression ve bölge terk noktaları.
- Crafting/loot sink-source dengesi.
- Rune Shrine impression → opt-in → completion.
- Pro paywall view → trial → paid → renewal/churn.
- Sosyal davet → oda → raid completion.
- Analytics eventleri kişisel sağlık verisi ile gereksiz şekilde birleştirilmemelidir.

# 42. Teknik Ürün Mimarisi

**Durum: LOCKED DIRECTION / VALIDATE REAL DEVICE**
Mevcut ActiRune V2 teknik yönü Flutter tabanlıdır ve oyunun bu aşaması için motor değiştirmek gerekmemektedir.

- Flutter: ana uygulama, navigation, UI ve platform katmanı.
- Flame: canlı savaş / oyun döngüsü için uygun mevcut motor.
- camera: kamera akışı.
- Google ML Kit Pose: pose çıkarımı için mevcut yaklaşım.
- go_router: rota yapısı.
- Hareket doğrulayıcı: pose noktalarını Squat/Lunge/Push-up/Plank state machine’lerine dönüştürür.
- Combat Engine: Verified Movement Event → damage/defense/combo/Rune sonucu.
- BattleSession: pause/resume sırasında state korunmalı; victory/defeat/exit ile session retire edilir.
- Gerçek insan ML Kit hareket doğrulaması fiziksel cihazda tam ürün kanıtı olarak ayrıca doğrulanmalıdır.
- Gerçek Health Connect / backend / billing / production signing gibi servisler prototip local adapter durumundan production entegrasyonuna taşınacaktır.

# 43. Kamera ve Pose Doğrulama İlkeleri

**Durum: REQUIRED**
Kamera sistemi yalnızca sayaç değil, hareket kalitesi ve savaş doğrulamasının güven kapısıdır.

- Tüm vücut / ilgili eklem zinciri kadrajda olmalı.
- Confidence düşükse tekrar doğrulanmamalı.
- Hareket state machine: başlangıç → hareket fazı → geçerli alt/üst eşik → tamamlanma → cooldown.
- Her hareketin kendine özgü form kriterleri vardır.
- Pose hatasında kullanıcıya anlaşılır ve kısa yönlendirme verilir.
- Kamera görüntüsü mümkün olduğunca cihazda tutulur; yalnızca gerekli oyun olayları sunucuya gider.
- Video kayıt/depoma varsayılan ürün şartı değildir.

# 44. Gizlilik, Adalet ve Güvenlik İlkeleri

**Durum: LOCKED**
- Kullanıcının kamera görüntüsünü rakibe göstermeme varsayılanı.
- Sağlık/aktivite verisi yalnızca gereken amaçla ve izinle.
- PvP’de premium güç avantajı sınırlandırılır/normalize edilir.
- Çocuk/ergen kullanım senaryoları için yaş, gizlilik ve sosyal iletişim güvenliği ayrıca ele alınmalıdır.
- Oyuncuya güvenli olmayan hareket hızı veya ağrı üzerinden rekabet baskısı oluşturulmaz.
- Uygulama tıbbi teşhis koymaz; egzersiz alternatifi ve genel güvenlik sunar.

# 45. İçerik ve Dünya Tasarım Çerçevesi

**Durum: LOCKED DIRECTION**
Her dünya yalnızca görsel skin değil; görev, düşman, malzeme, boss mekaniği ve progression anlamı taşımalıdır.

### Örnek Dünya Kimlikleri

| Dünya | Mekanik odağı | Örnek kaynak/boss |
| --- | --- | --- |
| Yeşil Vadi | Başlangıç, keşif, temel hareket çeşitliliği | Rün Yaprağı / temel kurt-golem encounter’ları |
| Karanlık Orman | Form ve savaş ustalığı | Canavar Özü / Kurt sürüsü / Alfa Kurt |
| Buz Diyarı | Savunma, Plank, kontrollü tempo | Buz Kristali / Buz Lordu |
| Volkan | Güç, ağır saldırı, yüksek riskli boss fazları | Alev Özü, Obsidyen / Alev Titani |

> **Not:** Dünya isimleri/içerik sayısı içerik üretim aşamasında genişletilebilir; her dünya için mekanik kimlik ilkesi kilitlidir.

# 46. 1. Sürüm Öncelik Matrisi

**Durum: LOCKED**
### Release Fazları

| Faz | Mutlaka çalışan çekirdek | Sonraya bırakılan |
| --- | --- | --- |
| Faz 1 — Core Solo | Ana Dünya, Macera, 4 hareket altyapısı, Kamera Hazırlık, Canlı Savaş, Form Koçu, görevler, Player/Hero/Lumi/Mastery, loot/crafting, recovery/difficulty, Pro temel katmanı, Rewarded Ads | Global PvP, Guild Wars, büyük World Boss |
| Faz 2 — Social Foundation | Arkadaş sistemi, 2 kişilik Live Boss Raid, Ghost Duel, Friend Quest | 4 kişilik raid, global ranked |
| Faz 3 — Competitive | Arkadaş Live 1v1, 4 kişilik Raid, anti-cheat güçlendirme | Guild/World War ölçeği |
| Faz 4 — Live World | Global Ranked, World Boss, Guild Wars, sezon turnuvaları | Yeni büyük sistem ancak veri kanıtı varsa |

# 47. İlk Sürümde Özellikle Yapılmayacaklar

**Durum: LOCKED**
- 20+ hareketlik kontrolsüz egzersiz kütüphanesi.
- Zorunlu interstitial reklamlar.
- Loot box / gacha odaklı ekonomi.
- Premium silah satın alarak PvP’de bariz güç üstünlüğü.
- Canlı video karşı tarafa yayınlanan PvP.
- İlk günden MMO ölçeğinde global matchmaking zorunluluğu.
- Her sistem için ayrı token ve düzinelerce para birimi.
- Ana ekranlarda aynı bilgiyi tekrar tekrar gösteren dashboard yığını.
- V1.1 superseded görsellerine dönüş.
- Codex’in kullanıcı onaylı görsel yerine yeni tasarım uydurması.

# 48. Ekran Tasarım Kuralı: Her Ekran Tek Soruyu Cevaplar

**Durum: LOCKED**
### Ekran Soruları

| Ekran | Cevapladığı tek ana soru |
| --- | --- |
| Ana Dünya | Bugün ne yaptım ve sıradaki ilerlemem ne? |
| Macera | Hareketim beni dünyada nereye götürdü? |
| Savaşa Hazırlık | Bu düşmanı yenmek için ne yapacağım? |
| Kamera Hazırlık | Hareketi güvenli ve doğrulanabilir biçimde yapmaya hazır mıyım? |
| Canlı Savaş | Hareketim doğru mu ve savaşa ne etkisi oldu? |
| Görevler | Bugün/hafta neyi tamamlamalıyım? |
| Kahraman | Hareketlerim karakterimi nasıl geliştirdi? |
| Profil | Ben ActiRune’da ne kadar ilerledim? |
| Pro | Neden para ödemeliyim? |

# 49. Görsel ve UX Kabul Kriterleri

**Durum: LOCKED**
- Onaylı referansa görsel sadakat; premium 3D/2.5D his.
- Ekran üst/alt boşluk, blur bant, generic düz Material katman üretmemeli.
- Tıklanabilir görünen her ana kartın gerçek navigation/aksiyonu olmalı.
- Savaş pause/resume state’i korunmalı.
- Reward claim idempotent olmalı; tekrar açmak çift ödül vermemeli.
- Kamera izin/red/hata durumları güvenli yönetilmeli.
- Görev/progression verisi yeniden açılışta korunmalı.
- Savaş ekranı hareket türünü hard-code etmemeli; movement profile ile sürülmeli.
- Ana akışlarda alt menü görünürlüğü kilit kurallara uymalı.

# 50. Codex / Geliştirme Çalışma Doktrini

**Durum: LOCKED**
ActiRune geliştirmesinde araştırma-first yaklaşımı ve görsel otorite korunur.

- Önce mevcut repo, doküman ve onaylı referans okunur.
- Daha önce kilitlenmiş karar rastgele yeniden tasarlanmaz.
- Yeni görsel üretmek gerekiyorsa kullanıcı/ChatGPT tasarım akışında üretilir; Codex runtime uygulamasını yapar.
- Kapsamlı değişiklikler test/analyze/build ve emulator readback ile kapanır.
- Dış yayın, ödeme, production key, yıkıcı cihaz işlemi ayrı yetki gerektirir.
- Aile Güvende/Kinola proje kaynakları ActiRune ile karıştırılmaz.

# 51. Açık Konular ve Bir Sonraki Kilitlenecek Kararlar

**Durum: NEXT**
Ana omurga artık yeterince zengindir. Bundan sonra kontrolsüz yeni özellik eklemek yerine aşağıdaki eksikler sırasıyla netleştirilmelidir.

- Savaşa Hazırlık için tek final canonical görselin seçilmesi.
- Zafer/Yenilgi ekranlarının yeni ana planla görsel ve ekonomi uyumunun kilitlenmesi.
- Görevler ana ekranının yeni Quest Engine’e göre 10 varyasyonla tasarlanıp seçilmesi.
- Kahraman / Lumi / Envanter / Crafting ana ekranlarının bu ekonomiyle tasarlanması.
- Pro paywall ekranının 4 ana değer önerisine göre yeniden tasarlanması.
- Player Level, Hero Level ve Mastery XP eğrilerinin sayısal dengesi.
- Loot drop oranları ve Gold/Kristal sink-source ekonomisi.
- Gerçek cihazda Squat + Lunge + Push-up + Plank ML Kit doğrulama protokolü.
- 1. gün → 7. gün → 30. gün → 90. gün oyuncu yolculuğunun ayrı retention planı.
- Fiyat, trial ve bölgesel fiyatlandırmanın A/B test planı.

# 52. Nihai Ürün Manifestosu

**Durum: LOCKED**
ActiRune’un başarısı tek bir “havalı özellikten” gelmeyecektir. Başarı; hareketin keşfe, savaşa, loot’a, göreve, karakter gelişimine ve sosyal bağa aynı anda anlamlı biçimde dönüşmesinden gelecektir.

Kullanıcı her gün uygulamayı “egzersiz yapmam gerekiyor” diye değil, “bugünkü maceram ne, hangi boss açıldı, Lumi ne oldu, haftalık görevde ne kaldı?” diye açmalıdır.

Fitness davranışı oyun hedefinin altında gizlenmez; oyun hedefi sağlıklı gerçek hareketle kazanılır. ActiRune’un asıl farkı budur.

- Gerçek hareket merkezde.
- Oyun kalitesi ikinci sınıf değil.
- Kişiselleştirme gerçek performansa dayanır.
- Görevler geri dönüş motorudur.
- Lumi duygusal bağ motorudur.
- Crafting/loot uzun vadeli RPG hedefidir.
- Sosyal savaş büyüme ve bağlılık katmanıdır.
- Pro kişisel derinlik satar; temel hareketi rehin almaz.
- Reklam gönüllüdür; ilerlemeyi satın aldırmaz.
- Sağlık/güvenlik retention’dan önce gelir.

# Ek A — Nihai Kısa Ürün Tanımı

**ActiRune, günlük yürüyüşünü keşfe; kamera ile doğrulanan gerçek egzersizlerini RPG savaşlarına; uzun vadeli hareket alışkanlığını ise kahraman, Lumi, ustalık ve dünya gelişimine dönüştüren kişiselleştirilmiş sosyal Movement RPG’dir.**
