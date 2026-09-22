import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

/// Exact-art Weekly League Result popup.
///
/// Reward claiming and leaderboard navigation belong to their owning systems.
/// This shell renders the approved artwork and emits typed interaction bounds
/// without fabricating economy mutations or a Rune League route.
class WeeklyLeagueResultPopup extends StatelessWidget {
  const WeeklyLeagueResultPopup({
    super.key,
    required this.onClose,
    this.onClaimReward,
    this.onViewLeaderboard,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_remaining_13/'
      '04_WEEKLY_LEAGUE_RESULT_POPUP_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback onClose;
  final VoidCallback? onClaimReward;
  final VoidCallback? onViewLeaderboard;

  ArtworkHotspot _actionHotspot({
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: ArtworkInteractionSurface(
        assetPath: artworkAsset,
        sourceSize: artworkSize,
        hotspots: [
          ArtworkHotspot(
            id: 'weekly-league-result.close',
            semanticLabel: 'Haftalık Lig Sonucunu Kapat',
            normalizedRect: const Rect.fromLTWH(0.856, 0.131, 0.073, 0.045),
            onTap: onClose,
          ),
          _actionHotspot(
            id: 'weekly-league-result.claim-reward',
            semanticLabel: 'Ödülü Al',
            normalizedRect: const Rect.fromLTWH(0.084, 0.724, 0.405, 0.055),
            callback: onClaimReward,
          ),
          _actionHotspot(
            id: 'weekly-league-result.view-leaderboard',
            semanticLabel: 'Liderliği Gör',
            normalizedRect: const Rect.fromLTWH(0.511, 0.724, 0.390, 0.055),
            callback: onViewLeaderboard,
          ),
        ],
      ),
    );
  }
}
