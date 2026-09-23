import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:actirune/features/battle/combat/combat_engine.dart';
import 'package:actirune/features/battle/verified_movement_router.dart';
import 'package:actirune/features/pose/detector/verified_rep.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final base = DateTime.utc(2026);

  VerifiedRep rep(String exercise, int milliseconds, {double formScore = 1}) {
    return VerifiedRep(
      exercise: exercise,
      at: base.add(Duration(milliseconds: milliseconds)),
      formScore: formScore,
    );
  }

  BattleSessionEngine liveSession(VerifiedMovementType movement) {
    return BattleSessionEngine()
      ..prepare(movement)
      ..startLiveBattle();
  }

  test(
    'all four supported detector identities route in matching encounters',
    () {
      const cases = <(String, VerifiedMovementType)>[
        ('squat', VerifiedMovementType.squat),
        ('lunge', VerifiedMovementType.lunge),
        ('push_up', VerifiedMovementType.pushUp),
        ('plank', VerifiedMovementType.plank),
      ];

      for (var i = 0; i < cases.length; i++) {
        final current = cases[i];
        final session = liveSession(current.$2);
        final combat = CombatEngine(bossMaxHp: 1000, damagePerVerifiedRep: 100);
        final router = VerifiedMovementRouter(session: session, combat: combat);

        expect(router.route(rep(current.$1, 100 + i)), isTrue);
        expect(session.snapshot.lastVerifiedMovement, current.$2);
        expect(session.snapshot.verifiedActionCount, 1);
        expect(combat.snapshot.verifiedReps, 1);
        expect(combat.snapshot.bossHp, 900);
      }
    },
  );

  test('mismatched detector identity is rejected without combat mutation', () {
    final session = liveSession(VerifiedMovementType.lunge);
    final combat = CombatEngine();
    final router = VerifiedMovementRouter(session: session, combat: combat);

    expect(router.route(rep('squat', 100)), isFalse);
    expect(session.snapshot.verifiedActionCount, 0);
    expect(session.snapshot.lastVerifiedMovement, isNull);
    expect(combat.snapshot.verifiedReps, 0);
  });

  test('unknown exercise is rejected without battle or combat mutation', () {
    final session = liveSession(VerifiedMovementType.squat);
    final combat = CombatEngine();
    final router = VerifiedMovementRouter(session: session, combat: combat);

    expect(router.route(rep('burpee', 100)), isFalse);
    expect(session.snapshot.verifiedActionCount, 0);
    expect(session.snapshot.lastVerifiedMovement, isNull);
    expect(combat.snapshot.verifiedReps, 0);
    expect(combat.snapshot.bossHp, combat.snapshot.bossMaxHp);
  });

  test('non-live battle rejection cannot mutate combat', () {
    final session = BattleSessionEngine()..prepare(VerifiedMovementType.squat);
    final combat = CombatEngine();
    final router = VerifiedMovementRouter(session: session, combat: combat);

    expect(router.route(rep('squat', 100)), isFalse);
    expect(session.snapshot.verifiedActionCount, 0);
    expect(combat.snapshot.verifiedReps, 0);
  });

  test('paused battle rejection cannot mutate combat', () {
    final session = liveSession(VerifiedMovementType.lunge)..pause();
    final combat = CombatEngine();
    final router = VerifiedMovementRouter(session: session, combat: combat);

    expect(router.route(rep('lunge', 100)), isFalse);
    expect(session.snapshot.verifiedActionCount, 0);
    expect(combat.snapshot.verifiedReps, 0);
  });

  test('same verified event cannot be replayed after phase recovery', () {
    final session = BattleSessionEngine()..prepare(VerifiedMovementType.pushUp);
    final combat = CombatEngine();
    final router = VerifiedMovementRouter(session: session, combat: combat);
    final event = rep('push_up', 100);

    expect(router.route(event), isFalse);
    session.startLiveBattle();
    expect(router.route(event), isFalse);

    expect(session.snapshot.verifiedActionCount, 0);
    expect(combat.snapshot.verifiedReps, 0);
  });

  test('duplicate accepted event cannot double-count', () {
    final session = liveSession(VerifiedMovementType.plank);
    final combat = CombatEngine();
    final router = VerifiedMovementRouter(session: session, combat: combat);
    final event = rep('plank', 100);

    expect(router.route(event), isTrue);
    expect(router.route(event), isFalse);

    expect(session.snapshot.verifiedActionCount, 1);
    expect(combat.snapshot.verifiedReps, 1);
  });

  test('same movement at a new timestamp remains a new verified event', () {
    final session = liveSession(VerifiedMovementType.squat);
    final combat = CombatEngine();
    final router = VerifiedMovementRouter(session: session, combat: combat);

    expect(router.route(rep('squat', 100)), isTrue);
    expect(router.route(rep('squat', 200)), isTrue);

    expect(session.snapshot.verifiedActionCount, 2);
    expect(combat.snapshot.verifiedReps, 2);
  });

  test('router passes form score to existing CombatEngine semantics', () {
    final session = liveSession(VerifiedMovementType.lunge);
    final combat = CombatEngine(bossMaxHp: 1000, damagePerVerifiedRep: 100);
    final router = VerifiedMovementRouter(session: session, combat: combat);

    expect(router.route(rep('lunge', 100, formScore: .1)), isTrue);

    expect(session.snapshot.verifiedActionCount, 1);
    expect(combat.snapshot.verifiedReps, 1);
    expect(combat.snapshot.bossHp, 930);
    expect(combat.snapshot.combo, 0);
  });
}
