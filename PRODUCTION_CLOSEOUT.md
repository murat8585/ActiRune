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

Only one non-external production item should be `IN_PROGRESS` at a time.

## Frozen Phase-1 boundary

Phase-1 internal scope is frozen at commit `034305744735afd9fef93488e7a81b73d87db7c0` after ActiRune Direct Validation Run 267 SUCCESS. Production work must branch from that authority rather than changing the meaning of the frozen internal ledger.

## Ordered production queue

| ID | Status | Scope | Current truth / closure requirement |
|---|---|---|---|
| P2-000 | CLOSED | Production closeout bootstrap | Dedicated production branch and ordered ledger created from the exact frozen Phase-1 HEAD. |
| P2-001A | VERIFIED | Identity migration safety prep | Typed platform-identity consistency guard, regressions and dedicated production-closeout CI exist. Package-aware canonical formatting is applied. This checkpoint must pass `ActiRune Production Closeout Validation` on its exact HEAD before P2-001A is recorded CLOSED. |
| P2-001 | BLOCKED_EXTERNAL | Final Android/iOS application identity authority | Android `applicationId`/namespace and iOS Runner bundle id are still `com.example.actirune`. No final production package/bundle decision is authoritative. Owner must explicitly lock the real identifiers before platform/provider registration. |
| P2-002 | BLOCKED_EXTERNAL | Android/iOS production signing ownership | Android release currently uses debug signing. No authoritative Apple Development Team/signing evidence exists. Requires protected signing ownership after P2-001. |
| P2-003 | BLOCKED_EXTERNAL | Production provider authority lock | Recommended stack is Firebase + RevenueCat + Google Mobile Ads + Firebase Analytics/optional BigQuery, but recommendation is not authority. Requires P2-001 plus explicit provider/account decision before `validation/release/provider_authority.json` may legitimately exist. |
| P2-004 | BLOCKED_EXTERNAL | Real provider configuration | Requires real provider projects/apps/products/ad units/analytics transport and non-secret audit evidence matching the locked identities/providers. No fake config files, ids, prices, entitlements or success states. |
| P2-005 | BLOCKED_EXTERNAL | Authoritative production Battle encounter/content owner | Production Battle remains fail-closed until a real encounter/content authority supplies unlocked encounter movement/target/duration/reward semantics. Do not invent an encounter merely to enable the tab. |
| P2-006 | BLOCKED_EXTERNAL | Real-human physical-device ML Kit release evidence | Requires labelled real-device corpus against an exact release build plus final human review bound to the exact evidence blob/build. CI/unit tests are not physical proof. |
| P2-007 | TODO | Exact release-candidate gate | After P2-001..P2-006 are legitimately satisfied, run full Direct Validation and the unified Production Readiness gate on the exact candidate HEAD. Any unresolved represented gate must remain red. |
| P2-008 | TODO | Store candidate/submission evidence | Requires signed release artifacts, store-side identity/configuration, review/submission evidence and final production checklist. No store-ready claim before P2-007 is green. |

## Current repository evidence

### P2-001 identity

Current Android configuration:
- namespace: `com.example.actirune`
- applicationId: `com.example.actirune`
- release signing: debug signing

Current iOS configuration:
- Runner bundle id: `com.example.actirune`
- no authoritative `DEVELOPMENT_TEAM` value found in repository evidence

Historical `com.example.actirune_canonical_visual_prototype` is visual-prototype history only and is explicitly not production authority.

Identity-decision packet:
- `docs/release/PRODUCTION_IDENTITY_DECISION_PACKET_20260924.md`
- candidate shapes are proposals only; no platform identity mutation has been made.

### P2-001A identity migration safety prep

Persistent safeguards:
- `lib/core/release/production_identity_guard.dart`
- `test/production_identity_guard_test.dart`
- `.github/workflows/actirune-production-closeout-validation.yml`

The guard validates:
- Android namespace is present and not `com.example.*`;
- Android namespace and applicationId stay aligned;
- `MainActivity` package stays aligned with Android namespace;
- iOS RunnerTests bundle id is derived from the Runner bundle id.

Validation history:
- Production Closeout Validation Run 1 stopped only on formatter drift.
- The first temporary formatter revealed that formatting before dependency resolution can differ because `analysis_options.yaml` could not resolve `package:flutter_lints/flutter.yaml`.
- Package-aware formatter V2 therefore runs `flutter pub get` before `dart format`.
- Package-aware canonical formatting commit: `c0d004d4e005604cad6f1433a4f6715841cd3cb0`.
- Temporary V2 formatter removed at `8e8ebf96cd30bb115860c6dd6a9b0b170ff00cf2`.
- This user-authored checkpoint intentionally triggers the persistent production-closeout validation on the exact post-cleanup HEAD.

No production identifier is inferred from test fixtures such as `com.actirune.app`.

### P2-003 provider recommendation

Current architecture recommendation remains:
- Firebase for backend/Auth/Firestore/Functions/App Check
- RevenueCat for Pro subscriptions/entitlements
- Google Mobile Ads / AdMob for rewarded ads
- Firebase Analytics with optional BigQuery export

This is still `RECOMMENDED / NOT YET LOCKED` and must not be converted into provider configuration until identity and account authority exist.

## Dependency chain

`P2-001 identity -> P2-002 signing -> P2-003 provider authority -> P2-004 provider configuration -> P2-006 physical release evidence -> P2-007 exact release gate -> P2-008 store candidate`

P2-005 Battle encounter/content authority may be resolved in parallel when authoritative product content exists, but production Battle must remain fail-closed until then.

## Current checkpoint

`BASE=034305744735afd9fef93488e7a81b73d87db7c0 | LAST_CLOSED=P2-000 | ACTIVE=P2-001A-VERIFY | FIRST_BLOCKER=P2-001 | NEXT_AFTER_AUTHORITY=P2-002`

## Hard boundary reached on 2026-09-24

Repository work has reached the first legitimate production authority boundary. The next state-changing action must not guess the final package/bundle identifiers, signing owner, provider projects, account ids, product ids, prices, ad-unit ids, credentials, physical-device results, or Battle content. Those require real owner/external evidence.
