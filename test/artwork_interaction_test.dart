import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:actirune/features/battle/live_battle_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    required BattleSessionEngine session,
    VoidCallback? onOpenFormCoach,
    VoidCallback? onVictory,
  }) {
    return MaterialApp(
      home: LiveBattleScreen(
        session: session,
        cameraEnabled: false,
        onOpenFormCoach: onOpenFormCoach ?? () {},
        onVictory: onVictory ?? () {},
      ),
    );
  }

  testWidgets('Live Battle exposes canonical transparent artwork hotspots', (
    tester,
  ) async {
    final session = BattleSessionEngine();
    await tester.pumpWidget(buildSubject(session: session));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('artwork-hotspot-live-battle.pause')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-live-battle.rune-power')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-live-battle.protection')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-live-battle.health-potion')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-live-battle.battle-continue')),
      findsOneWidget,
    );

    expect(
      find.byKey(const ValueKey('artwork-hotspot-live-battle.combo-series')),
      findsNothing,
      reason: 'Combo series has no authoritative tap behavior.',
    );
  });

  testWidgets('pause hotspot opens Form Coach and pauses the same session', (
    tester,
  ) async {
    final session = BattleSessionEngine();
    var opened = 0;
    await tester.pumpWidget(
      buildSubject(
        session: session,
        onOpenFormCoach: () => opened++,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-live-battle.pause')),
    );
    await tester.pump();

    expect(opened, 1);
    expect(session.snapshot.phase, BattleSessionPhase.formCoach);
    expect(session.snapshot.isPaused, isTrue);
  });

  testWidgets('support cards dispatch typed requests without duplicate UI', (
    tester,
  ) async {
    final session = BattleSessionEngine();
    await tester.pumpWidget(buildSubject(session: session));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-live-battle.rune-power')),
    );
    expect(session.snapshot.lastSupportAction, BattleSupportAction.runePower);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-live-battle.protection')),
    );
    expect(session.snapshot.lastSupportAction, BattleSupportAction.protection);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-live-battle.health-potion')),
    );
    expect(session.snapshot.lastSupportAction, BattleSupportAction.powerPotion);
    expect(session.snapshot.supportActionRequestCount, 3);

    expect(find.byType(ElevatedButton), findsNothing);
    expect(find.byType(FilledButton), findsNothing);
    expect(find.byType(OutlinedButton), findsNothing);
  });
}
