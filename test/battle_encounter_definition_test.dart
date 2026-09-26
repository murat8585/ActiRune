import 'package:actirune/features/battle/battle_encounter_definition.dart';
import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:actirune/features/battle/combat/combat_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('encounter requires stable identity and explicit combat values', () {
    expect(
      () => BattleEncounterDefinition(
        encounterId: '',
        enemyId: 'fixture-enemy',
        contentVersion: 'test-only',
        movement: VerifiedMovementType.squat,
        enemyMaxHp: 1000,
        damagePerVerifiedRep: 100,
      ),
      throwsArgumentError,
    );
    expect(
      () => BattleEncounterDefinition(
        encounterId: 'fixture-encounter',
        enemyId: 'fixture-enemy',
        contentVersion: 'test-only',
        movement: VerifiedMovementType.squat,
        enemyMaxHp: 0,
        damagePerVerifiedRep: 100,
      ),
      throwsArgumentError,
    );
    expect(
      () => CombatEngine(bossMaxHp: 1000, damagePerVerifiedRep: 0),
      throwsArgumentError,
    );
  });

  test(
    'fixture encounter movement and combat have exact independent owners',
    () {
      final encounter = BattleEncounterDefinition(
        encounterId: 'fixture-encounter',
        enemyId: 'fixture-enemy',
        contentVersion: 'test-only',
        movement: VerifiedMovementType.lunge,
        enemyMaxHp: 1000,
        damagePerVerifiedRep: 100,
      );
      final session = BattleSessionEngine()..prepare(encounter.movement);
      final combat = CombatEngine(
        bossMaxHp: encounter.enemyMaxHp,
        damagePerVerifiedRep: encounter.damagePerVerifiedRep,
      );
      expect(encounter.encounterId, 'fixture-encounter');
      expect(encounter.enemyId, 'fixture-enemy');
      expect(session.snapshot.preparedMovement, VerifiedMovementType.lunge);
      expect(combat.snapshot.bossHp, encounter.enemyMaxHp);
      expect(combat.snapshot.combo, 0);
      combat.dispose();
      session.dispose();
    },
  );
}
