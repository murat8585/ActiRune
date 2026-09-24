# ActiRune Production Closeout Ledger

Updated: 2026-09-24 (Europe/Istanbul)
Authority branch: `production/closeout-20260924`
Frozen internal base: `034305744735afd9fef93488e7a81b73d87db7c0`
Purpose: continue from the completed Phase-1 internal freeze without reopening closed work, repeating audits, or fabricating production authority.

## Recovery rule

At every production-closeout session:
1. Read this file first.
2. Read the current `production/closeout-20260924` HEAD.
3. Resume the first item that is not `CLOSED`, while respecting dependencies.
4. Never reopen frozen Phase-1 work unless `PHASE1_CLOSEOUT.md` contains valid reopening evidence.
5. Never turn a missing owner/account/device/store/provider decision into a synthetic green state.
6. Never commit production secrets, signing keys, service-account material, private API keys, certificates, provisioning credentials, reviewer passwords, or private provider/store tokens.
7. Repository-safe preparation is monotonic. A closed `P2-xxxA` preparation item is not repeated because the corresponding real external `P2-xxx` item remains blocked.

## State model

- `TODO`: actionable repository or validation work exists now.
- `IN_PROGRESS`: currently being worked.
- `BLOCKED_EXTERNAL`: the next legitimate action requires owner/account/device/store/provider/content authority outside the repository.
- `VERIFIED`: evidence exists but final queue transition has not yet been recorded.
- `CLOSED`: requirement is fully satisfied with auditable evidence.

## Frozen Phase-1 boundary

Phase-1 internal scope is frozen at `034305744735afd9fef93488e7a81b73d87db7c0` after ActiRune Direct Validation Run 267 SUCCESS.

## Ordered production queue

