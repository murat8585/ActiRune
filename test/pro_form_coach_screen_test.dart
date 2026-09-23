import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/profile/pro_form_coach_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onCrystalStore,
    VoidCallback? onGoldStore,
    VoidCallback? onNotifications,
    ValueChanged<ProFormMovement>? onMovementSelected,
    ValueChanged<ProFormTrendRange>? onTrendRangeSelected,
    ValueChanged<ProFormCoachRootDestination>? onRootNavigate,
    bool battleRootEnabled = true,
  }) {
    return MaterialApp(
      home: ProFormCoachScreen(
        onCrystalStore: onCrystalStore,
        onGoldStore: onGoldStore,
        onNotifications: onNotifications,
        onMovementSelected: onMovementSelected,
        onTrendRangeSelected: onTrendRangeSelected,
        onRootNavigate: onRootNavigate,
        battleRootEnabled: battleRootEnabled,
      ),
    );
  }

  testWidgets('Pro Form Coach renders canonical exact artwork shell', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, ProFormCoachScreen.artworkAsset);
    expect(surface.sourceSize, ProFormCoachScreen.artworkSize);
    expect(ProFormCoachScreen.artworkSize, const Size(941, 1672));

    for (final id in [
      'pro-form-coach.crystal-store',
      'pro-form-coach.gold-store',
      'pro-form-coach.notifications',
      'pro-form-coach.movement-squat',
      'pro-form-coach.movement-lunge',
      'pro-form-coach.movement-pushUp',
      'pro-form-coach.movement-plank',
      'pro-form-coach.range-sevenDays',
      'pro-form-coach.range-thirtyDays',
      'pro-form-coach.nav-home',
      'pro-form-coach.nav-adventure',
      'pro-form-coach.nav-battle',
      'pro-form-coach.nav-hero',
      'pro-form-coach.nav-profile',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
    }
  });

  testWidgets('movement selectors only dispatch to the analytics owner', (
    tester,
  ) async {
    final selected = <ProFormMovement>[];

    await tester.pumpWidget(buildSubject(onMovementSelected: selected.add));
    await tester.pumpAndSettle();

    for (final entry in [
      ('squat', ProFormMovement.squat),
      ('lunge', ProFormMovement.lunge),
      ('pushUp', ProFormMovement.pushUp),
      ('plank', ProFormMovement.plank),
    ]) {
      await tester.tap(
        find.byKey(
          ValueKey('artwork-hotspot-pro-form-coach.movement-${entry.$1}'),
        ),
      );
      await tester.pump();
    }

    expect(selected, [
      ProFormMovement.squat,
      ProFormMovement.lunge,
      ProFormMovement.pushUp,
      ProFormMovement.plank,
    ]);
  });

  testWidgets('trend ranges dispatch without fabricating analytics state', (
    tester,
  ) async {
    final selected = <ProFormTrendRange>[];

    await tester.pumpWidget(buildSubject(onTrendRangeSelected: selected.add));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-pro-form-coach.range-sevenDays'),
      ),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-pro-form-coach.range-thirtyDays'),
      ),
    );
    await tester.pump();

    expect(selected, [ProFormTrendRange.sevenDays, ProFormTrendRange.thirtyDays]);
  });

  testWidgets('top actions remain independent callbacks', (tester) async {
    var crystalCount = 0;
    var goldCount = 0;
    var notificationCount = 0;

    await tester.pumpWidget(
      buildSubject(
        onCrystalStore: () => crystalCount++,
        onGoldStore: () => goldCount++,
        onNotifications: () => notificationCount++,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-pro-form-coach.crystal-store'),
      ),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-pro-form-coach.gold-store')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-pro-form-coach.notifications'),
      ),
    );
    await tester.pump();

    expect(crystalCount, 1);
    expect(goldCount, 1);
    expect(notificationCount, 1);
  });

  testWidgets('root navigation dispatches through the owning shell', (
    tester,
  ) async {
    final roots = <ProFormCoachRootDestination>[];

    await tester.pumpWidget(buildSubject(onRootNavigate: roots.add));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-pro-form-coach.nav-profile')),
    );
    await tester.pump();

    expect(roots, [ProFormCoachRootDestination.profile]);
  });

  testWidgets('battle root is inert when no real battle owner exists', (
    tester,
  ) async {
    final roots = <ProFormCoachRootDestination>[];

    await tester.pumpWidget(
      buildSubject(onRootNavigate: roots.add, battleRootEnabled: false),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-pro-form-coach.nav-battle')),
    );
    await tester.pump();

    expect(roots, isEmpty);
  });
}
