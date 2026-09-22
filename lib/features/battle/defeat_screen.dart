import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
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
              overlays: [
                ArtworkOverlay(
                  id: 'defeat.retry-count',
                  normalizedRect: const Rect.fromLTWH(
                    0.505,
                    0.756,
                    0.088,
                    0.026,
                  ),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(color: Color(0xFF071827)),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          '$remaining / 3',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (!retryEnabled)
                  const ArtworkOverlay(
                    id: 'defeat.retry-disabled',
                    normalizedRect: Rect.fromLTWH(0.142, 0.815, 0.716, 0.050),
                    child: ColoredBox(color: Color(0x99000000)),
                  ),
              ],
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
                  enabled: retryEnabled,
                  onTap: onRewardedRetryRequested,
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
