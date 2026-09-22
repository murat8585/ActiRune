import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum ProPlan { monthly, annual }

/// Canonical ActiRune Pro paywall from VIS_0216.
///
/// This screen intentionally owns no billing, trial, entitlement, pricing, or
/// purchase-success state. Those effects belong to a real billing owner and
/// are exposed only as callbacks. The approved artwork remains the UI.
class ProPaywallScreen extends StatelessWidget {
  const ProPaywallScreen({
    super.key,
    this.onBack,
    this.onClose,
    this.onPlanSelected,
    this.onUpgradeRequested,
    this.onContinueFree,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/01_CANONICAL_FINAL/'
      'VIS_0216__P1_PRO_PAYWALL_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final ValueChanged<ProPlan>? onPlanSelected;
  final VoidCallback? onUpgradeRequested;
  final VoidCallback? onContinueFree;

  ArtworkHotspot _hotspot({
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: artworkAsset,
          sourceSize: artworkSize,
          hotspots: [
            _hotspot(
              id: 'pro-paywall.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(
                0.0180,
                0.0100,
                0.0830,
                0.0450,
              ),
              callback: onBack,
            ),
            _hotspot(
              id: 'pro-paywall.close',
              semanticLabel: 'Kapat',
              normalizedRect: const Rect.fromLTWH(
                0.8920,
                0.0100,
                0.0750,
                0.0450,
              ),
              callback: onClose,
            ),
            _hotspot(
              id: 'pro-paywall.plan-monthly',
              semanticLabel: 'Aylık plan',
              normalizedRect: const Rect.fromLTWH(
                0.1810,
                0.8360,
                0.3080,
                0.0500,
              ),
              callback: onPlanSelected == null
                  ? null
                  : () => onPlanSelected!(ProPlan.monthly),
            ),
            _hotspot(
              id: 'pro-paywall.plan-annual',
              semanticLabel: 'Yıllık plan',
              normalizedRect: const Rect.fromLTWH(
                0.5050,
                0.8360,
                0.3150,
                0.0500,
              ),
              callback: onPlanSelected == null
                  ? null
                  : () => onPlanSelected!(ProPlan.annual),
            ),
            _hotspot(
              id: 'pro-paywall.upgrade',
              semanticLabel: 'Pro’ya Geç',
              normalizedRect: const Rect.fromLTWH(
                0.1810,
                0.8920,
                0.6380,
                0.0470,
              ),
              callback: onUpgradeRequested,
            ),
            _hotspot(
              id: 'pro-paywall.continue-free',
              semanticLabel: 'Ücretsiz özelliklerle devam et',
              normalizedRect: const Rect.fromLTWH(
                0.3400,
                0.9490,
                0.3200,
                0.0310,
              ),
              callback: onContinueFree,
            ),
          ],
        ),
      ),
    );
  }
}
