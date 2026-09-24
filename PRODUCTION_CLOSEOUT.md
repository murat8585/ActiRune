# ActiRune Production Closeout Ledger

Updated: 2026-09-24 (Europe/Istanbul)
Authority branch: `production/closeout-20260924`
Frozen internal base: `034305744735afd9fef93488e7a81b73d87db7c0`
Purpose: continue from the completed Phase-1 internal freeze without reopening closed internal work or fabricating production authority.

## Recovery rule

At the start of every production-closeout session:
1. Read this file first.
2. Read the current production branch HEAD.
3. Resume the first item that is not `CLOSED`, while respecting dependencies.
4. Never reopen frozen Phase-1 work unless `PHASE1_CLOSEOUT.md` reopening evidence exists.
5. Never turn a missing owner/account/device decision into a synthetic green state.
6. Never commit production secrets, signing keys, service-account material, private API keys, certificates, provisioning credentials, or private provider tokens.

## State model

- `TODO`: actionable repository or validation work exists.
- `IN_PROGRESS`: currently being worked.
- `BLOCKED_EXTERNAL`: requires owner/account/device/store/provider authority outside repository evidence.
- `VERIFIED`: evidence exists but final queue transition has not yet been recorded.
- `CLOSED`: requirement is fully satisfied with auditable evidence.

## Frozen Phase-1 boundary

Phase-1 internal scope is frozen at commit `034305744735afd9fef93488e7a81b73d87db7c0` after ActiRune Direct Validation Run 267 SUCCESS.

## Ordered production queue

| ID | Status | Scope | Current truth / closure requirement |
|---|---|---|---|
| P2-000 | CLOSED | Production closeout bootstrap | Dedicated production branch and ordered ledger created from the exact frozen Phase-1 HEAD. |
| P2-001A | CLOSED | Identity migration safety prep | Typed platform-identity consistency guard, regressions and production-closeout CI are green. Production Closeout Validation Run 3 SUCCESS at exact HEAD `8717303a76b3853e4ca6c8cbfa8ce8765662df6f`. |
| P2-001B | CLOSED | Unified identity/release CLI binding | Unified CLI evaluates both release state and platform-identity consistency as pure Dart. Production Closeout Validation Run 7 SUCCESS at exact HEAD `370b08093e338729af1836e986059a8aa487ed20`; closure commit validation also succeeded. |
| P2-001C | VERIFIED | Dry-run identity authority migration planner | Candidate syntax/placeholder guard, regression coverage and a dry-run-only migration planner exist. Canonical formatting is applied and temporary formatter is removed. Exact post-cleanup production-closeout validation must pass before this is CLOSED. |
| P2-001 | BLOCKED_EXTERNAL | Final Android/iOS application identity authority | Android `applicationId`/namespace and iOS Runner bundle id remain `com.example.actirune`. No final production package/bundle decision is authoritative. |
| P2-002 | BLOCKED_EXTERNAL | Android/iOS production signing ownership | Android release uses debug signing. No authoritative Apple Development Team/signing evidence exists. Requires P2-001 first. |
| P2-003 | BLOCKED_EXTERNAL | Production provider authority lock | Firebase + RevenueCat + Google Mobile Ads + Firebase Analytics/optional BigQuery is recommended, not authoritative. Requires real identity/provider/account authority. |
| P2-004 | BLOCKED_EXTERNAL | Real provider configuration | Requires real provider projects/apps/products/ad units/analytics transport and non-secret audit evidence. |
| P2-005 | BLOCKED_EXTERNAL | Authoritative production Battle encounter/content owner | Production Battle remains fail-closed until a real encounter/content authority supplies movement/target/duration/reward semantics. |
| P2-006 | BLOCKED_EXTERNAL | Real-human physical-device ML Kit release evidence | Requires labelled real-device corpus against an exact release build plus final human review bound to that evidence/build. |
| P2-007 | TODO | Exact release-candidate gate | After P2-001..P2-006 are legitimately satisfied, run full Direct Validation and unified Production Readiness on the exact candidate HEAD. |
| P2-008 | TODO | Store candidate/submission evidence | Requires signed artifacts, store-side identity/configuration, submission/review evidence and final production checklist. |

## Identity evidence

Current Android:
- namespace: `com.example.actirune`
- applicationId: `com.example.actirune`
- MainActivity package: `com.example.actirune`
- release signing: debug signing

Current iOS:
- Runner bundle id: `com.example.actirune`
- RunnerTests derives from the placeholder app id
- no authoritative `DEVELOPMENT_TEAM` value in repository evidence

Historical `com.example.actirune_canonical_visual_prototype` is prototype history only, not production authority.

Identity decision packet:
- `docs/release/PRODUCTION_IDENTITY_DECISION_PACKET_20260924.md`
- candidate identifiers are proposals only.
- test fixtures such as `com.actirune.app` are not authority.

## P2-001A evidence

Persistent files:
- `lib/core/release/production_identity_guard.dart`
- `test/production_identity_guard_test.dart`
- `.github/workflows/actirune-production-closeout-validation.yml`

