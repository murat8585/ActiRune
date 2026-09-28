import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/clean_base_text.dart';

enum QuestsRootDestination { home, adventure, battle, hero, profile }

/// Final60 clean-base Quest Center.
///
/// The artwork supplies the progression/reward geometry. Daily and weekly
/// entry labels plus root navigation stay Flutter-owned for localization.
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

  final VoidCallback onDailyQuests;
  final VoidCallback onWeeklyQuests;
  final ValueChanged<QuestsRootDestination>? onRootNavigate;
  final bool battleRootEnabled;

  ArtworkHotspot _rootHotspot({
    required QuestsRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != QuestsRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'quests.nav-${destination.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: enabled,
      onTap: enabled ? () => callback(destination) : () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    const navY = 0.920;
    const navH = 0.078;

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
              id: 'quests.title',
              normalizedRect: Rect.fromLTWH(0.155, 0.145, 0.690, 0.060),
              child: CleanBaseText('GÖREV MERKEZİ', fontSize: 24),
            ),
            ArtworkOverlay(
              id: 'quests.progress-title',
              normalizedRect: Rect.fromLTWH(0.250, 0.375, 0.500, 0.040),
              child: CleanBaseText('GÖREV YOLCULUĞU', fontSize: 16),
            ),
            ArtworkOverlay(
              id: 'quests.daily-label',
              normalizedRect: Rect.fromLTWH(0.175, 0.452, 0.385, 0.042),
              child: CleanBaseText('GÜNLÜK GÖREVLER', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'quests.daily-button',
              normalizedRect: Rect.fromLTWH(0.720, 0.452, 0.220, 0.042),
              child: CleanBaseText('AÇ', fontSize: 15),
            ),
            ArtworkOverlay(
              id: 'quests.weekly-label',
              normalizedRect: Rect.fromLTWH(0.175, 0.548, 0.385, 0.042),
              child: CleanBaseText('HAFTALIK GÖREVLER', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'quests.weekly-button',
              normalizedRect: Rect.fromLTWH(0.720, 0.548, 0.220, 0.042),
              child: CleanBaseText('AÇ', fontSize: 15),
            ),
            ArtworkOverlay(
              id: 'quests.nav-bg',
              normalizedRect: Rect.fromLTWH(0.000, navY, 1.000, navH),
              child: ColoredBox(color: Color(0xCC06111E)),
            ),
            ArtworkOverlay(
              id: 'quests.nav-home-label',
              normalizedRect: Rect.fromLTWH(0.000, navY + 0.024, 0.200, 0.032),
              child: CleanBaseText('Ana Dünya', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'quests.nav-adventure-label',
              normalizedRect: Rect.fromLTWH(0.200, navY + 0.024, 0.200, 0.032),
              child: CleanBaseText('Macera', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'quests.nav-battle-label',
              normalizedRect: Rect.fromLTWH(0.400, navY + 0.024, 0.190, 0.032),
              child: CleanBaseText('Savaş', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'quests.nav-hero-label',
              normalizedRect: Rect.fromLTWH(0.590, navY + 0.024, 0.200, 0.032),
              child: CleanBaseText('Kahraman', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'quests.nav-profile-label',
              normalizedRect: Rect.fromLTWH(0.790, navY + 0.024, 0.210, 0.032),
              child: CleanBaseText('Profil', fontSize: 12, background: Colors.transparent),
            ),
          ],
          hotspots: [
            ArtworkHotspot(
              id: 'quests.daily',
              semanticLabel: 'Günlük Görevler',
              normalizedRect: const Rect.fromLTWH(0.040, 0.425, 0.920, 0.090),
              onTap: onDailyQuests,
            ),
            ArtworkHotspot(
              id: 'quests.weekly',
              semanticLabel: 'Haftalık Görevler',
              normalizedRect: const Rect.fromLTWH(0.040, 0.520, 0.920, 0.090),
              onTap: onWeeklyQuests,
            ),
            _rootHotspot(
              destination: QuestsRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, navY, 0.200, navH),
            ),
            _rootHotspot(
              destination: QuestsRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, navY, 0.200, navH),
            ),
            _rootHotspot(
              destination: QuestsRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, navY, 0.190, navH),
            ),
            _rootHotspot(
              destination: QuestsRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.590, navY, 0.200, navH),
            ),
            _rootHotspot(
              destination: QuestsRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.790, navY, 0.210, navH),
            ),
          ],
        ),
      ),
    );
  }
}
