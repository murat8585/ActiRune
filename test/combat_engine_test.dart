import 'package:flutter_test/flutter_test.dart';
import 'package:actirune/features/battle/combat/combat_engine.dart';

void main() {
  test('one verified rep damages boss exactly once', () {
    final engine = CombatEngine(bossMaxHp: 1000, damagePerVerifiedRep: 100);
    engine.acceptVerifiedRep();
    expect(engine.snapshot.bossHp, 900);
    expect(engine.snapshot.verifiedReps, 1);
  });
}
