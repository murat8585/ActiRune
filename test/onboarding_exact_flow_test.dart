import 'package:actirune/features/onboarding/calibration_result_screen.dart';
import 'package:actirune/features/onboarding/first_calibration_engine.dart';
import 'package:actirune/features/onboarding/first_calibration_screen.dart';
import 'package:actirune/features/onboarding/onboarding_screen.dart';
import 'package:actirune/features/onboarding/onboarding_welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> startWelcome(WidgetTester tester) async {
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-onboarding-welcome.start')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(FirstCalibrationScreen), findsOneWidget);
  }

  testWidgets('Welcome advances only to First Calibration', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingWelcomeScreen), findsOneWidget);
    expect(find.byType(FirstCalibrationScreen), findsNothing);
    expect(find.byType(CalibrationResultScreen), findsNothing);

    await startWelcome(tester);

    expect(find.byType(OnboardingWelcomeScreen), findsNothing);
    expect(find.byType(CalibrationResultScreen), findsNothing);
  });

  testWidgets('Missing calibration runner cannot fabricate success', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
    await tester.pumpAndSettle();
    await startWelcome(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-first-calibration.start')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.byType(FirstCalibrationScreen), findsOneWidget);
    expect(find.byType(CalibrationResultScreen), findsNothing);
  });

  testWidgets('Blocked calibration assessment stays on First Calibration', (
    tester,
  ) async {
    var attempts = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(
          onRunCalibration: () async {
            attempts++;
            return _calibrationAssessment(cameraPoseIntroCompleted: false);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await startWelcome(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-first-calibration.start')),
    );
    await tester.pumpAndSettle();

    expect(attempts, 1);
    expect(find.byType(FirstCalibrationScreen), findsOneWidget);
    expect(find.byType(CalibrationResultScreen), findsNothing);
  });

  testWidgets(
    'Successful typed calibration exposes result and recalibrate returns',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScreen(
            onRunCalibration: () async => _calibrationAssessment(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await startWelcome(tester);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-first-calibration.start')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CalibrationResultScreen), findsOneWidget);

      await tester.tap(
        find.byKey(
          const ValueKey('artwork-hotspot-calibration-result.recalibrate'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FirstCalibrationScreen), findsOneWidget);
      expect(find.byType(CalibrationResultScreen), findsNothing);
    },
  );

  testWidgets('Ready calibration exposes the starting profile exactly once', (
    tester,
  ) async {
    final profiles = <StartingCalibrationProfile>[];
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(
          onRunCalibration: () async => _calibrationAssessment(),
          onCalibrationReady: (profile) async => profiles.add(profile),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await startWelcome(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-first-calibration.start')),
    );
    await tester.pumpAndSettle();

    expect(profiles, hasLength(1));
    expect(profiles.single.goalKey, 'general-fitness');
    expect(profiles.single.preferredSessionMinutes, 20);
    expect(profiles.single.experienceKey, 'starter');
  });

  testWidgets('failed completed-profile write keeps result closed', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(
          onRunCalibration: () async => _calibrationAssessment(),
          onCalibrationReady: (_) async => throw StateError('write failed'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await startWelcome(tester);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-first-calibration.start')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(FirstCalibrationScreen), findsOneWidget);
    expect(find.byType(CalibrationResultScreen), findsNothing);
  });

  testWidgets(
    'First Adventure leaves onboarding only after successful result',
    (tester) async {
      var enteredApp = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScreen(
            onRunCalibration: () async => _calibrationAssessment(),
            onEnterApp: () => enteredApp++,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await startWelcome(tester);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-first-calibration.start')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const ValueKey('artwork-hotspot-calibration-result.start-adventure'),
        ),
      );
      await tester.pump();

      expect(enteredApp, 1);
    },
  );

  testWidgets('Calibration information panels do not become fake hotspots', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(
          onRunCalibration: () async => _calibrationAssessment(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await startWelcome(tester);

    for (final id in const [
      'first-calibration.camera-ready',
      'first-calibration.body-ready',
      'first-calibration.light-ready',
      'first-calibration.area-ready',
      'first-calibration.squat',
      'first-calibration.lunge',
      'first-calibration.push-up',
      'first-calibration.plank',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsNothing);
    }
  });
}

FirstCalibrationAssessment _calibrationAssessment({
  bool cameraPoseIntroCompleted = true,
}) {
  const engine = FirstCalibrationEngine();
  return engine.evaluate(
    FirstCalibrationInput(
      profile: const CalibrationProfileInput(
        goalKey: 'general-fitness',
        preferredSessionMinutes: 20,
        experienceKey: 'starter',
      ),
      cameraPoseIntroCompleted: cameraPoseIntroCompleted,
      preferences: {
        for (final movement in CalibrationMovement.values)
          movement: CalibrationMovementPreference(
            movement: movement,
            suitability: CalibrationMovementSuitability.standard,
          ),
      },
      evidence: {
        for (final movement in CalibrationMovement.values)
          movement: CalibrationMovementEvidence(
            movement: movement,
            status: CalibrationEvidenceStatus.standardVerified,
            evidenceId: 'test-${movement.name}',
          ),
      },
    ),
  );
}
