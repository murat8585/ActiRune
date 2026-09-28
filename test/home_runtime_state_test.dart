import 'package:actirune/features/home/home_runtime_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('empty Home runtime state exposes no fabricated player data', () {
    const state = HomeRuntimeState();

    expect(state.hasAnyRuntimeData, isFalse);
    expect(state.playerName, isNull);
    expect(state.playerLevel, isNull);
    expect(state.stepsToday, isNull);
    expect(state.runeEnergyFraction, isNull);
    expect(state.worldProgressFraction, isNull);
  });

  test('authoritative caller values are exposed without defaults', () {
    const state = HomeRuntimeState(
      playerName: 'Player',
      playerLevel: 4,
      playerXpFraction: 0.25,
      activeDaysInCurrentSevenDayPath: 3,
      unreadInboxCount: 2,
      questBadgeCount: 1,
      stepsToday: 1200,
      verifiedMovementsToday: 8,
      activeMinutesToday: 21,
      runeEnergyFraction: 0.4,
      worldProgressFraction: 0.6,
      remainingEncounterSteps: 300,
      rewardBadgeCount: 1,
    );

    expect(state.hasAnyRuntimeData, isTrue);
    expect(state.playerName, 'Player');
    expect(state.stepsToday, 1200);
    expect(state.runeEnergyFraction, 0.4);
    expect(state.worldProgressFraction, 0.6);
  });

  test('invalid normalized and count values fail closed in debug/test', () {
    expect(
      () => HomeRuntimeState(playerLevel: 0),
      throwsAssertionError,
    );
    expect(
      () => HomeRuntimeState(playerXpFraction: 1.01),
      throwsAssertionError,
    );
    expect(
      () => HomeRuntimeState(runeEnergyFraction: -0.01),
      throwsAssertionError,
    );
    expect(
      () => HomeRuntimeState(activeDaysInCurrentSevenDayPath: 8),
      throwsAssertionError,
    );
    expect(
      () => HomeRuntimeState(remainingEncounterSteps: -1),
      throwsAssertionError,
    );
  });
}
