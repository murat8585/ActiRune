import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

class VictoryScreen extends StatelessWidget {
  const VictoryScreen({
    super.key,
    required this.onContinue,
    required this.onReplay,
    required this.onViewRewards,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_p0_battle/P0_VICTORY_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback onContinue;
  final VoidCallback onReplay;
  final VoidCallback onViewRewards;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: VictoryScreen.artworkAsset,
          sourceSize: VictoryScreen.artworkSize,
          hotspots: [
            ArtworkHotspot(
              id: 'victory.continue',
              semanticLabel: 'Devam Et',
              normalizedRect: const Rect.fromLTWH(0.176, 0.812, 0.648, 0.070),
              onTap: onContinue,
            ),
            ArtworkHotspot(
              id: 'victory.replay',
              semanticLabel: 'Tekrar Oyna',
              normalizedRect: const Rect.fromLTWH(0.055, 0.897, 0.424, 0.053),
              onTap: onReplay,
            ),
            ArtworkHotspot(
              id: 'victory.view-rewards',
              semanticLabel: 'Ödülleri Gör',
              normalizedRect: const Rect.fromLTWH(0.521, 0.897, 0.420, 0.053),
              onTap: onViewRewards,
            ),
          ],
        ),
      ),
    );
  }
}
