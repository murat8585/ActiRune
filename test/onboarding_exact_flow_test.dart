import 'package:actirune/features/onboarding/calibration_result_screen.dart';
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

  testWidgets('Failed calibration stays on First Calibration', (tester) async {
    var attempts = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(
          onRunCalibration: () async {
            attempts++;
            return false;
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

  testWidgets('Successful calibration exposes result and recalibrate returns', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: OnboardingScreen(onRunCalibration: () async => true)),
    );
    await tester.pumpAndSettle();
    await startWelcome(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-first-calibration.start')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CalibrationResultScreen), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-calibration-result.recalibrate')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FirstCalibrationScreen), findsOneWidget);
    expect(find.byType(CalibrationResultScreen), findsNothing);
  });

  testWidgets('First Adventure leaves onboarding only after successful result', (
    tester,
  ) async {
    var enteredApp = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(
          onRunCalibration: () async => true,
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
  });

  testWidgets('Calibration information panels do not become fake hotspots', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: OnboardingScreen(onRunCalibration: () async => true)),
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
