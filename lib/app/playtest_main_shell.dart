import 'package:flutter/material.dart';

import '../features/battle/battle_flow_host.dart';
import '../features/battle/battle_prep_screen.dart';
import '../features/battle/battle_session_engine.dart';
import '../features/battle/camera_prep_screen.dart';
import 'main_shell.dart';

/// Emulator integration shell for the current Final60 first-10 pass.
///
/// It keeps the real MainShell and BattleSessionEngine contracts intact while
/// using a synthetic, camera-disabled battle session so the full visual flow
/// can be inspected on an emulator without inventing production encounter
/// data or requiring a physical camera/pose run.
class PlaytestMainShell extends StatefulWidget {
  const PlaytestMainShell({super.key});

  @override
  State<PlaytestMainShell> createState() => _PlaytestMainShellState();
}

class _PlaytestMainShellState extends State<PlaytestMainShell> {
  late BattleSessionEngine _session;

  @override
  void initState() {
    super.initState();
    _session = _newSession();
  }

  BattleSessionEngine _newSession() {
    final session = BattleSessionEngine();
    session.prepare(VerifiedMovementType.squat);
    session.setSyntheticMode(true);
    return session;
  }

  void _resetBattle() {
    final previous = _session;
    setState(() => _session = _newSession());
    previous.dispose();
  }

  void _leaveBattle(
    ValueChanged<BattlePrepRootDestination> onRootNavigate,
    BattlePrepRootDestination destination,
  ) {
    onRootNavigate(destination);
    _resetBattle();
  }

  Widget _buildBattle(
    BuildContext context,
    ValueChanged<BattlePrepRootDestination> onRootNavigate,
  ) {
    return BattleFlowHost(
      session: _session,
      cameraReadiness: CameraPrepReadiness.ready,
      cameraEnabled: false,
      onBattlePrepBack: () =>
          _leaveBattle(onRootNavigate, BattlePrepRootDestination.adventure),
      onReturnToAdventure: () =>
          _leaveBattle(onRootNavigate, BattlePrepRootDestination.adventure),
      onRootNavigate: (destination) =>
          _leaveBattle(onRootNavigate, destination),
      onVictoryContinue: () =>
          _leaveBattle(onRootNavigate, BattlePrepRootDestination.adventure),
      onVictoryReplay: _resetBattle,
      onRewardedRetryRequested: () {
        _session.restartAfterSuccessfulRewardedAd();
      },
      onDefeatReturnToAdventure: () =>
          _leaveBattle(onRootNavigate, BattlePrepRootDestination.adventure),
      retiredBuilder: (_) => _RetiredBattleScreen(onRestart: _resetBattle),
    );
  }

  @override
  void dispose() {
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainShell(battleRootBuilder: _buildBattle);
  }
}

class _RetiredBattleScreen extends StatelessWidget {
  const _RetiredBattleScreen({required this.onRestart});

  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: FilledButton(
          onPressed: onRestart,
          child: const Text('Yeni Savaş Hazırlığı'),
        ),
      ),
    );
  }
}
