import 'package:actirune/features/quests/quests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    required VoidCallback onDaily,
    required VoidCallback onWeekly,
    ValueChanged<QuestsRootDestination>? onRootNavigate,
    bool battleRootEnabled = true,
  }) {
    return MaterialApp(
      home: QuestsScreen(
        onDailyQuests: onDaily,
        onWeeklyQuests: onWeekly,
        onRootNavigate: onRootNavigate,
        battleRootEnabled: battleRootEnabled,
      ),
    );
  }

  testWidgets('Daily and Weekly tabs expose only parent navigation actions', (
    tester,
  ) async {
    var daily = 0;
    var weekly = 0;

    await tester.pumpWidget(
      buildSubject(
        onDaily: () => daily++,
        onWeekly: () => weekly++,
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('artwork-hotspot-quests.daily')));
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-quests.weekly')),
    );

    expect(daily, 1);
    expect(weekly, 1);
  });

  testWidgets('root navigation preserves fail-closed Battle availability', (
    tester,
  ) async {
    QuestsRootDestination? destination;

    await tester.pumpWidget(
      buildSubject(
        onDaily: () {},
        onWeekly: () {},
        onRootNavigate: (next) => destination = next,
        battleRootEnabled: false,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-quests.nav-home')),
    );
    expect(destination, QuestsRootDestination.home);

    destination = null;
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-quests.nav-battle')),
      warnIfMissed: false,
    );
    expect(destination, isNull);
  });
}
