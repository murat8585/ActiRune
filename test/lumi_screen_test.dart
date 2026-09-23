import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/hero/lumi_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onDailyStreak,
    VoidCallback? onBondInfo,
    VoidCallback? onLevelRewards,
    ValueChanged<LumiAbility>? onAbilitySelected,
    ValueChanged<LumiAppearance>? onAppearanceSelected,
    VoidCallback? onAppearanceNext,
    VoidCallback? onCustomize,
    ValueChanged<LumiRootDestination>? onRootNavigate,
    bool battleRootEnabled = true,
  }) {
    return MaterialApp(
      home: LumiScreen(
        onDailyStreak: onDailyStreak,
        onBondInfo: onBondInfo,
        onLevelRewards: onLevelRewards,
        onAbilitySelected: onAbilitySelected,
        onAppearanceSelected: onAppearanceSelected,
        onAppearanceNext: onAppearanceNext,
        onCustomize: onCustomize,
        onRootNavigate: onRootNavigate,
        battleRootEnabled: battleRootEnabled,
      ),
    );
  }

  testWidgets('Lumi renders the approved exact-art shell', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, LumiScreen.artworkAsset);
    expect(surface.sourceSize, LumiScreen.artworkSize);
    expect(LumiScreen.artworkSize, const Size(941, 1672));

    for (final id in [
      'lumi.daily-streak',
      'lumi.bond-info',
      'lumi.level-rewards',
      'lumi.ability-heal',
      'lumi.ability-shield',
      'lumi.ability-support',
      'lumi.ability-ultimate',
      'lumi.appearance-frost',
      'lumi.appearance-midnight',
      'lumi.appearance-obsidian',
      'lumi.appearance-golden',
      'lumi.appearance-next',
      'lumi.customize',
      'lumi.nav-home',
      'lumi.nav-adventure',
      'lumi.nav-battle',
      'lumi.nav-hero',
      'lumi.nav-profile',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
    }
  });

  testWidgets('Lumi intent controls dispatch only to authoritative owners', (
    tester,
  ) async {
    var dailyStreakCount = 0;
    var bondInfoCount = 0;
    var levelRewardsCount = 0;
    var appearanceNextCount = 0;
    var customizeCount = 0;
    final abilities = <LumiAbility>[];
    final appearances = <LumiAppearance>[];

    await tester.pumpWidget(
      buildSubject(
        onDailyStreak: () => dailyStreakCount++,
        onBondInfo: () => bondInfoCount++,
        onLevelRewards: () => levelRewardsCount++,
        onAbilitySelected: abilities.add,
        onAppearanceSelected: appearances.add,
        onAppearanceNext: () => appearanceNextCount++,
        onCustomize: () => customizeCount++,
      ),
    );
    await tester.pumpAndSettle();

    for (final id in [
      'lumi.daily-streak',
      'lumi.bond-info',
      'lumi.level-rewards',
      'lumi.appearance-next',
      'lumi.customize',
    ]) {
      await tester.tap(find.byKey(ValueKey('artwork-hotspot-$id')));
      await tester.pump();
    }
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-lumi.ability-shield')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-lumi.appearance-frost')),
    );
    await tester.pump();

    expect(dailyStreakCount, 1);
    expect(bondInfoCount, 1);
    expect(levelRewardsCount, 1);
    expect(appearanceNextCount, 1);
    expect(customizeCount, 1);
    expect(abilities, [LumiAbility.shield]);
    expect(appearances, [LumiAppearance.frost]);
  });

  testWidgets('battle root stays inert without a real battle owner', (
    tester,
  ) async {
    final roots = <LumiRootDestination>[];

    await tester.pumpWidget(
      buildSubject(onRootNavigate: roots.add, battleRootEnabled: false),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-lumi.nav-battle')),
    );
    await tester.pump();

    expect(roots, isEmpty);
  });
}
