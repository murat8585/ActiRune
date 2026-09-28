import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/home/home_screen.dart';
import 'package:actirune/features/quests/daily_quests_screen.dart';
import 'package:actirune/features/quests/quests_screen.dart';
import 'package:actirune/features/quests/weekly_quests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home quests opens Quest Center before Daily or Weekly children', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pump();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(QuestsScreen), findsNothing);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.quests')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(QuestsScreen), findsOneWidget);
    expect(find.byType(DailyQuestsScreen), findsNothing);
    expect(find.byType(WeeklyQuestsScreen), findsNothing);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-quests.daily')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(DailyQuestsScreen), findsOneWidget);

    Navigator.of(tester.element(find.byType(DailyQuestsScreen))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(QuestsScreen), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-quests.weekly')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(WeeklyQuestsScreen), findsOneWidget);
  });
}
