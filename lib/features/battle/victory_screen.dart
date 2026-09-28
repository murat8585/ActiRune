import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/clean_base_text.dart';

class VictoryScreen extends StatelessWidget {
  const VictoryScreen({
    super.key,
    required this.onContinue,
    required this.onReplay,
    required this.onViewRewards,
  });

  static const artworkAsset =
      'assets/ui/clean_base_final_60/48__LATE_QA_POS_18__PASS.png';
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
          overlays: const [
            ArtworkOverlay(
              id: 'victory.title',
              normalizedRect: Rect.fromLTWH(0.165, 0.410, 0.670, 0.065),
              child: CleanBaseText('ZAFER!', fontSize: 34),
            ),
            ArtworkOverlay(
              id: 'victory.rewards-label',
              normalizedRect: Rect.fromLTWH(0.330, 0.515, 0.340, 0.040),
              child: CleanBaseText('KAZANILAN ÖDÜLLER', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'victory.continue-label',
              normalizedRect: Rect.fromLTWH(0.070, 0.895, 0.500, 0.052),
              child: CleanBaseText('DEVAM ET', fontSize: 21),
            ),
            ArtworkOverlay(
              id: 'victory.replay-label',
              normalizedRect: Rect.fromLTWH(0.635, 0.895, 0.285, 0.052),
              child: CleanBaseText('TEKRAR OYNA', fontSize: 16),
            ),
          ],
          hotspots: [
            ArtworkHotspot(
              id: 'victory.continue',
              semanticLabel: 'Devam Et',
              normalizedRect: const Rect.fromLTWH(0.045, 0.865, 0.545, 0.100),
              onTap: onContinue,
            ),
            ArtworkHotspot(
              id: 'victory.replay',
              semanticLabel: 'Tekrar Oyna',
              normalizedRect: const Rect.fromLTWH(0.610, 0.865, 0.355, 0.100),
              onTap: onReplay,
            ),
            ArtworkHotspot(
              id: 'victory.view-rewards',
              semanticLabel: 'Ödülleri Gör',
              normalizedRect: const Rect.fromLTWH(0.030, 0.515, 0.940, 0.215),
              onTap: onViewRewards,
            ),
          ],
        ),
      ),
    );
  }
}
