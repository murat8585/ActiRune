import 'package:flutter/foundation.dart';

enum BattleSessionPhase {
  battlePrep,
  cameraPrep,
  liveBattle,
  formCoach,
  victory,
  defeat,
  retired,
}

enum VerifiedMovementType { squat, lunge, pushUp, plank }

enum BattleSupportAction { runePower, protection, powerPotion }

@immutable
class BattleSessionSnapshot {
  const BattleSessionSnapshot({
    required this.phase,
    required this.isPaused,
    required this.syntheticMode,
    required this.verifiedActionCount,
    required this.supportActionRequestCount,
    required this.rewardedRetriesRemaining,
    this.preparedMovement,
    this.lastVerifiedMovement,
    this.lastSupportAction,
  });

  final BattleSessionPhase phase;
  final bool isPaused;
  final bool syntheticMode;
  final int verifiedActionCount;
  final int supportActionRequestCount;
  final int rewardedRetriesRemaining;
  final VerifiedMovementType? preparedMovement;
  final VerifiedMovementType? lastVerifiedMovement;
  final BattleSupportAction? lastSupportAction;

  BattleSessionSnapshot copyWith({
    BattleSessionPhase? phase,
    bool? isPaused,
    bool? syntheticMode,
    int? verifiedActionCount,
    int? supportActionRequestCount,
    int? rewardedRetriesRemaining,
    VerifiedMovementType? preparedMovement,
    VerifiedMovementType? lastVerifiedMovement,
    BattleSupportAction? lastSupportAction,
    bool clearLastVerifiedMovement = false,
    bool clearLastSupportAction = false,
  }) {
    return BattleSessionSnapshot(
      phase: phase ?? this.phase,
      isPaused: isPaused ?? this.isPaused,
      syntheticMode: syntheticMode ?? this.syntheticMode,
      verifiedActionCount: verifiedActionCount ?? this.verifiedActionCount,
      supportActionRequestCount:
          supportActionRequestCount ?? this.supportActionRequestCount,
      rewardedRetriesRemaining:
          rewardedRetriesRemaining ?? this.rewardedRetriesRemaining,
      preparedMovement: preparedMovement ?? this.preparedMovement,
      lastVerifiedMovement: clearLastVerifiedMovement
          ? null
          : (lastVerifiedMovement ?? this.lastVerifiedMovement),
      lastSupportAction: clearLastSupportAction
          ? null
          : (lastSupportAction ?? this.lastSupportAction),
    );
  }
}

/// Owns battle-flow state, not combat-balance numbers.
///
/// The locked product contract defines movement roles, but does not yet define
/// authoritative numeric effects for Rune Gücü, Koruma or Güç İksiri. Those
/// artwork controls therefore produce typed support-action requests here;
/// damage/heal/shield percentages must be supplied by an authoritative combat
/// or loadout contract instead of being invented in the UI layer.
class BattleSessionEngine extends ChangeNotifier {
  BattleSessionEngine()
    : _snapshot = const BattleSessionSnapshot(
        phase: BattleSessionPhase.battlePrep,
        isPaused: false,
        syntheticMode: false,
        verifiedActionCount: 0,
        supportActionRequestCount: 0,
        rewardedRetriesRemaining: 3,
      );

  BattleSessionSnapshot _snapshot;
  BattleSessionSnapshot get snapshot => _snapshot;

  void prepare(VerifiedMovementType movement) {
    _set(
      _snapshot.copyWith(
        phase: BattleSessionPhase.battlePrep,
        preparedMovement: movement,
        isPaused: false,
      ),
    );
  }

  void enterCameraPrep({bool syntheticMode = false}) {
    _set(
      _snapshot.copyWith(
        phase: BattleSessionPhase.cameraPrep,
        syntheticMode: syntheticMode,
        isPaused: false,
      ),
    );
  }

  bool returnToBattlePrep() {
    if (_snapshot.phase != BattleSessionPhase.cameraPrep ||
        _snapshot.preparedMovement == null) {
      return false;
    }
    _set(
      _snapshot.copyWith(phase: BattleSessionPhase.battlePrep, isPaused: false),
    );
    return true;
  }

