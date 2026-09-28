# 09 — OPERATING RULES / DO-NOT-DO

## User workflow preferences
- Research/readback first, then edit.
- GitHub is the operational authority.
- Repo/ZIP evidence beats guessing.
- Follow the existing plan rather than random trial-and-error.
- When user says continue, continue working instead of repeatedly asking `devam edeyim mi?`.
- During long work, give short concrete live status updates showing actual work done.
- Do not claim background work is happening when no tool/action is running.
- Do not consume conversation with giant status essays during active execution; keep progress short and useful.

## Visual rules
- Original approved source is authority.
- Previous AI-generated output is NOT a source for clean-base correction.
- Never mix source images/donors.
- One original source -> one output.
- Preserve composition, camera, character identity, panel/button geometry, premium materials and lighting.
- Remove only mutable/localizable/runtime content.
- Do not casually regenerate screens already accepted PASS.
- Final clean-base output is a full premium image, not empty/transparent scaffolding.
- A contact sheet/collage is QA-only; final assets are independent portrait screens.

## Character rules
- ActiHero canonical identity cannot randomly change.
- Lumi is a large adult white wolf. Never cat/fox/puppy/chibi/small pet.

## Flutter/runtime rules
- Preserve existing working navigation/state/backend/engine behavior.
- Artwork is a shell, not the state owner.
- Do not convert the game into 60 dead screenshots with tap boxes.
- Runtime/localization values belong in Flutter/state.
- Existing `ArtworkInteractionSurface` approach is compatible and should be reused unless proven inadequate.
- Verify hotspots after artwork replacement.

## Current asset mapping rule
ABSOLUTE:
Do not use final-assets branch filename prefixes as canonical screen number.

Already disproven:
- storage `01__ORIGINAL_OUTPUT_22__PASS.png` != canonical Home
- storage `05__ORIGINAL_OUTPUT_26__PASS.png` != canonical Adventure

Map by visual content + approved source identity.

## Repository safety
- Do not overwrite/delete original visual-authority sources.
- Do not merge integration branch into production before verification.
- Do not build/release while `pubspec` references a directory that is missing on the branch.
- Keep production base stable.
- Use dedicated branches for transitional work.

## Testing rules
- Static code audit is not emulator PASS.
- Route exists != feature works.
- Donor exists != feature works.
- Preview/unavailable dialog is not final feature completion.
- Fresh emulator evidence required after final integration.

## Build/device rules
- Do not waste builds on every tiny visual adjustment.
- Stabilize integration -> emulator -> verified APK -> Vivo.

## Current things NOT to do
- Do not restart 60-screen generation.
- Do not call current final-assets storage order canonical.
- Do not wire Home/Adventure to storage 01/05.
- Do not delete old Home/Adventure visual authority until new canonical files are verified.
- Do not ignore runtime recovery backlog just because visuals look finished.
- Do not bake selected/equipped/owned/progress values back into art.
- Do not treat store listing language as the same problem as in-game localization.
