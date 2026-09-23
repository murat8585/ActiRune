# ActiRune Production Provider Decision Record

Date: 2026-09-23 (Europe/Istanbul)
Status: RECOMMENDED / NOT YET LOCKED
Branch authority: `integration/artwork-interactions-20260921`

## Decision boundary

This record selects the lowest-friction production provider candidates for ActiRune's current Flutter/iOS/Android architecture. It does **not** authorize SDK installation, account creation, store product creation, credential changes, production deploys, or secret commits.

Provider configuration must wait until the final Android application id, iOS bundle id, signing ownership, and provider accounts are authoritative.

## Recommended production stack

| Capability | Recommended provider | Current repository state | Decision |
|---|---|---|---|
| App/backend platform | Firebase | Absent | Preferred candidate |
| Authentication | Firebase Authentication | Absent | Preferred candidate |
| Player/economy persistence | Cloud Firestore behind Security Rules/server authority | Absent | Preferred candidate |
| Server-authoritative mutations | Cloud Functions/callable endpoints | Absent | Preferred candidate |
| App attestation | Firebase App Check | Absent | Required with Firebase production rollout |
| Pro subscriptions/entitlements | RevenueCat | UI/callback contract only | Preferred candidate |
| Rewarded ads | Google Mobile Ads / AdMob | Product policy only | Preferred candidate |
| Product analytics | Firebase Analytics | Typed `AnalyticsSink` only | Preferred candidate |
| Deeper analytics warehouse | BigQuery export from Firebase | Absent | Optional after event delivery is verified |
| Health data | Android Health Connect + Apple HealthKit | Absent | Deferred; only integrate if approved release scope remains |

## Why Firebase is ranked first for ActiRune

1. ActiRune is already a Flutter application targeting Android and iOS. Firebase has an official Flutter setup path through FlutterFire.
2. The current repository has no backend schema or cloud provider to migrate away from, so provider lock-in cost is currently lowest.
3. Authentication, Firestore, Functions, App Check, Analytics, Crashlytics/Remote Config can live under one operational project instead of creating several unrelated security boundaries.
4. Firestore mobile/web requests can be protected by Firebase Authentication + Security Rules. Server/Admin access must use IAM rather than assuming client rules protect server credentials.
5. App Check adds application-attestation protection and should be enabled before production data/reward endpoints are trusted.
6. Existing ActiRune policy objects already separate client presentation from authoritative mutations, so Firebase can be placed behind repositories/functions instead of inside UI widgets.

### Firebase alternative: Supabase

Supabase is a credible second choice. Its official Flutter library exposes Postgres, Auth, Realtime, Storage and Edge Functions, and its Data API can be protected with Row Level Security.

It ranks second for this repository because ActiRune currently has no relational schema that requires Postgres, while the recommended monetization/analytics stack already contains Google services. Choosing Supabase would be reasonable if SQL ownership, relational reporting or provider portability becomes a stronger product requirement than minimum integration surface.

No Firebase or Supabase package should be added until the backend choice is explicitly locked.

## Why RevenueCat is ranked first for Pro billing

The existing `ProPaywallScreen` intentionally owns no purchase, trial, entitlement, pricing or success state. It exposes only callbacks. This is the correct seam for a provider-neutral billing gateway.

RevenueCat's official Flutter SDK supports native store subscriptions and centralizes entitlements. ActiRune can therefore keep one internal concept such as `pro` entitlement while Apple/Google product identifiers remain provider configuration rather than gameplay/UI constants.

### RevenueCat alternative: direct store billing

Direct Apple StoreKit + Google Play Billing is viable but increases platform-specific purchase lifecycle, receipt/token verification, backend notification and entitlement synchronization work. Google explicitly recommends/uses a secure backend for purchase verification and subscription management. For a two-platform Flutter V1, RevenueCat is therefore the lower-risk integration path unless avoiding the external billing-management service becomes a stronger requirement.

No RevenueCat SDK, product id, trial period or price is authoritative yet.

## Why Google Mobile Ads / AdMob is ranked first for rewarded ads

ActiRune already has a provider-neutral `RewardedAdPolicy`. It decides whether a placement is eligible and refuses to grant a non-Pro reward unless an external ad reports completion.

Google's official Flutter rewarded-ad integration exposes load/show lifecycle callbacks and `onUserEarnedReward`, with optional server-side verification (SSV). This maps cleanly to ActiRune's existing policy boundary.

Production rules:
- Development must use test ad units.
- Ad load/show success must never equal reward success.
- Only the earned/completed outcome may flow into `RewardedAdPolicy.rewardMayApply`.
- High-value or abuse-sensitive rewards should use server-authoritative verification/SSV before persistence.
- Ad unit ids are environment configuration, never gameplay constants.
- Ranked PvP rewarded revive remains prohibited by ActiRune policy regardless of provider capability.

