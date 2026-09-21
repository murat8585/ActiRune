# ActiRune Visual Authority Transfer Report — 2026-09-21

## Outcome

The canonical visual-authority payload and its metadata are prepared on `visual-authority/20260921-current-all`. The dirty working tree at `D:\ActiRuneV2_Work` was not used for edits; only a separate clean transfer worktree was changed.

## Source and integrity readback

- Core source: `ACTIRUNE_VISUAL_AUTHORITY_CODEX_READY_20260919.zip`; actual SHA-256: `2a5b0892743db91cf9eab28f9277dfa8afe3f2a014fe665587aeea79436a0568`.
- The expected core archive SHA-256 recorded both in the task text and the remote transfer manifest is `2a5b0892743db91cf9eab28f9277dfa8afe3f2a014fe665587aeea79436a056`, which is 63 hex characters, not a valid SHA-256. The actual 64-character digest shares that full 63-character prefix and ends in `8`. This is recorded as one provenance/authority-contract conflict; it is not silently represented as an exact archive-hash match.
- All 115 selected core PNGs were individually checked against their rows in the ZIP's embedded 370-record visual master manifest: 115 matched, 0 missing rows, 0 per-image mismatches.
- Social source file: local `sıralama.zip`; actual SHA-256: `af82bd348f0801b356d25273c72de3f6f3b164eb6a55363239dc92bf7392a1eb`. Its digest exactly matches the remote manifest's expected social archive digest under logical source name `ACTIRUNE_SOCIAL_APPROVED_REFERENCES_20260921.zip`. All 7 images also match the remote social per-file manifest.
- Images were extracted byte-for-byte. No resize, recompression, conversion, optimization, regeneration, or pixel edits were performed.

## Verified set and size

- EXISTING_APPROVED_VISUALS=115
- SOCIAL_APPROVED_VISUALS=7
- TOTAL_APPROVED_VISUALS=122
- UNIQUE_SHA256_VISUALS=122
- EXACT_DUPLICATES=0
- MISSING_EXPECTED_FILES=0
- FILE_HASH_MISMATCHES=0
- AUTHORITY_CONFLICTS=1 (malformed core archive checksum contract)
- VISUAL_AUTHORITY_CONFLICTS=0 in checked canonical root/social references
- KNOWN_NONFINAL_COMPARISON_RISKS=3 (camera-preparation references explicitly marked not final)
- PROVENANCE_CONTRACT_CONFLICTS=1 (malformed 63-character core archive checksum above)
- MAX_FILE_SIZE_BYTES=10813523 (`VIS_0078__GREEN_VALLEY_HOME_BACKGROUND.png`)
- FILES_OVER_50_MB=0 (threshold: 50 MiB)
- FILES_OVER_100_MB=0 (threshold: 100 MiB)
- TOTAL_VISUAL_BYTES=311955238

All 122 content hashes are unique, so no duplicate aliases were needed. All files are below GitHub's 100 MiB hard-file limit; Git LFS is not needed.

## Authority-status preservation

The archive's status values are retained in the manifest rather than flattening reference-only material into final authority:

- `CANONICAL_FINAL`: 14
- `CORE_LOCKED_ANCHOR`: 4
- `NEAR_FINAL_REFERENCE`: 2
- `CAMERA_PREP_REFERENCE_NOT_FINAL`: 3
- `CURRENT_PATCH_REFERENCE`: 10
- `CURRENT_STRONG_REFERENCE`: 44
- `CURRENT_SUPERSEDED_BY_NEWER_FINAL`: 2
- `LEGACY_FUNCTION_REFERENCE_ONLY`: 28
- `REUSABLE_GAME_ASSET`: 8

Legacy, superseded, camera-preparation, near-final, and reusable items remain explicitly labeled; they are not promoted to canonical finals.

## Representative route and visual-consistency audit

The source route map and representative images were checked for Ana Dünya, Macera, Savaş, Kahraman, Profil, and all seven social references.

| Route | Visual ID(s) | Preserved authority |
|---|---:|---|
| Ana Dünya | 354 | CORE_LOCKED_ANCHOR |
| Macera | 231 | CORE_LOCKED_ANCHOR |
| Savaş | 166 / 168 | CURRENT_PATCH_REFERENCE / CORE_LOCKED_ANCHOR |
| Kahraman | 171 | CANONICAL_FINAL |
| Profil | 222 | CANONICAL_FINAL |

All six listed core route visuals are present and are 941×1672. The checked core and social references retain the same five bottom-navigation labels—Ana Dünya, Macera, Savaş, Kahraman, Profil—with no sixth Social tab. Social/Profile-family references highlight Profil where navigation is shown. The approved Rune Düellosu reference also shows the five-tab navigation; the task allows a separately documented focused-duel variant to omit it.

No such conflict was observed in the checked canonical root/social representatives: the five-tab navigation and root-screen parentage are consistent, and Lumi appears as the white wolf companion. The source archive also contains three explicitly non-final camera-preparation comparisons that must not be promoted:

- `VIS_0167__CURRENT_CAMERA_PREP_NEW_WOLF_WRONG_NAV.png` is labeled `WRONG_NAV` by its filename; the screenshot shows the five tabs with Savaş active. Keep it as a camera-preparation reference only.
- `VIS_0230__CAMERA_PREP_OLD_NO_NAV_OLD_LUMI_REFERENCE.png` and `VIS_0355__CAMERA_PREP_NO_NAV_OLD_LUMI_REFERENCE.png` show the older no-bottom-navigation / old-Lumi variant. Keep both as comparison-only references.

All three retain the source authority status `CAMERA_PREP_REFERENCE_NOT_FINAL`; they are recorded as contained non-final risks, not canonical visual-authority conflicts. This was a bounded consistency check, not a redesign or pixel-correction pass.

## Future implementation constraint

Preserve the approved composition as the visible UI and implement future interaction as:

`3D/2.5D artwork shell → dynamic data/text → transparent artwork hotspot → route/state/engine callback`

Do not place duplicate visible Flutter cards, buttons, or menus over approved artwork. Do not begin implementation as part of this transfer.

## Paths

- Manifest: `visual_authority/20260921/VISUAL_AUTHORITY_MANIFEST_20260921.csv`
- SHA-256 list: `visual_authority/20260921/VISUAL_AUTHORITY_SHA256SUMS_20260921.txt`
- Social route map: `visual_authority/20260921/SOCIAL_SCREEN_ROUTE_MAP_20260921.tsv`
- This report: `visual_authority/20260921/VISUAL_AUTHORITY_TRANSFER_REPORT_20260921.md`

The transfer commit and publication state are verified from branch history and remote readback after commit; no self-referential commit hash is embedded in this report.
