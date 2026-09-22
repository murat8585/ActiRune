import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/adventure/adventure_screen.dart';
import 'package:actirune/features/quests/daily_quests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home Daily Streak opens exact Daily Quests artwork', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.daily-streak')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DailyQuestsScreen), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('Daily root navigation closes child route and selects root', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.daily-streak')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(DailyQuestsScreen), findsOneWidget);

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-daily-quests.nav-adventure'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DailyQuestsScreen), findsNothing);
    expect(find.byType(AdventureScreen), findsOneWidget);
  });
}
