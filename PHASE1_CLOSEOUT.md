# ActiRune Phase-1 Closeout Ledger

Updated: 2026-09-24 (Europe/Istanbul)
Authority branch: `integration/artwork-interactions-20260921`
Baseline before ledger: `7484d52474203720f95ec063bd86465c693a7fd1`
Purpose: prevent repeated audits and make Phase-1 completion monotonic and evidence-driven.

## Authority and recovery rule

This file is the authoritative ordered work queue for Phase-1 closeout.

At the start of every ActiRune work session:
1. Read the current branch HEAD.
2. Read this file.
3. Resume the single `IN_PROGRESS` item, or if none exists, take the first `TODO` item in numeric order.
4. Do not choose work from an older audit, chat summary, run number, or historical handoff when it conflicts with this ledger.
5. `CURRENT_PROGRESS.md` remains a technical evidence/checkpoint record; it does not override this queue.

## State machine

Allowed forward states:

`CANDIDATE -> TODO -> IN_PROGRESS -> VERIFIED -> CLOSED`

Exceptional states:

- `BLOCKED_EXTERNAL`: requires real external authority/evidence and is not an internal implementation target.
- `REOPENED`: allowed only with new concrete evidence.

Rules:
- Only one Phase-1 item may be `IN_PROGRESS` at a time.
- Do not start the next item until the active item is `CLOSED` or legitimately `BLOCKED_EXTERNAL`.
- A `CLOSED` item must not be re-audited or reimplemented merely because a later chat/session does not remember it.
- Reopening requires one of: a reproducible failing regression, a verified runtime defect, an authoritative product-contract change, or an explicit owner scope change.
- A new issue discovered while closing an item is appended once with evidence. It does not trigger a repository-wide re-audit.
- Run numbers are evidence identifiers, not progress metrics.
- Do not manufacture providers, credentials, production identities, balance numbers, encounters, rewards, physical-device evidence, or release PASS states.

## Definition of Done for an internal item

An internal item may move to `CLOSED` only when all applicable conditions are met:
1. The current HEAD proves the gap still exists before implementation.
2. The smallest authoritative runtime/domain owner is implemented or the alleged gap is disproved by current code.
3. Focused regression coverage passes.
4. Full relevant validation passes.
5. No unrelated production authority or secret is invented.
6. Closure evidence is recorded in this ledger: commit SHA, tests/validation, and concise result.

If current HEAD disproves a candidate gap, record `CLOSED — NO GAP` with evidence instead of rebuilding it.

## Frozen completed baseline

The following are not open work merely because older audit documents mention them:
- Daily/Weekly Quest Engine: verified in current progress history.
- First Calibration deterministic owner / false-success protection: verified in current progress history.
- Four movement detector chain and typed `VerifiedRep -> BattleSession/Combat` routing: verified through Direct Validation Run 248.
- Dynamic Difficulty, Recovery/Safety, Loot/Crafting policy, Rewarded Ads policy, analytics contract, release guards, provider-neutral billing/ad gateways and release-evidence scaffolding: already verified repository scope.

These areas may reopen only under the `REOPENED` rule above.

## Ordered closeout queue

| ID | Status | Scope | Closure target |
|---|---|---|---|
| P1-001 | CLOSED | Flexible Activity integration truth | Verified staging implementation was integrated without its temporary workflow. Runtime `8aaab7130dacf829711f2cef2832f1c0db140d2b`; regression coverage `30f9d5b0614f69138f1da28596db0b218ef4e2cb`; Direct Validation Run 251 SUCCESS at `30f9d5b0614f69138f1da28596db0b218ef4e2cb`. |
| P1-002 | CLOSED | Achievement contract semantics | Proven gap: signal equality was checked but category-to-signal compatibility was not enforced. Added fail-closed category validation and regression coverage; canonical formatting applied; temporary formatter removed. Final behavioral validation: Direct Validation Run 257 SUCCESS at `f0d27780edf944ba605123f0553df36f15e12d4e`. |
| P1-003 | CLOSED | Progression ownership semantics | Four independent axes remain separate; Player Level permanence and visible-next-unlock principle are explicit; Lumi Bond source semantics and cosmetic/animation unlock are represented; Movement Mastery remains verified-movement-only and non-purchasable. Numeric balance and persistence were not invented. Direct Validation Run 259 SUCCESS at `5b58d731f0843cc683c441eecc7993633c08cf58`. |
| P1-004 | IN_PROGRESS | Production Battle encounter authority | Verify whether an authoritative encounter/content owner now exists. If absent, preserve fail-closed behavior and classify the missing authority correctly rather than fabricating content. If present, bind it through the existing typed battle root seam and validate. |
| P1-005 | TODO | Runtime route closure | Check implemented Shop, Pro, Rune Shrine, Pro Form Coach and other approved Phase-1 screens against actual `MainShell`/runtime reachability. Connect only approved missing routes and regression-test them. |
| P1-006 | TODO | Visual authority closure | Verify canonical/current/near-final/legacy/superseded classifications and runtime references. Do not regenerate art merely to satisfy bookkeeping. Close when runtime uses only approved authority or documented exceptions. |
| P1-007 | TODO | Phase-1 internal release gate | Reconcile the completed P1-001..P1-006 results with current release-gate code/docs. No broad feature re-audit. Any genuinely new internal blocker must have concrete code/test evidence. |
| P1-008 | TODO | Phase-1 internal close | Require P1-001..P1-007 closed or correctly external-blocked, Direct Validation green for final internal HEAD, and an updated recovery checkpoint. Then freeze Phase-1 internal scope. |

