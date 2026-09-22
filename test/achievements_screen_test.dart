import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/profile/achievements_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onBack,
    VoidCallback? onNotifications,
    VoidCallback? onShowInProfile,
    ValueChanged<AchievementFilter>? onFilterChanged,
    ValueChanged<AchievementsRootDestination>? onRootNavigate,
    bool battleRootEnabled = true,
  }) {
    return MaterialApp(
      home: AchievementsScreen(
        onBack: onBack,
        onNotifications: onNotifications,
        onShowInProfile: onShowInProfile,
        onFilterChanged: onFilterChanged,
        onRootNavigate: onRootNavigate,
        battleRootEnabled: battleRootEnabled,
      ),
    );
  }

  testWidgets('Achievements renders canonical artwork and category hotspots', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, AchievementsScreen.artworkAsset);
    expect(surface.sourceSize, AchievementsScreen.artworkSize);
    expect(AchievementsScreen.artworkSize, const Size(941, 1672));

    for (final filter in AchievementFilter.values) {
      expect(
        find.byKey(
          ValueKey('artwork-hotspot-achievements.filter-${filter.name}'),
        ),
        findsOneWidget,
      );
    }
  });

  testWidgets('screen filter Savaş is independent from root Savaş', (
    tester,
  ) async {
    AchievementFilter? selected;
    AchievementsRootDestination? routed;

    await tester.pumpWidget(
      buildSubject(
        onFilterChanged: (value) => selected = value,
        onRootNavigate: (value) => routed = value,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-achievements.filter-battle')),
    );
    await tester.pump();

    expect(selected, AchievementFilter.battle);
    expect(routed, isNull);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-achievements.nav-battle')),
    );
    await tester.pump();

    expect(routed, AchievementsRootDestination.battle);
  });

  testWidgets('Profile and notification actions dispatch independently', (
    tester,
  ) async {
    var profileCount = 0;
    var notificationCount = 0;

    await tester.pumpWidget(
      buildSubject(
        onShowInProfile: () => profileCount++,
        onNotifications: () => notificationCount++,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-achievements.show-in-profile'),
      ),
    );
    await tester.pump();
    expect(profileCount, 1);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-achievements.notifications')),
    );
    await tester.pump();
    expect(notificationCount, 1);
  });

  testWidgets('Battle root remains disabled without a battle owner', (
    tester,
  ) async {
    AchievementsRootDestination? routed;
    await tester.pumpWidget(
      buildSubject(
        battleRootEnabled: false,
        onRootNavigate: (value) => routed = value,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-achievements.nav-battle')),
      warnIfMissed: false,
    );
    await tester.pump();

    expect(routed, isNull);
  });
}
