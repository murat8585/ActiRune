# ActiRune Phase-1 Internal Gap Audit

Date: 2026-09-23 (Europe/Istanbul)
Branch: `integration/artwork-interactions-20260921`
Status: ACTIVE AUDIT

## Purpose

Re-audit Master Product Bible Phase 1 after the production-evidence safety work and distinguish:

1. real internal product/runtime gaps that can still be completed without inventing external authority, from
2. hard production boundaries that require real application identity, provider accounts, credentials, protected signing or physical-device evidence.

No external account/provider identity is invented by this audit.

## Daily + Weekly Quest Engine finding

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

The integration branch still requires its own Direct Validation before this batch is called fully verified.

## Persistence boundary

Master Product Bible also requires quest/progression state to survive reopening. Current `pubspec.yaml` has no critical-data persistence/backend provider.

The official Flutter `shared_preferences` package is suitable for simple key-value preferences but its own documentation warns that it must not be used for critical data. Therefore this audit does not falsely promote simple preferences storage into the authoritative owner of rewards/economy/progression.

Critical quest claims, inventory/economy and progression persistence remain tied to the real backend/persistence authority that will be selected and integrated later.

## First Calibration finding

Master Product Bible marks First Calibration as REQUIRED. Current `lib/features/onboarding/` contains calibration screens, but this audit found no separate deterministic calibration-domain owner yet for:

- declared goal/time/experience input,
- movement suitability/preferences,
- required movement evidence summary,
- safe non-medical starting-profile classification,
- false-success prevention at the domain boundary.

This remains a legitimate internal Phase-1 gap that can be implemented without external provider identity, provided no medical diagnosis or fabricated pose evidence is introduced.

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

## Next internal sequence

1. Close and Direct-Validate Daily + Weekly Quest Engine batch.
2. Implement a deterministic First Calibration domain owner with false-success protection and regression tests, without inventing medical/pose facts.
3. Re-audit remaining Phase-1 internal gaps after calibration.
4. Stop at the external authority boundary rather than substituting fake providers or synthetic physical evidence.
