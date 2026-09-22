import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum RuneShrineResultRootDestination { home, adventure, battle, hero, profile }

/// Exact-art Rune Shrine reward result.
///
/// The current integration branch does not yet contain the authoritative
/// shrine cooldown/reward engine or a proven parent entry route. This screen
/// therefore exposes only the controls visible in the approved result artwork
/// and leaves navigation/state ownership to its caller.
class RuneShrineResultScreen extends StatelessWidget {
  const RuneShrineResultScreen({
    super.key,
    required this.onBack,
    this.onInspectRune,
    this.onContinue,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_remaining_13/'
      '07_RUNE_SHRINE_RESULT_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback onBack;
  final VoidCallback? onInspectRune;
  final VoidCallback? onContinue;
  final ValueChanged<RuneShrineResultRootDestination>? onRootNavigate;
  final bool battleRootEnabled;

  ArtworkHotspot _optionalHotspot({
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
    required RuneShrineResultRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != RuneShrineResultRootDestination.battle ||
            battleRootEnabled);
    return ArtworkHotspot(
      id: 'rune-shrine-result.nav-${destination.name}',
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
            ArtworkHotspot(
              id: 'rune-shrine-result.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.014, 0.012, 0.073, 0.046),
              onTap: onBack,
            ),
            _optionalHotspot(
              id: 'rune-shrine-result.inspect',
              semanticLabel: 'Rune’yi İncele',
              normalizedRect: const Rect.fromLTWH(0.174, 0.741, 0.640, 0.061),
              callback: onInspectRune,
            ),
            _optionalHotspot(
              id: 'rune-shrine-result.continue',
              semanticLabel: 'Devam Et',
              normalizedRect: const Rect.fromLTWH(0.291, 0.816, 0.408, 0.047),
              callback: onContinue,
            ),
            _rootHotspot(
              destination: RuneShrineResultRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.010, 0.899, 0.190, 0.092),
            ),
            _rootHotspot(
              destination: RuneShrineResultRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, 0.899, 0.200, 0.092),
            ),
            _rootHotspot(
              destination: RuneShrineResultRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, 0.899, 0.195, 0.092),
            ),
            _rootHotspot(
              destination: RuneShrineResultRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.595, 0.899, 0.205, 0.092),
            ),
            _rootHotspot(
              destination: RuneShrineResultRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.800, 0.899, 0.190, 0.092),
            ),
          ],
        ),
      ),
    );
  }
}
