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

/// Typed milestone signals emitted by authoritative gameplay/progression owners.
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

  final AchievementSignal signal;
  final String evidenceId;
}

enum AchievementUnlockStatus {
  signalMismatch,
  categoryMismatch,
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
/// Threshold computation remains owned by source systems. This layer validates
/// typed evidence, enforces the locked category/signal relationship, and
/// guarantees one-time unlock semantics without inventing reward values.
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
    if (!_categoryMatchesSignal(definition.category, definition.signal)) {
      return AchievementUnlockDecision(
        achievementId: definition.id,
        evidenceId: evidence.evidenceId,
        status: AchievementUnlockStatus.categoryMismatch,
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

bool _categoryMatchesSignal(
  AchievementCategory category,
  AchievementSignal signal,
) {
  return switch (signal) {
    AchievementSignal.firstBattleCompleted =>
      category == AchievementCategory.battle,
    AchievementSignal.firstBossCompleted =>
      category == AchievementCategory.battle,
    AchievementSignal.distanceMilestoneReached =>
      category == AchievementCategory.exploration,
    AchievementSignal.verifiedMovementMilestoneReached =>
      category == AchievementCategory.movement,
    AchievementSignal.highFormSeriesReached =>
      category == AchievementCategory.form,
    AchievementSignal.socialMilestoneReached =>
      category == AchievementCategory.social,
    AchievementSignal.lumiBondMilestoneReached =>
      category == AchievementCategory.lumi,
    AchievementSignal.worldCompletionReached =>
      category == AchievementCategory.exploration,
    AchievementSignal.hiddenAchievementDiscovered =>
      category == AchievementCategory.hidden,
  };
}

void _requireStableId(String value, String fieldName) {
  if (value.trim().isEmpty) {
    throw ArgumentError.value(value, fieldName, 'must not be empty');
  }
}
