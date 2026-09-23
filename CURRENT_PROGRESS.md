# ActiRune Current Progress

Updated: 2026-09-23 (Europe/Istanbul)
Branch: `integration/artwork-interactions-20260921`

## Last fully green Direct Validation
- Run: 242
- Checked commit: `f3379da95326632c9f7ad848918fd42f9e5416c7`
- Result: SUCCESS
- Scope: fail-closed Phase-1 release-readiness aggregator plus machine-readable physical-device ML Kit evidence infrastructure and all previously verified Phase-1 UI/gameplay, movement, Dynamic Difficulty, Recovery/Safety, Loot/Crafting, Rewarded Ads policy, Analytics/Balance, Production Release Guard and provider-neutral billing/ad gateway systems.
- Formatting: PASS.
- Analyzer: PASS, 0 issues.
- Existing Direct Validation focused interaction suite: PASS.
- Full Flutter suite: PASS.
- Diff hygiene: PASS.
- Temporary release-readiness staging workflow was removed after dedicated green validation; integration commit `f3379da95326632c9f7ad848918fd42f9e5416c7` contains the validated aggregator/test batch without the temporary workflow.

## Newly completed verified system
### Phase-1 release-readiness aggregator
- Runtime: `lib/core/release/phase1_release_readiness.dart`.
- Regression tests: `test/phase1_release_readiness_test.dart`.
- Production application identity/signing, provider authority/configuration and physical-device evidence/human review are separate release gates.
- Placeholder/missing production identity or signing remains blocking through `ProductionReleaseGuard`.
- Provider state is explicitly `undecided`, `lockedNotConfigured` or `configured`; an undecided or incomplete provider state cannot produce aggregate green.
- Missing or structurally incomplete physical evidence cannot produce aggregate green.
- Any physical record marked FAIL or NEEDS_THRESHOLD_REVIEW blocks aggregate green.
- A claimed physical final PASS is rejected unless the evidence is structurally ready and has no outstanding failed/threshold-review records.
- `allDeclaredGatesSatisfied` means only the gates represented by supplied verified evidence are satisfied; it explicitly does not replace store review, credential/signing provenance, provider-console verification or other external evidence.

### Physical-device ML Kit evidence infrastructure
- Runtime evidence model: `lib/features/pose/validation/physical_validation_evidence.dart`.
- Repository validator CLI: `tool/validate_physical_mlkit_evidence.dart`.
- Regression tests: `test/physical_validation_evidence_test.dart`.
- Evidence documentation: `validation/physical_device_mlkit/README.md`.
- Empty starter template: `validation/physical_device_mlkit/evidence.template.json`.
- The schema records exact commit/build, ML Kit package version, device/OS, camera/orientation, lighting/framing, anonymous corpus/session ids, movement, labelled expectations, accepted/rejected observations, false positives/negatives, occlusion/duplicate/lifecycle notes, coverage tags and reviewer disposition.
- Repository evidence explicitly rejects raw personal/biometric media fields such as real subject names, raw video paths/bytes and biometric ids.
- Required evidence coverage includes valid, incomplete, incorrect-form, speed, confidence/occlusion, framing, duplicate/replay and battle-integration cases for all four Phase-1 movements; plank hold and camera lifecycle have explicit coverage gates.
- The validator can only report `BLOCKED_EVIDENCE_INCOMPLETE` or `READY_FOR_HUMAN_REVIEW`.
- `READY_FOR_HUMAN_REVIEW` deliberately does **not** mean release PASS. Real-human physical-device evidence, thresholds, supported-device scope and final disposition remain human-reviewed external proof.

## Production identity audit
- Audit: `docs/release/CANONICAL_IDENTITY_AUDIT_20260923.md`.
- Current Android application id remains `com.example.actirune`.
- Current iOS Runner bundle id remains `com.example.actirune`; no authoritative `DEVELOPMENT_TEAM` is present in repository evidence.
- Historical `com.example.actirune_canonical_visual_prototype` belongs to the visual prototype APK and is explicitly not production authority.
- No authoritative historical ActiRune Firebase, RevenueCat, AdMob, Apple Team/App Store Connect, Google Play production package or final iOS bundle-id decision was found.
- Aile Güvende/Kinola identities must never be reused for ActiRune.
- Production provider bootstrap remains blocked by identity authority rather than silently registering placeholder ids.

## Provider-neutral Pro billing gateway
- Runtime: `lib/features/monetization/pro_billing_gateway.dart`.
- Regression coverage: `test/monetization_provider_contracts_test.dart`.
- Defines monthly/annual billing periods without inventing store product ids.
- Provider/store package id remains opaque to gameplay/UI behavior.
- Localized price is provider-supplied display data; ActiRune does not calculate or hard-code store pricing in the domain contract.
- Pro access is granted only when purchase outcome is `purchased` AND entitlement state is `active`; cancelled/failed/inactive results cannot report Pro success.
- Gateway owns load offerings, current entitlement, purchase and restore boundaries without selecting RevenueCat/StoreKit/Google Play in runtime yet.

