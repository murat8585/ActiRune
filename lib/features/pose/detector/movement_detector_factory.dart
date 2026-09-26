import 'lunge_detector.dart';
import 'reverse_lunge_detector.dart';
import 'high_knee_detector.dart';
import 'cross_body_knee_raise_detector.dart';
import 'plank_detector.dart';
import 'pose_rep_detector.dart';
import 'push_up_detector.dart';
import 'squat_detector.dart';

enum PoseExerciseType {
  squat,
  lunge,
  pushUp,
  plank,
  reverseLunge,
  highKnee,
  crossBodyKneeRaise,
}

/// Creates the correct deterministic detector for the prepared movement.
///
/// Plank is deliberately fail-closed unless the authoritative encounter/task
/// owner supplies the required hold duration. The camera layer must never make
/// up a hold target merely to get the screen moving.
class MovementDetectorFactory {
  const MovementDetectorFactory();

  PoseRepDetector create(
    PoseExerciseType movement, {
    Duration? requiredPlankHoldDuration,
  }) {
    return switch (movement) {
      PoseExerciseType.squat => SquatDetector(),
      PoseExerciseType.lunge => LungeDetector(),
      PoseExerciseType.reverseLunge => ReverseLungeDetector(),
      PoseExerciseType.highKnee => HighKneeDetector(),
      PoseExerciseType.crossBodyKneeRaise => CrossBodyKneeRaiseDetector(),
      PoseExerciseType.pushUp => PushUpDetector(),
      PoseExerciseType.plank => PlankDetector(
        requiredHoldDuration: _requirePlankDuration(requiredPlankHoldDuration),
      ),
    };
  }

  Duration _requirePlankDuration(Duration? duration) {
    if (duration == null || duration <= Duration.zero) {
      throw ArgumentError.value(
        duration,
        'requiredPlankHoldDuration',
        'must be supplied by the authoritative encounter/task owner for plank',
      );
    }
    return duration;
  }
}
