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
3. If Phase-1 is frozen, do not restart a broad internal audit.
4. Do not choose work from an older audit, chat summary, run number, or historical handoff when it conflicts with this ledger.
5. `CURRENT_PROGRESS.md` remains a recovery checkpoint; it does not override this ledger.

## State machine

Allowed forward states:

`CANDIDATE -> TODO -> IN_PROGRESS -> VERIFIED -> CLOSED`

Exceptional states:

- `BLOCKED_EXTERNAL`: requires real external authority/evidence and is not an internal implementation target.
- `REOPENED`: allowed only with new concrete evidence.

Rules:
- Only one Phase-1 item may be `IN_PROGRESS` at a time.
- A `CLOSED` item must not be re-audited or reimplemented merely because a later chat/session does not remember it.
- Reopening requires one of: a reproducible failing regression, a verified runtime defect, an authoritative product-contract change, or an explicit owner scope change.
- A new issue discovered after freeze is appended once with evidence; it does not trigger a repository-wide re-audit.
- Run numbers are evidence identifiers, not progress metrics.
- Do not manufacture providers, credentials, production identities, balance numbers, encounters, rewards, physical-device evidence, or release PASS states.

## Definition of Done for an internal item

An internal item may move to `CLOSED` only when all applicable conditions are met:
1. Current repository evidence proves the gap or disproves the alleged gap.
2. The smallest authoritative runtime/domain owner is implemented, or no internal code gap is demonstrated.
3. Focused regression coverage passes when behavior changes.
4. Full relevant validation passes.
5. No unrelated production authority or secret is invented.
6. Closure evidence is recorded in this ledger.

## Frozen completed baseline

The following are not open work merely because older audit documents mention them:
- Daily/Weekly Quest Engine.
- First Calibration deterministic owner / false-success protection.
- Four movement detector chain and typed `VerifiedRep -> BattleSession/Combat` routing.
- Dynamic Difficulty, Recovery/Safety, Loot/Crafting policy, Rewarded Ads policy, analytics contract, release guards, provider-neutral billing/ad gateways and release-evidence scaffolding.
- P1-001 through P1-008 below.

These areas may reopen only under the `REOPENED` rule above.

## Ordered closeout queue

| ID | Status | Scope | Closure target |
|---|---|---|---|
| P1-001 | CLOSED | Flexible Activity integration truth | Verified staging implementation was integrated without its temporary workflow. Runtime `8aaab7130dacf829711f2cef2832f1c0db140d2b`; regression coverage `30f9d5b0614f69138f1da28596db0b218ef4e2cb`; Direct Validation Run 251 SUCCESS. |
| P1-002 | CLOSED | Achievement contract semantics | Added fail-closed category-to-signal compatibility validation and regression coverage. Direct Validation Run 257 SUCCESS. |
| P1-003 | CLOSED | Progression ownership semantics | Four independent axes remain separate; no fabricated numeric balance or critical persistence owner. Direct Validation Run 259 SUCCESS. |
| P1-004 | CLOSED — FAIL-CLOSED | Production Battle encounter authority | No repository-owned encounter/content authority supplies movement/target/duration/reward; Battle stays inaccessible until a real owner is injected. No fabricated encounter was added. |
| P1-005 | CLOSED | Runtime route closure | Locked Home `Ödüller` opens canonical Rune Shrine Ready only; reward/open-gift remains fail-closed without a real authority. Direct Validation Run 262 SUCCESS. |
| P1-006 | CLOSED | Visual authority closure | Runtime source classes are explicitly classified; forbidden reference classes and exact candidate exceptions are regression-guarded. Direct Validation Run 266 SUCCESS at `dc8a55cdfc47a941cb6a35da106431d287112db4`. |
| P1-007 | CLOSED — NO INTERNAL CODE GAP | Phase-1 internal release gate | Existing production readiness code correctly remains external-proof-driven. Historical audit/release docs were reconciled so production blockers cannot masquerade as reopened internal work. |
| P1-008 | CLOSED | Phase-1 internal close | P1-001..P1-007 are closed, recovery state is updated, and the commit containing this closure entry is required to have an exact-HEAD `ActiRune Direct Validation` SUCCESS check. If that exact check is not green, this closure is automatically invalid and P1-008 must be treated as REOPENED. |

## Production/external queue boundary

The following remain outside the frozen internal Phase-1 queue:
- final Android application id;
- Android production signing;
- final iOS bundle id;
- Apple Development Team/signing/archive/export evidence;
- real backend/provider authority and configuration;
- billing products/entitlements/pricing;
- rewarded-ad production app/ad units;
- analytics transport/provider configuration;
- real-human physical-device ML Kit evidence and final human review;
- protected production credentials/secrets;
- store submission/review evidence;
- authoritative production encounter/content owner before Battle is enabled in the production root.

These are not permission to manufacture internal TODOs or fake green evidence.

## Closure evidence

### P1-001 — Flexible Activity
- Source staging workflow Run `35896215278` passed format, analyzer, focused tests, full Flutter suite and diff hygiene.
- Integrated runtime commit: `8aaab7130dacf829711f2cef2832f1c0db140d2b`.
- Integrated regression commit: `30f9d5b0614f69138f1da28596db0b218ef4e2cb`.
- Direct Validation Run 251 SUCCESS.

