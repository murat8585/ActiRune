import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:actirune/features/battle/defeat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  BattleSessionEngine defeatedSession({int remainingRetries = 3}) {
    final session = BattleSessionEngine();
    for (var remaining = 3; remaining > remainingRetries; remaining--) {
      session.markDefeat();
      final restarted = session.restartAfterSuccessfulRewardedAd();
      if (!restarted) {
        throw StateError('Could not prepare rewarded retry fixture.');
      }
    }
    session.markDefeat();
    return session;
  }

  Widget buildSubject({
    required BattleSessionEngine session,
    VoidCallback? onRewardedRetryRequested,
    VoidCallback? onReturnToAdventure,
    VoidCallback? onViewTactics,
  }) {
    return MaterialApp(
      home: DefeatScreen(
        session: session,
        onRewardedRetryRequested: onRewardedRetryRequested ?? () {},
        onReturnToAdventure: onReturnToAdventure ?? () {},
        onViewTactics: onViewTactics ?? () {},
      ),
    );
  }

  testWidgets('Defeat exposes only the three authoritative artwork CTAs', (
    tester,
  ) async {
    final session = defeatedSession();
    await tester.pumpWidget(buildSubject(session: session));
    await tester.pump();

    expect(
      find.byKey(const ValueKey('artwork-hotspot-defeat.rewarded-retry')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-defeat.return-adventure')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-defeat.view-tactics')),
      findsOneWidget,
    );

    expect(
      find.byKey(const ValueKey('artwork-hotspot-defeat.result-panel')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-defeat.retry-info')),
      findsNothing,
    );
  });

  testWidgets('requesting an ad does not consume a retry before success', (
    tester,
  ) async {
    final session = defeatedSession();
    var requested = 0;

    await tester.pumpWidget(
      buildSubject(
        session: session,
        onRewardedRetryRequested: () => requested++,
      ),
    );
    await tester.pump();

    expect(find.text('3 / 3'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-defeat.rewarded-retry')),
    );
    await tester.pump();

    expect(requested, 1);
    expect(session.snapshot.rewardedRetriesRemaining, 3);
    expect(session.snapshot.phase, BattleSessionPhase.defeat);
  });

  testWidgets('retry counter follows successful rewarded-ad state', (
    tester,
  ) async {
    final session = defeatedSession(remainingRetries: 2);
    await tester.pumpWidget(buildSubject(session: session));
    await tester.pump();

    expect(find.text('2 / 3'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('artwork-overlay-defeat.retry-disabled')),
      findsNothing,
    );
  });

  testWidgets('zero retries disables and dims rewarded retry CTA', (
    tester,
  ) async {
    final session = defeatedSession(remainingRetries: 0);
    var requested = 0;

    await tester.pumpWidget(
      buildSubject(
        session: session,
        onRewardedRetryRequested: () => requested++,
      ),
    );
    await tester.pump();

    expect(find.text('0 / 3'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('artwork-overlay-defeat.retry-disabled')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-defeat.rewarded-retry')),
      warnIfMissed: false,
    );
    await tester.pump();

    expect(requested, 0);
    expect(session.snapshot.rewardedRetriesRemaining, 0);
  });

  testWidgets('secondary Defeat callbacks remain available at zero retries', (
    tester,
  ) async {
    final session = defeatedSession(remainingRetries: 0);
    var returned = 0;
    var tactics = 0;

    await tester.pumpWidget(
      buildSubject(
        session: session,
        onReturnToAdventure: () => returned++,
        onViewTactics: () => tactics++,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-defeat.return-adventure')),
    );
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-defeat.view-tactics')),
    );

    expect(returned, 1);
    expect(tactics, 1);
  });

  testWidgets('Defeat does not add duplicate Flutter buttons or bottom nav', (
    tester,
  ) async {
    final session = defeatedSession();
    await tester.pumpWidget(buildSubject(session: session));
    await tester.pump();

    expect(find.byType(ElevatedButton), findsNothing);
    expect(find.byType(FilledButton), findsNothing);
    expect(find.byType(OutlinedButton), findsNothing);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byType(BottomNavigationBar), findsNothing);
  });
}
