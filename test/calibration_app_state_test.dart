import 'package:actirune/features/onboarding/calibration_app_state.dart';
import 'package:actirune/features/onboarding/first_calibration_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('skipped state persists without a starting profile', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final store = SharedPreferencesCalibrationStateStore(preferences);

    await store.write(const CalibrationAppState.skipped());
    final restored = await store.read();

    expect(restored.status, CalibrationStatus.skipped);
    expect(restored.startingProfile, isNull);
    expect(restored.hasCompletedCalibration, isFalse);
  });

  test('only a real completed profile restores completed status', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final store = SharedPreferencesCalibrationStateStore(preferences);
    final profile = StartingCalibrationProfile(
      goalKey: 'test-goal',
      preferredSessionMinutes: 17,
      experienceKey: 'test-experience',
      movementPreferences: {
        for (final movement in CalibrationMovement.values)
          movement: CalibrationMovementPreference(
            movement: movement,
            suitability: CalibrationMovementSuitability.standard,
          ),
      },
    );

    await store.write(CalibrationAppState.completed(profile));
    final restored = await store.read();

    expect(restored.status, CalibrationStatus.completed);
    expect(restored.startingProfile?.goalKey, 'test-goal');
    expect(restored.startingProfile?.preferredSessionMinutes, 17);
    expect(restored.startingProfile?.experienceKey, 'test-experience');
    expect(
      restored.startingProfile?.movementPreferences.keys.toSet(),
      CalibrationMovement.values.toSet(),
    );
  });

  test(
    'incomplete saved success fails closed to an unfinished state',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        SharedPreferencesCalibrationStateStore.storageKey,
        '{"status":"completed"}',
      );
      final store = SharedPreferencesCalibrationStateStore(preferences);

      final restored = await store.read();

      expect(restored.status, CalibrationStatus.inProgress);
      expect(restored.startingProfile, isNull);
      expect(restored.hasCompletedCalibration, isFalse);
    },
  );

  test('P5A completed schema never reinterprets generic lunge', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      SharedPreferencesCalibrationStateStore.storageKey,
      '{"status":"completed","startingProfile":{"goalKey":"x",'
      '"preferredSessionMinutes":20,"experienceKey":"x",'
      '"movementPreferences":[{"movement":"squat","suitability":"standard"},'
      '{"movement":"lunge","suitability":"standard"},'
      '{"movement":"pushUp","suitability":"standard"},'
      '{"movement":"plank","suitability":"standard"}]}}',
    );
    final restored = await SharedPreferencesCalibrationStateStore(
      preferences,
    ).read();
    expect(restored.status, CalibrationStatus.inProgress);
    expect(restored.hasCompletedCalibration, isFalse);
  });

  test('P5A skipped state remains readable without schema version', () async {
    SharedPreferences.setMockInitialValues({
      SharedPreferencesCalibrationStateStore.storageKey: '{"status":"skipped"}',
    });
    final preferences = await SharedPreferences.getInstance();
    final restored = await SharedPreferencesCalibrationStateStore(
      preferences,
    ).read();
    expect(restored.status, CalibrationStatus.skipped);
    expect(restored.startingProfile, isNull);
  });
}
