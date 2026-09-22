import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum MasteryRootDestination { home, adventure, battle, hero, profile }

enum MasteryMovement { squat, lunge, pushUp, plank }

class MovementMasteryScreen extends StatelessWidget {
  const MovementMasteryScreen({
    super.key,
    this.onBack,
    this.onHelp,
    this.onMasteryInfo,
    this.onMovement,
    this.onMovementGuide,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_p1/05_P1_MOVEMENT_MASTERY_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final VoidCallback? onHelp;
  final VoidCallback? onMasteryInfo;
  final ValueChanged<MasteryMovement>? onMovement;
  final VoidCallback? onMovementGuide;
  final ValueChanged<MasteryRootDestination>? onRootNavigate;
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

  ArtworkHotspot _movementHotspot({
    required MasteryMovement movement,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onMovement;
    return ArtworkHotspot(
      id: 'mastery.movement-${movement.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(movement),
    );
  }

  ArtworkHotspot _rootHotspot({
    required MasteryRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != MasteryRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'mastery.nav-${destination.name}',
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
              id: 'mastery.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.018, 0.010, 0.085, 0.060),
              callback: onBack,
            ),
            _hotspot(
              id: 'mastery.help',
              semanticLabel: 'Yardım',
              normalizedRect: const Rect.fromLTWH(0.870, 0.012, 0.090, 0.060),
              callback: onHelp,
            ),
            _hotspot(
              id: 'mastery.info',
              semanticLabel: 'Hareket Ustalığı Bilgisi',
              normalizedRect: const Rect.fromLTWH(0.873, 0.401, 0.055, 0.038),
              callback: onMasteryInfo,
            ),
            _movementHotspot(
              movement: MasteryMovement.squat,
              semanticLabel: 'Squat Ustalığı',
              normalizedRect: const Rect.fromLTWH(0.020, 0.478, 0.467, 0.145),
            ),
            _movementHotspot(
              movement: MasteryMovement.lunge,
              semanticLabel: 'Lunge Ustalığı',
              normalizedRect: const Rect.fromLTWH(0.501, 0.478, 0.466, 0.145),
            ),
            _movementHotspot(
              movement: MasteryMovement.pushUp,
              semanticLabel: 'Push-up Ustalığı',
              normalizedRect: const Rect.fromLTWH(0.020, 0.635, 0.467, 0.145),
            ),
            _movementHotspot(
              movement: MasteryMovement.plank,
              semanticLabel: 'Plank Ustalığı',
              normalizedRect: const Rect.fromLTWH(0.501, 0.635, 0.466, 0.145),
            ),
            _hotspot(
              id: 'mastery.guide',
              semanticLabel: 'Hareket Rehberi',
              normalizedRect: const Rect.fromLTWH(0.610, 0.802, 0.350, 0.060),
              callback: onMovementGuide,
            ),
            _rootHotspot(
              destination: MasteryRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, 0.885, 0.200, 0.115),
            ),
            _rootHotspot(
              destination: MasteryRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, 0.885, 0.200, 0.115),
            ),
            _rootHotspot(
              destination: MasteryRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, 0.885, 0.200, 0.115),
            ),
            _rootHotspot(
              destination: MasteryRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.600, 0.885, 0.200, 0.115),
            ),
            _rootHotspot(
              destination: MasteryRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.800, 0.885, 0.200, 0.115),
            ),
          ],
        ),
      ),
    );
  }
}
