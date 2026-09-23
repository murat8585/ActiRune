# ActiRune Current Progress

Updated: 2026-09-23 (Europe/Istanbul)
Branch: `integration/artwork-interactions-20260921`

## Last fully green Direct Validation
- Run: 238
- Checked commit: `13cc2b4915d0cfc6f2f933f79bbca1431d0fe97b`
- Result: SUCCESS
- Scope: provider-neutral Analytics/Balance event contract, together with all previously verified Phase-1 UI/gameplay, movement, Dynamic Difficulty, Recovery/Safety, Loot/Crafting and Rewarded Ads policy systems.
- Formatting: PASS.
- Analyzer: PASS, 0 issues.
- Analytics stage focused tests: PASS.
- Existing Direct Validation focused interaction suite: PASS.
- Full Flutter suite: PASS in stage and Direct Validation.
- Diff hygiene: PASS.
- Temporary analytics stage workflow was removed after validation in cleanup-only commit `a1ecb59915cf4d2b306035fc4aab3028e647bcdc`; runtime/test behavior was not changed by cleanup.

## Newly completed verified system
### Analytics / Balance provider-neutral contract
- Runtime: `lib/core/analytics/analytics_event.dart`.
- Regression test: `test/analytics_event_contract_test.dart`.
- Required typed families: onboarding, D1/D7/D30 retention, daily/weekly quest completion/reroll/abandon, movement verified/invalid/form score, boss success/retry/rewarded retry, world progression/region exit, economy craft sink/loot source, Rune Shrine impression/opt-in/completion, Pro paywall/trial/paid/renewal/churn and social invite/room/raid completion.
- Movement analytics reuses the existing `VerifiedMovementType`; economy material events reuse the locked `MaterialFamily` authority.
- `AnalyticsSink` is an interface only. No analytics provider, network transport, persistence, account identity, backend endpoint, SDK success or production telemetry delivery was fabricated.

## Release-gate audit now recorded
- Matrix: `docs/release/PHASE1_RELEASE_GATE_MATRIX_20260923.md`.
- Physical ML Kit gate: `docs/release/PHYSICAL_DEVICE_MLKIT_VALIDATION_GATE.md`.
- Release matrix commit: `e514eed8dae43cdfbf6a2c04f46bd4161854c7c1`.
- Physical-device validation protocol commit: `d45a74115ef94e91965788e76511faaca57750b5`.
- These are documentation-only changes after the last fully green runtime commit; they do not alter tested runtime behavior.

### Current release-service classifications
- Core verified Flutter/gameplay scope: IMPLEMENTED within repository scope.
- Four movement state machines + VerifiedRep routing: IMPLEMENTED, but physical-device proof still required.
- Dynamic Difficulty: IMPLEMENTED deterministic policy owner.
- Recovery/Safety: IMPLEMENTED deterministic policy owner.
- Loot/Crafting: ADAPTER_ONLY beyond local validation; no real persistence/economy backend owner.
- Rewarded Ads: ADAPTER_ONLY; product policy exists, real ad provider SDK does not.
- Pro/Billing: ADAPTER_ONLY at UI/contract level; no billing/IAP provider or SKU owner exists.
- Analytics/Balance: ADAPTER_ONLY; typed event contract exists, real provider/transport does not.
- Backend/cloud persistence: ABSENT in current repository evidence.
- Health Connect/HealthKit: ABSENT in current repository evidence.
- Android production id/signing: ABSENT/not production-ready; app id remains `com.example.actirune` and release currently uses debug signing.
- iOS production id/signing: ABSENT/not production-ready; bundle id remains `com.example.actirune` and no `DEVELOPMENT_TEAM` value is present in repository evidence.
- ML Kit physical-device release proof: BLOCKED_EXTERNAL_PROOF until real-human labelled physical-device corpus is completed and reviewed.

## Recently verified policy systems
### Loot / Crafting ownership boundary
- Runtime: `lib/features/economy/loot_crafting_policy.dart`.
- Regression test: `test/loot_crafting_policy_test.dart`.
- Locked material families and source families are typed; caller-supplied authoritative recipes are validated without inventory mutation.
- No recipe costs, drop rates, loot tables, currency values, persistence or reward application were invented.

