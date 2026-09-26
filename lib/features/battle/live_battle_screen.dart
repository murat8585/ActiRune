import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../pose/detector/verified_rep.dart';
import '../pose/provider/pose_camera_controller.dart';
import 'battle_pose_detector_factory.dart';
import 'battle_session_engine.dart';
import 'combat/combat_engine.dart';
import 'verified_movement_router.dart';

class LiveBattleScreen extends StatefulWidget {
  const LiveBattleScreen({
    super.key,
    required this.session,
    required this.combat,
    required this.onOpenFormCoach,
    required this.onVictory,
    this.cameraEnabled = true,
    this.requiredPlankHoldDuration,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/02_CORE_LOCKED_ANCHORS/'
      'VIS_0168__CORE_LIVE_BATTLE_ANCHOR.png';
  static const artworkSize = Size(941, 1672);

  final BattleSessionEngine session;
  final CombatEngine combat;
  final VoidCallback onOpenFormCoach;
  final VoidCallback onVictory;
  final bool cameraEnabled;

  /// Authoritative encounter/task hold target for plank. A plank encounter
  /// remains camera-fail-closed when this value is absent or non-positive.
  final Duration? requiredPlankHoldDuration;

  @override
  State<LiveBattleScreen> createState() => _LiveBattleScreenState();
}

class _LiveBattleScreenState extends State<LiveBattleScreen>
    with WidgetsBindingObserver {
  late final VerifiedMovementRouter _movementRouter;
  PoseCameraController? _poseCamera;
  bool _cameraStartPending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _movementRouter = VerifiedMovementRouter(
      session: widget.session,
      combat: widget.combat,
    );
    if (widget.session.snapshot.phase != BattleSessionPhase.liveBattle) {
      widget.session.startLiveBattle();
    }
    if (widget.cameraEnabled) {
      _ensurePoseCamera();
      _startCameraIfNeeded();
    }
  }

  @override
  void didUpdateWidget(covariant LiveBattleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.cameraEnabled && widget.cameraEnabled) {
      _ensurePoseCamera();
      _startCameraIfNeeded();
    } else if (oldWidget.cameraEnabled && !widget.cameraEnabled) {
      final camera = _poseCamera;
      _poseCamera = null;
      if (camera != null) unawaited(camera.dispose());
    } else if (widget.cameraEnabled &&
        widget.session.snapshot.phase == BattleSessionPhase.liveBattle) {
      _ensurePoseCamera();
      _startCameraIfNeeded();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final camera = _poseCamera;
    _poseCamera = null;
    if (camera != null) unawaited(camera.dispose());
    super.dispose();
  }

  void _ensurePoseCamera() {
    if (_poseCamera != null) return;

    final detector = const BattlePoseDetectorFactory().tryCreate(
      preparedMovement: widget.session.snapshot.preparedMovement,
      requiredPlankHoldDuration: widget.requiredPlankHoldDuration,
    );
    if (detector == null) return;

    _poseCamera = PoseCameraController(
      detector: detector,
      onVerifiedRep: _acceptVerifiedRep,
    );
  }

  void _startCameraIfNeeded() {
    if (!widget.cameraEnabled || _cameraStartPending) return;
    final camera = _poseCamera;
    if (camera == null || camera.isReady) return;

    _cameraStartPending = true;
    unawaited(
      camera.start().whenComplete(() {
        _cameraStartPending = false;
      }),
    );
  }

  void _acceptVerifiedRep(VerifiedRep rep) {
    if (!mounted || !_movementRouter.route(rep)) return;

    if (widget.combat.snapshot.bossHp <= 0) {
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
    _startCameraIfNeeded();
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
        !widget.session.snapshot.isPaused) {
      _startCameraIfNeeded();
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
          sourceSize: LiveBattleScreen.artworkSize,
          hotspots: [
            ArtworkHotspot(
              id: 'live-battle.pause',
              semanticLabel: 'Durdur',
              normalizedRect: const Rect.fromLTWH(0.030, 0.116, 0.074, 0.060),
              onTap: _openFormCoach,
            ),
            ArtworkHotspot(
              id: 'live-battle.rune-power',
              semanticLabel: 'Rune Gücü',
              normalizedRect: const Rect.fromLTWH(0.083, 0.783, 0.235, 0.082),
              onTap: () => widget.session.requestSupportAction(
                BattleSupportAction.runePower,
              ),
            ),
            ArtworkHotspot(
              id: 'live-battle.protection',
              semanticLabel: 'Koruma',
              normalizedRect: const Rect.fromLTWH(0.371, 0.783, 0.235, 0.082),
              onTap: () => widget.session.requestSupportAction(
                BattleSupportAction.protection,
              ),
            ),
            ArtworkHotspot(
              id: 'live-battle.health-potion',
              semanticLabel: 'Güç İksiri',
              normalizedRect: const Rect.fromLTWH(0.662, 0.783, 0.235, 0.082),
              onTap: () => widget.session.requestSupportAction(
                BattleSupportAction.powerPotion,
              ),
            ),
            ArtworkHotspot(
              id: 'live-battle.battle-continue',
              semanticLabel: 'HAREKET DEVAM ETTİKÇE ZAFER YAKLAŞIR!',
              normalizedRect: const Rect.fromLTWH(0.182, 0.872, 0.638, 0.063),
              onTap: _continueBattle,
            ),
          ],
        ),
      ),
    );
  }
}
