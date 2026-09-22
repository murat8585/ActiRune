import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BattleSessionEngine', () {
    test('one verified movement produces exactly one combat action', () {
      final engine = BattleSessionEngine();
      engine.startLiveBattle();

      expect(engine.acceptVerifiedMovement(VerifiedMovementType.squat), isTrue);
      expect(engine.snapshot.verifiedActionCount, 1);
      expect(engine.snapshot.lastVerifiedMovement, VerifiedMovementType.squat);

      expect(engine.acceptVerifiedMovement(VerifiedMovementType.plank), isTrue);
      expect(engine.snapshot.verifiedActionCount, 2);
      expect(engine.snapshot.lastVerifiedMovement, VerifiedMovementType.plank);
    });

    test('paused battle rejects movement and support actions', () {
      final engine = BattleSessionEngine();
      engine.startLiveBattle();
      engine.pause();

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

    test('Form Coach preserves the session and resumes live battle', () {
      final engine = BattleSessionEngine();
      engine.startLiveBattle();
      engine.acceptVerifiedMovement(VerifiedMovementType.lunge);

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
        final engine = BattleSessionEngine();
        engine.startLiveBattle();

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
      final engine = BattleSessionEngine();

      for (var remaining = 3; remaining > 0; remaining--) {
        engine.markDefeat();
        expect(engine.snapshot.rewardedRetriesRemaining, remaining);
        expect(engine.restartAfterSuccessfulRewardedAd(), isTrue);
        expect(engine.snapshot.phase, BattleSessionPhase.cameraPrep);
        expect(engine.snapshot.rewardedRetriesRemaining, remaining - 1);
      }

      engine.markDefeat();
      expect(engine.snapshot.rewardedRetriesRemaining, 0);
      expect(engine.restartAfterSuccessfulRewardedAd(), isFalse);
      expect(engine.snapshot.rewardedRetriesRemaining, 0);
    });
  });
}
