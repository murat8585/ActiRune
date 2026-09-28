import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/clean_base_text.dart';
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
      'assets/ui/clean_base_final_60/49__LATE_QA_POS_19__PASS.png';
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
                const ArtworkOverlay(
                  id: 'defeat.title',
                  normalizedRect: Rect.fromLTWH(0.165, 0.415, 0.670, 0.060),
                  child: CleanBaseText('YENİLDİN', fontSize: 32),
                ),
                const ArtworkOverlay(
                  id: 'defeat.retry-title',
                  normalizedRect: Rect.fromLTWH(0.365, 0.748, 0.280, 0.040),
                  child: CleanBaseText('SON BİR ŞANS', fontSize: 17),
                ),
                ArtworkOverlay(
                  id: 'defeat.retry-count',
                  normalizedRect: const Rect.fromLTWH(0.385, 0.795, 0.200, 0.035),
                  child: CleanBaseText(
                    '$remaining / 3',
                    fontSize: 18,
                    background: const Color(0xAA071827),
                  ),
                ),
                ArtworkOverlay(
                  id: 'defeat.retry-label',
                  normalizedRect: const Rect.fromLTWH(0.635, 0.795, 0.260, 0.045),
                  child: CleanBaseText(
                    'TEKRAR SAVAŞ',
                    fontSize: 16,
                    color: retryEnabled ? Colors.white : Colors.white54,
                  ),
                ),
                const ArtworkOverlay(
                  id: 'defeat.return-label',
                  normalizedRect: Rect.fromLTWH(0.070, 0.915, 0.400, 0.050),
                  child: CleanBaseText('MACERAYA DÖN', fontSize: 18),
                ),
                const ArtworkOverlay(
                  id: 'defeat.tactics-label',
                  normalizedRect: Rect.fromLTWH(0.555, 0.915, 0.365, 0.050),
                  child: CleanBaseText('TAKTİĞİ GÖR', fontSize: 17),
                ),
                if (!retryEnabled)
                  const ArtworkOverlay(
                    id: 'defeat.retry-disabled',
                    normalizedRect: Rect.fromLTWH(0.605, 0.760, 0.330, 0.100),
                    child: ColoredBox(color: Color(0x66000000)),
                  ),
              ],
              hotspots: [
                ArtworkHotspot(
                  id: 'defeat.rewarded-retry',
                  semanticLabel: 'Tekrar Savaş',
                  normalizedRect: const Rect.fromLTWH(0.605, 0.760, 0.330, 0.100),
                  enabled: retryEnabled,
                  onTap: onRewardedRetryRequested,
                ),
                ArtworkHotspot(
                  id: 'defeat.return-adventure',
                  semanticLabel: 'Maceraya Dön',
                  normalizedRect: const Rect.fromLTWH(0.035, 0.880, 0.460, 0.105),
                  onTap: onReturnToAdventure,
                ),
                ArtworkHotspot(
                  id: 'defeat.view-tactics',
                  semanticLabel: 'Taktiği Gör',
                  normalizedRect: const Rect.fromLTWH(0.525, 0.880, 0.440, 0.105),
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
