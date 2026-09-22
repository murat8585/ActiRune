import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onDailyStreak,
    VoidCallback? onMessages,
    VoidCallback? onQuests,
    VoidCallback? onEvents,
    VoidCallback? onSettings,
    VoidCallback? onWorldMap,
    VoidCallback? onYesterdaySummary,
    VoidCallback? onRewards,
    ValueChanged<HomeRootDestination>? onRootNavigate,
    bool battleRootEnabled = true,
  }) {
    return MaterialApp(
      home: HomeScreen(
        onDailyStreak: onDailyStreak,
        onMessages: onMessages,
        onQuests: onQuests,
        onEvents: onEvents,
        onSettings: onSettings,
        onWorldMap: onWorldMap,
        onYesterdaySummary: onYesterdaySummary,
        onRewards: onRewards,
        onRootNavigate: onRootNavigate,
        battleRootEnabled: battleRootEnabled,
      ),
    );
  }

  testWidgets('Home renders only the locked 941x1672 anchor', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, HomeScreen.artworkAsset);
    expect(surface.sourceSize, HomeScreen.artworkSize);
    expect(HomeScreen.artworkSize, const Size(941, 1672));

    const authoritativeIds = [
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
    for (final id in authoritativeIds) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
    }

    expect(find.text('SAVAŞA DEVAM ET'), findsNothing);
    expect(
      find.byKey(const ValueKey('artwork-hotspot-home.encounter-progress')),
      findsNothing,
    );
  });

  testWidgets('Home visible actions dispatch through artwork hotspots', (
    tester,
  ) async {
    final counts = <String, int>{};
    void hit(String id) => counts[id] = (counts[id] ?? 0) + 1;

    await tester.pumpWidget(
      buildSubject(
        onDailyStreak: () => hit('daily-streak'),
        onMessages: () => hit('messages'),
        onQuests: () => hit('quests'),
        onEvents: () => hit('events'),
        onSettings: () => hit('settings'),
        onWorldMap: () => hit('world-map'),
        onYesterdaySummary: () => hit('yesterday-summary'),
        onRewards: () => hit('rewards'),
      ),
    );
    await tester.pump();

    for (final entry in const {
      'home.daily-streak': 'daily-streak',
      'home.messages': 'messages',
      'home.quests': 'quests',
      'home.events': 'events',
      'home.settings': 'settings',
      'home.world-map': 'world-map',
      'home.yesterday-summary': 'yesterday-summary',
      'home.rewards': 'rewards',
    }.entries) {
      await tester.tap(find.byKey(ValueKey('artwork-hotspot-${entry.key}')));
      await tester.pump();
      expect(counts[entry.value], 1);
    }
  });

  testWidgets('Home root artwork dispatches canonical destinations', (
    tester,
  ) async {
    for (final destination in HomeRootDestination.values) {
      HomeRootDestination? routed;
      await tester.pumpWidget(
        buildSubject(onRootNavigate: (value) => routed = value),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(ValueKey('artwork-hotspot-home.nav-${destination.name}')),
      );
      await tester.pump();

      expect(routed, destination);
    }
  });

  testWidgets('Home Battle hotspot is inert when no real battle root exists', (
    tester,
  ) async {
    HomeRootDestination? routed;
    await tester.pumpWidget(
      buildSubject(
        onRootNavigate: (value) => routed = value,
        battleRootEnabled: false,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.nav-battle')),
    );
    await tester.pump();

    expect(routed, isNull);
  });
}
