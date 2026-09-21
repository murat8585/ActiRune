# ActiRune P1 Selected Visual Candidates — 2026-09-21

## Package and authority status

This directory contains the seven selected P1 candidate PNGs from `ACTIRUNE_P1_SELECTED_FINAL_VISUALS_20260921.zip`, along with the ZIP-provided `P1_SELECTED_VISUALS_MANIFEST_20260921.tsv` and `README.md`. The ZIP SHA-256 is `82adb6972a50c3771eba30803b4a0e35deb989c00325fea68740d08c7472bb0f`.

All seven entries in `P1_FINAL_SELECTION_MANIFEST_20260921.tsv` have the exact status `SELECTED_P1_VISUAL_AUTHORITY_CANDIDATE`. Selection and transfer do not promote these files to canonical production authority and do not prove product readiness, routes, hotspots, state binding, engine behavior, or runtime correctness. The historical source visuals remain unchanged.

The PNGs were extracted without image editing and their SHA-256 values and byte lengths match the supplied selection manifest. The two ZIP-provided text files are retained as supplied.

## Shared locked rules

- The permanent root navigation is exactly: Ana Dünya / Macera / Savaş / Kahraman / Profil. Keep the required family active; do not add a sixth tab.
- Where shown, ActiHero remains a young male with wavy dark-brown hair, navy/black armor, restrained gold details, a cyan rune/crystal, and a blue cloak.
- Where shown, Lumi remains a large white wolf with cyan eyes, icy rune glow, and a blue/gold harness or pendant. Never use kitten/cat/fox Lumi.
- Never use Atlas, Mana, Destansı, or legacy UI as production content or visual authority. Use current product terminology, including Epik where that rarity is intended.
- Screen values and states listed below are dynamic data regions, not fixed sample values.

## Selected screens

### 1. Profile / Rune Ligi

- File: `01_P1_PROFILE_FINAL_REVISION.png`
- Visual ID / screen ID: `VIS_0222` / `rune-league`
- Parent: `profile`
- Baseline source: `visual_authority/20260921/current/01_CANONICAL_FINAL/VIS_0222__P1_PROFILE_FINAL.png` — canonical Profile shell; this selected revision remains a candidate.
- Required meaning: revise the canonical Profile with a visible Rune Ligi entry. Preserve Arkadaşlar and Tümünü Gör as the entry to Rune Dostları; keep Profil active.
- Canonical terms: Rune Ligi, Rune Dostları, Arkadaşlar, Tümünü Gör, Profil.
- Bottom navigation: visible; Profil active.
- Dynamic regions: player identity/avatar/title; Player Level summary; Rune Ligi tier/rank/points; Rune Dostları preview/count.

### 2. Equipment / Ekipman

- File: `02_P1_EQUIPMENT_FINAL.png`
- Visual ID / screen ID: `VIS_0175` / `equipment`
- Parent: `hero`
- Baseline source: `visual_authority/20260921/current/05_CURRENT_PATCH_REFERENCES/VIS_0175__CURRENT_EQUIPMENT_PATCH_BASE.png` — NONFINAL_PATCH / CURRENT_PATCH_REFERENCE; this selected revision remains a candidate.
- Required meaning: Kahraman → Ekipman, equipment slots, Ekipman Envanteri, and Ön Ayarlar. Keep the screen focused on equipped gear and loadouts.
- Canonical terms: Ekipman, Silah, Zırh, Rün, Ekipman Envanteri, Ön Ayarlar.
- Bottom navigation: visible; Kahraman active.
- Dynamic regions: equipped slots/items; item stats and states; inventory counts; preset selection/state.

### 3. Inventory / Envanter

