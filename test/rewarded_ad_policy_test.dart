import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:actirune/features/monetization/rewarded_ad_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = RewardedAdPolicy();
  final now = DateTime.utc(2026, 9, 23, 12);

  test(
    'Rune Shrine uses locked four-hour cooldown and three-per-day limit',
    () {
      expect(RewardedAdPolicy.runeShrineCooldown, const Duration(hours: 4));
      expect(RewardedAdPolicy.runeShrineDailyLimit, 3);

      final first = policy.evaluateRuneShrine(
        now: now,
        lastSuccessfulRewardAt: null,
        successfulRewardsToday: 0,
        isPro: false,
      );
      expect(first.deliveryMode, RewardDeliveryMode.watchAd);

      final coolingDown = policy.evaluateRuneShrine(
        now: now,
        lastSuccessfulRewardAt: now.subtract(const Duration(hours: 3)),
        successfulRewardsToday: 1,
        isPro: false,
      );
      expect(coolingDown.eligible, isFalse);
      expect(coolingDown.blockReason, RewardedAdBlockReason.cooldown);
      expect(coolingDown.remainingCooldown, const Duration(hours: 1));

      final exactlyFourHours = policy.evaluateRuneShrine(
        now: now,
        lastSuccessfulRewardAt: now.subtract(const Duration(hours: 4)),
        successfulRewardsToday: 2,
        isPro: false,
      );
      expect(exactlyFourHours.deliveryMode, RewardDeliveryMode.watchAd);

      final dailyLimit = policy.evaluateRuneShrine(
        now: now,
        lastSuccessfulRewardAt: now.subtract(const Duration(hours: 8)),
        successfulRewardsToday: 3,
        isPro: false,
      );
      expect(dailyLimit.eligible, isFalse);
      expect(dailyLimit.blockReason, RewardedAdBlockReason.dailyLimit);
    },
  );

  test('eligible Pro Rune Shrine reward is direct and does not require ad', () {
    final decision = policy.evaluateRuneShrine(
      now: now,
      lastSuccessfulRewardAt: null,
      successfulRewardsToday: 0,
      isPro: true,
    );

    expect(decision.deliveryMode, RewardDeliveryMode.directProGrant);
    expect(policy.rewardMayApply(decision: decision), isTrue);
  });

  test('ad reward applies only after completed external ad outcome', () {
    final decision = policy.evaluateRuneShrine(
      now: now,
      lastSuccessfulRewardAt: null,
      successfulRewardsToday: 0,
      isPro: false,
    );

    expect(
      policy.rewardMayApply(
        decision: decision,
        externalAdOutcome: ExternalAdOutcome.completed,
      ),
      isTrue,
    );
    expect(
      policy.rewardMayApply(
        decision: decision,
        externalAdOutcome: ExternalAdOutcome.cancelled,
      ),
      isFalse,
    );
    expect(
      policy.rewardMayApply(
        decision: decision,
        externalAdOutcome: ExternalAdOutcome.failed,
      ),
      isFalse,
    );
    expect(policy.rewardMayApply(decision: decision), isFalse);
  });

  test('PvE rewarded retry is offerable only from defeat state', () {
    final session = BattleSessionEngine();

    for (final phaseAction in <void Function()>[
      session.enterCameraPrep,
      session.startLiveBattle,
      session.openFormCoach,
      session.markVictory,
    ]) {
      phaseAction();
      final decision = policy.evaluatePveDefeat(
        session: session.snapshot,
        isRankedPvp: false,
        isPro: false,
      );
      expect(decision.eligible, isFalse);
      expect(decision.blockReason, RewardedAdBlockReason.battleNotDefeated);
    }

    session.markDefeat();
    final defeatDecision = policy.evaluatePveDefeat(
      session: session.snapshot,
      isRankedPvp: false,
      isPro: false,
    );
    expect(defeatDecision.deliveryMode, RewardDeliveryMode.watchAd);
  });

  test('Ranked PvP never offers rewarded revive', () {
    final session = BattleSessionEngine()..markDefeat();

    final decision = policy.evaluatePveDefeat(
      session: session.snapshot,
      isRankedPvp: true,
      isPro: false,
    );

    expect(decision.eligible, isFalse);
    expect(decision.blockReason, RewardedAdBlockReason.rankedPvp);
  });

  test('battle retry count stays owned by current BattleSessionEngine', () {
    final session = BattleSessionEngine();

    for (var remaining = 3; remaining > 0; remaining--) {
      session.markDefeat();
      final decision = policy.evaluatePveDefeat(
        session: session.snapshot,
        isRankedPvp: false,
        isPro: false,
      );
      expect(decision.eligible, isTrue);
      expect(
        policy.rewardMayApply(
          decision: decision,
          externalAdOutcome: ExternalAdOutcome.completed,
        ),
        isTrue,
      );
      expect(session.restartAfterSuccessfulRewardedAd(), isTrue);
      expect(session.snapshot.rewardedRetriesRemaining, remaining - 1);
    }

    session.markDefeat();
    final exhausted = policy.evaluatePveDefeat(
      session: session.snapshot,
      isRankedPvp: false,
      isPro: false,
    );
    expect(exhausted.eligible, isFalse);
    expect(exhausted.blockReason, RewardedAdBlockReason.retryUnavailable);
  });

  test('invalid Rune Shrine counters fail closed', () {
    final decision = policy.evaluateRuneShrine(
      now: now,
      lastSuccessfulRewardAt: null,
      successfulRewardsToday: -1,
      isPro: false,
    );

    expect(decision.eligible, isFalse);
    expect(decision.blockReason, RewardedAdBlockReason.invalidState);
  });
}
