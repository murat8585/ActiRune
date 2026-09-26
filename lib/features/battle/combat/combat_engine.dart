import 'package:flutter/foundation.dart';

@immutable
class CombatSnapshot {
  const CombatSnapshot({
    required this.bossHp,
    required this.bossMaxHp,
    required this.verifiedReps,
    required this.combo,
  });
  final int bossHp;
  final int bossMaxHp;
  final int verifiedReps;
  final int combo;
  double get hpFraction => bossMaxHp == 0 ? 0 : bossHp / bossMaxHp;
}

class CombatEngine extends ChangeNotifier {
  CombatEngine({required this.bossMaxHp, required this.damagePerVerifiedRep})
    : _snapshot = CombatSnapshot(
        bossHp: bossMaxHp,
        bossMaxHp: bossMaxHp,
        verifiedReps: 0,
        combo: 0,
      ) {
    if (bossMaxHp <= 0 || damagePerVerifiedRep <= 0) {
      throw ArgumentError('Combat values must be positive');
    }
  }

  final int bossMaxHp;
  final int damagePerVerifiedRep;
  CombatSnapshot _snapshot;
  CombatSnapshot get snapshot => _snapshot;

  void acceptVerifiedRep({double formScore = 1.0}) {
    final damage = (damagePerVerifiedRep * formScore.clamp(.7, 1.0)).round();
    _snapshot = CombatSnapshot(
      bossHp: (_snapshot.bossHp - damage).clamp(0, bossMaxHp),
      bossMaxHp: bossMaxHp,
      verifiedReps: _snapshot.verifiedReps + 1,
      combo: formScore >= .9 ? _snapshot.combo + 1 : 0,
    );
    notifyListeners();
  }

  void reset() {
    _snapshot = CombatSnapshot(
      bossHp: bossMaxHp,
      bossMaxHp: bossMaxHp,
      verifiedReps: 0,
      combo: 0,
    );
    notifyListeners();
  }
}
