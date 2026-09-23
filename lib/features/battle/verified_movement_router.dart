import '../pose/detector/verified_rep.dart';
import 'battle_session_engine.dart';
import 'combat/combat_engine.dart';

/// Narrow authority boundary between already-verified pose events and battle.
///
/// Detectors own movement verification. BattleSession owns whether the current
/// battle may accept an action. CombatEngine owns numeric damage/combo balance.
/// This router only maps the four locked movement identities and forwards one
/// accepted event exactly once to each battle owner.
class VerifiedMovementRouter {
  VerifiedMovementRouter({required this.session, required this.combat});

  final BattleSessionEngine session;
  final CombatEngine combat;

  bool accept(VerifiedRep rep) {
    final movement = movementTypeForExercise(rep.exercise);
    if (movement == null) return false;

    final prepared = session.snapshot.preparedMovement;
    if (prepared != null && prepared != movement) return false;

    if (!session.acceptVerifiedMovement(movement)) return false;

    combat.acceptVerifiedRep(formScore: rep.formScore);
    return true;
  }

  static VerifiedMovementType? movementTypeForExercise(String exercise) {
    return switch (exercise) {
      'squat' => VerifiedMovementType.squat,
      'lunge' => VerifiedMovementType.lunge,
      'push_up' => VerifiedMovementType.pushUp,
      'plank' => VerifiedMovementType.plank,
      _ => null,
    };
  }
}
