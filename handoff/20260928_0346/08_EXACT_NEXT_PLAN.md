# 08 — EXACT NEXT PLAN / CONTINUATION ORDER

## P0 — Canonicalize the 60 uploaded PASS assets

Source branch:
`codex/final-pass-60-assets-20260927`

Folder:
`assets/ui/clean_base_final_60/`

Do this before any more route replacement:
1. Read all 60 uploaded PNGs.
2. Build an internal identification contact sheet if useful; contact sheet is QA-only, never a final product asset.
3. Visually identify the real screen shown in every PNG.
4. Match each PNG against `03_CANONICAL_60_SCREEN_SOURCE_MAP.csv`.
5. Require strict one-to-one mapping:
   - 60 storage assets
   - 60 canonical screen identities
   - 0 unknown
   - 0 duplicate identity
   - 0 missing canonical screen
6. Do NOT guess from current numeric prefix or `ORIGINAL_OUTPUT_xx` text.
7. If two assets look like variants of the same canonical screen, compare against source authority and final QA decision.
8. Create canonical runtime names, e.g.:
   - `01_home.png`
   - `02_quest_center.png`
   - `03_daily_quests.png`
   - ...
   - `60_rune_event_countdown.png`
9. Generate mapping manifest containing:
   - storage filename
   - canonical output number
   - canonical screen name
   - source authority filename
   - SHA-256
   - QA status
10. Read back the map before code changes.

### P0 acceptance gate
Proceed only when:
`60 mapped / 60 canonical identities / 0 duplicate / 0 unknown / 0 missing`.

## P1 — Move verified canonical assets onto integration branch

Target branch:
`codex/clean-base-flutter-integration-20260927`

Target directory:
`assets/ui/clean_base_final_60/`

Steps:
1. Copy/graft the CANONICALLY named files.
2. Verify GitHub directory readback succeeds on integration branch.
3. Verify `pubspec.yaml` registration.
4. Read back representative assets:
   - Home
   - Live Battle
   - Lumi Evolution
   - Shop Main
   - Rune Shrine Intro
5. Keep old visual-authority source files in repo for provenance/fallback.
6. Do not merge production yet.

## P2 — Integrate first 10-screen playable chain
Exact order:
1. Home
2. Quest Center
3. Daily Quests
4. Weekly Quests
5. Adventure
6. Battle Prep
7. Camera Prep
8. Live Battle
9. Victory
10. Defeat

For each screen:
- replace artwork path only after mapping verification
- preserve current route/state/engine logic
- verify source size/aspect behavior
- recheck every hotspot coordinate against final art
- add Flutter runtime/localized text only where needed
- do not paint text back into PNG
- do not replace real functionality with preview dialogs

## P3 — Static validation
Run/verify:
- asset manifest validator
- `flutter pub get`
- format
- `flutter analyze`
- relevant tests
- route smoke tests
- no missing assets
- no stale asset paths
- no duplicate canonical asset IDs

## P4 — Emulator smoke test
At minimum:
- cold launch
- Home loads final canonical art
- Quest Center route
- Daily route
- Weekly route
- back behavior
- Adventure route
- battle-entry boundary
- Battle Prep
- Camera Prep
- permission/readiness path
- camera/pose init
- Live Battle
- Victory/Defeat route
- root bottom navigation
- no crash
- no visual scale/safe-area break
- no hotspot drift

Static source readback alone is not enough.

## P5 — Integrate remaining 50 screens in controlled families
Suggested groups:
- 11–20: Equipment / Inventory / Crafting / Lumi / Movement / Events / Inbox
- 21–30: Inventory / Crafting / Lumi / Movement variants
- 31–40: Mastery / Hero / Progression / Badges / World / Rune Shrine Ready
- 41–50: Shop family
- 51–60: Profile Customization + Rune Shrine/Rune System

After every group:
- GitHub readback
- asset existence
- route/state audit
- analyze/test
- no regression in previous groups

## P6 — Runtime/state recovery
Use the 492-control audit as backlog evidence.
Prioritize:
- core routes
- movement verification
- battle engine connection
- state ownership
- reachable surfaces
before cosmetic secondary behavior.

## P7 — Localization
Start with stable runtime keys and at least English + Turkish, then extend to German/Spanish/Portuguese/Japanese/Chinese and other desired locales.

Check long strings and CJK layouts on real screen geometry.

## P8 — Calibration fix
Ensure calibration does not trap users while optional:
- functional skip-for-now path
- no mandatory loop before usable app entry unless product requirement changes explicitly

## P9 — APK/device
Only after integration is stable:
1. verified emulator build
2. emulator smoke
3. create one verified Android APK
4. install/test on Vivo
5. record actual issues
6. fix from evidence

Avoid creating a fresh APK after every minor UI change.

## Definition of done for the current integration phase
- 60/60 canonical mapping verified
- 60 canonical assets actually present on production-based integration branch
- intended screens use intended artwork
- runtime text/state remains Flutter-owned
- core Home->Adventure->Battle->Result loop navigates correctly
- camera/movement path is not merely decorative
- analyze/tests pass
- fresh emulator smoke passes
- then physical-device validation
