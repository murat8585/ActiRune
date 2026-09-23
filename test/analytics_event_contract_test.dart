import 'package:actirune/core/analytics/analytics_event.dart';
import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:actirune/features/economy/loot_crafting_policy.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeAnalyticsSink implements AnalyticsSink {
  final events = <AnalyticsEvent>[];

  @override
  Future<void> record(AnalyticsEvent event) async {
    events.add(event);
  }
}

void main() {
  final at = DateTime.utc(2026, 9, 23, 12);

  test('required analytics families are explicit and provider-neutral', () {
    expect(AnalyticsEventFamily.values, [
      AnalyticsEventFamily.onboarding,
      AnalyticsEventFamily.retention,
      AnalyticsEventFamily.quest,
      AnalyticsEventFamily.movement,
      AnalyticsEventFamily.boss,
      AnalyticsEventFamily.worldProgression,
      AnalyticsEventFamily.economy,
      AnalyticsEventFamily.runeShrine,
      AnalyticsEventFamily.pro,
      AnalyticsEventFamily.social,
    ]);
  });

  test('onboarding and retention required checkpoints are typed', () {
    final events = <AnalyticsEvent>[
      OnboardingAnalyticsEvent(
        occurredAt: at,
        action: OnboardingAnalyticsAction.completed,
      ),
      OnboardingAnalyticsEvent(
        occurredAt: at,
        action: OnboardingAnalyticsAction.calibrationDroppedOut,
      ),
      RetentionAnalyticsEvent(
        occurredAt: at,
        checkpoint: RetentionCheckpoint.d1,
      ),
      RetentionAnalyticsEvent(
        occurredAt: at,
        checkpoint: RetentionCheckpoint.d7,
      ),
      RetentionAnalyticsEvent(
        occurredAt: at,
        checkpoint: RetentionCheckpoint.d30,
      ),
    ];

    expect(events.map((event) => event.family), [
      AnalyticsEventFamily.onboarding,
      AnalyticsEventFamily.onboarding,
      AnalyticsEventFamily.retention,
      AnalyticsEventFamily.retention,
      AnalyticsEventFamily.retention,
    ]);
  });

  test('quest movement and boss metrics use existing movement authority', () {
    final events = <AnalyticsEvent>[
      QuestAnalyticsEvent(
        occurredAt: at,
        cadence: QuestCadence.daily,
        action: QuestAnalyticsAction.completed,
      ),
      QuestAnalyticsEvent(
        occurredAt: at,
        cadence: QuestCadence.weekly,
        action: QuestAnalyticsAction.rerolled,
      ),
      QuestAnalyticsEvent(
        occurredAt: at,
        cadence: QuestCadence.daily,
        action: QuestAnalyticsAction.abandoned,
      ),
      MovementAnalyticsEvent(
        occurredAt: at,
        movement: VerifiedMovementType.plank,
        action: MovementAnalyticsAction.verified,
        formScore: 0.91,
      ),
      MovementAnalyticsEvent(
        occurredAt: at,
        movement: VerifiedMovementType.squat,
        action: MovementAnalyticsAction.invalid,
      ),
      BossAnalyticsEvent(occurredAt: at, action: BossAnalyticsAction.succeeded),
      BossAnalyticsEvent(occurredAt: at, action: BossAnalyticsAction.retried),
      BossAnalyticsEvent(
        occurredAt: at,
        action: BossAnalyticsAction.rewardedRetryUsed,
      ),
    ];

    expect(
      events.whereType<MovementAnalyticsEvent>().first.movement,
      VerifiedMovementType.plank,
    );
    expect(events.whereType<MovementAnalyticsEvent>().first.formScore, 0.91);
    expect(events.map((event) => event.family).toSet(), {
      AnalyticsEventFamily.quest,
      AnalyticsEventFamily.movement,
      AnalyticsEventFamily.boss,
    });
  });

  test('world economy Rune Shrine Pro and social funnels are typed', () {
    final events = <AnalyticsEvent>[
      WorldProgressionAnalyticsEvent(
        occurredAt: at,
        action: WorldProgressionAnalyticsAction.progressed,
      ),
      WorldProgressionAnalyticsEvent(
        occurredAt: at,
        action: WorldProgressionAnalyticsAction.regionExited,
      ),
      EconomyAnalyticsEvent(
        occurredAt: at,
        action: EconomyAnalyticsAction.craftingSink,
        resourceKind: EconomyResourceKind.material,
        quantity: 2,
        materialFamily: MaterialFamily.ancientOre,
      ),
      EconomyAnalyticsEvent(
        occurredAt: at,
        action: EconomyAnalyticsAction.lootSource,
        resourceKind: EconomyResourceKind.gold,
        quantity: 10,
      ),
      RuneShrineAnalyticsEvent(
        occurredAt: at,
        action: RuneShrineAnalyticsAction.impression,
      ),
      RuneShrineAnalyticsEvent(
        occurredAt: at,
        action: RuneShrineAnalyticsAction.optedIn,
      ),
      RuneShrineAnalyticsEvent(
        occurredAt: at,
        action: RuneShrineAnalyticsAction.completed,
      ),
      ProAnalyticsEvent(
        occurredAt: at,
        action: ProAnalyticsAction.paywallViewed,
      ),
      ProAnalyticsEvent(
        occurredAt: at,
        action: ProAnalyticsAction.trialStarted,
      ),
      ProAnalyticsEvent(occurredAt: at, action: ProAnalyticsAction.paid),
      ProAnalyticsEvent(occurredAt: at, action: ProAnalyticsAction.renewed),
      ProAnalyticsEvent(occurredAt: at, action: ProAnalyticsAction.churned),
      SocialAnalyticsEvent(
        occurredAt: at,
        action: SocialAnalyticsAction.inviteSent,
      ),
      SocialAnalyticsEvent(
        occurredAt: at,
        action: SocialAnalyticsAction.roomEntered,
      ),
      SocialAnalyticsEvent(
        occurredAt: at,
        action: SocialAnalyticsAction.raidCompleted,
      ),
    ];

    expect(events.map((event) => event.family).toSet(), {
      AnalyticsEventFamily.worldProgression,
      AnalyticsEventFamily.economy,
      AnalyticsEventFamily.runeShrine,
      AnalyticsEventFamily.pro,
      AnalyticsEventFamily.social,
    });
    expect(
      events.whereType<EconomyAnalyticsEvent>().first.materialFamily,
      MaterialFamily.ancientOre,
    );
  });

  test('sink is only an interface and caller controls delivery', () async {
    final sink = _FakeAnalyticsSink();
    final event = RuneShrineAnalyticsEvent(
      occurredAt: at,
      action: RuneShrineAnalyticsAction.completed,
    );

    await sink.record(event);

    expect(sink.events, [same(event)]);
  });
}