## Provider-neutral Rewarded Ad gateway
- Runtime: `lib/features/monetization/rewarded_ad_gateway.dart`.
- Regression coverage: `test/monetization_provider_contracts_test.dart`.
- Locked placements represented as Rune Shrine and PvE defeat retry.
- External provider results represented as completed/cancelled/failed/unavailable.
- `RewardedAdDeliveryCoordinator` preserves `RewardedAdPolicy` as product authority.
- Completed external ad may pass the reward gate; cancelled, failed and unavailable outcomes cannot.
- Direct Pro grants do not invoke an ad provider.
- Policy-blocked decisions do not invoke an ad provider.
- No AdMob SDK, ad-unit id, fake success path or provider network behavior was added.

## Production provider research / recommendation
- Decision record: `docs/architecture/PRODUCTION_PROVIDER_DECISION_20260923.md`.
- Decision record commit: `64353a59583f81f13543cfe999ce8e3f89bab7be`.
- Status: RECOMMENDED / NOT YET LOCKED.
- Recommended lowest-friction stack for the current Flutter/iOS/Android architecture:
  - Firebase for backend/Auth/Firestore/Functions/App Check.
  - RevenueCat for Pro subscription/entitlement management.
  - Google Mobile Ads / AdMob for rewarded ads.
  - Firebase Analytics with optional BigQuery export for analytics/warehouse use.
  - Native Android Health Connect + Apple HealthKit deferred until approved release scope requires them.
- Supabase is recorded as the credible backend alternative when SQL/Postgres ownership or provider portability outweighs minimum integration surface.
- No provider SDK was installed because final app identifiers, provider projects/accounts and credentials are not authoritative yet.

## Production Release Guard
- Runtime guard: `lib/core/release/production_release_guard.dart`.
- Regression tests: `test/production_release_guard_test.dart`.
- Repository CLI: `tool/check_production_release_readiness.dart`.
- Manual release workflow: `.github/workflows/actirune-production-readiness.yml`.
- Android application id must exist and must not use `com.example.*`.
- Android release signing must be configured and must not use debug signing.
- iOS Runner bundle id must exist and must not use `com.example.*`; RunnerTests ids are ignored when selecting the app id.
- iOS `DEVELOPMENT_TEAM` must exist.
- Missing/malformed authority fails closed.

## Analytics / Balance provider-neutral contract
- Runtime: `lib/core/analytics/analytics_event.dart`.
- Regression test: `test/analytics_event_contract_test.dart`.
- Required typed families: onboarding, D1/D7/D30 retention, daily/weekly quest completion/reroll/abandon, movement verified/invalid/form score, boss success/retry/rewarded retry, world progression/region exit, economy craft sink/loot source, Rune Shrine impression/opt-in/completion, Pro paywall/trial/paid/renewal/churn and social invite/room/raid completion.
- `AnalyticsSink` remains provider-neutral. No analytics provider, network transport, persistence, account identity, backend endpoint, SDK success or production telemetry delivery was fabricated.

## Release-gate audit recorded
- Matrix: `docs/release/PHASE1_RELEASE_GATE_MATRIX_20260923.md`.
- Physical ML Kit gate: `docs/release/PHYSICAL_DEVICE_MLKIT_VALIDATION_GATE.md`.
- Release matrix commit: `e514eed8dae43cdfbf6a2c04f46bd4161854c7c1`.
- Physical-device validation protocol commit: `d45a74115ef94e91965788e76511faaca57750b5`.

### Current release-service classifications
- Core verified Flutter/gameplay scope: IMPLEMENTED within repository scope.
- Four movement state machines + VerifiedRep routing: IMPLEMENTED, but physical-device proof still required.
- Physical evidence schema/validator: IMPLEMENTED and VERIFIED; real corpus remains `BLOCKED_EXTERNAL_PROOF`.
- Aggregate release gate: IMPLEMENTED and VERIFIED; current real-world state remains blocked by identity/provider/external-proof inputs.
- Dynamic Difficulty: IMPLEMENTED deterministic policy owner.
- Recovery/Safety: IMPLEMENTED deterministic policy owner.
- Loot/Crafting: ADAPTER_ONLY beyond local validation; no real persistence/economy backend owner.
- Rewarded Ads: ADAPTER_ONLY; product policy + provider-neutral gateway are verified, real ad provider SDK/account is absent.
- Pro/Billing: ADAPTER_ONLY; UI + provider-neutral billing/entitlement gateway are verified, real IAP provider/store products are absent.
- Analytics/Balance: ADAPTER_ONLY; typed event contract exists, real provider/transport does not.
- Backend/cloud persistence: ABSENT in current repository evidence.
- Health Connect/HealthKit: ABSENT in current repository evidence.
- Android production id/signing: BLOCKED and automatically detectable; app id remains `com.example.actirune` and release currently uses debug signing.
- iOS production id/signing: BLOCKED and automatically detectable; bundle id remains `com.example.actirune` and no `DEVELOPMENT_TEAM` value is present in repository evidence.
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
- Machine-readable physical-device evidence contract/tooling: VERIFIED by Direct Validation Run 241.

