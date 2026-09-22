import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:actirune/features/battle/form_coach_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  BattleSessionEngine formCoachSession() {
    final session = BattleSessionEngine();
    session.startLiveBattle();
    session.acceptVerifiedMovement(VerifiedMovementType.squat);
    session.openFormCoach();
    return session;
  }

  Widget buildSubject({
    required BattleSessionEngine session,
    VoidCallback? onResumeBattle,
  }) {
    return MaterialApp(
      home: FormCoachScreen(
        session: session,
        onResumeBattle: onResumeBattle ?? () {},
      ),
    );
  }

  Future<void> settleArtwork(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }

  testWidgets('Form Coach exposes only authoritative active hotspots', (
    tester,
  ) async {
    final session = formCoachSession();
    await tester.pumpWidget(buildSubject(session: session));
    await settleArtwork(tester);

    expect(
      find.byKey(const ValueKey('artwork-hotspot-form-coach.pause')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-form-coach.rune-action')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-form-coach.guard-action')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-form-coach.potion-action')),
      findsOneWidget,
    );

    expect(
      find.byKey(const ValueKey('artwork-hotspot-form-coach.form-coach-panel')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-form-coach.depth-correction')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-form-coach.repetition-counter')),
      findsNothing,
    );
  });

  testWidgets('Form Coach keeps battle state and returns to same live session', (
    tester,
  ) async {
    final session = formCoachSession();
    var resumed = 0;
    final actionsBefore = session.snapshot.verifiedActionCount;

    await tester.pumpWidget(
      buildSubject(session: session, onResumeBattle: () => resumed++),
    );
    await settleArtwork(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-form-coach.pause')),
    );
    await tester.pump();

    expect(resumed, 1);
    expect(session.snapshot.phase, BattleSessionPhase.liveBattle);
    expect(session.snapshot.isPaused, isFalse);
    expect(session.snapshot.verifiedActionCount, actionsBefore);
  });

  testWidgets('Form Coach support controls emit typed requests only', (
    tester,
  ) async {
    final session = formCoachSession();
    await tester.pumpWidget(buildSubject(session: session));
    await settleArtwork(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-form-coach.rune-action')),
    );
    expect(session.snapshot.lastSupportAction, BattleSupportAction.runePower);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-form-coach.guard-action')),
    );
    expect(session.snapshot.lastSupportAction, BattleSupportAction.protection);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-form-coach.potion-action')),
    );
    expect(session.snapshot.lastSupportAction, BattleSupportAction.powerPotion);
    expect(session.snapshot.supportActionRequestCount, 3);

    expect(find.byType(ElevatedButton), findsNothing);
    expect(find.byType(FilledButton), findsNothing);
    expect(find.byType(OutlinedButton), findsNothing);
  });
}
