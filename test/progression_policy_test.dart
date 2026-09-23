import 'package:actirune/features/progression/progression_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = ProgressionPolicy();

  test('Product Bible keeps exactly four independent progression axes', () {
    expect(
      ProgressionPolicy.axes,
      {
        ProgressionAxis.playerLevel,
        ProgressionAxis.heroLevel,
        ProgressionAxis.lumiBond,
        ProgressionAxis.movementMastery,
      },
    );

    for (final axis in ProgressionAxis.values) {
      expect(policy.isLockedAxis(axis), isTrue);
    }
  });

  test('Player Level is permanent and excluded from seasonal reset', () {
    expect(policy.playerLevelParticipatesInSeasonalReset, isFalse);
  });

  test('Player unlock contract contains only locked semantic categories', () {
    expect(
      ProgressionPolicy.playerUnlocks,
      {
        PlayerProgressionUnlock.systemFeature,
        PlayerProgressionUnlock.mapOrRegionAccess,
        PlayerProgressionUnlock.questType,
        PlayerProgressionUnlock.socialFeature,
        PlayerProgressionUnlock.milestone,
      },
    );
  });

  test('Hero unlock contract remains a separate progression track', () {
    expect(
      ProgressionPolicy.heroUnlocks,
      {
        HeroProgressionUnlock.skill,
        HeroProgressionUnlock.attackSlot,
        HeroProgressionUnlock.passiveSlot,
        HeroProgressionUnlock.runeCapacity,
        HeroProgressionUnlock.equipmentQuality,
        HeroProgressionUnlock.combatAbility,
      },
    );
  });

  test('Lumi Bond unlock contract stays separate from Hero and Player', () {
    expect(
      ProgressionPolicy.lumiUnlocks,
      {
        LumiProgressionUnlock.supportEffect,
        LumiProgressionUnlock.visualEvolution,
        LumiProgressionUnlock.combatUtility,
      },
    );
  });

  test('Movement Mastery has exactly the four locked movement tracks', () {
    expect(
      ProgressionPolicy.masteryTracks,
      {
        MovementMasteryTrack.squat,
        MovementMasteryTrack.lunge,
        MovementMasteryTrack.pushUp,
        MovementMasteryTrack.plank,
      },
    );
  });

  test('verified correct movement can advance only its explicit mastery track', () {
    for (final track in MovementMasteryTrack.values) {
      final authorization = policy.authorizeMovementMasteryAdvance(
        track: track,
        source: MovementMasteryAdvanceSource.verifiedCorrectMovement,
      );

      expect(authorization, isNotNull);
      expect(authorization!.track, track);
      expect(
        authorization.source,
        MovementMasteryAdvanceSource.verifiedCorrectMovement,
      );
    }
  });

  test('Movement Mastery cannot be purchased', () {
    for (final track in MovementMasteryTrack.values) {
      expect(
        policy.authorizeMovementMasteryAdvance(
          track: track,
          source: MovementMasteryAdvanceSource.purchase,
        ),
        isNull,
      );
    }
  });

  test('Movement Mastery unlock categories stay semantic, not numeric balance', () {
    expect(
      ProgressionPolicy.movementMasteryUnlocks,
      {
        MovementMasteryUnlock.formQuality,
        MovementMasteryUnlock.battlePerformance,
        MovementMasteryUnlock.title,
        MovementMasteryUnlock.masteryCosmetic,
      },
    );
  });
}
