import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/adventure/adventure_screen.dart';
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
    VoidCallback? onEncounterPreview,
    VoidCallback? onStory,
    VoidCallback? onAdventureLog,
    ValueChanged<AdventureRootDestination>? onRootNavigate,
  }) {
    return MaterialApp(
      home: AdventureScreen(
        onDailyStreak: onDailyStreak,
        onMessages: onMessages,
        onQuests: onQuests,
        onEvents: onEvents,
        onSettings: onSettings,
        onWorldMap: onWorldMap,
        onEncounterPreview: onEncounterPreview,
        onStory: onStory,
        onAdventureLog: onAdventureLog,
        onRootNavigate: onRootNavigate,
      ),
    );
  }

  testWidgets('Adventure renders only the locked 941x1672 anchor', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, AdventureScreen.artworkAsset);
    expect(surface.sourceSize, AdventureScreen.artworkSize);
    expect(AdventureScreen.artworkSize, const Size(941, 1672));

    const authoritativeIds = [
      'adventure.daily-streak',
      'adventure.messages',
      'adventure.quests',
      'adventure.events',
      'adventure.settings',
      'adventure.world-map',
      'adventure.encounter-preview',
      'adventure.story',
      'adventure.log',
      'adventure.nav-home',
      'adventure.nav-adventure',
      'adventure.nav-battle',
      'adventure.nav-hero',
      'adventure.nav-profile',
    ];
    for (final id in authoritativeIds) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
    }

    for (final id in const [
      'adventure.node-2000',
      'adventure.node-4000',
      'adventure.node-6000',
      'adventure.node-8000',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsNothing);
    }
  });

  testWidgets('Adventure visible controls dispatch without inventing state', (
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
        onEncounterPreview: () => hit('encounter-preview'),
        onStory: () => hit('story'),
        onAdventureLog: () => hit('log'),
      ),
    );
    await tester.pump();

    for (final entry in const {
      'adventure.daily-streak': 'daily-streak',
      'adventure.messages': 'messages',
      'adventure.quests': 'quests',
      'adventure.events': 'events',
      'adventure.settings': 'settings',
      'adventure.world-map': 'world-map',
      'adventure.encounter-preview': 'encounter-preview',
      'adventure.story': 'story',
      'adventure.log': 'log',
    }.entries) {
      await tester.tap(find.byKey(ValueKey('artwork-hotspot-${entry.key}')));
      await tester.pump();
      expect(counts[entry.value], 1);
    }
  });

  testWidgets('HAZIR OL remains an encounter preview boundary', (tester) async {
    var previewCount = 0;
    await tester.pumpWidget(
      buildSubject(onEncounterPreview: () => previewCount++),
    );
    await tester.pump();

    expect(find.text('SAVAŞ HAZIRLIĞI'), findsNothing);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-adventure.encounter-preview')),
    );
    await tester.pump();

    expect(previewCount, 1);
    expect(find.text('SAVAŞ HAZIRLIĞI'), findsNothing);
  });

  testWidgets('Adventure root artwork dispatches canonical destinations', (
    tester,
  ) async {
    for (final destination in AdventureRootDestination.values) {
      AdventureRootDestination? routed;
      await tester.pumpWidget(
        buildSubject(onRootNavigate: (value) => routed = value),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(
          ValueKey('artwork-hotspot-adventure.nav-${destination.name}'),
        ),
      );
      await tester.pump();

      expect(routed, destination);
    }
  });
}
