# ActiRune Canonical Production Identity Audit

Date: 2026-09-23 (Europe/Istanbul)
Status: COMPLETE / EXTERNAL DECISION REQUIRED

## Purpose

Prevent a historical prototype package id, placeholder id, or unrelated project identity from becoming ActiRune's production Android/iOS identity by accident.

## Sources checked

- Current integration branch platform configuration.
- Repository default-branch code search for ActiRune/package/Firebase indicators.
- Repository commit-message search for bundle/Firebase/RevenueCat/AdMob decisions.
- Repository branch-name search for production/provider-specific branches.
- Available ActiRune project-history artifact evidence from prior work.

## Findings

### Current Android identity

Current integration configuration remains:

`com.example.actirune`

This is a Flutter placeholder namespace and is already blocked by `ProductionReleaseGuard`.

### Current iOS identity

Current integration configuration remains:

`com.example.actirune`

No authoritative `DEVELOPMENT_TEAM` value exists in current repository evidence. This is already blocked by `ProductionReleaseGuard`.

### Historical prototype identity

A prior ActiRune project-history artifact contains:

`com.example.actirune_canonical_visual_prototype`

with a matching prototype `MainActivity`.

This identifier belongs to a historical/canonical **visual prototype APK**. It is not evidence of a production package-name decision. The `com.example.*` namespace also independently marks it as non-production for the release guard.

### Provider identity/history

No authoritative historical repository/project decision was found that locks any of the following for ActiRune production:

- Firebase project/app identity,
- RevenueCat project/API configuration,
- AdMob app/ad-unit identity,
- Supabase project identity,
- Apple Development Team/Team ID,
- App Store Connect application identity,
- final Google Play package name,
- final iOS bundle identifier.

## Explicit exclusions

Do not reuse identities from Aile Güvende/Kinola or any other application. Those are unrelated products and are not ActiRune authority.

Do not promote either of these placeholders to production:

- `com.example.actirune`
- `com.example.actirune_canonical_visual_prototype`

Do not create Firebase/RevenueCat/AdMob production configuration against a placeholder package/bundle id, because changing store identity later can create unnecessary project/app-registration migration work.

## Decision state

Production identity is **not yet canonical**.

No production identifier change is applied by this audit.

A reasonable naming candidate may be evaluated later, but it must remain a proposal until the owner makes the production identity authoritative. Provider SDK bootstrap should wait for that identity because Firebase app registration, store products, RevenueCat app mapping and AdMob app registration are platform-identity-sensitive.

## Release-gate consequence

The current state remains correctly blocked:

- Android production identity/signing: BLOCKED.
- iOS production identity/signing: BLOCKED.
- Provider production bootstrap: BLOCKED_BY_IDENTITY_AUTHORITY.

The repository can continue with provider-neutral contracts, validation tooling and physical-device evidence infrastructure without inventing these identifiers.
