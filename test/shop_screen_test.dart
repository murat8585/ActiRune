import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/shop/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onNotifications,
    VoidCallback? onSettings,
    ValueChanged<ShopCategory>? onCategorySelected,
    VoidCallback? onWeeklyCollection,
    VoidCallback? onSeeAllFeatured,
    ValueChanged<ShopProduct>? onProductSelected,
    VoidCallback? onRuneThemes,
    VoidCallback? onCrystalPacks,
    VoidCallback? onPro,
    ValueChanged<ShopRootDestination>? onRootNavigate,
    bool battleRootEnabled = true,
  }) {
    return MaterialApp(
      home: ShopScreen(
        onNotifications: onNotifications,
        onSettings: onSettings,
        onCategorySelected: onCategorySelected,
        onWeeklyCollection: onWeeklyCollection,
        onSeeAllFeatured: onSeeAllFeatured,
        onProductSelected: onProductSelected,
        onRuneThemes: onRuneThemes,
        onCrystalPacks: onCrystalPacks,
        onPro: onPro,
        onRootNavigate: onRootNavigate,
        battleRootEnabled: battleRootEnabled,
      ),
    );
  }

  testWidgets('Shop renders the approved exact-art shell', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, ShopScreen.artworkAsset);
    expect(surface.sourceSize, ShopScreen.artworkSize);
    expect(ShopScreen.artworkSize, const Size(941, 1672));

    for (final id in [
      'shop.notifications',
      'shop.settings',
      'shop.category-featured',
      'shop.category-hero',
      'shop.category-lumi',
      'shop.category-effects',
      'shop.category-runeThemes',
      'shop.category-crystals',
      'shop.category-pro',
      'shop.weekly-collection',
      'shop.see-all-featured',
      'shop.product-starTravelerCloak',
      'shop.product-moonlightLumi',
      'shop.product-ancientRuneEffect',
      'shop.product-forestSpiritArmor',
      'shop.product-crystalPortalEffect',
      'shop.product-lumiNorthernLights',
      'shop.product-shadowSteps',
      'shop.product-heroPoseVictory',
      'shop.rune-themes',
      'shop.crystal-packs',
      'shop.pro',
      'shop.nav-home',
      'shop.nav-adventure',
      'shop.nav-battle',
      'shop.nav-hero',
      'shop.nav-profile',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
    }
  });

  testWidgets('Shop categories dispatch only to their owner', (tester) async {
    final categories = <ShopCategory>[];

    await tester.pumpWidget(buildSubject(onCategorySelected: categories.add));
    await tester.pumpAndSettle();

    for (final entry in [
      ('featured', ShopCategory.featured),
      ('hero', ShopCategory.hero),
      ('lumi', ShopCategory.lumi),
      ('effects', ShopCategory.effects),
      ('runeThemes', ShopCategory.runeThemes),
      ('crystals', ShopCategory.crystals),
      ('pro', ShopCategory.pro),
    ]) {
      await tester.tap(
        find.byKey(ValueKey('artwork-hotspot-shop.category-${entry.$1}')),
      );
      await tester.pump();
    }

    expect(categories, [
      ShopCategory.featured,
      ShopCategory.hero,
      ShopCategory.lumi,
      ShopCategory.effects,
      ShopCategory.runeThemes,
      ShopCategory.crystals,
      ShopCategory.pro,
    ]);
  });

  testWidgets('Shop product cards only dispatch product intent', (
    tester,
  ) async {
    final products = <ShopProduct>[];

    await tester.pumpWidget(buildSubject(onProductSelected: products.add));
    await tester.pumpAndSettle();

    for (final entry in [
      ('starTravelerCloak', ShopProduct.starTravelerCloak),
      ('moonlightLumi', ShopProduct.moonlightLumi),
      ('ancientRuneEffect', ShopProduct.ancientRuneEffect),
      ('forestSpiritArmor', ShopProduct.forestSpiritArmor),
      ('crystalPortalEffect', ShopProduct.crystalPortalEffect),
      ('lumiNorthernLights', ShopProduct.lumiNorthernLights),
      ('shadowSteps', ShopProduct.shadowSteps),
      ('heroPoseVictory', ShopProduct.heroPoseVictory),
    ]) {
      await tester.tap(
        find.byKey(ValueKey('artwork-hotspot-shop.product-${entry.$1}')),
      );
      await tester.pump();
    }

    expect(products, [
      ShopProduct.starTravelerCloak,
      ShopProduct.moonlightLumi,
      ShopProduct.ancientRuneEffect,
      ShopProduct.forestSpiritArmor,
      ShopProduct.crystalPortalEffect,
      ShopProduct.lumiNorthernLights,
      ShopProduct.shadowSteps,
      ShopProduct.heroPoseVictory,
    ]);
  });

  testWidgets('Shop commerce actions remain callback-only', (tester) async {
    var weeklyCollectionCount = 0;
    var seeAllCount = 0;
    var runeThemesCount = 0;
    var crystalPacksCount = 0;
    var proCount = 0;

    await tester.pumpWidget(
      buildSubject(
        onWeeklyCollection: () => weeklyCollectionCount++,
        onSeeAllFeatured: () => seeAllCount++,
        onRuneThemes: () => runeThemesCount++,
        onCrystalPacks: () => crystalPacksCount++,
        onPro: () => proCount++,
      ),
    );
    await tester.pumpAndSettle();

    for (final id in [
      'shop.weekly-collection',
      'shop.see-all-featured',
      'shop.rune-themes',
      'shop.crystal-packs',
      'shop.pro',
    ]) {
      await tester.tap(find.byKey(ValueKey('artwork-hotspot-$id')));
      await tester.pump();
    }

    expect(weeklyCollectionCount, 1);
    expect(seeAllCount, 1);
    expect(runeThemesCount, 1);
    expect(crystalPacksCount, 1);
    expect(proCount, 1);
  });

  testWidgets('Shop utility actions and root navigation are independent', (
    tester,
  ) async {
    var notificationsCount = 0;
    var settingsCount = 0;
    final roots = <ShopRootDestination>[];

    await tester.pumpWidget(
      buildSubject(
        onNotifications: () => notificationsCount++,
        onSettings: () => settingsCount++,
        onRootNavigate: roots.add,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-shop.notifications')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-shop.settings')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-shop.nav-hero')),
    );
    await tester.pump();

    expect(notificationsCount, 1);
    expect(settingsCount, 1);
    expect(roots, [ShopRootDestination.hero]);
  });

  testWidgets('Shop battle root stays inert without a battle owner', (
    tester,
  ) async {
    final roots = <ShopRootDestination>[];

    await tester.pumpWidget(
      buildSubject(onRootNavigate: roots.add, battleRootEnabled: false),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-shop.nav-battle')),
    );
    await tester.pump();

    expect(roots, isEmpty);
  });
}
