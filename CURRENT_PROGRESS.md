# ActiRune Current Progress

Updated: 2026-09-23 (Europe/Istanbul)
Branch: `integration/artwork-interactions-20260921`

## Last fully green behavioral Direct Validation
- Run: **245**
- Checked commit: `0cd0f041160621c5e8632634b62441528bb081ad`
- Result: **SUCCESS**
- Scope: production-evidence chain + all previously verified Phase-1 UI/gameplay, movement, battle routing, Dynamic Difficulty, Recovery/Safety, Loot/Crafting, Rewarded Ads policy, Analytics/Balance, provider-neutral billing/ad gateways, production release guard, physical-evidence infrastructure, aggregate release readiness and provider-authority enforcement.
- Formatting: PASS.
- Analyzer: PASS.
- Full Flutter suite: PASS.
- Canonical artwork presence/dimension guards: PASS.
- The temporary production-evidence staging workflow was removed before the integration checkpoint; `0cd0f041160621c5e8632634b62441528bb081ad` contains only the intended persistent release/runtime/test/documentation files.

## Latest verified release-safety batches

### Run 243 — Provider Authority Lock
- Runtime: `lib/core/release/provider_authority_lock.dart`.
- Tests: `test/provider_authority_lock_test.dart`.
- CLI: `tool/validate_provider_authority_lock.dart`.
- Template: `validation/release/provider_authority.template.json`.
- Locks non-secret Android/iOS application ids plus backend, billing, rewarded-ad and analytics provider names.
- Rejects placeholder ids, malformed authority, unknown/credential-like fields and platform-id mismatches.
- Current real production authority is still NOT LOCKED; the verified system is the fail-closed mechanism, not fabricated provider/account data.

### Run 244 — Provider authority bound into aggregate release readiness
- Runtime: `lib/core/release/phase1_release_readiness.dart`.
- Tests: `test/phase1_release_readiness_test.dart`.
- `ProviderReleaseState.configured` cannot produce aggregate green without a valid `ProviderAuthorityReport`.
- A mismatched or absent provider authority is explicitly blocking.
- Production identity/signing, provider authority/configuration and physical-device evidence/human review remain separate gates.

### Run 245 — Production Evidence Chain
New verified persistent files:
- `lib/core/release/provider_configuration_evidence.dart`
- `lib/features/pose/validation/physical_validation_final_review.dart`
- `test/provider_configuration_evidence_test.dart`
- `test/physical_validation_final_review_test.dart`
- `tool/check_phase1_production_readiness.dart`
- `tool/phase1_production_readiness_gate_test.dart`
- `validation/release/provider_configuration.template.json`
- `validation/release/physical_final_review.template.json`
- updated `validation/release/README.md`
- hardened `.github/workflows/actirune-production-readiness.yml`

Provider configuration evidence:
- Must match the locked Android/iOS ids and provider names.
- Records only non-secret public/audit references and verification methods.
- Required providers cannot be marked release-configured unless explicitly recorded as configured.
- Unknown fields are rejected so API keys/tokens/secrets cannot quietly become release evidence.

Physical final review:
- A final physical PASS is bound to the exact Git blob SHA of `validation/physical_device_mlkit/evidence.json`.
- The physical corpus must represent exactly one build.
- `reviewedBuild` must match that corpus build.
- Failed disposition, malformed SHA, changed evidence, mixed-build evidence or build mismatch blocks release.
- Raw video, real subject identity and biometric data do not belong in repository release records.

Unified production checker:
- `dart run tool/check_phase1_production_readiness.dart` launches the real gate through Flutter test runtime so Flutter-domain types are evaluated correctly.
- It evaluates production identity/signing, provider authority, provider configuration, physical evidence completeness, exact evidence/build-bound final review and the aggregate Phase-1 gate together.
- Current repository is intentionally expected to return **BLOCKED_PHASE1_PRODUCTION_READINESS** until real external inputs exist.
- The staging validation explicitly proved the current repo fails closed for the expected blockers rather than manufacturing a false PASS.

Manual Production Readiness workflow:
- `.github/workflows/actirune-production-readiness.yml` is `workflow_dispatch` only.
- It formats/analyzes the release-gate code, runs focused release regressions and enforces the unified Phase-1 production checker.
- It is expected to fail today because the real production prerequisites below are unresolved. That red result is correct behavior, not a code regression.

## Physical-device ML Kit evidence infrastructure
Verified by Run 241.
- Model: `lib/features/pose/validation/physical_validation_evidence.dart`.
- Validator: `tool/validate_physical_mlkit_evidence.dart`.
- Tests: `test/physical_validation_evidence_test.dart`.
- Docs/template: `validation/physical_device_mlkit/README.md`, `evidence.template.json`.
- Covers Squat, Lunge, Push-up and Plank; valid/incomplete/incorrect-form/speed/occlusion/framing/duplicate/battle-integration coverage plus plank-hold and camera-lifecycle evidence.
- Repository records privacy-safe metadata/results only. Raw personal footage and biometric identity fields are rejected.
- Automation may say `READY_FOR_HUMAN_REVIEW`; it may not convert that into a release PASS.

