import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum WeeklyQuestsRootDestination { home, adventure, battle, hero, profile }

/// Canonical Weekly Adventure / Weekly Quests screen from VIS_0228.
///
/// The approved artwork is the production UI. Progress rows are status-only
/// unless the artwork exposes an explicit CTA. Reward mutation remains
/// caller-owned because this integration branch has no authoritative weekly
/// quest reward engine contract.
class WeeklyQuestsScreen extends StatelessWidget {
  const WeeklyQuestsScreen({
    super.key,
    this.onDailyStreak,
    this.onClaimQuestChainReward,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/01_CANONICAL_FINAL/'
      'VIS_0228__P1_WEEKLY_QUESTS_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onDailyStreak;
  final VoidCallback? onClaimQuestChainReward;
  final ValueChanged<WeeklyQuestsRootDestination>? onRootNavigate;
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
    required WeeklyQuestsRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != WeeklyQuestsRootDestination.battle ||
            battleRootEnabled);
    return ArtworkHotspot(
      id: 'weekly-quests.nav-${destination.name}',
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
              id: 'weekly-quests.daily-streak',
              semanticLabel: 'Günlük Seri 7 gün',
              normalizedRect: const Rect.fromLTWH(
                0.6900,
                0.0080,
                0.2950,
                0.0870,
              ),
              callback: onDailyStreak,
            ),
            _hotspot(
              id: 'weekly-quests.claim-quest-chain',
              semanticLabel: 'Görev Zinciri ödülünü al',
              normalizedRect: const Rect.fromLTWH(
                0.7750,
                0.8000,
                0.1850,
                0.0450,
              ),
              callback: onClaimQuestChainReward,
            ),
            _rootHotspot(
              destination: WeeklyQuestsRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(
                0.0100,
                0.8950,
                0.1950,
                0.0950,
              ),
            ),
            _rootHotspot(
              destination: WeeklyQuestsRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(
                0.2050,
                0.8950,
                0.1980,
                0.0950,
              ),
            ),
            _rootHotspot(
              destination: WeeklyQuestsRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(
                0.4030,
                0.8950,
                0.1820,
                0.0950,
              ),
            ),
            _rootHotspot(
              destination: WeeklyQuestsRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(
                0.5850,
                0.8950,
                0.2000,
                0.0950,
              ),
            ),
            _rootHotspot(
              destination: WeeklyQuestsRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(
                0.7850,
                0.8950,
                0.1950,
                0.0950,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
