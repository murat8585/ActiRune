import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:actirune/features/battle/camera_prep_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const notReady = CameraPrepReadiness(
    camera: CameraPrepCheckStatus(
      state: CameraPrepCheckState.ready,
      label: 'Hazır',
    ),
    fullBody: CameraPrepCheckStatus(
      state: CameraPrepCheckState.checking,
      label: 'Kontrol Ediliyor',
    ),
    lighting: CameraPrepCheckStatus(
      state: CameraPrepCheckState.warning,
      label: 'Yetersiz Işık',
    ),
    space: CameraPrepCheckStatus(
      state: CameraPrepCheckState.warning,
      label: 'Biraz Geri Çekil',
    ),
    poseDetection: CameraPrepCheckStatus(
      state: CameraPrepCheckState.warning,
      label: 'Alanı Boşalt',
    ),
  );

  BattleSessionEngine cameraPrepSession() {
    final session = BattleSessionEngine();
    session.prepare(VerifiedMovementType.squat);
    session.enterCameraPrep();
    return session;
  }

  Widget buildSubject({
    required BattleSessionEngine session,
    required CameraPrepReadiness readiness,
    VoidCallback? onBack,
    VoidCallback? onInfo,
    VoidCallback? onRecheck,
    VoidCallback? onStartLiveBattle,
  }) {
    return MaterialApp(
      home: CameraPrepScreen(
        session: session,
        readiness: readiness,
        onBack: onBack ?? () {},
        onInfo: onInfo ?? () {},
        onRecheck: onRecheck ?? () {},
        onStartLiveBattle: onStartLiveBattle ?? () {},
      ),
    );
  }

  testWidgets(
    'Camera Prep exposes runtime readiness without fake row hotspots',
    (tester) async {
      final session = cameraPrepSession();
      await tester.pumpWidget(
        buildSubject(session: session, readiness: notReady),
      );
      await tester.pump();

      for (final id in const [
        'camera',
        'full-body',
        'lighting',
        'space',
        'pose',
      ]) {
        expect(
          find.byKey(ValueKey('artwork-overlay-camera-prep.$id-status')),
          findsOneWidget,
        );
      }

      expect(find.text('Kontrol Ediliyor'), findsOneWidget);
      expect(find.text('Yetersiz Işık'), findsOneWidget);
      expect(find.text('Biraz Geri Çekil'), findsOneWidget);
      expect(find.text('Alanı Boşalt'), findsOneWidget);
      expect(
        find.byKey(
          const ValueKey('artwork-overlay-camera-prep.ready-disabled'),
        ),
        findsOneWidget,
      );

      for (final id in const [
        'camera-prep.back',
        'camera-prep.info',
        'camera-prep.ready',
        'camera-prep.recheck',
      ]) {
        expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
      }

      expect(
        find.byKey(const ValueKey('artwork-hotspot-camera-prep.camera-row')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('artwork-hotspot-camera-prep.lighting-row')),
        findsNothing,
      );
    },
  );

  testWidgets('HAZIRIM cannot start battle until every check is ready', (
    tester,
  ) async {
    final session = cameraPrepSession();
    var started = 0;
    await tester.pumpWidget(
      buildSubject(
        session: session,
        readiness: notReady,
        onStartLiveBattle: () => started++,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-camera-prep.ready')),
    );
    await tester.pump();
    expect(started, 0);
    expect(session.snapshot.phase, BattleSessionPhase.cameraPrep);

    await tester.pumpWidget(
      buildSubject(
        session: session,
        readiness: CameraPrepReadiness.ready,
        onStartLiveBattle: () => started++,
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey('artwork-overlay-camera-prep.ready-disabled')),
      findsNothing,
    );
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-camera-prep.ready')),
    );
    await tester.pump();

    expect(started, 1);
    expect(session.snapshot.phase, BattleSessionPhase.liveBattle);
  });

  testWidgets('Camera Prep back and recheck preserve authoritative state', (
    tester,
  ) async {
    final session = cameraPrepSession();
    var rechecked = 0;
    var backed = 0;
    await tester.pumpWidget(
      buildSubject(
        session: session,
        readiness: notReady,
        onBack: () => backed++,
        onRecheck: () => rechecked++,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-camera-prep.recheck')),
    );
    await tester.pump();
    expect(rechecked, 1);
    expect(session.snapshot.phase, BattleSessionPhase.cameraPrep);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-camera-prep.back')),
    );
    await tester.pump();
    expect(backed, 1);
    expect(session.snapshot.phase, BattleSessionPhase.battlePrep);
    expect(session.snapshot.preparedMovement, VerifiedMovementType.squat);
  });
}
