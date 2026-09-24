# ActiRune Production Signing Preflight

Date: 2026-09-24 (Europe/Istanbul)
Branch: `production/closeout-20260924`
Status: `P2-002A = CLOSED / REPOSITORY-SAFE PREP`

## Purpose

Prepare production signing safety without inventing or committing any real signing owner, key, certificate, provisioning profile, password, secret, Apple Team ID, or provider credential.

This work does **not** close `P2-002`. Real Android/iOS signing ownership remains blocked behind the final application identity (`P2-001`) and real owner/account authority.

## Guarded requirements

Persistent implementation:
- `lib/core/release/production_signing_hygiene_guard.dart`
- `test/production_signing_hygiene_guard_test.dart`
- `tool/check_production_signing_preflight.dart`
- `.github/workflows/actirune-production-closeout-validation.yml`

The signing preflight fails closed when:
- Android release signing is missing;
- Android release signing still uses the debug signing config;
- the iOS Development Team is missing;
- an iOS Team ID is present but not a 10-character alphanumeric identifier;
- required signing/secret ignore patterns disappear from `.gitignore`;
- signing material such as `.jks`, `.keystore`, `.p12`, `.mobileprovision`, `.env*`, or `key.properties` is tracked by Git.

The CLI reads only repository text metadata and tracked path names. It does not read secret/signing-material file contents.

## Current repository truth

Expected current result is `BLOCKED`, specifically because:
- Android release still points to debug signing;
- no authoritative Apple Development Team exists yet.

Expected hygiene result is clean:
- signing material ignore coverage is present;
- no tracked signing material is accepted by CI.

## Validation history

- Initial persistent workflow Run 17 reached canonical formatting and stopped because only `test/production_signing_hygiene_guard_test.dart` required formatter output. No analyzer/test/preflight result was falsely treated as success.
- Canonical formatter commit: `9a641c282b49fb65c2739f511fa732edba4cc878`.
- Temporary formatter removed at `a089337499b28c4cf0a65c7d27fc75100e7f12e2`.
- Post-cleanup checkpoint commit: `65572971ef00685792dfd91536fd6f30db059945`.
- Production Closeout Validation Run 18 SUCCESS on that exact checkpoint.

Run 18 proved:
- exact checkout PASS;
- package-aware formatting PASS;
- analyzer PASS;
- identity + release + signing hygiene regression tests PASS;
- real repository signing preflight PASS as tooling while correctly reporting current signing state `BLOCKED` for Android debug signing and missing Apple Team authority;
- no tracked signing material detected;
- `.gitignore` signing/secret coverage intact;
- dry-run identity migration planner PASS;
- unified production identity/release gate PASS as tooling while real production authority remains intentionally blocked.

## Self-validating closure rule

`P2-002A` is CLOSED only while `ActiRune Production Closeout Validation` attached to the exact commit containing this closure also concludes SUCCESS. A failure automatically reopens P2-002A.

## External boundary

`P2-002` remains `BLOCKED_EXTERNAL` until the owner provides real production signing authority after `P2-001` identity is locked.
