import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../pose/detector/squat_detector.dart';
import '../pose/provider/pose_camera_controller.dart';
import 'battle_session_engine.dart';
import 'combat/combat_engine.dart';

class LiveBattleScreen extends StatefulWidget {
  const LiveBattleScreen({
    super.key,
    required this.session,
    required this.onOpenFormCoach,
    required this.onVictory,
    this.cameraEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/02_CORE_LOCKED_ANCHORS/'
      'VIS_0168__CORE_LIVE_BATTLE_ANCHOR.png';

  final BattleSessionEngine session;
  final VoidCallback onOpenFormCoach;
  final VoidCallback onVictory;
  final bool cameraEnabled;

  @override
  State<LiveBattleScreen> createState() => _LiveBattleScreenState();
}

class _LiveBattleScreenState extends State<LiveBattleScreen>
    with WidgetsBindingObserver {
  late final CombatEngine _combat;
  PoseCameraController? _poseCamera;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _combat = CombatEngine();
    widget.session.startLiveBattle();
    if (widget.cameraEnabled) {
      _poseCamera = PoseCameraController(onVerifiedRep: _acceptVerifiedRep);
      unawaited(_poseCamera!.start());
    }
  }

  @override
  void didUpdateWidget(covariant LiveBattleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.cameraEnabled && widget.cameraEnabled && _poseCamera == null) {
      _poseCamera = PoseCameraController(onVerifiedRep: _acceptVerifiedRep);
      unawaited(_poseCamera!.start());
    } else if (oldWidget.cameraEnabled && !widget.cameraEnabled) {
      final camera = _poseCamera;
      _poseCamera = null;
      if (camera != null) unawaited(camera.dispose());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final camera = _poseCamera;
    _poseCamera = null;
    if (camera != null) unawaited(camera.dispose());
    _combat.dispose();
    super.dispose();
  }

  void _acceptVerifiedRep(VerifiedRep rep) {
    if (!mounted) return;
    final accepted = widget.session.acceptVerifiedMovement(
      VerifiedMovementType.squat,
    );
    if (!accepted) return;

    _combat.acceptVerifiedRep(formScore: rep.formScore);
    if (_combat.snapshot.bossHp <= 0) {
      widget.session.markVictory();
      _stopCamera();
      widget.onVictory();
    }
  }

  void _openFormCoach() {
    widget.session.openFormCoach();
    _stopCamera();
    widget.onOpenFormCoach();
  }

  void _continueBattle() {
    widget.session.resumeLiveBattle();
    if (widget.cameraEnabled && !(_poseCamera?.isReady ?? false)) {
      unawaited(_poseCamera?.start());
    }
  }

  void _stopCamera() {
    final camera = _poseCamera;
    if (camera != null) unawaited(camera.stop());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final camera = _poseCamera;
    if (camera == null) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      widget.session.pause();
      unawaited(camera.stop());
    } else if (state == AppLifecycleState.resumed &&
        widget.session.snapshot.phase == BattleSessionPhase.liveBattle &&
        !widget.session.snapshot.isPaused &&
        !camera.isReady) {
      unawaited(camera.start());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: LiveBattleScreen.artworkAsset,
          hotspots: [
            ArtworkHotspot(
              id: 'live-battle.pause',
              semanticLabel: 'Durdur',
              normalizedRect: const Rect.fromLTWH(
                0.030,
                0.116,
                0.074,
                0.060,
              ),
              onTap: _openFormCoach,
            ),
            ArtworkHotspot(
              id: 'live-battle.rune-power',
              semanticLabel: 'Rune Gücü',
              normalizedRect: const Rect.fromLTWH(
                0.083,
                0.783,
                0.235,
                0.082,
              ),
              onTap: () => widget.session.requestSupportAction(
                BattleSupportAction.runePower,
              ),
            ),
            ArtworkHotspot(
              id: 'live-battle.protection',
              semanticLabel: 'Koruma',
              normalizedRect: const Rect.fromLTWH(
                0.371,
                0.783,
                0.235,
                0.082,
              ),
              onTap: () => widget.session.requestSupportAction(
                BattleSupportAction.protection,
              ),
            ),
            ArtworkHotspot(
              id: 'live-battle.health-potion',
              semanticLabel: 'Güç İksiri',
              normalizedRect: const Rect.fromLTWH(
                0.662,
                0.783,
                0.235,
                0.082,
              ),
              onTap: () => widget.session.requestSupportAction(
                BattleSupportAction.powerPotion,
              ),
            ),
            ArtworkHotspot(
              id: 'live-battle.battle-continue',
              semanticLabel: 'HAREKET DEVAM ETTİKÇE ZAFER YAKLAŞIR!',
              normalizedRect: const Rect.fromLTWH(
                0.182,
                0.872,
                0.638,
                0.063,
              ),
              onTap: _continueBattle,
            ),
          ],
        ),
      ),
    );
  }
}