## Previously verified product/UI systems
- Dynamic Difficulty + Recovery/Safety: VERIFIED by Direct Validation Run 236.
- Loot/Crafting + Rewarded Ads policy: VERIFIED by Direct Validation Run 237.
- Analytics/Balance typed contract: VERIFIED by Direct Validation Run 238.
- Production Release Guard: VERIFIED by Direct Validation Run 239.
- Pro Billing + Rewarded Ad provider-neutral gateways: VERIFIED by Direct Validation Run 240.
- Physical-device evidence infrastructure: VERIFIED by Direct Validation Run 241.
- Phase-1 release-readiness aggregator: VERIFIED by Direct Validation Run 242.
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
- Fail-closed production application-id/bundle-id/signing readiness guard
- Provider-neutral Pro billing/entitlement contract
- Provider-neutral Rewarded Ad execution contract/coordinator
- Physical-device evidence model/validator with privacy-safe repository boundary
- Fail-closed aggregate Phase-1 release-readiness report

## Product authority / safety boundary
- Master Product Bible Phase 1 requires Core Solo: Home, Adventure, Squat/Lunge/Push-up/Plank infrastructure, Camera Prep, Live Battle, Form Coach, quests, Player/Hero/Lumi/Mastery, loot/crafting, Recovery/Difficulty, Pro base layer and Rewarded Ads.
- Master Product Bible separately marks Analytics/Balance and camera/pose proof as REQUIRED.
- Provider research recommends Firebase + RevenueCat + AdMob + Firebase Analytics/BigQuery, but the product Bible still does not itself authorize those provider accounts/configuration.
- Do not invent gameplay effects, inventory mutations, engine state, rewards, routes, entitlement behavior, purchase behavior, pricing, trial state, personalization output, medical diagnosis, analytics transport/output or ad-provider behavior where product/engine/provider authority is absent.
- Meaningful gameplay progress remains movement-backed.
- Pose thresholds stay configuration until labelled-video corpus and real-device ML Kit validation are completed.

## Current hard boundary
- Remaining production blockers require provider/account configuration, store product setup, final application identifiers, signing identity and/or real physical-device evidence.
- Production credentials/signing secrets must not be invented or committed.
- Real physical-device ML Kit validation cannot be truthfully replaced by CI or synthetic unit tests.
- Production release identity/signing mistakes are automatically detectable.
- Billing and rewarded-ad providers can be connected behind tested interfaces without allowing provider SDK behavior to become product authority.
- Physical evidence can now be recorded and mechanically checked without allowing automation to manufacture a release PASS.
- Aggregate readiness cannot become green while provider authority is undecided or physical review/evidence is unresolved.

## Next exact actions
1. Define a provider-authority lock record/template and fail-closed validator so provider names and final Android/iOS identities can be made authoritative later without committing credentials or allowing placeholder ids.
2. Keep final Android/iOS identifiers as an external owner decision; do not invent or reuse prototype/other-product ids.
3. Once identifiers/provider projects are authoritative, bootstrap Firebase development configuration first behind provider-neutral repositories and App Check, without production deployment.
4. Add RevenueCat behind `ProBillingGateway`; store products/pricing/entitlements must come from real store/provider configuration.
5. Add Google Mobile Ads behind `RewardedAdGateway`; use test ad units in development and preserve `RewardedAdPolicy` as the reward authority.
6. Add Firebase Analytics only as an `AnalyticsSink` adapter; do not emit sensitive health/camera/raw-pose data.
7. Execute the labelled real-human physical-device protocol in `docs/release/PHYSICAL_DEVICE_MLKIT_VALIDATION_GATE.md` and record evidence through the verified physical-evidence schema against an exact release commit/build.
8. Run Production Readiness guard and full Direct Validation after each provider/runtime integration; do not call the build production-ready until all applicable gates are proven.

## Permanent working rule
After each meaningful green batch, update this file with latest green run/commit, completed scope, blockers and exact next step. This file is the GitHub recovery checkpoint when a chat/tab ends.
