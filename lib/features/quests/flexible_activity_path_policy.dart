import 'package:flutter/foundation.dart';

enum ActivityDayState { inactive, active, recovery }

@immutable
class FlexibleActivityWindow {
  const FlexibleActivityWindow({
    required this.days,
    required this.activeDayGoal,
  });

  final List<ActivityDayState> days;
  final int activeDayGoal;

  int get activeDayCount => days
      .where((day) => day != ActivityDayState.inactive)
      .length;

  int get inactiveDayCount => days.length - activeDayCount;

  bool get goalReached => activeDayCount >= activeDayGoal;

  /// The locked product rule is intentionally non-punitive: one missed day
  /// does not erase previously-earned active days inside the seven-day window.
  bool get missedDayResetsWindowProgress => false;

  /// Missed days never become a debt that must be repaid later.
  int get missedDayDebt => 0;
}

/// Product owner for the flexible seven-day activity/streak contract.
///
/// The exact target (for example 5 active days out of 7) is configuration and
/// therefore caller-owned. This policy owns only the locked semantics:
/// - the evaluation window has exactly seven day slots;
/// - normal activity and Recovery Day both count as active;
/// - inactivity does not erase prior progress or create debt;
/// - Rune Surge comeback eligibility exists after a 1-2 day break when the
///   user returns on an active/recovery day.
class FlexibleActivityPathPolicy {
  const FlexibleActivityPathPolicy();

  static const windowLength = 7;

  FlexibleActivityWindow evaluate({
    required List<ActivityDayState> days,
    required int activeDayGoal,
  }) {
    if (days.length != windowLength) {
      throw ArgumentError.value(
        days.length,
        'days.length',
        'must equal the seven-day product window',
      );
    }
    if (activeDayGoal < 1 || activeDayGoal > windowLength) {
      throw ArgumentError.value(
        activeDayGoal,
        'activeDayGoal',
        'must be between 1 and $windowLength',
      );
    }

    return FlexibleActivityWindow(
      days: List.unmodifiable(days),
      activeDayGoal: activeDayGoal,
    );
  }

  bool isRuneSurgeComebackEligible({
    required int inactiveDaysBeforeReturn,
    required ActivityDayState returnDay,
  }) {
    if (inactiveDaysBeforeReturn < 0) {
      throw ArgumentError.value(
        inactiveDaysBeforeReturn,
        'inactiveDaysBeforeReturn',
        'must not be negative',
      );
    }

    final returnedActive = returnDay != ActivityDayState.inactive;
    return returnedActive &&
        inactiveDaysBeforeReturn >= 1 &&
        inactiveDaysBeforeReturn <= 2;
  }
}
