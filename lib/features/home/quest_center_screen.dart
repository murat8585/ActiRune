import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/artwork_sample_mask.dart';
import '../quests/local_quest_state.dart';

/// Current approved Quest parent with distinct owned Daily and Weekly routes.
class QuestCenterScreen extends StatelessWidget {
  const QuestCenterScreen({
    super.key,
    required this.onBack,
    required this.onDaily,
    required this.onWeekly,
    this.questOwner,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/06_CURRENT_STRONG_CHILD_REFERENCES/'
      'VIS_0173__CURRENT_QUESTS_PARENT_ALT.png';

  final VoidCallback onBack;
  final VoidCallback onDaily;
  final VoidCallback onWeekly;
  final LocalQuestOwner? questOwner;

  @override
  Widget build(BuildContext context) {
    final owner = questOwner;
    final daily =
        owner?.recordsFor(QuestType.daily) ??
        LocalQuestOwner.sampleRecords
            .where((record) => record.type == QuestType.daily)
            .toList();
    final weekly =
        owner?.recordsFor(QuestType.weekly) ??
        LocalQuestOwner.sampleRecords
            .where((record) => record.type == QuestType.weekly)
            .toList();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: artworkAsset,
          sourceSize: const Size(941, 1672),
          overlays: [
            const ArtworkOverlay(
              id: 'quest-center-profile-sample',
              normalizedRect: Rect.fromLTWH(.18, .025, .17, .078),
              child: ArtworkSampleMask(label: 'Profil verisi yok'),
            ),
            const ArtworkOverlay(
              id: 'quest-center-nav-badge',
              normalizedRect: Rect.fromLTWH(.135, .898, .031, .021),
              child: ColoredBox(color: Color(0xFF071522)),
            ),
            ArtworkOverlay(
              id: 'quest-center-owned-routes',
              normalizedRect: const Rect.fromLTWH(.045, .285, .91, .56),
              interactive: true,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xF006172A),
                  border: Border.all(
                    color: const Color(0xFFD8B873),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'GÖREV YOLLARI',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFD991),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Yerel örnek görevler • gerçek aktivite ilerlemesi bağlı değil',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFBBD3E3),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        key: const ValueKey('quest-center-daily'),
                        behavior: HitTestBehavior.opaque,
                        onTap: onDaily,
                        child: _RouteCard(
                          title: 'GÜNLÜK GÖREVLER',
                          summary: '${daily.length} örnek görev • ana hedef 3',
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        key: const ValueKey('quest-center-weekly'),
                        behavior: HitTestBehavior.opaque,
                        onTap: onWeekly,
                        child: _RouteCard(
                          title: 'HAFTALIK GÖREVLER',
                          summary:
                              '${weekly.length} örnek görev • seviye doğrulanmadı',
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Gerçek görev ilerlemesi ve ödül kayıt sistemi bağlı değil; ödül verilmez.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFBBD3E3),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          hotspots: const [],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: SafeArea(
        child: IconButton.filledTonal(
          key: const ValueKey('quest-center-back'),
          tooltip: 'Ana Dünya’ya dön',
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.title, required this.summary});
  final String title;
  final String summary;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xFF12374C),
      border: Border.all(color: const Color(0xFF78CAD7)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFD991),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            summary,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    ),
  );
}
