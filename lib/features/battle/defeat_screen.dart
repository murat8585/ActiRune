import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/feature_unavailable_dialog.dart';
import 'battle_session_engine.dart';

class DefeatScreen extends StatelessWidget {
  const DefeatScreen({
    super.key,
    required this.session,
    required this.onRewardedRetryRequested,
    required this.onReturnToAdventure,
    required this.onViewTactics,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_p0_battle/'
      'P0_DEFEAT_FINAL_CANDIDATE.png';
  static const artworkSize = Size(941, 1672);

  final BattleSessionEngine session;
  final VoidCallback onRewardedRetryRequested;
  final VoidCallback onReturnToAdventure;
  final VoidCallback onViewTactics;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: session,
      builder: (context, _) {
        final remaining = session.snapshot.rewardedRetriesRemaining;
        final retryEnabled =
            session.snapshot.phase == BattleSessionPhase.defeat &&
            remaining > 0;

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            top: false,
            bottom: false,
            child: ArtworkInteractionSurface(
              assetPath: DefeatScreen.artworkAsset,
              sourceSize: DefeatScreen.artworkSize,
              hotspots: [
                ArtworkHotspot(
                  id: 'defeat.rewarded-retry',
                  semanticLabel: 'Reklam İzle ve Tekrar Savaş',
                  normalizedRect: const Rect.fromLTWH(
                    0.142,
                    0.812,
                    0.716,
                    0.055,
                  ),
                  onTap: () {
                    if (retryEnabled) {
                      onRewardedRetryRequested();
                    } else {
                      FeatureUnavailableDialog.show(
                        context,
                        feature: 'Tekrar savaş',
                        message: 'Bu oturumda kullanılabilir tekrar hakkı yok.',
                      );
                    }
                  },
                ),
                ArtworkHotspot(
                  id: 'defeat.return-adventure',
                  semanticLabel: 'Maceraya Dön',
                  normalizedRect: const Rect.fromLTWH(
                    0.070,
                    0.876,
                    0.434,
                    0.046,
                  ),
                  onTap: onReturnToAdventure,
                ),
                ArtworkHotspot(
                  id: 'defeat.view-tactics',
                  semanticLabel: 'Taktiği Gör',
                  normalizedRect: const Rect.fromLTWH(
                    0.535,
                    0.876,
                    0.393,
                    0.046,
                  ),
                  onTap: onViewTactics,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
