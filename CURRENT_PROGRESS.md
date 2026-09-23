# ActiRune Current Progress

Updated: 2026-09-23 (Europe/Istanbul)
Branch: `integration/artwork-interactions-20260921`

## Last fully green Direct Validation
- Run: 233
- Checked commit: `84ffeabc09b4337c1d21208932f4421594430d04`
- Result: SUCCESS
- Scope: Push-up / Şınav deterministic detector + regression coverage, together with the complete previously verified Phase-1 UI/gameplay suite.
- Formatting: PASS.
- Analyzer: PASS, 0 issues.
- Focused interaction suite: PASS.
- Full Flutter suite: PASS.
- Diff hygiene: PASS.
- Temporary Push-up stage workflow was removed after validation; cleanup-only commit does not alter validated runtime/test behavior.

## Newly completed verified system
- System: Push-up / Şınav movement verification
- Runtime: `lib/features/pose/detector/push_up_detector.dart`
- Regression test: `test/push_up_detector_test.dart`
- Coverage includes full rep, shallow rep rejection, body-line invalidation, low-confidence freeze, missing-landmark ghost-rep prevention, return-to-top requirement, cooldown and valid-start requirement.
- Thresholds are deliberately configurable until labelled-video and physical-device ML Kit validation are complete; the unit tests verify deterministic state-machine behavior, not clinical/biomechanical correctness.

## Previously verified movement systems
- Squat: detector + regression tests green in the full suite.
- Lunge: VERIFIED by Direct Validation Run 232 successful re-run.

## Previously verified product/UI systems
- Mağaza / Shop Revision: VERIFIED by Direct Validation Run 228 successful re-run.
- Lumi: VERIFIED by Direct Validation Run 224.
- Crafting / Rün Dövme: VERIFIED by Direct Validation Run 222 successful re-run.
- Pro Form Koçu / Long-Term Form Analytics: VERIFIED by Direct Validation Run 221 successful re-run.
- Kişisel Günlük Macera / Personal Daily Adventure: VERIFIED by Direct Validation Run 220 successful re-run.
- Pro / Paywall: VERIFIED by Direct Validation Run 219 successful re-run.
- Profile -> Achievements / Rozetler: VERIFIED by Direct Validation Run 218.

## Active work
- Phase-1 Core Solo four-movement infrastructure.
- Squat: green.
- Lunge: green.
- Push-up: green.
- Next exact functional gap: Plank duration/form verifier.
- After Plank: typed movement-verification router into BattleSession/Combat boundary without UI fabricating movement events.

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
- Push-up movement verification

## Phase-1 product authority boundary
- Master Product Bible Phase 1 requires Core Solo: Home, Adventure, Squat/Lunge/Push-up/Plank infrastructure, Camera Prep, Live Battle, Form Coach, quests, Player/Hero/Lumi/Mastery, loot/crafting, Recovery/Difficulty, Pro base layer and Rewarded Ads.
- Phase 2 social features such as two-person Live Boss Raid and Ghost Duel must not be pulled forward merely because a placeholder social screen exists.
- Do not invent gameplay effects, inventory mutations, engine state, rewards, routes, entitlement behavior, purchase behavior, pricing, trial state, personalization output, recovery state, analytics output or ad behavior where product/engine authority is absent.
- Approved canonical artwork must be used as-is; do not generate replacement art in runtime implementation.
- Meaningful gameplay progress remains movement-backed under the Master Product Bible.
- Pose thresholds stay configuration until labelled-video corpus and real-device ML Kit validation are completed.

## Next exact actions
1. Implement Plank form/hold verifier using shoulder-hip-ankle alignment, confidence gating and configurable hold duration.
2. Add tests for valid hold, insufficient duration, body-line break, confidence loss, missing landmarks and duplicate-event prevention.
3. Require formatter + analyzer + movement tests + full Flutter suite + diff hygiene before marking Plank green.
4. Add typed movement-verification router so Squat/Lunge/Push-up/Plank produce a common verified movement event for BattleSession.
5. Prove exactly one accepted verified movement produces exactly one battle/combat action.
6. Re-audit Dynamic Difficulty, Recovery/Safety, loot/crafting ownership and Rewarded Ads ownership.
7. Physical-device ML Kit corpus validation remains a mandatory release gate and cannot be replaced by synthetic unit tests.

## Permanent working rule
After each meaningful green batch, update this file with latest green run/commit, completed scope, blockers and exact next step. This file is the GitHub recovery checkpoint when a chat/tab ends.
