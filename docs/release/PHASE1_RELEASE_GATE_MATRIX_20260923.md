# ActiRune Phase-1 Release Gate Matrix

Original date: 2026-09-23
Reconciled: 2026-09-24 (Europe/Istanbul)
Branch authority: `integration/artwork-interactions-20260921`
Internal closeout authority: repository-root `PHASE1_CLOSEOUT.md`

This file classifies repository and release state. It is **not** a production-readiness certificate.

## Two different gates

ActiRune has two deliberately separate gates:

1. **Phase-1 internal closeout** — repository-owned product/runtime work. Its ordered authority is `PHASE1_CLOSEOUT.md`, and its behavioral regression gate is `ActiRune Direct Validation`.
2. **Phase-1 production readiness** — external identities, signing, provider configuration and real-device evidence. Its aggregate is `Phase1ReleaseReadiness`, enforced by `tool/check_phase1_production_readiness.dart` and the manually dispatched `ActiRune Production Readiness` workflow.

A red production-readiness result caused by missing real identities/providers/signing/physical evidence does **not** reopen a completed internal Phase-1 item. Conversely, a green internal Direct Validation run is not evidence that production providers, stores, signing or physical-device review exist.

## Internal Phase-1 closeout state

As of this reconciliation:

| Internal item | State | Evidence boundary |
|---|---|---|
| P1-001 Flexible Activity integration truth | CLOSED | Direct Validation Run 251 SUCCESS |
| P1-002 Achievement contract semantics | CLOSED | Direct Validation Run 257 SUCCESS |
| P1-003 Progression ownership semantics | CLOSED | Direct Validation Run 259 SUCCESS |
| P1-004 Production Battle encounter authority | CLOSED — FAIL-CLOSED | No repository-owned encounter/content authority exists; Battle remains inaccessible without an injected real owner rather than inventing encounter data |
| P1-005 Runtime route closure | CLOSED | Home `Ödüller` -> canonical Rune Shrine Ready only; Direct Validation Run 262 SUCCESS |
| P1-006 Visual authority closure | CLOSED | Runtime authority classification + regression guard; Direct Validation Run 266 SUCCESS at `dc8a55cdfc47a941cb6a35da106431d287112db4` |
| P1-007 Internal release-gate reconciliation | IN PROGRESS at this document revision | Production and internal gate semantics are being reconciled without changing external proof requirements |
| P1-008 Internal close | TODO at this document revision | Requires P1-007 closure, final internal Direct Validation green and recovery checkpoint update |

The last fully green behavioral validation before this document-only reconciliation is Direct Validation Run 266. Documentation-only commits after that run do not alter runtime behavior.

## Status vocabulary for production scope

- `IMPLEMENTED`: repository contains the runtime/policy owner for the stated scope and direct verification evidence exists.
- `ADAPTER_ONLY`: repository contains a typed boundary/policy/interface, but the external production provider/integration is not proven.
- `ABSENT`: required production integration/configuration is not present in repository evidence.
- `BLOCKED_EXTERNAL_PROOF`: implementation exists far enough to test, but release proof requires real external evidence that unit tests/CI cannot manufacture.

## Production matrix

