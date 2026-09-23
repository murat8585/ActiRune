# ActiRune Phase-1 Release Gate Matrix

Date: 2026-09-23
Branch authority: `integration/artwork-interactions-20260921`

This file classifies repository state. It is **not** a production-readiness certificate. A local policy or typed interface is not evidence that an external provider, account, credential, store product or physical-device proof exists.

## Status vocabulary

- `IMPLEMENTED`: repository contains the real runtime owner for the stated scope and it has direct verification evidence.
- `ADAPTER_ONLY`: repository contains a typed boundary/policy/interface, but the external provider or production integration is not present.
- `ABSENT`: required production integration/configuration is not present in the current repository evidence.
- `BLOCKED_EXTERNAL_PROOF`: implementation exists far enough to test, but release proof requires evidence that cannot be manufactured by unit tests or CI.

## Matrix

| Area | Current status | Repository evidence | Release requirement |
|---|---|---|---|
| Core Flutter game/UI | IMPLEMENTED for the currently verified Phase-1 repository scope | Direct Validation through Run 238 is green; `CURRENT_PROGRESS.md` records verified UI, battle, movement, progression and policy systems | Keep Direct Validation green after future integration work |
| Pose / movement state machines | IMPLEMENTED | Squat, Lunge, Push-up and Plank deterministic detectors plus typed `VerifiedRep` routing are in runtime and regression coverage | Preserve detector/router tests and validate thresholds against labelled real-human footage |
| ML Kit physical-device proof | BLOCKED_EXTERNAL_PROOF | `google_mlkit_pose_detection` is declared and movement logic is unit-tested, but repository/CI cannot prove camera behavior on real people and real devices | Complete `PHYSICAL_DEVICE_MLKIT_VALIDATION_GATE.md` with real-device labelled-corpus evidence |
| Dynamic Difficulty | IMPLEMENTED as deterministic policy owner | `lib/features/adaptation/dynamic_difficulty_engine.dart` and tests | Real production inputs/persistence must come from authoritative data owners |
| Recovery / Safety | IMPLEMENTED as deterministic policy owner | `lib/features/adaptation/recovery_safety_engine.dart` and tests | Do not turn policy into medical diagnosis; production history inputs remain caller-owned |
| Loot / Crafting | ADAPTER_ONLY beyond local validation | `lib/features/economy/loot_crafting_policy.dart` validates authoritative caller-supplied recipes/inventory without mutating persistence | Add real inventory persistence/economy authority and server-side integrity before production economy claims |
| Rewarded Ads policy | ADAPTER_ONLY | `lib/features/monetization/rewarded_ad_policy.dart` enforces locked eligibility/completion rules, but `pubspec.yaml` contains no ad SDK | Integrate a real ad provider, lifecycle, consent/privacy handling and verified completion callback before any live ad claim |
| Pro / Billing | ADAPTER_ONLY at UI/contract level | Pro paywall UI exists, but `pubspec.yaml` contains no billing/IAP provider package and no authoritative SKU/store-product integration | Add StoreKit/Google Play Billing through an approved owner; verify purchase, restore, renewal, entitlement and failure paths |
| Analytics / Balance event model | ADAPTER_ONLY | `lib/core/analytics/analytics_event.dart` defines typed required events and `AnalyticsSink`; no provider is bound | Bind an approved analytics provider/backend with privacy/consent rules and delivery verification |
| Backend / cloud persistence | ABSENT from current repository evidence | No Firebase/backend dependency or production service configuration is present in current Flutter dependencies/tree audit | Select and integrate authoritative backend, auth/data model, security rules, environment separation and production credentials |
| Health Connect / HealthKit | ABSENT | Android main manifest declares camera only; iOS Info.plist declares camera usage only; `pubspec.yaml` has no health integration package | Add product-approved Health Connect/HealthKit capability, permissions, consent UX, least-privilege data access and real-device tests |
| Android production application id | ABSENT / placeholder | `android/app/build.gradle.kts` still uses `com.example.actirune` | Set final production application id before store release |
| Android production signing | ABSENT | Android release build explicitly uses the debug signing config | Configure protected production keystore/signing path; never commit private signing secrets |
| iOS production bundle id | ABSENT / placeholder | Xcode project still uses `com.example.actirune` | Set final production bundle identifier before App Store distribution |
| iOS production signing | ABSENT | Current project has automatic signing style but no `DEVELOPMENT_TEAM` value in repository evidence | Configure the approved Apple team/provisioning path outside source secrets and verify archive/export |

## Critical authority notes

1. Meaningful gameplay progression remains movement-backed.
2. Pose thresholds remain configuration until the labelled physical-device corpus proves them.
3. The current verified BattleSession owner has the newer explicit user override for rewarded retries: `3 -> 2 -> 1 -> 0`, and each successful rewarded retry restarts the same encounter from the beginning. That newer owner supersedes the older Bible wording about one partial-HP/checkpoint revive unless the owner explicitly changes it again.
4. A provider-neutral contract is deliberately not described as a live service. Humans have historically discovered that naming an interface `ProductionWhatever` does not cause servers, invoices or legal compliance to materialize.
5. Production credentials, signing secrets, billing keys and provider secrets must not be committed to this repository.

## Release-blocking gates before calling Phase-1 production ready

- Real-human physical-device ML Kit corpus completed and reviewed.
- Final Android application id + production signing verified.
- Final iOS bundle id + Apple signing/archive/export verified.
- Real billing/entitlement integration verified if Pro is included in release.
- Real ad-provider integration verified if Rewarded Ads are included in release.
- Backend/cloud persistence and security model verified for any feature that depends on remote state.
- Health Connect/HealthKit integrated and consent-tested if health data is included in release scope.
- Analytics provider/transport privacy and delivery verification completed if production telemetry is enabled.

Until those external gates are satisfied, the correct claim is: **Phase-1 core product logic is substantially implemented and regression-verified in repository scope; production service integration and physical-device release proof remain incomplete.**
