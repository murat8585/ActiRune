import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum PlayerLevelRootDestination { home, adventure, battle, hero, profile }

class PlayerLevelScreen extends StatelessWidget {
  const PlayerLevelScreen({
    super.key,
    this.onBack,
    this.onHelp,
    this.onClaimMilestone,
    this.onAbout,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_p1/06_P1_PLAYER_LEVEL_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final VoidCallback? onHelp;
  final VoidCallback? onClaimMilestone;
  final VoidCallback? onAbout;
  final ValueChanged<PlayerLevelRootDestination>? onRootNavigate;
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
    required PlayerLevelRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != PlayerLevelRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'player-level.nav-${destination.name}',
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
              id: 'player-level.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.018, 0.008, 0.090, 0.060),
              callback: onBack,
            ),
            _hotspot(
              id: 'player-level.help',
              semanticLabel: 'Yardım',
              normalizedRect: const Rect.fromLTWH(0.873, 0.010, 0.088, 0.060),
              callback: onHelp,
            ),
            _hotspot(
              id: 'player-level.claim-level-30',
              semanticLabel: 'Seviye 30 Ödülünü Al',
              normalizedRect: const Rect.fromLTWH(0.704, 0.697, 0.145, 0.034),
              callback: onClaimMilestone,
            ),
            _hotspot(
              id: 'player-level.about',
              semanticLabel: 'Oyuncu Seviyesi Hakkında',
              normalizedRect: const Rect.fromLTWH(0.025, 0.756, 0.940, 0.096),
              callback: onAbout,
            ),
            _rootHotspot(
              destination: PlayerLevelRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, 0.874, 0.200, 0.126),
            ),
            _rootHotspot(
              destination: PlayerLevelRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, 0.874, 0.200, 0.126),
            ),
            _rootHotspot(
              destination: PlayerLevelRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, 0.874, 0.200, 0.126),
            ),
            _rootHotspot(
              destination: PlayerLevelRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.600, 0.874, 0.200, 0.126),
            ),
            _rootHotspot(
              destination: PlayerLevelRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.800, 0.874, 0.200, 0.126),
            ),
          ],
        ),
      ),
    );
  }
}
