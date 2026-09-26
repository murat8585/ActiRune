import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import 'hero_item_state.dart';

export 'hero_item_state.dart' show EquipmentSlot;

enum EquipmentRootDestination { home, adventure, battle, hero, profile }

/// Selected P1 Equipment candidate wired as an artwork-first child screen.
///
/// The image remains a visual-authority candidate until the global runtime
/// audit promotes it. This widget does not draw duplicate visible controls.
class EquipmentScreen extends StatelessWidget {
  const EquipmentScreen({
    super.key,
    this.onBack,
    this.onInfo,
    this.onSlot,
    this.onSelectedItem,
    this.onInventory,
    this.onPresets,
    this.onRootNavigate,
    this.itemOwner,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_p1/02_P1_EQUIPMENT_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final VoidCallback? onInfo;
  final ValueChanged<EquipmentSlot>? onSlot;
  final VoidCallback? onSelectedItem;
  final VoidCallback? onInventory;
  final VoidCallback? onPresets;
  final ValueChanged<EquipmentRootDestination>? onRootNavigate;
  final HeroItemOwner? itemOwner;
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

  ArtworkHotspot _slotHotspot({
    required EquipmentSlot slot,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onSlot;
    return ArtworkHotspot(
      id: 'equipment.slot-${slot.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null || itemOwner != null,
      onTap: () {
        itemOwner?.selectSlot(slot);
        callback?.call(slot);
      },
    );
  }

  ArtworkHotspot _rootHotspot({
    required EquipmentRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != EquipmentRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'equipment.nav-${destination.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: enabled,
      onTap: enabled ? () => callback(destination) : () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (itemOwner != null) {
      return AnimatedBuilder(
        animation: itemOwner!,
        builder: (context, _) => _buildScreen(),
      );
    }
    return _buildScreen();
  }

  Widget _buildScreen() {
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
              id: 'equipment.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.018, 0.014, 0.092, 0.064),
              callback: onBack,
            ),
            _hotspot(
              id: 'equipment.info',
              semanticLabel: 'Bilgi',
              normalizedRect: const Rect.fromLTWH(0.882, 0.015, 0.088, 0.064),
              callback: onInfo,
            ),
            _slotHotspot(
              slot: EquipmentSlot.weapon,
              semanticLabel: 'Silah',
              normalizedRect: const Rect.fromLTWH(0.020, 0.182, 0.202, 0.136),
            ),
            _slotHotspot(
              slot: EquipmentSlot.helmet,
              semanticLabel: 'Miğfer',
              normalizedRect: const Rect.fromLTWH(0.020, 0.323, 0.202, 0.128),
            ),
            _slotHotspot(
              slot: EquipmentSlot.gloves,
              semanticLabel: 'Eldiven',
              normalizedRect: const Rect.fromLTWH(0.020, 0.457, 0.202, 0.128),
            ),
            _slotHotspot(
              slot: EquipmentSlot.ring,
              semanticLabel: 'Yüzük',
              normalizedRect: const Rect.fromLTWH(0.020, 0.590, 0.202, 0.128),
            ),
            _slotHotspot(
              slot: EquipmentSlot.necklace,
              semanticLabel: 'Kolye',
              normalizedRect: const Rect.fromLTWH(0.773, 0.182, 0.202, 0.136),
            ),
            _slotHotspot(
              slot: EquipmentSlot.chest,
              semanticLabel: 'Göğüslük',
              normalizedRect: const Rect.fromLTWH(0.773, 0.323, 0.202, 0.128),
            ),
            _slotHotspot(
              slot: EquipmentSlot.boots,
              semanticLabel: 'Çizme',
              normalizedRect: const Rect.fromLTWH(0.773, 0.457, 0.202, 0.128),
            ),
            _slotHotspot(
              slot: EquipmentSlot.rune,
              semanticLabel: 'Rune Slotu',
              normalizedRect: const Rect.fromLTWH(0.773, 0.590, 0.202, 0.128),
            ),
            _hotspot(
              id: 'equipment.selected-item',
              semanticLabel: 'Seçili Eşya Detayı',
              normalizedRect: const Rect.fromLTWH(0.236, 0.458, 0.531, 0.151),
              callback: onSelectedItem,
            ),
            _hotspot(
              id: 'equipment.equip-selected',
              semanticLabel: 'Seçili eşyayı tak',
              normalizedRect: const Rect.fromLTWH(.25, .62, .23, .07),
              callback:
                  itemOwner?.selectedItem?.compatibleSlots.contains(
                        itemOwner!.selectedSlot,
                      ) ==
                      true
                  ? () => itemOwner!.equip(
                      itemOwner!.selectedItem!.id,
                      itemOwner!.selectedSlot,
                    )
                  : null,
            ),
            _hotspot(
              id: 'equipment.unequip',
              semanticLabel: 'Seçili slottaki eşyayı çıkar',
              normalizedRect: const Rect.fromLTWH(.52, .62, .23, .07),
              callback:
                  itemOwner?.equippedItemIds.containsKey(
                        itemOwner!.selectedSlot,
                      ) ==
                      true
                  ? () => itemOwner!.unequip(itemOwner!.selectedSlot)
                  : null,
            ),
            _hotspot(
              id: 'equipment.inventory',
              semanticLabel: 'Ekipman Envanteri',
              normalizedRect: const Rect.fromLTWH(0.020, 0.777, 0.462, 0.087),
              callback: onInventory,
            ),
            _hotspot(
              id: 'equipment.presets',
              semanticLabel: 'Ön Ayarlar',
              normalizedRect: const Rect.fromLTWH(0.500, 0.777, 0.467, 0.087),
              callback: onPresets,
            ),
            _rootHotspot(
              destination: EquipmentRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, 0.883, 0.200, 0.117),
            ),
            _rootHotspot(
              destination: EquipmentRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, 0.883, 0.200, 0.117),
            ),
            _rootHotspot(
              destination: EquipmentRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, 0.883, 0.200, 0.117),
            ),
            _rootHotspot(
              destination: EquipmentRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.600, 0.883, 0.200, 0.117),
            ),
            _rootHotspot(
              destination: EquipmentRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.800, 0.883, 0.200, 0.117),
            ),
          ],
        ),
      ),
    );
  }
}
