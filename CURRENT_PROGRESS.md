# ActiRune Current Progress

Updated: 2026-09-23 (Europe/Istanbul)
Branch: `integration/artwork-interactions-20260921`

## Last fully green Direct Validation
- Run: 236
- Checked commit: `fafefde4bc6df54bc8b534a4d88a9098241665cf`
- Result: SUCCESS
- Scope: REQUIRED Dynamic Difficulty directional policy + Recovery/Safety policy contracts, together with all previously verified Phase-1 UI/gameplay and movement systems.
- Formatting: PASS.
- Analyzer: PASS, 0 issues.
- Focused stage adaptation/safety tests: PASS.
- Full Flutter suite: PASS in stage and Direct Validation.
- Diff hygiene: PASS.
- Temporary adaptation/safety stage workflow was removed after validation in cleanup-only commit `a2b6a38b7077cfa62ce205acdc62fc51c3e81a09`; runtime/test behavior was not changed by cleanup.

## Newly completed verified systems
### Dynamic Difficulty
- Runtime: `lib/features/adaptation/dynamic_difficulty_engine.dart`.
- Regression test: `test/dynamic_difficulty_engine_test.dart`.
- No product-unauthorized numeric thresholds, weights or persistence were invented.
- The owner receives a caller-classified performance trend plus explicit movement-unsuitable/recovery signals.
- Consistently comfortable performance produces gradual upward direction only.
- Balanced performance holds.
- Struggling performance decreases pressure and offers an alternative movement.
- A movement marked unsuitable holds escalation and requests an alternative rather than manufacturing a medical conclusion.
- Recovery/Safety recommendation overrides upward pressure and decreases repetition/duration, encounter, boss-phase and task-density pressure.

### Recovery / Safety
- Runtime: `lib/features/adaptation/recovery_safety_engine.dart`.
- Regression test: `test/recovery_safety_engine_test.dart`.
- Two consecutive intense lower-body days trigger the Bible-authorized Recovery Day route.
- User-reported pain/unsuitability or a movement marked unsuitable requests a lighter alternative; no diagnosis is made.
- Recovery Day is streak-eligible as required by product authority.
- Unsafe speed or degraded form makes performance reward ineligible, preventing score incentives for unsafe behavior.
- Recovery and alternative routing are policy outputs only; no medical inference, backend state or task persistence was fabricated.

## Verified movement infrastructure
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
- Phase-1 Core Solo / Loot-Crafting ownership + Rewarded Ads ownership audit.
- The Crafting screen is already exact-art and callback-only; it intentionally does not mutate inventory or spend currency without an authoritative owner.
- Rewarded retry state exists inside the battle session flow, but real ad-service ownership and Rune Shrine daily/cooldown policy must be separated from UI callbacks and verified before adding behavior.
- Product authority: Rune Shrine rewarded ad = once per 4 hours, max 3/day; PvE defeat = at most once per battle for a 25–30% HP/checkpoint continuation; no Ranked PvP revive ad; no ads during Camera/Live Battle/Form Coach.
- Do not invent ad SDK success, inventory grant, loot tables, recipe costs, SKU state or server persistence.

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
- Dynamic Difficulty directional policy
- Recovery/Safety policy

## Phase-1 product authority boundary
- Master Product Bible Phase 1 requires Core Solo: Home, Adventure, Squat/Lunge/Push-up/Plank infrastructure, Camera Prep, Live Battle, Form Coach, quests, Player/Hero/Lumi/Mastery, loot/crafting, Recovery/Difficulty, Pro base layer and Rewarded Ads.
- Do not invent gameplay effects, inventory mutations, engine state, rewards, routes, entitlement behavior, purchase behavior, pricing, trial state, personalization output, medical diagnosis, analytics output or ad behavior where product/engine authority is absent.
- Meaningful gameplay progress remains movement-backed.
- Pose thresholds stay configuration until labelled-video corpus and real-device ML Kit validation are completed.

## Next exact actions
1. Audit current inventory/crafting owners and determine whether a pure transaction contract can be added without inventing recipes/costs/loot tables.
2. Audit Rewarded Ads state and split eligibility/policy from external ad SDK success.
3. Implement only product-authorized cooldown/count/battle-context rules and require explicit ad-success callback before any reward/continue mutation.
4. Require formatter + analyzer + focused/full tests + diff hygiene before marking the batch green.
5. Re-audit remaining Phase-1 gaps after Loot/Crafting + Rewarded Ads.
6. Physical-device ML Kit labelled-corpus validation remains a mandatory release gate and cannot be replaced by synthetic unit tests.

## Permanent working rule
After each meaningful green batch, update this file with latest green run/commit, completed scope, blockers and exact next step. This file is the GitHub recovery checkpoint when a chat/tab ends.
