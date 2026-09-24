import 'package:actirune/features/quests/flexible_activity_path_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = FlexibleActivityPathPolicy();

  test('seven-day window keeps active-day goal configurable', () {
    final window = policy.evaluate(
      days: const [
        ActivityDayState.active,
        ActivityDayState.inactive,
        ActivityDayState.active,
        ActivityDayState.recovery,
        ActivityDayState.active,
        ActivityDayState.inactive,
        ActivityDayState.active,
      ],
      activeDayGoal: 5,
    );

    expect(window.days, hasLength(7));
    expect(window.activeDayCount, 5);
    expect(window.inactiveDayCount, 2);
    expect(window.goalReached, isTrue);
  });

  test('Recovery Day counts as an active day', () {
    final window = policy.evaluate(
      days: const [
        ActivityDayState.recovery,
        ActivityDayState.recovery,
        ActivityDayState.inactive,
        ActivityDayState.inactive,
        ActivityDayState.inactive,
        ActivityDayState.inactive,
        ActivityDayState.inactive,
      ],
      activeDayGoal: 2,
    );

    expect(window.activeDayCount, 2);
    expect(window.goalReached, isTrue);
  });

  test('missed days do not erase progress or create debt', () {
    final window = policy.evaluate(
      days: const [
        ActivityDayState.active,
        ActivityDayState.inactive,
        ActivityDayState.inactive,
        ActivityDayState.active,
        ActivityDayState.inactive,
        ActivityDayState.recovery,
        ActivityDayState.inactive,
      ],
      activeDayGoal: 5,
    );

    expect(window.activeDayCount, 3);
    expect(window.goalReached, isFalse);
    expect(window.missedDayResetsWindowProgress, isFalse);
    expect(window.missedDayDebt, 0);
  });

  test('one or two inactive days enable Rune Surge on active return', () {
    for (final inactiveDays in [1, 2]) {
      expect(
        policy.isRuneSurgeComebackEligible(
          inactiveDaysBeforeReturn: inactiveDays,
          returnDay: ActivityDayState.active,
        ),
        isTrue,
      );
      expect(
        policy.isRuneSurgeComebackEligible(
          inactiveDaysBeforeReturn: inactiveDays,
          returnDay: ActivityDayState.recovery,
        ),
        isTrue,
      );
    }
  });

  test('Rune Surge stays closed without a qualifying comeback', () {
    for (final inactiveDays in [0, 3, 7]) {
      expect(
        policy.isRuneSurgeComebackEligible(
          inactiveDaysBeforeReturn: inactiveDays,
          returnDay: ActivityDayState.active,
        ),
        isFalse,
      );
    }

    expect(
      policy.isRuneSurgeComebackEligible(
        inactiveDaysBeforeReturn: 1,
        returnDay: ActivityDayState.inactive,
      ),
      isFalse,
    );
  });

  test('invalid window size and goal fail closed', () {
    expect(
      () => policy.evaluate(
        days: const [ActivityDayState.active],
        activeDayGoal: 1,
      ),
      throwsArgumentError,
    );
    expect(
      () => policy.evaluate(
        days: List.filled(7, ActivityDayState.active),
        activeDayGoal: 0,
      ),
      throwsArgumentError,
    );
    expect(
      () => policy.evaluate(
        days: List.filled(7, ActivityDayState.active),
        activeDayGoal: 8,
      ),
      throwsArgumentError,
    );
  });

  test('negative inactive-day evidence is rejected', () {
    expect(
      () => policy.isRuneSurgeComebackEligible(
        inactiveDaysBeforeReturn: -1,
        returnDay: ActivityDayState.active,
      ),
      throwsArgumentError,
    );
  });
}
