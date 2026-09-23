import 'package:actirune/features/battle/battle_pose_detector_factory.dart';
import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:actirune/features/pose/detector/lunge_detector.dart';
import 'package:actirune/features/pose/detector/plank_detector.dart';
import 'package:actirune/features/pose/detector/push_up_detector.dart';
import 'package:actirune/features/pose/detector/squat_detector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const factory = BattlePoseDetectorFactory();

  test('battle movement resolves to its matching camera detector', () {
    expect(
      factory.tryCreate(preparedMovement: VerifiedMovementType.squat),
      isA<SquatDetector>(),
    );
    expect(
      factory.tryCreate(preparedMovement: VerifiedMovementType.lunge),
      isA<LungeDetector>(),
    );
    expect(
      factory.tryCreate(preparedMovement: VerifiedMovementType.pushUp),
      isA<PushUpDetector>(),
    );
  });

  test('missing prepared movement remains fail closed', () {
    expect(factory.tryCreate(preparedMovement: null), isNull);
  });

  test('plank remains fail closed without authoritative hold duration', () {
    expect(
      factory.tryCreate(preparedMovement: VerifiedMovementType.plank),
      isNull,
    );
    expect(
      factory.tryCreate(
        preparedMovement: VerifiedMovementType.plank,
        requiredPlankHoldDuration: Duration.zero,
      ),
      isNull,
    );
  });

  test('plank detector is created only with authoritative hold duration', () {
    final detector = factory.tryCreate(
      preparedMovement: VerifiedMovementType.plank,
      requiredPlankHoldDuration: const Duration(seconds: 20),
    );

    expect(detector, isA<PlankDetector>());
    expect(
      (detector! as PlankDetector).requiredHoldDuration,
      const Duration(seconds: 20),
    );
  });
}
