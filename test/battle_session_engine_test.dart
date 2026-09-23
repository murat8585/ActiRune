import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BattleSessionEngine', () {
    test('prepared movement accepts matching action and rejects mismatch', () {
      final engine = BattleSessionEngine()
        ..prepare(VerifiedMovementType.squat)
        ..startLiveBattle();

      expect(engine.acceptVerifiedMovement(VerifiedMovementType.squat), isTrue);
      expect(engine.snapshot.verifiedActionCount, 1);
      expect(engine.snapshot.lastVerifiedMovement, VerifiedMovementType.squat);

      expect(
        engine.acceptVerifiedMovement(VerifiedMovementType.plank),
        isFalse,
      );
      expect(engine.snapshot.verifiedActionCount, 1);
      expect(engine.snapshot.lastVerifiedMovement, VerifiedMovementType.squat);
    });

    test('unprepared live battle rejects verified movement fail closed', () {
      final engine = BattleSessionEngine()..startLiveBattle();

      expect(
        engine.acceptVerifiedMovement(VerifiedMovementType.squat),
        isFalse,
      );
      expect(engine.snapshot.verifiedActionCount, 0);
      expect(engine.snapshot.lastVerifiedMovement, isNull);
    });

    test('paused battle rejects movement and support actions', () {
      final engine = BattleSessionEngine()
        ..prepare(VerifiedMovementType.pushUp)
        ..startLiveBattle()
        ..pause();

      expect(engine.snapshot.isPaused, isTrue);
      expect(
        engine.acceptVerifiedMovement(VerifiedMovementType.pushUp),
        isFalse,
      );
      expect(
        engine.requestSupportAction(BattleSupportAction.runePower),
        isFalse,
      );
      expect(engine.snapshot.verifiedActionCount, 0);
      expect(engine.snapshot.supportActionRequestCount, 0);
    });

    test('Camera Prep can return to Battle Prep without losing movement', () {
      final engine = BattleSessionEngine();
      engine.prepare(VerifiedMovementType.lunge);
      engine.enterCameraPrep(syntheticMode: true);

      expect(engine.returnToBattlePrep(), isTrue);
      expect(engine.snapshot.phase, BattleSessionPhase.battlePrep);
      expect(engine.snapshot.preparedMovement, VerifiedMovementType.lunge);
      expect(engine.snapshot.syntheticMode, isTrue);
      expect(engine.snapshot.rewardedRetriesRemaining, 3);
      expect(engine.returnToBattlePrep(), isFalse);
    });

    test('Form Coach preserves the session and resumes live battle', () {
      final engine = BattleSessionEngine()
        ..prepare(VerifiedMovementType.lunge)
        ..startLiveBattle();
      expect(engine.acceptVerifiedMovement(VerifiedMovementType.lunge), isTrue);

      engine.openFormCoach();
      expect(engine.snapshot.phase, BattleSessionPhase.formCoach);
      expect(engine.snapshot.isPaused, isTrue);
      expect(engine.snapshot.verifiedActionCount, 1);

      engine.resumeLiveBattle();
      expect(engine.snapshot.phase, BattleSessionPhase.liveBattle);
      expect(engine.snapshot.isPaused, isFalse);
      expect(engine.snapshot.verifiedActionCount, 1);
    });

    test(
      'support artwork controls create typed requests without fake balance',
      () {
        final engine = BattleSessionEngine()
          ..prepare(VerifiedMovementType.squat)
          ..startLiveBattle();

        expect(
          engine.requestSupportAction(BattleSupportAction.runePower),
          isTrue,
        );
        expect(
          engine.snapshot.lastSupportAction,
          BattleSupportAction.runePower,
        );
        expect(engine.snapshot.supportActionRequestCount, 1);

        expect(
          engine.requestSupportAction(BattleSupportAction.protection),
          isTrue,
        );
        expect(
          engine.snapshot.lastSupportAction,
          BattleSupportAction.protection,
        );
        expect(engine.snapshot.supportActionRequestCount, 2);

        expect(
          engine.requestSupportAction(BattleSupportAction.powerPotion),
          isTrue,
        );
        expect(
          engine.snapshot.lastSupportAction,
          BattleSupportAction.powerPotion,
        );
        expect(engine.snapshot.supportActionRequestCount, 3);
      },
    );

    test('successful PvE rewarded retries consume exactly 3 then stop', () {
      final engine = BattleSessionEngine()..prepare(VerifiedMovementType.plank);

      for (var remaining = 3; remaining > 0; remaining--) {
        engine.markDefeat();
        expect(engine.snapshot.rewardedRetriesRemaining, remaining);
        expect(engine.restartAfterSuccessfulRewardedAd(), isTrue);
        expect(engine.snapshot.phase, BattleSessionPhase.cameraPrep);
        expect(engine.snapshot.rewardedRetriesRemaining, remaining - 1);
        expect(engine.snapshot.preparedMovement, VerifiedMovementType.plank);
      }

      engine.markDefeat();
      expect(engine.snapshot.rewardedRetriesRemaining, 0);
      expect(engine.restartAfterSuccessfulRewardedAd(), isFalse);
      expect(engine.snapshot.rewardedRetriesRemaining, 0);
    });
  });
}
