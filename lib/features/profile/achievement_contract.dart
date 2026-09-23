import 'package:flutter/foundation.dart';

/// Long-term achievement categories locked by the product contract.
///
/// Numeric thresholds and reward amounts are deliberately not owned here.
enum AchievementCategory {
  exploration,
  battle,
  movement,
  form,
  lumi,
  social,
  hidden,
}

/// Typed milestone signals that authoritative gameplay/progression owners may
/// emit after their own criteria are satisfied.
///
/// For example, the distance owner decides when its configured distance
/// milestone is reached; this contract does not invent a kilometre threshold.
enum AchievementSignal {
  firstBattleCompleted,
  firstBossCompleted,
  distanceMilestoneReached,
  verifiedMovementMilestoneReached,
  highFormSeriesReached,
  socialMilestoneReached,
  lumiBondMilestoneReached,
  worldCompletionReached,
  hiddenAchievementDiscovered,
}

@immutable
class AchievementDefinition {
  const AchievementDefinition({
    required this.id,
    required this.category,
    required this.signal,
  });

  final String id;
  final AchievementCategory category;
  final AchievementSignal signal;
}

@immutable
class AchievementEvidence {
  const AchievementEvidence({
    required this.signal,
    required this.evidenceId,
  });

  /// Milestone already verified by its authoritative source system.
  final AchievementSignal signal;

  /// Stable source-owned identity used to prevent replay/double unlock.
  final String evidenceId;
}

enum AchievementUnlockStatus {
  signalMismatch,
  alreadyUnlocked,
  evidenceAlreadyConsumed,
  unlockable,
}

@immutable
class AchievementUnlockDecision {
  const AchievementUnlockDecision({
    required this.achievementId,
    required this.evidenceId,
    required this.status,
  });

  final String achievementId;
  final String evidenceId;
  final AchievementUnlockStatus status;

  bool get shouldUnlock => status == AchievementUnlockStatus.unlockable;
}

/// Pure, fail-closed achievement unlock policy.
///
/// This layer never computes distance, rep counts, form thresholds, world
/// completion percentages, Lumi levels or social scores. Those remain with
/// their authoritative systems. It only consumes already-verified typed
/// milestone evidence and guarantees category-safe, one-time unlock semantics.
class AchievementUnlockPolicy {
  const AchievementUnlockPolicy();

  AchievementUnlockDecision evaluate({
    required AchievementDefinition definition,
    required AchievementEvidence evidence,
    Set<String> alreadyUnlockedAchievementIds = const <String>{},
    Set<String> consumedEvidenceIds = const <String>{},
  }) {
    _requireStableId(definition.id, 'definition.id');
    _requireStableId(evidence.evidenceId, 'evidence.evidenceId');

    if (definition.signal != evidence.signal) {
      return AchievementUnlockDecision(
        achievementId: definition.id,
        evidenceId: evidence.evidenceId,
        status: AchievementUnlockStatus.signalMismatch,
      );
    }
    if (alreadyUnlockedAchievementIds.contains(definition.id)) {
      return AchievementUnlockDecision(
        achievementId: definition.id,
        evidenceId: evidence.evidenceId,
        status: AchievementUnlockStatus.alreadyUnlocked,
      );
    }
    if (consumedEvidenceIds.contains(evidence.evidenceId)) {
      return AchievementUnlockDecision(
        achievementId: definition.id,
        evidenceId: evidence.evidenceId,
        status: AchievementUnlockStatus.evidenceAlreadyConsumed,
      );
    }

    return AchievementUnlockDecision(
      achievementId: definition.id,
      evidenceId: evidence.evidenceId,
      status: AchievementUnlockStatus.unlockable,
    );
  }
}

void _requireStableId(String value, String fieldName) {
  if (value.trim().isEmpty) {
    throw ArgumentError.value(value, fieldName, 'must not be empty');
  }
}