| Area | Current status | Repository evidence | Production requirement |
|---|---|---|---|
| Core Flutter game/UI | IMPLEMENTED for the internally verified Phase-1 repository scope | P1-001..P1-006 closeout evidence is recorded in `PHASE1_CLOSEOUT.md`; Direct Validation Run 266 is green | Keep final internal Direct Validation green and do not confuse it with production-service proof |
| Pose / movement state machines | IMPLEMENTED | Squat, Lunge, Push-up and Plank deterministic detectors plus typed `VerifiedRep` routing are in runtime/regression coverage | Validate thresholds against labelled real-human footage before production claims |
| ML Kit physical-device proof | BLOCKED_EXTERNAL_PROOF | `google_mlkit_pose_detection` and validation tooling exist; CI cannot prove real-person/device behavior | Complete `PHYSICAL_DEVICE_MLKIT_VALIDATION_GATE.md` and exact-build human review |
| Dynamic Difficulty | IMPLEMENTED as deterministic policy owner | `lib/features/adaptation/dynamic_difficulty_engine.dart` and tests | Real production inputs/persistence must come from authoritative data owners |
| Recovery / Safety | IMPLEMENTED as deterministic policy owner | `lib/features/adaptation/recovery_safety_engine.dart` and tests | Keep non-medical boundary; production history inputs remain caller-owned |
| Loot / Crafting | ADAPTER_ONLY beyond local validation | `lib/features/economy/loot_crafting_policy.dart` validates caller-supplied recipes/inventory | Real persistence/economy authority and integrity controls remain external production work |
| Rewarded Ads | ADAPTER_ONLY | Provider-neutral gateway/policy exists; no live ad-provider proof is authoritative | Approved provider, consent/privacy, lifecycle and verified completion callback |
| Pro / Billing | ADAPTER_ONLY | Provider-neutral billing boundary and paywall exist; no authoritative live SKU/store entitlement proof | StoreKit/Google Play Billing provider configuration plus purchase/restore/renewal/failure verification |
| Analytics | ADAPTER_ONLY | Typed analytics event contract/sink exists; no production transport proof is bound | Approved provider, privacy/consent and delivery verification |
| Backend / cloud persistence | ABSENT from current authoritative production evidence | No locked/configured backend evidence file establishes a live production service | Approved backend/auth/data/security/environment configuration and non-secret audit evidence |
| Health Connect / HealthKit | ABSENT | No health integration package/capability is authoritative in current release evidence | Add only if included in approved release scope, with least privilege and real-device consent tests |
| Android production application id | ABSENT / placeholder | Platform file still uses `com.example.actirune` | Final owner-approved application id |
| Android production signing | ABSENT | Release path still lacks authoritative protected production signing proof | Protected production keystore/signing provenance outside Git secrets |
| iOS production bundle id | ABSENT / placeholder | Current project evidence still uses placeholder identity | Final owner-approved bundle id |
| iOS production signing | ABSENT | No authoritative Apple Development Team/signing evidence in repository release records | Approved Apple team/provisioning/archive/export evidence |

## Release-gate code interpretation

`lib/core/release/phase1_release_readiness.dart` is a **production-readiness aggregate**, despite the historical `Phase1` name. Its blockers are intentionally external-facing: production identity/signing, provider authority/configuration, physical-device evidence and final human review.

`test/phase1_release_readiness_test.dart` explicitly proves that current placeholder identities, undecided providers and missing physical evidence cannot produce a green aggregate report. That fail-closed behavior is correct and must not be weakened merely to close internal Phase-1 work.

`.github/workflows/actirune-production-readiness.yml` is `workflow_dispatch` only. It is not the automatic internal regression workflow. Running it before external evidence exists is expected to end blocked/non-green at the unified production-readiness enforcement step.

The automatic internal behavioral gate remains `.github/workflows/actirune-direct-validation.yml`.

## Critical authority notes

1. Meaningful gameplay progression remains movement-backed.
2. Pose thresholds remain configuration until a labelled physical-device corpus proves them.
3. The verified BattleSession owner retains the newer explicit rewarded-retry behavior `3 -> 2 -> 1 -> 0`, with each successful rewarded retry restarting the same encounter from the beginning, unless product authority changes it again.
4. Provider-neutral contracts are not live-service evidence. Naming an interface after production, as humanity has repeatedly demonstrated, does not cause a provider account to appear by spontaneous generation.
5. Production credentials, signing secrets, billing keys and provider secrets must not be committed.
6. P1-004's fail-closed Battle state is an internal safety closure, not proof that production encounter content exists.
7. P1-006 visual candidate exceptions remain exactly the documented runtime exceptions; runtime use does not silently promote candidate artwork to canonical authority.

## Production blockers before a production-ready claim

- Real-human physical-device ML Kit corpus completed and reviewed for the exact release build.
- Final Android application id + production signing verified.
- Final iOS bundle id + Apple signing/archive/export verified.
- Real billing/entitlement integration verified if Pro ships.
- Real ad-provider integration verified if Rewarded Ads ship.
- Backend/cloud persistence and security verified for features that depend on remote/critical state.
- Health Connect/HealthKit integrated and consent-tested only if included in release scope.
- Analytics provider/transport privacy and delivery verified if telemetry is enabled.

Until those external gates are satisfied, the correct claim is:

**Phase-1 internal product logic can close independently when its ordered closeout ledger and Direct Validation are green; production service integration, platform identity/signing and physical-device release proof remain incomplete.**
