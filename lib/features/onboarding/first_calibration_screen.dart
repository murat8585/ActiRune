import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

/// Canonical first-calibration entry screen.
///
/// This screen starts a real calibration request owned by the parent flow. It
/// never marks calibration successful by itself.
class FirstCalibrationScreen extends StatelessWidget {
  const FirstCalibrationScreen({
    super.key,
    required this.onStartCalibration,
    this.enabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/01_CANONICAL_FINAL/'
      'VIS_0180__P1_FIRST_CALIBRATION_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback onStartCalibration;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ArtworkInteractionSurface(
      assetPath: artworkAsset,
      sourceSize: artworkSize,
      hotspots: [
        ArtworkHotspot(
          id: 'first-calibration.start',
          semanticLabel: 'Kalibrasyonu Başlat',
          normalizedRect: const Rect.fromLTWH(0.190, 0.843, 0.620, 0.061),
          enabled: enabled,
          onTap: onStartCalibration,
        ),
      ],
    );
  }
}
