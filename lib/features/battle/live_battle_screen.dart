import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/clean_base_text.dart';
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
    required this.onOpenFormCoach,
    required this.onVictory,
    this.cameraEnabled = true,
    this.requiredPlankHoldDuration,
  });

  static const artworkAsset =
      'assets/ui/clean_base_final_60/56__FINAL_FIX__LIVE_BATTLE__PASS.png';
  static const artworkSize = Size(941, 1672);

  final BattleSessionEngine session;
  final VoidCallback onOpenFormCoach;
  final VoidCallback onVictory;
  final bool cameraEnabled;
  final Duration? requiredPlankHoldDuration;

  @override
  State<LiveBattleScreen> createState() => _LiveBattleScreenState();
}

class _LiveBattleScreenState extends State<LiveBattleScreen>
    with WidgetsBindingObserver {
  late final CombatEngine _combat;
  late final VerifiedMovementRouter _movementRouter;
  PoseCameraController? _poseCamera;
  bool _cameraStartPending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _combat = CombatEngine();
    _movementRouter = VerifiedMovementRouter(
      session: widget.session,
      combat: _combat,
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
    _combat.dispose();
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
    _startCameraIfNeeded();
  }

  void _debugVictory() {
    if (!widget.session.snapshot.syntheticMode) return;
    widget.session.markVictory();
    _stopCamera();
    widget.onVictory();
  }

  void _debugDefeat() {
    if (!widget.session.snapshot.syntheticMode) return;
    widget.session.markDefeat();
    _stopCamera();
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
    final syntheticMode = widget.session.snapshot.syntheticMode;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: LiveBattleScreen.artworkAsset,
          sourceSize: LiveBattleScreen.artworkSize,
          overlays: [
            const ArtworkOverlay(
              id: 'live-battle.hero-name',
              normalizedRect: Rect.fromLTWH(0.100, 0.025, 0.255, 0.045),
              child: CleanBaseText('ActiHero', fontSize: 16),
            ),
            const ArtworkOverlay(
              id: 'live-battle.pause-label',
              normalizedRect: Rect.fromLTWH(0.390, 0.020, 0.220, 0.050),
              child: CleanBaseText('DURDUR', fontSize: 15),
            ),
            const ArtworkOverlay(
              id: 'live-battle.enemy-name',
              normalizedRect: Rect.fromLTWH(0.650, 0.025, 0.245, 0.045),
              child: CleanBaseText('GÖLGE MUHAFIZI', fontSize: 14),
            ),
            const ArtworkOverlay(
              id: 'live-battle.continue-label',
              normalizedRect: Rect.fromLTWH(0.395, 0.785, 0.500, 0.045),
              child: CleanBaseText('HAREKETE DEVAM', fontSize: 16),
            ),
            if (syntheticMode)
              const ArtworkOverlay(
                id: 'live-battle.qa-victory-label',
                normalizedRect: Rect.fromLTWH(0.325, 0.095, 0.165, 0.038),
                child: CleanBaseText(
                  'TEST ZAFER',
                  fontSize: 12,
                  color: Color(0xFF79F7AE),
                ),
              ),
            if (syntheticMode)
              const ArtworkOverlay(
                id: 'live-battle.qa-defeat-label',
                normalizedRect: Rect.fromLTWH(0.510, 0.095, 0.165, 0.038),
                child: CleanBaseText(
                  'TEST YENİLGİ',
                  fontSize: 12,
                  color: Color(0xFFFF7A7A),
                ),
              ),
          ],
          hotspots: [
            ArtworkHotspot(
              id: 'live-battle.pause',
              semanticLabel: 'Durdur',
              normalizedRect: const Rect.fromLTWH(0.380, 0.010, 0.240, 0.070),
              onTap: _openFormCoach,
            ),
            ArtworkHotspot(
              id: 'live-battle.rune-power',
              semanticLabel: 'Rune Gücü',
              normalizedRect: const Rect.fromLTWH(0.325, 0.855, 0.135, 0.105),
              onTap: () => widget.session.requestSupportAction(
                BattleSupportAction.runePower,
              ),
            ),
            ArtworkHotspot(
              id: 'live-battle.protection',
              semanticLabel: 'Koruma',
              normalizedRect: const Rect.fromLTWH(0.790, 0.850, 0.190, 0.115),
              onTap: () => widget.session.requestSupportAction(
                BattleSupportAction.protection,
              ),
            ),
            ArtworkHotspot(
              id: 'live-battle.health-potion',
              semanticLabel: 'Güç İksiri',
              normalizedRect: const Rect.fromLTWH(0.615, 0.855, 0.135, 0.105),
              onTap: () => widget.session.requestSupportAction(
                BattleSupportAction.powerPotion,
              ),
            ),
            ArtworkHotspot(
              id: 'live-battle.battle-continue',
              semanticLabel: 'Harekete devam',
              normalizedRect: const Rect.fromLTWH(0.355, 0.770, 0.585, 0.080),
              onTap: _continueBattle,
            ),
            if (syntheticMode)
              ArtworkHotspot(
                id: 'live-battle.qa-victory',
                semanticLabel: 'Test Zafer',
                normalizedRect: const Rect.fromLTWH(0.315, 0.085, 0.185, 0.060),
                onTap: _debugVictory,
              ),
            if (syntheticMode)
              ArtworkHotspot(
                id: 'live-battle.qa-defeat',
                semanticLabel: 'Test Yenilgi',
                normalizedRect: const Rect.fromLTWH(0.500, 0.085, 0.185, 0.060),
                onTap: _debugDefeat,
              ),
          ],
        ),
      ),
    );
  }
}
