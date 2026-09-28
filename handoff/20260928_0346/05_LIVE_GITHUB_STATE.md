# 05 — LIVE GITHUB STATE / CURRENT BRANCHES

Repository: `murat8585/ActiRune`

## Visual authority
Branch: `visual-authority/20260921-current-all`

Purpose:
- approved/current original PNG source authority
- P0/P1/current child references
- source of truth when clean-base regeneration is ever specifically required

## Production base
Branch: `production/closeout-20260924`
Known closeout authority SHA:
`95d7a83a529bf7e04ca3939a85e65bd277de4f88`

Current Flutter integration work should inherit production code from this line, not from an old/simple Flutter skeleton.

## Runtime recovery / real navigation audit
Branch: `fix/real-ui-navigation-20260925`
Audited SHA:
`242f297a9399361b70affc5588d3170063b07078`

This branch/report exposed that having a visible control or donor screen is not equivalent to a working feature.

## Final 60 asset branch
Branch:
`codex/final-pass-60-assets-20260927`

Live-verified head at this handoff:
`a30c3300eb07398056b426352dc6f3677c3270f7`

Directory exists on this branch:
`assets/ui/clean_base_final_60/`

Example current storage names:
- `01__ORIGINAL_OUTPUT_22__PASS.png`
- `02__ORIGINAL_OUTPUT_23__PASS.png`
- `03__ORIGINAL_OUTPUT_24__PASS.png`
- `04__ORIGINAL_OUTPUT_25__PASS.png`
- `05__ORIGINAL_OUTPUT_26__PASS.png`

WARNING: These storage prefixes are not canonical screen numbering.

## Active Flutter integration branch
Branch:
`codex/clean-base-flutter-integration-20260927`

Live-verified head at handoff:
`0e893b75c4669c5a467cc3419519e243277bb8ae`

Head commit message:
`Hold manifest stable`

Root `MANIFEST.json`:
`{"status":"integration-in-progress"}`

### pubspec state
Integration branch `pubspec.yaml` currently registers:
`assets/ui/clean_base_final_60/`

### Critical branch inconsistency
At handoff creation GitHub contents readback returned `Not Found` for:
`assets/ui/clean_base_final_60/`
on the integration branch.

The directory does exist on final-assets branch.

Therefore integration branch must not be treated as build/release-ready until the verified canonical asset directory is actually copied/grafted and read back there.

## Home safe state
Integration branch Home currently uses:
`visual_authority/20260921/current/02_CORE_LOCKED_ANCHORS/VIS_0354__CORE_HOME_ANCHOR.png`

Architecture:
`ArtworkInteractionSurface` + transparent `ArtworkHotspot`s.

A temporary wrong clean-base storage binding was detected and reverted.

## Adventure safe state
Integration branch Adventure currently uses:
`visual_authority/20260921/current/02_CORE_LOCKED_ANCHORS/VIS_0231__CORE_ADVENTURE_ANCHOR.png`

Temporary wrong storage binding was detected and reverted.

## Why this matters
The current safe state preserves working production behavior while canonical remapping is done. It is better to temporarily retain old approved artwork than wire a visually good but semantically wrong screen into Home/Adventure.

## GitHub operational rule
- do mapping/readback first
- keep work isolated on integration branch
- do not merge to production until asset identity + code + tests are verified
- do not delete visual-authority sources
