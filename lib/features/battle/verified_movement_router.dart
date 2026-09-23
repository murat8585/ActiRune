import '../pose/detector/verified_rep.dart';
import 'battle_session_engine.dart';
import 'combat/combat_engine.dart';

/// Routes detector-produced [VerifiedRep] events into the authoritative battle
/// and combat owners without introducing movement balance or UI state.
///
/// A supported event identity is consumed at most once for the lifetime of
/// this router. Events rejected because the battle is not live are not replayed
/// later, preventing stale/ghost movement actions after pause or phase changes.
class VerifiedMovementRouter {
  VerifiedMovementRouter({
    required BattleSessionEngine session,
    required CombatEngine combat,
  }) : _session = session,
       _combat = combat;

  final BattleSessionEngine _session;
  final CombatEngine _combat;
  final Set<({String exercise, int atMicros})> _consumed = {};

  bool route(VerifiedRep rep) {
    final movement = _movementFor(rep.exercise);
    if (movement == null) return false;

    final identity = (
      exercise: rep.exercise,
      atMicros: rep.at.microsecondsSinceEpoch,
    );
    if (!_consumed.add(identity)) return false;

    if (!_session.acceptVerifiedMovement(movement)) return false;

    _combat.acceptVerifiedRep(formScore: rep.formScore);
    return true;
  }

  VerifiedMovementType? _movementFor(String exercise) {
    return switch (exercise) {
      'squat' => VerifiedMovementType.squat,
      'lunge' => VerifiedMovementType.lunge,
      'push_up' => VerifiedMovementType.pushUp,
      'plank' => VerifiedMovementType.plank,
      _ => null,
    };
  }
}
