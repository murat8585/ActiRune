import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum PrivacyRootDestination { home, adventure, battle, hero, profile }

enum PrivacyToggle { onlineStatus, challenges, congratulations }

class SettingsPrivacyScreen extends StatelessWidget {
  const SettingsPrivacyScreen({
    super.key,
    this.onBack,
    this.onProfileVisibility,
    this.onToggle,
    this.onBlockedPlayers,
    this.onDataPrivacy,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_remaining_13/10_SETTINGS_PRIVACY_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final VoidCallback? onProfileVisibility;
  final ValueChanged<PrivacyToggle>? onToggle;
  final VoidCallback? onBlockedPlayers;
  final VoidCallback? onDataPrivacy;
  final ValueChanged<PrivacyRootDestination>? onRootNavigate;
  final bool battleRootEnabled;

  ArtworkHotspot _toggleHotspot({
    required PrivacyToggle toggle,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onToggle;
    return ArtworkHotspot(
      id: 'settings-privacy.toggle-${toggle.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(toggle),
    );
  }

  ArtworkHotspot _rootHotspot({
    required PrivacyRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != PrivacyRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'settings-privacy.nav-${destination.name}',
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
              id: 'settings-privacy.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.018, 0.010, 0.090, 0.060),
              enabled: onBack != null,
              onTap: onBack ?? () {},
            ),
            ArtworkHotspot(
              id: 'settings-privacy.profile-visibility',
              semanticLabel: 'Profil Görünürlüğü',
              normalizedRect: const Rect.fromLTWH(0.080, 0.192, 0.835, 0.070),
              enabled: onProfileVisibility != null,
              onTap: onProfileVisibility ?? () {},
            ),
            _toggleHotspot(
              toggle: PrivacyToggle.onlineStatus,
              semanticLabel: 'Çevrimiçi Durum',
              normalizedRect: const Rect.fromLTWH(0.780, 0.327, 0.120, 0.060),
            ),
            _toggleHotspot(
              toggle: PrivacyToggle.challenges,
              semanticLabel: 'Meydan Okuma Al',
              normalizedRect: const Rect.fromLTWH(0.780, 0.458, 0.120, 0.060),
            ),
            _toggleHotspot(
              toggle: PrivacyToggle.congratulations,
              semanticLabel: 'Tebrik Al',
              normalizedRect: const Rect.fromLTWH(0.780, 0.525, 0.120, 0.060),
            ),
            ArtworkHotspot(
              id: 'settings-privacy.blocked-players',
              semanticLabel: 'Engellenen Oyuncular',
              normalizedRect: const Rect.fromLTWH(0.080, 0.642, 0.835, 0.070),
              enabled: onBlockedPlayers != null,
              onTap: onBlockedPlayers ?? () {},
            ),
            ArtworkHotspot(
              id: 'settings-privacy.data-privacy',
              semanticLabel: 'Veri ve Gizlilik',
              normalizedRect: const Rect.fromLTWH(0.080, 0.765, 0.835, 0.078),
              enabled: onDataPrivacy != null,
              onTap: onDataPrivacy ?? () {},
            ),
            _rootHotspot(
              destination: PrivacyRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: PrivacyRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: PrivacyRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: PrivacyRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.600, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: PrivacyRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.800, 0.906, 0.200, 0.094),
            ),
          ],
        ),
      ),
    );
  }
}