### Rewarded Ads policy boundary
- Runtime: `lib/features/monetization/rewarded_ad_policy.dart`.
- Regression test: `test/rewarded_ad_policy_test.dart`.
- Rune Shrine: 4-hour cooldown, max 3 successful rewards/day.
- Non-Pro reward requires completed external ad outcome; cancelled/failed/missing outcomes cannot grant.
- Eligible Pro path is direct delivery without ad; actual reward owner remains external.
- Ranked PvP rewarded revive is rejected.
- PvE rewarded retry is offered only from BattleSession defeat state.
- Latest explicit user override remains authoritative: 3 rewarded retries; each successful rewarded ad restarts the same encounter from the beginning. Do not silently revert to the older Bible 25–30% HP/checkpoint line.

## Verified movement infrastructure
- Squat: green.
- Lunge: VERIFIED by Direct Validation Run 232 successful re-run.
- Push-up: VERIFIED by Direct Validation Run 233.
- Plank: VERIFIED by Direct Validation Run 234.
- Typed BattleSession/Combat routing: VERIFIED by Direct Validation Run 235.

## Previously verified product/UI systems
- Dynamic Difficulty + Recovery/Safety: VERIFIED by Direct Validation Run 236.
- Loot/Crafting + Rewarded Ads policy: VERIFIED by Direct Validation Run 237.
- Mağaza / Shop Revision: VERIFIED by Direct Validation Run 228 successful re-run.
- Lumi: VERIFIED by Direct Validation Run 224.
- Crafting / Rün Dövme exact-art shell: VERIFIED by Direct Validation Run 222 successful re-run.
- Pro Form Koçu / Long-Term Form Analytics UI: VERIFIED by Direct Validation Run 221 successful re-run.
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
- Pro Form Koçu / Long-Term Form Analytics UI
- Crafting / Rün Dövme exact-art shell + typed craft validation boundary
- Lumi
- Mağaza / Shop Revision
- Squat / Lunge / Push-up / Plank deterministic movement verification
- Typed VerifiedRep -> BattleSession/Combat routing
- Dynamic Difficulty directional policy
- Recovery/Safety policy
- Rune Shrine + PvE Rewarded Ads eligibility/completion policy
- Provider-neutral required Analytics/Balance event contract

## Product authority / safety boundary
- Master Product Bible Phase 1 requires Core Solo: Home, Adventure, Squat/Lunge/Push-up/Plank infrastructure, Camera Prep, Live Battle, Form Coach, quests, Player/Hero/Lumi/Mastery, loot/crafting, Recovery/Difficulty, Pro base layer and Rewarded Ads.
- Master Product Bible separately marks Analytics/Balance and camera/pose proof as REQUIRED.
- Master Product Bible names no Firebase, RevenueCat or AdMob provider; provider selection must not be invented merely to make a dependency list look impressive.
- Do not invent gameplay effects, inventory mutations, engine state, rewards, routes, entitlement behavior, purchase behavior, pricing, trial state, personalization output, medical diagnosis, analytics transport/output or ad-provider behavior where product/engine/provider authority is absent.
- Meaningful gameplay progress remains movement-backed.
- Pose thresholds stay configuration until labelled-video corpus and real-device ML Kit validation are completed.

## Current hard boundary
- The remaining blockers are no longer ordinary local UI/state-machine gaps. They require production-provider decisions/accounts/configuration, signing identity or real physical devices/evidence.
- No provider is currently authoritative in the product Bible for backend, billing, ads, health or analytics delivery.
- Production credentials/signing secrets must not be invented or committed.
- Real physical-device ML Kit validation cannot be truthfully replaced by CI or synthetic unit tests.

## Next exact actions when external authority/evidence is available
1. Select/confirm authoritative backend, billing, ad and analytics providers before adding provider SDKs.
2. Confirm final Android application id and iOS bundle id before production signing work.
3. Configure production signing through protected secret management, never repository plaintext.
4. Integrate Health Connect/HealthKit only if it remains in the approved release scope and permission/consent requirements are fixed.
5. Execute the labelled real-human physical-device protocol in `docs/release/PHYSICAL_DEVICE_MLKIT_VALIDATION_GATE.md` and record results against an exact release commit/build.
6. Re-run full Direct Validation after any runtime/provider integration and do not call the build production-ready until all applicable release gates are proven.

## Permanent working rule
After each meaningful green batch, update this file with latest green run/commit, completed scope, blockers and exact next step. This file is the GitHub recovery checkpoint when a chat/tab ends.
