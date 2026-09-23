enum RecoveryRoute { standard, lighterAlternative, recoveryDay }

/// Explicit, non-diagnostic safety/recovery evidence from product-owned input.
class RecoverySafetyInput {
  const RecoverySafetyInput({
    required this.consecutiveIntenseLowerBodyDays,
    this.userReportedPainOrUnsuitability = false,
    this.movementMarkedUnsuitable = false,
    this.formDegraded = false,
    this.unsafeSpeed = false,
  }) : assert(consecutiveIntenseLowerBodyDays >= 0);

  final int consecutiveIntenseLowerBodyDays;
  final bool userReportedPainOrUnsuitability;
  final bool movementMarkedUnsuitable;
  final bool formDegraded;
  final bool unsafeSpeed;
}

class RecoverySafetyDecision {
  const RecoverySafetyDecision({
    required this.route,
    required this.offerAlternativeMovement,
    required this.recoveryDayStreakEligible,
    required this.allowPerformanceReward,
  });

  final RecoveryRoute route;
  final bool offerAlternativeMovement;

  /// Product authority: a Recovery Day is a valuable active day and does not
  /// break the streak.
  final bool recoveryDayStreakEligible;

  /// Unsafe speed or degraded form must never be rewarded for a higher score.
  final bool allowPerformanceReward;

  bool get recommendsRecovery => route == RecoveryRoute.recoveryDay;
}

/// REQUIRED Recovery/Safety policy owner.
///
/// This engine never diagnoses an injury. It reacts only to explicit user or
/// product-owned signals, distributes recovery after two intense lower-body
/// days, and gates score/reward eligibility when speed or form is unsafe.
class RecoverySafetyEngine {
  const RecoverySafetyEngine();

  RecoverySafetyDecision evaluate(RecoverySafetyInput input) {
    final explicitAlternative =
        input.userReportedPainOrUnsuitability || input.movementMarkedUnsuitable;
    final recoveryDay = input.consecutiveIntenseLowerBodyDays >= 2;
    final unsafeForReward = input.formDegraded || input.unsafeSpeed;

    return RecoverySafetyDecision(
      route: recoveryDay
          ? RecoveryRoute.recoveryDay
          : explicitAlternative
          ? RecoveryRoute.lighterAlternative
          : RecoveryRoute.standard,
      offerAlternativeMovement: explicitAlternative || recoveryDay,
      recoveryDayStreakEligible: true,
      allowPerformanceReward: !unsafeForReward,
    );
  }
}