| ID | Status | Scope | Current truth / closure requirement |
|---|---|---|---|
| P2-000 | CLOSED | Production closeout bootstrap | Dedicated production branch and ordered ledger created from the exact frozen Phase-1 HEAD. |
| P2-001A | CLOSED | Identity migration safety prep | Typed identity consistency guard + CI. Run 3 SUCCESS at `8717303a76b3853e4ca6c8cbfa8ce8765662df6f`. |
| P2-001B | CLOSED | Unified identity/release CLI | Pure-Dart unified gate. Run 7 SUCCESS at `370b08093e338729af1836e986059a8aa487ed20`; closure Run 8 SUCCESS. |
| P2-001C | CLOSED | Dry-run identity migration planner | Candidate guard + dry-run-only migration planner. Run 13 SUCCESS at `93f057db81cac0aaacbe9dbdff6825a701d8e0ee`; closure validation SUCCESS. |
| P2-002A | CLOSED | Production signing safety preflight | Signing hygiene guard/tests/CLI are green. Run 18 SUCCESS at `65572971ef00685792dfd91536fd6f30db059945`; closure Run 19 SUCCESS at `582f6e232c0f99b80640aff3fa34cc4eadbba539`. |
| P2-003A | CLOSED | Provider authority/config preflight | Pure-Dart authority/config evidence validators and CI preflight. Run 23 SUCCESS at `31729dc793c95ebaa9af55d60544f8a8bc52b2ea`; final combined closure Run 25 SUCCESS at `d8c100e8204b5b0bef85190bab8e0cf82043a923`. |
| P2-005A | CLOSED | Battle encounter authority decision prep | `docs/release/BATTLE_ENCOUNTER_AUTHORITY_DECISION_PACKET_20260924.md` separates locked battle behavior from the still-missing first production encounter authority. No enemy, target, reward, unlock, balance number, or content source was invented. |
| P2-006A | CLOSED | Physical-device evidence intake prep | Existing labelled-corpus gate, evidence schema, exact-build binding and final-review mechanism are sufficient repository infrastructure. Real-human/device proof remains external. |
| P2-007A | CLOSED | Exact release-candidate gate wiring | `.github/workflows/actirune-production-readiness.yml` now checks out the exact selected `${{ github.sha }}` instead of a hard-coded integration branch. Permanent closeout CI guards this contract. |
| P2-008A | CLOSED | Store submission evidence preflight | Typed Apple/Google store evidence contract, tests, fail-closed template, CLI validator, documentation and CI preflight exist. Conditional requirements begin `undecided`; rejected review cannot become green; credentials/secrets are unsupported. |
| P2-001 | BLOCKED_EXTERNAL | Final Android/iOS application identity authority | Android namespace/applicationId and iOS Runner bundle id remain `com.example.actirune`. No final production package/bundle decision is authoritative. |
| P2-002 | BLOCKED_EXTERNAL | Android/iOS production signing ownership | Android release still uses debug signing; no authoritative Apple Development Team/signing evidence exists. Requires P2-001 first. |
| P2-003 | BLOCKED_EXTERNAL | Production provider authority lock | Firebase + RevenueCat + Google Mobile Ads + Firebase Analytics/optional BigQuery remains a recommendation, not authority. Requires real owner/account decisions. |
| P2-004 | BLOCKED_EXTERNAL | Real provider configuration | Requires real provider projects/apps/products/ad units/analytics transport plus non-secret audit evidence. |
| P2-005 | BLOCKED_EXTERNAL | First production Battle encounter/content authority | Runtime Battle remains intentionally fail-closed until an owner-approved encounter record supplies encounter identity, unlock/eligibility, movement, target/duration, combat semantics, reward and versioned runtime content owner. |
| P2-006 | BLOCKED_EXTERNAL | Real-human physical-device ML Kit release evidence | Requires labelled physical-device corpus for Squat/Lunge/Push-up/Plank against an exact release build plus final human review. |
| P2-007 | BLOCKED_EXTERNAL | Exact release-candidate gate execution | Gate wiring is ready; execution as a release PASS requires P2-001..P2-006 to be legitimately satisfied and an exact candidate HEAD/build to exist. |
| P2-008 | BLOCKED_EXTERNAL | Store candidate/submission/review evidence | Store evidence tooling is ready; actual signed artifacts, console records, submission references and review states require the real release candidate and store-side actions. |

## Current production truth

### Identity

Android currently remains:
- namespace: `com.example.actirune`
- applicationId: `com.example.actirune`
- MainActivity package: `com.example.actirune`
- release signing: debug signing

Apple/iOS currently remains:
- Runner bundle id: `com.example.actirune`
- RunnerTests derives from the placeholder app id
- no authoritative `DEVELOPMENT_TEAM` is established in repository evidence

`com.actirune.app` is a candidate/test fixture only. It is not production authority.

Identity decision packet:
- `docs/release/PRODUCTION_IDENTITY_DECISION_PACKET_20260924.md`

### Battle runtime

Production `/app` constructs `MainShell` without `battleRootBuilder`, so Battle stays unavailable by design. That is correct fail-closed behavior while P2-005 is unresolved.

Locked product behavior already defines the canonical battle flow and the four verified movement roles. It does **not** authorize promoting Product Bible examples such as Stone Golem/wolf fixtures into the first production encounter.

Decision packet:
- `docs/release/BATTLE_ENCOUNTER_AUTHORITY_DECISION_PACKET_20260924.md`

### Physical-device validation

Repository evidence intake is prepared in:
- `docs/release/PHYSICAL_DEVICE_MLKIT_VALIDATION_GATE.md`
- `validation/physical_device_mlkit/`
- `validation/release/physical_final_review.template.json`

Synthetic tests, emulator output and CI logs do not satisfy P2-006.

### Exact candidate gate

Production Readiness is manual by design and now evaluates the exact selected workflow SHA:
- `.github/workflows/actirune-production-readiness.yml`

The production-closeout validation workflow prevents reintroducing the old hard-coded integration checkout.