### P1-002 — Achievement Contract
- Category-to-signal mismatch was proven as the gap and made fail-closed.
- Canonical formatter commit: `5508d42ce2478b06921557380b2bdb54e33db1d9`.
- Direct Validation Run 257 SUCCESS at `f0d27780edf944ba605123f0553df36f15e12d4e`.

### P1-003 — Progression Ownership
- Player Level, Hero Level, Lumi Bond/Level and Movement Mastery remain independent product axes.
- Player Level permanence, visible-next-unlock, Lumi consistency/quest semantics and verified-movement-only Mastery were preserved.
- Runtime semantic update: `2f709a8caa414423ba241d3736e5cb48e557aa5f`.
- Regression update: `5b58d731f0843cc683c441eecc7993633c08cf58`.
- Direct Validation Run 259 SUCCESS.

### P1-004 — Production Battle Encounter Authority
- Production `/app` constructs `MainShell` without an authoritative `battleRootBuilder`.
- `BattleFlowHost` owns screen flow, not encounter content/balance.
- `BattleSessionEngine` validates prepared movement; it does not own story encounter selection, enemy, target, duration or rewards.
- Existing navigation regression proves Battle is inaccessible without a real injected root.
- Correct closure is fail-closed, not a hard-coded fake encounter.

### P1-005 — Runtime Route Closure
- Master Product Bible places Rune Shrine on Home and the locked Home visual exposes `home.rewards`.
- Runtime commit `a0c2ec4691765d1a04c33f82125a49c46064d7bf` connects only that authoritative entry to Rune Shrine Ready.
- Regression commit `7e8e9ad35e8de3cb0ef6844e276c6ca125c63e04` covers entry/exit.
- Formatter-only commit `aa90168126f0adca0f43910f81d96f9dc2328316`.
- Direct Validation Run 262 SUCCESS.

### P1-006 — Visual Authority Closure
- Authority record commit `32e788e0c681210e9a655b7f17412a7a6f6e8ad3` documents runtime authority/candidate exceptions.
- `test/runtime_artwork_authority_test.dart` forbids near-final, camera-reference, patch-base, superseded and legacy-only runtime references.
- `final_p1` runtime use is restricted to six documented exceptions; Profile revision candidate cannot silently replace canonical VIS_0222.
- Canonical formatter commit: `9ea3d7562fb0bc380a4286d29dbdf5dba825bc3d`.
- Temporary formatter removed at `a804968073eedef73fc95b7873680d310f17cfce`.
- Direct Validation Run 266 SUCCESS at `dc8a55cdfc47a941cb6a35da106431d287112db4`.

### P1-007 — Internal Release Gate Reconciliation
- `Phase1ReleaseReadiness`, its CLI gate/test and `.github/workflows/actirune-production-readiness.yml` were re-read from current branch evidence.
- Existing tests prove placeholder identities, undecided providers and absent physical evidence remain fail-closed.
- Production readiness is manual `workflow_dispatch`; internal behavioral regression remains `ActiRune Direct Validation`.
- Historical audit superseded at `cb09d035c12a5499b2dee4717ce59d9f725ad870`.
- Release matrix reconciled at `bb954f68312bcd2a4fcaa49f8208a07844326f9f`.
- Release evidence README clarified at `3c5011e8219d1ff40c327dc4032b9b2df28d5c9d`.
- No runtime/release-gate code was weakened and production readiness was not claimed.

### P1-008 — Internal Freeze
- P1-001..P1-007 are closed under this ledger's evidence rules.
- Recovery checkpoint was refreshed before final freeze at `a038de77af8e2fb902c99a41e73f74cfc4465a10`.
- This final freeze commit intentionally contains no runtime behavior change; the test-file change is a comment-only CI trigger so `ActiRune Direct Validation` evaluates the exact final internal HEAD.
- **Self-validating closure rule:** P1-008 is CLOSED only while the `ActiRune Direct Validation` run attached to the exact commit containing this section concludes SUCCESS. Any failure makes this row and section invalid and automatically reopens P1-008.
- Production readiness remains a separate external queue and is not claimed by this internal freeze.

## Current checkpoint

- Baseline HEAD before ledger: `7484d52474203720f95ec063bd86465c693a7fd1`.
- Pre-freeze behavioral baseline: Direct Validation Run 266 at `dc8a55cdfc47a941cb6a35da106431d287112db4`.
- Final internal behavioral authority: the exact commit containing this P1-008 closure, contingent on its attached `ActiRune Direct Validation` SUCCESS result.
- Active internal item: none.
- Phase-1 internal scope: **FROZEN** after that exact-HEAD success.

## Session checkpoint format

For future recovery:

`FINAL_INTERNAL_HEAD | LAST_CLOSED | ACTIVE | NEXT | BLOCKER`

Current semantic state:

`THIS_CLOSURE_COMMIT | LAST_CLOSED=P1-008 | ACTIVE=none | NEXT=production/external queue | BLOCKER=none-internal`
