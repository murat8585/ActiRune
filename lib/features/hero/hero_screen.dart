import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum HeroRootDestination { home, adventure, battle, hero, profile }

/// Canonical Hero main screen from VIS_0171.
///
/// The artwork itself is the production UI. This widget only exposes the
/// visible interaction boundaries already present in the approved image.
class HeroScreen extends StatelessWidget {
  const HeroScreen({
    super.key,
    this.onEquipment,
    this.onRunes,
    this.onAbilities,
    this.onCompanion,
    this.onCharacterStory,
    this.onCompanionDetails,
    this.onRuneDetails,
    this.onDetailedStats,
    this.onMovementMastery,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/01_CANONICAL_FINAL/'
      'VIS_0171__P1_HERO_MAIN_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onEquipment;
  final VoidCallback? onRunes;
  final VoidCallback? onAbilities;
  final VoidCallback? onCompanion;
  final VoidCallback? onCharacterStory;
  final VoidCallback? onCompanionDetails;
  final VoidCallback? onRuneDetails;
  final VoidCallback? onDetailedStats;
  final VoidCallback? onMovementMastery;
  final ValueChanged<HeroRootDestination>? onRootNavigate;
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
    required HeroRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != HeroRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'hero.nav-${destination.name}',
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
              id: 'hero.equipment',
              semanticLabel: 'Ekipman',
              normalizedRect: const Rect.fromLTWH(
                0.0150,
                0.2150,
                0.1050,
                0.0700,
              ),
              callback: onEquipment,
            ),
            _hotspot(
              id: 'hero.runes',
              semanticLabel: 'Runeler',
              normalizedRect: const Rect.fromLTWH(
                0.0150,
                0.2860,
                0.1050,
                0.0700,
              ),
              callback: onRunes,
            ),
            _hotspot(
              id: 'hero.abilities',
              semanticLabel: 'Yetenekler',
              normalizedRect: const Rect.fromLTWH(
                0.0150,
                0.3570,
                0.1050,
                0.0700,
              ),
              callback: onAbilities,
            ),
            _hotspot(
              id: 'hero.companion',
              semanticLabel: 'Yoldaş',
              normalizedRect: const Rect.fromLTWH(
                0.0150,
                0.4250,
                0.1050,
                0.0700,
              ),
              callback: onCompanion,
            ),
            _hotspot(
              id: 'hero.character-story',
              semanticLabel: 'Karakter Hikayesi',
              normalizedRect: const Rect.fromLTWH(
                0.0150,
                0.4940,
                0.1100,
                0.0660,
              ),
              callback: onCharacterStory,
            ),
            _hotspot(
              id: 'hero.companion-details',
              semanticLabel: 'Yoldaş Detayı',
              normalizedRect: const Rect.fromLTWH(
                0.7350,
                0.5050,
                0.2050,
                0.0430,
              ),
              callback: onCompanionDetails,
            ),
            _hotspot(
              id: 'hero.rune-details',
              semanticLabel: 'Rune Detayları',
              normalizedRect: const Rect.fromLTWH(
                0.3700,
                0.7020,
                0.2450,
                0.0350,
              ),
              callback: onRuneDetails,
            ),
            _hotspot(
              id: 'hero.detailed-stats',
              semanticLabel: 'Detaylı İstatistikler',
              normalizedRect: const Rect.fromLTWH(
                0.7000,
                0.7020,
                0.2450,
                0.0350,
              ),
              callback: onDetailedStats,
            ),
            _hotspot(
              id: 'hero.movement-mastery',
              semanticLabel: 'Hareket Ustalığı',
              normalizedRect: const Rect.fromLTWH(
                0.0250,
                0.7480,
                0.9300,
                0.1250,
              ),
              callback: onMovementMastery,
            ),
            _rootHotspot(
              destination: HeroRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(
                0.0100,
                0.8920,
                0.1950,
                0.0880,
              ),
            ),
            _rootHotspot(
              destination: HeroRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(
                0.2050,
                0.8920,
                0.1980,
                0.0880,
              ),
            ),
            _rootHotspot(
              destination: HeroRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(
                0.4030,
                0.8920,
                0.1820,
                0.0880,
              ),
            ),
            _rootHotspot(
              destination: HeroRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(
                0.5850,
                0.8920,
                0.2000,
                0.0880,
              ),
            ),
            _rootHotspot(
              destination: HeroRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(
                0.7850,
                0.8920,
                0.1950,
                0.0880,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
