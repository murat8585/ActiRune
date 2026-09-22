import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum SettingsRootDestination { home, adventure, battle, hero, profile }

enum SettingsSection {
  account,
  notifications,
  privacy,
  permissions,
  accessibility,
}

class SettingsHubScreen extends StatelessWidget {
  const SettingsHubScreen({
    super.key,
    this.onBack,
    this.onSection,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_p1/07_P1_SETTINGS_HUB_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final ValueChanged<SettingsSection>? onSection;
  final ValueChanged<SettingsRootDestination>? onRootNavigate;
  final bool battleRootEnabled;

  ArtworkHotspot _sectionHotspot({
    required SettingsSection section,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onSection;
    return ArtworkHotspot(
      id: 'settings.section-${section.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(section),
    );
  }

  ArtworkHotspot _rootHotspot({
    required SettingsRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != SettingsRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'settings.nav-${destination.name}',
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
              id: 'settings.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.010, 0.010, 0.080, 0.060),
              enabled: onBack != null,
              onTap: onBack ?? () {},
            ),
            _sectionHotspot(
              section: SettingsSection.account,
              semanticLabel: 'Hesap',
              normalizedRect: const Rect.fromLTWH(0.025, 0.300, 0.940, 0.100),
            ),
            _sectionHotspot(
              section: SettingsSection.notifications,
              semanticLabel: 'Bildirimler',
              normalizedRect: const Rect.fromLTWH(0.025, 0.405, 0.940, 0.100),
            ),
            _sectionHotspot(
              section: SettingsSection.privacy,
              semanticLabel: 'Gizlilik',
              normalizedRect: const Rect.fromLTWH(0.025, 0.510, 0.940, 0.100),
            ),
            _sectionHotspot(
              section: SettingsSection.permissions,
              semanticLabel: 'İzinler',
              normalizedRect: const Rect.fromLTWH(0.025, 0.615, 0.940, 0.100),
            ),
            _sectionHotspot(
              section: SettingsSection.accessibility,
              semanticLabel: 'Erişilebilirlik',
              normalizedRect: const Rect.fromLTWH(0.025, 0.720, 0.940, 0.100),
            ),
            _rootHotspot(
              destination: SettingsRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, 0.884, 0.200, 0.116),
            ),
            _rootHotspot(
              destination: SettingsRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, 0.884, 0.200, 0.116),
            ),
            _rootHotspot(
              destination: SettingsRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, 0.884, 0.200, 0.116),
            ),
            _rootHotspot(
              destination: SettingsRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.600, 0.884, 0.200, 0.116),
            ),
            _rootHotspot(
              destination: SettingsRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.800, 0.884, 0.200, 0.116),
            ),
          ],
        ),
      ),
    );
  }
}
