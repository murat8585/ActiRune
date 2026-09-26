import 'dart:io';

import 'package:actirune/app/actirune_app.dart';
import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/onboarding/calibration_app_state.dart';
import 'package:actirune/features/onboarding/calibration_result_screen.dart';
import 'package:actirune/features/onboarding/first_calibration_flow_screen.dart';
import 'package:actirune/features/onboarding/first_calibration_screen.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('production artwork has exact approved path and SHA-256', () async {
    const expected =
        'visual_authority/20260926/final/VIS_20260926_FIRST_CALIBRATION_FINAL.png';
    expect(FirstCalibrationScreen.artworkAsset, expected);
    final bytes = await File(expected).readAsBytes();
    expect(
      sha256.convert(bytes).toString().toUpperCase(),
      'DA877FBB6A2A5221FA4CDB40D2AC975329BEB7AD4D12EBDC8AB61FD061712F5A',
    );
  });

  testWidgets('skip persists distinct state and opens shell without success', (
    tester,
  ) async {
    final store = InMemoryCalibrationStateStore();
    await tester.pumpWidget(ActiRuneApp(calibrationStateStore: store));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-onboarding-welcome.start')),
    );
    await tester.pumpAndSettle();

    final start = find.byKey(
      const ValueKey('artwork-hotspot-first-calibration.start'),
    );
    final skip = find.byKey(
      const ValueKey('artwork-hotspot-first-calibration.skip'),
    );
    expect(start, findsOneWidget);
    expect(skip, findsOneWidget);
    expect(
      tester.widget<Semantics>(start).properties.label,
      'Kalibrasyona Başla',
    );
    expect(tester.widget<Semantics>(skip).properties.label, 'Şimdilik Geç');

    await tester.tap(skip);
    await tester.pumpAndSettle();
    expect(find.byType(MainShell), findsOneWidget);
    expect(find.byType(CalibrationResultScreen), findsNothing);
    expect(find.byType(FirstCalibrationFlowScreen), findsNothing);
    final state = await store.read();
    expect(state.status, CalibrationStatus.skipped);
    expect(state.hasCompletedCalibration, isFalse);
    expect(state.startingProfile, isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
      ActiRuneApp(
        calibrationStateStore: store,
        initialCalibrationState: await store.read(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(MainShell), findsOneWidget);
  });

  testWidgets('failed persistence keeps user on calibration intro', (
    tester,
  ) async {
    await tester.pumpWidget(
      ActiRuneApp(calibrationStateStore: _FailingStore()),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-onboarding-welcome.start')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-first-calibration.skip')),
    );
    await tester.pump();
    expect(find.byType(FirstCalibrationScreen), findsOneWidget);
    expect(find.byType(MainShell), findsNothing);
  });
}

class _FailingStore implements CalibrationStateStore {
  @override
  Future<CalibrationAppState> read() async =>
      const CalibrationAppState.notStarted();

  @override
  Future<void> write(CalibrationAppState state) async =>
      throw StateError('test persistence failure');
}