## Production/external queue boundary

The following do not prevent internal queue progress and must not be repeatedly rediscovered as internal TODOs:
- final Android application id;
- Android production signing;
- final iOS bundle id;
- Apple Development Team/signing;
- real Firebase/backend authority and configuration;
- RevenueCat products/entitlements/pricing;
- AdMob production app/ad units;
- analytics transport/provider configuration;
- real-human physical-device ML Kit evidence and final human review;
- protected production credentials/secrets;
- store submission/review evidence.

These belong to a separate production closeout phase after Phase-1 internal closure, unless an internal item explicitly depends on an owner-approved external decision.

## Closure evidence

### P1-001 — Flexible Activity
- Source staging workflow Run `35896215278`: format, analyzer, focused tests, full Flutter suite and diff hygiene SUCCESS.
- Integrated runtime commit: `8aaab7130dacf829711f2cef2832f1c0db140d2b`.
- Integrated test commit: `30f9d5b0614f69138f1da28596db0b218ef4e2cb`.
- Authority-branch Direct Validation: Run 251 SUCCESS at `30f9d5b0614f69138f1da28596db0b218ef4e2cb`.

### P1-002 — Achievement Contract
- Root defect confirmed from staging/current code: `AchievementDefinition.category` could disagree with its typed signal and still unlock when the evidence signal matched.
- Added category-safe fail-closed policy and explicit mismatch regression.
- Canonical formatter commit: `5508d42ce2478b06921557380b2bdb54e33db1d9`.
- Temporary formatter was removed before final validation.
- Final behavioral Direct Validation: Run 257 SUCCESS at `f0d27780edf944ba605123f0553df36f15e12d4e` including formatting, analyzer, focused interaction tests, full Flutter suite and diff hygiene.

### P1-003 — Progression Ownership
- Product Bible confirms four independent axes: Player Level, Hero Level, Lumi Bond/Level and Movement Mastery.
- Locked rules confirmed: Player Level is permanent; the next Player Level unlock must be visible; Lumi Bond grows from real consistency and quests; Lumi unlocks include support/evolution/cosmetic-animation semantics; Movement Mastery advances only from verified movement and cannot be purchased.
- Runtime semantic update: `2f709a8caa414423ba241d3736e5cb48e557aa5f`.
- Regression update: `5b58d731f0843cc683c441eecc7993633c08cf58`.
- Current `pubspec.yaml` contains no critical progression persistence/backend provider, so numeric curves and durable persistence remain outside this internal semantic owner rather than being fabricated locally.
- Direct Validation Run 259 SUCCESS at `5b58d731f0843cc683c441eecc7993633c08cf58`: formatting, analyzer, focused interaction tests, full Flutter suite and diff hygiene PASS.

## Current checkpoint

- Baseline HEAD before ledger: `7484d52474203720f95ec063bd86465c693a7fd1`.
- Last fully green behavioral Direct Validation: Run 259 at `5b58d731f0843cc683c441eecc7993633c08cf58`.
- `CURRENT_PROGRESS.md` is historical evidence and must not override this ordered ledger.
- Active item: `P1-004`.

## Session checkpoint format

Every meaningful closeout transition must update the bottom of this file with:

`BEHAVIORAL_HEAD | LAST_CLOSED | ACTIVE | NEXT | BLOCKER`

Current:

`5b58d731f0843cc683c441eecc7993633c08cf58 | LAST_CLOSED=P1-003 | ACTIVE=P1-004 | NEXT=P1-005 | BLOCKER=none`
