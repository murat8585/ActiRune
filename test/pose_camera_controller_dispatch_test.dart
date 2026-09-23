import 'package:actirune/features/pose/detector/lunge_detector.dart';
import 'package:actirune/features/pose/detector/movement_detector_factory.dart';
import 'package:actirune/features/pose/detector/plank_detector.dart';
import 'package:actirune/features/pose/detector/pose_rep_detector.dart';
import 'package:actirune/features/pose/detector/push_up_detector.dart';
import 'package:actirune/features/pose/detector/squat_detector.dart';
import 'package:actirune/features/pose/provider/pose_camera_controller.dart';
import 'package:actirune/features/pose/provider/pose_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MovementDetectorFactory', () {
    const factory = MovementDetectorFactory();

    test('creates the correct detector for the three repetition movements', () {
      expect(factory.create(PoseExerciseType.squat), isA<SquatDetector>());
      expect(factory.create(PoseExerciseType.lunge), isA<LungeDetector>());
      expect(factory.create(PoseExerciseType.pushUp), isA<PushUpDetector>());
    });

    test('plank fails closed without authoritative hold duration', () {
      expect(
        () => factory.create(PoseExerciseType.plank),
        throwsArgumentError,
      );
      expect(
        () => factory.create(
          PoseExerciseType.plank,
          requiredPlankHoldDuration: Duration.zero,
        ),
        throwsArgumentError,
      );
    });

    test('plank uses the caller-owned hold duration', () {
      final detector = factory.create(
        PoseExerciseType.plank,
        requiredPlankHoldDuration: const Duration(seconds: 12),
      );

      expect(detector, isA<PlankDetector>());
      expect(
        (detector as PlankDetector).requiredHoldDuration,
        const Duration(seconds: 12),
      );
    });
  });

  group('PoseRepDispatcher', () {
    test('forwards only detector-produced verified reps', () {
      final received = <VerifiedRep>[];
      final detector = _FakeDetector();
      final dispatcher = PoseRepDispatcher(
        detector: detector,
        onVerifiedRep: received.add,
      );
      final first = PoseFrame(
        timestamp: DateTime.utc(2026, 9, 23, 12),
        joints: const {},
      );
      final second = PoseFrame(
        timestamp: DateTime.utc(2026, 9, 23, 12, 0, 1),
        joints: const {},
      );

      dispatcher.accept(first);
      expect(received, isEmpty);

      detector.next = VerifiedRep(
        exercise: 'lunge',
        at: second.timestamp,
        formScore: .9,
      );
      dispatcher.accept(second);

      expect(detector.frames, [first, second]);
      expect(received, hasLength(1));
      expect(received.single.exercise, 'lunge');
      expect(received.single.formScore, .9);
    });
  });
}

class _FakeDetector implements PoseRepDetector {
  final frames = <PoseFrame>[];
  VerifiedRep? next;

  @override
  VerifiedRep? process(PoseFrame frame) {
    frames.add(frame);
    final result = next;
    next = null;
    return result;
  }
}
