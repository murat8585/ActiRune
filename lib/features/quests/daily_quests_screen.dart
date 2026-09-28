import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/clean_base_text.dart';

enum DailyQuestsRootDestination { home, adventure, battle, hero, profile }

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
      'assets/ui/clean_base_final_60/44__LATE_QA_POS_13__PASS.png';
  static const artworkSize = Size(941, 1672);
  static const _gold = Color(0xFFE8C875);
  static const _ivory = Color(0xFFF3E7C6);

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
              id: 'daily.back-icon',
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
              id: 'daily.title',
              normalizedRect: Rect.fromLTWH(0.205, 0.174, 0.590, 0.043),
              child: CleanBaseText(
                'GÜNLÜK MACERA',
                fontSize: 21,
                color: _gold,
                letterSpacing: 1.05,
              ),
            ),
            ArtworkOverlay(
              id: 'daily.row-1',
              normalizedRect: Rect.fromLTWH(0.215, 0.443, 0.320, 0.028),
              child: CleanBaseText(
                'KEŞİF',
                fontSize: 14,
                color: _ivory,
                textAlign: TextAlign.left,
                alignment: Alignment.centerLeft,
              ),
            ),
            ArtworkOverlay(
              id: 'daily.row-2',
              normalizedRect: Rect.fromLTWH(0.215, 0.543, 0.320, 0.028),
              child: CleanBaseText(
                'SAVAŞ',
                fontSize: 14,
                color: _ivory,
                textAlign: TextAlign.left,
                alignment: Alignment.centerLeft,
              ),
            ),
            ArtworkOverlay(
              id: 'daily.row-3',
              normalizedRect: Rect.fromLTWH(0.215, 0.643, 0.320, 0.028),
              child: CleanBaseText(
                'HAREKET / FORM',
                fontSize: 14,
                color: _ivory,
                textAlign: TextAlign.left,
                alignment: Alignment.centerLeft,
                letterSpacing: 0.55,
              ),
            ),
            ArtworkOverlay(
              id: 'daily.row-4',
              normalizedRect: Rect.fromLTWH(0.215, 0.743, 0.320, 0.028),
              child: CleanBaseText(
                'LUMI / GELİŞİM',
                fontSize: 14,
                color: _ivory,
                textAlign: TextAlign.left,
                alignment: Alignment.centerLeft,
                letterSpacing: 0.55,
              ),
            ),
            ArtworkOverlay(
              id: 'daily.row-5',
              normalizedRect: Rect.fromLTWH(0.215, 0.843, 0.320, 0.028),
              child: CleanBaseText(
                'TOPARLAMA / DENGE',
                fontSize: 13,
                color: _ivory,
                textAlign: TextAlign.left,
                alignment: Alignment.centerLeft,
                letterSpacing: 0.45,
              ),
            ),
          ],
          hotspots: [
            ArtworkHotspot(
              id: 'daily-quests.back',
              semanticLabel: 'Görev Merkezine Dön',
              normalizedRect: const Rect.fromLTWH(0.000, 0.000, 0.120, 0.085),
              onTap: () => Navigator.of(context).maybePop(),
            ),
            _hotspot(
              id: 'daily-quests.progress-reward',
              semanticLabel: 'Günlük Rün Sandığı',
              normalizedRect: const Rect.fromLTWH(0.365, 0.315, 0.270, 0.115),
              callback: onProgressReward,
            ),
            _hotspot(
              id: 'daily-quests.claim-explore',
              semanticLabel: 'Keşif ödülünü al',
              normalizedRect: const Rect.fromLTWH(0.705, 0.445, 0.250, 0.065),
              callback: onClaimExploreReward,
            ),
            _hotspot(
              id: 'daily-quests.claim-battle',
              semanticLabel: 'Savaş ödülünü al',
              normalizedRect: const Rect.fromLTWH(0.705, 0.545, 0.250, 0.065),
              callback: onClaimBattleReward,
            ),
            _hotspot(
              id: 'daily-quests.free-change',
              semanticLabel: 'Görev değiştir',
              normalizedRect: const Rect.fromLTWH(0.190, 0.835, 0.385, 0.070),
              callback: onFreeTaskChange,
            ),
            _hotspot(
              id: 'daily-quests.change-help',
              semanticLabel: 'Görev değiştirme yardımı',
              normalizedRect: const Rect.fromLTWH(0.570, 0.835, 0.085, 0.070),
              callback: onTaskChangeHelp,
            ),
          ],
        ),
      ),
    );
  }
}
