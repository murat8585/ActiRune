# ActiRune Current Progress

Updated: 2026-09-23 (Europe/Istanbul)
Branch: `integration/artwork-interactions-20260921`

## Last fully green Direct Validation
- Run: 234
- Checked commit: `352af3ffaa25e5e8e8b6cd40f8075fa552dd6695`
- Result: SUCCESS
- Scope: Plank deterministic hold/form verifier + regression coverage, together with all previously verified Phase-1 UI/gameplay and movement systems.
- Formatting: PASS.
- Analyzer: PASS, 0 issues.
- Focused interaction suite: PASS.
- Full Flutter suite: PASS.
- Diff hygiene: PASS.
- Temporary Plank stage workflow was removed after validation; cleanup-only commit does not alter validated runtime/test behavior.

## Newly completed verified system
- System: Plank movement verification
- Runtime: `lib/features/pose/detector/plank_detector.dart`
- Regression test: `test/plank_detector_test.dart`
- Required hold duration is supplied by the authoritative task/encounter owner rather than invented inside the detector.
- Coverage includes valid continuous hold, insufficient duration, body-line reset, confidence-loss freeze, missing-landmark freeze/ghost prevention, duplicate-event prevention, new hold after form break and right-side landmark verification.
- Missing/low-confidence pose data freezes elapsed progress and does not count hidden time; observed bad form resets the current hold.
- Thresholds remain configurable until labelled-video and physical-device ML Kit validation are complete.

## Verified four-movement infrastructure
- Squat: green.
- Lunge: VERIFIED by Direct Validation Run 232 successful re-run.
- Push-up: VERIFIED by Direct Validation Run 233.
- Plank: VERIFIED by Direct Validation Run 234.

## Previously verified product/UI systems
- Mağaza / Shop Revision: VERIFIED by Direct Validation Run 228 successful re-run.
- Lumi: VERIFIED by Direct Validation Run 224.
- Crafting / Rün Dövme: VERIFIED by Direct Validation Run 222 successful re-run.
- Pro Form Koçu / Long-Term Form Analytics: VERIFIED by Direct Validation Run 221 successful re-run.
- Kişisel Günlük Macera / Personal Daily Adventure: VERIFIED by Direct Validation Run 220 successful re-run.
- Pro / Paywall: VERIFIED by Direct Validation Run 219 successful re-run.
- Profile -> Achievements / Rozetler: VERIFIED by Direct Validation Run 218.

## Active work
- Next exact functional gap: typed movement-verification routing from detector-produced `VerifiedRep` into the authoritative BattleSession/Combat boundary.
- Verified implementation authority before editing: `VerifiedRep` carries `exercise`, `at`, and `formScore`; `BattleSessionEngine.acceptVerifiedMovement` owns live/paused phase acceptance; `CombatEngine.acceptVerifiedRep` owns existing combat damage/combo semantics.
- Architecture contract remains: one `VerifiedRep` must create at most one BattleSession action and one CombatEngine damage event.
- The adapter must map only `squat`, `lunge`, `push_up`, and `plank`; unknown exercise names and invalid battle phases must be rejected without combat mutation.
- Do not change combat balance, detector thresholds, prepared-movement policy, or UI state while implementing this boundary.

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
- Squat / Lunge / Push-up / Plank deterministic movement verification

## Phase-1 product authority boundary
- Master Product Bible Phase 1 requires Core Solo: Home, Adventure, Squat/Lunge/Push-up/Plank infrastructure, Camera Prep, Live Battle, Form Coach, quests, Player/Hero/Lumi/Mastery, loot/crafting, Recovery/Difficulty, Pro base layer and Rewarded Ads.
- Do not invent gameplay effects, inventory mutations, engine state, rewards, routes, entitlement behavior, purchase behavior, pricing, trial state, personalization output, recovery state, analytics output or ad behavior where product/engine authority is absent.
- Meaningful gameplay progress remains movement-backed.
- Pose thresholds stay configuration until labelled-video corpus and real-device ML Kit validation are completed.

## Next exact actions
1. Implement the narrow typed VerifiedRep -> BattleSession/Combat adapter using only existing owners.
2. Prove the four exact movement identities map correctly, unknown names reject, paused/non-live sessions reject, and duplicate event identity cannot double-count.
3. Pass form score through to existing CombatEngine semantics without introducing new balance values.
4. Require formatter + analyzer + focused/full tests + diff hygiene before marking routing green.
5. Re-audit Dynamic Difficulty, Recovery/Safety, loot/crafting ownership and Rewarded Ads ownership.
6. Physical-device ML Kit corpus validation remains a mandatory release gate and cannot be replaced by synthetic unit tests.

## Permanent working rule
After each meaningful green batch, update this file with latest green run/commit, completed scope, blockers and exact next step. This file is the GitHub recovery checkpoint when a chat/tab ends.
