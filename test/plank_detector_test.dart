import 'dart:math' as math;

import 'package:actirune/features/pose/detector/plank_detector.dart';
import 'package:actirune/features/pose/detector/verified_rep.dart';
import 'package:actirune/features/pose/provider/pose_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final base = DateTime.utc(2026);

  PoseFrame frame(
    int milliseconds, {
    double bodyLineAngle = 175,
    double confidence = 1,
    bool useRightSide = false,
  }) {
    final radians = (180 - bodyLineAngle) * math.pi / 180;
    final shoulder = JointPoint(x: 0, y: 0, confidence: confidence);
    final hip = JointPoint(x: 1, y: 0, confidence: confidence);
    final ankle = JointPoint(
      x: 1 + math.cos(radians),
      y: math.sin(radians),
      confidence: confidence,
    );

    final joints = <Joint, JointPoint>{};
    if (useRightSide) {
      joints.addAll({
        Joint.rightShoulder: shoulder,
        Joint.rightHip: hip,
        Joint.rightAnkle: ankle,
      });
    } else {
      joints.addAll({
        Joint.leftShoulder: shoulder,
        Joint.leftHip: hip,
        Joint.leftAnkle: ankle,
      });
    }

    return PoseFrame(
      timestamp: base.add(Duration(milliseconds: milliseconds)),
      joints: joints,
    );
  }

  test('continuous valid plank emits once after required hold duration', () {
    final detector = PlankDetector(
      requiredHoldDuration: const Duration(seconds: 2),
    );

    expect(detector.process(frame(0)), isNull);
    expect(detector.process(frame(1000)), isNull);
    final rep = detector.process(frame(2000));

    expect(rep, isNotNull);
    expect(rep!.exercise, 'plank');
    expect(detector.accumulatedValidDuration, const Duration(seconds: 2));
    expect(detector.completedCurrentHold, isTrue);
  });

  test('insufficient valid hold duration never emits an event', () {
    final detector = PlankDetector(
      requiredHoldDuration: const Duration(seconds: 2),
    );

    detector.process(frame(0));
    detector.process(frame(700));
    final result = detector.process(frame(1500));

    expect(result, isNull);
    expect(detector.accumulatedValidDuration, const Duration(milliseconds: 1500));
  });

  test('observed body-line failure resets current hold progress', () {
    final detector = PlankDetector(
      requiredHoldDuration: const Duration(seconds: 2),
    );

    detector.process(frame(0));
    detector.process(frame(1200));
    detector.process(frame(1300, bodyLineAngle: 120));

    expect(detector.accumulatedValidDuration, Duration.zero);
    expect(detector.completedCurrentHold, isFalse);
    expect(detector.process(frame(2000)), isNull);
    expect(detector.process(frame(2900)), isNull);
    expect(detector.process(frame(4000)), isNotNull);
  });

  test('low confidence freezes progress and hidden time is not counted', () {
    final detector = PlankDetector(
      requiredHoldDuration: const Duration(seconds: 2),
    );

    detector.process(frame(0));
    detector.process(frame(1000));
    detector.process(frame(1500, confidence: .4));
    detector.process(frame(4000));

    expect(detector.accumulatedValidDuration, const Duration(seconds: 1));
    expect(detector.process(frame(5000)), isNotNull);
  });

  test('missing landmarks freeze progress and cannot create a ghost hold', () {
    final detector = PlankDetector(
      requiredHoldDuration: const Duration(seconds: 2),
    );

    detector.process(frame(0));
    detector.process(frame(1000));
    detector.process(
      PoseFrame(
        timestamp: base.add(const Duration(milliseconds: 1500)),
        joints: const {},
      ),
    );
    expect(detector.process(frame(4000)), isNull);
    expect(detector.accumulatedValidDuration, const Duration(seconds: 1));
    expect(detector.process(frame(5000)), isNotNull);
  });

  test('one continuous hold emits no duplicate event after completion', () {
    final detector = PlankDetector(
      requiredHoldDuration: const Duration(seconds: 1),
    );

    detector.process(frame(0));
    final first = detector.process(frame(1000));
    final duplicate = detector.process(frame(2000));

    expect(first, isNotNull);
    expect(duplicate, isNull);
  });

  test('body-line break after completion allows a new future hold', () {
    final detector = PlankDetector(
      requiredHoldDuration: const Duration(seconds: 1),
    );

    detector.process(frame(0));
    expect(detector.process(frame(1000)), isNotNull);
    detector.process(frame(1100, bodyLineAngle: 120));
    expect(detector.completedCurrentHold, isFalse);
    detector.process(frame(2000));
    expect(detector.process(frame(3000)), isNotNull);
  });

  test('right-side landmarks can verify a hold', () {
    final detector = PlankDetector(
      requiredHoldDuration: const Duration(seconds: 1),
    );

    detector.process(frame(0, useRightSide: true));
    final result = detector.process(frame(1000, useRightSide: true));

    expect(result, isA<VerifiedRep>());
  });
}
