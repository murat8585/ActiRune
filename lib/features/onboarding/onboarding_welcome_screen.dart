import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

/// Exact-art first-run welcome screen.
///
/// The approved artwork is the UI. The start action advances the owning
/// onboarding flow. Locale and accessibility destinations stay owner-supplied
/// so this screen does not invent settings behavior that is not implemented.
class OnboardingWelcomeScreen extends StatelessWidget {
  const OnboardingWelcomeScreen({
    super.key,
    required this.onStart,
    this.onLanguage,
    this.onAccessibility,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_remaining_13/'
      '05_ONBOARDING_WELCOME_FINAL.png';
  static const artworkSize = Size(941, 1671);

  final VoidCallback onStart;
  final VoidCallback? onLanguage;
  final VoidCallback? onAccessibility;

  ArtworkHotspot _optionalHotspot({
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
    return ArtworkInteractionSurface(
      assetPath: artworkAsset,
      sourceSize: artworkSize,
      hotspots: [
        _optionalHotspot(
          id: 'onboarding-welcome.language',
          semanticLabel: 'Dil Seçimi',
          normalizedRect: const Rect.fromLTWH(0.815, 0.012, 0.165, 0.052),
          callback: onLanguage,
        ),
        ArtworkHotspot(
          id: 'onboarding-welcome.start',
          semanticLabel: 'Maceraya Başla',
          normalizedRect: const Rect.fromLTWH(0.115, 0.758, 0.755, 0.105),
          onTap: onStart,
        ),
        _optionalHotspot(
          id: 'onboarding-welcome.accessibility',
          semanticLabel: 'Erişilebilirlik',
          normalizedRect: const Rect.fromLTWH(0.755, 0.918, 0.225, 0.058),
          callback: onAccessibility,
        ),
      ],
    );
  }
}
