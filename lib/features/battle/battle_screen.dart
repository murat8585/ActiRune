import 'package:flame/game.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../core/design/actirune_theme.dart';
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
    if (!mounted) return;
    combat.acceptVerifiedRep(formScore: rep.formScore);
    game.playVerifiedHit();
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
          final s = combat.snapshot;
          return Stack(
            fit: StackFit.expand,
            children: [
              GameWidget(game: game),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton.filledTonal(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: ActiRuneColors.surface,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              'Squat  ${s.verifiedReps} / 15',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton.filledTonal(
                            onPressed: () {},
                            icon: const Icon(Icons.pause),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      LinearProgressIndicator(
                        value: s.hpFraction,
                        minHeight: 12,
                        color: ActiRuneColors.danger,
                      ),
                      const SizedBox(height: 6),
                      Text('Buz Devi Gözcüsü   ${s.bossHp} / ${s.bossMaxHp}'),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: ActiRuneColors.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'x${s.combo}\nKOMBO',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 148,
                        height: 110,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF061729),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: ActiRuneColors.cyan),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _cameraPanel(),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Mükemmel!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: ActiRuneColors.cyan,
                        ),
                      ),
                      const Text('Rün Gücü Yükseliyor!'),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
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
      return Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(controller),
          const Align(
            alignment: Alignment.bottomCenter,
            child: ColoredBox(
              color: Color(0x99061729),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Text('POSE AKTİF', style: TextStyle(fontSize: 11)),
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          poseCamera.error == null ? Icons.videocam : Icons.videocam_off,
          color: ActiRuneColors.cyan,
        ),
        Text(
          poseCamera.error == null
              ? 'KAMERA HAZIRLANIYOR'
              : 'KAMERA KULLANILAMIYOR',
        ),
      ],
    );
  }
}
