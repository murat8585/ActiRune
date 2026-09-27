import 'package:camera/camera.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/ui/clean_base_assets.dart';
import '../../core/ui/clean_base_overlay.dart';
import '../../core/ui/clean_base_screen.dart';
import 'combat/combat_engine.dart';
import 'game/actirune_battle_game.dart';
import '../pose/detector/squat_detector.dart';
import '../pose/provider/pose_camera_controller.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen>
    with WidgetsBindingObserver {
  late final CombatEngine combat;
  late final ActiRuneBattleGame game;
  late final PoseCameraController poseCamera;
  bool _victoryQueued = false;

  @override
  void initState() {
    super.initState();
    combat = CombatEngine();
    game = ActiRuneBattleGame(combat);
    WidgetsBinding.instance.addObserver(this);
    poseCamera = PoseCameraController(onVerifiedRep: _acceptVerifiedRep);
    poseCamera.start().whenComplete(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    poseCamera.dispose();
    combat.dispose();
    super.dispose();
  }

  void _acceptVerifiedRep(VerifiedRep rep) {
    if (!mounted || combat.snapshot.bossHp <= 0) return;
    combat.acceptVerifiedRep(formScore: rep.formScore);
    game.playVerifiedHit();
  }

  void _queueVictory() {
    if (_victoryQueued) return;
    _victoryQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.go('/app/battle/victory');
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      poseCamera.stop();
    } else if (state == AppLifecycleState.resumed && !poseCamera.isReady) {
      poseCamera.start().whenComplete(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: combat,
        builder: (context, _) {
          final snapshot = combat.snapshot;
          if (snapshot.bossHp <= 0) _queueVictory();

          return Stack(
            fit: StackFit.expand,
            children: [
              // Keep the existing Flame game mounted. The production clean-base
              // artwork is the visible layer above it while combat logic remains intact.
              GameWidget(game: game),
              CleanBaseScreen(
                assetPath: CleanBaseAssets.liveBattle,
                children: [
                  CleanBaseHotspot(
                    left: 0,
                    top: 0,
                    width: 165,
                    height: 180,
                    semanticLabel: 'Savaş hazırlığına dön',
                    onTap: () => context.go('/app/battle/prep'),
                  ),
                  CleanBasePositioned(
                    left: 620,
                    top: 58,
                    width: 370,
                    height: 22,
                    child: LinearProgressIndicator(
                      value: snapshot.hpFraction,
                      minHeight: 18,
                      backgroundColor: const Color(0x66000000),
                      color: const Color(0xFFD63D4B),
                    ),
                  ),
                  CleanBaseLabel(
                    left: 380,
                    top: 55,
                    width: 260,
                    height: 70,
                    text: '${snapshot.bossHp} / ${snapshot.bossMaxHp}',
                    fontSize: 28,
                  ),
                  CleanBaseLabel(
                    left: 425,
                    top: 1210,
                    width: 230,
                    height: 80,
                    text: '${snapshot.verifiedReps} / 15',
                    fontSize: 38,
                  ),
                  CleanBaseLabel(
                    left: 50,
                    top: 1160,
                    width: 180,
                    height: 90,
                    text: 'x${snapshot.combo}',
                    fontSize: 40,
                  ),
                  CleanBasePositioned(
                    left: 800,
                    top: 1280,
                    width: 230,
                    height: 165,
                    child: _cameraPanel(),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _cameraPanel() {
    final controller = poseCamera.camera;
    if (controller != null && controller.value.isInitialized) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: CameraPreview(controller),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xCC061729),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF57D9FF), width: 2),
      ),
      child: Center(
        child: Icon(
          poseCamera.error == null ? Icons.videocam : Icons.videocam_off,
          size: 46,
          color: const Color(0xFF57D9FF),
        ),
      ),
    );
  }
}
