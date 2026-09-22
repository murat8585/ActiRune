import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum ProfileRootDestination { home, adventure, battle, hero, profile }

/// Canonical Profile shell from VIS_0222.
///
/// This artwork is the approved Profile base, but its P1 Rune League entry is
/// still pending. Do not synthesize a Rune League hotspot until the revised
/// artwork becomes the visual authority.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    this.onBack,
    this.onProfileDetails,
    this.onEditProfile,
    this.onAvatar,
    this.onBadges,
    this.onMovementMastery,
    this.onWorldProgress,
    this.onFriends,
    this.onHistory,
    this.onAccountInfo,
    this.onNotifications,
    this.onPrivacy,
    this.onSettings,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/01_CANONICAL_FINAL/'
      'VIS_0222__P1_PROFILE_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final VoidCallback? onProfileDetails;
  final VoidCallback? onEditProfile;
  final VoidCallback? onAvatar;
  final VoidCallback? onBadges;
  final VoidCallback? onMovementMastery;
  final VoidCallback? onWorldProgress;
  final VoidCallback? onFriends;
  final VoidCallback? onHistory;
  final VoidCallback? onAccountInfo;
  final VoidCallback? onNotifications;
  final VoidCallback? onPrivacy;
  final VoidCallback? onSettings;
  final ValueChanged<ProfileRootDestination>? onRootNavigate;
  final bool battleRootEnabled;

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

  ArtworkHotspot _rootHotspot({
    required ProfileRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != ProfileRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'profile.nav-${destination.name}',
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
            _hotspot(
              id: 'profile.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(
                0.0180,
                0.0230,
                0.0920,
                0.0550,
              ),
              callback: onBack,
            ),
            _hotspot(
              id: 'profile.settings-top',
              semanticLabel: 'Ayarlar',
              normalizedRect: const Rect.fromLTWH(
                0.8870,
                0.0240,
                0.0930,
                0.0550,
              ),
              callback: onSettings,
            ),
            _hotspot(
              id: 'profile.details',
              semanticLabel: 'Profil Detayı',
              normalizedRect: const Rect.fromLTWH(
                0.3600,
                0.1480,
                0.3900,
                0.1250,
              ),
              callback: onProfileDetails,
            ),
            _hotspot(
              id: 'profile.edit',
              semanticLabel: 'Profili Düzenle',
              normalizedRect: const Rect.fromLTWH(
                0.5480,
                0.1480,
                0.0600,
                0.0400,
              ),
              callback: onEditProfile,
            ),
            _hotspot(
              id: 'profile.avatar',
              semanticLabel: 'Profil Fotoğrafı',
              normalizedRect: const Rect.fromLTWH(
                0.2400,
                0.2180,
                0.0850,
                0.0500,
              ),
              callback: onAvatar,
            ),
            _hotspot(
              id: 'profile.badges',
              semanticLabel: 'Favori Rozetler Tümünü Gör',
              normalizedRect: const Rect.fromLTWH(
                0.7750,
                0.3020,
                0.1850,
                0.0350,
              ),
              callback: onBadges,
            ),
            _hotspot(
              id: 'profile.movement-mastery',
              semanticLabel: 'Hareket Ustalığı Tümünü Gör',
              normalizedRect: const Rect.fromLTWH(
                0.7750,
                0.4560,
                0.1850,
                0.0350,
              ),
              callback: onMovementMastery,
            ),
            _hotspot(
              id: 'profile.world-progress',
              semanticLabel: 'Dünya İlerlemesi Tümünü Gör',
              normalizedRect: const Rect.fromLTWH(
                0.7750,
                0.5740,
                0.1850,
                0.0350,
              ),
              callback: onWorldProgress,
            ),
            _hotspot(
              id: 'profile.friends',
              semanticLabel: 'Arkadaşlar Tümünü Gör',
              normalizedRect: const Rect.fromLTWH(
                0.3100,
                0.7010,
                0.1700,
                0.0350,
              ),
              callback: onFriends,
            ),
            _hotspot(
              id: 'profile.history',
              semanticLabel: 'Geçmiş Tümünü Gör',
              normalizedRect: const Rect.fromLTWH(
                0.7750,
                0.7010,
                0.1800,
                0.0350,
              ),
              callback: onHistory,
            ),
            _hotspot(
              id: 'profile.account-info',
              semanticLabel: 'Hesap Bilgileri',
              normalizedRect: const Rect.fromLTWH(
                0.0450,
                0.8420,
                0.2200,
                0.0500,
              ),
              callback: onAccountInfo,
            ),
            _hotspot(
              id: 'profile.notifications',
              semanticLabel: 'Bildirimler',
              normalizedRect: const Rect.fromLTWH(
                0.2700,
                0.8420,
                0.2200,
                0.0500,
              ),
              callback: onNotifications,
            ),
            _hotspot(
              id: 'profile.privacy',
              semanticLabel: 'Gizlilik',
              normalizedRect: const Rect.fromLTWH(
                0.4950,
                0.8420,
                0.2200,
                0.0500,
              ),
              callback: onPrivacy,
            ),
            _hotspot(
              id: 'profile.settings',
              semanticLabel: 'Ayarlar',
              normalizedRect: const Rect.fromLTWH(
                0.7200,
                0.8420,
                0.2250,
                0.0500,
              ),
              callback: onSettings,
            ),
            _rootHotspot(
              destination: ProfileRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(
                0.0150,
                0.9050,
                0.2000,
                0.0800,
              ),
            ),
            _rootHotspot(
              destination: ProfileRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(
                0.2150,
                0.9050,
                0.1950,
                0.0800,
              ),
            ),
            _rootHotspot(
              destination: ProfileRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(
                0.4100,
                0.9050,
                0.1800,
                0.0800,
              ),
            ),
            _rootHotspot(
              destination: ProfileRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(
                0.5900,
                0.9050,
                0.2000,
                0.0800,
              ),
            ),
            _rootHotspot(
              destination: ProfileRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(
                0.7900,
                0.9050,
                0.1950,
                0.0800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
