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
    this.onSkipCalibration,
    this.enabled = true,
    this.skipEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260926/final/'
      'VIS_20260926_FIRST_CALIBRATION_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback onStartCalibration;
  final VoidCallback? onSkipCalibration;
  final bool enabled;
  final bool skipEnabled;

  @override
  Widget build(BuildContext context) {
    return ArtworkInteractionSurface(
      assetPath: artworkAsset,
      sourceSize: artworkSize,
      hotspots: [
        ArtworkHotspot(
          id: 'first-calibration.start',
          semanticLabel: 'Kalibrasyona Başla',
          normalizedRect: const Rect.fromLTWH(0.210, 0.853, 0.580, 0.057),
          enabled: enabled,
          onTap: onStartCalibration,
        ),
        ArtworkHotspot(
          id: 'first-calibration.skip',
          semanticLabel: 'Şimdilik Geç',
          normalizedRect: const Rect.fromLTWH(0.310, 0.927, 0.380, 0.034),
          enabled: skipEnabled && onSkipCalibration != null,
          onTap: onSkipCalibration ?? () {},
        ),
      ],
    );
  }
}
