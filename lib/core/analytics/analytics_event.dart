import 'package:flutter/foundation.dart';

import '../../features/battle/battle_session_engine.dart';
import '../../features/economy/loot_crafting_policy.dart';

enum AnalyticsEventFamily {
  onboarding,
  retention,
  quest,
  movement,
  boss,
  worldProgression,
  economy,
  runeShrine,
  pro,
  social,
}

sealed class AnalyticsEvent {
  const AnalyticsEvent({required this.occurredAt});

  final DateTime occurredAt;
  AnalyticsEventFamily get family;
}

enum OnboardingAnalyticsAction { completed, calibrationDroppedOut }

@immutable
final class OnboardingAnalyticsEvent extends AnalyticsEvent {
  const OnboardingAnalyticsEvent({
    required super.occurredAt,
    required this.action,
  });

  final OnboardingAnalyticsAction action;

  @override
  AnalyticsEventFamily get family => AnalyticsEventFamily.onboarding;
}

enum RetentionCheckpoint { d1, d7, d30 }

@immutable
final class RetentionAnalyticsEvent extends AnalyticsEvent {
  const RetentionAnalyticsEvent({
    required super.occurredAt,
    required this.checkpoint,
  });

  final RetentionCheckpoint checkpoint;

  @override
  AnalyticsEventFamily get family => AnalyticsEventFamily.retention;
}

enum QuestCadence { daily, weekly }

enum QuestAnalyticsAction { completed, rerolled, abandoned }

@immutable
final class QuestAnalyticsEvent extends AnalyticsEvent {
  const QuestAnalyticsEvent({
    required super.occurredAt,
    required this.cadence,
    required this.action,
  });

  final QuestCadence cadence;
  final QuestAnalyticsAction action;

  @override
  AnalyticsEventFamily get family => AnalyticsEventFamily.quest;
}

enum MovementAnalyticsAction { verified, invalid }

@immutable
final class MovementAnalyticsEvent extends AnalyticsEvent {
  const MovementAnalyticsEvent({
    required super.occurredAt,
    required this.movement,
    required this.action,
    this.formScore,
  });

  final VerifiedMovementType movement;
  final MovementAnalyticsAction action;
  final double? formScore;

  @override
  AnalyticsEventFamily get family => AnalyticsEventFamily.movement;
}

enum BossAnalyticsAction { succeeded, retried, rewardedRetryUsed }

@immutable
final class BossAnalyticsEvent extends AnalyticsEvent {
  const BossAnalyticsEvent({required super.occurredAt, required this.action});

  final BossAnalyticsAction action;

  @override
  AnalyticsEventFamily get family => AnalyticsEventFamily.boss;
}

enum WorldProgressionAnalyticsAction { progressed, regionExited }

@immutable
final class WorldProgressionAnalyticsEvent extends AnalyticsEvent {
  const WorldProgressionAnalyticsEvent({
    required super.occurredAt,
    required this.action,
  });

  final WorldProgressionAnalyticsAction action;

  @override
  AnalyticsEventFamily get family => AnalyticsEventFamily.worldProgression;
}

enum EconomyAnalyticsAction { craftingSink, lootSource }

enum EconomyResourceKind { gold, crystal, material }

@immutable
final class EconomyAnalyticsEvent extends AnalyticsEvent {
  const EconomyAnalyticsEvent({
    required super.occurredAt,
    required this.action,
    required this.resourceKind,
    required this.quantity,
    this.materialFamily,
  });

  final EconomyAnalyticsAction action;
  final EconomyResourceKind resourceKind;
  final int quantity;
  final MaterialFamily? materialFamily;

  @override
  AnalyticsEventFamily get family => AnalyticsEventFamily.economy;
}

enum RuneShrineAnalyticsAction { impression, optedIn, completed }

@immutable
final class RuneShrineAnalyticsEvent extends AnalyticsEvent {
  const RuneShrineAnalyticsEvent({
    required super.occurredAt,
    required this.action,
  });

  final RuneShrineAnalyticsAction action;

  @override
  AnalyticsEventFamily get family => AnalyticsEventFamily.runeShrine;
}

enum ProAnalyticsAction { paywallViewed, trialStarted, paid, renewed, churned }

@immutable
final class ProAnalyticsEvent extends AnalyticsEvent {
  const ProAnalyticsEvent({required super.occurredAt, required this.action});

  final ProAnalyticsAction action;

  @override
  AnalyticsEventFamily get family => AnalyticsEventFamily.pro;
}

enum SocialAnalyticsAction { inviteSent, roomEntered, raidCompleted }

@immutable
final class SocialAnalyticsEvent extends AnalyticsEvent {
  const SocialAnalyticsEvent({required super.occurredAt, required this.action});

  final SocialAnalyticsAction action;

  @override
  AnalyticsEventFamily get family => AnalyticsEventFamily.social;
}

/// Provider boundary only. No analytics SDK, backend, persistence or network
/// behavior is implied by this interface.
abstract interface class AnalyticsSink {
  Future<void> record(AnalyticsEvent event);
}
