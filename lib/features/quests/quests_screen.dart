import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/clean_base_text.dart';

enum QuestsRootDestination { home, adventure, battle, hero, profile }

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({
    super.key,
    required this.onDailyQuests,
    required this.onWeeklyQuests,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'assets/ui/clean_base_final_60/'
      '59__FINAL_FIX__PROGRESSION_REWARD_PATH__PASS.png';
  static const artworkSize = Size(941, 1672);
  static const _gold = Color(0xFFE8C875);
  static const _ivory = Color(0xFFF3E7C6);

  final VoidCallback onDailyQuests;
  final VoidCallback onWeeklyQuests;

  /// Kept for API compatibility with the root-navigation contract. This child
  /// screen now returns through Navigator instead of painting a second bottom
  /// nav over the clean-base artwork.
  final ValueChanged<QuestsRootDestination>? onRootNavigate;
  final bool battleRootEnabled;

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
          overlays: const [
            ArtworkOverlay(
              id: 'quests.back-icon',
              normalizedRect: Rect.fromLTWH(0.020, 0.018, 0.070, 0.045),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: _gold,
                  size: 24,
                ),
              ),
            ),
            ArtworkOverlay(
              id: 'quests.title',
              normalizedRect: Rect.fromLTWH(0.205, 0.166, 0.590, 0.046),
              child: CleanBaseText(
                'GÖREV MERKEZİ',
                fontSize: 21,
                color: _gold,
                letterSpacing: 1.15,
              ),
            ),
            ArtworkOverlay(
              id: 'quests.daily-label',
              normalizedRect: Rect.fromLTWH(0.190, 0.433, 0.350, 0.030),
              child: CleanBaseText(
                'GÜNLÜK GÖREVLER',
                fontSize: 14,
                color: _ivory,
                textAlign: TextAlign.left,
                alignment: Alignment.centerLeft,
                letterSpacing: 0.7,
              ),
            ),
            ArtworkOverlay(
              id: 'quests.daily-button',
              normalizedRect: Rect.fromLTWH(0.735, 0.438, 0.190, 0.030),
              child: CleanBaseText(
                'AÇ',
                fontSize: 13,
                color: _gold,
                letterSpacing: 0.8,
              ),
            ),
            ArtworkOverlay(
              id: 'quests.weekly-label',
              normalizedRect: Rect.fromLTWH(0.190, 0.528, 0.350, 0.030),
              child: CleanBaseText(
                'HAFTALIK GÖREVLER',
                fontSize: 14,
                color: _ivory,
                textAlign: TextAlign.left,
                alignment: Alignment.centerLeft,
                letterSpacing: 0.65,
              ),
            ),
            ArtworkOverlay(
              id: 'quests.weekly-button',
              normalizedRect: Rect.fromLTWH(0.735, 0.533, 0.190, 0.030),
              child: CleanBaseText(
                'AÇ',
                fontSize: 13,
                color: _gold,
                letterSpacing: 0.8,
              ),
            ),
          ],
          hotspots: [
            ArtworkHotspot(
              id: 'quests.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.000, 0.000, 0.120, 0.085),
              onTap: () => Navigator.of(context).maybePop(),
            ),
            ArtworkHotspot(
              id: 'quests.daily',
              semanticLabel: 'Günlük Görevler',
              normalizedRect: const Rect.fromLTWH(0.040, 0.420, 0.920, 0.085),
              onTap: onDailyQuests,
            ),
            ArtworkHotspot(
              id: 'quests.weekly',
              semanticLabel: 'Haftalık Görevler',
              normalizedRect: const Rect.fromLTWH(0.040, 0.515, 0.920, 0.085),
              onTap: onWeeklyQuests,
            ),
          ],
        ),
      ),
    );
  }
}
