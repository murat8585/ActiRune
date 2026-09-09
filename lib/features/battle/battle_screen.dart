import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../../core/design/actirune_theme.dart';
import 'combat/combat_engine.dart';
import 'game/actirune_battle_game.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});
  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  late final CombatEngine combat;
  late final ActiRuneBattleGame game;

  @override
  void initState() {
    super.initState();
    combat = CombatEngine();
    game = ActiRuneBattleGame(combat);
  }

  @override
  void dispose() {
    combat.dispose();
    super.dispose();
  }

  void _debugVerifiedRep() {
    combat.acceptVerifiedRep(formScore: .98);
    game.playVerifiedHit();
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
                          IconButton.filledTonal(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(color: ActiRuneColors.surface, borderRadius: BorderRadius.circular(18)),
                            child: Text('Squat  ${s.verifiedReps} / 15', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          const Spacer(),
                          IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.pause)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      LinearProgressIndicator(value: s.hpFraction, minHeight: 12, color: ActiRuneColors.danger),
                      const SizedBox(height: 6),
                      Text('Buz Devi Gözcüsü   ${s.bossHp} / ${s.bossMaxHp}'),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: ActiRuneColors.surface, borderRadius: BorderRadius.circular(16)),
                          child: Text('x${s.combo}\nKOMBO', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.videocam, color: ActiRuneColors.cyan),
                          Text('CAMERA / POSE'),
                          Text('prototype slot', style: TextStyle(fontSize: 11)),
                        ]),
                      ),
                      const SizedBox(height: 12),
                      const Text('Mükemmel!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: ActiRuneColors.cyan)),
                      const Text('Rün Gücü Yükseliyor!'),
                      const SizedBox(height: 16),
                      // Prototype-only. Real build replaces this with VerifiedRep stream.
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton.icon(
                          onPressed: _debugVerifiedRep,
                          icon: const Icon(Icons.science),
                          label: const Text('DEBUG: VERIFIED SQUAT ÜRET'),
                        ),
                      ),
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
}
