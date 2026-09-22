import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum DailyQuestsRootDestination { home, adventure, battle, hero, profile }

/// Canonical Daily Adventure / Daily Quests screen from VIS_0227.
///
/// The approved artwork is the production UI. This widget exposes only the
/// visible interaction regions already present in that artwork. Reward and
/// task-change effects remain caller-owned because the integration branch has
/// no authoritative Daily Quest engine contract for those mutations.
class DailyQuestsScreen extends StatelessWidget {
  const DailyQuestsScreen({
    super.key,
    this.onProgressReward,
    this.onClaimExploreReward,
    this.onClaimBattleReward,
    this.onFreeTaskChange,
    this.onTaskChangeHelp,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/01_CANONICAL_FINAL/'
      'VIS_0227__P1_DAILY_QUESTS_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onProgressReward;
  final VoidCallback? onClaimExploreReward;
  final VoidCallback? onClaimBattleReward;
  final VoidCallback? onFreeTaskChange;
  final VoidCallback? onTaskChangeHelp;
  final ValueChanged<DailyQuestsRootDestination>? onRootNavigate;
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
    required DailyQuestsRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != DailyQuestsRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'daily-quests.nav-${destination.name}',
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
              id: 'daily-quests.progress-reward',
              semanticLabel: 'Günlük Rün Sandığı',
              normalizedRect: const Rect.fromLTWH(
                0.5850,
                0.2750,
                0.3850,
                0.1350,
              ),
              callback: onProgressReward,
            ),
            _hotspot(
              id: 'daily-quests.claim-explore',
              semanticLabel: 'Keşif ödülünü al',
              normalizedRect: const Rect.fromLTWH(
                0.7850,
                0.5360,
                0.1850,
                0.0570,
              ),
              callback: onClaimExploreReward,
            ),
            _hotspot(
              id: 'daily-quests.claim-battle',
              semanticLabel: 'Savaş ödülünü al',
              normalizedRect: const Rect.fromLTWH(
                0.7850,
                0.5960,
                0.1850,
                0.0570,
              ),
              callback: onClaimBattleReward,
            ),
            _hotspot(
              id: 'daily-quests.free-change',
              semanticLabel: '1 ücretsiz görev değiştirme',
              normalizedRect: const Rect.fromLTWH(
                0.0200,
                0.8500,
                0.3550,
                0.0500,
              ),
              callback: onFreeTaskChange,
            ),
            _hotspot(
              id: 'daily-quests.change-help',
              semanticLabel: 'Görev değiştirme yardımı',
              normalizedRect: const Rect.fromLTWH(
                0.3750,
                0.8500,
                0.0650,
                0.0500,
              ),
              callback: onTaskChangeHelp,
            ),
            _rootHotspot(
              destination: DailyQuestsRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(
                0.0100,
                0.9050,
                0.1950,
                0.0850,
              ),
            ),
            _rootHotspot(
              destination: DailyQuestsRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(
                0.2050,
                0.9050,
                0.1980,
                0.0850,
              ),
            ),
            _rootHotspot(
              destination: DailyQuestsRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(
                0.4030,
                0.9050,
                0.1820,
                0.0850,
              ),
            ),
            _rootHotspot(
              destination: DailyQuestsRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(
                0.5850,
                0.9050,
                0.2000,
                0.0850,
              ),
            ),
            _rootHotspot(
              destination: DailyQuestsRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(
                0.7850,
                0.9050,
                0.1950,
                0.0850,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
