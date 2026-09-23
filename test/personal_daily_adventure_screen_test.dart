import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/adventure/personal_daily_adventure_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onNotifications,
    VoidCallback? onSettings,
    ValueChanged<PersonalDailyAdventureDuration>? onDurationSelected,
    VoidCallback? onStartAdventure,
    VoidCallback? onViewPlan,
    ValueChanged<PersonalDailyAdventureRootDestination>? onRootNavigate,
    bool battleRootEnabled = true,
  }) {
    return MaterialApp(
      home: PersonalDailyAdventureScreen(
        onNotifications: onNotifications,
        onSettings: onSettings,
        onDurationSelected: onDurationSelected,
        onStartAdventure: onStartAdventure,
        onViewPlan: onViewPlan,
        onRootNavigate: onRootNavigate,
        battleRootEnabled: battleRootEnabled,
      ),
    );
  }

  testWidgets(
    'Personal Daily Adventure renders canonical exact artwork shell',
    (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final surface = tester.widget<ArtworkInteractionSurface>(
        find.byType(ArtworkInteractionSurface),
      );
      expect(surface.assetPath, PersonalDailyAdventureScreen.artworkAsset);
      expect(surface.sourceSize, PersonalDailyAdventureScreen.artworkSize);
      expect(PersonalDailyAdventureScreen.artworkSize, const Size(941, 1672));

      for (final id in [
        'personal-daily.notifications',
        'personal-daily.settings',
        'personal-daily.duration-quick15',
        'personal-daily.duration-standard30',
        'personal-daily.duration-deep45',
        'personal-daily.start',
        'personal-daily.view-plan',
        'personal-daily.nav-home',
        'personal-daily.nav-adventure',
        'personal-daily.nav-battle',
        'personal-daily.nav-hero',
        'personal-daily.nav-profile',
      ]) {
        expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
      }
    },
  );

  testWidgets('duration choices dispatch only to the owning engine', (
    tester,
  ) async {
    final selected = <PersonalDailyAdventureDuration>[];

    await tester.pumpWidget(buildSubject(onDurationSelected: selected.add));
    await tester.pumpAndSettle();

    for (final entry in [
      ('quick15', PersonalDailyAdventureDuration.quick15),
      ('standard30', PersonalDailyAdventureDuration.standard30),
      ('deep45', PersonalDailyAdventureDuration.deep45),
    ]) {
      await tester.tap(
        find.byKey(
          ValueKey('artwork-hotspot-personal-daily.duration-${entry.$1}'),
        ),
      );
      await tester.pump();
    }

    expect(selected, [
      PersonalDailyAdventureDuration.quick15,
      PersonalDailyAdventureDuration.standard30,
      PersonalDailyAdventureDuration.deep45,
    ]);
  });

  testWidgets('start and plan actions remain independent callbacks', (
    tester,
  ) async {
    var startCount = 0;
    var planCount = 0;

    await tester.pumpWidget(
      buildSubject(
        onStartAdventure: () => startCount++,
        onViewPlan: () => planCount++,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-personal-daily.start')),
    );
    await tester.pump();
    expect(startCount, 1);
    expect(planCount, 0);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-personal-daily.view-plan')),
    );
    await tester.pump();
    expect(startCount, 1);
    expect(planCount, 1);
  });

  testWidgets('top actions and root navigation dispatch without fake state', (
    tester,
  ) async {
    var notificationCount = 0;
    var settingsCount = 0;
    final roots = <PersonalDailyAdventureRootDestination>[];

    await tester.pumpWidget(
      buildSubject(
        onNotifications: () => notificationCount++,
        onSettings: () => settingsCount++,
        onRootNavigate: roots.add,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-personal-daily.notifications'),
      ),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-personal-daily.settings')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-personal-daily.nav-adventure'),
      ),
    );
    await tester.pump();

    expect(notificationCount, 1);
    expect(settingsCount, 1);
    expect(roots, [PersonalDailyAdventureRootDestination.adventure]);
  });

  testWidgets('battle root is inert when no real battle owner exists', (
    tester,
  ) async {
    final roots = <PersonalDailyAdventureRootDestination>[];

    await tester.pumpWidget(
      buildSubject(onRootNavigate: roots.add, battleRootEnabled: false),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-personal-daily.nav-battle')),
    );
    await tester.pump();

    expect(roots, isEmpty);
  });
}
