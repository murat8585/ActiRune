import 'dart:math' as math;

import 'package:actirune/features/pose/detector/push_up_detector.dart';
import 'package:actirune/features/pose/detector/verified_rep.dart';
import 'package:actirune/features/pose/provider/pose_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final base = DateTime.utc(2026);

  PoseFrame frame(
    int milliseconds,
    double elbowAngle, {
    double bodyLineAngle = 175,
    double confidence = 1,
  }) {
    final elbowRadians = (180 - elbowAngle) * math.pi / 180;
    final bodyRadians = (180 - bodyLineAngle) * math.pi / 180;

    final shoulder = JointPoint(x: 0, y: 0, confidence: confidence);
    final elbow = JointPoint(x: 1, y: 0, confidence: confidence);
    final wrist = JointPoint(
      x: 1 + math.cos(elbowRadians),
      y: math.sin(elbowRadians),
      confidence: confidence,
    );
    final hip = JointPoint(x: 1, y: 0, confidence: confidence);
    final ankle = JointPoint(
      x: 1 + math.cos(bodyRadians),
      y: math.sin(bodyRadians),
      confidence: confidence,
    );

    return PoseFrame(
      timestamp: base.add(Duration(milliseconds: milliseconds)),
      joints: {
        Joint.leftShoulder: shoulder,
        Joint.leftElbow: elbow,
        Joint.leftWrist: wrist,
        Joint.leftHip: hip,
        Joint.leftAnkle: ankle,
      },
    );
  }

  VerifiedRep? cycle(PushUpDetector detector, int start) {
    detector.process(frame(start, 170));
    detector.process(frame(start + 100, 130));
    detector.process(frame(start + 200, 80));
    detector.process(frame(start + 500, 130));
    return detector.process(frame(start + 600, 170));
  }

  test('valid push-up emits exactly one verified rep', () {
    final detector = PushUpDetector();
    final rep = cycle(detector, 0);

    expect(rep, isNotNull);
    expect(rep!.exercise, 'push_up');
    expect(detector.process(frame(700, 170)), isNull);
  });

  test('shallow push-up never reaches the bottom state', () {
    final detector = PushUpDetector();
    detector.process(frame(0, 170));
    detector.process(frame(100, 130));
    detector.process(frame(300, 115));
    detector.process(frame(500, 130));

    expect(detector.process(frame(650, 170)), isNull);
  });

  test('body-line failure invalidates the current repetition', () {
    final detector = PushUpDetector();
    detector.process(frame(0, 170));
    detector.process(frame(100, 130));
    detector.process(frame(200, 80));
    detector.process(frame(300, 80, bodyLineAngle: 120));
    detector.process(frame(500, 130));

    expect(detector.process(frame(650, 170)), isNull);
  });

  test('low confidence landmarks freeze progression', () {
    final detector = PushUpDetector();
    detector.process(frame(0, 170));
    detector.process(frame(100, 130));
    detector.process(frame(200, 80, confidence: .4));
    detector.process(frame(500, 130));

    expect(detector.process(frame(650, 170)), isNull);
  });

  test('missing landmarks cannot create a ghost rep', () {
    final detector = PushUpDetector();
    detector.process(frame(0, 170));
    detector.process(frame(100, 130));
    detector.process(
      PoseFrame(
        timestamp: base.add(const Duration(milliseconds: 200)),
        joints: const {},
      ),
    );
    detector.process(frame(500, 130));

    expect(detector.process(frame(650, 170)), isNull);
  });

  test('return to top is required before a rep is emitted', () {
    final detector = PushUpDetector();
    detector.process(frame(0, 170));
    detector.process(frame(100, 130));
    detector.process(frame(200, 80));
    detector.process(frame(500, 130));

    expect(detector.process(frame(650, 130)), isNull);
  });

  test('cooldown suppresses a rapid second push-up', () {
    final detector = PushUpDetector();
    expect(cycle(detector, 0), isNotNull);
    expect(cycle(detector, 640), isNull);
  });

  test('detector requires a valid top position before descending', () {
    final detector = PushUpDetector();
    detector.process(frame(0, 80));
    detector.process(frame(300, 130));

    expect(detector.process(frame(600, 170)), isNull);
  });
}
