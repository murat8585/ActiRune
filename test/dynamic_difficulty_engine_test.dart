import 'package:actirune/features/adaptation/dynamic_difficulty_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = DynamicDifficultyEngine();

  test('consistently comfortable performance increases only gradually', () {
    final decision = engine.evaluate(
      const DynamicDifficultyInput(
        playerLevel: 12,
        performanceTrend: PerformanceTrend.consistentlyComfortable,
      ),
    );

    expect(
      decision.repetitionOrDuration,
      AdaptationDirection.increaseGradually,
    );
    expect(
      decision.encounterDifficulty,
      AdaptationDirection.increaseGradually,
    );
    expect(decision.bossPhase, AdaptationDirection.increaseGradually);
    expect(decision.taskDensity, AdaptationDirection.increaseGradually);
    expect(decision.offerAlternativeMovement, isFalse);
    expect(decision.recoveryRoute, isFalse);
  });

  test('balanced performance holds all product-authoritative outputs', () {
    final decision = engine.evaluate(
      const DynamicDifficultyInput(
        playerLevel: 30,
        performanceTrend: PerformanceTrend.balanced,
      ),
    );

    expect(decision.repetitionOrDuration, AdaptationDirection.hold);
    expect(decision.encounterDifficulty, AdaptationDirection.hold);
    expect(decision.bossPhase, AdaptationDirection.hold);
    expect(decision.taskDensity, AdaptationDirection.hold);
    expect(decision.offerAlternativeMovement, isFalse);
    expect(decision.recoveryRoute, isFalse);
  });

  test('struggling performance decreases pressure and offers alternative', () {
    final decision = engine.evaluate(
      const DynamicDifficultyInput(
        playerLevel: 8,
        performanceTrend: PerformanceTrend.struggling,
      ),
    );

    expect(decision.repetitionOrDuration, AdaptationDirection.decrease);
    expect(decision.encounterDifficulty, AdaptationDirection.decrease);
    expect(decision.bossPhase, AdaptationDirection.decrease);
    expect(decision.taskDensity, AdaptationDirection.decrease);
    expect(decision.offerAlternativeMovement, isTrue);
    expect(decision.recoveryRoute, isFalse);
  });

  test('unsuitable movement requests alternative without invented escalation', () {
    final decision = engine.evaluate(
      const DynamicDifficultyInput(
        playerLevel: 50,
        performanceTrend: PerformanceTrend.consistentlyComfortable,
        movementUnsuitable: true,
      ),
    );

    expect(decision.repetitionOrDuration, AdaptationDirection.hold);
    expect(decision.encounterDifficulty, AdaptationDirection.hold);
    expect(decision.bossPhase, AdaptationDirection.hold);
    expect(decision.taskDensity, AdaptationDirection.hold);
    expect(decision.offerAlternativeMovement, isTrue);
    expect(decision.recoveryRoute, isFalse);
  });

  test('Recovery Safety overrides upward difficulty pressure', () {
    final decision = engine.evaluate(
      const DynamicDifficultyInput(
        playerLevel: 50,
        performanceTrend: PerformanceTrend.consistentlyComfortable,
        recoveryRecommended: true,
      ),
    );

    expect(decision.repetitionOrDuration, AdaptationDirection.decrease);
    expect(decision.encounterDifficulty, AdaptationDirection.decrease);
    expect(decision.bossPhase, AdaptationDirection.decrease);
    expect(decision.taskDensity, AdaptationDirection.decrease);
    expect(decision.offerAlternativeMovement, isTrue);
    expect(decision.recoveryRoute, isTrue);
  });
}
