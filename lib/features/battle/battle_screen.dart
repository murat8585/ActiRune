import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/widgets/feature_unavailable_dialog.dart';
import 'battle_flow_host.dart';
import 'battle_encounter_definition.dart';
import 'battle_prep_screen.dart';
import 'battle_session_engine.dart';
import 'camera_prep_screen.dart';
import 'combat/combat_engine.dart';

typedef BattleRewardedRetryRequest = Future<bool> Function();

/// Route-level adapter for one canonical PvE encounter.
///
/// The caller owns encounter selection and external navigation. This screen
/// owns exactly one [BattleSessionEngine] so battle state survives the
/// Battle Prep -> Camera Prep -> Live Battle <-> Form Coach -> Result flow.
class BattleScreen extends StatefulWidget {
  const BattleScreen({
    super.key,
    required this.encounter,
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

  final BattleEncounterDefinition encounter;
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
  late final CombatEngine _combat;

  @override
  void initState() {
    super.initState();
    _session = BattleSessionEngine()..prepare(widget.encounter.movement);
    _combat = CombatEngine(
      bossMaxHp: widget.encounter.enemyMaxHp,
      damagePerVerifiedRep: widget.encounter.damagePerVerifiedRep,
    );
  }

  @override
  void dispose() {
    _session.dispose();
    _combat.dispose();
    super.dispose();
  }

  void _showUnavailable(String feature, {String? message}) {
    unawaited(
      FeatureUnavailableDialog.show(
        context,
        feature: feature,
        message: message,
      ),
    );
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
    if (request == null) {
      _showUnavailable(
        'Son Bir Şans',
        message: 'Ödüllü tekrar sahibi bağlanmadan yeni savaş hakkı verilemez.',
      );
      return;
    }

    final rewarded = await request();
    if (!mounted || !rewarded) return;

    if (_session.restartAfterSuccessfulRewardedAd()) _combat.reset();
  }

  @override
  Widget build(BuildContext context) {
    return BattleFlowHost(
      session: _session,
      combat: _combat,
      cameraReadiness: widget.cameraReadiness,
      cameraEnabled: widget.cameraEnabled,
      requiredPlankHoldDuration: widget.requiredPlankHoldDuration,
      onBattlePrepBack: _exitEncounter,
      onBattlePrepInfo:
          widget.onBattlePrepInfo ??
          () => _showUnavailable('Savaş Hazırlığı Bilgisi'),
      onEquipment:
          widget.onEquipment ?? () => _showUnavailable('Savaş Ekipmanı'),
      onRunes: widget.onRunes ?? () => _showUnavailable('Savaş Runeleri'),
      onCompanion:
          widget.onCompanion ?? () => _showUnavailable('Savaş Yoldaşı'),
      onAbilities:
          widget.onAbilities ?? () => _showUnavailable('Savaş Yetenekleri'),
      onBattleTips:
          widget.onBattleTips ?? () => _showUnavailable('Savaş İpuçları'),
      onReturnToAdventure: _exitEncounter,
      onRootNavigate: _rootNavigate,
      onCameraPrepInfo:
          widget.onCameraPrepInfo ??
          () => _showUnavailable('Kamera Hazırlığı Bilgisi'),
      onCameraRecheck:
          widget.onCameraRecheck ??
          () => _showUnavailable(
            'Kamera Yeniden Kontrol',
            message:
                'Gerçek kamera hazırlık sahibi bağlanmadan yeniden kontrol başlatılamaz.',
          ),
      onVictoryContinue: _exitEncounter,
      onVictoryReplay:
          widget.onVictoryReplay ??
          () => _showUnavailable(
            'Tekrar Savaş',
            message:
                'Karşılaşma sahibi yeni savaş oturumunu sağlamadan tekrar başlatılamaz.',
          ),
      onVictoryViewRewards:
          widget.onVictoryViewRewards ??
          () => _showUnavailable('Savaş Ödülleri'),
      onRewardedRetryRequested: () {
        unawaited(_requestRewardedRetry());
      },
      onDefeatReturnToAdventure: _exitEncounter,
      onDefeatViewTactics:
          widget.onDefeatViewTactics ??
          () => _showUnavailable('Savaş Taktikleri'),
    );
  }
}
