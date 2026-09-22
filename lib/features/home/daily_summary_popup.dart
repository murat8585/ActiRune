import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

/// Exact-art Daily Summary popup.
///
/// The approved artwork is the UI. Flutter contributes only transparent
/// interaction regions and delegates product actions to the owner.
class DailySummaryPopup extends StatelessWidget {
  const DailySummaryPopup({
    super.key,
    required this.onClose,
    required this.onContinueToday,
    required this.onAdventureProgress,
    this.onViewDetails,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_remaining_13/'
      '03_DAILY_SUMMARY_POPUP_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback onClose;
  final VoidCallback onContinueToday;
  final VoidCallback onAdventureProgress;

  /// A deeper stats/details destination is intentionally owner-supplied.
  /// The current integration branch has no authoritative details route.
  final VoidCallback? onViewDetails;

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
            id: 'daily-summary.close',
            semanticLabel: 'Dünün Özetini Kapat',
            normalizedRect: const Rect.fromLTWH(0.823, 0.086, 0.072, 0.044),
            onTap: onClose,
          ),
          ArtworkHotspot(
            id: 'daily-summary.adventure-progress',
            semanticLabel: 'Macera İlerlemesini Gör',
            normalizedRect: const Rect.fromLTWH(0.098, 0.620, 0.797, 0.074),
            onTap: onAdventureProgress,
          ),
          ArtworkHotspot(
            id: 'daily-summary.continue-today',
            semanticLabel: 'Bugüne Devam Et',
            normalizedRect: const Rect.fromLTWH(0.099, 0.868, 0.416, 0.049),
            onTap: onContinueToday,
          ),
          _actionHotspot(
            id: 'daily-summary.view-details',
            semanticLabel: 'Detayları Gör',
            normalizedRect: const Rect.fromLTWH(0.523, 0.868, 0.371, 0.049),
            callback: onViewDetails,
          ),
        ],
      ),
    );
  }
}
