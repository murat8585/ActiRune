# ActiRune P0 Battle Final Visual Handoff

This directory is reserved for the four approved P0 battle visual outputs.

Expected binary files:

- `P0_BATTLE_PREP_FINAL.png`
- `P0_CAMERA_PREP_FINAL.png`
- `P0_VICTORY_FINAL.png`
- `P0_DEFEAT_FINAL_CANDIDATE.png`

The exact local-source names and SHA-256 values are recorded in `P0_BATTLE_FINAL_UPLOAD_MANIFEST_20260921.tsv`.

## Authority rules

- Preserve exact image bytes during transfer.
- Do not overwrite or delete historical VIS_0166/VIS_0167/VIS_0169/VIS_0170 references.
- Battle Prep may show the canonical five-tab root navigation with `Macera` active.
- Camera Prep, Victory and Defeat must not show bottom navigation.
- Canonical ActiHero and large white-wolf Lumi identities are required.
- Defeat uses the battle-scoped ad retry system: at most 3 successful rewarded-ad retries per eligible PvE encounter; each successful retry restarts the same encounter from its initial battle state. No ranked-PvP ad retry.

## Defeat localization note

The currently approved candidate contains one mixed-language helper line: `Checkpoint revive değildir. Savaş baştan başlar.` It is acceptable as an archived candidate but should not be promoted to final canonical production art until a later approved localized revision replaces it with Turkish-only copy. Do not silently edit pixels during upload.
