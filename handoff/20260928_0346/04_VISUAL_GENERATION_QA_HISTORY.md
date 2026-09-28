# 04 — VISUAL GENERATION / QA HISTORY

## 60-screen clean-base objective
Approved/current ActiRune source visuals were converted into runtime-ready clean-base art while preserving premium composition and removing localizable/runtime state.

## First full QA result
Initial visible PASS set:
`22–34, 36–41, 43–44` = 21 screens.

Initial regenerate set:
`01–21, 35, 42, 45–60` = 39 screens.

### Initial failure families
- 01–10: wrong templates/map collapse, wrong hero identity, wrong screen semantics, bottom-nav contamination.
- 11–20: repeated equipment/inventory template behavior, Lumi drifting toward cat/fox.
- 21: selected/active inventory category baked in.
- 35: selected achievement filter baked in.
- 42 / 45 / 50: Lumi identity/state issues.
- 46: Effects Shop became potion-like wrong semantics.
- 47: Runes/Event wrong.
- 48: Star Gate wrong.
- 49: sale/discount state baked in.
- 51–60: generic Shop-family collapse instead of required Rune Shrine/Rune system screens.

## Source recovery and strict regeneration
A dedicated original-source export was created to stop generation from drifting or reusing failed AI outputs.

Package:
`ACTIRUNE_CLEAN_BASE_ORIGINAL_SOURCES_66.zip`

SHA-256:
`D1E3EC92B8E853974DF79CD176AF407BA25B48F49D6D2ADB0908B9E827CD23C0`

GitHub source-export operation:
- branch: `codex/export-clean-base-sources-66-20260927`
- commit: `7e916bdb3ee94a2caa3337dc669c52afdd36a269`
- successful Action run: `36313220845`
- artifact id: `10929692207`
- artifact name: `ACTIRUNE_CLEAN_BASE_ORIGINAL_SOURCES_66`

Strict rule:
- open exact original PNG
- inspect independently
- forget previous generated failure
- preserve only current source composition
- clean mutable/localizable state only
- generate one independent output
- never mix donors

## Late 5-image surgical correction
A focused late group included:
1. Movement Mastery
2. Inventory / Resource Archive
3. Progression / Reward Path
4. Live Battle
5. Lumi Companion / Evolution

Late review outcome:
- Movement Mastery: PASS
- Inventory: PASS
- Progression: PASS after chest-state neutralization
- Live Battle: PASS
- Lumi: PASS after center-card and evolution-state neutralization

### Lumi final choice
User sent three Lumi-related variants and asked whether they were all the same screen. Decision:
- they were treated as variants of the same screen
- only the FIRST image was selected as the final one
- second and third variants were not selected for final set

Lumi acceptance conditions:
- large adult white wolf remains canonical
- five portrait cards use equal UI treatment
- center white Lumi does not look selected/equipped
- three evolution forms use equal frame/pedestal/background treatment
- right cyan form may contain intrinsic cyan magic, but UI must not read as active/unlocked/current
- no baked runtime text/values

## Final visual-stage decision
The visual production stage was closed with the final-selected 60 screen set treated as PASS.

Important nuance discovered later:
**visual PASS does not mean uploaded storage filename equals canonical screen number.**

The GitHub final-assets folder contains 60 good/final-selected assets, but storage names came from accepted-output packaging. During Flutter integration, storage 01 and storage 05 were visually checked and did not correspond to canonical Home and Adventure.

Therefore:
- do NOT regenerate the 60 set
- do NOT trust storage prefix as canonical identity
- perform canonical remapping before route integration

## Previous handoff references
`ACTIRUNE_MASTER_HANDOFF_20260927.zip`
- 28 files
- SHA-256 `B6677C8D0AFD27B7A59B7AE257DE2B37A60E4E287A0FEF2E9AA2BF03B9D8D113`

Earlier full-tab handoff:
`ACTIRUNE_MASTER_HANDOFF_FULL_TAB_20260914.zip`
- SHA-256 `772D1F7FE5712246FD6DD01A17FC069EE1B78611BABBFEB665696153E0580DDE`

User download grouping for final-selected visuals:
- `ACTIRUNE_PASS_01_10.zip`
- `ACTIRUNE_PASS_11_20.zip`
- `ACTIRUNE_PASS_21_30.zip`
- `ACTIRUNE_PASS_31_40.zip`
- `ACTIRUNE_PASS_41_50.zip`
- `ACTIRUNE_PASS_51_60.zip`

These grouping names should NOT be used as canonical screen identity without remapping.
