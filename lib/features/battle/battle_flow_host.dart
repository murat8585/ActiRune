import 'package:flutter/material.dart';

import 'battle_prep_screen.dart';
import 'battle_session_engine.dart';
import 'camera_prep_screen.dart';
import 'defeat_screen.dart';
import 'form_coach_screen.dart';
import 'live_battle_screen.dart';
import 'victory_screen.dart';

class BattleFlowHost extends StatelessWidget {
  const BattleFlowHost({
    super.key,
    required this.session,
    required this.cameraReadiness,
    this.cameraEnabled = true,
    this.onBattlePrepBack,
    this.onBattlePrepInfo,
    this.onEquipment,
    this.onRunes,
    this.onCompanion,
    this.onAbilities,
    this.onBattleTips,
    this.onCameraPrepOpened,
    this.onReturnToAdventure,
    this.onRootNavigate,
    this.onCameraPrepBack,
    this.onCameraPrepInfo,
    this.onCameraRecheck,
    this.onLiveBattleStarted,
    this.onFormCoachOpened,
    this.onLiveBattleResumed,
    this.onVictoryReached,
    this.onVictoryContinue,
    this.onVictoryReplay,
    this.onVictoryViewRewards,
    this.onRewardedRetryRequested,
    this.onDefeatReturnToAdventure,
    this.onDefeatViewTactics,
    this.retiredBuilder,
  });

  final BattleSessionEngine session;
  final CameraPrepReadiness cameraReadiness;
  final bool cameraEnabled;

  final VoidCallback? onBattlePrepBack;
  final VoidCallback? onBattlePrepInfo;
  final VoidCallback? onEquipment;
  final VoidCallback? onRunes;
  final VoidCallback? onCompanion;
  final VoidCallback? onAbilities;
  final VoidCallback? onBattleTips;
  final VoidCallback? onCameraPrepOpened;
  final VoidCallback? onReturnToAdventure;
  final ValueChanged<BattlePrepRootDestination>? onRootNavigate;

  final VoidCallback? onCameraPrepBack;
  final VoidCallback? onCameraPrepInfo;
  final VoidCallback? onCameraRecheck;
  final VoidCallback? onLiveBattleStarted;

  final VoidCallback? onFormCoachOpened;
  final VoidCallback? onLiveBattleResumed;
  final VoidCallback? onVictoryReached;

  final VoidCallback? onVictoryContinue;
  final VoidCallback? onVictoryReplay;
  final VoidCallback? onVictoryViewRewards;

  final VoidCallback? onRewardedRetryRequested;
  final VoidCallback? onDefeatReturnToAdventure;
  final VoidCallback? onDefeatViewTactics;

  final WidgetBuilder? retiredBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: session,
      builder: (context, _) {
        return switch (session.snapshot.phase) {
          BattleSessionPhase.battlePrep => BattlePrepScreen(
            session: session,
            onBack: onBattlePrepBack ?? _noop,
            onInfo: onBattlePrepInfo ?? _noop,
            onEquipment: onEquipment ?? _noop,
            onRunes: onRunes ?? _noop,
            onCompanion: onCompanion ?? _noop,
            onAbilities: onAbilities ?? _noop,
            onBattleTips: onBattleTips ?? _noop,
            onOpenCameraPrep: onCameraPrepOpened ?? _noop,
            onReturnToAdventure: onReturnToAdventure ?? _noop,
            onRootNavigate: onRootNavigate ?? _noopRootNavigation,
          ),
          BattleSessionPhase.cameraPrep => CameraPrepScreen(
            session: session,
            readiness: cameraReadiness,
            onBack: onCameraPrepBack ?? _noop,
            onInfo: onCameraPrepInfo ?? _noop,
            onRecheck: onCameraRecheck ?? _noop,
            onStartLiveBattle: onLiveBattleStarted ?? _noop,
          ),
          BattleSessionPhase.liveBattle ||
          BattleSessionPhase.formCoach => IndexedStack(
            index: session.snapshot.phase == BattleSessionPhase.formCoach
                ? 1
                : 0,
            children: [
              LiveBattleScreen(
                key: const ValueKey('battle-flow.live-battle'),
                session: session,
                cameraEnabled: cameraEnabled,
                onOpenFormCoach: onFormCoachOpened ?? _noop,
                onVictory: onVictoryReached ?? _noop,
              ),
              FormCoachScreen(
                key: const ValueKey('battle-flow.form-coach'),
                session: session,
                onResumeBattle: onLiveBattleResumed ?? _noop,
              ),
            ],
          ),
          BattleSessionPhase.victory => VictoryScreen(
            onContinue: onVictoryContinue ?? _noop,
            onReplay: onVictoryReplay ?? _noop,
            onViewRewards: onVictoryViewRewards ?? _noop,
          ),
          BattleSessionPhase.defeat => DefeatScreen(
            session: session,
            onRewardedRetryRequested: onRewardedRetryRequested ?? _noop,
            onReturnToAdventure: onDefeatReturnToAdventure ?? _noop,
            onViewTactics: onDefeatViewTactics ?? _noop,
          ),
          BattleSessionPhase.retired =>
            retiredBuilder?.call(context) ?? const SizedBox.expand(),
        };
      },
    );
  }
}

void _noop() {}

void _noopRootNavigation(BattlePrepRootDestination _) {}
