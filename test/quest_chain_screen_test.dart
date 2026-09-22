import 'package:actirune/app/main_shell.dart';
import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/adventure/adventure_screen.dart';
import 'package:actirune/features/hero/hero_screen.dart';
import 'package:actirune/features/quests/quest_chain_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onBack,
    VoidCallback? onDailyStreak,
    VoidCallback? onActiveQuest,
    VoidCallback? onCompletionRewards,
    ValueChanged<QuestChainRootDestination>? onRootNavigate,
    bool battleRootEnabled = true,
  }) {
    return MaterialApp(
      home: QuestChainScreen(
        onBack: onBack,
        onDailyStreak: onDailyStreak,
        onActiveQuest: onActiveQuest,
        onCompletionRewards: onCompletionRewards,
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
      'quest-chain.completion-rewards',
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
      'quest-chain.locked-badge-4',
      'quest-chain.locked-badge-5',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsNothing);
    }
  });

  testWidgets('Engine-owned actions stay disabled without their owners', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    for (final id in const [
      'quest-chain.daily-streak',
      'quest-chain.active-quest',
      'quest-chain.completion-rewards',
    ]) {
      final semantics = tester.widget<Semantics>(
        find.byKey(ValueKey('artwork-hotspot-$id')),
      );
      expect(semantics.properties.enabled, isFalse);
    }
  });

  testWidgets('Visible actions dispatch only through explicit owners', (
    tester,
  ) async {
    var back = 0;
    var daily = 0;
    var activeQuest = 0;
    var completionRewards = 0;

    await tester.pumpWidget(
      buildSubject(
        onBack: () => back++,
        onDailyStreak: () => daily++,
        onActiveQuest: () => activeQuest++,
        onCompletionRewards: () => completionRewards++,
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
    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-quest-chain.completion-rewards'),
      ),
    );
    await tester.pump();

    expect(back, 1);
    expect(daily, 1);
    expect(activeQuest, 1);
    expect(completionRewards, 1);
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

  testWidgets('Adventure Quests opens Quest Chain and back returns Adventure', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.nav-adventure')),
    );
    await tester.pump();
    expect(find.byType(AdventureScreen), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-adventure.quests')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(QuestChainScreen), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-quest-chain.back')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AdventureScreen), findsOneWidget);
  });

  testWidgets('Hero Character Story opens the authoritative Quest Chain', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.nav-hero')),
    );
    await tester.pump();
    expect(find.byType(HeroScreen), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-hero.character-story')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(QuestChainScreen), findsOneWidget);
  });

  testWidgets('Active quest enters Battle only when a real owner exists', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MainShell(
          battleRootBuilder: (_, _) => const Scaffold(
            body: Center(child: Text('REAL QUEST BATTLE ROOT')),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.nav-adventure')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-adventure.quests')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-quest-chain.active-quest')),
    );
    await tester.pumpAndSettle();

    expect(find.text('REAL QUEST BATTLE ROOT'), findsOneWidget);
    expect(find.byType(QuestChainScreen), findsNothing);
  });

  testWidgets(
    'MainShell exposes quest-chain owner callbacks without faking UI',
    (tester) async {
      var streak = 0;
      var rewards = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: MainShell(
            onQuestChainStreakDetails: () => streak++,
            onQuestChainCompletionRewards: () => rewards++,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-home.nav-adventure')),
      );
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-adventure.quests')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-quest-chain.daily-streak')),
      );
      await tester.pump();
      await tester.tap(
        find.byKey(
          const ValueKey('artwork-hotspot-quest-chain.completion-rewards'),
        ),
      );
      await tester.pump();

      expect(streak, 1);
      expect(rewards, 1);
    },
  );
}
