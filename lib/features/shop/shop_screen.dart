import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum ShopCategory { featured, hero, lumi, effects, runeThemes, crystals, pro }

enum ShopProduct {
  starTravelerCloak,
  moonlightLumi,
  ancientRuneEffect,
  forestSpiritArmor,
  crystalPortalEffect,
  lumiNorthernLights,
  shadowSteps,
  heroPoseVictory,
}

enum ShopRootDestination { home, adventure, battle, hero, profile }

/// Canonical Mağaza / Shop Revision exact-art shell from VIS_0221.
///
/// The approved artwork is the UI. Product, category and commerce actions are
/// forwarded to authoritative owners only. This screen does not own billing,
/// SKU identifiers, prices, purchases, entitlements or currency grants.
class ShopScreen extends StatelessWidget {
  const ShopScreen({
    super.key,
    this.onNotifications,
    this.onSettings,
    this.onCategorySelected,
    this.onWeeklyCollection,
    this.onSeeAllFeatured,
    this.onProductSelected,
    this.onRuneThemes,
    this.onCrystalPacks,
    this.onPro,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/01_CANONICAL_FINAL/'
      'VIS_0221__P1_SHOP_REVISION_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onNotifications;
  final VoidCallback? onSettings;
  final ValueChanged<ShopCategory>? onCategorySelected;
  final VoidCallback? onWeeklyCollection;
  final VoidCallback? onSeeAllFeatured;
  final ValueChanged<ShopProduct>? onProductSelected;
  final VoidCallback? onRuneThemes;
  final VoidCallback? onCrystalPacks;
  final VoidCallback? onPro;
  final ValueChanged<ShopRootDestination>? onRootNavigate;
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
    required ShopCategory category,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onCategorySelected;
    return ArtworkHotspot(
      id: 'shop.category-${category.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(category),
    );
  }

  ArtworkHotspot _productHotspot({
    required ShopProduct product,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onProductSelected;
    return ArtworkHotspot(
      id: 'shop.product-${product.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(product),
    );
  }

  ArtworkHotspot _rootHotspot({
    required ShopRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != ShopRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'shop.nav-${destination.name}',
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
              id: 'shop.notifications',
              semanticLabel: 'Bildirimler',
              normalizedRect: const Rect.fromLTWH(
                0.8270,
                0.0120,
                0.0660,
                0.0550,
              ),
              callback: onNotifications,
            ),
            _hotspot(
              id: 'shop.settings',
              semanticLabel: 'Ayarlar',
              normalizedRect: const Rect.fromLTWH(
                0.9100,
                0.0100,
                0.0740,
                0.0580,
              ),
              callback: onSettings,
            ),
            _categoryHotspot(
              category: ShopCategory.featured,
              semanticLabel: 'Öne Çıkan',
              normalizedRect: const Rect.fromLTWH(
                0.0180,
                0.2260,
                0.1400,
                0.0520,
              ),
            ),
            _categoryHotspot(
              category: ShopCategory.hero,
              semanticLabel: 'Hero',
              normalizedRect: const Rect.fromLTWH(
                0.1580,
                0.2260,
                0.1300,
                0.0520,
              ),
            ),
            _categoryHotspot(
              category: ShopCategory.lumi,
              semanticLabel: 'Lumi',
              normalizedRect: const Rect.fromLTWH(
                0.2880,
                0.2260,
                0.1200,
                0.0520,
              ),
            ),
            _categoryHotspot(
              category: ShopCategory.effects,
              semanticLabel: 'Efektler',
              normalizedRect: const Rect.fromLTWH(
                0.4080,
                0.2260,
                0.1250,
                0.0520,
              ),
            ),
            _categoryHotspot(
              category: ShopCategory.runeThemes,
              semanticLabel: 'Rün Temaları',
              normalizedRect: const Rect.fromLTWH(
                0.5330,
                0.2260,
                0.1600,
                0.0520,
              ),
            ),
            _categoryHotspot(
              category: ShopCategory.crystals,
              semanticLabel: 'Kristaller',
              normalizedRect: const Rect.fromLTWH(
                0.6930,
                0.2260,
                0.1450,
                0.0520,
              ),
            ),
            _categoryHotspot(
              category: ShopCategory.pro,
              semanticLabel: 'Pro',
              normalizedRect: const Rect.fromLTWH(
                0.8380,
                0.2260,
                0.1450,
                0.0520,
              ),
            ),
            _hotspot(
              id: 'shop.weekly-collection',
              semanticLabel: 'Kristal Şövalye Seti Koleksiyonunu İncele',
              normalizedRect: const Rect.fromLTWH(
                0.0500,
                0.3970,
                0.2350,
                0.0350,
              ),
              callback: onWeeklyCollection,
            ),
            _hotspot(
              id: 'shop.see-all-featured',
              semanticLabel: 'Öne Çıkan Ürünlerin Tümünü Gör',
              normalizedRect: const Rect.fromLTWH(
                0.8100,
                0.4370,
                0.1650,
                0.0300,
              ),
              callback: onSeeAllFeatured,
            ),
            _productHotspot(
              product: ShopProduct.starTravelerCloak,
              semanticLabel: 'Yıldız Gezgini Pelerini',
              normalizedRect: const Rect.fromLTWH(
                0.0200,
                0.4610,
                0.2250,
                0.1450,
              ),
            ),
            _productHotspot(
              product: ShopProduct.moonlightLumi,
              semanticLabel: 'Ay Işığı Lumi',
              normalizedRect: const Rect.fromLTWH(
                0.2580,
                0.4610,
                0.2250,
                0.1450,
              ),
            ),
            _productHotspot(
              product: ShopProduct.ancientRuneEffect,
              semanticLabel: 'Kadim Rune Efekti',
              normalizedRect: const Rect.fromLTWH(
                0.4950,
                0.4610,
                0.2250,
                0.1450,
              ),
            ),
            _productHotspot(
              product: ShopProduct.forestSpiritArmor,
              semanticLabel: 'Orman Ruhu Zırhı',
              normalizedRect: const Rect.fromLTWH(
                0.7350,
                0.4610,
                0.2350,
                0.1450,
              ),
            ),
            _productHotspot(
              product: ShopProduct.crystalPortalEffect,
              semanticLabel: 'Kristal Portal Efekti',
              normalizedRect: const Rect.fromLTWH(
                0.0200,
                0.6120,
                0.2250,
                0.1400,
              ),
            ),
            _productHotspot(
              product: ShopProduct.lumiNorthernLights,
              semanticLabel: 'Lumi Kuzey Işıkları',
              normalizedRect: const Rect.fromLTWH(
                0.2580,
                0.6120,
                0.2250,
                0.1400,
              ),
            ),
            _productHotspot(
              product: ShopProduct.shadowSteps,
              semanticLabel: 'Gölge Adımları',
              normalizedRect: const Rect.fromLTWH(
                0.4950,
                0.6120,
                0.2250,
                0.1400,
              ),
            ),
            _productHotspot(
              product: ShopProduct.heroPoseVictory,
              semanticLabel: 'Kahraman Pose Zafer',
              normalizedRect: const Rect.fromLTWH(
                0.7350,
                0.6120,
                0.2350,
                0.1400,
              ),
            ),
            _hotspot(
              id: 'shop.rune-themes',
              semanticLabel: 'Rün Temaları Koleksiyonu',
              normalizedRect: const Rect.fromLTWH(
                0.0400,
                0.8420,
                0.2650,
                0.0350,
              ),
              callback: onRuneThemes,
            ),
            _hotspot(
              id: 'shop.crystal-packs',
              semanticLabel: 'Kristal Paketleri',
              normalizedRect: const Rect.fromLTWH(
                0.3600,
                0.8420,
                0.2700,
                0.0350,
              ),
              callback: onCrystalPacks,
            ),
            _hotspot(
              id: 'shop.pro',
              semanticLabel: 'ActiRune Pro',
              normalizedRect: const Rect.fromLTWH(
                0.6900,
                0.8420,
                0.2550,
                0.0350,
              ),
              callback: onPro,
            ),
            _rootHotspot(
              destination: ShopRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(
                0.0000,
                0.9060,
                0.2000,
                0.0940,
              ),
            ),
            _rootHotspot(
              destination: ShopRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(
                0.2000,
                0.9060,
                0.2000,
                0.0940,
              ),
            ),
            _rootHotspot(
              destination: ShopRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(
                0.4000,
                0.9060,
                0.2000,
                0.0940,
              ),
            ),
            _rootHotspot(
              destination: ShopRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(
                0.6000,
                0.9060,
                0.2000,
                0.0940,
              ),
            ),
            _rootHotspot(
              destination: ShopRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(
                0.8000,
                0.9060,
                0.2000,
                0.0940,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
