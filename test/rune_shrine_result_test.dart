import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/hero/rune_shrine_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onBack,
    VoidCallback? onInspectRune,
    VoidCallback? onContinue,
    ValueChanged<RuneShrineResultRootDestination>? onRootNavigate,
    bool battleRootEnabled = true,
  }) {
    return MaterialApp(
      home: RuneShrineResultScreen(
        onBack: onBack ?? () {},
        onInspectRune: onInspectRune,
        onContinue: onContinue,
        onRootNavigate: onRootNavigate,
        battleRootEnabled: battleRootEnabled,
      ),
    );
  }

  testWidgets('Rune Shrine result renders exact approved artwork shell', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, RuneShrineResultScreen.artworkAsset);
    expect(surface.sourceSize, const Size(941, 1672));

    for (final id in const [
      'rune-shrine-result.back',
      'rune-shrine-result.inspect',
      'rune-shrine-result.continue',
      'rune-shrine-result.nav-home',
      'rune-shrine-result.nav-adventure',
      'rune-shrine-result.nav-battle',
      'rune-shrine-result.nav-hero',
      'rune-shrine-result.nav-profile',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
    }

    for (final id in const [
      'rune-shrine-result.attack-bonus',
      'rune-shrine-result.critical-bonus',
      'rune-shrine-result.rarity',
      'rune-shrine-result.flavor',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsNothing);
    }
  });

  testWidgets('Result actions dispatch independently', (tester) async {
    var back = 0;
    var inspect = 0;
    var continued = 0;

    await tester.pumpWidget(
      buildSubject(
        onBack: () => back++,
        onInspectRune: () => inspect++,
        onContinue: () => continued++,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-rune-shrine-result.inspect')),
    );
    await tester.pump();
    expect(inspect, 1);
    expect(continued, 0);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-rune-shrine-result.continue')),
    );
    await tester.pump();
    expect(continued, 1);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-rune-shrine-result.back')),
    );
    await tester.pump();
    expect(back, 1);
  });

  testWidgets('Root navigation stays caller-owned', (tester) async {
    for (final destination in RuneShrineResultRootDestination.values) {
      RuneShrineResultRootDestination? routed;
      await tester.pumpWidget(
        buildSubject(onRootNavigate: (value) => routed = value),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(
          ValueKey('artwork-hotspot-rune-shrine-result.nav-${destination.name}'),
        ),
      );
      await tester.pump();
      expect(routed, destination);
    }
  });

  testWidgets('Battle root can be disabled without hiding its visual control', (
    tester,
  ) async {
    RuneShrineResultRootDestination? routed;
    await tester.pumpWidget(
      buildSubject(
        battleRootEnabled: false,
        onRootNavigate: (value) => routed = value,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-rune-shrine-result.nav-battle'),
      ),
      warnIfMissed: false,
    );
    await tester.pump();

    expect(routed, isNull);
  });
}
