import 'package:actirune/app/main_shell.dart';
import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/core/widgets/feature_unavailable_dialog.dart';
import 'package:actirune/features/quests/weekly_quests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onDailyStreak,
    VoidCallback? onClaimQuestChainReward,
    ValueChanged<WeeklyQuestsRootDestination>? onRootNavigate,
    bool battleRootEnabled = true,
  }) {
    return MaterialApp(
      home: WeeklyQuestsScreen(
        onDailyStreak: onDailyStreak,
        onClaimQuestChainReward: onClaimQuestChainReward,
        onRootNavigate: onRootNavigate,
        battleRootEnabled: battleRootEnabled,
      ),
    );
  }

  testWidgets('Weekly Quests renders exact approved artwork shell', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, WeeklyQuestsScreen.artworkAsset);
    expect(surface.sourceSize, const Size(941, 1672));

    for (final id in const [
      'weekly-quests.daily-streak',
      'weekly-quests.claim-quest-chain',
      'weekly-quests.nav-home',
      'weekly-quests.nav-adventure',
      'weekly-quests.nav-battle',
      'weekly-quests.nav-hero',
      'weekly-quests.nav-profile',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
    }

    for (final id in const [
      'weekly-quests.completed-explore',
      'weekly-quests.continuing-battle',
      'weekly-quests.continuing-mastery',
      'weekly-quests.continuing-mini-boss',
      'weekly-quests.continuing-form',
      'weekly-quests.continuing-lumi',
      'weekly-quests.completed-active-day',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsNothing);
    }
  });

  testWidgets('Weekly reward stays disabled without an owner engine', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    final semantics = tester.widget<Semantics>(
      find.byKey(
        const ValueKey('artwork-hotspot-weekly-quests.claim-quest-chain'),
      ),
    );
    expect(semantics.properties.enabled, isFalse);
  });

  testWidgets('Weekly callbacks dispatch only through explicit owners', (
    tester,
  ) async {
    var daily = 0;
    var reward = 0;

    await tester.pumpWidget(
      buildSubject(
        onDailyStreak: () => daily++,
        onClaimQuestChainReward: () => reward++,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-weekly-quests.daily-streak')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-weekly-quests.claim-quest-chain'),
      ),
    );
    await tester.pump();

    expect(daily, 1);
    expect(reward, 1);
  });

  testWidgets('Weekly root navigation stays caller-owned', (tester) async {
    for (final destination in WeeklyQuestsRootDestination.values) {
      WeeklyQuestsRootDestination? routed;
      await tester.pumpWidget(
        buildSubject(onRootNavigate: (value) => routed = value),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(
          ValueKey('artwork-hotspot-weekly-quests.nav-${destination.name}'),
        ),
      );
      await tester.pump();
      expect(routed, destination);
    }
  });

  testWidgets('Battle root can be disabled without hiding its artwork', (
    tester,
  ) async {
    WeeklyQuestsRootDestination? routed;
    await tester.pumpWidget(
      buildSubject(
        battleRootEnabled: false,
        onRootNavigate: (value) => routed = value,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-weekly-quests.nav-battle')),
      warnIfMissed: false,
    );
    await tester.pump();

    expect(routed, isNull);
  });

  testWidgets('Home Görevler never misroutes directly to Weekly Quests', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('artwork-hotspot-home.quests')));
    await tester.pumpAndSettle();

    expect(find.byType(WeeklyQuestsScreen), findsNothing);
    expect(find.byType(FeatureUnavailableDialog), findsOneWidget);
    expect(find.text('Görevler'), findsOneWidget);
  });
}
