# ACTIRUNE MASTER HANDOFF — 2026-09-28 03:46 +03:00

Bu klasör ActiRune projesinin A'dan Z'ye operasyonel devir paketidir. Amaç yeni bir sohbet/Codex oturumunun geçmişi tekrar keşfetmeden, yanlış işleri tekrarlamadan ve mevcut GitHub otoritesini bozmadan doğrudan kaldığımız yerden devam etmesidir.

## En önemli güncel gerçek

- 60 final-selected clean-base görsel üretildi ve görsel QA tarafında PASS kabul edildi.
- Kullanıcı 60 görseli 6 ayrı ZIP halinde indirdi.
- 60 final-selected PNG GitHub'da `codex/final-pass-60-assets-20260927` branch'inde `assets/ui/clean_base_final_60/` altında bulunuyor.
- Ancak Flutter entegrasyonu sırasında kritik bir eşleme sorunu bulundu: GitHub'daki storage dosya prefix'leri canonical 01–60 ekran numarası değil.
- Örnek: `01__ORIGINAL_OUTPUT_22__PASS.png` Home değil; `05__ORIGINAL_OUTPUT_26__PASS.png` Adventure değil.
- Bu nedenle geçici yanlış Home/Adventure bağlamaları geri alındı.
- Şu an görsel üretim yeniden yapılmayacak. İlk görev 60 uploaded PASS asset'i gerçek ekran içeriklerine göre canonical 01–60 listesine birebir eşlemek.

## Canlı GitHub durumu
Repository: `murat8585/ActiRune`

- Visual authority: `visual-authority/20260921-current-all`
- Production base: `production/closeout-20260924`
- Known production closeout SHA: `95d7a83a529bf7e04ca3939a85e65bd277de4f88`
- Runtime recovery/audit branch: `fix/real-ui-navigation-20260925`
- Audited SHA: `242f297a9399361b70affc5588d3170063b07078`
- Final 60 asset branch: `codex/final-pass-60-assets-20260927`
- Live head at handoff: `a30c3300eb07398056b426352dc6f3677c3270f7`
- Active integration branch: `codex/clean-base-flutter-integration-20260927`
- Live head at handoff: `0e893b75c4669c5a467cc3419519e243277bb8ae`
- Integration root manifest: `{"status":"integration-in-progress"}`

## Çok önemli entegrasyon branch uyarısı
`pubspec.yaml` integration branch'inde `assets/ui/clean_base_final_60/` dizinini register ediyor. Fakat handoff oluşturulurken GitHub contents API ile bu dizin integration branch'inde kontrol edildi ve `Not Found` döndü. Dizin final-assets branch'inde mevcut.

Yani integration branch şu haliyle release/build otoritesi olarak kullanılmamalı. Önce canonical asset mapping tamamlanmalı, doğru klasör integration branch'e taşınmalı ve readback yapılmalı.

## Home ve Adventure güvenli state
Yanlış storage asset bağlamaları geri alındı.

Home halen:
`visual_authority/20260921/current/02_CORE_LOCKED_ANCHORS/VIS_0354__CORE_HOME_ANCHOR.png`

Adventure halen:
`visual_authority/20260921/current/02_CORE_LOCKED_ANCHORS/VIS_0231__CORE_ADVENTURE_ANCHOR.png`

Bu bilinçli olarak güvenli geçiş state'idir.

## Paket içeriği
- Ürün vizyonu ve çekirdek oyun döngüsü
- Canonical ActiHero/Lumi kilitleri
- Görsel dil / clean-base mimarisi
- Canonical 60 ekran source-map
- Visual generation ve QA geçmişi
- GitHub branch/commit ve paket/hash referansları
- Flutter entegrasyon mimarisi
- Runtime/route audit bağlamı
- Build/emulator validation geçmişi
- Kesin sonraki iş planı
- Riskler ve yapılmaması gerekenler
- Yeni sohbet bootstrap promptu
- Machine-readable current state

## Temel otorite sırası
1. Kullanıcının en yeni açık talimatı
2. Live GitHub readback
3. Bu handoff içindeki current-state ve next-plan belgeleri
4. Product Bible / locked decisions / 20260921 visual authority
5. Approved original visual source PNG
6. Uyumlu production implementation/donor code
7. Historical docs

## Bu paketin amacı
Bu ZIP'in ardından yapılacak ilk iş yeni ekran çizmek değil, canonical asset mapping + Flutter integration işini tamamlamaktır.
