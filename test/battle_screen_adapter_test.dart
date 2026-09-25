import 'package:actirune/core/widgets/feature_unavailable_dialog.dart';
import 'package:actirune/features/battle/battle_flow_host.dart';
import 'package:actirune/features/battle/battle_prep_screen.dart';
import 'package:actirune/features/battle/battle_screen.dart';
import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:actirune/features/battle/camera_prep_screen.dart';
import 'package:actirune/features/battle/form_coach_screen.dart';
import 'package:actirune/features/battle/live_battle_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    CameraPrepReadiness readiness = CameraPrepReadiness.checking,
    VoidCallback? onExitEncounter,
  }) {
    return MaterialApp(
      home: BattleScreen(
        movement: VerifiedMovementType.squat,
        cameraReadiness: readiness,
        cameraEnabled: false,
        onExitEncounter: onExitEncounter,
      ),
    );
  }

  testWidgets(
    'BattleScreen is a canonical host adapter with safe checking readiness',
    (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(BattleFlowHost), findsOneWidget);
      expect(find.byType(BattlePrepScreen), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-battle-prep.start')),
      );
      await tester.pump();

      expect(find.byType(CameraPrepScreen), findsOneWidget);
      expect(find.text('Kontrol Ediliyor'), findsNWidgets(5));
      expect(
        find.byKey(
          const ValueKey('artwork-overlay-camera-prep.ready-disabled'),
        ),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-camera-prep.ready')),
      );
      await tester.pump();
      expect(find.byType(CameraPrepScreen), findsOneWidget);
      expect(find.byType(LiveBattleScreen), findsNothing);
    },
  );

  testWidgets(
    'verified readiness advances adapter to Live Battle and Form Coach',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(readiness: CameraPrepReadiness.ready),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-battle-prep.start')),
      );
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-camera-prep.ready')),
      );
      await tester.pump();

      expect(find.byType(LiveBattleScreen), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-live-battle.pause')),
      );
      await tester.pump();
      expect(find.byType(FormCoachScreen), findsOneWidget);
    },
  );

  testWidgets('Battle Prep exit retires the adapter and calls its owner', (
    tester,
  ) async {
    var exits = 0;
    await tester.pumpWidget(buildSubject(onExitEncounter: () => exits++));
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-battle-prep.back')),
    );
    await tester.pump();

    expect(exits, 1);
    expect(find.byType(BattlePrepScreen), findsNothing);
  });

  testWidgets(
    'unowned Battle Prep controls fail closed with visible feedback',
    (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-battle-prep.equipment')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FeatureUnavailableDialog), findsOneWidget);
      expect(find.text('Savaş Ekipmanı'), findsOneWidget);
    },
  );
}