  void setSyntheticMode(bool enabled) {
    _set(_snapshot.copyWith(syntheticMode: enabled));
  }

  void startLiveBattle() {
    _set(
      _snapshot.copyWith(phase: BattleSessionPhase.liveBattle, isPaused: false),
    );
  }

  void pause() {
    if (_snapshot.phase != BattleSessionPhase.liveBattle ||
        _snapshot.isPaused) {
      return;
    }
    _set(_snapshot.copyWith(isPaused: true));
  }

  void openFormCoach() {
    if (_snapshot.phase != BattleSessionPhase.liveBattle) return;
    _set(
      _snapshot.copyWith(phase: BattleSessionPhase.formCoach, isPaused: true),
    );
  }

  void resumeLiveBattle() {
    if (_snapshot.phase != BattleSessionPhase.formCoach &&
        _snapshot.phase != BattleSessionPhase.liveBattle) {
      return;
    }
    _set(
      _snapshot.copyWith(phase: BattleSessionPhase.liveBattle, isPaused: false),
    );
  }

  /// Accepts one already-verified movement and records exactly one combat
  /// action. The movement must match the encounter that was prepared before
  /// entering live battle. Unknown/unprepared or mismatched movement is
  /// rejected fail-closed so another detector can never power this encounter.
  bool acceptVerifiedMovement(VerifiedMovementType movement) {
    final preparedMovement = _snapshot.preparedMovement;
    if (_snapshot.phase != BattleSessionPhase.liveBattle ||
        _snapshot.isPaused ||
        preparedMovement == null ||
        movement != preparedMovement) {
      return false;
    }
    _set(
      _snapshot.copyWith(
        verifiedActionCount: _snapshot.verifiedActionCount + 1,
        lastVerifiedMovement: movement,
      ),
    );
    return true;
  }

  /// Records a typed request from an approved artwork control. Form Coach is
  /// an overlay of the same battle session, so its visible support controls may
  /// still emit the same typed requests. No damage/heal/shield magnitude is
  /// applied here because those balance values are not yet authoritative.
  bool requestSupportAction(BattleSupportAction action) {
    final acceptsSupportInput =
        (_snapshot.phase == BattleSessionPhase.liveBattle &&
            !_snapshot.isPaused) ||
        _snapshot.phase == BattleSessionPhase.formCoach;
    if (!acceptsSupportInput) return false;

    _set(
      _snapshot.copyWith(
        supportActionRequestCount: _snapshot.supportActionRequestCount + 1,
        lastSupportAction: action,
      ),
    );
    return true;
  }

  void markVictory() {
    if (_snapshot.phase == BattleSessionPhase.retired) return;
    _set(
      _snapshot.copyWith(phase: BattleSessionPhase.victory, isPaused: false),
    );
  }

  void markDefeat() {
    if (_snapshot.phase == BattleSessionPhase.retired) return;
    _set(_snapshot.copyWith(phase: BattleSessionPhase.defeat, isPaused: false));
  }

  /// Latest user override: a successful rewarded ad restarts the same PvE
  /// encounter from its beginning. Cancelled/failed ads never call this method
  /// and therefore never consume a retry.
  bool restartAfterSuccessfulRewardedAd() {
    if (_snapshot.phase != BattleSessionPhase.defeat ||
        _snapshot.rewardedRetriesRemaining <= 0) {
      return false;
    }
    _set(
      BattleSessionSnapshot(
        phase: BattleSessionPhase.cameraPrep,
        isPaused: false,
        syntheticMode: _snapshot.syntheticMode,
        verifiedActionCount: 0,
        supportActionRequestCount: 0,
        rewardedRetriesRemaining: _snapshot.rewardedRetriesRemaining - 1,
        preparedMovement: _snapshot.preparedMovement,
      ),
    );
    return true;
  }

  void retire() {
    _set(
      _snapshot.copyWith(phase: BattleSessionPhase.retired, isPaused: false),
    );
  }

  void _set(BattleSessionSnapshot next) {
    if (identical(_snapshot, next)) return;
    _snapshot = next;
    notifyListeners();
  }
}
