import 'package:flutter/foundation.dart';

/// The four progression axes locked by the Product Bible.
///
/// This policy intentionally owns no XP curves, thresholds, currencies or
/// reward quantities. Those are balance/configuration inputs and are not
/// authoritative in the current product contract.
enum ProgressionAxis { playerLevel, heroLevel, lumiBond, movementMastery }

/// Product-level movement mastery tracks. Each track progresses separately.
enum MovementMasteryTrack { squat, lunge, pushUp, plank }

/// The only Product-Bible-defined sources relevant to mastery authorization.
///
/// Purchase is represented explicitly so the "mastery cannot be purchased"
/// rule is enforceable instead of living as prose only.
enum MovementMasteryAdvanceSource { verifiedCorrectMovement, purchase }

enum PlayerProgressionUnlock {
  systemFeature,
  mapOrRegionAccess,
  questType,
  socialFeature,
  milestone,
}

enum HeroProgressionUnlock {
  skill,
  attackSlot,
  passiveSlot,
  runeCapacity,
  equipmentQuality,
  combatAbility,
}

enum LumiProgressionUnlock { supportEffect, visualEvolution, combatUtility }

enum MovementMasteryUnlock {
  formQuality,
  battlePerformance,
  title,
  masteryCosmetic,
}

@immutable
class MovementMasteryAdvanceAuthorization {
  const MovementMasteryAdvanceAuthorization._({
    required this.track,
    required this.source,
  });

  final MovementMasteryTrack track;
  final MovementMasteryAdvanceSource source;
}

/// Semantic owner for progression rules that are already locked by product.
///
/// The policy deliberately stops at the authority boundary. It does not assign
/// XP, levels, thresholds, drop rates, currencies or reward multipliers because
/// those values remain adjustable and must come from an authoritative balance
/// source later.
class ProgressionPolicy {
  const ProgressionPolicy();

  static const axes = <ProgressionAxis>{
    ProgressionAxis.playerLevel,
    ProgressionAxis.heroLevel,
    ProgressionAxis.lumiBond,
    ProgressionAxis.movementMastery,
  };

  static const masteryTracks = <MovementMasteryTrack>{
    MovementMasteryTrack.squat,
    MovementMasteryTrack.lunge,
    MovementMasteryTrack.pushUp,
    MovementMasteryTrack.plank,
  };

  static const playerUnlocks = <PlayerProgressionUnlock>{
    PlayerProgressionUnlock.systemFeature,
    PlayerProgressionUnlock.mapOrRegionAccess,
    PlayerProgressionUnlock.questType,
    PlayerProgressionUnlock.socialFeature,
    PlayerProgressionUnlock.milestone,
  };

  static const heroUnlocks = <HeroProgressionUnlock>{
    HeroProgressionUnlock.skill,
    HeroProgressionUnlock.attackSlot,
    HeroProgressionUnlock.passiveSlot,
    HeroProgressionUnlock.runeCapacity,
    HeroProgressionUnlock.equipmentQuality,
    HeroProgressionUnlock.combatAbility,
  };

  static const lumiUnlocks = <LumiProgressionUnlock>{
    LumiProgressionUnlock.supportEffect,
    LumiProgressionUnlock.visualEvolution,
    LumiProgressionUnlock.combatUtility,
  };

  static const movementMasteryUnlocks = <MovementMasteryUnlock>{
    MovementMasteryUnlock.formQuality,
    MovementMasteryUnlock.battlePerformance,
    MovementMasteryUnlock.title,
    MovementMasteryUnlock.masteryCosmetic,
  };

  /// Player Level is global/permanent and never participates in a seasonal
  /// reset. No equivalent reset rule is invented here for the other axes.
  bool get playerLevelParticipatesInSeasonalReset => false;

  /// True for the four locked axes. Keeping this explicit prevents a future UI
  /// from silently collapsing Player, Hero, Lumi and Movement Mastery into one
  /// generic level number.
  bool isLockedAxis(ProgressionAxis axis) => axes.contains(axis);

  /// Returns an authorization only when a correct movement has already been
  /// verified. Purchase can never advance mastery.
  MovementMasteryAdvanceAuthorization? authorizeMovementMasteryAdvance({
    required MovementMasteryTrack track,
    required MovementMasteryAdvanceSource source,
  }) {
    if (!masteryTracks.contains(track) ||
        source != MovementMasteryAdvanceSource.verifiedCorrectMovement) {
      return null;
    }

    return MovementMasteryAdvanceAuthorization._(
      track: track,
      source: source,
    );
  }
}
