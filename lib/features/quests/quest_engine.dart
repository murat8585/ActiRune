import 'package:flutter/foundation.dart';

enum QuestFamily {
  exploration,
  battle,
  masteryForm,
  progression,
  social,
  recovery,
}

enum DailyQuestMilestone {
  firstVictory,
  dailyRuneChest,
  masterCompletion,
}

@immutable
class QuestDefinition {
  const QuestDefinition({
    required this.id,
    required this.family,
  });

  final String id;
  final QuestFamily family;
}

@immutable
class DailyQuestPlan {
  const DailyQuestPlan({
    required this.dayId,
    required this.quests,
    required this.completedQuestIds,
    required this.unlockedMilestones,
  });

  final String dayId;
  final List<QuestDefinition> quests;
  final Set<String> completedQuestIds;
  final Set<DailyQuestMilestone> unlockedMilestones;

  int get completedCount => completedQuestIds.length;
  bool get normalDailyGoalReached => completedCount >= DailyQuestEngine.normalGoal;
}

class DailyQuestEngine {
  const DailyQuestEngine();

  static const int candidateCount = 5;
  static const int normalGoal = 3;

  DailyQuestPlan buildPlan({
    required String dayId,
    required List<QuestDefinition> candidates,
    Set<String> completedQuestIds = const <String>{},
  }) {
    _validateScopeId(dayId, 'dayId');
    _validateQuestDefinitions(candidates, expectedCount: candidateCount);
    _validateCompletedIds(candidates, completedQuestIds);

    return DailyQuestPlan(
      dayId: dayId,
      quests: List.unmodifiable(candidates),
      completedQuestIds: Set.unmodifiable(completedQuestIds),
      unlockedMilestones: Set.unmodifiable(
        milestonesForCompletedCount(completedQuestIds.length),
      ),
    );
  }

  Set<DailyQuestMilestone> milestonesForCompletedCount(int completedCount) {
    if (completedCount < 0 || completedCount > candidateCount) {
      throw ArgumentError.value(
        completedCount,
        'completedCount',
        'must be between 0 and $candidateCount',
      );
    }

    final milestones = <DailyQuestMilestone>{};
    if (completedCount >= 1) {
      milestones.add(DailyQuestMilestone.firstVictory);
    }
    if (completedCount >= normalGoal) {
      milestones.add(DailyQuestMilestone.dailyRuneChest);
    }
    if (completedCount == candidateCount) {
      milestones.add(DailyQuestMilestone.masterCompletion);
    }
    return milestones;
  }
}

@immutable
class WeeklyQuestPolicy {
  const WeeklyQuestPolicy({
    required this.totalQuestCount,
    required this.mainRewardMinimum,
  });

  final int totalQuestCount;
  final int mainRewardMinimum;
}

@immutable
class WeeklyQuestPlan {
  const WeeklyQuestPlan({
    required this.weekId,
    required this.playerLevel,
    required this.policy,
    required this.quests,
    required this.completedQuestIds,
  });

  final String weekId;
  final int playerLevel;
  final WeeklyQuestPolicy policy;
  final List<QuestDefinition> quests;
  final Set<String> completedQuestIds;

  int get completedCount => completedQuestIds.length;
  bool get mainRewardUnlocked => completedCount >= policy.mainRewardMinimum;
}

class WeeklyQuestEngine {
  const WeeklyQuestEngine();

  WeeklyQuestPolicy policyForPlayerLevel(int playerLevel) {
    if (playerLevel < 1) {
      throw ArgumentError.value(
        playerLevel,
        'playerLevel',
        'must be at least 1',
      );
    }

    if (playerLevel <= 9) {
      return const WeeklyQuestPolicy(
        totalQuestCount: 6,
        mainRewardMinimum: 4,
      );
    }
    if (playerLevel <= 24) {
      return const WeeklyQuestPolicy(
        totalQuestCount: 8,
        mainRewardMinimum: 5,
      );
    }
    if (playerLevel <= 49) {
      return const WeeklyQuestPolicy(
        totalQuestCount: 10,
        mainRewardMinimum: 6,
      );
    }
    return const WeeklyQuestPolicy(
      totalQuestCount: 12,
      mainRewardMinimum: 7,
    );
  }

  WeeklyQuestPlan buildPlan({
    required String weekId,
    required int playerLevel,
    required List<QuestDefinition> candidates,
    Set<String> completedQuestIds = const <String>{},
  }) {
    _validateScopeId(weekId, 'weekId');
    final policy = policyForPlayerLevel(playerLevel);
    _validateQuestDefinitions(
      candidates,
      expectedCount: policy.totalQuestCount,
    );
    _validateCompletedIds(candidates, completedQuestIds);

    return WeeklyQuestPlan(
      weekId: weekId,
      playerLevel: playerLevel,
      policy: policy,
      quests: List.unmodifiable(candidates),
      completedQuestIds: Set.unmodifiable(completedQuestIds),
    );
  }
}

enum QuestRewardClaimStatus { notEligible, claimable, alreadyClaimed }

@immutable
class QuestRewardClaimDecision {
  const QuestRewardClaimDecision({
    required this.claimId,
    required this.status,
  });

  final String claimId;
  final QuestRewardClaimStatus status;

  bool get shouldApplyReward => status == QuestRewardClaimStatus.claimable;
}

/// Pure idempotency policy for reward claims.
///
/// The caller owns persistence and actual reward application. This policy only
/// guarantees that a stable claim id cannot be treated as claimable twice when
/// the caller provides its already-persisted claim-id set.
class QuestRewardClaimPolicy {
  const QuestRewardClaimPolicy();

  QuestRewardClaimDecision evaluate({
    required String scopeId,
    required String rewardKey,
    required bool eligible,
    Set<String> alreadyClaimedIds = const <String>{},
  }) {
    _validateScopeId(scopeId, 'scopeId');
    _validateScopeId(rewardKey, 'rewardKey');
    final claimId = '$scopeId::$rewardKey';

    if (!eligible) {
      return QuestRewardClaimDecision(
        claimId: claimId,
        status: QuestRewardClaimStatus.notEligible,
      );
    }
    if (alreadyClaimedIds.contains(claimId)) {
      return QuestRewardClaimDecision(
        claimId: claimId,
        status: QuestRewardClaimStatus.alreadyClaimed,
      );
    }
    return QuestRewardClaimDecision(
      claimId: claimId,
      status: QuestRewardClaimStatus.claimable,
    );
  }
}

void _validateQuestDefinitions(
  List<QuestDefinition> quests, {
  required int expectedCount,
}) {
  if (quests.length != expectedCount) {
    throw ArgumentError.value(
      quests.length,
      'quests.length',
      'must equal the product-authoritative count $expectedCount',
    );
  }

  final seen = <String>{};
  for (final quest in quests) {
    _validateScopeId(quest.id, 'quest.id');
    if (!seen.add(quest.id)) {
      throw ArgumentError('duplicate quest id: ${quest.id}');
    }
  }
}

void _validateCompletedIds(
  List<QuestDefinition> quests,
  Set<String> completedQuestIds,
) {
  final knownIds = quests.map((quest) => quest.id).toSet();
  final unknownIds = completedQuestIds.difference(knownIds);
  if (unknownIds.isNotEmpty) {
    throw ArgumentError(
      'completed quest ids are not in the active plan: '
      '${unknownIds.join(', ')}',
    );
  }
}

void _validateScopeId(String value, String fieldName) {
  if (value.trim().isEmpty) {
    throw ArgumentError.value(value, fieldName, 'must not be empty');
  }
}
