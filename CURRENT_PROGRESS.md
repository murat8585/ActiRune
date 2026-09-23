# ActiRune Current Progress

Updated: 2026-09-23 (Europe/Istanbul)
Branch: `integration/artwork-interactions-20260921`

## Last fully green Direct Validation
- Run: 232 (successful re-run)
- Checked commit: `883fba4b3c5f8f0f0b32d03024422284d4f80b0f`
- Result: SUCCESS
- Scope: Lunge deterministic detector/state-machine coverage plus all previously verified Phase-1 UI/gameplay shells.
- Formatting: 104 files checked, 0 changed.
- Analyzer: 0 issues.
- Focused interaction suite: 155 tests PASS.
- Full Flutter suite: 172 tests PASS.
- Diff hygiene: PASS.
- Lunge regression coverage includes left/right reps, shallow reps, low-confidence freeze, full return requirement, missing-landmark ghost-rep prevention, cooldown and locked lead-side behavior.
- Temporary Lunge formatter workflow was removed after validation; cleanup-only commit does not alter the validated runtime/test implementation.

## Newly completed verified system
- System: Lunge movement verification
- Runtime: `lib/features/pose/detector/lunge_detector.dart`
- Shared verified event: `lib/features/pose/detector/verified_rep.dart`
- Regression test: `test/lunge_detector_test.dart`
- Detector thresholds remain configurable until labelled-video and physical-device corpus validation; they are not claimed as biomechanical truth.
- No movement event is emitted without a valid bottom phase, return to standing and cooldown gate.
- Missing/low-confidence pose data cannot fabricate a rep.

## Previously verified immediately before this system
- Mağaza / Shop Revision: VERIFIED by Direct Validation Run 228 successful re-run.
- Lumi: VERIFIED by Direct Validation Run 224.
- Crafting / Rün Dövme: VERIFIED by Direct Validation Run 222 successful re-run.
- Pro Form Koçu / Long-Term Form Analytics: VERIFIED by Direct Validation Run 221 successful re-run.
- Kişisel Günlük Macera / Personal Daily Adventure: VERIFIED by Direct Validation Run 220 successful re-run.
- Pro / Paywall: VERIFIED by Direct Validation Run 219 successful re-run.
- Profile -> Achievements / Rozetler: VERIFIED by Direct Validation Run 218.

## Active work
- Phase-1 Core Solo four-movement infrastructure.
- Squat: detector + tests already present and green in full suite.
- Lunge: detector + tests now green.
- Next exact functional gap: Push-up / Şınav detector + deterministic regression coverage.
- After Push-up: Plank hold verifier, then typed detector-to-BattleSession integration boundary.

## Completed / verified major areas
- Canonical root navigation: Ana Dünya / Macera / Savaş / Kahraman / Profil
- Home, Adventure, Hero and Profile artwork shells
- Battle Prep, Camera Prep, Live Battle, Free real-time Form Coach, Victory, Defeat
- BattleFlowHost and canonical BattleScreen adapter
- Rewarded retry state 3/3 -> 2/3 -> 1/3 -> 0/3
- Events + Event Detail popup
- Daily Summary popup
- Weekly League Result popup
- Onboarding exact-art flow with false-success protection
- Hero/Profile child route batch
- Rune Shrine Result exact-art shell
- Daily Quests / Weekly Quests / Quest Chain / Rune Shrine Ready artwork included in strict validation
- World Progression
- Profile -> Achievements / Rozetler
- Pro / Paywall
- Kişisel Günlük Macera / Personal Daily Adventure
- Pro Form Koçu / Long-Term Form Analytics
- Crafting / Rün Dövme
- Lumi
- Mağaza / Shop Revision
- Squat movement verification
- Lunge movement verification

## Phase-1 product authority boundary
- Master Product Bible Phase 1 requires Core Solo: Home, Adventure, Squat/Lunge/Push-up/Plank infrastructure, Camera Prep, Live Battle, Form Coach, quests, Player/Hero/Lumi/Mastery, loot/crafting, Recovery/Difficulty, Pro base layer and Rewarded Ads.
- Phase 2 social features such as two-person Live Boss Raid and Ghost Duel must not be pulled forward merely because a placeholder social screen exists.
- Do not invent gameplay effects, inventory mutations, engine state, rewards, routes, entitlement behavior, purchase behavior, pricing, trial state, personalization output, recovery state, analytics output or ad behavior where product/engine authority is absent.
- Approved canonical artwork must be used as-is; do not generate replacement art in runtime implementation.
- Meaningful gameplay progress remains movement-backed under the Master Product Bible.
- Pose thresholds stay configuration until labelled-video corpus and real-device ML Kit validation are completed.

## Next exact actions
1. Implement Push-up / Şınav deterministic state machine using only available pose landmarks and configurable thresholds.
2. Add positive/negative tests: full rep, shallow rep, body-line failure, confidence loss, missing landmarks, return-to-start and cooldown.
3. Require formatter + analyzer + focused/full tests + diff hygiene before marking Push-up green.
4. Implement Plank duration/form verifier with dropout-safe hold reset/freeze semantics.
5. Add a typed movement-verification router so Squat/Lunge/Push-up/Plank feed BattleSession as already-verified events without UI fabricating movement.
6. Re-audit Dynamic Difficulty, Recovery/Safety, loot/crafting ownership and Rewarded Ads ownership.
7. Physical-device ML Kit corpus validation remains a mandatory release gate and cannot be replaced by synthetic unit tests.

## Permanent working rule
After each meaningful green batch, update this file with latest green run/commit, completed scope, blockers and exact next step. This file is the GitHub recovery checkpoint when a chat/tab ends.
