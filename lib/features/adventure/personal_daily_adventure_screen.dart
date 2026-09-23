import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum PersonalDailyAdventureDuration { quick15, standard30, deep45 }

enum PersonalDailyAdventureRootDestination {
  home,
  adventure,
  battle,
  hero,
  profile,
}

/// Canonical Personal Daily Adventure exact-art shell from VIS_0226.
///
/// This screen does not calculate personalized targets, recovery state,
/// encounters, rewards, or battle ownership. The approved artwork is the UI;
/// actions are forwarded to the real owning engine through callbacks only.
class PersonalDailyAdventureScreen extends StatelessWidget {
  const PersonalDailyAdventureScreen({
    super.key,
    this.onNotifications,
    this.onSettings,
    this.onDurationSelected,
    this.onStartAdventure,
    this.onViewPlan,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/01_CANONICAL_FINAL/'
      'VIS_0226__P1_PERSONAL_DAILY_ADVENTURE_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onNotifications;
  final VoidCallback? onSettings;
  final ValueChanged<PersonalDailyAdventureDuration>? onDurationSelected;
  final VoidCallback? onStartAdventure;
  final VoidCallback? onViewPlan;
  final ValueChanged<PersonalDailyAdventureRootDestination>? onRootNavigate;
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

  ArtworkHotspot _durationHotspot({
    required PersonalDailyAdventureDuration duration,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onDurationSelected;
    return ArtworkHotspot(
      id: 'personal-daily.duration-${duration.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(duration),
    );
  }

  ArtworkHotspot _rootHotspot({
    required PersonalDailyAdventureRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != PersonalDailyAdventureRootDestination.battle ||
            battleRootEnabled);
    return ArtworkHotspot(
      id: 'personal-daily.nav-${destination.name}',
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
              id: 'personal-daily.notifications',
              semanticLabel: 'Bildirimler',
              normalizedRect: const Rect.fromLTWH(
                0.8300,
                0.0100,
                0.0700,
                0.0520,
              ),
              callback: onNotifications,
            ),
            _hotspot(
              id: 'personal-daily.settings',
              semanticLabel: 'Ayarlar',
              normalizedRect: const Rect.fromLTWH(
                0.9000,
                0.0100,
                0.0780,
                0.0520,
              ),
              callback: onSettings,
            ),
            _durationHotspot(
              duration: PersonalDailyAdventureDuration.quick15,
              semanticLabel: '15 dakika Hızlı Macera',
              normalizedRect: const Rect.fromLTWH(
                0.0200,
                0.7080,
                0.3100,
                0.0620,
              ),
            ),
            _durationHotspot(
              duration: PersonalDailyAdventureDuration.standard30,
              semanticLabel: '30 dakika Standart Macera',
              normalizedRect: const Rect.fromLTWH(
                0.3300,
                0.7080,
                0.3350,
                0.0620,
              ),
            ),
            _durationHotspot(
              duration: PersonalDailyAdventureDuration.deep45,
              semanticLabel: '45 dakika Derin Macera',
              normalizedRect: const Rect.fromLTWH(
                0.6650,
                0.7080,
                0.3100,
                0.0620,
              ),
            ),
            _hotspot(
              id: 'personal-daily.start',
              semanticLabel: 'Maceraya Başla',
              normalizedRect: const Rect.fromLTWH(
                0.0250,
                0.7820,
                0.6550,
                0.0820,
              ),
              callback: onStartAdventure,
            ),
            _hotspot(
              id: 'personal-daily.view-plan',
              semanticLabel: 'Planı Gör',
              normalizedRect: const Rect.fromLTWH(
                0.7250,
                0.8030,
                0.2450,
                0.0500,
              ),
              callback: onViewPlan,
            ),
            _rootHotspot(
              destination: PersonalDailyAdventureRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(
                0.0000,
                0.8890,
                0.1950,
                0.1080,
              ),
            ),
            _rootHotspot(
              destination: PersonalDailyAdventureRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(
                0.1950,
                0.8890,
                0.2050,
                0.1080,
              ),
            ),
            _rootHotspot(
              destination: PersonalDailyAdventureRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(
                0.4000,
                0.8890,
                0.2000,
                0.1080,
              ),
            ),
            _rootHotspot(
              destination: PersonalDailyAdventureRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(
                0.6000,
                0.8890,
                0.2000,
                0.1080,
              ),
            ),
            _rootHotspot(
              destination: PersonalDailyAdventureRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(
                0.8000,
                0.8890,
                0.2000,
                0.1080,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