The guard fails closed for:
- missing or `com.example.*` Android namespace;
- namespace/applicationId mismatch;
- MainActivity package/namespace mismatch;
- missing or mismatched iOS RunnerTests bundle derivation.

Package-aware formatting commit: `c0d004d4e005604cad6f1433a4f6715841cd3cb0`.
Temporary V2 formatter removed: `8e8ebf96cd30bb115860c6dd6a9b0b170ff00cf2`.
Production Closeout Validation Run 3: SUCCESS on `8717303a76b3853e4ca6c8cbfa8ce8765662df6f` with format, analyzer, guard regressions and current-placeholder fail-closed check all green.

## P2-001B evidence

Initial runtime/tool integration commit: `61d4bb11255d885f8d380709383d18c49ed53176`.
Production validation workflow update: `27bcaf3538f64e62e68207a0181f53597d5dd1a7`.
Canonical CLI formatting commit: `c37de575d2013035ebfa78a0f39b7161d032cbd7`.
Temporary CLI formatter removed: `cac5643901a633720ea86f23bfb11b8378f09c27`.

Run 5 proved format, analyzer and all 9 identity/release guard regressions PASS, then exposed one real tooling defect: invoking the CLI with `dart run` failed because both release guards imported Flutter foundation only for `@immutable`, pulling in unavailable `dart:ui` on the standalone Dart VM. This was not hidden or reclassified as success.

Minimum fix:
- `production_identity_guard.dart` converted to pure Dart at `34016962090cac716afee4d8b26a299c9f239a64`.
- `production_release_guard.dart` converted to pure Dart at `370b08093e338729af1836e986059a8aa487ed20`.
- No guard semantics were weakened; only unnecessary Flutter runtime coupling was removed.

Production Closeout Validation Run 7 SUCCESS on exact HEAD `370b08093e338729af1836e986059a8aa487ed20`:
- exact checkout PASS;
- package-aware formatting PASS;
- analyzer PASS;
- 9 identity/release guard regressions PASS;
- unified `dart run tool/check_production_release_readiness.dart` PASS as a gate execution while correctly returning repository state `RESULT: BLOCKED` for the real placeholder/signing/Team blockers rather than a false production-ready state.

Production Closeout Validation Run 8 SUCCESS on exact closure commit `18dcb1c2ac963123c1a754e8721e75f478a21d64`, satisfying the P2-001B self-validating closure rule.

## P2-001C evidence

Persistent files:
- `lib/core/release/production_identity_candidate.dart`
- `test/production_identity_candidate_test.dart`
- `tool/plan_production_identity_migration.dart`
- `.github/workflows/actirune-production-closeout-validation.yml`

The candidate guard rejects:
- missing Android/iOS identifiers;
- malformed Android application ids;
- malformed iOS bundle identifiers;
- any `com.example.*` candidate.

The planner is deliberately `DRY_RUN_ONLY`. It accepts explicit `--android-id` and `--ios-bundle-id` values, reads current platform identity files, prints the exact Android namespace/applicationId/MainActivity and iOS Runner/RunnerTests mutations that would be required, and does not modify platform identity, signing, provider, account or secret state.

Validation history:
- Production Closeout Validation Run 11 reached the formatter and exposed canonical formatting drift only; analyzer/tests/planner were correctly not run after that failure.
- Canonical two-file formatting commit: `bdd7d379234a444fa23534eb7a7b71b604d8a2e5`.
- Temporary formatter removed: `b94db018f217d69a8313889f753f05965d038f29`.
- This checkpoint intentionally triggers the persistent production-closeout validation on the exact post-cleanup HEAD.

P2-001C may be CLOSED only after that exact validation passes formatting, analyzer, candidate/identity/release regressions, the valid dry-run planner path, the placeholder-rejection planner path, and the unified production readiness gate.

## Provider recommendation boundary

Current recommendation remains:
- Firebase for backend/Auth/Firestore/Functions/App Check
- RevenueCat for Pro subscriptions/entitlements
- Google Mobile Ads / AdMob for rewarded ads
- Firebase Analytics with optional BigQuery export

This remains `RECOMMENDED / NOT YET LOCKED`.

## Dependency chain

`P2-001 identity -> P2-002 signing -> P2-003 provider authority -> P2-004 provider configuration -> P2-006 physical release evidence -> P2-007 exact release gate -> P2-008 store candidate`

P2-005 Battle encounter/content authority may be resolved in parallel only when authoritative product content exists.

## Current checkpoint

`BASE=034305744735afd9fef93488e7a81b73d87db7c0 | LAST_CLOSED=P2-001B | ACTIVE=P2-001C-VERIFY | FIRST_BLOCKER=P2-001 | NEXT_AFTER_AUTHORITY=P2-002`

## Hard boundary

Repository-safe identity preparation now includes a dry-run candidate validation/migration planner. No platform identity has been changed. No next state-changing action may guess the final package/bundle identifiers, signing owner, provider projects/accounts, product ids, prices, ad-unit ids, credentials, physical-device results, or Battle content. Those require real owner/external evidence.
