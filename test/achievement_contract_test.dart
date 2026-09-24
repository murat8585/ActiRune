import 'package:actirune/features/profile/achievement_contract.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = AchievementUnlockPolicy();

  const validPairs = <(AchievementCategory, AchievementSignal)>[
    (AchievementCategory.battle, AchievementSignal.firstBattleCompleted),
    (AchievementCategory.battle, AchievementSignal.firstBossCompleted),
    (
      AchievementCategory.exploration,
      AchievementSignal.distanceMilestoneReached,
    ),
    (
      AchievementCategory.movement,
      AchievementSignal.verifiedMovementMilestoneReached,
    ),
    (AchievementCategory.form, AchievementSignal.highFormSeriesReached),
    (AchievementCategory.social, AchievementSignal.socialMilestoneReached),
    (AchievementCategory.lumi, AchievementSignal.lumiBondMilestoneReached),
    (
      AchievementCategory.exploration,
      AchievementSignal.worldCompletionReached,
    ),
    (
      AchievementCategory.hidden,
      AchievementSignal.hiddenAchievementDiscovered,
    ),
  ];

  for (final (category, signal) in validPairs) {
    test('${signal.name} accepts only its locked category', () {
      final accepted = policy.evaluate(
        definition: AchievementDefinition(
          id: 'achievement-${signal.name}',
          category: category,
          signal: signal,
        ),
        evidence: AchievementEvidence(
          signal: signal,
          evidenceId: 'evidence-${signal.name}',
        ),
      );

      expect(accepted.status, AchievementUnlockStatus.unlockable);
      expect(accepted.shouldUnlock, isTrue);

      final wrongCategory = AchievementCategory.values.firstWhere(
        (candidate) => candidate != category,
      );
      final rejected = policy.evaluate(
        definition: AchievementDefinition(
          id: 'wrong-${signal.name}',
          category: wrongCategory,
          signal: signal,
        ),
        evidence: AchievementEvidence(
          signal: signal,
          evidenceId: 'wrong-evidence-${signal.name}',
        ),
      );

      expect(rejected.status, AchievementUnlockStatus.categoryMismatch);
      expect(rejected.shouldUnlock, isFalse);
    });
  }

  test('signal mismatch fails closed before unlock', () {
    final decision = policy.evaluate(
      definition: const AchievementDefinition(
        id: 'first-battle',
        category: AchievementCategory.battle,
        signal: AchievementSignal.firstBattleCompleted,
      ),
      evidence: const AchievementEvidence(
        signal: AchievementSignal.firstBossCompleted,
        evidenceId: 'boss-evidence',
      ),
    );

    expect(decision.status, AchievementUnlockStatus.signalMismatch);
    expect(decision.shouldUnlock, isFalse);
  });

  test('already unlocked achievement cannot unlock twice', () {
    final decision = policy.evaluate(
      definition: const AchievementDefinition(
        id: 'first-battle',
        category: AchievementCategory.battle,
        signal: AchievementSignal.firstBattleCompleted,
      ),
      evidence: const AchievementEvidence(
        signal: AchievementSignal.firstBattleCompleted,
        evidenceId: 'battle-evidence',
      ),
      alreadyUnlockedAchievementIds: const {'first-battle'},
    );

    expect(decision.status, AchievementUnlockStatus.alreadyUnlocked);
  });

  test('consumed evidence cannot unlock another achievement', () {
    final decision = policy.evaluate(
      definition: const AchievementDefinition(
        id: 'first-battle',
        category: AchievementCategory.battle,
        signal: AchievementSignal.firstBattleCompleted,
      ),
      evidence: const AchievementEvidence(
        signal: AchievementSignal.firstBattleCompleted,
        evidenceId: 'battle-evidence',
      ),
      consumedEvidenceIds: const {'battle-evidence'},
    );

    expect(decision.status, AchievementUnlockStatus.evidenceAlreadyConsumed);
  });

  test('blank stable ids are rejected', () {
    expect(
      () => policy.evaluate(
        definition: const AchievementDefinition(
          id: ' ',
          category: AchievementCategory.battle,
          signal: AchievementSignal.firstBattleCompleted,
        ),
        evidence: const AchievementEvidence(
          signal: AchievementSignal.firstBattleCompleted,
          evidenceId: 'valid-evidence',
        ),
      ),
      throwsArgumentError,
    );

    expect(
      () => policy.evaluate(
        definition: const AchievementDefinition(
          id: 'valid-achievement',
          category: AchievementCategory.battle,
          signal: AchievementSignal.firstBattleCompleted,
        ),
        evidence: const AchievementEvidence(
          signal: AchievementSignal.firstBattleCompleted,
          evidenceId: '',
        ),
      ),
      throwsArgumentError,
    );
  });
}
