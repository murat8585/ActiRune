import 'package:actirune/features/adaptation/recovery_safety_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = RecoverySafetyEngine();

  test('standard route stays available without recovery or safety signal', () {
    final decision = engine.evaluate(
      const RecoverySafetyInput(consecutiveIntenseLowerBodyDays: 0),
    );

    expect(decision.route, RecoveryRoute.standard);
    expect(decision.offerAlternativeMovement, isFalse);
    expect(decision.recoveryDayStreakEligible, isTrue);
    expect(decision.allowPerformanceReward, isTrue);
  });

  test('two intense lower-body days recommend Recovery Day', () {
    final decision = engine.evaluate(
      const RecoverySafetyInput(consecutiveIntenseLowerBodyDays: 2),
    );

    expect(decision.route, RecoveryRoute.recoveryDay);
    expect(decision.recommendsRecovery, isTrue);
    expect(decision.offerAlternativeMovement, isTrue);
    expect(decision.recoveryDayStreakEligible, isTrue);
  });

  test('reported pain or unsuitability offers alternative without diagnosis', () {
    final decision = engine.evaluate(
      const RecoverySafetyInput(
        consecutiveIntenseLowerBodyDays: 0,
        userReportedPainOrUnsuitability: true,
      ),
    );

    expect(decision.route, RecoveryRoute.lighterAlternative);
    expect(decision.offerAlternativeMovement, isTrue);
    expect(decision.recommendsRecovery, isFalse);
  });

  test('movement marked unsuitable also offers lighter alternative', () {
    final decision = engine.evaluate(
      const RecoverySafetyInput(
        consecutiveIntenseLowerBodyDays: 0,
        movementMarkedUnsuitable: true,
      ),
    );

    expect(decision.route, RecoveryRoute.lighterAlternative);
    expect(decision.offerAlternativeMovement, isTrue);
  });

  test('unsafe speed cannot be rewarded for higher score', () {
    final decision = engine.evaluate(
      const RecoverySafetyInput(
        consecutiveIntenseLowerBodyDays: 0,
        unsafeSpeed: true,
      ),
    );

    expect(decision.allowPerformanceReward, isFalse);
  });

  test('degraded form cannot be rewarded for higher score', () {
    final decision = engine.evaluate(
      const RecoverySafetyInput(
        consecutiveIntenseLowerBodyDays: 0,
        formDegraded: true,
      ),
    );

    expect(decision.allowPerformanceReward, isFalse);
  });

  test('Recovery Day remains streak eligible even with safety flags', () {
    final decision = engine.evaluate(
      const RecoverySafetyInput(
        consecutiveIntenseLowerBodyDays: 2,
        userReportedPainOrUnsuitability: true,
        formDegraded: true,
      ),
    );

    expect(decision.route, RecoveryRoute.recoveryDay);
    expect(decision.offerAlternativeMovement, isTrue);
    expect(decision.recoveryDayStreakEligible, isTrue);
    expect(decision.allowPerformanceReward, isFalse);
  });
}
