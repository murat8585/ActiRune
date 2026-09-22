import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum AchievementFilter {
  all,
  exploration,
  battle,
  movement,
  form,
  lumi,
  social,
  hidden,
}

enum AchievementsRootDestination { home, adventure, battle, hero, profile }

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({
    super.key,
    this.onBack,
    this.onCrystalStore,
    this.onGoldStore,
    this.onNotifications,
    this.onShowInProfile,
    this.onFilterChanged,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/01_CANONICAL_FINAL/'
      'VIS_0215__P1_ACHIEVEMENTS_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final VoidCallback? onCrystalStore;
  final VoidCallback? onGoldStore;
  final VoidCallback? onNotifications;
  final VoidCallback? onShowInProfile;
  final ValueChanged<AchievementFilter>? onFilterChanged;
  final ValueChanged<AchievementsRootDestination>? onRootNavigate;
  final bool battleRootEnabled;

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  AchievementFilter _filter = AchievementFilter.all;

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

  ArtworkHotspot _filterHotspot({
    required AchievementFilter filter,
    required String label,
    required Rect normalizedRect,
  }) {
    return ArtworkHotspot(
      id: 'achievements.filter-${filter.name}',
      semanticLabel: _filter == filter ? '$label, seçili' : label,
      normalizedRect: normalizedRect,
      onTap: () {
        if (_filter != filter) {
          setState(() => _filter = filter);
        }
        widget.onFilterChanged?.call(filter);
      },
    );
  }

  ArtworkHotspot _rootHotspot({
    required AchievementsRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = widget.onRootNavigate;
    final enabled =
        callback != null &&
        (destination != AchievementsRootDestination.battle ||
            widget.battleRootEnabled);
    return ArtworkHotspot(
      id: 'achievements.nav-${destination.name}',
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
          assetPath: AchievementsScreen.artworkAsset,
          sourceSize: AchievementsScreen.artworkSize,
          hotspots: [
            _hotspot(
              id: 'achievements.back',
              semanticLabel: 'Profile Dön',
              normalizedRect: const Rect.fromLTWH(
                0.0180,
                0.0080,
                0.3000,
                0.0780,
              ),
              callback: widget.onBack,
            ),
            _hotspot(
              id: 'achievements.crystal-store',
              semanticLabel: 'Kristal Ekle',
              normalizedRect: const Rect.fromLTWH(
                0.6630,
                0.0070,
                0.0610,
                0.0340,
              ),
              callback: widget.onCrystalStore,
            ),
            _hotspot(
              id: 'achievements.gold-store',
              semanticLabel: 'Altın Ekle',
              normalizedRect: const Rect.fromLTWH(
                0.8390,
                0.0070,
                0.0550,
                0.0340,
              ),
              callback: widget.onGoldStore,
            ),
            _hotspot(
              id: 'achievements.notifications',
              semanticLabel: 'Bildirimler',
              normalizedRect: const Rect.fromLTWH(
                0.9150,
                0.0040,
                0.0640,
                0.0390,
              ),
              callback: widget.onNotifications,
            ),
            _hotspot(
              id: 'achievements.show-in-profile',
              semanticLabel: 'Profilde Göster',
              normalizedRect: const Rect.fromLTWH(
                0.6840,
                0.4070,
                0.2460,
                0.0370,
              ),
              callback: widget.onShowInProfile,
            ),
            _filterHotspot(
              filter: AchievementFilter.all,
              label: 'Tümü',
              normalizedRect: const Rect.fromLTWH(
                0.0270,
                0.5090,
                0.1160,
                0.0340,
              ),
            ),
            _filterHotspot(
              filter: AchievementFilter.exploration,
              label: 'Keşif',
              normalizedRect: const Rect.fromLTWH(
                0.1470,
                0.5090,
                0.1120,
                0.0340,
              ),
            ),
            _filterHotspot(
              filter: AchievementFilter.battle,
              label: 'Savaş',
              normalizedRect: const Rect.fromLTWH(
                0.2620,
                0.5090,
                0.1120,
                0.0340,
              ),
            ),
            _filterHotspot(
              filter: AchievementFilter.movement,
              label: 'Hareket',
              normalizedRect: const Rect.fromLTWH(
                0.3770,
                0.5090,
                0.1190,
                0.0340,
              ),
            ),
            _filterHotspot(
              filter: AchievementFilter.form,
              label: 'Form',
              normalizedRect: const Rect.fromLTWH(
                0.4990,
                0.5090,
                0.1110,
                0.0340,
              ),
            ),
            _filterHotspot(
              filter: AchievementFilter.lumi,
              label: 'Lumi',
              normalizedRect: const Rect.fromLTWH(
                0.6130,
                0.5090,
                0.1120,
                0.0340,
              ),
            ),
            _filterHotspot(
              filter: AchievementFilter.social,
              label: 'Sosyal',
              normalizedRect: const Rect.fromLTWH(
                0.7280,
                0.5090,
                0.1130,
                0.0340,
              ),
            ),
            _filterHotspot(
              filter: AchievementFilter.hidden,
              label: 'Gizli',
              normalizedRect: const Rect.fromLTWH(
                0.8450,
                0.5090,
                0.1130,
                0.0340,
              ),
            ),
            _rootHotspot(
              destination: AchievementsRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(
                0.0140,
                0.9190,
                0.1980,
                0.0770,
              ),
            ),
            _rootHotspot(
              destination: AchievementsRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(
                0.2130,
                0.9190,
                0.1950,
                0.0770,
              ),
            ),
            _rootHotspot(
              destination: AchievementsRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(
                0.4090,
                0.9190,
                0.1840,
                0.0770,
              ),
            ),
            _rootHotspot(
              destination: AchievementsRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(
                0.5940,
                0.9190,
                0.1930,
                0.0770,
              ),
            ),
            _rootHotspot(
              destination: AchievementsRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(
                0.7890,
                0.9190,
                0.1960,
                0.0770,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
