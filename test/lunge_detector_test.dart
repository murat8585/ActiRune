import 'dart:math' as math;

import 'package:actirune/features/pose/detector/lunge_detector.dart';
import 'package:actirune/features/pose/detector/verified_rep.dart';
import 'package:actirune/features/pose/provider/pose_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final base = DateTime.utc(2026);

  ({JointPoint hip, JointPoint knee, JointPoint ankle}) leg(
    double kneeAngle, {
    required double xOffset,
    double confidence = 1,
  }) {
    final radians = kneeAngle * math.pi / 180;
    final knee = JointPoint(x: xOffset, y: 0, confidence: confidence);
    final ankle = JointPoint(x: xOffset + 1, y: 0, confidence: confidence);
    final hip = JointPoint(
      x: xOffset + math.cos(radians),
      y: math.sin(radians),
      confidence: confidence,
    );
    return (hip: hip, knee: knee, ankle: ankle);
  }

  PoseFrame frame(
    int milliseconds,
    double leftKneeAngle,
    double rightKneeAngle, {
    double confidence = 1,
  }) {
    final left = leg(leftKneeAngle, xOffset: -2, confidence: confidence);
    final right = leg(rightKneeAngle, xOffset: 2, confidence: confidence);
    return PoseFrame(
      timestamp: base.add(Duration(milliseconds: milliseconds)),
      joints: {
        Joint.leftHip: left.hip,
        Joint.leftKnee: left.knee,
        Joint.leftAnkle: left.ankle,
        Joint.rightHip: right.hip,
        Joint.rightKnee: right.knee,
        Joint.rightAnkle: right.ankle,
      },
    );
  }

  VerifiedRep? leftCycle(LungeDetector detector, int start) {
    detector.process(frame(start, 170, 170));
    detector.process(frame(start + 100, 135, 168));
    detector.process(frame(start + 200, 90, 165));
    detector.process(frame(start + 500, 130, 166));
    return detector.process(frame(start + 600, 170, 170));
  }

  VerifiedRep? rightCycle(LungeDetector detector, int start) {
    detector.process(frame(start, 170, 170));
    detector.process(frame(start + 100, 168, 135));
    detector.process(frame(start + 200, 165, 90));
    detector.process(frame(start + 500, 166, 130));
    return detector.process(frame(start + 600, 170, 170));
  }

  test('valid left lunge emits exactly one verified rep', () {
    final detector = LungeDetector();
    final rep = leftCycle(detector, 0);

    expect(rep, isNotNull);
    expect(rep!.exercise, 'lunge');
    expect(detector.process(frame(700, 170, 170)), isNull);
  });

  test('valid right lunge emits exactly one verified rep', () {
    final detector = LungeDetector();
    final rep = rightCycle(detector, 0);

    expect(rep, isNotNull);
    expect(rep!.exercise, 'lunge');
  });

  test('shallow lunge never reaches the bottom state', () {
    final detector = LungeDetector();
    detector.process(frame(0, 170, 170));
    detector.process(frame(100, 135, 168));
    detector.process(frame(300, 120, 166));
    detector.process(frame(500, 135, 168));

    expect(detector.process(frame(650, 170, 170)), isNull);
  });

  test('low confidence frames freeze progression', () {
    final detector = LungeDetector();
    detector.process(frame(0, 170, 170));
    detector.process(frame(100, 135, 168));
    detector.process(frame(200, 90, 165, confidence: .4));
    detector.process(frame(500, 130, 166));

    expect(detector.process(frame(650, 170, 170)), isNull);
  });

  test('return to standing is required before a rep is emitted', () {
    final detector = LungeDetector();
    detector.process(frame(0, 170, 170));
    detector.process(frame(100, 135, 168));
    detector.process(frame(200, 90, 165));
    detector.process(frame(500, 130, 166));

    expect(detector.process(frame(650, 145, 168)), isNull);
  });

  test('missing landmarks cannot create a ghost rep', () {
    final detector = LungeDetector();
    detector.process(frame(0, 170, 170));
    detector.process(frame(100, 135, 168));
    detector.process(
      PoseFrame(
        timestamp: base.add(const Duration(milliseconds: 200)),
        joints: const {},
      ),
    );
    detector.process(frame(500, 130, 166));

    expect(detector.process(frame(650, 170, 170)), isNull);
  });

  test('cooldown suppresses a rapid second lunge', () {
    final detector = LungeDetector();
    expect(leftCycle(detector, 0), isNotNull);
    expect(rightCycle(detector, 640), isNull);
  });

  test('lead side remains locked through one repetition', () {
    final detector = LungeDetector();
    detector.process(frame(0, 170, 170));
    detector.process(frame(100, 135, 168));
    detector.process(frame(200, 90, 165));

    expect(detector.leadSide, LungeSide.left);

    detector.process(frame(350, 170, 90));
    expect(detector.leadSide, LungeSide.left);
    expect(detector.process(frame(700, 170, 170)), isNotNull);
  });
}
