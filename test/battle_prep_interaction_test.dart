import 'package:actirune/features/battle/battle_prep_screen.dart';
import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    required BattleSessionEngine session,
    VoidCallback? onBack,
    VoidCallback? onInfo,
    VoidCallback? onEquipment,
    VoidCallback? onRunes,
    VoidCallback? onCompanion,
    VoidCallback? onAbilities,
    VoidCallback? onBattleTips,
    VoidCallback? onOpenCameraPrep,
    VoidCallback? onReturnToAdventure,
    ValueChanged<BattlePrepRootDestination>? onRootNavigate,
  }) {
    return MaterialApp(
      home: BattlePrepScreen(
        session: session,
        onBack: onBack ?? () {},
        onInfo: onInfo ?? () {},
        onEquipment: onEquipment ?? () {},
        onRunes: onRunes ?? () {},
        onCompanion: onCompanion ?? () {},
        onAbilities: onAbilities ?? () {},
        onBattleTips: onBattleTips ?? () {},
        onOpenCameraPrep: onOpenCameraPrep ?? () {},
        onReturnToAdventure: onReturnToAdventure ?? () {},
        onRootNavigate: onRootNavigate ?? (_) {},
      ),
    );
  }

  testWidgets('Battle Prep exposes only authoritative artwork hotspots', (
    tester,
  ) async {
    final session = BattleSessionEngine()..prepare(VerifiedMovementType.lunge);
    await tester.pumpWidget(buildSubject(session: session));
    await tester.pump();

    const activeIds = [
      'battle-prep.back',
      'battle-prep.info',
      'battle-prep.equipment',
      'battle-prep.runes',
      'battle-prep.companion',
      'battle-prep.abilities',
      'battle-prep.tips',
      'battle-prep.start',
      'battle-prep.return-adventure',
      'battle-prep.nav-home',
      'battle-prep.nav-adventure',
      'battle-prep.nav-battle',
      'battle-prep.nav-hero',
      'battle-prep.nav-profile',
    ];
    for (final id in activeIds) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
    }

    expect(
      find.byKey(const ValueKey('artwork-hotspot-battle-prep.hero-card')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-battle-prep.lumi-card')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-battle-prep.strategy')),
      findsNothing,
    );
  });

  testWidgets('Battle Prep shortcuts dispatch without inventing game state', (
    tester,
  ) async {
    final session = BattleSessionEngine()..prepare(VerifiedMovementType.pushUp);
    final counts = <String, int>{};
    void hit(String id) => counts[id] = (counts[id] ?? 0) + 1;

    await tester.pumpWidget(
      buildSubject(
        session: session,
        onInfo: () => hit('info'),
        onEquipment: () => hit('equipment'),
        onRunes: () => hit('runes'),
        onCompanion: () => hit('companion'),
        onAbilities: () => hit('abilities'),
        onBattleTips: () => hit('tips'),
      ),
    );
    await tester.pump();

    for (final entry in const {
      'battle-prep.info': 'info',
      'battle-prep.equipment': 'equipment',
      'battle-prep.runes': 'runes',
      'battle-prep.companion': 'companion',
      'battle-prep.abilities': 'abilities',
      'battle-prep.tips': 'tips',
    }.entries) {
      await tester.tap(find.byKey(ValueKey('artwork-hotspot-${entry.key}')));
      await tester.pump();
      expect(counts[entry.value], 1);
    }

    expect(session.snapshot.phase, BattleSessionPhase.battlePrep);
    expect(session.snapshot.preparedMovement, VerifiedMovementType.pushUp);
  });

  testWidgets('SAVAŞA BAŞLA enters Camera Prep once', (tester) async {
    final session = BattleSessionEngine()..prepare(VerifiedMovementType.squat);
    var opened = 0;
    await tester.pumpWidget(
      buildSubject(session: session, onOpenCameraPrep: () => opened++),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-battle-prep.start')),
    );
    await tester.pump();

    expect(opened, 1);
    expect(session.snapshot.phase, BattleSessionPhase.cameraPrep);
    expect(session.snapshot.preparedMovement, VerifiedMovementType.squat);
  });

  testWidgets('Battle Prep exit controls retire the encounter before routing', (
    tester,
  ) async {
    for (final destination in BattlePrepRootDestination.values) {
      final session = BattleSessionEngine()
        ..prepare(VerifiedMovementType.plank);
      BattlePrepRootDestination? routed;
      await tester.pumpWidget(
        buildSubject(
          session: session,
          onRootNavigate: (value) => routed = value,
        ),
      );
      await tester.pump();

      final suffix = switch (destination) {
        BattlePrepRootDestination.home => 'home',
        BattlePrepRootDestination.adventure => 'adventure',
        BattlePrepRootDestination.battle => 'battle',
        BattlePrepRootDestination.hero => 'hero',
        BattlePrepRootDestination.profile => 'profile',
      };
      await tester.tap(
        find.byKey(ValueKey('artwork-hotspot-battle-prep.nav-$suffix')),
      );
      await tester.pump();

      expect(routed, destination);
      expect(session.snapshot.phase, BattleSessionPhase.retired);
    }
  });
}
