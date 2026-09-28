import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum QuestsRootDestination { home, adventure, battle, hero, profile }

/// Canonical Quest Center parent screen from VIS_0173.
///
/// This parent exposes only stable navigation affordances. Baked quest rows,
/// reward amounts and completion states remain visual reference data until an
/// authoritative runtime quest-state adapter owns those fields.
class QuestsScreen extends StatelessWidget {
  const QuestsScreen({
    super.key,
    required this.onDailyQuests,
    required this.onWeeklyQuests,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/06_CURRENT_STRONG_CHILD_REFERENCES/'
      'VIS_0173__CURRENT_QUESTS_PARENT_ALT.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback onDailyQuests;
  final VoidCallback onWeeklyQuests;
  final ValueChanged<QuestsRootDestination>? onRootNavigate;
  final bool battleRootEnabled;

  ArtworkHotspot _rootHotspot({
    required QuestsRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != QuestsRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'quests.nav-${destination.name}',
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
              id: 'quests.daily',
              semanticLabel: 'Günlük Görevler',
              normalizedRect: const Rect.fromLTWH(
                0.075,
                0.285,
                0.410,
                0.045,
              ),
              onTap: onDailyQuests,
            ),
            ArtworkHotspot(
              id: 'quests.weekly',
              semanticLabel: 'Haftalık Görevler',
              normalizedRect: const Rect.fromLTWH(
                0.505,
                0.285,
                0.405,
                0.045,
              ),
              onTap: onWeeklyQuests,
            ),
            _rootHotspot(
              destination: QuestsRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(
                0.010,
                0.884,
                0.195,
                0.094,
              ),
            ),
            _rootHotspot(
              destination: QuestsRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(
                0.205,
                0.884,
                0.198,
                0.094,
              ),
            ),
            _rootHotspot(
              destination: QuestsRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(
                0.403,
                0.884,
                0.182,
                0.094,
              ),
            ),
            _rootHotspot(
              destination: QuestsRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(
                0.585,
                0.884,
                0.200,
                0.094,
              ),
            ),
            _rootHotspot(
              destination: QuestsRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(
                0.785,
                0.884,
                0.195,
                0.094,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
