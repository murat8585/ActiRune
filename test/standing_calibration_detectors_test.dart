import 'package:actirune/features/pose/detector/cross_body_knee_raise_detector.dart';
import 'package:actirune/features/pose/detector/high_knee_detector.dart';
import 'package:actirune/features/pose/detector/reverse_lunge_detector.dart';
import 'package:actirune/features/pose/detector/verified_rep.dart';
import 'package:actirune/features/pose/provider/pose_models.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_support/standing_calibration_frames.dart';

void main() {
  VerifiedRep? reverseCycle(
    ReverseLungeDetector detector,
    int start, {
    bool rearLeft = true,
    double scale = 1,
  }) {
    detector.process(standingFrame(start, scale: scale));
    detector.process(
      reverseStep(start + 100, rearLeft: rearLeft, scale: scale),
    );
    detector.process(
      reverseBottom(start + 200, rearLeft: rearLeft, scale: scale),
    );
    detector.process(
      reverseBottom(start + 350, rearLeft: rearLeft, scale: scale),
    );
    detector.process(
      reverseReturning(start + 500, rearLeft: rearLeft, scale: scale),
    );
    return detector.process(standingFrame(start + 600, scale: scale));
  }

  VerifiedRep? highCycle(
    HighKneeDetector detector,
    int start, {
    bool left = true,
    double scale = 1,
  }) {
    detector.process(standingFrame(start, scale: scale));
    detector.process(highKneeFrame(start + 100, left: left, scale: scale));
    detector.process(highKneeFrame(start + 300, left: left, scale: scale));
    return detector.process(standingFrame(start + 600, scale: scale));
  }

  VerifiedRep? crossCycle(
    CrossBodyKneeRaiseDetector detector,
    int start, {
    bool leftKnee = true,
    double scale = 1,
  }) {
    detector.process(standingFrame(start, scale: scale));
    detector.process(
      crossBodyFrame(start + 100, leftKnee: leftKnee, scale: scale),
    );
    detector.process(
      crossBodyFrame(start + 300, leftKnee: leftKnee, scale: scale),
    );
    return detector.process(standingFrame(start + 600, scale: scale));
  }

  group('ReverseLungeDetector', () {
    test('left and right projected reverse-lunge cycles verify', () {
      expect(
        reverseCycle(ReverseLungeDetector(), 0)?.exercise,
        'reverse_lunge',
      );
      expect(
        reverseCycle(ReverseLungeDetector(), 0, rearLeft: false)?.exercise,
        'reverse_lunge',
      );
    });

    test('squat and knee raise do not verify reverse lunge', () {
      final detector = ReverseLungeDetector();
      detector.process(standingFrame(0));
      detector.process(squatFrame(100, bottom: false));
      detector.process(squatFrame(200));
      detector.process(squatFrame(400, bottom: false));
      expect(detector.process(standingFrame(600)), isNull);
      detector.process(highKneeFrame(800));
      expect(detector.process(standingFrame(1100)), isNull);
    });

    test('lateral step without depth and forward depth cannot verify', () {
      for (final depth in [0.0, -80.0]) {
        final detector = ReverseLungeDetector();
        detector.process(standingFrame(0));
        detector.process(reverseStep(100, depth: depth));
        detector.process(reverseBottom(200, depth: depth));
        detector.process(reverseBottom(350, depth: depth));
        detector.process(reverseReturning(500, depth: depth));
        expect(detector.process(standingFrame(600)), isNull);
      }
    });

    test('one-frame bottom after a step is insufficient', () {
      final detector = ReverseLungeDetector();
      detector.process(standingFrame(0));
      detector.process(reverseStep(100));
      detector.process(reverseBottom(200));
      detector.process(reverseReturning(500));
      expect(detector.process(standingFrame(600)), isNull);
    });

    test('missing experimental depth fails closed', () {
      final detector = ReverseLungeDetector();
      PoseFrame noDepth(PoseFrame source) => PoseFrame(
        timestamp: source.timestamp,
        joints: {
          for (final entry in source.joints.entries)
            entry.key: JointPoint(
              x: entry.value.x,
              y: entry.value.y,
              confidence: entry.value.confidence,
            ),
        },
      );
      for (final frame in [
        standingFrame(0),
        reverseStep(100),
        reverseBottom(200),
        reverseBottom(350),
        reverseReturning(500),
        standingFrame(600),
      ]) {
        expect(detector.process(noDepth(frame)), isNull);
      }
    });

    test('one frame bend, missing return, and partial pose fail closed', () {
      final detector = ReverseLungeDetector();
      detector.process(standingFrame(0));
      detector.process(reverseBottom(100));
      expect(detector.process(standingFrame(600)), isNull);
      detector.process(reverseStep(700));
      detector.process(reverseBottom(800));
      expect(detector.process(reverseReturning(1100)), isNull);
      detector.process(
        calibrationFrame(1200, lowConfidence: Joint.leftAnkle, omitJoint: true),
      );
      expect(detector.process(standingFrame(1300)), isNull);
    });

    test('low confidence bottom and no observed return cannot verify', () {
      final detector = ReverseLungeDetector();
      detector.process(standingFrame(0));
      detector.process(reverseStep(100));
      detector.process(reverseBottom(200, lowConfidence: Joint.rightKnee));
      detector.process(reverseReturning(500));
      expect(detector.process(standingFrame(600)), isNull);
      detector.process(reverseStep(800));
      detector.process(reverseBottom(900));
      expect(detector.process(reverseBottom(1300)), isNull);
    });

    test('cooldown blocks a rapid duplicate cycle', () {
      final detector = ReverseLungeDetector();
      expect(reverseCycle(detector, 0), isNotNull);
      expect(reverseCycle(detector, 640, rearLeft: false), isNull);
    });
  });

  group('HighKneeDetector', () {
    test('controlled left and right cycles verify', () {
      expect(highCycle(HighKneeDetector(), 0)?.exercise, 'high_knee');
      expect(
        highCycle(HighKneeDetector(), 0, left: false)?.exercise,
        'high_knee',
      );
    });

    test('near and far body scales classify identically', () {
      expect(highCycle(HighKneeDetector(), 0, scale: 1), isNotNull);
      expect(highCycle(HighKneeDetector(), 0, scale: .4), isNotNull);
    });

    test('jitter, small step, squat and reverse lunge do not verify', () {
      final detector = HighKneeDetector();
      detector.process(standingFrame(0));
      detector.process(
        calibrationFrame(100, overrides: {Joint.leftKnee: (-15, 190)}),
      );
      detector.process(reverseStep(200));
      detector.process(squatFrame(300));
      detector.process(reverseBottom(400));
      expect(detector.process(standingFrame(600)), isNull);
    });

    test('opposite elbow convergence is reserved for cross-body movement', () {
      final detector = HighKneeDetector();
      detector.process(standingFrame(0));
      detector.process(crossBodyFrame(100));
      detector.process(crossBodyFrame(300));
      expect(detector.process(standingFrame(600)), isNull);
    });

    test('low-confidence knee and duplicate without return fail', () {
      final detector = HighKneeDetector();
      detector.process(standingFrame(0));
      detector.process(highKneeFrame(100, lowConfidence: Joint.leftKnee));
      detector.process(highKneeFrame(300));
      expect(detector.process(standingFrame(600)), isNull);
      detector.process(highKneeFrame(800));
      detector.process(highKneeFrame(1000));
      expect(detector.process(highKneeFrame(1200)), isNull);
    });
  });

  group('CrossBodyKneeRaiseDetector', () {
    test('both opposite elbow/knee pairings verify', () {
      expect(
        crossCycle(CrossBodyKneeRaiseDetector(), 0)?.exercise,
        'cross_body_knee_raise',
      );
      expect(
        crossCycle(CrossBodyKneeRaiseDetector(), 0, leftKnee: false)?.exercise,
        'cross_body_knee_raise',
      );
    });

    test('near and far body scales classify identically', () {
      expect(crossCycle(CrossBodyKneeRaiseDetector(), 0, scale: 1), isNotNull);
      expect(crossCycle(CrossBodyKneeRaiseDetector(), 0, scale: .4), isNotNull);
    });

    test('same side, high knee only and arm only cannot verify', () {
      final detector = CrossBodyKneeRaiseDetector();
      detector.process(standingFrame(0));
      detector.process(crossBodyFrame(100, sameSideOnly: true));
      detector.process(crossBodyFrame(300, sameSideOnly: true));
      expect(detector.process(standingFrame(600)), isNull);
      detector.process(highKneeFrame(800));
      detector.process(highKneeFrame(1000));
      expect(detector.process(standingFrame(1200)), isNull);
      detector.process(
        calibrationFrame(1300, overrides: {Joint.rightElbow: (-25, 60)}),
      );
      expect(detector.process(standingFrame(1600)), isNull);
    });

    test('standing, low confidence and missing reset cannot verify', () {
      final detector = CrossBodyKneeRaiseDetector();
      expect(detector.process(standingFrame(0)), isNull);
      detector.process(crossBodyFrame(100, lowConfidence: Joint.rightElbow));
      detector.process(crossBodyFrame(300));
      expect(detector.process(standingFrame(600)), isNull);
      detector.process(crossBodyFrame(800));
      detector.process(crossBodyFrame(1000));
      expect(detector.process(crossBodyFrame(1200)), isNull);
    });
  });
}
