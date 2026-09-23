import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum CraftingCategory { weapons, armor, runes }

enum CraftingRecipe {
  iceGuardianSword,
  shadowClaw,
  flameAxe,
  stormSpear,
  stoneBreaker,
  ironLongSword,
}

enum CraftingMaterial { iceOre, ancientEssence, frozenShard, gold }

enum CraftingRootDestination { home, adventure, battle, hero, profile }

/// Canonical Crafting / Rün Dövme exact-art shell.
///
/// The approved artwork is the UI. Recipe/category/material selections and the
/// craft action are forwarded to a real crafting owner only. This widget does
/// not mutate inventory, spend currency, grant items, or invent drop sources.
class CraftingScreen extends StatelessWidget {
  const CraftingScreen({
    super.key,
    this.onBack,
    this.onInfo,
    this.onGoldStore,
    this.onCrystalStore,
    this.onEnergyStore,
    this.onCategorySelected,
    this.onRecipeSelected,
    this.onMaterialSourceRequested,
    this.onAllRecipes,
    this.onCraftRequested,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_p1/04_P1_CRAFTING_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final VoidCallback? onInfo;
  final VoidCallback? onGoldStore;
  final VoidCallback? onCrystalStore;
  final VoidCallback? onEnergyStore;
  final ValueChanged<CraftingCategory>? onCategorySelected;
  final ValueChanged<CraftingRecipe>? onRecipeSelected;
  final ValueChanged<CraftingMaterial>? onMaterialSourceRequested;
  final VoidCallback? onAllRecipes;
  final VoidCallback? onCraftRequested;
  final ValueChanged<CraftingRootDestination>? onRootNavigate;
  final bool battleRootEnabled;

  ArtworkHotspot _hotspot({
    required String id,
    required String semanticLabel,
    required Rect normalizedRect,
    required VoidCallback? callback,
  }) {
    return ArtworkHotspot(
      id: id,
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback ?? () {},
    );
  }

  ArtworkHotspot _categoryHotspot({
    required CraftingCategory category,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onCategorySelected;
    return ArtworkHotspot(
      id: 'crafting.category-${category.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(category),
    );
  }

  ArtworkHotspot _recipeHotspot({
    required CraftingRecipe recipe,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRecipeSelected;
    return ArtworkHotspot(
      id: 'crafting.recipe-${recipe.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(recipe),
    );
  }

  ArtworkHotspot _materialHotspot({
    required CraftingMaterial material,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onMaterialSourceRequested;
    return ArtworkHotspot(
      id: 'crafting.material-${material.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(material),
    );
  }

  ArtworkHotspot _rootHotspot({
    required CraftingRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != CraftingRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'crafting.nav-${destination.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: enabled,
      onTap: enabled ? () => callback(destination) : () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: artworkAsset,
          sourceSize: artworkSize,
          hotspots: [
            _hotspot(
              id: 'crafting.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.0100, 0.0100, 0.0780, 0.0500),
              callback: onBack,
            ),
            _hotspot(
              id: 'crafting.gold-store',
              semanticLabel: 'Altın Ekle',
              normalizedRect: const Rect.fromLTWH(0.4050, 0.0110, 0.0500, 0.0380),
              callback: onGoldStore,
            ),
            _hotspot(
              id: 'crafting.crystal-store',
              semanticLabel: 'Kristal Ekle',
              normalizedRect: const Rect.fromLTWH(0.5920, 0.0110, 0.0500, 0.0380),
              callback: onCrystalStore,
            ),
            _hotspot(
              id: 'crafting.energy-store',
              semanticLabel: 'Enerji Ekle',
              normalizedRect: const Rect.fromLTWH(0.7850, 0.0110, 0.0500, 0.0380),
              callback: onEnergyStore,
            ),
            _hotspot(
              id: 'crafting.info',
              semanticLabel: 'Üretim Bilgisi',
              normalizedRect: const Rect.fromLTWH(0.9200, 0.0100, 0.0700, 0.0520),
              callback: onInfo,
            ),
            _categoryHotspot(
              category: CraftingCategory.weapons,
              semanticLabel: 'Silahlar',
              normalizedRect: const Rect.fromLTWH(0.0250, 0.3650, 0.3150, 0.0480),
            ),
            _categoryHotspot(
              category: CraftingCategory.armor,
              semanticLabel: 'Zırhlar',
              normalizedRect: const Rect.fromLTWH(0.3400, 0.3650, 0.3150, 0.0480),
            ),
            _categoryHotspot(
              category: CraftingCategory.runes,
              semanticLabel: 'Runeler',
              normalizedRect: const Rect.fromLTWH(0.6550, 0.3650, 0.3200, 0.0480),
            ),
            _recipeHotspot(
              recipe: CraftingRecipe.iceGuardianSword,
              semanticLabel: 'Buz Muhafızı Kılıcı',
              normalizedRect: const Rect.fromLTWH(0.0320, 0.4240, 0.4250, 0.0710),
            ),
            _recipeHotspot(
              recipe: CraftingRecipe.shadowClaw,
              semanticLabel: 'Gölge Pençesi',
              normalizedRect: const Rect.fromLTWH(0.0320, 0.4970, 0.4250, 0.0710),
            ),
            _recipeHotspot(
              recipe: CraftingRecipe.flameAxe,
              semanticLabel: 'Alev Baltası',
              normalizedRect: const Rect.fromLTWH(0.0320, 0.5700, 0.4250, 0.0710),
            ),
            _recipeHotspot(
              recipe: CraftingRecipe.stormSpear,
              semanticLabel: 'Fırtına Mızrağı',
              normalizedRect: const Rect.fromLTWH(0.0320, 0.6430, 0.4250, 0.0710),
            ),
            _recipeHotspot(
              recipe: CraftingRecipe.stoneBreaker,
              semanticLabel: 'Kaya Kırıcı',
              normalizedRect: const Rect.fromLTWH(0.0320, 0.7160, 0.4250, 0.0710),
            ),
            _recipeHotspot(
              recipe: CraftingRecipe.ironLongSword,
              semanticLabel: 'Demir Uzun Kılıç',
              normalizedRect: const Rect.fromLTWH(0.0320, 0.7890, 0.4250, 0.0710),
            ),
            _materialHotspot(
              material: CraftingMaterial.iceOre,
              semanticLabel: 'Buz Cevheri Kaynağı',
              normalizedRect: const Rect.fromLTWH(0.5000, 0.7160, 0.1120, 0.0820),
            ),
            _materialHotspot(
              material: CraftingMaterial.ancientEssence,
              semanticLabel: 'Kadim Öz Kaynağı',
              normalizedRect: const Rect.fromLTWH(0.6120, 0.7160, 0.1120, 0.0820),
            ),
            _materialHotspot(
              material: CraftingMaterial.frozenShard,
              semanticLabel: 'Donmuş Parça Kaynağı',
              normalizedRect: const Rect.fromLTWH(0.7240, 0.7160, 0.1120, 0.0820),
            ),
            _materialHotspot(
              material: CraftingMaterial.gold,
              semanticLabel: 'Altın Kaynağı',
              normalizedRect: const Rect.fromLTWH(0.8360, 0.7160, 0.1350, 0.0820),
            ),
            _hotspot(
              id: 'crafting.all-recipes',
              semanticLabel: 'Tüm Tarifler',
              normalizedRect: const Rect.fromLTWH(0.0450, 0.8460, 0.3950, 0.0500),
              callback: onAllRecipes,
            ),
            _hotspot(
              id: 'crafting.craft',
              semanticLabel: 'Üret',
              normalizedRect: const Rect.fromLTWH(0.4950, 0.8200, 0.4550, 0.0750),
              callback: onCraftRequested,
            ),
            _rootHotspot(
              destination: CraftingRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.0000, 0.9020, 0.2000, 0.0980),
            ),
            _rootHotspot(
              destination: CraftingRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.2000, 0.9020, 0.2000, 0.0980),
            ),
            _rootHotspot(
              destination: CraftingRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.4000, 0.9020, 0.2000, 0.0980),
            ),
            _rootHotspot(
              destination: CraftingRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.6000, 0.9020, 0.2000, 0.0980),
            ),
            _rootHotspot(
              destination: CraftingRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.8000, 0.9020, 0.2000, 0.0980),
            ),
          ],
        ),
      ),
    );
  }
}
