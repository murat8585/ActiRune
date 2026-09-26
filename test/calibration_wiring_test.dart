import 'package:actirune/app/actirune_app.dart';
import 'package:actirune/features/onboarding/calibration_app_state.dart';
import 'package:actirune/features/onboarding/calibration_movement_sequence.dart';
import 'package:actirune/features/onboarding/calibration_result_screen.dart';
import 'package:actirune/features/onboarding/first_calibration_engine.dart';
import 'package:actirune/features/onboarding/first_calibration_flow_screen.dart';
import 'package:actirune/features/onboarding/first_calibration_screen.dart';
import 'package:actirune/features/onboarding/onboarding_screen.dart';
import 'package:actirune/features/pose/detector/pose_rep_detector.dart';
import 'package:actirune/features/pose/detector/verified_rep.dart';
import 'package:actirune/features/pose/provider/pose_camera_controller.dart';
import 'package:actirune/features/pose/provider/pose_models.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_support/standing_calibration_frames.dart';

final _baseTime = DateTime.utc(2026, 9, 25);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('production root opens the standing calibration flow', (
    tester,
  ) async {
    var factoryCalls = 0;

    await tester.pumpWidget(
      ActiRuneApp(
        calibrationCameraSessionFactory:
            ({
              required detector,
              required onVerifiedRep,
              required onPoseFrame,
            }) {
              factoryCalls++;
              return _FakeCameraSession(
                detector: detector,
                onVerifiedRep: onVerifiedRep,
                onPoseFrame: onPoseFrame,
                startupFrame: _fullBodyFrame(at: _baseTime),
              );
            },
      ),
    );
    await tester.pumpAndSettle();

    await _openCalibrationArtwork(tester);
    final startHotspot = find.byKey(
      const ValueKey('artwork-hotspot-first-calibration.start'),
    );
    expect(tester.widget<Semantics>(startHotspot).properties.enabled, isTrue);
    await tester.tap(startHotspot);
    await tester.pumpAndSettle();

    expect(find.byType(FirstCalibrationFlowScreen), findsOneWidget);
    expect(factoryCalls, 0);
    expect(find.byType(CalibrationResultScreen), findsNothing);
  });

  testWidgets('production four-rep flow persists completed profile', (
    tester,
  ) async {
    final store = InMemoryCalibrationStateStore();
    _FakeCameraSession? session;
    await tester.pumpWidget(
      ActiRuneApp(
        calibrationStateStore: store,
        calibrationCameraSessionFactory:
            ({
              required detector,
              required onVerifiedRep,
              required onPoseFrame,
            }) => session = _FakeCameraSession(
              detector: detector,
              onVerifiedRep: onVerifiedRep,
              onPoseFrame: onPoseFrame,
              startupFrame: _fullBodyFrame(at: _baseTime),
            ),
      ),
    );
    await tester.pumpAndSettle();
    await _openCalibrationArtwork(tester);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-first-calibration.start')),
    );
    await tester.pumpAndSettle();
    expect((await store.read()).status, CalibrationStatus.inProgress);
    await _fillInputsAndSelectStandardMovements(tester);
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('first-calibration.prepare-camera')),
    );
    await tester.pump(const Duration(seconds: 6));
    for (final frame in _verifiedFramesForAllMovements()) {
      session!.emit(frame);
    }
    await tester.pumpAndSettle();
    expect(find.byType(CalibrationResultScreen), findsOneWidget);
    final state = await store.read();
    expect(state.status, CalibrationStatus.completed);
    expect(state.hasCompletedCalibration, isTrue);
    expect(
      state.startingProfile?.movementPreferences.keys.toList(),
      CalibrationMovement.values,
    );
  });

  testWidgets('camera permission denial cannot create a calibration result', (
    tester,
  ) async {
    _FakeCameraSession? session;
    await _pumpApp(
      tester,
      sessionBuilder: (detector, onVerifiedRep, onPoseFrame) =>
          session = _FakeCameraSession(
            detector: detector,
            onVerifiedRep: onVerifiedRep,
            onPoseFrame: onPoseFrame,
            startError: CameraException('CameraAccessDenied', 'denied'),
          ),
    );
    await _openCalibrationArtwork(tester);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-first-calibration.start')),
    );
    await tester.pumpAndSettle();
    await _fillInputsAndSelectStandardMovements(tester);
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('first-calibration.prepare-camera')),
    );
    await tester.pumpAndSettle();

    expect(session!.startCalls, 1);
    expect(
      find.byKey(const ValueKey('first-calibration.camera-error')),
      findsOneWidget,
    );
    expect(find.textContaining('Kamera izni verilmedi'), findsOneWidget);
    expect(find.byType(CalibrationResultScreen), findsNothing);
    expect(
      find.byKey(const ValueKey('first-calibration.retry-camera')),
      findsOneWidget,
    );
  });

  testWidgets('partial pose readiness cannot start movement capture', (
    tester,
  ) async {
    _FakeCameraSession? session;
    await _pumpApp(
      tester,
      sessionBuilder: (detector, onVerifiedRep, onPoseFrame) =>
          session = _FakeCameraSession(
            detector: detector,
            onVerifiedRep: onVerifiedRep,
            onPoseFrame: onPoseFrame,
            startupFrame: PoseFrame(
              timestamp: _baseTime,
              joints: const {
                Joint.leftShoulder: JointPoint(x: 0, y: 0, confidence: 1),
              },
            ),
          ),
    );
    await _openCalibrationArtwork(tester);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-first-calibration.start')),
    );
    await tester.pumpAndSettle();
    await _fillInputsAndSelectStandardMovements(tester);
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('first-calibration.prepare-camera')),
    );
    await tester.pumpAndSettle();

    expect(session!.isReady, isTrue);
    expect(
      find.byKey(const ValueKey('first-calibration.readiness-status')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('first-calibration.active-movement')),
      findsNothing,
    );
    expect(find.byType(CalibrationResultScreen), findsNothing);
  });

  testWidgets('camera and pose readiness without real movements is blocked', (
    tester,
  ) async {
    _FakeCameraSession? session;
    await _pumpApp(
      tester,
      sessionBuilder: (detector, onVerifiedRep, onPoseFrame) =>
          session = _FakeCameraSession(
            detector: detector,
            onVerifiedRep: onVerifiedRep,
            onPoseFrame: onPoseFrame,
            startupFrame: _fullBodyFrame(at: _baseTime),
          ),
    );
    await _openCalibrationArtwork(tester);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-first-calibration.start')),
    );
    await tester.pumpAndSettle();
    await _fillInputsAndSelectStandardMovements(tester);
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('first-calibration.prepare-camera')),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 6));

    expect(session!.isReady, isTrue);
    expect(session!.capturedEvidence, isEmpty);
    expect(
      find.byKey(const ValueKey('first-calibration.active-movement')),
      findsOneWidget,
    );
    expect(find.byType(CalibrationResultScreen), findsNothing);
  });

  testWidgets('fake camera countdown cancels on body loss and restarts', (
    tester,
  ) async {
    _FakeCameraSession? session;
    await _pumpApp(
      tester,
      sessionBuilder: (detector, onVerifiedRep, onPoseFrame) =>
          session = _FakeCameraSession(
            detector: detector,
            onVerifiedRep: onVerifiedRep,
            onPoseFrame: onPoseFrame,
            startupFrame: _fullBodyFrame(at: _baseTime),
          ),
    );
    await _openCalibrationArtwork(tester);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-first-calibration.start')),
    );
    await tester.pumpAndSettle();
    await _fillInputsAndSelectStandardMovements(tester);
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('first-calibration.prepare-camera')),
    );
    await tester.pump(const Duration(milliseconds: 1900));
    expect(find.textContaining('sabit kal'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('first-calibration.active-movement')),
      findsNothing,
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('3'), findsOneWidget);
    session!.emit(PoseFrame(timestamp: _baseTime, joints: const {}));
    await tester.pump();
    expect(find.textContaining('bekleniyor'), findsWidgets);
    await tester.pump(const Duration(seconds: 3));
    expect(
      find.byKey(const ValueKey('first-calibration.active-movement')),
      findsNothing,
    );
    session!.emit(
      _fullBodyFrame(at: _baseTime.add(const Duration(seconds: 4))),
    );
    session!.emit(
      _fullBodyFrame(at: _baseTime.add(const Duration(seconds: 5))),
    );
    await tester.pump(const Duration(milliseconds: 1900));
    expect(
      find.byKey(const ValueKey('first-calibration.active-movement')),
      findsNothing,
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('3'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('2'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('1'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(
      find.byKey(const ValueKey('first-calibration.active-movement')),
      findsOneWidget,
    );
    expect(session!.capturedEvidence, isEmpty);
  });

  testWidgets('four detector-verified movements open the ready result', (
    tester,
  ) async {
    _FakeCameraSession? session;
    await _pumpApp(
      tester,
      sessionBuilder: (detector, onVerifiedRep, onPoseFrame) =>
          session = _FakeCameraSession(
            detector: detector,
            onVerifiedRep: onVerifiedRep,
            onPoseFrame: onPoseFrame,
            startupFrame: _fullBodyFrame(at: _baseTime),
          ),
    );
    await _openCalibrationArtwork(tester);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-first-calibration.start')),
    );
    await tester.pumpAndSettle();
    await _fillInputsAndSelectStandardMovements(tester);
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('first-calibration.prepare-camera')),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 6));

    for (final frame in _verifiedFramesForAllMovements()) {
      session!.emit(frame);
    }
    await tester.pumpAndSettle();

    expect(session!.capturedEvidence, hasLength(4));
    expect(find.byType(CalibrationResultScreen), findsOneWidget);
  });

  test(
    'empty and non-repetition frames never fabricate production evidence',
    () {
      final sequence = CalibrationMovementSequence(
        preferences: _standardPreferences(),
      )..enableCapture();
      final frames = [
        _fullBodyFrame(at: _baseTime),
        PoseFrame(
          timestamp: _baseTime.add(const Duration(seconds: 1)),
          joints: const {},
        ),
        _fullBodyFrame(
          at: _baseTime.add(const Duration(seconds: 2)),
          confidence: .2,
        ),
      ];
      for (final frame in frames) {
        expect(sequence.process(frame), isNull);
      }

      expect(sequence.evidence, isEmpty);
      expect(sequence.isComplete, isFalse);
    },
  );
}

