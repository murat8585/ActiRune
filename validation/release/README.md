# ActiRune release authority and evidence records

This directory stores non-secret, auditable **production release** authority/evidence metadata. It must never become a convenient dumping ground for credentials. Humans have invented password managers for a reason.

> This directory is not the Phase-1 internal closeout queue. Internal repository completion is governed by repository-root `PHASE1_CLOSEOUT.md` plus `ActiRune Direct Validation`. The checks described below deliberately remain blocked until real production identity, provider configuration and physical-device evidence exist. A blocked production-readiness result does not by itself reopen an internally closed P1 item.

## 1. Provider authority lock

`provider_authority.template.json` is deliberately invalid until the product owner has made the production provider and application-identity decisions authoritative.

After those decisions exist, copy the template to:

`validation/release/provider_authority.json`

Fill only these non-secret authority fields:

- `androidApplicationId`
- `iosBundleIdentifier`
- `backendProvider`
- `billingProvider`
- `rewardedAdsProvider`
- `analyticsProvider`

Then run:

```text
dart run tool/validate_provider_authority_lock.dart
```

The validator fails closed when the authority is missing/malformed, provider names remain placeholders, either app id uses `com.example.*`, or locked ids differ from the real Android/iOS platform files.

`PROVIDER_AUTHORITY_LOCK_VALID` proves only that provider choice and platform identities are explicit and match repository platform configuration. It does not prove SDK/provider-console configuration.

## 2. Provider configuration evidence

After authority is locked and the real providers are configured, copy:

`provider_configuration.template.json`

to:

`validation/release/provider_configuration.json`

For backend, billing, rewarded ads and analytics, record:

- the exact provider name from the authority lock,
- a non-secret public/project/app reference suitable for audit,
- whether configuration is actually complete,
- one or more verification methods:
  - `providerConsoleReadback`
  - `storeConsoleReadback`
  - `runtimeSmokeTest`
  - `automatedApiReadback`

The configuration record also repeats the locked Android/iOS application ids and release build. The validator requires provider names and app ids to match authority exactly and every required provider to be explicitly configured.

This evidence must not contain API keys, tokens, client secrets, service-account material, private keys or signing credentials. Unknown fields are rejected.

## 3. Physical-device final review

Raw physical-device evidence lives under `validation/physical_device_mlkit/` as privacy-safe metadata/results. After the real-human corpus is structurally complete and reviewed, copy:

`physical_final_review.template.json`

to:

`validation/release/physical_final_review.json`

The final review record contains:

- `disposition`: must be `passed` for release,
- `evidenceGitBlobSha`: exact Git blob SHA of the reviewed `evidence.json`,
- `reviewReference`: auditable review/ticket/change reference,
- `reviewedBuild`: exact build represented by the physical evidence.

The validator rejects a final pass when the evidence file changes, when the recorded blob SHA is malformed, when evidence contains multiple build ids, or when the reviewed build differs from the physical corpus build. This prevents an old physical approval from quietly hitchhiking onto a different build.

Get the evidence blob SHA with:

```text
git hash-object validation/physical_device_mlkit/evidence.json
```

Do not store raw personal video, subject real names or biometric identifiers in this release record.

## 4. Unified Phase-1 production readiness check

Run:

```text
dart run tool/check_phase1_production_readiness.dart
```

The checker evaluates all repository-declared **production** gates together:

- Android/iOS production application identity and signing,
- provider authority lock,
- provider configuration evidence,
- physical-device evidence completeness,
- physical final review bound to the exact evidence blob/build,
- aggregate production release blockers.

It exits non-zero while any represented production gate remains unresolved. With the repository's current placeholder identities and absent real evidence files, a non-zero result is expected and correct; do not weaken the gate to manufacture a green result for internal closeout.

A successful result still does not replace Apple/Google store review, credential/signing provenance or provider-console/live-service evidence that exists outside the repository.

## 5. Internal-versus-production checkpoint

Use these sources for the two separate questions:

- **Is Phase-1 repository work internally closed?** Read `PHASE1_CLOSEOUT.md` and the latest `ActiRune Direct Validation` evidence.
- **Is the product ready for production distribution?** Use this directory, `Phase1ReleaseReadiness`, the production-readiness workflow, provider/platform readbacks and real-device/store evidence.

Neither answer may be substituted for the other.

## Secret boundary

Never add API keys, tokens, client secrets, service-account JSON, private keys, signing credentials, ad-unit credentials, RevenueCat keys or other private provider credentials to these JSON records. Production secrets belong in protected provider/CI secret stores, not Git history, because Git remembers human mistakes with unsettling enthusiasm.