## Verified movement/gameplay infrastructure
- Squat: green.
- Lunge: VERIFIED by Direct Validation Run 232 successful re-run.
- Push-up: VERIFIED by Run 233.
- Plank: VERIFIED by Run 234.
- Typed VerifiedRep -> BattleSession/Combat routing: VERIFIED by Run 235.
- Dynamic Difficulty + Recovery/Safety: Run 236.
- Loot/Crafting + Rewarded Ads policy: Run 237.
- Analytics/Balance typed contract: Run 238.
- Production Release Guard: Run 239.
- Provider-neutral Pro Billing + Rewarded Ad gateways: Run 240.
- Physical-device evidence infrastructure: Run 241.
- Base Phase-1 release-readiness aggregator: Run 242.
- Provider Authority Lock: Run 243.
- Provider authority aggregate hardening: Run 244.
- Production Evidence Chain: Run 245.

## Verified product/UI scope
Major previously verified scope includes:
- Root navigation: Ana Dünya / Macera / Savaş / Kahraman / Profil.
- Home, Adventure, Hero, Profile and child routes.
- Onboarding and calibration shells with false-success protection.
- Daily/Weekly Quests, Quest Chain, Events, Daily Summary, Weekly League Result.
- Battle Prep, Camera Prep, Live Battle, Form Coach, Victory, Defeat and BattleFlowHost.
- Rewarded retry state 3/3 -> 2/3 -> 1/3 -> 0/3.
- World Progression, Movement Mastery, Player Level, Achievements.
- Pro Paywall, Personal Daily Adventure, Pro Form Coach / long-term form analytics UI.
- Equipment, Inventory, Crafting / Rune Forge, Lumi, Shop Revision and settings family.
- Canonical approved artwork remains runtime authority; replacement art must not be invented.

## Production identity audit
Audit: `docs/release/CANONICAL_IDENTITY_AUDIT_20260923.md`.

Current repository state:
- Android application id: `com.example.actirune` — placeholder, BLOCKED.
- Android release signing: debug signing — BLOCKED.
- iOS Runner bundle id: `com.example.actirune` — placeholder, BLOCKED.
- iOS `DEVELOPMENT_TEAM`: no authoritative value in repository evidence — BLOCKED.
- Historical `com.example.actirune_canonical_visual_prototype` is a visual-prototype id only and is NOT production authority.
- Aile Güvende/Kinola identities are unrelated and must never be reused for ActiRune.

No authoritative historical ActiRune Firebase project, RevenueCat project, AdMob app/ad units, Apple Team/App Store Connect identity, Google Play production package or final iOS bundle-id decision was found.

## Provider recommendation versus authority
Decision record: `docs/architecture/PRODUCTION_PROVIDER_DECISION_20260923.md`.
Status: **RECOMMENDED / NOT YET LOCKED**.

Current recommendation:
- Firebase: backend/Auth/Firestore/Functions/App Check.
- RevenueCat: Pro subscription/entitlement management.
- Google Mobile Ads / AdMob: rewarded ads.
- Firebase Analytics + optional BigQuery export: analytics/warehouse.
- Health Connect / HealthKit: deferred unless explicitly retained in approved release scope.

This recommendation is not permission to invent provider projects, credentials, product ids, pricing, entitlements or production app identities.

## Current real release blockers
1. Final Android application id has not been made authoritative.
2. Android production signing identity/configuration is absent.
3. Final iOS bundle id has not been made authoritative.
4. Apple Development Team/signing authority is absent.
5. `validation/release/provider_authority.json` is absent because the provider/application-identity decision is not yet authoritative.
6. Real provider projects/accounts/configuration are absent; therefore `provider_configuration.json` is also absent.
7. RevenueCat store products/pricing/entitlements are not authoritative/configured.
8. Google Mobile Ads production app/ad-unit configuration is absent.
9. Real analytics transport/provider configuration is absent.
10. Real-human physical-device ML Kit corpus is absent/incomplete as release proof.
11. `physical_final_review.json` cannot legitimately PASS until that exact corpus/build is reviewed.
12. Store review and protected signing/credential provenance remain external release responsibilities.

## Current readiness truth
- Repository-internal Phase-1 architecture/policy/guard scaffolding is highly mature and CI-green through Run 245.
- Current production readiness is **BLOCKED**, intentionally and correctly.
- Do not describe the build as production-ready while any blocker above remains unresolved.
- Do not turn missing external proof into synthetic CI success.
- Do not commit production secrets or signing credentials to Git history.

## Next exact actions
1. Re-audit the Master Product Bible/release matrix for any remaining Phase-1 feature that can still be completed without inventing external identities/providers.
2. If no internal product gap remains, stop internal feature fabrication at the hard boundary rather than creating fake work.
3. When the owner makes final Android/iOS identities and provider choices authoritative, create `provider_authority.json` from the verified template and validate it against real platform files.
4. Configure production signing only through protected secret/signing management.
5. Integrate one real provider at a time behind the already verified provider-neutral interfaces; after each batch run full Direct Validation.
6. Record provider configuration with non-secret audit evidence only after real console/runtime verification.
7. Execute the labelled real-human physical-device protocol in `docs/release/PHYSICAL_DEVICE_MLKIT_VALIDATION_GATE.md` against an exact build and record it through the verified evidence schema.
8. Bind the final physical human review to the exact evidence Git blob SHA and exact reviewed build.
9. Run the manual Production Readiness workflow. Only an evidence-backed green result may advance release readiness.

## Permanent working rule
After each meaningful green behavioral batch, update this file with the latest verified run/commit, completed scope, blockers and next exact action. Documentation-only checkpoint commits do not redefine the last behavioral validation run. This file is the GitHub recovery checkpoint when a chat/tab ends.