## Why Firebase Analytics + BigQuery is ranked first

ActiRune already has a typed provider-neutral `AnalyticsSink` and event families. Firebase Analytics has an official Flutter SDK and can export supported analytics data to BigQuery for deeper analysis.

The provider adapter must translate typed ActiRune events to provider event names/parameters. Gameplay code must continue emitting typed domain events rather than importing `firebase_analytics` throughout the app.

No user identity, advertising identifier, health data, raw pose frame, camera image or sensitive data should be added to analytics merely because the provider can accept it.

## Required security architecture

### Client is not reward/economy authority

The client may request an action, render a result, or cache display state. It must not become authoritative for:
- Pro entitlement grants,
- paid purchase verification,
- rewarded-ad inventory/currency grants,
- anti-abuse reward history,
- server-owned loot/economy mutations,
- competitive/ranked outcomes.

### Firebase production baseline if selected

- Firebase Authentication for user identity where authenticated ownership is required.
- Cloud Firestore Security Rules with deny-by-default/least-privilege policies.
- Local Emulator Suite tests for security rules before deployment.
- Cloud Functions/server authority for sensitive mutations.
- Firebase App Check enabled and enforced for protected production resources after client rollout is verified.
- Server/Admin credentials kept out of the mobile repository.

### RevenueCat production baseline if selected

- Store products configured in Apple/Google stores first.
- RevenueCat products/offerings mapped to one internal Pro entitlement contract.
- Entitlement status, not a local boolean toggle, controls Pro access.
- Webhook/server validation should feed authoritative backend state where server-owned features depend on Pro.
- Public mobile SDK keys may be configured through normal platform configuration; private/admin secrets never ship in the app.

### Rewarded ads production baseline if selected

- Test units in development and CI/manual test builds.
- Production units only in production configuration.
- Reward granted only after the earned/completed signal accepted by ActiRune policy.
- Use server-side verification for rewards that mutate authoritative cloud economy or abuse-sensitive state.

## Repository integration order

1. Finalize Android application id and iOS bundle id.
2. Finalize Android/iOS signing ownership using protected secrets, not repository plaintext.
3. Lock the backend provider and create separate development/production projects/environments.
4. Add Firebase core/auth/App Check first if Firebase is selected; prove startup and attestation before persistence.
5. Add persistence/functions behind provider-neutral repositories; do not place Firestore calls in widgets or combat logic.
6. Add RevenueCat behind a provider-neutral Pro entitlement/billing gateway.
7. Add Google Mobile Ads behind a provider-neutral rewarded-ad gateway and keep `RewardedAdPolicy` as the product authority.
8. Add Firebase Analytics as an `AnalyticsSink` adapter, then validate event mapping before enabling BigQuery export.
9. Execute real physical-device ML Kit corpus validation against an exact release commit/build.
10. Run Production Readiness guard and full Direct Validation before any store candidate is called release-ready.

## Current no-go list

Until provider/account/product authority exists, do not:
- add fake Firebase config files,
- invent a Firebase project id,
- invent RevenueCat API keys or entitlement/product ids,
- invent AdMob app/ad-unit ids,
- invent subscription pricing or trial duration,
- mark purchase/ad callbacks successful in mocks used by production runtime,
- commit signing certificates, keystores, private keys or admin credentials,
- treat CI/unit tests as physical-device ML Kit proof.

## Official evidence reviewed on 2026-09-23

- Firebase for Flutter setup: https://firebase.google.com/docs/flutter/setup
- Cloud Firestore Security Rules: https://firebase.google.com/docs/firestore/security/get-started
- Firebase App Check for Flutter: https://firebase.google.com/docs/app-check/flutter/default-providers
- Firebase Analytics for Flutter: https://firebase.google.com/docs/analytics/flutter/get-started
- Firebase to BigQuery export: https://firebase.google.com/docs/projects/bigquery-export
- RevenueCat Flutter installation: https://www.revenuecat.com/docs/getting-started/installation/flutter
- RevenueCat Entitlements: https://www.revenuecat.com/docs/getting-started/entitlements
- Google Play Billing architecture: https://developer.android.com/google/play/billing/
- Google Mobile Ads rewarded ads for Flutter: https://developers.google.com/admob/flutter/rewarded
- Supabase Flutter reference: https://supabase.com/docs/reference/dart/introduction
- Supabase Flutter quickstart / RLS: https://supabase.com/docs/guides/getting-started/quickstarts/flutter

## Status

Recommended stack: **Firebase + RevenueCat + Google Mobile Ads + Firebase Analytics/BigQuery**.

This is an evidence-backed architecture recommendation, not a provider/account authorization. The next safe code step is to add provider-neutral billing and rewarded-ad gateway contracts behind the already-verified UI/policy boundaries, without installing provider SDKs.
