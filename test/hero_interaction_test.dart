import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/hero/hero_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onEquipment,
    VoidCallback? onRunes,
    VoidCallback? onAbilities,
    VoidCallback? onCompanion,
    VoidCallback? onCharacterStory,
    VoidCallback? onCompanionDetails,
    VoidCallback? onRuneDetails,
    VoidCallback? onDetailedStats,
    VoidCallback? onMovementMastery,
    ValueChanged<HeroRootDestination>? onRootNavigate,
    bool battleRootEnabled = true,
  }) {
    return MaterialApp(
      home: HeroScreen(
        onEquipment: onEquipment,
        onRunes: onRunes,
        onAbilities: onAbilities,
        onCompanion: onCompanion,
        onCharacterStory: onCharacterStory,
        onCompanionDetails: onCompanionDetails,
        onRuneDetails: onRuneDetails,
        onDetailedStats: onDetailedStats,
        onMovementMastery: onMovementMastery,
        onRootNavigate: onRootNavigate,
        battleRootEnabled: battleRootEnabled,
      ),
    );
  }

  testWidgets('Hero renders only the canonical 941x1672 final', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, HeroScreen.artworkAsset);
    expect(surface.sourceSize, HeroScreen.artworkSize);
    expect(HeroScreen.artworkSize, const Size(941, 1672));

    const authoritativeIds = [
      'hero.equipment',
      'hero.runes',
      'hero.abilities',
      'hero.companion',
      'hero.character-story',
      'hero.companion-details',
      'hero.rune-details',
      'hero.detailed-stats',
      'hero.movement-mastery',
      'hero.nav-home',
      'hero.nav-adventure',
      'hero.nav-battle',
      'hero.nav-hero',
      'hero.nav-profile',
    ];
    for (final id in authoritativeIds) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
    }
  });

  testWidgets('Hero visible actions dispatch through artwork hotspots', (
    tester,
  ) async {
    final counts = <String, int>{};
    void hit(String id) => counts[id] = (counts[id] ?? 0) + 1;

    await tester.pumpWidget(
      buildSubject(
        onEquipment: () => hit('equipment'),
        onRunes: () => hit('runes'),
        onAbilities: () => hit('abilities'),
        onCompanion: () => hit('companion'),
        onCharacterStory: () => hit('character-story'),
        onCompanionDetails: () => hit('companion-details'),
        onRuneDetails: () => hit('rune-details'),
        onDetailedStats: () => hit('detailed-stats'),
        onMovementMastery: () => hit('movement-mastery'),
      ),
    );
    await tester.pump();

    for (final entry in const {
      'hero.equipment': 'equipment',
      'hero.runes': 'runes',
      'hero.abilities': 'abilities',
      'hero.companion': 'companion',
      'hero.character-story': 'character-story',
      'hero.companion-details': 'companion-details',
      'hero.rune-details': 'rune-details',
      'hero.detailed-stats': 'detailed-stats',
      'hero.movement-mastery': 'movement-mastery',
    }.entries) {
      await tester.tap(find.byKey(ValueKey('artwork-hotspot-${entry.key}')));
      await tester.pump();
      expect(counts[entry.value], 1);
    }
  });

  testWidgets('Hero root artwork dispatches canonical destinations', (
    tester,
  ) async {
    for (final destination in HeroRootDestination.values) {
      HeroRootDestination? routed;
      await tester.pumpWidget(
        buildSubject(onRootNavigate: (value) => routed = value),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(ValueKey('artwork-hotspot-hero.nav-${destination.name}')),
      );
      await tester.pump();

      expect(routed, destination);
    }
  });

  testWidgets('Hero Battle hotspot is inert when no real battle root exists', (
    tester,
  ) async {
    HeroRootDestination? routed;
    await tester.pumpWidget(
      buildSubject(
        onRootNavigate: (value) => routed = value,
        battleRootEnabled: false,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-hero.nav-battle')),
    );
    await tester.pump();

    expect(routed, isNull);
  });
}
