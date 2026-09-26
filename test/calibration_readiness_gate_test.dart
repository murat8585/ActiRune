import 'package:actirune/features/onboarding/calibration_readiness_gate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('camera alone and partial pose never start countdown', () {
    final gate = CalibrationReadinessGate();
    gate.update(cameraReady: true, poseDetected: false, fullBodyReady: false);
    expect(gate.phase, CalibrationReadinessPhase.waitingForPose);
    expect(gate.advance(const Duration(seconds: 10)), isFalse);
    gate.update(cameraReady: true, poseDetected: true, fullBodyReady: false);
    expect(gate.advance(const Duration(seconds: 10)), isFalse);
    expect(gate.phase, CalibrationReadinessPhase.waitingForPose);
  });

  test('two stable seconds then 3, 2, 1 then capture exactly once', () {
    final gate = CalibrationReadinessGate();
    gate.update(cameraReady: true, poseDetected: true, fullBodyReady: true);
    for (var i = 0; i < 19; i++) {
      gate.update(cameraReady: true, poseDetected: true, fullBodyReady: true);
      expect(gate.advance(const Duration(milliseconds: 100)), isFalse);
    }
    expect(gate.phase, CalibrationReadinessPhase.stabilizing);
    expect(gate.advance(const Duration(milliseconds: 100)), isFalse);
    expect(gate.phase, CalibrationReadinessPhase.countdown);
    expect(gate.countdownNumber, 3);
    for (final expected in [2, 1]) {
      for (var i = 0; i < 10; i++) {
        expect(gate.advance(const Duration(milliseconds: 100)), isFalse);
      }
      expect(gate.countdownNumber, expected);
    }
    for (var i = 0; i < 9; i++) {
      expect(gate.advance(const Duration(milliseconds: 100)), isFalse);
    }
    expect(gate.advance(const Duration(milliseconds: 100)), isTrue);
    expect(gate.phase, CalibrationReadinessPhase.movementCapture);
    expect(gate.advance(const Duration(seconds: 10)), isFalse);
  });

  test('pose loss during stability restarts entire stability period', () {
    final gate = CalibrationReadinessGate();
    gate.update(cameraReady: true, poseDetected: true, fullBodyReady: true);
    gate.advance(const Duration(milliseconds: 1900));
    gate.update(cameraReady: true, poseDetected: false, fullBodyReady: false);
    expect(gate.phase, CalibrationReadinessPhase.waitingForPose);
    gate.update(cameraReady: true, poseDetected: true, fullBodyReady: true);
    gate.advance(const Duration(milliseconds: 1900));
    expect(gate.phase, CalibrationReadinessPhase.stabilizing);
    gate.advance(const Duration(milliseconds: 100));
    expect(gate.countdownNumber, 3);
  });

  test('body or camera loss cancels countdown and forbids capture', () {
    final gate = CalibrationReadinessGate();
    gate.update(cameraReady: true, poseDetected: true, fullBodyReady: true);
    gate.advance(const Duration(seconds: 2));
    gate.advance(const Duration(seconds: 1));
    expect(gate.countdownNumber, 2);
    gate.update(cameraReady: true, poseDetected: true, fullBodyReady: false);
    expect(gate.phase, CalibrationReadinessPhase.waitingForPose);
    expect(gate.advance(const Duration(seconds: 5)), isFalse);
    gate.update(cameraReady: true, poseDetected: true, fullBodyReady: true);
    gate.advance(const Duration(milliseconds: 1900));
    expect(gate.phase, CalibrationReadinessPhase.stabilizing);
    gate.update(cameraReady: false, poseDetected: true, fullBodyReady: true);
    expect(gate.phase, CalibrationReadinessPhase.waitingForCamera);
    expect(gate.advance(const Duration(seconds: 5)), isFalse);
  });
}
