enum PerformanceTrend { consistentlyComfortable, balanced, struggling }

enum AdaptationDirection { increaseGradually, hold, decrease }

/// Caller-owned evidence distilled from the product-authoritative inputs.
///
/// The engine intentionally receives a classified performance trend rather than
/// inventing thresholds for 7/28-day performance, form scores, mastery,
/// completion rate, preferred duration, goals or capacity. Those raw-data
/// thresholds remain an analytics/product-configuration concern.
class DynamicDifficultyInput {
  const DynamicDifficultyInput({
    required this.playerLevel,
    required this.performanceTrend,
    this.movementUnsuitable = false,
    this.recoveryRecommended = false,
  }) : assert(playerLevel >= 0);

  final int playerLevel;
  final PerformanceTrend performanceTrend;
  final bool movementUnsuitable;
  final bool recoveryRecommended;
}

class DynamicDifficultyDecision {
  const DynamicDifficultyDecision({
    required this.repetitionOrDuration,
    required this.encounterDifficulty,
    required this.bossPhase,
    required this.taskDensity,
    required this.offerAlternativeMovement,
    required this.recoveryRoute,
  });

  final AdaptationDirection repetitionOrDuration;
  final AdaptationDirection encounterDifficulty;
  final AdaptationDirection bossPhase;
  final AdaptationDirection taskDensity;
  final bool offerAlternativeMovement;
  final bool recoveryRoute;
}

/// Deterministic policy layer for the REQUIRED Dynamic Difficulty system.
///
/// It changes only direction, never numeric balance. Recovery/Safety can
/// override upward pressure, and an unsuitable movement requests an alternative
/// without fabricating medical conclusions.
class DynamicDifficultyEngine {
  const DynamicDifficultyEngine();

  DynamicDifficultyDecision evaluate(DynamicDifficultyInput input) {
    if (input.recoveryRecommended) {
      return const DynamicDifficultyDecision(
        repetitionOrDuration: AdaptationDirection.decrease,
        encounterDifficulty: AdaptationDirection.decrease,
        bossPhase: AdaptationDirection.decrease,
        taskDensity: AdaptationDirection.decrease,
        offerAlternativeMovement: true,
        recoveryRoute: true,
      );
    }

    if (input.movementUnsuitable) {
      return const DynamicDifficultyDecision(
        repetitionOrDuration: AdaptationDirection.hold,
        encounterDifficulty: AdaptationDirection.hold,
        bossPhase: AdaptationDirection.hold,
        taskDensity: AdaptationDirection.hold,
        offerAlternativeMovement: true,
        recoveryRoute: false,
      );
    }

    return switch (input.performanceTrend) {
      PerformanceTrend.consistentlyComfortable =>
        const DynamicDifficultyDecision(
          repetitionOrDuration: AdaptationDirection.increaseGradually,
          encounterDifficulty: AdaptationDirection.increaseGradually,
          bossPhase: AdaptationDirection.increaseGradually,
          taskDensity: AdaptationDirection.increaseGradually,
          offerAlternativeMovement: false,
          recoveryRoute: false,
        ),
      PerformanceTrend.balanced => const DynamicDifficultyDecision(
        repetitionOrDuration: AdaptationDirection.hold,
        encounterDifficulty: AdaptationDirection.hold,
        bossPhase: AdaptationDirection.hold,
        taskDensity: AdaptationDirection.hold,
        offerAlternativeMovement: false,
        recoveryRoute: false,
      ),
      PerformanceTrend.struggling => const DynamicDifficultyDecision(
        repetitionOrDuration: AdaptationDirection.decrease,
        encounterDifficulty: AdaptationDirection.decrease,
        bossPhase: AdaptationDirection.decrease,
        taskDensity: AdaptationDirection.decrease,
        offerAlternativeMovement: true,
        recoveryRoute: false,
      ),
    };
  }
}
