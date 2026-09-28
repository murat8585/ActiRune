import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

/// Canonical first-calibration entry screen.
///
/// This screen starts a real calibration request owned by the parent flow. It
/// never marks calibration successful by itself. Calibration is optional for
/// product entry; [onSkip] lets the user continue without fabricating a result.
class FirstCalibrationScreen extends StatelessWidget {
  const FirstCalibrationScreen({
    super.key,
    required this.onStartCalibration,
    this.onSkip,
    this.enabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/01_CANONICAL_FINAL/'
      'VIS_0180__P1_FIRST_CALIBRATION_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback onStartCalibration;
  final VoidCallback? onSkip;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final skip = onSkip;

    return ArtworkInteractionSurface(
      assetPath: artworkAsset,
      sourceSize: artworkSize,
      overlays: [
        if (skip != null)
          const ArtworkOverlay(
            id: 'first-calibration.skip-label',
            normalizedRect: Rect.fromLTWH(0.315, 0.914, 0.370, 0.036),
            child: Center(
              child: Text(
                'ŞİMDİLİK GEÇ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
      ],
      hotspots: [
        ArtworkHotspot(
          id: 'first-calibration.start',
          semanticLabel: 'Kalibrasyonu Başlat',
          normalizedRect: const Rect.fromLTWH(0.190, 0.843, 0.620, 0.061),
          enabled: enabled,
          onTap: onStartCalibration,
        ),
        if (skip != null)
          ArtworkHotspot(
            id: 'first-calibration.skip',
            semanticLabel: 'Şimdilik geç',
            normalizedRect: const Rect.fromLTWH(0.250, 0.902, 0.500, 0.060),
            onTap: skip,
          ),
      ],
    );
  }
}
