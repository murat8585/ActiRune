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

## Active work
- Phase-1 Core Solo release-service and physical-device gate classification.
- Repository evidence currently shows Flutter dependencies only for Flame, Camera, Google ML Kit Pose Detection and GoRouter; there is no billing, ad, Firebase/backend, Health Connect/HealthKit or analytics-provider package in `pubspec.yaml`.
- Android main manifest declares camera only; no Health Connect integration is configured there.
- iOS Info.plist declares camera usage only; no HealthKit usage descriptions are present.
- Android application id remains `com.example.actirune`, and release build explicitly uses debug signing.
- iOS product bundle identifier remains `com.example.actirune`; no `DEVELOPMENT_TEAM` entry was found in the current Xcode project.
- Therefore no production readiness claim may be made for billing, ad SDK delivery, backend/cloud persistence, Health Connect/HealthKit, analytics delivery or store signing.
- Google ML Kit pose adapter/unit infrastructure is implemented, but real-human labelled-corpus validation on physical devices remains a mandatory release gate.

## Phase-1 product authority boundary
- Master Product Bible Phase 1 requires Core Solo: Home, Adventure, Squat/Lunge/Push-up/Plank infrastructure, Camera Prep, Live Battle, Form Coach, quests, Player/Hero/Lumi/Mastery, loot/crafting, Recovery/Difficulty, Pro base layer and Rewarded Ads.
- Master Product Bible separately marks Analytics/Balance and camera/pose proof as REQUIRED.
- Do not invent gameplay effects, inventory mutations, engine state, rewards, routes, entitlement behavior, purchase behavior, pricing, trial state, personalization output, medical diagnosis, analytics transport/output or ad-provider behavior where product/engine/provider authority is absent.
- Meaningful gameplay progress remains movement-backed.
- Pose thresholds stay configuration until labelled-video corpus and real-device ML Kit validation are completed.

## Next exact actions
1. Create a repository release-gate matrix classifying billing, ad SDK, backend/cloud persistence, Health Connect/HealthKit, analytics provider, Android signing, iOS signing and ML Kit physical-device proof as implemented, adapter-only, absent or blocked using direct repository evidence.
2. Create the physical-device ML Kit labelled-corpus validation protocol without inventing numeric pass thresholds that the product authority has not set.
3. Keep provider-neutral policy/contracts intact; do not fabricate external service success or credentials.
4. Only after real provider integrations and physical-device proof exist should Phase-1 Core Solo be called production/release complete.

## Permanent working rule
After each meaningful green batch, update this file with latest green run/commit, completed scope, blockers and exact next step. This file is the GitHub recovery checkpoint when a chat/tab ends.
