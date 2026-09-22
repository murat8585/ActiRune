import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/adventure/world_progression_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    bool bossUnlocked = false,
    VoidCallback? onBossPreview,
    VoidCallback? onShowNextTarget,
    VoidCallback? onRewardPreview,
    ValueChanged<WorldProgressionRootDestination>? onRootNavigate,
  }) {
    return MaterialApp(
      home: WorldProgressionScreen(
        bossUnlocked: bossUnlocked,
        onBossPreview: onBossPreview,
        onShowNextTarget: onShowNextTarget,
        onRewardPreview: onRewardPreview,
        onRootNavigate: onRootNavigate,
      ),
    );
  }

  testWidgets('World Progression uses canonical artwork and locked boss action', (
    tester,
  ) async {
    var bossTaps = 0;
    await tester.pumpWidget(
      buildSubject(
        onBossPreview: () => bossTaps++,
        onShowNextTarget: () {},
        onRewardPreview: () {},
      ),
    );
    await tester.pumpAndSettle();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, WorldProgressionScreen.artworkAsset);
    expect(surface.sourceSize, WorldProgressionScreen.artworkSize);
    expect(WorldProgressionScreen.artworkSize, const Size(941, 1672));

    final boss = find.byKey(
      const ValueKey('artwork-hotspot-world-progression.boss-preview'),
    );
    expect(boss, findsOneWidget);
    await tester.tap(boss, warnIfMissed: false);
    await tester.pump();
    expect(bossTaps, 0);
  });

  testWidgets('boss preview dispatches only after product unlock', (tester) async {
    var bossTaps = 0;
    await tester.pumpWidget(
      buildSubject(bossUnlocked: true, onBossPreview: () => bossTaps++),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-world-progression.boss-preview'),
      ),
    );
    await tester.pump();

    expect(bossTaps, 1);
  });

  testWidgets('safe authority-backed actions dispatch independently', (
    tester,
  ) async {
    var nextTarget = 0;
    var rewardPreview = 0;
    WorldProgressionRootDestination? routed;

    await tester.pumpWidget(
      buildSubject(
        onShowNextTarget: () => nextTarget++,
        onRewardPreview: () => rewardPreview++,
        onRootNavigate: (value) => routed = value,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-world-progression.show-next-target'),
      ),
    );
    await tester.pump();
    expect(nextTarget, 1);

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-world-progression.reward-preview'),
      ),
    );
    await tester.pump();
    expect(rewardPreview, 1);

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-world-progression.nav-home'),
      ),
    );
    await tester.pump();
    expect(routed, WorldProgressionRootDestination.home);
  });
}