Future<void> _pumpApp(
  WidgetTester tester, {
  required _FakeCameraSession Function(
    PoseRepDetector detector,
    void Function(VerifiedRep) onVerifiedRep,
    void Function(PoseFrame) onPoseFrame,
  )
  sessionBuilder,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => OnboardingScreen(
          onRunCalibration: () =>
              Navigator.of(context).push<FirstCalibrationAssessment>(
                MaterialPageRoute(
                  builder: (_) => FirstCalibrationFlowScreen(
                    cameraSessionFactory:
                        ({
                          required detector,
                          required onVerifiedRep,
                          required onPoseFrame,
                        }) => sessionBuilder(
                          detector,
                          onVerifiedRep,
                          onPoseFrame,
                        ),
                  ),
                ),
              ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _openCalibrationArtwork(WidgetTester tester) async {
  await tester.tap(
    find.byKey(const ValueKey('artwork-hotspot-onboarding-welcome.start')),
  );
  await tester.pumpAndSettle();
  expect(find.byType(FirstCalibrationScreen), findsOneWidget);
}

Future<void> _fillInputsAndSelectStandardMovements(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const ValueKey('first-calibration.goal')),
    'Daha hareketli olmak',
  );
  await tester.enterText(
    find.byKey(const ValueKey('first-calibration.session-minutes')),
    '20',
  );
  await tester.enterText(
    find.byKey(const ValueKey('first-calibration.experience')),
    'Başlangıç',
  );

  for (final movement in CalibrationMovement.values) {
    final preference = find.byKey(
      ValueKey('first-calibration.preference.${movement.name}'),
    );
    await tester.ensureVisible(preference);
    await tester.pumpAndSettle();
    final option = find.descendant(
      of: preference,
      matching: find.text('Standart uygun'),
    );
    await tester.tap(option);
    await tester.pump();
  }
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pump();
}

class _FakeCameraSession implements PoseCameraSession {
  _FakeCameraSession({
    required this.detector,
    required this.onVerifiedRep,
    required this.onPoseFrame,
    this.startupFrame,
    this.startError,
  });

  final PoseRepDetector detector;
  final void Function(VerifiedRep) onVerifiedRep;
  final void Function(PoseFrame) onPoseFrame;
  final PoseFrame? startupFrame;
  final Object? startError;
  int startCalls = 0;
  final Map<CalibrationMovement, CalibrationMovementEvidence> capturedEvidence =
      {};

  @override
  CameraController? get camera => null;

  @override
  bool isReady = false;

  @override
  Object? error;

  @override
  Future<void> start() async {
    startCalls++;
    error = startError;
    isReady = startError == null;
    final frame = startupFrame;
    if (isReady && frame != null) emit(frame);
  }

  void emit(PoseFrame frame) {
    final activeDetector = detector;
    final rep = activeDetector.process(frame);
    if (activeDetector is CalibrationMovementSequence) {
      capturedEvidence
        ..clear()
        ..addAll(activeDetector.evidence);
    }
    onPoseFrame(frame);
    if (rep != null) onVerifiedRep(rep);
  }

  @override
  Future<void> stop() async {
    isReady = false;
  }

  @override
  Future<void> dispose() async {
    isReady = false;
  }
}

Map<CalibrationMovement, CalibrationMovementPreference>
_standardPreferences() => {
  for (final movement in CalibrationMovement.values)
    movement: CalibrationMovementPreference(
      movement: movement,
      suitability: CalibrationMovementSuitability.standard,
    ),
};

PoseFrame _fullBodyFrame({
  required DateTime at,
  double confidence = 1,
  Map<Joint, JointPoint> overrides = const {},
}) {
  final joints = <Joint, JointPoint>{
    for (final joint in Joint.values)
      joint: JointPoint(
        x: joint.index.toDouble() + .25,
        y: joint.index.toDouble() + .75,
        confidence: confidence,
      ),
  }..addAll(overrides);
  return PoseFrame(timestamp: at, joints: joints);
}

List<PoseFrame> _verifiedFramesForAllMovements() => [
  standingFrame(1000),
  squatFrame(1100, bottom: false),
  squatFrame(1200),
  squatFrame(1500, bottom: false),
  standingFrame(1600),
  standingFrame(1700),
  reverseStep(1800),
  reverseBottom(1900),
  reverseBottom(2050),
  reverseReturning(2200),
  standingFrame(2300),
  standingFrame(2400),
  highKneeFrame(2500),
  highKneeFrame(2700),
  standingFrame(3000),
  standingFrame(3100),
  crossBodyFrame(3200),
  crossBodyFrame(3400),
  standingFrame(3700),
];
