import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum WorldProgressionRootDestination { home, adventure, battle, hero, profile }

/// Canonical World Progression screen from VIS_0218.
///
/// The approved artwork is the UI. Region/location and reward actions stay
/// caller-owned until their authoritative child routes or engines are present.
class WorldProgressionScreen extends StatelessWidget {
  const WorldProgressionScreen({
    super.key,
    this.onBack,
    this.onHeroProfile,
    this.onNotifications,
    this.onSettings,
    this.onRegionSelect,
    this.onAncientTree,
    this.onLostRuneCave,
    this.onWaterfallTemple,
    this.onWindCliffs,
    this.onShowNextTarget,
    this.onBossPreview,
    this.onRewardPreview,
    this.onRootNavigate,
    this.bossUnlocked = false,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/01_CANONICAL_FINAL/'
      'VIS_0218__P1_WORLD_PROGRESSION_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final VoidCallback? onHeroProfile;
  final VoidCallback? onNotifications;
  final VoidCallback? onSettings;
  final VoidCallback? onRegionSelect;
  final VoidCallback? onAncientTree;
  final VoidCallback? onLostRuneCave;
  final VoidCallback? onWaterfallTemple;
  final VoidCallback? onWindCliffs;
  final VoidCallback? onShowNextTarget;
  final VoidCallback? onBossPreview;
  final VoidCallback? onRewardPreview;
  final ValueChanged<WorldProgressionRootDestination>? onRootNavigate;
  final bool bossUnlocked;
  final bool battleRootEnabled;

  ArtworkHotspot _hotspot({
    required String id,
    required String semanticLabel,
    required Rect normalizedRect,
    required VoidCallback? callback,
    bool enabled = true,
  }) {
    final active = enabled && callback != null;
    return ArtworkHotspot(
      id: id,
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: active,
      onTap: active ? callback : () {},
    );
  }

  ArtworkHotspot _rootHotspot({
    required WorldProgressionRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != WorldProgressionRootDestination.battle ||
            battleRootEnabled);
    return ArtworkHotspot(
      id: 'world-progression.nav-${destination.name}',
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
              id: 'world-progression.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(
                0.0200,
                0.0550,
                0.0750,
                0.0450,
              ),
              callback: onBack,
            ),
            _hotspot(
              id: 'world-progression.hero-profile',
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(
                0.0150,
                0.0030,
                0.3150,
                0.0500,
              ),
              callback: onHeroProfile,
            ),
            _hotspot(
              id: 'world-progression.notifications',
              semanticLabel: 'Bildirimler',
              normalizedRect: const Rect.fromLTWH(
                0.8000,
                0.0060,
                0.0750,
                0.0450,
              ),
              callback: onNotifications,
            ),
            _hotspot(
              id: 'world-progression.settings',
              semanticLabel: 'Ayarlar',
              normalizedRect: const Rect.fromLTWH(
                0.8950,
                0.0060,
                0.0750,
                0.0450,
              ),
              callback: onSettings,
            ),
            _hotspot(
              id: 'world-progression.region-select',
              semanticLabel: 'Bölge Seç',
              normalizedRect: const Rect.fromLTWH(
                0.7850,
                0.0550,
                0.1850,
                0.0400,
              ),
              callback: onRegionSelect,
            ),
            _hotspot(
              id: 'world-progression.ancient-tree',
              semanticLabel: 'Kadim Ağaç',
              normalizedRect: const Rect.fromLTWH(
                0.2450,
                0.2100,
                0.1750,
                0.0650,
              ),
              callback: onAncientTree,
            ),
            _hotspot(
              id: 'world-progression.lost-rune-cave',
              semanticLabel: 'Kayıp Rün Mağarası',
              normalizedRect: const Rect.fromLTWH(
                0.4850,
                0.2450,
                0.2000,
                0.0800,
              ),
              callback: onLostRuneCave,
            ),
            _hotspot(
              id: 'world-progression.waterfall-temple',
              semanticLabel: 'Şelale Tapınağı',
              normalizedRect: const Rect.fromLTWH(
                0.3450,
                0.3200,
                0.1700,
                0.0650,
              ),
              callback: onWaterfallTemple,
            ),
            _hotspot(
              id: 'world-progression.wind-cliffs',
              semanticLabel: 'Rüzgar Kayalıkları',
              normalizedRect: const Rect.fromLTWH(
                0.5900,
                0.3550,
                0.1950,
                0.0650,
              ),
              callback: onWindCliffs,
            ),
            _hotspot(
              id: 'world-progression.show-next-target',
              semanticLabel: 'Haritada Göster',
              normalizedRect: const Rect.fromLTWH(
                0.0460,
                0.7420,
                0.2950,
                0.0330,
              ),
              callback: onShowNextTarget,
            ),
            _hotspot(
              id: 'world-progression.boss-preview',
              semanticLabel: bossUnlocked
                  ? "Boss'u İncele"
                  : "Boss'u İncele (Kilitli)",
              normalizedRect: const Rect.fromLTWH(
                0.6500,
                0.7420,
                0.2950,
                0.0330,
              ),
              callback: onBossPreview,
            ),
            _hotspot(
              id: 'world-progression.reward-preview',
              semanticLabel: 'Ödülü Ön İzle',
              normalizedRect: const Rect.fromLTWH(
                0.7200,
                0.8520,
                0.2250,
                0.0360,
              ),
              callback: onRewardPreview,
            ),
            _rootHotspot(
              destination: WorldProgressionRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(
                0.0000,
                0.9100,
                0.2000,
                0.0850,
              ),
            ),
            _rootHotspot(
              destination: WorldProgressionRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(
                0.2000,
                0.9100,
                0.2000,
                0.0850,
              ),
            ),
            _rootHotspot(
              destination: WorldProgressionRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(
                0.4000,
                0.9100,
                0.2000,
                0.0850,
              ),
            ),
            _rootHotspot(
              destination: WorldProgressionRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(
                0.6000,
                0.9100,
                0.2000,
                0.0850,
              ),
            ),
            _rootHotspot(
              destination: WorldProgressionRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(
                0.8000,
                0.9100,
                0.2000,
                0.0850,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
