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
    const navY = 0.930;
    const navH = 0.068;

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
              id: 'weekly.title',
              normalizedRect: Rect.fromLTWH(0.170, 0.300, 0.660, 0.055),
              child: CleanBaseText('HAFTALIK MACERA', fontSize: 24),
            ),
            ArtworkOverlay(
              id: 'weekly.row-1',
              normalizedRect: Rect.fromLTWH(0.180, 0.510, 0.340, 0.038),
              child: CleanBaseText('SAVAŞ', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'weekly.row-2',
              normalizedRect: Rect.fromLTWH(0.180, 0.602, 0.340, 0.038),
              child: CleanBaseText('KORUMA', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'weekly.row-3',
              normalizedRect: Rect.fromLTWH(0.180, 0.694, 0.340, 0.038),
              child: CleanBaseText('KEŞİF / USTALIK', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'weekly.row-4',
              normalizedRect: Rect.fromLTWH(0.180, 0.786, 0.340, 0.038),
              child: CleanBaseText('LUMI / GELİŞİM', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'weekly.row-5',
              normalizedRect: Rect.fromLTWH(0.180, 0.878, 0.340, 0.038),
              child: CleanBaseText('GÖREV ZİNCİRİ', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'weekly.nav-bg',
              normalizedRect: Rect.fromLTWH(0.000, navY, 1.000, navH),
              child: ColoredBox(color: Color(0xE606111E)),
            ),
            ArtworkOverlay(
              id: 'weekly.nav-home',
              normalizedRect: Rect.fromLTWH(0.000, navY + 0.018, 0.200, 0.030),
              child: CleanBaseText('Ana Dünya', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'weekly.nav-adventure',
              normalizedRect: Rect.fromLTWH(0.200, navY + 0.018, 0.200, 0.030),
              child: CleanBaseText('Macera', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'weekly.nav-battle',
              normalizedRect: Rect.fromLTWH(0.400, navY + 0.018, 0.190, 0.030),
              child: CleanBaseText('Savaş', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'weekly.nav-hero',
              normalizedRect: Rect.fromLTWH(0.590, navY + 0.018, 0.200, 0.030),
              child: CleanBaseText('Kahraman', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'weekly.nav-profile',
              normalizedRect: Rect.fromLTWH(0.790, navY + 0.018, 0.210, 0.030),
              child: CleanBaseText('Profil', fontSize: 12, background: Colors.transparent),
            ),
          ],
          hotspots: [
            _hotspot(
              id: 'weekly-quests.daily-streak',
              semanticLabel: 'Günlük Seri',
              normalizedRect: const Rect.fromLTWH(0.060, 0.360, 0.880, 0.120),
              callback: onDailyStreak,
            ),
            _hotspot(
              id: 'weekly-quests.claim-quest-chain',
              semanticLabel: 'Görev Zinciri ödülünü al',
              normalizedRect: const Rect.fromLTWH(0.745, 0.865, 0.210, 0.060),
              callback: onClaimQuestChainReward,
            ),
            _rootHotspot(
              destination: WeeklyQuestsRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, navY, 0.200, navH),
            ),
            _rootHotspot(
              destination: WeeklyQuestsRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, navY, 0.200, navH),
            ),
            _rootHotspot(
              destination: WeeklyQuestsRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, navY, 0.190, navH),
            ),
            _rootHotspot(
              destination: WeeklyQuestsRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.590, navY, 0.200, navH),
            ),
            _rootHotspot(
              destination: WeeklyQuestsRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.790, navY, 0.210, navH),
            ),
          ],
        ),
      ),
    );
  }
}
