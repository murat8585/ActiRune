import 'package:actirune/features/profile/achievement_contract.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = AchievementUnlockPolicy();

  void expectUnlockable(
    AchievementSignal signal,
    AchievementCategory category,
  ) {
    final decision = policy.evaluate(
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

    expect(decision.status, AchievementUnlockStatus.unlockable);
    expect(decision.shouldUnlock, isTrue);
  }

  test('locked signals accept only their product categories', () {
    expectUnlockable(
      AchievementSignal.firstBattleCompleted,
      AchievementCategory.battle,
    );
    expectUnlockable(
      AchievementSignal.firstBossCompleted,
      AchievementCategory.battle,
    );
    expectUnlockable(
      AchievementSignal.distanceMilestoneReached,
      AchievementCategory.exploration,
    );
    expectUnlockable(
      AchievementSignal.verifiedMovementMilestoneReached,
      AchievementCategory.movement,
    );
    expectUnlockable(
      AchievementSignal.highFormSeriesReached,
      AchievementCategory.form,
    );
    expectUnlockable(
      AchievementSignal.socialMilestoneReached,
      AchievementCategory.social,
    );
    expectUnlockable(
      AchievementSignal.lumiBondMilestoneReached,
      AchievementCategory.lumi,
    );
    expectUnlockable(
      AchievementSignal.worldCompletionReached,
      AchievementCategory.exploration,
    );
    expectUnlockable(
      AchievementSignal.hiddenAchievementDiscovered,
      AchievementCategory.hidden,
    );
  });

  test('category mismatch fails closed', () {
    final decision = policy.evaluate(
      definition: const AchievementDefinition(
        id: 'wrong-first-battle',
        category: AchievementCategory.social,
        signal: AchievementSignal.firstBattleCompleted,
      ),
      evidence: const AchievementEvidence(
        signal: AchievementSignal.firstBattleCompleted,
        evidenceId: 'battle-evidence',
      ),
    );

    expect(decision.status, AchievementUnlockStatus.categoryMismatch);
    expect(decision.shouldUnlock, isFalse);
  });

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
