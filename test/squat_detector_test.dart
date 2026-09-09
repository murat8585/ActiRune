import 'dart:math' as math;

import 'package:actirune/features/pose/detector/squat_detector.dart';
import 'package:actirune/features/pose/provider/pose_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final base = DateTime.utc(2026);

  PoseFrame frame(int milliseconds, double kneeAngle, {double confidence = 1}) {
    const knee = JointPoint(x: 0, y: 0, confidence: 1);
    const ankle = JointPoint(x: 1, y: 0, confidence: 1);
    final radians = kneeAngle * 3.141592653589793 / 180;
    final hip = JointPoint(
      x: math.cos(radians),
      y: math.sin(radians),
      confidence: confidence,
    );
    return PoseFrame(
      timestamp: base.add(Duration(milliseconds: milliseconds)),
      joints: {
        Joint.leftHip: hip,
        Joint.leftKnee: JointPoint(
          x: knee.x,
          y: knee.y,
          confidence: confidence,
        ),
        Joint.leftAnkle: JointPoint(
          x: ankle.x,
          y: ankle.y,
          confidence: confidence,
        ),
      },
    );
  }

  VerifiedRep? cycle(SquatDetector detector, int start) {
    detector.process(frame(start, 170));
    detector.process(frame(start + 100, 135));
    detector.process(frame(start + 200, 90));
    detector.process(frame(start + 500, 130));
    return detector.process(frame(start + 600, 170));
  }

  test('valid squat emits exactly one verified rep', () {
    final detector = SquatDetector();
    expect(cycle(detector, 0), isNotNull);
    expect(detector.process(frame(700, 170)), isNull);
  });

  test('shallow squat below bottom threshold is not a rep', () {
    final detector = SquatDetector();
    detector.process(frame(0, 170));
    detector.process(frame(100, 130));
    detector.process(frame(400, 120));
    expect(detector.process(frame(600, 170)), isNull);
  });

  test('low confidence frames cannot advance the state machine', () {
    final detector = SquatDetector();
    detector.process(frame(0, 170));
    detector.process(frame(100, 90, confidence: .4));
    detector.process(frame(500, 130));
    expect(detector.process(frame(600, 170)), isNull);
  });

  test('cooldown suppresses a rapid second cycle', () {
    final detector = SquatDetector();
    expect(cycle(detector, 0), isNotNull);
    expect(cycle(detector, 640), isNull);
  });

  test('return to standing is required before a rep is emitted', () {
    final detector = SquatDetector();
    detector.process(frame(0, 170));
    detector.process(frame(100, 90));
    detector.process(frame(500, 130));
    expect(detector.process(frame(600, 130)), isNull);
  });

  test('missing joints are ignored without ghost reps', () {
    final detector = SquatDetector();
    detector.process(frame(0, 170));
    detector.process(PoseFrame(timestamp: base, joints: const {}));
    expect(detector.process(frame(700, 170)), isNull);
  });
}
