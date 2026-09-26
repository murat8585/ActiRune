import 'dart:math' as math;

import 'package:actirune/app/actirune_app.dart';
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

const _testPlankDuration = Duration(seconds: 1);
final _baseTime = DateTime.utc(2026, 9, 25);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('production root blocks legacy movement calibration until P5B', (
    tester,
  ) async {
    var factoryCalls = 0;

    await tester.pumpWidget(
      ActiRuneApp(
        requiredPlankHoldDuration: _testPlankDuration,
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

    expect(find.byType(FirstCalibrationFlowScreen), findsNothing);
    expect(factoryCalls, 0);
    expect(find.textContaining('P5B'), findsOneWidget);
    expect(find.byType(CalibrationResultScreen), findsNothing);
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
    'calibration sequence requires explicit product-owned plank duration',
    () {
      final sequence = CalibrationMovementSequence(
        preferences: _standardPreferences(),
        requiredPlankHoldDuration: null,
      )..enableCapture();

      for (final frame in _verifiedFramesForFirstThreeMovements()) {
        sequence.process(frame);
      }

      expect(sequence.evidence.keys.toSet(), {
        CalibrationMovement.squat,
        CalibrationMovement.lunge,
        CalibrationMovement.pushUp,
      });
      expect(sequence.currentMovement, CalibrationMovement.plank);
      expect(sequence.configurationError, contains('ürün yapılandırmasında'));
      expect(sequence.isComplete, isFalse);
    },
  );

  test('pose confidence loss cannot count hidden plank hold time', () {
    final sequence = CalibrationMovementSequence(
      preferences: _standardPreferences(),
      requiredPlankHoldDuration: _testPlankDuration,
    )..enableCapture();

    for (final frame in _verifiedFramesForFirstThreeMovements()) {
      sequence.process(frame);
    }

    sequence.process(_plankFrame(4000));
    sequence.process(_plankFrame(4500));
    sequence.process(_plankFrame(4800, confidence: .2));
    expect(sequence.evidence.containsKey(CalibrationMovement.plank), isFalse);

    sequence.process(_plankFrame(5000));
    expect(sequence.evidence.containsKey(CalibrationMovement.plank), isFalse);

    final completedHold = sequence.process(_plankFrame(6000));
    expect(completedHold?.exercise, 'plank');
    expect(sequence.evidence.containsKey(CalibrationMovement.plank), isTrue);
  });

  test('alternative preference cannot receive standard-detector evidence', () {
    final preferences = _standardPreferences()
      ..[CalibrationMovement.pushUp] = const CalibrationMovementPreference(
        movement: CalibrationMovement.pushUp,
        suitability: CalibrationMovementSuitability.alternativeRequired,
        alternativeKey: 'user-entered-alternative',
      );
    final sequence = CalibrationMovementSequence(
      preferences: preferences,
      requiredPlankHoldDuration: _testPlankDuration,
    )..enableCapture();

    for (final frame in [..._squatCycle(1000), ..._lungeCycle(2000)]) {
      sequence.process(frame);
    }
    expect(sequence.currentMovement, CalibrationMovement.pushUp);
    expect(sequence.configurationError, contains('alternatif'));
    final pushUpFrames = _pushUpCycle(12000);
    for (final frame in pushUpFrames) {
      sequence.process(frame);
    }

    expect(sequence.evidence.containsKey(CalibrationMovement.pushUp), isFalse);
    expect(sequence.configurationError, contains('alternatif'));
  });

  test(
    'empty and non-repetition frames never fabricate production evidence',
    () {
      final sequence = CalibrationMovementSequence(
        preferences: _standardPreferences(),
        requiredPlankHoldDuration: _testPlankDuration,
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
                    requiredPlankHoldDuration: _testPlankDuration,
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

JointPoint _point(double x, double y) => JointPoint(x: x, y: y, confidence: 1);

PoseFrame _squatFrame(int milliseconds, double kneeAngle) {
  final radians = kneeAngle * math.pi / 180;
  return _fullBodyFrame(
    at: _baseTime.add(Duration(milliseconds: milliseconds)),
    overrides: {
      Joint.leftHip: _point(math.cos(radians), math.sin(radians)),
      Joint.leftKnee: _point(0, 0),
      Joint.leftAnkle: _point(1, 0),
    },
  );
}

List<PoseFrame> _squatCycle(int start) => [
  _squatFrame(start, 170),
  _squatFrame(start + 100, 135),
  _squatFrame(start + 200, 90),
  _squatFrame(start + 500, 130),
  _squatFrame(start + 600, 170),
];

PoseFrame _lungeFrame(int milliseconds, double leftAngle, double rightAngle) {
  Map<Joint, JointPoint> leg(double angle, double offset) {
    final radians = angle * math.pi / 180;
    return {
      Joint.values[offset < 0 ? Joint.leftHip.index : Joint.rightHip.index]:
          _point(offset + math.cos(radians), math.sin(radians)),
      Joint.values[offset < 0 ? Joint.leftKnee.index : Joint.rightKnee.index]:
          _point(offset, 0),
      Joint.values[offset < 0 ? Joint.leftAnkle.index : Joint.rightAnkle.index]:
          _point(offset + 1, 0),
    };
  }

  return _fullBodyFrame(
    at: _baseTime.add(Duration(milliseconds: milliseconds)),
    overrides: {...leg(leftAngle, -2), ...leg(rightAngle, 2)},
  );
}

List<PoseFrame> _lungeCycle(int start) => [
  _lungeFrame(start, 170, 170),
  _lungeFrame(start + 100, 135, 168),
  _lungeFrame(start + 200, 90, 165),
  _lungeFrame(start + 500, 130, 166),
  _lungeFrame(start + 600, 170, 170),
];

PoseFrame _pushUpFrame(int milliseconds, double elbowAngle) {
  final elbowRadians = (180 - elbowAngle) * math.pi / 180;
  final bodyRadians = (180 - 175) * math.pi / 180;
  return _fullBodyFrame(
    at: _baseTime.add(Duration(milliseconds: milliseconds)),
    overrides: {
      Joint.leftShoulder: _point(0, 0),
      Joint.leftElbow: _point(1, 0),
      Joint.leftWrist: _point(
        1 + math.cos(elbowRadians),
        math.sin(elbowRadians),
      ),
      Joint.leftHip: _point(1, 0),
      Joint.leftAnkle: _point(1 + math.cos(bodyRadians), math.sin(bodyRadians)),
    },
  );
}

List<PoseFrame> _pushUpCycle(int start) => [
  _pushUpFrame(start, 170),
  _pushUpFrame(start + 100, 130),
  _pushUpFrame(start + 200, 80),
  _pushUpFrame(start + 500, 130),
  _pushUpFrame(start + 600, 170),
];

PoseFrame _plankFrame(int milliseconds, {double confidence = 1}) {
  final radians = (180 - 175) * math.pi / 180;
  return _fullBodyFrame(
    at: _baseTime.add(Duration(milliseconds: milliseconds)),
    confidence: confidence,
    overrides: {
      Joint.leftShoulder: _point(0, 0),
      Joint.leftHip: _point(1, 0),
      Joint.leftAnkle: _point(1 + math.cos(radians), math.sin(radians)),
    },
  );
}

List<PoseFrame> _plankCycle(int start) => [
  _plankFrame(start),
  _plankFrame(start + _testPlankDuration.inMilliseconds),
];

List<PoseFrame> _verifiedFramesForFirstThreeMovements() => [
  ..._squatCycle(1000),
  ..._lungeCycle(2000),
  ..._pushUpCycle(3000),
];

List<PoseFrame> _verifiedFramesForAllMovements() => [
  ..._verifiedFramesForFirstThreeMovements(),
  ..._plankCycle(4000),
];
