import 'package:flutter/foundation.dart';

import 'battle_session_engine.dart';

/// A caller-owned encounter record. This type is a contract, not a catalog:
/// production must obtain its values from an approved versioned content owner.
@immutable
class BattleEncounterDefinition {
  BattleEncounterDefinition({
    required this.encounterId,
    required this.enemyId,
    required this.contentVersion,
    required this.movement,
    required this.enemyMaxHp,
    required this.damagePerVerifiedRep,
  }) {
    if (encounterId.trim().isEmpty ||
        enemyId.trim().isEmpty ||
        contentVersion.trim().isEmpty ||
        enemyMaxHp <= 0 ||
        damagePerVerifiedRep <= 0) {
      throw ArgumentError(
        'Encounter identity and positive combat values are required',
      );
    }
  }

  final String encounterId;
  final String enemyId;
  final String contentVersion;
  final VerifiedMovementType movement;
  final int enemyMaxHp;
  final int damagePerVerifiedRep;
}
