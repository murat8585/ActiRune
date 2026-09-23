import 'package:flutter/foundation.dart';

import '../battle/battle_session_engine.dart';

enum RewardDeliveryMode { watchAd, directProGrant, unavailable }

enum RewardedAdBlockReason {
  cooldown,
  dailyLimit,
  battleNotDefeated,
  rankedPvp,
  retryUnavailable,
  invalidState,
}

enum ExternalAdOutcome { completed, cancelled, failed }

@immutable
class RewardedAdDecision {
  const RewardedAdDecision._({
    required this.deliveryMode,
    this.blockReason,
    this.remainingCooldown = Duration.zero,
  });

  factory RewardedAdDecision.watchAd() {
    return const RewardedAdDecision._(
      deliveryMode: RewardDeliveryMode.watchAd,
    );
  }

  factory RewardedAdDecision.directProGrant() {
    return const RewardedAdDecision._(
      deliveryMode: RewardDeliveryMode.directProGrant,
    );
  }

  factory RewardedAdDecision.unavailable(
    RewardedAdBlockReason reason, {
    Duration remainingCooldown = Duration.zero,
  }) {
    return RewardedAdDecision._(
      deliveryMode: RewardDeliveryMode.unavailable,
      blockReason: reason,
      remainingCooldown: remainingCooldown,
    );
  }

  final RewardDeliveryMode deliveryMode;
  final RewardedAdBlockReason? blockReason;
  final Duration remainingCooldown;

  bool get eligible => deliveryMode != RewardDeliveryMode.unavailable;
}

/// Product-policy boundary for rewarded placements.
///
/// This class never talks to an ad SDK and never grants inventory, currency or
/// battle state. The caller must supply entitlement/history/session state and
/// may apply a reward only after [rewardMayApply] confirms a completed external
/// ad, or when an eligible Pro entitlement allows direct delivery.
class RewardedAdPolicy {
  const RewardedAdPolicy();

  static const runeShrineCooldown = Duration(hours: 4);
  static const runeShrineDailyLimit = 3;

  RewardedAdDecision evaluateRuneShrine({
    required DateTime now,
    required DateTime? lastSuccessfulRewardAt,
    required int successfulRewardsToday,
    required bool isPro,
  }) {
    if (successfulRewardsToday < 0) {
      return RewardedAdDecision.unavailable(
        RewardedAdBlockReason.invalidState,
      );
    }
    if (successfulRewardsToday >= runeShrineDailyLimit) {
      return RewardedAdDecision.unavailable(
        RewardedAdBlockReason.dailyLimit,
      );
    }

    if (lastSuccessfulRewardAt != null) {
      final nextEligibleAt = lastSuccessfulRewardAt.add(runeShrineCooldown);
      if (now.isBefore(nextEligibleAt)) {
        return RewardedAdDecision.unavailable(
          RewardedAdBlockReason.cooldown,
          remainingCooldown: nextEligibleAt.difference(now),
        );
      }
    }

    return isPro
        ? RewardedAdDecision.directProGrant()
        : RewardedAdDecision.watchAd();
  }

  RewardedAdDecision evaluatePveDefeat({
    required BattleSessionSnapshot session,
    required bool isRankedPvp,
    required bool isPro,
  }) {
    if (isRankedPvp) {
      return RewardedAdDecision.unavailable(
        RewardedAdBlockReason.rankedPvp,
      );
    }
    if (session.phase != BattleSessionPhase.defeat) {
      return RewardedAdDecision.unavailable(
        RewardedAdBlockReason.battleNotDefeated,
      );
    }
    if (session.rewardedRetriesRemaining <= 0) {
      return RewardedAdDecision.unavailable(
        RewardedAdBlockReason.retryUnavailable,
      );
    }

    return isPro
        ? RewardedAdDecision.directProGrant()
        : RewardedAdDecision.watchAd();
  }

  bool rewardMayApply({
    required RewardedAdDecision decision,
    ExternalAdOutcome? externalAdOutcome,
  }) {
    return switch (decision.deliveryMode) {
      RewardDeliveryMode.unavailable => false,
      RewardDeliveryMode.directProGrant => true,
      RewardDeliveryMode.watchAd =>
        externalAdOutcome == ExternalAdOutcome.completed,
    };
  }
}
