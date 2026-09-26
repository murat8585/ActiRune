import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/feature_unavailable_dialog.dart';
import '../quests/local_quest_state.dart';

/// Current approved Quest parent with distinct owned Daily and Weekly routes.
class QuestCenterScreen extends StatelessWidget {
  const QuestCenterScreen({
    super.key,
    required this.onBack,
    required this.onDaily,
    required this.onWeekly,
    this.onRootNavigate,
    this.questOwner,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/06_CURRENT_STRONG_CHILD_REFERENCES/'
      'VIS_0173__CURRENT_QUESTS_PARENT_ALT.png';

  final VoidCallback onBack;
  final VoidCallback onDaily;
  final VoidCallback onWeekly;
  final ValueChanged<String>? onRootNavigate;
  final LocalQuestOwner? questOwner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: artworkAsset,
          sourceSize: const Size(941, 1672),
          hotspots: [
            ArtworkHotspot(
              id: 'quest-center-daily',
              semanticLabel: 'Günlük Görevler',
              normalizedRect: const Rect.fromLTWH(.075, .286, .415, .05),
              onTap: onDaily,
            ),
            ArtworkHotspot(
              id: 'quest-center-weekly',
              semanticLabel: 'Haftalık Görevler',
              normalizedRect: const Rect.fromLTWH(.51, .286, .42, .05),
              onTap: onWeekly,
            ),
            ArtworkHotspot(
              id: 'quest-center-back',
              semanticLabel: 'Ana Dünya’ya dön',
              normalizedRect: const Rect.fromLTWH(.01, .89, .19, .09),
              onTap: onBack,
            ),
            for (final (id, y) in [
              ('quest-1', .48),
              ('quest-2', .519),
              ('quest-3', .558),
              ('quest-4', .597),
              ('quest-5', .636),
              ('quest-6', .675),
            ])
              ArtworkHotspot(
                id: 'quest-center.$id',
                semanticLabel: 'Görsel görev $id',
                normalizedRect: Rect.fromLTWH(.76, y, .2, .038),
                onTap: () => FeatureUnavailableDialog.show(
                  context,
                  feature: 'Görev ilerlemesi',
                  message:
                      'Görseldeki ilerleme ve ödül örnektir. '
                      'Gerçek ilerleme veya ödül kaydı bağlı değil.',
                ),
              ),
            for (final (name, x) in [
              ('adventure', .2),
              ('battle', .4),
              ('hero', .6),
              ('profile', .8),
            ])
              ArtworkHotspot(
                id: 'quest-center.nav-$name',
                semanticLabel: 'Ana sekme $name',
                normalizedRect: Rect.fromLTWH(x, .89, .2, .09),
                onTap: () => onRootNavigate == null
                    ? FeatureUnavailableDialog.show(
                        context,
                        feature: 'Ana sekme',
                      )
                    : onRootNavigate!(name),
              ),
          ],
        ),
      ),
    );
  }
}
