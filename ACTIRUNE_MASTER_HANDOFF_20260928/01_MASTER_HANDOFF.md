# ACTIRUNE — A'DAN Z'YE MASTER DEVİR

## 1. Ürün vizyonu
ActiRune fiziksel hareket ile fantasy RPG ilerlemesini birleştiren mobil oyun/uygulama. Ana döngüler: günlük/haftalık görev, hareket doğrulama, savaş, ödül, seviye, equipment, inventory, crafting, Lumi companion, rune sistemi, achievements, events, shop.

## 2. Canonical karakterler
### ActiHero
Genç erkek, dalgalı koyu kahverengi saç, lacivert-siyah zırh, kontrollü altın detaylar, cyan rune/crystal enerji, mavi pelerin, profesyonel kahramansı görünüm.

### Lumi
Büyük yetişkin beyaz kurt, cyan gözler, beyaz/gümüş kürk, cyan/buz rune enerjisi, lacivert/siyah/altın harness veya collar. Kedi, tilki, yavru, chibi veya küçük köpek görünümü yasak.

## 3. Görsel stil
Premium mobile fantasy RPG; dark fantasy + restrained sci-fi; 9:16 portrait; 3D/2.5D; koyu lacivert/siyah taş-metal; cyan rune ışığı; kontrollü altın; cinematic lighting; yüksek okunabilirlik.

## 4. Clean-base mimarisi
Görsel = static premium artwork.
Flutter = runtime katmanı.
Flutter'dan gelmesi gerekenler: metinler, localization, oyuncu adı, level, XP, gold, crystals, Rune Points, timer, quest progress, progress bar, selected/equipped/owned/claimed state, notifications, cooldown, HP, energy, shop price.
Görsele runtime state gömülmez. `0`, `--`, `N/A`, lorem veya random glyph placeholder kullanılmaz.

## 5. Localization
Tek clean-base görsel üzerinden Türkçe, İngilizce, Almanca, İspanyolca, Portekizce, Brezilya PT, Bahasa Indonesia, Çince, Japonca ve diğer diller Flutter text ile desteklenecek.

## 6. Görsel üretim geçmişi
İlk büyük QA'da PASS: 22–34, 36–41, 43–44. FAIL: 01–21, 35, 42, 45–60.
Başlıca fail nedenleri: yanlış kadın Hero, aynı template tekrarları, bottom-nav contamination, Lumi'nin kedi/tilki olması, selected/active state'in görsele gömülmesi, yanlış Shop/Rune Shrine ailesi.

Regeneration grupları:
- Group 1: 01–10
- Group 2: 11–20
- Group 3: 21, 35, 42, 45, 46, 47, 48, 49, 50, 51
- Group 4: 52–60

Surgical correction yapılan 5 ekran:
1. Lumi Companion/Evolution
2. Live Battle
3. Progression/Reward Path
4. Inventory
5. Movement Mastery
Final: 5/5 PASS.

Lumi son kritik düzeltmesi: ortadaki beyaz kart selected görünüyordu; sağ evolution form active/unlocked görünüyordu. Final kriteri: 5 portrait kart eşit UI treatment, 3 evolution form eşit UI treatment. Son üç varyanttan yalnızca ilk görsel final seçildi.

## 7. Final görsel durumu
Kullanıcı 60 final clean-base ekranı PASS kabul etti. Görsel üretim safhası kapandı. Eski FAIL/rejected varyantlar sete girmeyecek.

## 8. Source export
Branch: `codex/export-clean-base-sources-66-20260927`
Commit: `7e916bdb3ee94a2caa3337dc669c52afdd36a269`
Action: `36313220845`
Artifact: `ACTIRUNE_CLEAN_BASE_ORIGINAL_SOURCES_66`
Artifact ID: `10929692207`
SHA-256: `D1E3EC92B8E853974DF79CD176AF407BA25B48F49D6D2ADB0908B9E827CD23C0`

