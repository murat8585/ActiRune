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
    const navY = 0.928;
    const navH = 0.070;

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
              id: 'daily.title',
              normalizedRect: Rect.fromLTWH(0.155, 0.170, 0.690, 0.060),
              child: CleanBaseText('GÜNLÜK MACERA', fontSize: 24),
            ),
            ArtworkOverlay(
              id: 'daily.row-1',
              normalizedRect: Rect.fromLTWH(0.215, 0.455, 0.340, 0.040),
              child: CleanBaseText('KEŞİF', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'daily.row-2',
              normalizedRect: Rect.fromLTWH(0.215, 0.555, 0.340, 0.040),
              child: CleanBaseText('SAVAŞ', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'daily.row-3',
              normalizedRect: Rect.fromLTWH(0.215, 0.655, 0.340, 0.040),
              child: CleanBaseText('HAREKET / FORM', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'daily.row-4',
              normalizedRect: Rect.fromLTWH(0.215, 0.755, 0.340, 0.040),
              child: CleanBaseText('LUMI / GELİŞİM', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'daily.row-5',
              normalizedRect: Rect.fromLTWH(0.215, 0.855, 0.340, 0.040),
              child: CleanBaseText('TOPARLAMA / DENGE', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'daily.nav-bg',
              normalizedRect: Rect.fromLTWH(0.000, navY, 1.000, navH),
              child: ColoredBox(color: Color(0xE606111E)),
            ),
            ArtworkOverlay(
              id: 'daily.nav-home',
              normalizedRect: Rect.fromLTWH(0.000, navY + 0.020, 0.200, 0.030),
              child: CleanBaseText('Ana Dünya', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'daily.nav-adventure',
              normalizedRect: Rect.fromLTWH(0.200, navY + 0.020, 0.200, 0.030),
              child: CleanBaseText('Macera', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'daily.nav-battle',
              normalizedRect: Rect.fromLTWH(0.400, navY + 0.020, 0.190, 0.030),
              child: CleanBaseText('Savaş', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'daily.nav-hero',
              normalizedRect: Rect.fromLTWH(0.590, navY + 0.020, 0.200, 0.030),
              child: CleanBaseText('Kahraman', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'daily.nav-profile',
              normalizedRect: Rect.fromLTWH(0.790, navY + 0.020, 0.210, 0.030),
              child: CleanBaseText('Profil', fontSize: 12, background: Colors.transparent),
            ),
          ],
          hotspots: [
            _hotspot(
              id: 'daily-quests.progress-reward',
              semanticLabel: 'Günlük Rün Sandığı',
              normalizedRect: const Rect.fromLTWH(0.365, 0.320, 0.270, 0.115),
              callback: onProgressReward,
            ),
            _hotspot(
              id: 'daily-quests.claim-explore',
              semanticLabel: 'Keşif ödülünü al',
              normalizedRect: const Rect.fromLTWH(0.720, 0.455, 0.235, 0.065),
              callback: onClaimExploreReward,
            ),
            _hotspot(
              id: 'daily-quests.claim-battle',
              semanticLabel: 'Savaş ödülünü al',
              normalizedRect: const Rect.fromLTWH(0.720, 0.555, 0.235, 0.065),
              callback: onClaimBattleReward,
            ),
            _hotspot(
              id: 'daily-quests.free-change',
              semanticLabel: 'Görev değiştir',
              normalizedRect: const Rect.fromLTWH(0.190, 0.850, 0.385, 0.060),
              callback: onFreeTaskChange,
            ),
            _hotspot(
              id: 'daily-quests.change-help',
              semanticLabel: 'Görev değiştirme yardımı',
              normalizedRect: const Rect.fromLTWH(0.570, 0.850, 0.085, 0.060),
              callback: onTaskChangeHelp,
            ),
            _rootHotspot(
              destination: DailyQuestsRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, navY, 0.200, navH),
            ),
            _rootHotspot(
              destination: DailyQuestsRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, navY, 0.200, navH),
            ),
            _rootHotspot(
              destination: DailyQuestsRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, navY, 0.190, navH),
            ),
            _rootHotspot(
              destination: DailyQuestsRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.590, navY, 0.200, navH),
            ),
            _rootHotspot(
              destination: DailyQuestsRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.790, navY, 0.210, navH),
            ),
          ],
        ),
      ),
    );
  }
}
