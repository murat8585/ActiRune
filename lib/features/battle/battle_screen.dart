import 'package:flutter/material.dart';

import 'battle_flow_host.dart';
import 'battle_prep_screen.dart';
import 'battle_session_engine.dart';
import 'camera_prep_screen.dart';

typedef BattleRewardedRetryRequest = Future<bool> Function();

/// Route-level adapter for one canonical PvE encounter.
///
/// The caller owns encounter selection and external navigation. This screen
/// owns exactly one [BattleSessionEngine] so battle state survives the
/// Battle Prep -> Camera Prep -> Live Battle <-> Form Coach -> Result flow.
class BattleScreen extends StatefulWidget {
  const BattleScreen({
    super.key,
    required this.movement,
    this.cameraReadiness = CameraPrepReadiness.checking,
    this.cameraEnabled = true,
    this.requiredPlankHoldDuration,
    this.onExitEncounter,
    this.onRootNavigate,
    this.onEquipment,
    this.onRunes,
    this.onCompanion,
    this.onAbilities,
    this.onBattleTips,
    this.onBattlePrepInfo,
    this.onCameraPrepInfo,
    this.onCameraRecheck,
    this.onRewardedRetry,
    this.onVictoryReplay,
    this.onVictoryViewRewards,
    this.onDefeatViewTactics,
  });

  final VerifiedMovementType movement;
  final CameraPrepReadiness cameraReadiness;
  final bool cameraEnabled;

  /// Required only for plank encounters. The authoritative encounter/task
  /// owner supplies the hold target; no UI or camera layer default is invented.
  final Duration? requiredPlankHoldDuration;

  final VoidCallback? onExitEncounter;
  final ValueChanged<BattlePrepRootDestination>? onRootNavigate;

  final VoidCallback? onEquipment;
  final VoidCallback? onRunes;
  final VoidCallback? onCompanion;
  final VoidCallback? onAbilities;
  final VoidCallback? onBattleTips;
  final VoidCallback? onBattlePrepInfo;

  final VoidCallback? onCameraPrepInfo;
  final VoidCallback? onCameraRecheck;

  final BattleRewardedRetryRequest? onRewardedRetry;
  final VoidCallback? onVictoryReplay;
  final VoidCallback? onVictoryViewRewards;
  final VoidCallback? onDefeatViewTactics;

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  late final BattleSessionEngine _session;

  @override
  void initState() {
    super.initState();
    _session = BattleSessionEngine()..prepare(widget.movement);
  }

  @override
  void dispose() {
    _session.dispose();
    super.dispose();
  }

  void _exitEncounter() {
    if (_session.snapshot.phase != BattleSessionPhase.retired) {
      _session.retire();
    }

    final callback = widget.onExitEncounter;
    if (callback != null) {
      callback();
      return;
    }

    Navigator.of(context).maybePop();
  }

  void _rootNavigate(BattlePrepRootDestination destination) {
    final callback = widget.onRootNavigate;
    if (callback != null) {
      callback(destination);
      return;
    }

    Navigator.of(context).maybePop();
  }

  Future<void> _requestRewardedRetry() async {
    final request = widget.onRewardedRetry;
    if (request == null) return;

    final rewarded = await request();
    if (!mounted || !rewarded) return;

    _session.restartAfterSuccessfulRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return BattleFlowHost(
      session: _session,
      cameraReadiness: widget.cameraReadiness,
      cameraEnabled: widget.cameraEnabled,
      requiredPlankHoldDuration: widget.requiredPlankHoldDuration,
      onBattlePrepBack: _exitEncounter,
      onBattlePrepInfo: widget.onBattlePrepInfo,
      onEquipment: widget.onEquipment,
      onRunes: widget.onRunes,
      onCompanion: widget.onCompanion,
      onAbilities: widget.onAbilities,
      onBattleTips: widget.onBattleTips,
      onReturnToAdventure: _exitEncounter,
      onRootNavigate: _rootNavigate,
      onCameraPrepInfo: widget.onCameraPrepInfo,
      onCameraRecheck: widget.onCameraRecheck,
      onVictoryContinue: _exitEncounter,
      onVictoryReplay: widget.onVictoryReplay,
      onVictoryViewRewards: widget.onVictoryViewRewards,
      onRewardedRetryRequested: () {
        _requestRewardedRetry();
      },
      onDefeatReturnToAdventure: _exitEncounter,
      onDefeatViewTactics: widget.onDefeatViewTactics,
    );
  }
}