## 9. Final 60 görsel GitHub
Branch: `codex/final-pass-60-assets-20260927`
Folder: `assets/ui/clean_base_final_60/`

Kritik sonradan bulunan problem: 60 farklı dosya bulunması canonical 01–60 sırasıyla eşleştiği anlamına gelmiyor. Görsel kontrolde `01__ORIGINAL_OUTPUT_22__PASS.png` ve `05__ORIGINAL_OUTPUT_26__PASS.png` Home/Adventure çıkmadı. Bu nedenle `FILE NUMBER != CANONICAL SCREEN NUMBER`.

## 10. Production Flutter mimarisi
Production authority: `production/closeout-20260924`.
Mevcut mimari artwork + Flutter hotspot/runtime yaklaşımını zaten kullanıyor. Önemli yapı: `ArtworkInteractionSurface`. Bu korunmalı. Çalışan route/state/backend kodu silinmemeli.

## 11. Flutter integration branch
Working branch: `codex/clean-base-flutter-integration-20260927`.
Bu dalda clean-base asset registration, pubspec asset namespace ve asset tree graft çalışmaları yapıldı.
İlk olarak 01=Home ve 05=Adventure varsayımıyla bağlandı. Görsel readback bunun yanlış olduğunu gösterince Home ve Adventure bağlantıları geri alındı.
Görülen commitler:
- `ccfe7b7f48b64dcbde5ad0903273a98f0ecc8c4c`
- `95f59781b48af34b4207d29463f1ac4999bfbb2c`
- `f6988eed1aaf8d5c4f46cf8fdce7641427e700cf`
- `c3592c4e918e1c8aa21428ebc59c44af848cdf61`
- `cfe4cc21fba79b91f80c2927b25bdac54ed5b8e9`
- `be6a868f127d4eebe57bfd68c815a461bfe269f6`
Yeni oturumda branch HEAD mutlaka yeniden okunmalı.

## 12. İlk oynanabilir zincir
Home -> Quest Center -> Daily Quests / Weekly Quests -> Adventure -> Battle Prep -> Camera Prep -> Live Battle -> Victory / Defeat.

## 13. İlk QA hedefi
Doğru hotspot, route, back davranışı, bottom nav, safe area, aspect ratio, runtime text alignment, hotspot drift, modal/scroll, localization, emulator ve Vivo.
Camera Prep, Victory ve Defeat ekranlarında bottom nav olmamalı. Live Battle HP/energy/score/cooldown/progress Flutter runtime'dan gelmeli.

## 14. Ana bottom navigation
Ana Dünya / Macera / Savaş / Kahraman / Profil.

## 15. Kesin çalışma sırası
READ -> MAP -> CHANGE -> READBACK -> TEST.
60 ekranı tek seferde körlemesine değiştirme. Dosya numarasına güvenme. Görseli görmeden route bağlama.

## 16. Tam sonraki plan
1. `codex/clean-base-flutter-integration-20260927` HEAD oku.
2. `production/closeout-20260924` ile karşılaştır.
3. `assets/ui/clean_base_final_60/` içindeki 60 PNG'nin tamamını görsel içerikten tanımla.
4. Manifest alanları: filename, visual identity, canonical screen, Flutter screen, route, confidence, status.
5. İlk playable flow için gerekli 10 gerçek PNG'yi kesin doğrula.
6. Doğrulandıktan sonra `artworkAsset` yollarını değiştir.
7. Hotspot geometry yeni image geometry ile uyuşuyor mu kontrol et.
8. İlk 10 ekran compile/smoke test.
9. Sonra 11–20, 21–30, 31–40, 41–50, 51–60.
10. Emulator QA sonrası tek doğrulanmış APK ile Vivo testi.

## 17. Kullanıcının çalışma beklentisi
Gereksiz tekrar onay isteme. Sırayla devam et. Yapılan gerçek işi kısa canlı notlarla bildir. Plana sadık kal.
