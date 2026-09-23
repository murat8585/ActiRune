import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/hero/crafting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onBack,
    VoidCallback? onInfo,
    VoidCallback? onGoldStore,
    VoidCallback? onCrystalStore,
    VoidCallback? onEnergyStore,
    ValueChanged<CraftingCategory>? onCategorySelected,
    ValueChanged<CraftingRecipe>? onRecipeSelected,
    ValueChanged<CraftingMaterial>? onMaterialSourceRequested,
    VoidCallback? onAllRecipes,
    VoidCallback? onCraftRequested,
    ValueChanged<CraftingRootDestination>? onRootNavigate,
    bool battleRootEnabled = true,
  }) {
    return MaterialApp(
      home: CraftingScreen(
        onBack: onBack,
        onInfo: onInfo,
        onGoldStore: onGoldStore,
        onCrystalStore: onCrystalStore,
        onEnergyStore: onEnergyStore,
        onCategorySelected: onCategorySelected,
        onRecipeSelected: onRecipeSelected,
        onMaterialSourceRequested: onMaterialSourceRequested,
        onAllRecipes: onAllRecipes,
        onCraftRequested: onCraftRequested,
        onRootNavigate: onRootNavigate,
        battleRootEnabled: battleRootEnabled,
      ),
    );
  }

  testWidgets('Crafting renders the approved exact-art shell', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, CraftingScreen.artworkAsset);
    expect(surface.sourceSize, CraftingScreen.artworkSize);
    expect(CraftingScreen.artworkSize, const Size(941, 1672));

    for (final id in [
      'crafting.back',
      'crafting.gold-store',
      'crafting.crystal-store',
      'crafting.energy-store',
      'crafting.info',
      'crafting.category-weapons',
      'crafting.category-armor',
      'crafting.category-runes',
      'crafting.recipe-iceGuardianSword',
      'crafting.recipe-shadowClaw',
      'crafting.recipe-flameAxe',
      'crafting.recipe-stormSpear',
      'crafting.recipe-stoneBreaker',
      'crafting.recipe-ironLongSword',
      'crafting.material-iceOre',
      'crafting.material-ancientEssence',
      'crafting.material-frozenShard',
      'crafting.material-gold',
      'crafting.all-recipes',
      'crafting.craft',
      'crafting.nav-home',
      'crafting.nav-adventure',
      'crafting.nav-battle',
      'crafting.nav-hero',
      'crafting.nav-profile',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
    }
  });

  testWidgets('category and recipe controls dispatch only to owners', (
    tester,
  ) async {
    final categories = <CraftingCategory>[];
    final recipes = <CraftingRecipe>[];

    await tester.pumpWidget(
      buildSubject(
        onCategorySelected: categories.add,
        onRecipeSelected: recipes.add,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-crafting.category-weapons')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-crafting.recipe-iceGuardianSword'),
      ),
    );
    await tester.pump();

    expect(categories, [CraftingCategory.weapons]);
    expect(recipes, [CraftingRecipe.iceGuardianSword]);
  });

  testWidgets('material tiles request authoritative source details', (
    tester,
  ) async {
    final materials = <CraftingMaterial>[];

    await tester.pumpWidget(
      buildSubject(onMaterialSourceRequested: materials.add),
    );
    await tester.pumpAndSettle();

    for (final entry in [
      ('iceOre', CraftingMaterial.iceOre),
      ('ancientEssence', CraftingMaterial.ancientEssence),
      ('frozenShard', CraftingMaterial.frozenShard),
      ('gold', CraftingMaterial.gold),
    ]) {
      await tester.tap(
        find.byKey(ValueKey('artwork-hotspot-crafting.material-${entry.$1}')),
      );
      await tester.pump();
    }

    expect(materials, [
      CraftingMaterial.iceOre,
      CraftingMaterial.ancientEssence,
      CraftingMaterial.frozenShard,
      CraftingMaterial.gold,
    ]);
  });

  testWidgets('craft action is callback-only and does not mutate inventory', (
    tester,
  ) async {
    var craftCount = 0;
    var allRecipesCount = 0;

    await tester.pumpWidget(
      buildSubject(
        onCraftRequested: () => craftCount++,
        onAllRecipes: () => allRecipesCount++,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-crafting.craft')),
    );
    await tester.pump();
    expect(craftCount, 1);
    expect(allRecipesCount, 0);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-crafting.all-recipes')),
    );
    await tester.pump();
    expect(craftCount, 1);
    expect(allRecipesCount, 1);
  });

  testWidgets('top actions and root navigation remain independent', (
    tester,
  ) async {
    var backCount = 0;
    var infoCount = 0;
    var goldCount = 0;
    var crystalCount = 0;
    var energyCount = 0;
    final roots = <CraftingRootDestination>[];

    await tester.pumpWidget(
      buildSubject(
        onBack: () => backCount++,
        onInfo: () => infoCount++,
        onGoldStore: () => goldCount++,
        onCrystalStore: () => crystalCount++,
        onEnergyStore: () => energyCount++,
        onRootNavigate: roots.add,
      ),
    );
    await tester.pumpAndSettle();

    for (final id in [
      'crafting.back',
      'crafting.info',
      'crafting.gold-store',
      'crafting.crystal-store',
      'crafting.energy-store',
      'crafting.nav-hero',
    ]) {
      await tester.tap(find.byKey(ValueKey('artwork-hotspot-$id')));
      await tester.pump();
    }

    expect(backCount, 1);
    expect(infoCount, 1);
    expect(goldCount, 1);
    expect(crystalCount, 1);
    expect(energyCount, 1);
    expect(roots, [CraftingRootDestination.hero]);
  });

  testWidgets('battle root is inert without a real battle owner', (
    tester,
  ) async {
    final roots = <CraftingRootDestination>[];

    await tester.pumpWidget(
      buildSubject(onRootNavigate: roots.add, battleRootEnabled: false),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-crafting.nav-battle')),
    );
    await tester.pump();

    expect(roots, isEmpty);
  });
}
