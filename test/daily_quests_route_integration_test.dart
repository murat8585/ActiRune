import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/home/daily_streak_preview_screen.dart';
import 'package:actirune/features/home/home_screen.dart';
import 'package:actirune/features/quests/daily_quests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Home Daily Streak stays truthful until the real streak owner exists',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainShell()));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-home.daily-streak')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DailyStreakPreviewScreen), findsOneWidget);
      expect(find.byType(DailyQuestsScreen), findsNothing);

      await tester.tap(find.byKey(const ValueKey('daily-streak-preview-back')));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    },
  );
}