- File: `03_P1_INVENTORY_FINAL.png`
- Visual ID / screen ID: `VIS_0176` / `inventory`
- Parent: `hero`
- Baseline source: `visual_authority/20260921/current/05_CURRENT_PATCH_REFERENCES/VIS_0176__CURRENT_INVENTORY_PATCH_BASE.png` — NONFINAL_PATCH / CURRENT_PATCH_REFERENCE; this selected revision remains a candidate.
- Required meaning: categories Ekipman, Runeler, İksirler, Malzemeler, with search, filter, sort, and view controls. Do not use Mana or Destansı; use supported canonical terms such as Epik.
- Bottom navigation: visible; Kahraman active.
- Dynamic regions: category counts; item/material quantities; rarity; selected-item details; search query; filter state; sort order; view mode.

### 4. Crafting / Üretim

- File: `04_P1_CRAFTING_FINAL.png`
- Visual ID / screen ID: `VIS_0177` / `crafting`
- Parent: `hero`
- Baseline source: `visual_authority/20260921/current/05_CURRENT_PATCH_REFERENCES/VIS_0177__CURRENT_CRAFTING_PATCH_BASE.png` — NONFINAL_PATCH / CURRENT_PATCH_REFERENCE; this selected revision remains a candidate.
- Required meaning: Silahlar, Zırhlar, Runeler; a recipe list, required materials, and a clear ÜRET action. Do not use Mana and do not add a sixth bottom-navigation tab.
- Bottom navigation: visible; Kahraman active.
- Dynamic regions: recipe selection; required/owned material counts; Gold cost; resulting item; craft eligibility and result state.

### 5. Movement Mastery / Hareket Ustalığı

- File: `05_P1_MOVEMENT_MASTERY_FINAL.png`
- Visual ID / screen ID: `VIS_0356` / `mastery`
- Parent: `hero`
- Baseline source: `visual_authority/20260921/current/03_NEAR_FINAL_REFERENCES/VIS_0356__P1_MOVEMENT_MASTERY_NEAR_FINAL.png` — NEAR_FINAL_REFERENCE; this selected revision remains a candidate.
- Required meaning: four independent mastery states: Squat = temel saldırı; Lunge = dodge/çeviklik; Push-up = ağır saldırı/zırh kırma; Plank = savunma/kalkan. Mastery is earned through verified real movement.
- Bottom navigation: visible; Kahraman active.
- Dynamic regions: separate level/XP/progress for Squat, Lunge, Push-up, and Plank; verified counts/form; movement-specific unlocks.

### 6. Player Level / Oyuncu Seviyesi

- File: `06_P1_PLAYER_LEVEL_FINAL.png`
- Visual ID / screen ID: `VIS_0357` / `player-level`
- Parent: `profile`
- Baseline source: `visual_authority/20260921/current/03_NEAR_FINAL_REFERENCES/VIS_0357__P1_PLAYER_LEVEL_MILESTONES_NEAR_FINAL.png` — NEAR_FINAL_REFERENCE; this selected revision remains a candidate.
- Required meaning: show Player Level only as the account-level progression. Keep it separate from Hero Level, Lumi Bond/Level, and Movement Mastery; show milestones and their rewards.
- Bottom navigation: visible; Profil active.
- Dynamic regions: Player Level and account XP; next milestone; milestone unlock/claim state; reward values.

### 7. Settings Hub / Ayarlar

- File: `07_P1_SETTINGS_HUB_FINAL.png`
- Visual ID / screen ID: `VIS_0222` shell / `settings`
- Parent: `profile/home`
- Baseline source: `visual_authority/20260921/current/01_CANONICAL_FINAL/VIS_0222__P1_PROFILE_FINAL.png` — canonical Profile-family shell. Existing legacy settings visuals are function-only references, not production visual templates; this selected revision remains a candidate.
- Required meaning: a Profile-family hub with Hesap, Bildirimler, Gizlilik, İzinler, Erişilebilirlik. Keep Profil active; child settings pages remain distinct destinations.
- Bottom navigation: visible; Profil active.
- Dynamic regions: account labels/status; notification preferences; privacy choices; permission states; accessibility preferences.

## Transfer scope

This package adds visual reference candidates and documentation only. No image generation/editing, source-code, route, hotspot, engine, test, build, or runtime changes are represented by this package. No commit or push is implied by the candidate status.
