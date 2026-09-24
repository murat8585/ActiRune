# ActiRune Phase-1 Internal Gap Audit

Date: 2026-09-23 (Europe/Istanbul)
Branch: `integration/artwork-interactions-20260921`
Status: **SUPERSEDED — HISTORICAL EVIDENCE ONLY**

> Do not use this file as an active work queue. Its Daily/Weekly Quest and First Calibration findings were closed after this snapshot. The authoritative ordered Phase-1 queue is repository-root `PHASE1_CLOSEOUT.md`. A later chat/session must not reopen work from this audit merely because the historical text below describes it as incomplete at the time.

## Purpose

This document preserves the historical audit that was performed after the production-evidence safety work. At that point it distinguished:

1. internal product/runtime gaps that could be completed without inventing external authority, from
2. hard production boundaries that require real application identity, provider accounts, credentials, protected signing or physical-device evidence.

No external account/provider identity was invented by this audit.

## Daily + Weekly Quest Engine finding — historical

Before this audit, `lib/features/quests/` contained the canonical Daily/Weekly/Quest Chain screens but no deterministic runtime owner for the locked Daily Quest Engine and Weekly Quest Engine rules.

Master Product Bible authority requires:

- Daily: exactly 5 quest candidates.
- Daily normal goal: 3/5.
- Daily milestones: first reward at 1 completion, main Daily Rune Chest at 3, master completion at 5/5.
- Weekly quest count by Player Level: 6 / 8 / 10 / 12.
- Weekly main-reward minimum by Player Level: 4 / 5 / 6 / 7.
- Quest families include Exploration, Battle, Mastery/Form, Progression, Social and Recovery.
- Reward claims must be idempotent; reopening/retrying must not grant the same reward twice.

Candidate implementation added and staging-verified:

- `lib/features/quests/quest_engine.dart`
- `test/quest_engine_test.dart`

The engine:

- validates the exact product-authoritative daily/weekly quest counts,
- exposes the locked daily 1/3/5 milestone state,
- exposes the locked weekly level-band counts and main-reward thresholds,
- rejects duplicate quest ids and completed ids outside the active plan,
- provides a stable claim-id policy so an already-persisted claim cannot be treated as claimable twice,
- does not invent reward amounts, loot tables, drop rates or quest content,
- leaves real persistence and reward application to an authoritative persistence/economy owner.

Dedicated staging validation Run 35886220528 completed SUCCESS:

- format PASS,
- analyzer PASS,
- focused Quest Engine tests PASS,
- full Flutter suite PASS,
- diff hygiene PASS.

The integration-branch validation requirement described in the original audit was later satisfied. This paragraph is retained only to show what was known at the time.

## Persistence boundary

Master Product Bible also requires quest/progression state to survive reopening. The repository snapshot had no critical-data persistence/backend provider.

The official Flutter `shared_preferences` package is suitable for simple key-value preferences but its own documentation warns that it must not be used for critical data. Therefore this audit did not falsely promote simple preferences storage into the authoritative owner of rewards/economy/progression.

Critical quest claims, inventory/economy and progression persistence remain tied to the real backend/persistence authority that will be selected and integrated later. This is an external/production authority boundary, not permission to invent a local critical-data owner.

## First Calibration finding — historical

At the time of this snapshot, Master Product Bible marked First Calibration as REQUIRED and the audit had not yet found a separate deterministic calibration-domain owner for:

- declared goal/time/experience input,
- movement suitability/preferences,
- required movement evidence summary,
- safe non-medical starting-profile classification,
- false-success prevention at the domain boundary.

That internal gap was subsequently implemented and validated. It must not be reopened from this historical wording without new concrete evidence under the `PHASE1_CLOSEOUT.md` reopening rule.

## External hard boundaries remain unchanged

The following are not internal-feature fabrication targets:

- final Android application id,
- Android production signing,
- final iOS bundle id,
- Apple Development Team/signing,
- Firebase/RevenueCat/AdMob/analytics production projects and credentials,
- store product ids/pricing/entitlements,
- real-human physical-device ML Kit corpus and final review,
- protected production secrets.

## Historical sequence — no longer active instructions

The original audit proposed Quest Engine -> First Calibration -> another broad internal re-audit. The first two items were completed. The broad re-audit loop is superseded by the bounded `PHASE1_CLOSEOUT.md` ledger, which advances monotonically and only adds a new item when concrete code/test evidence proves a new gap.
