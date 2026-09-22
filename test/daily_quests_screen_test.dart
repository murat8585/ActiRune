import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/quests/daily_quests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onProgressReward,
    VoidCallback? onClaimExploreReward,
    VoidCallback? onClaimBattleReward,
    VoidCallback? onFreeTaskChange,
    VoidCallback? onTaskChangeHelp,
    ValueChanged<DailyQuestsRootDestination>? onRootNavigate,
    bool battleRootEnabled = true,
  }) {
    return MaterialApp(
      home: DailyQuestsScreen(
        onProgressReward: onProgressReward,
        onClaimExploreReward: onClaimExploreReward,
        onClaimBattleReward: onClaimBattleReward,
        onFreeTaskChange: onFreeTaskChange,
        onTaskChangeHelp: onTaskChangeHelp,
        onRootNavigate: onRootNavigate,
        battleRootEnabled: battleRootEnabled,
      ),
    );
  }

  testWidgets('Daily Quests renders exact approved artwork shell', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, DailyQuestsScreen.artworkAsset);
    expect(surface.sourceSize, const Size(941, 1672));

    for (final id in const [
      'daily-quests.progress-reward',
      'daily-quests.claim-explore',
      'daily-quests.claim-battle',
      'daily-quests.free-change',
      'daily-quests.change-help',
      'daily-quests.nav-home',
      'daily-quests.nav-adventure',
      'daily-quests.nav-battle',
      'daily-quests.nav-hero',
      'daily-quests.nav-profile',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
    }

    for (final id in const [
      'daily-quests.continuing-form',
      'daily-quests.continuing-lumi',
      'daily-quests.continuing-balance',
      'daily-quests.optional-mastery-bonus',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsNothing);
    }
  });

  testWidgets('Daily mutation controls stay disabled without owner engines', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    for (final id in const [
      'daily-quests.progress-reward',
      'daily-quests.claim-explore',
      'daily-quests.claim-battle',
      'daily-quests.free-change',
      'daily-quests.change-help',
    ]) {
      final semantics = tester.widget<Semantics>(
        find.byKey(ValueKey('artwork-hotspot-$id')),
      );
      expect(semantics.properties.enabled, isFalse);
    }
  });

  testWidgets('Daily mutation callbacks dispatch independently when owned', (
    tester,
  ) async {
    var progress = 0;
    var explore = 0;
    var battle = 0;
    var change = 0;
    var help = 0;

    await tester.pumpWidget(
      buildSubject(
        onProgressReward: () => progress++,
        onClaimExploreReward: () => explore++,
        onClaimBattleReward: () => battle++,
        onFreeTaskChange: () => change++,
        onTaskChangeHelp: () => help++,
      ),
    );
    await tester.pump();

    for (final entry in <String, VoidCallback>{
      'daily-quests.progress-reward': () => progress--,
      'daily-quests.claim-explore': () => explore--,
      'daily-quests.claim-battle': () => battle--,
      'daily-quests.free-change': () => change--,
      'daily-quests.change-help': () => help--,
    }.entries) {
      await tester.tap(find.byKey(ValueKey('artwork-hotspot-${entry.key}')));
      await tester.pump();
      entry.value();
    }

    expect(progress, 0);
    expect(explore, 0);
    expect(battle, 0);
    expect(change, 0);
    expect(help, 0);
  });

  testWidgets('Daily root navigation stays caller-owned', (tester) async {
    for (final destination in DailyQuestsRootDestination.values) {
      DailyQuestsRootDestination? routed;
      await tester.pumpWidget(
        buildSubject(onRootNavigate: (value) => routed = value),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(
          ValueKey('artwork-hotspot-daily-quests.nav-${destination.name}'),
        ),
      );
      await tester.pump();
      expect(routed, destination);
    }
  });

  testWidgets('Battle root can be disabled without hiding visual control', (
    tester,
  ) async {
    DailyQuestsRootDestination? routed;
    await tester.pumpWidget(
      buildSubject(
        battleRootEnabled: false,
        onRootNavigate: (value) => routed = value,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-daily-quests.nav-battle')),
      warnIfMissed: false,
    );
    await tester.pump();

    expect(routed, isNull);
  });
}
