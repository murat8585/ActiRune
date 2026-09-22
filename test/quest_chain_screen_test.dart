import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/quests/quest_chain_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onBack,
    VoidCallback? onDailyStreak,
    VoidCallback? onActiveQuest,
    ValueChanged<QuestChainRootDestination>? onRootNavigate,
    bool battleRootEnabled = true,
  }) {
    return MaterialApp(
      home: QuestChainScreen(
        onBack: onBack,
        onDailyStreak: onDailyStreak,
        onActiveQuest: onActiveQuest,
        onRootNavigate: onRootNavigate,
        battleRootEnabled: battleRootEnabled,
      ),
    );
  }

  testWidgets('Quest Chain renders exact approved artwork shell', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, QuestChainScreen.artworkAsset);
    expect(surface.sourceSize, const Size(941, 1672));

    for (final id in const [
      'quest-chain.back',
      'quest-chain.daily-streak',
      'quest-chain.active-quest',
      'quest-chain.nav-home',
      'quest-chain.nav-adventure',
      'quest-chain.nav-battle',
      'quest-chain.nav-hero',
      'quest-chain.nav-profile',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
    }

    for (final id in const [
      'quest-chain.completed-1',
      'quest-chain.completed-2',
      'quest-chain.locked-4',
      'quest-chain.locked-5',
      'quest-chain.chapter-reward',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsNothing);
    }
  });

  testWidgets('Active quest stays disabled without a real encounter owner', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    final semantics = tester.widget<Semantics>(
      find.byKey(const ValueKey('artwork-hotspot-quest-chain.active-quest')),
    );
    expect(semantics.properties.enabled, isFalse);
  });

  testWidgets('Visible actions dispatch only through explicit owners', (
    tester,
  ) async {
    var back = 0;
    var daily = 0;
    var activeQuest = 0;

    await tester.pumpWidget(
      buildSubject(
        onBack: () => back++,
        onDailyStreak: () => daily++,
        onActiveQuest: () => activeQuest++,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-quest-chain.back')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-quest-chain.daily-streak')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-quest-chain.active-quest')),
    );
    await tester.pump();

    expect(back, 1);
    expect(daily, 1);
    expect(activeQuest, 1);
  });

  testWidgets('Quest Chain root navigation stays caller-owned', (tester) async {
    for (final destination in QuestChainRootDestination.values) {
      QuestChainRootDestination? routed;
      await tester.pumpWidget(
        buildSubject(onRootNavigate: (value) => routed = value),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(
          ValueKey('artwork-hotspot-quest-chain.nav-${destination.name}'),
        ),
      );
      await tester.pump();
      expect(routed, destination);
    }
  });

  testWidgets('Battle root can be disabled without hiding its artwork', (
    tester,
  ) async {
    QuestChainRootDestination? routed;
    await tester.pumpWidget(
      buildSubject(
        battleRootEnabled: false,
        onRootNavigate: (value) => routed = value,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-quest-chain.nav-battle')),
      warnIfMissed: false,
    );
    await tester.pump();

    expect(routed, isNull);
  });
}
