import '../pose/detector/movement_detector_factory.dart';
import '../pose/detector/pose_rep_detector.dart';
import 'battle_session_engine.dart';

/// Resolves the prepared battle movement to the matching camera-fed detector.
///
/// Plank remains fail-closed until the authoritative encounter/task owner
/// supplies its required hold duration. No default hold target is invented.
class BattlePoseDetectorFactory {
  const BattlePoseDetectorFactory({
    this.detectorFactory = const MovementDetectorFactory(),
  });

  final MovementDetectorFactory detectorFactory;

  PoseRepDetector? tryCreate({
    required VerifiedMovementType? preparedMovement,
    Duration? requiredPlankHoldDuration,
  }) {
    if (preparedMovement == null) return null;

    return switch (preparedMovement) {
      VerifiedMovementType.squat => detectorFactory.create(
        PoseExerciseType.squat,
      ),
      VerifiedMovementType.lunge => detectorFactory.create(
        PoseExerciseType.lunge,
      ),
      VerifiedMovementType.pushUp => detectorFactory.create(
        PoseExerciseType.pushUp,
      ),
      VerifiedMovementType.plank =>
        requiredPlankHoldDuration == null ||
                requiredPlankHoldDuration <= Duration.zero
            ? null
            : detectorFactory.create(
                PoseExerciseType.plank,
                requiredPlankHoldDuration: requiredPlankHoldDuration,
              ),
    };
  }
}
