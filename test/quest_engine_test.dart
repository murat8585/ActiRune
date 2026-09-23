import 'package:actirune/features/quests/quest_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DailyQuestEngine', () {
    const engine = DailyQuestEngine();

    test('requires exactly five product-authoritative daily candidates', () {
      expect(
        () => engine.buildPlan(
          dayId: '2026-09-23',
          candidates: _quests(4),
        ),
        throwsArgumentError,
      );

      final plan = engine.buildPlan(
        dayId: '2026-09-23',
        candidates: _quests(5),
      );

      expect(plan.quests, hasLength(5));
      expect(plan.normalDailyGoalReached, isFalse);
    });

    test('unlocks cumulative 1 / 3 / 5 daily milestones', () {
      expect(
        engine.milestonesForCompletedCount(0),
        isEmpty,
      );
      expect(
        engine.milestonesForCompletedCount(1),
        {DailyQuestMilestone.firstVictory},
      );
      expect(
        engine.milestonesForCompletedCount(3),
        {
          DailyQuestMilestone.firstVictory,
          DailyQuestMilestone.dailyRuneChest,
        },
      );
      expect(
        engine.milestonesForCompletedCount(5),
        {
          DailyQuestMilestone.firstVictory,
          DailyQuestMilestone.dailyRuneChest,
          DailyQuestMilestone.masterCompletion,
        },
      );
    });

    test('three completed quests is the normal daily goal', () {
      final quests = _quests(5);
      final plan = engine.buildPlan(
        dayId: '2026-09-23',
        candidates: quests,
        completedQuestIds: quests.take(3).map((quest) => quest.id).toSet(),
      );

      expect(plan.completedCount, 3);
      expect(plan.normalDailyGoalReached, isTrue);
      expect(
        plan.unlockedMilestones,
        contains(DailyQuestMilestone.dailyRuneChest),
      );
    });

    test('rejects duplicate and unknown quest ids', () {
      expect(
        () => engine.buildPlan(
          dayId: '2026-09-23',
          candidates: const [
            QuestDefinition(id: 'same', family: QuestFamily.exploration),
            QuestDefinition(id: 'same', family: QuestFamily.battle),
            QuestDefinition(id: 'q3', family: QuestFamily.masteryForm),
            QuestDefinition(id: 'q4', family: QuestFamily.progression),
            QuestDefinition(id: 'q5', family: QuestFamily.recovery),
          ],
        ),
        throwsArgumentError,
      );

      expect(
        () => engine.buildPlan(
          dayId: '2026-09-23',
          candidates: _quests(5),
          completedQuestIds: const {'missing'},
        ),
        throwsArgumentError,
      );
    });
  });

  group('WeeklyQuestEngine', () {
    const engine = WeeklyQuestEngine();

    test('locks weekly quest counts and main reward minimums by level band', () {
      expectPolicy(engine.policyForPlayerLevel(1), total: 6, minimum: 4);
      expectPolicy(engine.policyForPlayerLevel(9), total: 6, minimum: 4);
      expectPolicy(engine.policyForPlayerLevel(10), total: 8, minimum: 5);
      expectPolicy(engine.policyForPlayerLevel(24), total: 8, minimum: 5);
      expectPolicy(engine.policyForPlayerLevel(25), total: 10, minimum: 6);
      expectPolicy(engine.policyForPlayerLevel(49), total: 10, minimum: 6);
      expectPolicy(engine.policyForPlayerLevel(50), total: 12, minimum: 7);
      expectPolicy(engine.policyForPlayerLevel(100), total: 12, minimum: 7);
    });

    test('rejects non-product-authoritative weekly candidate count', () {
      expect(
        () => engine.buildPlan(
          weekId: '2026-W39',
          playerLevel: 10,
          candidates: _quests(7),
        ),
        throwsArgumentError,
      );
    });

    test('main weekly reward unlocks exactly at level-band minimum', () {
      final quests = _quests(10);
      final before = engine.buildPlan(
        weekId: '2026-W39',
        playerLevel: 25,
        candidates: quests,
        completedQuestIds: quests.take(5).map((quest) => quest.id).toSet(),
      );
      final reached = engine.buildPlan(
        weekId: '2026-W39',
        playerLevel: 25,
        candidates: quests,
        completedQuestIds: quests.take(6).map((quest) => quest.id).toSet(),
      );

      expect(before.mainRewardUnlocked, isFalse);
      expect(reached.mainRewardUnlocked, isTrue);
    });

    test('player level starts at one for weekly policy', () {
      expect(() => engine.policyForPlayerLevel(0), throwsArgumentError);
    });
  });

  group('QuestRewardClaimPolicy', () {
    const policy = QuestRewardClaimPolicy();

    test('eligible reward is claimable once with stable claim id', () {
      final first = policy.evaluate(
        scopeId: 'daily:2026-09-23',
        rewardKey: 'dailyRuneChest',
        eligible: true,
      );
      final second = policy.evaluate(
        scopeId: 'daily:2026-09-23',
        rewardKey: 'dailyRuneChest',
        eligible: true,
        alreadyClaimedIds: {first.claimId},
      );

      expect(first.status, QuestRewardClaimStatus.claimable);
      expect(first.shouldApplyReward, isTrue);
      expect(second.claimId, first.claimId);
      expect(second.status, QuestRewardClaimStatus.alreadyClaimed);
      expect(second.shouldApplyReward, isFalse);
    });

    test('ineligible reward never requests application', () {
      final decision = policy.evaluate(
        scopeId: 'weekly:2026-W39',
        rewardKey: 'mainReward',
        eligible: false,
      );

      expect(decision.status, QuestRewardClaimStatus.notEligible);
      expect(decision.shouldApplyReward, isFalse);
    });
  });
}

List<QuestDefinition> _quests(int count) {
  final families = QuestFamily.values;
  return List<QuestDefinition>.generate(
    count,
    (index) => QuestDefinition(
      id: 'quest-${index + 1}',
      family: families[index % families.length],
    ),
  );
}

void expectPolicy(
  WeeklyQuestPolicy policy, {
  required int total,
  required int minimum,
}) {
  expect(policy.totalQuestCount, total);
  expect(policy.mainRewardMinimum, minimum);
}
