# ActiRune Production Signing Preflight

Date: 2026-09-24 (Europe/Istanbul)
Branch: `production/closeout-20260924`
Status: `P2-002A = IN_PROGRESS / REPOSITORY-SAFE PREP`

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

Expected hygiene result remains clean:
- signing material ignore coverage is present;
- no tracked signing material may be accepted by CI.

## Validation history

- Initial persistent workflow run 17 reached canonical formatting and stopped because only `test/production_signing_hygiene_guard_test.dart` required formatter output. No analyzer/test/preflight result was falsely treated as success.
- Canonical formatter commit: `9a641c282b49fb65c2739f511fa732edba4cc878`.
- Temporary formatter removed at `a089337499b28c4cf0a65c7d27fc75100e7f12e2`.

## Closure rule

`P2-002A` may be marked `CLOSED` only when `ActiRune Production Closeout Validation` succeeds on an exact post-cleanup checkpoint commit and proves:
- formatting PASS;
- analyzer PASS;
- identity/release/signing regression tests PASS;
- real repository signing preflight executes successfully while reporting the expected external blockers;
- no tracked signing material is detected;
- `.gitignore` signing coverage remains complete;
- identity migration planner and unified production gate remain green as tooling while the real repository remains production-blocked where authority is absent.

## External boundary

`P2-002` remains `BLOCKED_EXTERNAL` until the owner provides real production signing authority after `P2-001` identity is locked.
