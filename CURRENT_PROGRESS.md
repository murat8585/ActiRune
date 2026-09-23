# ActiRune Current Progress

Updated: 2026-09-23 (Europe/Istanbul)
Branch: `integration/artwork-interactions-20260921`

## Last fully green Direct Validation
- Run: 235
- Checked commit: `8e4b559ac61a4997ffe037455e39630e0103da79`
- Result: SUCCESS
- Scope: typed detector `VerifiedRep` -> BattleSession/Combat routing plus all previously verified Phase-1 UI/gameplay and four-movement systems.
- Formatting: PASS.
- Analyzer: PASS, 0 issues.
- Focused interaction tests: PASS.
- Full Flutter suite: PASS.
- Diff hygiene: PASS.
- Temporary movement-router stage workflow was removed after validation in cleanup-only commit `42ce7bf42387749cb97e7687b129b59ef6cb3395`; runtime/test behavior was not changed by cleanup.

## Newly completed verified system
- System: typed verified-movement routing.
- Runtime: `lib/features/battle/verified_movement_router.dart`.
- Regression test: `test/verified_movement_router_test.dart`.
- Direct Validation now includes the movement-router regression test in the focused suite.
- Exact supported detector identities are `squat`, `lunge`, `push_up`, and `plank`, mapped to the existing `VerifiedMovementType` values.
- Unknown exercise names are rejected without BattleSession or CombatEngine mutation.
- Non-live and paused sessions are rejected by the existing BattleSession owner and do not mutate combat.
- A supported event identity is consumed at most once, preventing duplicate accepted reps and stale replay after an invalid battle phase.
- A new timestamp remains a new verified event.
- Existing `formScore` is passed to `CombatEngine.acceptVerifiedRep`; no new damage, combo, threshold, prepared-movement or balance values were introduced.
- Architecture invariant remains: one accepted `VerifiedRep` creates at most one BattleSession verified action and one CombatEngine damage event.

## Verified four-movement infrastructure
- Squat: green.
- Lunge: VERIFIED by Direct Validation Run 232 successful re-run.
- Push-up: VERIFIED by Direct Validation Run 233.
- Plank: VERIFIED by Direct Validation Run 234.
- Typed BattleSession/Combat routing: VERIFIED by Direct Validation Run 235.

## Previously verified product/UI systems
- Mağaza / Shop Revision: VERIFIED by Direct Validation Run 228 successful re-run.
- Lumi: VERIFIED by Direct Validation Run 224.
- Crafting / Rün Dövme: VERIFIED by Direct Validation Run 222 successful re-run.
- Pro Form Koçu / Long-Term Form Analytics: VERIFIED by Direct Validation Run 221 successful re-run.
- Kişisel Günlük Macera / Personal Daily Adventure: VERIFIED by Direct Validation Run 220 successful re-run.
- Pro / Paywall: VERIFIED by Direct Validation Run 219 successful re-run.
- Profile -> Achievements / Rozetler: VERIFIED by Direct Validation Run 218.

## Active work
- Phase-1 Core Solo / Dynamic Difficulty + Recovery/Safety authority and runtime gap closure.
- Product Bible marks both systems REQUIRED.
- Dynamic Difficulty inputs are Player Level, recent 7/28-day movement/task performance, form scores and movement-specific Movement Mastery, task completion/failure patterns, preferred duration/goal/user capacity, and movements the user struggles with or marks unsuitable.
- Dynamic Difficulty outputs are repetition/duration, encounter difficulty, boss phase, task density and alternative movement; direction is gradual increase when consistently easy and decrease/alternative/recovery when struggling.
- Recovery/Safety must distribute tasks using muscle-group and movement history, allow lighter alternatives/recovery routes after intense lower-body work, allow easier movement variants, and offer an alternative when the user reports pain/unsuitability without diagnosing.
- Recovery Day must count as a valuable active day without breaking streak.
- Unsafe speed or form degradation must not be rewarded for a higher score.
- Current repository audit found no dedicated Dynamic Difficulty or Recovery runtime owner by path, so implementation must begin as pure typed policy/decision contracts and deterministic owner logic rather than fabricating persistence, medical inference, thresholds or backend state.

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
- Typed VerifiedRep -> BattleSession/Combat routing

## Phase-1 product authority boundary
- Master Product Bible Phase 1 requires Core Solo: Home, Adventure, Squat/Lunge/Push-up/Plank infrastructure, Camera Prep, Live Battle, Form Coach, quests, Player/Hero/Lumi/Mastery, loot/crafting, Recovery/Difficulty, Pro base layer and Rewarded Ads.
- Do not invent gameplay effects, inventory mutations, engine state, rewards, routes, entitlement behavior, purchase behavior, pricing, trial state, personalization output, medical diagnosis, analytics output or ad behavior where product/engine authority is absent.
- Meaningful gameplay progress remains movement-backed.
- Pose thresholds stay configuration until labelled-video corpus and real-device ML Kit validation are completed.

## Next exact actions
1. Implement evidence-backed Dynamic Difficulty and Recovery/Safety typed policy owners without inventing numeric thresholds or persistence.
2. Prove recovery overrides upward difficulty pressure when explicit pain/unsuitability or recovery routing requires it.
3. Prove Recovery Day remains streak-eligible and unsafe form/speed cannot be rewarded.
4. Require formatter + analyzer + focused/full tests + diff hygiene before marking the batch green.
5. Re-audit loot/crafting ownership and Rewarded Ads ownership after Recovery/Difficulty is green.
6. Physical-device ML Kit labelled-corpus validation remains a mandatory release gate and cannot be replaced by synthetic unit tests.

## Permanent working rule
After each meaningful green batch, update this file with latest green run/commit, completed scope, blockers and exact next step. This file is the GitHub recovery checkpoint when a chat/tab ends.
