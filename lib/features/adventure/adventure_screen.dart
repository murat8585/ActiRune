import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum AdventureRootDestination { home, adventure, battle, hero, profile }

/// Canonical locked Adventure snapshot.
///
/// The approved artwork shows the next encounter as still 1,580 steps away.
/// Therefore the visible `HAZIR OL` control is an encounter preview/preparation
/// boundary here, not permission to enter Battle Prep. The caller may replace
/// that boundary only when a real unlocked encounter state exists.
class AdventureScreen extends StatelessWidget {
  const AdventureScreen({
    super.key,
    this.onDailyStreak,
    this.onMessages,
    this.onQuests,
    this.onEvents,
    this.onSettings,
    this.onWorldMap,
    this.onEncounterPreview,
    this.onStory,
    this.onAdventureLog,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/02_CORE_LOCKED_ANCHORS/'
      'VIS_0231__CORE_ADVENTURE_ANCHOR.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onDailyStreak;
  final VoidCallback? onMessages;
  final VoidCallback? onQuests;
  final VoidCallback? onEvents;
  final VoidCallback? onSettings;
  final VoidCallback? onWorldMap;
  final VoidCallback? onEncounterPreview;
  final VoidCallback? onStory;
  final VoidCallback? onAdventureLog;
  final ValueChanged<AdventureRootDestination>? onRootNavigate;
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
    required AdventureRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != AdventureRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'adventure.nav-${destination.name}',
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
              id: 'adventure.daily-streak',
              semanticLabel: 'Günlük Seri',
              normalizedRect: const Rect.fromLTWH(
                0.6695,
                0.0185,
                0.2976,
                0.0867,
              ),
              callback: onDailyStreak,
            ),
            _hotspot(
              id: 'adventure.messages',
              semanticLabel: 'Mesajlar',
              normalizedRect: const Rect.fromLTWH(
                0.0287,
                0.1298,
                0.0935,
                0.0616,
              ),
              callback: onMessages,
            ),
            _hotspot(
              id: 'adventure.quests',
              semanticLabel: 'Görevler',
              normalizedRect: const Rect.fromLTWH(
                0.0287,
                0.2004,
                0.0935,
                0.0622,
              ),
              callback: onQuests,
            ),
            _hotspot(
              id: 'adventure.events',
              semanticLabel: 'Etkinlikler',
              normalizedRect: const Rect.fromLTWH(
                0.0287,
                0.2715,
                0.0935,
                0.0622,
              ),
              callback: onEvents,
            ),
            _hotspot(
              id: 'adventure.settings',
              semanticLabel: 'Ayarlar',
              normalizedRect: const Rect.fromLTWH(
                0.8810,
                0.1316,
                0.0882,
                0.0604,
              ),
              callback: onSettings,
            ),
            _hotspot(
              id: 'adventure.world-map',
              semanticLabel: 'Dünya Haritası',
              normalizedRect: const Rect.fromLTWH(
                0.6642,
                0.5472,
                0.2870,
                0.1244,
              ),
              callback: onWorldMap,
            ),
            _hotspot(
              id: 'adventure.encounter-preview',
              semanticLabel: 'Hazır Ol',
              normalizedRect: const Rect.fromLTWH(
                0.6908,
                0.7464,
                0.2380,
                0.0395,
              ),
              callback: onEncounterPreview,
            ),
            _hotspot(
              id: 'adventure.story',
              semanticLabel: 'Bölüm Hikayesi',
              normalizedRect: const Rect.fromLTWH(
                0.0351,
                0.8122,
                0.4570,
                0.0550,
              ),
              callback: onStory,
            ),
            _hotspot(
              id: 'adventure.log',
              semanticLabel: 'Macera Günlüğü',
              normalizedRect: const Rect.fromLTWH(
                0.5122,
                0.8122,
                0.4538,
                0.0550,
              ),
              callback: onAdventureLog,
            ),
            _rootHotspot(
              destination: AdventureRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(
                0.0074,
                0.8828,
                0.1955,
                0.0772,
              ),
            ),
            _rootHotspot(
              destination: AdventureRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(
                0.2019,
                0.8828,
                0.2040,
                0.0772,
              ),
            ),
            _rootHotspot(
              destination: AdventureRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(
                0.4060,
                0.8828,
                0.1838,
                0.0772,
              ),
            ),
            _rootHotspot(
              destination: AdventureRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(
                0.5898,
                0.8828,
                0.2019,
                0.0772,
              ),
            ),
            _rootHotspot(
              destination: AdventureRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(
                0.7917,
                0.8828,
                0.2030,
                0.0772,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
