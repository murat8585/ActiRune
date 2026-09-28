import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/clean_base_text.dart';

enum AdventureRootDestination { home, adventure, battle, hero, profile }

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
      'assets/ui/clean_base_final_60/33__EARLY_QA_POS_26__PASS.png';
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
    const navY = 0.910;
    const navH = 0.082;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: artworkAsset,
          sourceSize: artworkSize,
          overlays: const [
            ArtworkOverlay(
              id: 'adventure.title',
              normalizedRect: Rect.fromLTWH(0.325, 0.390, 0.350, 0.050),
              child: CleanBaseText('MACERA', fontSize: 24),
            ),
            ArtworkOverlay(
              id: 'adventure.story-label',
              normalizedRect: Rect.fromLTWH(0.055, 0.638, 0.270, 0.042),
              child: CleanBaseText('BÖLÜM HİKAYESİ', fontSize: 15),
            ),
            ArtworkOverlay(
              id: 'adventure.map-label',
              normalizedRect: Rect.fromLTWH(0.365, 0.638, 0.270, 0.042),
              child: CleanBaseText('DÜNYA HARİTASI', fontSize: 15),
            ),
            ArtworkOverlay(
              id: 'adventure.encounter-label',
              normalizedRect: Rect.fromLTWH(0.675, 0.638, 0.270, 0.042),
              child: CleanBaseText('SONRAKİ SAVAŞ', fontSize: 15),
            ),
            ArtworkOverlay(
              id: 'adventure.log-label',
              normalizedRect: Rect.fromLTWH(0.330, 0.785, 0.340, 0.040),
              child: CleanBaseText('MACERA GÜNLÜĞÜ', fontSize: 15),
            ),
            ArtworkOverlay(
              id: 'adventure.nav-home-label',
              normalizedRect: Rect.fromLTWH(0.000, navY + 0.050, 0.200, 0.026),
              child: CleanBaseText('Ana Dünya', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'adventure.nav-adventure-label',
              normalizedRect: Rect.fromLTWH(0.200, navY + 0.050, 0.200, 0.026),
              child: CleanBaseText('Macera', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'adventure.nav-battle-label',
              normalizedRect: Rect.fromLTWH(0.400, navY + 0.050, 0.190, 0.026),
              child: CleanBaseText('Savaş', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'adventure.nav-hero-label',
              normalizedRect: Rect.fromLTWH(0.590, navY + 0.050, 0.200, 0.026),
              child: CleanBaseText('Kahraman', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'adventure.nav-profile-label',
              normalizedRect: Rect.fromLTWH(0.790, navY + 0.050, 0.210, 0.026),
              child: CleanBaseText('Profil', fontSize: 12, background: Colors.transparent),
            ),
          ],
          hotspots: [
            _hotspot(
              id: 'adventure.daily-streak',
              semanticLabel: 'Günlük Seri',
              normalizedRect: const Rect.fromLTWH(0.650, 0.015, 0.210, 0.065),
              callback: onDailyStreak,
            ),
            _hotspot(
              id: 'adventure.messages',
              semanticLabel: 'Mesajlar',
              normalizedRect: const Rect.fromLTWH(0.890, 0.095, 0.095, 0.065),
              callback: onMessages,
            ),
            _hotspot(
              id: 'adventure.events',
              semanticLabel: 'Etkinlikler',
              normalizedRect: const Rect.fromLTWH(0.890, 0.165, 0.095, 0.065),
              callback: onEvents,
            ),
            _hotspot(
              id: 'adventure.settings',
              semanticLabel: 'Ayarlar',
              normalizedRect: const Rect.fromLTWH(0.870, 0.012, 0.120, 0.065),
              callback: onSettings,
            ),
            _hotspot(
              id: 'adventure.quests',
              semanticLabel: 'Görevler',
              normalizedRect: const Rect.fromLTWH(0.015, 0.230, 0.105, 0.085),
              callback: onQuests,
            ),
            _hotspot(
              id: 'adventure.story',
              semanticLabel: 'Bölüm Hikayesi',
              normalizedRect: const Rect.fromLTWH(0.020, 0.500, 0.305, 0.190),
              callback: onStory,
            ),
            _hotspot(
              id: 'adventure.world-map',
              semanticLabel: 'Dünya Haritası',
              normalizedRect: const Rect.fromLTWH(0.347, 0.500, 0.306, 0.190),
              callback: onWorldMap,
            ),
            _hotspot(
              id: 'adventure.encounter-preview',
              semanticLabel: 'Sonraki Savaşa Hazırlan',
              normalizedRect: const Rect.fromLTWH(0.675, 0.500, 0.305, 0.190),
              callback: onEncounterPreview,
            ),
            _hotspot(
              id: 'adventure.log',
              semanticLabel: 'Macera Günlüğü',
              normalizedRect: const Rect.fromLTWH(0.330, 0.720, 0.340, 0.135),
              callback: onAdventureLog,
            ),
            _rootHotspot(
              destination: AdventureRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, navY, 0.200, navH),
            ),
            _rootHotspot(
              destination: AdventureRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, navY, 0.200, navH),
            ),
            _rootHotspot(
              destination: AdventureRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, navY, 0.190, navH),
            ),
            _rootHotspot(
              destination: AdventureRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.590, navY, 0.200, navH),
            ),
            _rootHotspot(
              destination: AdventureRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.790, navY, 0.210, navH),
            ),
          ],
        ),
      ),
    );
  }
}
