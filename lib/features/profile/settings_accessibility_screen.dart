import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum AccessibilityRootDestination { home, adventure, battle, hero, profile }

enum AccessibilityToggle { highContrast, reducedAnimation, haptics, audioCues }

class SettingsAccessibilityScreen extends StatelessWidget {
  const SettingsAccessibilityScreen({
    super.key,
    this.onBack,
    this.onTextSize,
    this.onToggle,
    this.onColorSupport,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_remaining_13/12_SETTINGS_ACCESSIBILITY_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final VoidCallback? onTextSize;
  final ValueChanged<AccessibilityToggle>? onToggle;
  final VoidCallback? onColorSupport;
  final ValueChanged<AccessibilityRootDestination>? onRootNavigate;
  final bool battleRootEnabled;

  ArtworkHotspot _toggleHotspot({
    required AccessibilityToggle toggle,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onToggle;
    return ArtworkHotspot(
      id: 'settings-accessibility.toggle-${toggle.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(toggle),
    );
  }

  ArtworkHotspot _rootHotspot({
    required AccessibilityRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != AccessibilityRootDestination.battle ||
            battleRootEnabled);
    return ArtworkHotspot(
      id: 'settings-accessibility.nav-${destination.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: enabled,
      onTap: enabled ? () => callback(destination) : () {},
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
            ArtworkHotspot(
              id: 'settings-accessibility.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.018, 0.010, 0.080, 0.060),
              enabled: onBack != null,
              onTap: onBack ?? () {},
            ),
            ArtworkHotspot(
              id: 'settings-accessibility.text-size',
              semanticLabel: 'Metin Boyutu',
              normalizedRect: const Rect.fromLTWH(0.625, 0.290, 0.300, 0.060),
              enabled: onTextSize != null,
              onTap: onTextSize ?? () {},
            ),
            _toggleHotspot(
              toggle: AccessibilityToggle.highContrast,
              semanticLabel: 'Yüksek Kontrast',
              normalizedRect: const Rect.fromLTWH(0.765, 0.390, 0.120, 0.055),
            ),
            _toggleHotspot(
              toggle: AccessibilityToggle.reducedAnimation,
              semanticLabel: 'Azaltılmış Animasyon',
              normalizedRect: const Rect.fromLTWH(0.765, 0.488, 0.120, 0.055),
            ),
            _toggleHotspot(
              toggle: AccessibilityToggle.haptics,
              semanticLabel: 'Dokunsal Geri Bildirim',
              normalizedRect: const Rect.fromLTWH(0.765, 0.586, 0.120, 0.055),
            ),
            _toggleHotspot(
              toggle: AccessibilityToggle.audioCues,
              semanticLabel: 'Sesli İpuçları',
              normalizedRect: const Rect.fromLTWH(0.765, 0.684, 0.120, 0.055),
            ),
            ArtworkHotspot(
              id: 'settings-accessibility.color-support',
              semanticLabel: 'Renk Ayrımı Desteği',
              normalizedRect: const Rect.fromLTWH(0.655, 0.770, 0.285, 0.060),
              enabled: onColorSupport != null,
              onTap: onColorSupport ?? () {},
            ),
            _rootHotspot(
              destination: AccessibilityRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: AccessibilityRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: AccessibilityRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: AccessibilityRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.600, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: AccessibilityRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.800, 0.906, 0.200, 0.094),
            ),
          ],
        ),
      ),
    );
  }
}
