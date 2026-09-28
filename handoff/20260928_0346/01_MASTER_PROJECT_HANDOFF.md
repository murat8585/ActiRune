# 01 — MASTER PROJECT HANDOFF

## Proje
Ad: ActiRune
Eski çalışma adı: FitQues/FitQuest çizgisinden evrildi.
Repo: `murat8585/ActiRune`

## Ürün hedefi
ActiRune gerçek fiziksel hareketi mobil fantasy RPG ilerlemesine bağlayan bir oyun/uygulama olarak tasarlandı. Kullanıcının yürümesi, squat vb. doğrulanmış hareketleri oyunda enerji, saldırı, görev, ilerleme veya ödül üretmeli. Ürün basit bir fitness tracker değil; oyun mantığı hareket doğrulamasını gerçek oyun ekonomisi ve mücadele döngüsüne bağlamalı.

## Organik büyüme yaklaşımı
- Günlük/haftalık görevler
- Streak/reward loop
- Hareket tabanlı battle hissi
- Rune progression
- Lumi companion progression
- Achievements / badges
- Events
- Social/duel/league families

## Çekirdek playable loop — en yüksek öncelik
1. Home / Ana Dünya
2. Adventure / Macera
3. Battle Prep / Savaş Hazırlık
4. Camera Prep
5. Kamera + ışık + alan + pose algılama readiness
6. Hareket doğrulama
7. Attack/combat response
8. Enemy progression
9. Victory / Defeat
10. Reward/progression
11. Replay / next encounter

Daha önce özellikle karar verildi: çekirdek loop çalışmadan daha fazla yeni ekran icat etmeye öncelik verilmemeli.

## Ana navigasyon
- Ana Dünya
- Macera
- Savaş
- Kahraman
- Profil

## Önemli ürün aileleri
- Quest Center
- Daily Quests
- Weekly Quests
- Quest Chain
- Equipment
- Inventory
- Crafting
- Lumi
- Movement Mastery
- Player Level
- Achievements
- Badges
- World Progression
- Personal Daily Adventure
- Events
- Rune Inbox
- Rune Shrine
- Rune Detail/Mastery/Slots/Event
- Shop
- Settings
- Rune Ligi
- Rune Düellosu
- Rune Dostları
- Muhafız Profili
- Daily Summary / Weekly League Result
- Onboarding / Calibration

## Canonical karakterler
### ActiHero
- Genç erkek
- Dalgalı koyu kahverengi saç
- Lacivert/siyah zırh
- Kontrollü altın detaylar
- Göğüste cyan rune/crystal enerji
- Mavi pelerin
- Heroic/premium görünüm
- Cinsiyet/yüz/siluet rastgele değişmeyecek

### Lumi
- Büyük yetişkin BEYAZ KURT
- Gerçekçi/pro fantasy wolf proportions
- Cyan/ice-blue gözler
- Beyaz/gümüş kürk
- Restrained cyan rune energy
- Navy/black/gold premium harness/collar
- Cyan crystal details
- Kedi/tilki/yavru/küçük köpek/chibi/humanoid olamaz

## Görsel dil
Premium dark fantasy + restrained sci-fi/rune technology.
- Koyu lacivert
- Siyah taş/metal
- Cyan/ice-blue rune ışığı
- Kontrollü altın
- Magical crystal/glass
- Cinematic lighting
- 3D/2.5D depth
- Yüksek okunabilirlik
- Generic fantasy template veya flat Material replacement yok

## Clean-base mimarisi
Final uygulama:
`approved original art -> clean premium base PNG -> Flutter runtime text/localization/state -> transparent hotspots`

PNG'nin sahip olduğu şeyler:
- ortam
- kompozisyon
- frame/panel/button body geometry
- permanent iconography
- character art
- atmosfer
- boş runtime yüzeyleri

PNG'nin sahip OLMAMASI gereken mutable state:
- oyuncu adı
- level/XP
- Gold/Crystal/Rune miktarları
- item quantity
- timers
- percentages
- HP/energy
- progress fill
- selected/equipped/current
- owned/unowned
- claimed/purchased
- notification/unread
- localizable button/title labels

Removed alanlara `0`, `--`, `N/A`, lorem, fake rune text, black patch veya crude blur konmaz.

## Source preserving edit kuralı
Clean-base görsel yeniden tasarım değildir.
- 1 original approved source = 1 clean-base output
- previous AI output donor olamaz
- başka ekran donor olamaz
- composition/camera/panel geometry korunur
- source varsa memory'den reconstruct edilmez

## Localization
Runtime hedef dilleri içinde konuşulan/üretilenler:
- Türkçe
- İngilizce
- Almanca
- İspanyolca
- Portekizce
- Brezilya Portekizcesi
- Bahasa Indonesia
- Çince
- Japonca
- Bazı clean-base kurallarında Fransızca da hedef listesinde

Store listing language ile in-game localization ayrı karardır. App Store için bir aşamada global tek İngilizce listing daha pratik görüşü öne çıktı.

## Kalibrasyon
APK testinde kalibrasyonun kullanıcıyı kilitlememesi gerektiği görüldü. `Şimdilik geç`/skip yolu çalışmalı. Calibration gameplay için gerekli değilse onboarding'i block etmemeli.

## GitHub çalışma anlayışı
- Repo otorite
- Research/readback first
- Guess yok
- Çalışan route/state/engine korunacak
- Görsel entegrasyonu mevcut logic'i ezmeyecek
- Büyük değişiklikleri kontrollü branch'te yap
- Test kanıtı olmadan PASS deme
