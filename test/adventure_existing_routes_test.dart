import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/home/events_screen.dart';
import 'package:actirune/features/profile/settings_hub_screen.dart';
import 'package:actirune/features/quests/daily_quests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> openAdventure(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.nav-adventure')),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Adventure Daily Streak opens Daily Quests', (tester) async {
    await openAdventure(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-adventure.daily-streak')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DailyQuestsScreen), findsOneWidget);
  });

  testWidgets('Adventure Events opens Events', (tester) async {
    await openAdventure(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-adventure.events')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EventsScreen), findsOneWidget);
  });

  testWidgets('Adventure Settings opens canonical Settings Hub', (tester) async {
    await openAdventure(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-adventure.settings')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SettingsHubScreen), findsOneWidget);
  });
}
