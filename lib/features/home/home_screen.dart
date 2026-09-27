import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum HomeRootDestination { home, adventure, battle, hero, profile }

/// Canonical Home clean-base screen.
///
/// The clean-base artwork itself is the UI. Visible actions are exposed only
/// through transparent hotspots; mutable text/data is rendered by Flutter at
/// runtime where needed.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    this.onDailyStreak,
    this.onMessages,
    this.onQuests,
    this.onEvents,
    this.onSettings,
    this.onWorldMap,
    this.onYesterdaySummary,
    this.onRewards,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'assets/ui/clean_base_final_60/01__ORIGINAL_OUTPUT_22__PASS.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onDailyStreak;
  final VoidCallback? onMessages;
  final VoidCallback? onQuests;
  final VoidCallback? onEvents;
  final VoidCallback? onSettings;
  final VoidCallback? onWorldMap;
  final VoidCallback? onYesterdaySummary;
  final VoidCallback? onRewards;
  final ValueChanged<HomeRootDestination>? onRootNavigate;
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

  ArtworkHotspot _rootHotspot({
    required HomeRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != HomeRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'home.nav-${destination.name}',
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
              id: 'home.daily-streak',
              semanticLabel: 'Günlük Seri',
              normalizedRect: const Rect.fromLTWH(0.6700, 0.0180, 0.3020, 0.0830),
              callback: onDailyStreak,
            ),
            _hotspot(
              id: 'home.messages',
              semanticLabel: 'Mesajlar',
              normalizedRect: const Rect.fromLTWH(0.0200, 0.1300, 0.1050, 0.0650),
              callback: onMessages,
            ),
            _hotspot(
              id: 'home.quests',
              semanticLabel: 'Görevler',
              normalizedRect: const Rect.fromLTWH(0.0200, 0.1980, 0.1050, 0.0670),
              callback: onQuests,
            ),
            _hotspot(
              id: 'home.events',
              semanticLabel: 'Etkinlikler',
              normalizedRect: const Rect.fromLTWH(0.0200, 0.2680, 0.1050, 0.0680),
              callback: onEvents,
            ),
            _hotspot(
              id: 'home.settings',
              semanticLabel: 'Ayarlar',
              normalizedRect: const Rect.fromLTWH(0.8680, 0.1450, 0.1120, 0.0670),
              callback: onSettings,
            ),
            _hotspot(
              id: 'home.world-map',
              semanticLabel: 'Dünya Haritası',
              normalizedRect: const Rect.fromLTWH(0.7000, 0.6380, 0.2300, 0.0440),
              callback: onWorldMap,
            ),
            _hotspot(
              id: 'home.yesterday-summary',
              semanticLabel: 'Dünün Özeti',
              normalizedRect: const Rect.fromLTWH(0.0350, 0.7950, 0.4550, 0.0720),
              callback: onYesterdaySummary,
            ),
            _hotspot(
              id: 'home.rewards',
              semanticLabel: 'Ödüller',
              normalizedRect: const Rect.fromLTWH(0.5100, 0.7950, 0.4450, 0.0720),
              callback: onRewards,
            ),
            _rootHotspot(
              destination: HomeRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.0100, 0.8840, 0.1950, 0.0940),
            ),
            _rootHotspot(
              destination: HomeRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.2050, 0.8840, 0.1980, 0.0940),
            ),
            _rootHotspot(
              destination: HomeRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.4030, 0.8840, 0.1820, 0.0940),
            ),
            _rootHotspot(
              destination: HomeRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.5850, 0.8840, 0.2000, 0.0940),
            ),
            _rootHotspot(
              destination: HomeRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.7850, 0.8840, 0.1950, 0.0940),
            ),
          ],
        ),
      ),
    );
  }
}
