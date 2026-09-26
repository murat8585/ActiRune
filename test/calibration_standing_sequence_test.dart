import 'package:actirune/features/onboarding/calibration_movement_sequence.dart';
import 'package:actirune/features/onboarding/first_calibration_engine.dart';
import 'package:actirune/features/pose/detector/verified_rep.dart';
import 'package:actirune/features/pose/provider/pose_models.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_support/standing_calibration_frames.dart';

void main() {
  CalibrationMovementSequence sequence() => CalibrationMovementSequence(
    preferences: {
      for (final movement in CalibrationMovement.values)
        movement: CalibrationMovementPreference(
          movement: movement,
          suitability: CalibrationMovementSuitability.standard,
        ),
    },
  )..enableCapture();

  VerifiedRep? feed(
    CalibrationMovementSequence sequence,
    Iterable<PoseFrame> frames,
  ) {
    VerifiedRep? result;
    for (final frame in frames) {
      result = sequence.process(frame) ?? result;
    }
    return result;
  }

  Iterable<PoseFrame> squat(int t) => [
    standingFrame(t),
    squatFrame(t + 100, bottom: false),
    squatFrame(t + 200),
    squatFrame(t + 500, bottom: false),
    standingFrame(t + 600),
  ];
  Iterable<PoseFrame> reverse(int t) => [
    standingFrame(t),
    reverseStep(t + 100),
    reverseBottom(t + 200),
    reverseBottom(t + 350),
    reverseReturning(t + 500),
    standingFrame(t + 600),
  ];
  Iterable<PoseFrame> high(int t) => [
    standingFrame(t),
    highKneeFrame(t + 100),
    highKneeFrame(t + 300),
    standingFrame(t + 600),
  ];
  Iterable<PoseFrame> cross(int t) => [
    standingFrame(t),
    crossBodyFrame(t + 100),
    crossBodyFrame(t + 300),
    standingFrame(t + 600),
  ];

  test('exact four standing movements advance only on matching real reps', () {
    final chain = sequence();
    expect(CalibrationMovement.values, [
      CalibrationMovement.squat,
      CalibrationMovement.reverseLunge,
      CalibrationMovement.highKnee,
      CalibrationMovement.crossBodyKneeRaise,
    ]);
    expect(chain.currentMovement, CalibrationMovement.squat);
    expect(feed(chain, high(0)), isNull);
    expect(chain.currentMovement, CalibrationMovement.squat);
    expect(feed(chain, squat(1000))?.exercise, 'squat');
    expect(chain.currentMovement, CalibrationMovement.reverseLunge);

    expect(feed(chain, high(1700)), isNull);
    expect(chain.currentMovement, CalibrationMovement.reverseLunge);
    expect(feed(chain, reverse(2400))?.exercise, 'reverse_lunge');
    expect(chain.currentMovement, CalibrationMovement.highKnee);

    expect(feed(chain, cross(3100)), isNull);
    expect(chain.currentMovement, CalibrationMovement.highKnee);
    expect(feed(chain, high(3800))?.exercise, 'high_knee');
    expect(chain.currentMovement, CalibrationMovement.crossBodyKneeRaise);
    expect(chain.isComplete, isFalse);
    expect(chain.evidence.length, 3);

    expect(feed(chain, high(4500)), isNull);
    expect(chain.currentMovement, CalibrationMovement.crossBodyKneeRaise);
    expect(feed(chain, cross(5200))?.exercise, 'cross_body_knee_raise');
    expect(chain.isComplete, isTrue);
    expect(chain.evidence.keys.toList(), CalibrationMovement.values);
    expect(feed(chain, cross(5900)), isNull);
    expect(chain.evidence.length, 4);
  });

  test('pose loss resets a partial movement without creating evidence', () {
    final chain = sequence();
    chain.process(standingFrame(0));
    chain.process(squatFrame(100, bottom: false));
    chain.process(squatFrame(200));
    chain.process(
      PoseFrame(
        timestamp: calibrationBaseTime.add(const Duration(milliseconds: 300)),
        joints: const {},
      ),
    );
    chain.process(squatFrame(500, bottom: false));
    expect(chain.process(standingFrame(600)), isNull);
    expect(chain.evidence, isEmpty);
  });
}
