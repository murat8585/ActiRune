import 'package:flutter/foundation.dart';

/// Runtime-owned values rendered over the canonical Home clean-base artwork.
///
/// This contract deliberately contains no demo/default gameplay values. A null
/// field means the authoritative source for that value is unavailable and the
/// UI must fail closed instead of impersonating player state from baked art.
@immutable
class HomeRuntimeState {
  const HomeRuntimeState({
    this.playerName,
    this.playerLevel,
    this.playerXpFraction,
    this.activeDaysInCurrentSevenDayPath,
    this.unreadInboxCount,
    this.questBadgeCount,
    this.stepsToday,
    this.verifiedMovementsToday,
    this.activeMinutesToday,
    this.runeEnergyFraction,
    this.worldProgressFraction,
    this.remainingEncounterSteps,
    this.rewardBadgeCount,
  }) : assert(playerLevel == null || playerLevel >= 1),
       assert(playerXpFraction == null ||
           (playerXpFraction >= 0 && playerXpFraction <= 1)),
       assert(activeDaysInCurrentSevenDayPath == null ||
           (activeDaysInCurrentSevenDayPath >= 0 &&
               activeDaysInCurrentSevenDayPath <= 7)),
       assert(unreadInboxCount == null || unreadInboxCount >= 0),
       assert(questBadgeCount == null || questBadgeCount >= 0),
       assert(stepsToday == null || stepsToday >= 0),
       assert(verifiedMovementsToday == null || verifiedMovementsToday >= 0),
       assert(activeMinutesToday == null || activeMinutesToday >= 0),
       assert(runeEnergyFraction == null ||
           (runeEnergyFraction >= 0 && runeEnergyFraction <= 1)),
       assert(worldProgressFraction == null ||
           (worldProgressFraction >= 0 && worldProgressFraction <= 1)),
       assert(remainingEncounterSteps == null || remainingEncounterSteps >= 0),
       assert(rewardBadgeCount == null || rewardBadgeCount >= 0);

  final String? playerName;
  final int? playerLevel;

  /// Caller-owned normalized XP progress. Thresholds/curves remain outside UI.
  final double? playerXpFraction;

  /// Activity count inside the locked flexible seven-day activity path.
  final int? activeDaysInCurrentSevenDayPath;

  final int? unreadInboxCount;
  final int? questBadgeCount;
  final int? stepsToday;
  final int? verifiedMovementsToday;
  final int? activeMinutesToday;

  /// Caller-owned normalized Rune Energy state.
  final double? runeEnergyFraction;

  /// Caller-owned normalized progress for the currently displayed world path.
  final double? worldProgressFraction;

  final int? remainingEncounterSteps;
  final int? rewardBadgeCount;

  bool get hasAnyRuntimeData =>
      playerName != null ||
      playerLevel != null ||
      playerXpFraction != null ||
      activeDaysInCurrentSevenDayPath != null ||
      unreadInboxCount != null ||
      questBadgeCount != null ||
      stepsToday != null ||
      verifiedMovementsToday != null ||
      activeMinutesToday != null ||
      runeEnergyFraction != null ||
      worldProgressFraction != null ||
      remainingEncounterSteps != null ||
      rewardBadgeCount != null;
}
