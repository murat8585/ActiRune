import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:actirune/features/battle/combat/combat_engine.dart';
import 'package:actirune/features/battle/verified_movement_router.dart';
import 'package:actirune/features/pose/detector/verified_rep.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final at = DateTime.utc(2026);

  VerifiedRep rep(String exercise, {double formScore = 1}) {
    return VerifiedRep(exercise: exercise, at: at, formScore: formScore);
  }

  ({BattleSessionEngine session, CombatEngine combat, VerifiedMovementRouter router})
  liveRouter(VerifiedMovementType movement) {
    final session = BattleSessionEngine()
      ..prepare(movement)
      ..enterCameraPrep()
      ..startLiveBattle();
    final combat = CombatEngine(bossMaxHp: 1000, damagePerVerifiedRep: 100);
    return (
      session: session,
      combat: combat,
      router: VerifiedMovementRouter(session: session, combat: combat),
    );
  }

  test('maps all four locked movement identities', () {
    expect(
      VerifiedMovementRouter.movementTypeForExercise('squat'),
      VerifiedMovementType.squat,
    );
    expect(
      VerifiedMovementRouter.movementTypeForExercise('lunge'),
      VerifiedMovementType.lunge,
    );
    expect(
      VerifiedMovementRouter.movementTypeForExercise('push_up'),
      VerifiedMovementType.pushUp,
    );
    expect(
      VerifiedMovementRouter.movementTypeForExercise('plank'),
      VerifiedMovementType.plank,
    );
  });

  test('unknown exercise is rejected without changing battle owners', () {
    final state = liveRouter(VerifiedMovementType.squat);

    expect(state.router.accept(rep('unknown')), isFalse);
    expect(state.session.snapshot.verifiedActionCount, 0);
    expect(state.combat.snapshot.verifiedReps, 0);
    expect(state.combat.snapshot.bossHp, 1000);
  });

  test('one accepted verified rep creates exactly one session and combat action', () {
    final state = liveRouter(VerifiedMovementType.lunge);

    expect(state.router.accept(rep('lunge')), isTrue);
    expect(state.session.snapshot.verifiedActionCount, 1);
    expect(state.session.snapshot.lastVerifiedMovement, VerifiedMovementType.lunge);
    expect(state.combat.snapshot.verifiedReps, 1);
    expect(state.combat.snapshot.bossHp, 900);
  });

  test('form score is forwarded once to combat balance owner', () {
    final state = liveRouter(VerifiedMovementType.pushUp);

    expect(state.router.accept(rep('push_up', formScore: .8)), isTrue);
    expect(state.session.snapshot.verifiedActionCount, 1);
    expect(state.combat.snapshot.verifiedReps, 1);
    expect(state.combat.snapshot.bossHp, 920);
    expect(state.combat.snapshot.combo, 0);
  });

  test('prepared movement mismatch is rejected before either owner mutates', () {
    final state = liveRouter(VerifiedMovementType.plank);

    expect(state.router.accept(rep('squat')), isFalse);
    expect(state.session.snapshot.verifiedActionCount, 0);
    expect(state.combat.snapshot.verifiedReps, 0);
  });

  test('non-live battle rejects a verified event without combat damage', () {
    final session = BattleSessionEngine()..prepare(VerifiedMovementType.squat);
    final combat = CombatEngine(bossMaxHp: 1000, damagePerVerifiedRep: 100);
    final router = VerifiedMovementRouter(session: session, combat: combat);

    expect(router.accept(rep('squat')), isFalse);
    expect(session.snapshot.verifiedActionCount, 0);
    expect(combat.snapshot.verifiedReps, 0);
  });

  test('paused battle rejects a verified event without combat damage', () {
    final state = liveRouter(VerifiedMovementType.squat);
    state.session.pause();

    expect(state.router.accept(rep('squat')), isFalse);
    expect(state.session.snapshot.verifiedActionCount, 0);
    expect(state.combat.snapshot.verifiedReps, 0);
  });

  test('same verified event cannot be delivered twice', () {
    final state = liveRouter(VerifiedMovementType.plank);
    final event = rep('plank');

    expect(state.router.accept(event), isTrue);
    expect(state.session.snapshot.verifiedActionCount, 1);
    expect(state.combat.snapshot.verifiedReps, 1);

    expect(state.router.accept(event), isFalse);
    expect(state.session.snapshot.verifiedActionCount, 1);
    expect(state.combat.snapshot.verifiedReps, 1);
  });

  test('rejected event is not marked consumed and can be accepted later', () {
    final state = liveRouter(VerifiedMovementType.squat);
    final event = rep('squat');
    state.session.pause();

    expect(state.router.accept(event), isFalse);
    state.session.resumeLiveBattle();
    expect(state.router.accept(event), isTrue);
    expect(state.session.snapshot.verifiedActionCount, 1);
    expect(state.combat.snapshot.verifiedReps, 1);
  });
}
