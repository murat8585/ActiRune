# ActiRune Production Identity Decision Packet

Date: 2026-09-24 (Europe/Istanbul)
Branch: `production/closeout-20260924`
Status: DECISION PACKET READY / NOT AUTHORITATIVE

## Why this decision is first

ActiRune is at the first legitimate production boundary: the Android application ID and iOS bundle identifier must be locked before production signing, Firebase app registration, store app records, RevenueCat app mapping, AdMob app registration, and release evidence can be made authoritative.

This packet does not change platform identifiers. It exists so the owner can make one deliberate decision instead of allowing a Flutter placeholder or historical prototype id to escape into production.

## Current repository truth

Android:
- namespace: `com.example.actirune`
- applicationId: `com.example.actirune`
- MainActivity package: `com.example.actirune`
- release signing currently points at the debug signing config

iOS:
- Runner bundle identifier: `com.example.actirune`
- no authoritative `DEVELOPMENT_TEAM` value is present in repository evidence

Historical prototype id:
- `com.example.actirune_canonical_visual_prototype`
- visual-prototype history only
- must not be promoted to production

## Current platform constraints

### Android

Android's official guidance treats `applicationId` as the unique app identity on-device and in Google Play. After publication, changing it makes Google Play treat the upload as a different app. Android also recommends keeping namespace and application ID the same unless there is a specific reason not to.

### Apple

Apple requires the app's bundle identifier to match the Xcode/App Store Connect identity. After a build is uploaded to App Store Connect, the bundle ID cannot be changed for that app record.

### Firebase

Firebase's Android registration uses the actual Android package/application ID. Firebase documents that the registered Android package name is case-sensitive and cannot be changed for that Firebase Android app after registration.

Therefore provider bootstrap must remain behind this identity decision.

## Naming rule

Prefer one stable reverse-DNS identifier for Android and iOS when practical. The identifier should:
- be suitable for the full lifetime of ActiRune;
- avoid `com.example.*`;
- avoid another product's/company's namespace unless ActiRune is actually owned under that namespace;
- remain independent of temporary release channels, countries, languages, pricing, Pro status, or version numbers;
- use a namespace/domain controlled by the owner when possible.

## Candidate patterns — proposals only

These are syntax/product-shape proposals, not availability claims and not authority:

1. `com.actirune.app`
   - clean product-level identity;
   - suitable if the owner controls the `actirune` namespace/domain strategy;
   - currently used only as synthetic positive evidence inside release-guard tests, which does **not** make it production authority.

2. `com.actirune.game`
   - also product-level and stable;
   - slightly more category-specific than `.app`.

3. `<owner-controlled-reverse-dns>.actirune`
   - strongest namespace-ownership model when the owner has an established company/domain namespace;
   - example structure only; do not substitute a guessed company/domain.

Package/store availability is not proven by this document. Absence from a web search is not sufficient evidence that a package/bundle identifier is available or owned.

## Recommended decision shape

Lock these two values explicitly:

```text
ANDROID_APPLICATION_ID=<final value>
IOS_BUNDLE_IDENTIFIER=<final value>
```

Using the same value for both is preferred for operational simplicity unless an Apple/Google namespace constraint creates a real reason to differ.

## Exact repository changes after authority exists

Once the owner explicitly locks the identifiers, the implementation batch should update only identity-dependent files first:

Android:
- `android/app/build.gradle.kts` namespace
- `android/app/build.gradle.kts` applicationId
- `android/app/src/main/kotlin/.../MainActivity.kt` package/path as required

iOS:
- Runner `PRODUCT_BUNDLE_IDENTIFIER` values in `ios/Runner.xcodeproj/project.pbxproj`
- dependent test-target identifier(s) derived from the Runner id

Then:
1. run formatting/analyzer/tests and `ProductionReleaseGuard` regressions;
2. verify no `com.example.actirune` runtime/platform identity remains except intentional historical/test evidence;
3. only then proceed to production signing ownership;
4. only after signing/identity authority proceed to Firebase/provider app registration.

Do not create Firebase/RevenueCat/AdMob production app registrations against the current placeholder identity.

## Official references checked on 2026-09-24

- Android Developers — Configure the app module / application ID:
  https://developer.android.com/build/configure-app-module
- Android Developers — Prepare your app for release:
  https://developer.android.com/studio/publish/preparing
- Apple Developer — `CFBundleIdentifier`:
  https://developer.apple.com/documentation/bundleresources/information-property-list/cfbundleidentifier
- Apple Developer — App information / Bundle ID:
  https://developer.apple.com/help/app-store-connect/reference/app-information/app-information
- Firebase — Add Firebase to your Android project:
  https://firebase.google.com/docs/android/setup

## Current decision state

`P2-001 = BLOCKED_EXTERNAL`

No platform identity file has been changed. This is intentional. The next identity mutation requires explicit owner authority for the final Android application ID and iOS bundle identifier.
