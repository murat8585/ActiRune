# 06 — FLUTTER INTEGRATION ARCHITECTURE

## Existing production architecture is useful and should be preserved
Production screens already use the pattern:

`ArtworkInteractionSurface(assetPath, sourceSize, hotspots)`

The artwork is the premium visible shell. Flutter supplies:
- interaction
- route/navigation
- state
- accessibility/semantics
- runtime overlays
- localization

This matches the clean-base design philosophy. Do not replace it with a generic Material-card redesign unless a specific technical reason is proven.

## Integration objective
Replace old/unclean artwork references with VERIFIED canonical clean-base assets while keeping working logic.

Preserve:
- routes
- state owners
- battle engine
- camera/pose integration
- system actions
- working hotspot behavior
- existing navigation contracts

Then add Flutter runtime overlays on the blank clean-base surfaces.

## First controlled integration group
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

Reason: this group covers the real playable vertical slice before touching the other 50 screens.

## Main root navigation
- Home / Ana Dünya
- Adventure / Macera
- Battle / Savaş
- Hero / Kahraman
- Profile / Profil

## Hotspot rule
Clean-base work was source-preserving, so geometry should remain close to the original source. Nevertheless, every final asset must have hotspot alignment visually rechecked after replacement.

Do not assume an old normalized Rect is correct just because the artwork looks similar.

## Runtime text/localization
Flutter should own:
- titles
- button text
- labels
- dynamic descriptions
- localized strings
- currency labels
- numeric state

Stable localization keys should be used rather than painting text into PNG.

## Runtime state ownership
Flutter/game state should own:
- player level / XP
- Gold / Crystal / Rune Points
- daily/weekly quest progress
- timers/countdowns
- battle HP/energy/cooldowns
- movement score / verification
- inventory quantities
- equipment state
- crafting affordability/availability
- Lumi bond/evolution
- achievements/badges
- shop entitlement/ownership
- Rune levels/slots/state
- event progress

## Battle integration warning
Do not reduce the game to static screens + dead hotspots.
Camera Prep -> pose/movement validation -> attack -> enemy -> result must eventually execute real behavior.

## Calibration rule
Calibration must not hard-lock onboarding while optional. The previously observed missing/ineffective `Şimdilik geç` path must remain on the functional backlog.

## Suggested integration implementation flow per screen
1. Identify correct canonical clean-base file.
2. Verify source identity and SHA/readback.
3. Update artwork reference only.
4. Run asset-exists test.
5. Compare hotspot geometry.
6. Add runtime overlay anchors where needed.
7. Verify navigation callback/state owner.
8. Analyze/test.
9. Emulator smoke for representative paths.

## Asset directory intended for runtime
`assets/ui/clean_base_final_60/`

But do not use it on the active integration branch until the directory actually exists there and contains canonically named/verified assets.