### Store evidence

Persistent files:
- `lib/core/release/store_submission_evidence.dart`
- `test/store_submission_evidence_test.dart`
- `tool/validate_store_submission_evidence.dart`
- `validation/release/store_submission.template.json`
- `docs/release/STORE_SUBMISSION_EVIDENCE_GATE_20260924.md`

The store evidence gate binds records to exact release Git commit/build and authoritative Android/iOS identity. It fails closed for identity mismatch, incomplete required declarations, undecided conditional requirements, missing submission references, rejected review, malformed evidence, and unsupported secret fields.

## Repository-safe production preparation evidence

Key recent commits:
- exact-SHA Production Readiness checkout: `48bcde8b4894d3b5020a50a8d8666ec2bba30f7c`
- permanent exact-SHA guard: `a48d5c7c2a4913161605ae9daa9c070eec5ca35a`
- store evidence contract: `e5f6af12c5acd76a88c6b8979a776f3b9123a267`
- hardened store semantics: `e7d24c025a13772678261966b742fd58a63ef19a`
- store evidence regression coverage: `822ef6b2a4ee136198ae67492868daf5f8086a77`
- store evidence validator: `d7b02901641d6ba6cb2b43e6850d7d232948c83b`
- explicit unresolved-requirement semantics: `56ac66f950c8b67e15c115b8d0e0983d36c375f4`
- store evidence template: `44ab877e7b591cdc992193418006412cab9aeecc`
- store evidence documentation: `c52e7b73e4ff3d65233ca4a624eb13e9be2cbf72`
- CI store preflight: `aa98b1b0d7d88df3ce84494f873b9c89820fcdfa`
- battle authority decision packet: `2e3e425abb842bee3d891e1a9cbd1e2b9f289493`
- canonical store evidence formatting: `adb636a3c9ba1c037e440fca491398eaedb0cfe3`
- temporary store formatter removed: `c95802b856e8b8e6d9f52e7ba6b162c4a93cfe75`

Validation history for this final repository-safe batch:
- Run 32 proved exact-SHA checkout contract but stopped only because `store_submission_evidence.dart` needed canonical Dart formatting; analyzer/store behavior had not yet run.
- The one-file formatter produced `adb636a3c9ba1c037e440fca491398eaedb0cfe3`; the temporary formatter was then removed.
- **Self-validating closure rule:** P2-007A and P2-008A are CLOSED only if `ActiRune Production Closeout Validation` attached to this exact ledger-closure commit concludes SUCCESS. Any failure automatically reopens the affected preparation item and must be fixed before claiming repository-safe preparation complete.

## Provider recommendation boundary

Current recommendation remains:
- Firebase for backend/Auth/Firestore/Functions/App Check
- RevenueCat for Pro subscriptions/entitlements
- Google Mobile Ads / AdMob for rewarded ads
- Firebase Analytics with optional BigQuery export

This remains `RECOMMENDED / NOT YET LOCKED`.

## Dependency chain

`P2-001 identity -> P2-002 signing -> P2-003 provider authority -> P2-004 provider configuration -> P2-006 physical release evidence -> P2-007 exact release gate -> P2-008 store candidate/submission`

P2-005 Battle encounter/content authority is a separate owner/content dependency and may be resolved in parallel once authoritative content exists.

## Current checkpoint

`BASE=034305744735afd9fef93488e7a81b73d87db7c0 | LAST_CLOSED=P2-008A | ACTIVE=none | FIRST_BLOCKER=P2-001 | NEXT_AFTER_AUTHORITY=P2-002`

## Hard boundary

All currently discoverable **repository-safe** production preparation is exhausted after the self-validating closure above. The remaining queue is intentionally blocked on real owner/provider/device/store/content authority. No platform identity, signing owner, provider project/account, product id, price, ad-unit id, credential, physical-device result, Battle encounter value, store submission or review result may be guessed merely to turn the ledger green.
