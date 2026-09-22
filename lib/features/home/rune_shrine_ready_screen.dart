import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum RuneShrineReadyRootDestination { home, adventure, battle, hero, profile }

/// Canonical Rune Shrine ready state from VIS_0225.
///
/// The optional rewarded-ad action stays caller-owned. This screen never
/// grants a rune or advances to the result state by itself.
class RuneShrineReadyScreen extends StatelessWidget {
  const RuneShrineReadyScreen({
    super.key,
    this.onClose,
    this.onOpenGift,
    this.onNotNow,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/01_CANONICAL_FINAL/'
      'VIS_0225__P1_RUNE_SHRINE_READY_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onClose;
  final VoidCallback? onOpenGift;
  final VoidCallback? onNotNow;
  final ValueChanged<RuneShrineReadyRootDestination>? onRootNavigate;
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
    required RuneShrineReadyRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != RuneShrineReadyRootDestination.battle ||
            battleRootEnabled);
    return ArtworkHotspot(
      id: 'rune-shrine-ready.nav-${destination.name}',
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
              id: 'rune-shrine-ready.close',
              semanticLabel: 'Rün Tapınağını kapat',
              normalizedRect: const Rect.fromLTWH(
                0.8950,
                0.1320,
                0.0800,
                0.0650,
              ),
              callback: onClose,
            ),
            _hotspot(
              id: 'rune-shrine-ready.open-gift',
              semanticLabel: 'Rün hediyesini aç',
              normalizedRect: const Rect.fromLTWH(
                0.2250,
                0.6650,
                0.5500,
                0.0700,
              ),
              callback: onOpenGift,
            ),
            _hotspot(
              id: 'rune-shrine-ready.not-now',
              semanticLabel: 'Şimdi değil',
              normalizedRect: const Rect.fromLTWH(
                0.3100,
                0.7520,
                0.3800,
                0.0500,
              ),
              callback: onNotNow,
            ),
            _rootHotspot(
              destination: RuneShrineReadyRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(
                0.0100,
                0.8650,
                0.1950,
                0.0900,
              ),
            ),
            _rootHotspot(
              destination: RuneShrineReadyRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(
                0.2050,
                0.8650,
                0.1980,
                0.0900,
              ),
            ),
            _rootHotspot(
              destination: RuneShrineReadyRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(
                0.4030,
                0.8650,
                0.1820,
                0.0900,
              ),
            ),
            _rootHotspot(
              destination: RuneShrineReadyRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(
                0.5850,
                0.8650,
                0.2000,
                0.0900,
              ),
            ),
            _rootHotspot(
              destination: RuneShrineReadyRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(
                0.7850,
                0.8650,
                0.1950,
                0.0900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
