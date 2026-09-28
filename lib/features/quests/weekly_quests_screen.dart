import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/clean_base_text.dart';

enum WeeklyQuestsRootDestination { home, adventure, battle, hero, profile }

class WeeklyQuestsScreen extends StatelessWidget {
  const WeeklyQuestsScreen({
    super.key,
    this.onDailyStreak,
    this.onClaimQuestChainReward,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'assets/ui/clean_base_final_60/45__LATE_QA_POS_14__PASS.png';
  static const artworkSize = Size(941, 1672);
  static const _gold = Color(0xFFE8C875);
  static const _ivory = Color(0xFFF3E7C6);

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
              id: 'weekly.back-icon',
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
              id: 'weekly.title',
              normalizedRect: Rect.fromLTWH(0.245, 0.314, 0.510, 0.038),
              child: CleanBaseText(
                'HAFTALIK MACERA',
                fontSize: 20,
                color: _gold,
                letterSpacing: 1.0,
              ),
            ),
            ArtworkOverlay(
              id: 'weekly.row-1',
              normalizedRect: Rect.fromLTWH(0.185, 0.510, 0.285, 0.028),
              child: CleanBaseText(
                'SAVAŞ',
                fontSize: 14,
                color: _ivory,
                textAlign: TextAlign.left,
                alignment: Alignment.centerLeft,
              ),
            ),
            ArtworkOverlay(
              id: 'weekly.row-2',
              normalizedRect: Rect.fromLTWH(0.185, 0.602, 0.285, 0.028),
              child: CleanBaseText(
                'KORUMA',
                fontSize: 14,
                color: _ivory,
                textAlign: TextAlign.left,
                alignment: Alignment.centerLeft,
              ),
            ),
            ArtworkOverlay(
              id: 'weekly.row-3',
              normalizedRect: Rect.fromLTWH(0.185, 0.694, 0.285, 0.028),
              child: CleanBaseText(
                'KEŞİF / USTALIK',
                fontSize: 14,
                color: _ivory,
                textAlign: TextAlign.left,
                alignment: Alignment.centerLeft,
                letterSpacing: 0.55,
              ),
            ),
            ArtworkOverlay(
              id: 'weekly.row-4',
              normalizedRect: Rect.fromLTWH(0.185, 0.786, 0.285, 0.028),
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
              id: 'weekly.row-5',
              normalizedRect: Rect.fromLTWH(0.185, 0.878, 0.285, 0.028),
              child: CleanBaseText(
                'GÖREV ZİNCİRİ',
                fontSize: 14,
                color: _ivory,
                textAlign: TextAlign.left,
                alignment: Alignment.centerLeft,
                letterSpacing: 0.55,
              ),
            ),
          ],
          hotspots: [
            ArtworkHotspot(
              id: 'weekly-quests.back',
              semanticLabel: 'Görev Merkezine Dön',
              normalizedRect: const Rect.fromLTWH(0.000, 0.000, 0.120, 0.085),
              onTap: () => Navigator.of(context).maybePop(),
            ),
            _hotspot(
              id: 'weekly-quests.daily-streak',
              semanticLabel: 'Günlük Seri',
              normalizedRect: const Rect.fromLTWH(0.060, 0.355, 0.880, 0.120),
              callback: onDailyStreak,
            ),
            _hotspot(
              id: 'weekly-quests.claim-quest-chain',
              semanticLabel: 'Görev Zinciri ödülünü al',
              normalizedRect: const Rect.fromLTWH(0.745, 0.865, 0.210, 0.060),
              callback: onClaimQuestChainReward,
            ),
          ],
        ),
      ),
    );
  }
}
