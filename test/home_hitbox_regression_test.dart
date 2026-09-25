import 'package:actirune/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home hotspots stay at least 44x44 logical pixels on phone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          onDailyStreak: () {},
          onMessages: () {},
          onQuests: () {},
          onEvents: () {},
          onSettings: () {},
          onWorldMap: () {},
          onYesterdaySummary: () {},
          onRewards: () {},
          onRootNavigate: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    const ids = <String>[
      'home.daily-streak',
      'home.messages',
      'home.quests',
      'home.events',
      'home.settings',
      'home.world-map',
      'home.yesterday-summary',
      'home.rewards',
      'home.nav-home',
      'home.nav-adventure',
      'home.nav-battle',
      'home.nav-hero',
      'home.nav-profile',
    ];

    for (final id in ids) {
      final finder = find.byKey(ValueKey<String>('artwork-hotspot-$id'));
      expect(finder, findsOneWidget, reason: 'Missing Home hotspot: $id');
      final size = tester.getSize(finder);
      expect(
        size.width,
        greaterThanOrEqualTo(44),
        reason: '$id width is only ${size.width}',
      );
      expect(
        size.height,
        greaterThanOrEqualTo(44),
        reason: '$id height is only ${size.height}',
      );
    }
  });
}
