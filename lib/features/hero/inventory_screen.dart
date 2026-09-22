import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum InventoryRootDestination { home, adventure, battle, hero, profile }

enum InventoryCategory { equipment, runes, potions, materials }

enum InventoryViewMode { grid, list }

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({
    super.key,
    this.onBack,
    this.onInfo,
    this.onCategory,
    this.onSearch,
    this.onFilter,
    this.onSort,
    this.onViewMode,
    this.onItem,
    this.onBulkActions,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_p1/03_P1_INVENTORY_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final VoidCallback? onInfo;
  final ValueChanged<InventoryCategory>? onCategory;
  final VoidCallback? onSearch;
  final VoidCallback? onFilter;
  final VoidCallback? onSort;
  final ValueChanged<InventoryViewMode>? onViewMode;
  final ValueChanged<int>? onItem;
  final VoidCallback? onBulkActions;
  final ValueChanged<InventoryRootDestination>? onRootNavigate;
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
    required InventoryCategory category,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onCategory;
    return ArtworkHotspot(
      id: 'inventory.category-${category.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(category),
    );
  }

  ArtworkHotspot _viewHotspot({
    required InventoryViewMode mode,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onViewMode;
    return ArtworkHotspot(
      id: 'inventory.view-${mode.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(mode),
    );
  }

  ArtworkHotspot _itemHotspot({
    required int index,
    required Rect normalizedRect,
  }) {
    final callback = onItem;
    return ArtworkHotspot(
      id: 'inventory.item-$index',
      semanticLabel: 'Envanter Eşyası ${index + 1}',
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(index),
    );
  }

  ArtworkHotspot _rootHotspot({
    required InventoryRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != InventoryRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'inventory.nav-${destination.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: enabled,
      onTap: enabled ? () => callback(destination) : () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    const itemRects = <Rect>[
      Rect.fromLTWH(0.040, 0.290, 0.217, 0.136),
      Rect.fromLTWH(0.270, 0.290, 0.217, 0.136),
      Rect.fromLTWH(0.500, 0.290, 0.217, 0.136),
      Rect.fromLTWH(0.730, 0.290, 0.217, 0.136),
      Rect.fromLTWH(0.040, 0.433, 0.217, 0.136),
      Rect.fromLTWH(0.270, 0.433, 0.217, 0.136),
      Rect.fromLTWH(0.500, 0.433, 0.217, 0.136),
      Rect.fromLTWH(0.730, 0.433, 0.217, 0.136),
      Rect.fromLTWH(0.040, 0.576, 0.217, 0.136),
      Rect.fromLTWH(0.270, 0.576, 0.217, 0.136),
      Rect.fromLTWH(0.500, 0.576, 0.217, 0.136),
      Rect.fromLTWH(0.730, 0.576, 0.217, 0.136),
      Rect.fromLTWH(0.040, 0.719, 0.217, 0.136),
      Rect.fromLTWH(0.270, 0.719, 0.217, 0.136),
      Rect.fromLTWH(0.500, 0.719, 0.217, 0.136),
      Rect.fromLTWH(0.730, 0.719, 0.217, 0.136),
    ];

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
              id: 'inventory.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.010, 0.010, 0.080, 0.060),
              callback: onBack,
            ),
            _hotspot(
              id: 'inventory.info',
              semanticLabel: 'Bilgi',
              normalizedRect: const Rect.fromLTWH(0.904, 0.010, 0.070, 0.055),
              callback: onInfo,
            ),
            _categoryHotspot(
              category: InventoryCategory.equipment,
              semanticLabel: 'Ekipman',
              normalizedRect: const Rect.fromLTWH(0.014, 0.188, 0.250, 0.047),
            ),
            _categoryHotspot(
              category: InventoryCategory.runes,
              semanticLabel: 'Runeler',
              normalizedRect: const Rect.fromLTWH(0.264, 0.188, 0.233, 0.047),
            ),
            _categoryHotspot(
              category: InventoryCategory.potions,
              semanticLabel: 'İksirler',
              normalizedRect: const Rect.fromLTWH(0.497, 0.188, 0.228, 0.047),
            ),
            _categoryHotspot(
              category: InventoryCategory.materials,
              semanticLabel: 'Malzemeler',
              normalizedRect: const Rect.fromLTWH(0.725, 0.188, 0.247, 0.047),
            ),
            _hotspot(
              id: 'inventory.search',
              semanticLabel: 'Eşya Ara',
              normalizedRect: const Rect.fromLTWH(0.045, 0.244, 0.374, 0.037),
              callback: onSearch,
            ),
            _hotspot(
              id: 'inventory.filter',
              semanticLabel: 'Filtre',
              normalizedRect: const Rect.fromLTWH(0.440, 0.244, 0.185, 0.037),
              callback: onFilter,
            ),
            _hotspot(
              id: 'inventory.sort',
              semanticLabel: 'Sırala',
              normalizedRect: const Rect.fromLTWH(0.634, 0.244, 0.180, 0.037),
              callback: onSort,
            ),
            _viewHotspot(
              mode: InventoryViewMode.grid,
              semanticLabel: 'Izgara Görünümü',
              normalizedRect: const Rect.fromLTWH(0.824, 0.242, 0.067, 0.040),
            ),
            _viewHotspot(
              mode: InventoryViewMode.list,
              semanticLabel: 'Liste Görünümü',
              normalizedRect: const Rect.fromLTWH(0.893, 0.242, 0.064, 0.040),
            ),
            for (var index = 0; index < itemRects.length; index++)
              _itemHotspot(index: index, normalizedRect: itemRects[index]),
            _hotspot(
              id: 'inventory.bulk-actions',
              semanticLabel: 'Toplu İşlemler',
              normalizedRect: const Rect.fromLTWH(0.646, 0.855, 0.302, 0.042),
              callback: onBulkActions,
            ),
            _rootHotspot(
              destination: InventoryRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: InventoryRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: InventoryRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: InventoryRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.600, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: InventoryRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.800, 0.906, 0.200, 0.094),
            ),
          ],
        ),
      ),
    );
  }
}
