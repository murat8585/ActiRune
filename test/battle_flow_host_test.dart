import 'package:actirune/features/battle/battle_flow_host.dart';
import 'package:actirune/features/battle/battle_prep_screen.dart';
import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:actirune/features/battle/camera_prep_screen.dart';
import 'package:actirune/features/battle/combat/combat_engine.dart';
import 'package:actirune/features/battle/defeat_screen.dart';
import 'package:actirune/features/battle/form_coach_screen.dart';
import 'package:actirune/features/battle/live_battle_screen.dart';
import 'package:actirune/features/battle/victory_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    required BattleSessionEngine session,
    CameraPrepReadiness readiness = CameraPrepReadiness.ready,
    VoidCallback? onRewardedRetryRequested,
    VoidCallback? onDefeatReturnToAdventure,
    VoidCallback? onDefeatViewTactics,
    VoidCallback? onBattlePrepBack,
    WidgetBuilder? retiredBuilder,
  }) {
    return MaterialApp(
      home: BattleFlowHost(
        session: session,
        combat: CombatEngine(bossMaxHp: 1000, damagePerVerifiedRep: 100),
        cameraReadiness: readiness,
        cameraEnabled: false,
        onRewardedRetryRequested: onRewardedRetryRequested,
        onDefeatReturnToAdventure: onDefeatReturnToAdventure,
        onDefeatViewTactics: onDefeatViewTactics,
        onBattlePrepBack: onBattlePrepBack,
        retiredBuilder: retiredBuilder,
      ),
    );
  }

  testWidgets(
    'canonical battle phases render in order and preserve Live Battle state',
    (tester) async {
      final session = BattleSessionEngine();
      session.prepare(VerifiedMovementType.squat);

      await tester.pumpWidget(buildSubject(session: session));
      await tester.pump();
      expect(find.byType(BattlePrepScreen), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-battle-prep.start')),
      );
      await tester.pump();
      expect(session.snapshot.phase, BattleSessionPhase.cameraPrep);
      expect(find.byType(CameraPrepScreen), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-camera-prep.ready')),
      );
      await tester.pump();
      expect(session.snapshot.phase, BattleSessionPhase.liveBattle);
      expect(find.byType(LiveBattleScreen), findsOneWidget);

      final liveState = tester.state(find.byType(LiveBattleScreen));

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-live-battle.pause')),
      );
      await tester.pump();
      expect(session.snapshot.phase, BattleSessionPhase.formCoach);
      expect(find.byType(FormCoachScreen), findsOneWidget);
      expect(
        tester.state(find.byType(LiveBattleScreen, skipOffstage: false)),
        same(liveState),
        reason: 'Form Coach must not dispose and recreate active combat state.',
      );

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-form-coach.pause')),
      );
      await tester.pump();
      expect(session.snapshot.phase, BattleSessionPhase.liveBattle);
      expect(find.byType(LiveBattleScreen), findsOneWidget);
      expect(tester.state(find.byType(LiveBattleScreen)), same(liveState));

      session.markVictory();
      await tester.pump();
      expect(find.byType(VictoryScreen), findsOneWidget);
      expect(find.byType(LiveBattleScreen), findsNothing);
    },
  );

  testWidgets(
    'Defeat stays authoritative until a successful rewarded retry restarts it',
    (tester) async {
      final session = BattleSessionEngine();
      session.prepare(VerifiedMovementType.lunge);
      session.enterCameraPrep();
      session.startLiveBattle();
      session.markDefeat();

      var retryRequests = 0;
      var adventureRequests = 0;
      var tacticsRequests = 0;

      await tester.pumpWidget(
        buildSubject(
          session: session,
          onRewardedRetryRequested: () => retryRequests++,
          onDefeatReturnToAdventure: () => adventureRequests++,
          onDefeatViewTactics: () => tacticsRequests++,
        ),
      );
      await tester.pump();

      expect(find.byType(DefeatScreen), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-defeat.rewarded-retry')),
      );
      await tester.pump();
      expect(retryRequests, 1);
      expect(session.snapshot.phase, BattleSessionPhase.defeat);
      expect(session.snapshot.rewardedRetriesRemaining, 3);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-defeat.return-adventure')),
      );
      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-defeat.view-tactics')),
      );
      expect(adventureRequests, 1);
      expect(tacticsRequests, 1);

      expect(session.restartAfterSuccessfulRewardedAd(), isTrue);
      await tester.pump();
      expect(session.snapshot.phase, BattleSessionPhase.cameraPrep);
      expect(session.snapshot.rewardedRetriesRemaining, 2);
      expect(find.byType(CameraPrepScreen), findsOneWidget);
    },
  );

  testWidgets(
    'retired phase replaces Battle Prep after leaving the encounter',
    (tester) async {
      final session = BattleSessionEngine();
      session.prepare(VerifiedMovementType.plank);
      var backed = 0;

      await tester.pumpWidget(
        buildSubject(
          session: session,
          onBattlePrepBack: () => backed++,
          retiredBuilder: (_) => const Scaffold(body: Text('RETIRED')),
        ),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-battle-prep.back')),
      );
      await tester.pump();

      expect(backed, 1);
      expect(session.snapshot.phase, BattleSessionPhase.retired);
      expect(find.text('RETIRED'), findsOneWidget);
      expect(find.byType(BattlePrepScreen), findsNothing);
    },
  );
}
