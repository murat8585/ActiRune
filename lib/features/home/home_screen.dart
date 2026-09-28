import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/clean_base_text.dart';

enum HomeRootDestination { home, adventure, battle, hero, profile }

/// Final60 clean-base Home integration.
///
/// The PNG owns the premium static art and panel geometry. Localizable labels
/// and navigation semantics stay in Flutter so later language packs do not
/// require regenerating the artwork.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    this.onDailyStreak,
    this.onMessages,
    this.onQuests,
    this.onEvents,
    this.onSettings,
    this.onWorldMap,
    this.onYesterdaySummary,
    this.onRewards,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'assets/ui/clean_base_final_60/32__EARLY_QA_POS_25__PASS.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onDailyStreak;
  final VoidCallback? onMessages;
  final VoidCallback? onQuests;
  final VoidCallback? onEvents;
  final VoidCallback? onSettings;
  final VoidCallback? onWorldMap;
  final VoidCallback? onYesterdaySummary;
  final VoidCallback? onRewards;
  final ValueChanged<HomeRootDestination>? onRootNavigate;
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
    required HomeRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
    String? id,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != HomeRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: id ?? 'home.nav-${destination.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: enabled,
      onTap: enabled ? () => callback(destination) : () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    const navY = 0.904;
    const navH = 0.082;

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
              id: 'home.player-name',
              normalizedRect: Rect.fromLTWH(0.095, 0.022, 0.260, 0.045),
              child: CleanBaseText('ActiHero', fontSize: 20),
            ),
            ArtworkOverlay(
              id: 'home.world-map-label',
              normalizedRect: Rect.fromLTWH(0.055, 0.696, 0.390, 0.042),
              child: CleanBaseText('DÜNYA HARİTASI', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'home.battle-label',
              normalizedRect: Rect.fromLTWH(0.555, 0.696, 0.390, 0.042),
              child: CleanBaseText('SAVAŞA HAZIRLAN', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'home.rewards-label',
              normalizedRect: Rect.fromLTWH(0.045, 0.824, 0.270, 0.038),
              child: CleanBaseText('ÖDÜLLER', fontSize: 15),
            ),
            ArtworkOverlay(
              id: 'home.quests-label',
              normalizedRect: Rect.fromLTWH(0.365, 0.824, 0.270, 0.038),
              child: CleanBaseText('GÖREVLER', fontSize: 15),
            ),
            ArtworkOverlay(
              id: 'home.summary-label',
              normalizedRect: Rect.fromLTWH(0.685, 0.824, 0.270, 0.038),
              child: CleanBaseText('DÜNÜN ÖZETİ', fontSize: 15),
            ),
            ArtworkOverlay(
              id: 'home.nav-home-label',
              normalizedRect: Rect.fromLTWH(0.005, navY + 0.052, 0.190, 0.024),
              child: CleanBaseText('Ana Dünya', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'home.nav-adventure-label',
              normalizedRect: Rect.fromLTWH(0.205, navY + 0.052, 0.190, 0.024),
              child: CleanBaseText('Macera', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'home.nav-battle-label',
              normalizedRect: Rect.fromLTWH(0.405, navY + 0.052, 0.180, 0.024),
              child: CleanBaseText('Savaş', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'home.nav-hero-label',
              normalizedRect: Rect.fromLTWH(0.590, navY + 0.052, 0.195, 0.024),
              child: CleanBaseText('Kahraman', fontSize: 12, background: Colors.transparent),
            ),
            ArtworkOverlay(
              id: 'home.nav-profile-label',
              normalizedRect: Rect.fromLTWH(0.795, navY + 0.052, 0.195, 0.024),
              child: CleanBaseText('Profil', fontSize: 12, background: Colors.transparent),
            ),
          ],
          hotspots: [
            _hotspot(
              id: 'home.daily-streak',
              semanticLabel: 'Günlük Seri',
              normalizedRect: const Rect.fromLTWH(0.015, 0.095, 0.175, 0.075),
              callback: onDailyStreak,
            ),
            _hotspot(
              id: 'home.messages',
              semanticLabel: 'Mesajlar',
              normalizedRect: const Rect.fromLTWH(0.875, 0.090, 0.110, 0.070),
              callback: onMessages,
            ),
            _hotspot(
              id: 'home.events',
              semanticLabel: 'Etkinlikler',
              normalizedRect: const Rect.fromLTWH(0.875, 0.165, 0.110, 0.070),
              callback: onEvents,
            ),
            _hotspot(
              id: 'home.settings',
              semanticLabel: 'Ayarlar',
              normalizedRect: const Rect.fromLTWH(0.840, 0.012, 0.145, 0.070),
              callback: onSettings,
            ),
            _hotspot(
              id: 'home.world-map',
              semanticLabel: 'Dünya Haritası',
              normalizedRect: const Rect.fromLTWH(0.030, 0.620, 0.455, 0.125),
              callback: onWorldMap,
            ),
            _rootHotspot(
              id: 'home.battle-card',
              destination: HomeRootDestination.battle,
              semanticLabel: 'Savaşa Hazırlan',
              normalizedRect: const Rect.fromLTWH(0.515, 0.620, 0.455, 0.125),
            ),
            _hotspot(
              id: 'home.rewards',
              semanticLabel: 'Ödüller',
              normalizedRect: const Rect.fromLTWH(0.025, 0.755, 0.305, 0.115),
              callback: onRewards,
            ),
            _hotspot(
              id: 'home.quests',
              semanticLabel: 'Görevler',
              normalizedRect: const Rect.fromLTWH(0.345, 0.755, 0.310, 0.115),
              callback: onQuests,
            ),
            _hotspot(
              id: 'home.yesterday-summary',
              semanticLabel: 'Dünün Özeti',
              normalizedRect: const Rect.fromLTWH(0.670, 0.755, 0.305, 0.115),
              callback: onYesterdaySummary,
            ),
            _rootHotspot(
              destination: HomeRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, navY, 0.200, navH),
            ),
            _rootHotspot(
              destination: HomeRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, navY, 0.200, navH),
            ),
            _rootHotspot(
              destination: HomeRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, navY, 0.190, navH),
            ),
            _rootHotspot(
              destination: HomeRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.590, navY, 0.200, navH),
            ),
            _rootHotspot(
              destination: HomeRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.790, navY, 0.210, navH),
            ),
          ],
        ),
      ),
    );
  }
}
