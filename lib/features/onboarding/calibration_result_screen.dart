import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

/// Canonical calibration-success result.
///
/// It must only be rendered after an owning calibration engine has reported
/// success. Readiness rows and movement cards are status information, not
/// interactive controls.
class CalibrationResultScreen extends StatelessWidget {
  const CalibrationResultScreen({
    super.key,
    required this.onStartAdventure,
    required this.onRecalibrate,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_remaining_13/'
      '06_CALIBRATION_RESULT_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback onStartAdventure;
  final VoidCallback onRecalibrate;

  @override
  Widget build(BuildContext context) {
    return ArtworkInteractionSurface(
      assetPath: artworkAsset,
      sourceSize: artworkSize,
      hotspots: [
        ArtworkHotspot(
          id: 'calibration-result.start-adventure',
          semanticLabel: 'İlk Macerana Başla',
          normalizedRect: const Rect.fromLTWH(0.125, 0.817, 0.750, 0.067),
          onTap: onStartAdventure,
        ),
        ArtworkHotspot(
          id: 'calibration-result.recalibrate',
          semanticLabel: 'Tekrar Kalibre Et',
          normalizedRect: const Rect.fromLTWH(0.250, 0.895, 0.500, 0.052),
          onTap: onRecalibrate,
        ),
      ],
    );
  }
}
