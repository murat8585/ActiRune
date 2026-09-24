# ActiRune Store Submission Evidence Gate

Date: 2026-09-24
Status: `BLOCKED_EXTERNAL_PROOF` until real Apple App Store Connect and Google Play Console evidence exists.

## Purpose

This gate records non-secret, auditable evidence for the exact release candidate that is prepared for Apple App Review and Google Play review. It does not submit the app, choose production identifiers, create signing material, choose product pricing, or store provider/store credentials.

The repository template is:

`validation/release/store_submission.template.json`

When real evidence exists, copy it to:

`validation/release/store_submission.json`

and validate it with:

`dart run tool/validate_store_submission_evidence.dart`

## Exact-candidate binding

Every record must bind to:

- the exact 40-character release Git commit,
- the exact release build,
- the authoritative Android application id,
- the authoritative iOS bundle identifier.

The application identifiers must match `validation/release/provider_authority.json`. A store record for a different identity is rejected.

## Apple evidence

Record only non-secret audit references for:

- the App Store Connect app record,
- the selected build for the submitted app version,
- completion of required version metadata,
- completion of App Privacy information,
- an explicit export-compliance disposition (`complete` or `notRequired`),
- reviewer access/instructions when required,
- readiness of monetization items that belong with the release,
- normalized review state,
- an auditable submission reference after submission.

Apple requires required metadata and a selected build before an app version is submitted for review. Export-compliance determination must also be resolved for the build/app where applicable. This repository records only the resulting non-secret evidence; it does not store App Store Connect credentials or perform submission.

## Google Play evidence

Record only non-secret audit references for:

- the Play Console app record,
- the exact uploaded release artifact,
- Play App Signing verification,
- completed store listing,
- completed App content declarations,
- completed Data safety information,
- reviewer access instructions when required,
- an explicit production-access disposition (`complete` or `notRequired`),
- readiness of monetization items that belong with the release,
- normalized review state,
- an auditable submission reference after submission.

Google Play requires app/developer and policy information to be complete before review. The App content area includes declarations such as privacy policy, ads, app access and target-audience/content information. Some personal developer accounts are also subject to production-access testing requirements; the template therefore starts this field as `undecided` rather than guessing that it does or does not apply.

## Review-state normalization

Allowed normalized values are:

- `notSubmitted`
- `submitted`
- `inReview`
- `approved`
- `rejected`

A rejected review never counts as valid submission evidence. A submitted/in-review/approved state requires a non-secret submission reference.

## Secret boundary

Never store:

- App Store Connect API private keys or JWT material,
- Google Play service-account JSON or access tokens,
- signing private keys, certificates or passwords,
- RevenueCat/AdMob/provider secret keys,
- reviewer account passwords.

References may be stable console ids, ticket ids, change ids, build ids or other non-secret audit handles.

## Gate semantics

- `READY_FOR_STORE_SUBMISSION`: all pre-submission evidence is complete but one or both stores are still `notSubmitted`.
- `STORE_SUBMISSION_EVIDENCE_VALID`: both store records have non-rejected submitted/in-review/approved states with auditable submission references.
- Any identity mismatch, missing declaration, undecided conditional requirement, rejected state or malformed evidence fails closed.

This gate is repository preparation only. Actual signing, artifact upload, store submission and store review remain external release actions.
