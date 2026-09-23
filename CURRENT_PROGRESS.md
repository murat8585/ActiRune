# ActiRune Current Progress

Updated: 2026-09-23 (Europe/Istanbul)
Branch: `integration/artwork-interactions-20260921`

## Last fully green Direct Validation
- Run: 237
- Checked commit: `2c88746ba2d86b271d464f873a4d5ccd7f92f267`
- Result: SUCCESS
- Scope: Loot/Crafting ownership contract + Rewarded Ads eligibility/completion policy, together with all previously verified Phase-1 UI/gameplay, movement, Dynamic Difficulty and Recovery/Safety systems.
- Formatting: PASS.
- Analyzer: PASS, 0 issues.
- Focused stage loot/rewarded tests: PASS.
- Existing Direct Validation focused interaction suite: PASS.
- Full Flutter suite: PASS in stage and Direct Validation.
- Diff hygiene: PASS.
- Temporary loot/rewarded stage workflow was removed after validation in cleanup-only commit `349616c40b3ce758c6d14131708ac96094552ddb`; runtime/test behavior was not changed by cleanup.

## Newly completed verified systems
### Loot / Crafting ownership boundary
- Runtime: `lib/features/economy/loot_crafting_policy.dart`.
- Regression test: `test/loot_crafting_policy_test.dart`.
- Locked material families are represented as typed values: Rune Fragment, Ancient Ore, Monster Essence, Spirit Dust, Lumi Essence and Boss Core.
- Locked material loot-source families are represented as region, boss, quest and chest.
- Crafting validation accepts only a caller-supplied authoritative recipe id/material-cost map and caller-supplied inventory state.
- The policy reports exact missing material quantities but never mutates inventory.
- Empty/invalid recipe authority and invalid inventory state fail closed.
- No recipe costs, drop rates, loot tables, Gold/Kristal prices, inventory persistence or reward application were invented.
- Existing exact-art Crafting screen remains callback-only and therefore still cannot silently spend or grant inventory without a real owner.

### Rewarded Ads policy boundary
- Runtime: `lib/features/monetization/rewarded_ad_policy.dart`.
- Regression test: `test/rewarded_ad_policy_test.dart`.
- Rune Shrine locked policy is enforced as 4-hour cooldown and maximum 3 successful rewards per day.
- Eligible non-Pro delivery requires an external ad completion result; cancelled/failed/missing ad outcomes cannot apply a reward.
- Eligible Pro delivery is represented as direct delivery without requiring an ad, matching the locked Pro rule while leaving the actual reward owner external.
- Ranked PvP rewarded revive is rejected.
- PvE rewarded retry is offerable only from the BattleSession defeat phase; Camera Prep, Live Battle, Form Coach and Victory cannot surface this placement through the policy.
- No ad SDK is currently declared in `pubspec.yaml`; this layer intentionally contains no fake SDK success or network behavior.
- Important authority resolution: Master Product Bible originally says one PvE revive at ~25–30% HP/checkpoint, but the verified `BattleSessionEngine` contains a later explicit user override: 3 rewarded retries, each successful rewarded ad restarts the same encounter from the beginning. Per the project authority order, the newer user override supersedes that older Bible line. RewardedAdPolicy therefore defers retry count/restart semantics to `BattleSessionEngine` instead of silently reverting them.

## Verified movement infrastructure
- Squat: green.
- Lunge: VERIFIED by Direct Validation Run 232 successful re-run.
- Push-up: VERIFIED by Direct Validation Run 233.
- Plank: VERIFIED by Direct Validation Run 234.
- Typed BattleSession/Combat routing: VERIFIED by Direct Validation Run 235.

## Previously verified product/UI systems
- Dynamic Difficulty + Recovery/Safety: VERIFIED by Direct Validation Run 236.
- Mağaza / Shop Revision: VERIFIED by Direct Validation Run 228 successful re-run.
- Lumi: VERIFIED by Direct Validation Run 224.
- Crafting / Rün Dövme exact-art shell: VERIFIED by Direct Validation Run 222 successful re-run.
- Pro Form Koçu / Long-Term Form Analytics: VERIFIED by Direct Validation Run 221 successful re-run.
- Kişisel Günlük Macera / Personal Daily Adventure: VERIFIED by Direct Validation Run 220 successful re-run.
- Pro / Paywall: VERIFIED by Direct Validation Run 219 successful re-run.
- Profile -> Achievements / Rozetler: VERIFIED by Direct Validation Run 218.

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
- Crafting / Rün Döme exact-art shell + typed craft validation boundary
- Lumi
- Mağaza / Shop Revision
- Squat / Lunge / Push-up / Plank deterministic movement verification
- Typed VerifiedRep -> BattleSession/Combat routing
- Dynamic Difficulty directional policy
- Recovery/Safety policy
- Rune Shrine Rewarded Ads eligibility/completion policy
- PvE Rewarded Ads eligibility/completion policy with BattleSession-owned retry semantics

## Active work
- Phase-1 Core Solo remaining-gap audit after Loot/Crafting + Rewarded Ads.
- Master Product Bible marks Analytics/Balance infrastructure REQUIRED and also states real human ML Kit movement validation must be proven on physical devices.
- The Bible also states real Health Connect/backend/billing/production-signing style services must move from prototype/local adapters to production integration; current repository must be classified carefully rather than calling those production-ready without evidence.
- Current `pubspec.yaml` still has no ad SDK or billing SDK owner. Do not fabricate provider success, SKU state, credentials, server persistence or production signing.

## Phase-1 product authority boundary
- Master Product Bible Phase 1 requires Core Solo: Home, Adventure, Squat/Lunge/Push-up/Plank infrastructure, Camera Prep, Live Battle, Form Coach, quests, Player/Hero/Lumi/Mastery, loot/crafting, Recovery/Difficulty, Pro base layer and Rewarded Ads.
- Do not invent gameplay effects, inventory mutations, engine state, rewards, routes, entitlement behavior, purchase behavior, pricing, trial state, personalization output, medical diagnosis, analytics output or ad behavior where product/engine authority is absent.
- Meaningful gameplay progress remains movement-backed.
- Pose thresholds stay configuration until labelled-video corpus and real-device ML Kit validation are completed.

## Next exact actions
1. Re-audit remaining Phase-1 gaps against the Master Product Bible and current runtime instead of assuming Core Solo is release-complete.
2. Audit REQUIRED Analytics/Balance ownership and add only a typed event contract if the repository has no real analytics owner; do not fabricate a backend/provider.
3. Classify Health Connect/backend/billing/ad SDK/production signing as implemented, adapter-only or absent with repository evidence.
4. Preserve the later 3-retry BattleSession user override unless the user explicitly changes it again.
5. Build the physical-device ML Kit labelled-corpus validation plan/gate; synthetic unit tests cannot replace it.
6. Only after those release gates are explicit should Phase-1 Core Solo be called implementation-complete.

## Permanent working rule
After each meaningful green batch, update this file with latest green run/commit, completed scope, blockers and exact next step. This file is the GitHub recovery checkpoint when a chat/tab ends.
