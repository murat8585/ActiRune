import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum QuestChainRootDestination { home, adventure, battle, hero, profile }

/// Canonical Karanlık Orman / Kurt Avcısı quest-chain screen from VIS_0174.
///
/// Historical runtime evidence verifies that the visible `AKTİF GÖREVE GİT`
/// CTA targets Battle Prep. This artwork shell deliberately keeps battle and
/// reward actions caller-owned so it cannot fabricate encounter or economy
/// state when their real engines are absent.
class QuestChainScreen extends StatelessWidget {
  const QuestChainScreen({
    super.key,
    this.onBack,
    this.onDailyStreak,
    this.onActiveQuest,
    this.onCompletionRewards,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/01_CANONICAL_FINAL/'
      'VIS_0174__P1_QUEST_CHAIN_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final VoidCallback? onDailyStreak;
  final VoidCallback? onActiveQuest;
  final VoidCallback? onCompletionRewards;
  final ValueChanged<QuestChainRootDestination>? onRootNavigate;
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
    required QuestChainRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != QuestChainRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'quest-chain.nav-${destination.name}',
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
              id: 'quest-chain.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(
                0.0250,
                0.1160,
                0.0950,
                0.0900,
              ),
              callback: onBack,
            ),
            _hotspot(
              id: 'quest-chain.daily-streak',
              semanticLabel: 'Günlük Seri 7 gün',
              normalizedRect: const Rect.fromLTWH(
                0.7100,
                0.0180,
                0.2600,
                0.0800,
              ),
              callback: onDailyStreak,
            ),
            _hotspot(
              id: 'quest-chain.active-quest',
              semanticLabel: 'Aktif Göreve Git',
              normalizedRect: const Rect.fromLTWH(
                0.8050,
                0.4700,
                0.1550,
                0.0600,
              ),
              callback: onActiveQuest,
            ),
            _hotspot(
              id: 'quest-chain.completion-rewards',
              semanticLabel: 'Bölüm Tamamlama Ödülü',
              normalizedRect: const Rect.fromLTWH(
                0.0450,
                0.7750,
                0.9100,
                0.1200,
              ),
              callback: onCompletionRewards,
            ),
            _rootHotspot(
              destination: QuestChainRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(
                0.0200,
                0.9200,
                0.1800,
                0.0750,
              ),
            ),
            _rootHotspot(
              destination: QuestChainRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(
                0.2050,
                0.9200,
                0.1800,
                0.0750,
              ),
            ),
            _rootHotspot(
              destination: QuestChainRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(
                0.3950,
                0.9200,
                0.1800,
                0.0750,
              ),
            ),
            _rootHotspot(
              destination: QuestChainRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(
                0.5850,
                0.9200,
                0.1800,
                0.0750,
              ),
            ),
            _rootHotspot(
              destination: QuestChainRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(
                0.7750,
                0.9200,
                0.1800,
                0.0750,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
