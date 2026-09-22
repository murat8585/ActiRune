import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/home/rune_shrine_ready_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onClose,
    VoidCallback? onOpenGift,
    VoidCallback? onNotNow,
    ValueChanged<RuneShrineReadyRootDestination>? onRootNavigate,
    bool battleRootEnabled = true,
  }) {
    return MaterialApp(
      home: RuneShrineReadyScreen(
        onClose: onClose,
        onOpenGift: onOpenGift,
        onNotNow: onNotNow,
        onRootNavigate: onRootNavigate,
        battleRootEnabled: battleRootEnabled,
      ),
    );
  }

  testWidgets('Rune Shrine ready renders exact approved artwork shell', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, RuneShrineReadyScreen.artworkAsset);
    expect(surface.sourceSize, const Size(941, 1672));

    for (final id in const [
      'rune-shrine-ready.close',
      'rune-shrine-ready.open-gift',
      'rune-shrine-ready.not-now',
      'rune-shrine-ready.nav-home',
      'rune-shrine-ready.nav-adventure',
      'rune-shrine-ready.nav-battle',
      'rune-shrine-ready.nav-hero',
      'rune-shrine-ready.nav-profile',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
    }

    for (final id in const [
      'rune-shrine-ready.ready-state',
      'rune-shrine-ready.cooldown',
      'rune-shrine-ready.daily-uses',
      'rune-shrine-ready.gold-reward',
      'rune-shrine-ready.material-reward',
      'rune-shrine-ready.potion-reward',
      'rune-shrine-ready.rune-fragment-reward',
      'rune-shrine-ready.cosmetic-reward',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsNothing);
    }
  });

  testWidgets('Rewarded-ad action stays disabled without an owner', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    final semantics = tester.widget<Semantics>(
      find.byKey(const ValueKey('artwork-hotspot-rune-shrine-ready.open-gift')),
    );
    expect(semantics.properties.enabled, isFalse);
  });

  testWidgets('Modal actions dispatch independently when owned', (
    tester,
  ) async {
    var closed = 0;
    var opened = 0;
    var skipped = 0;

    await tester.pumpWidget(
      buildSubject(
        onClose: () => closed++,
        onOpenGift: () => opened++,
        onNotNow: () => skipped++,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-rune-shrine-ready.open-gift')),
    );
    await tester.pump();
    expect(opened, 1);
    expect(closed, 0);
    expect(skipped, 0);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-rune-shrine-ready.not-now')),
    );
    await tester.pump();
    expect(skipped, 1);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-rune-shrine-ready.close')),
    );
    await tester.pump();
    expect(closed, 1);
  });

  testWidgets('Root navigation stays caller-owned', (tester) async {
    for (final destination in RuneShrineReadyRootDestination.values) {
      RuneShrineReadyRootDestination? routed;
      await tester.pumpWidget(
        buildSubject(onRootNavigate: (value) => routed = value),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(
          ValueKey('artwork-hotspot-rune-shrine-ready.nav-${destination.name}'),
        ),
      );
      await tester.pump();
      expect(routed, destination);
    }
  });

  testWidgets('Battle root can be disabled without hiding visual control', (
    tester,
  ) async {
    RuneShrineReadyRootDestination? routed;
    await tester.pumpWidget(
      buildSubject(
        battleRootEnabled: false,
        onRootNavigate: (value) => routed = value,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-rune-shrine-ready.nav-battle'),
      ),
      warnIfMissed: false,
    );
    await tester.pump();

    expect(routed, isNull);
  });
}
