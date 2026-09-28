import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/clean_base_text.dart';

enum HomeRootDestination { home, adventure, battle, hero, profile }

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
  static const _gold = Color(0xFFE8C875);
  static const _ivory = Color(0xFFF3E7C6);

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
    const navY = 0.900;
    const navH = 0.098;

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
              normalizedRect: Rect.fromLTWH(0.145, 0.020, 0.215, 0.030),
              child: CleanBaseText(
                'ActiHero',
                fontSize: 15,
                color: _ivory,
                textAlign: TextAlign.left,
                alignment: Alignment.centerLeft,
                letterSpacing: 0.55,
              ),
            ),
            ArtworkOverlay(
              id: 'home.world-map-label',
              normalizedRect: Rect.fromLTWH(0.105, 0.720, 0.300, 0.034),
              child: CleanBaseText(
                'DÜNYA HARİTASI',
                fontSize: 16,
                color: _gold,
                letterSpacing: 1.05,
              ),
            ),
            ArtworkOverlay(
              id: 'home.battle-label',
              normalizedRect: Rect.fromLTWH(0.595, 0.720, 0.305, 0.034),
              child: CleanBaseText(
                'SAVAŞA HAZIRLAN',
                fontSize: 16,
                color: _gold,
                letterSpacing: 1.0,
              ),
            ),
            ArtworkOverlay(
              id: 'home.rewards-label',
              normalizedRect: Rect.fromLTWH(0.090, 0.838, 0.220, 0.030),
              child: CleanBaseText(
                'ÖDÜLLER',
                fontSize: 14,
                color: _ivory,
                letterSpacing: 0.9,
              ),
            ),
            ArtworkOverlay(
              id: 'home.quests-label',
              normalizedRect: Rect.fromLTWH(0.385, 0.838, 0.230, 0.030),
              child: CleanBaseText(
                'GÖREVLER',
                fontSize: 14,
                color: _ivory,
                letterSpacing: 0.9,
              ),
            ),
            ArtworkOverlay(
              id: 'home.summary-label',
              normalizedRect: Rect.fromLTWH(0.700, 0.838, 0.215, 0.030),
              child: CleanBaseText(
                'DÜNÜN ÖZETİ',
                fontSize: 14,
                color: _ivory,
                letterSpacing: 0.8,
              ),
            ),
            ArtworkOverlay(
              id: 'home.nav-home-label',
              normalizedRect: Rect.fromLTWH(0.018, 0.958, 0.165, 0.026),
              child: CleanBaseText(
                'Ana Dünya',
                fontSize: 11,
                color: _gold,
                letterSpacing: 0.25,
              ),
            ),
            ArtworkOverlay(
              id: 'home.nav-adventure-label',
              normalizedRect: Rect.fromLTWH(0.215, 0.958, 0.170, 0.026),
              child: CleanBaseText(
                'Macera',
                fontSize: 11,
                color: _ivory,
                letterSpacing: 0.25,
              ),
            ),
            ArtworkOverlay(
              id: 'home.nav-battle-label',
              normalizedRect: Rect.fromLTWH(0.410, 0.958, 0.170, 0.026),
              child: CleanBaseText(
                'Savaş',
                fontSize: 11,
                color: _ivory,
                letterSpacing: 0.25,
              ),
            ),
            ArtworkOverlay(
              id: 'home.nav-hero-label',
              normalizedRect: Rect.fromLTWH(0.605, 0.958, 0.180, 0.026),
              child: CleanBaseText(
                'Kahraman',
                fontSize: 11,
                color: _ivory,
                letterSpacing: 0.25,
              ),
            ),
            ArtworkOverlay(
              id: 'home.nav-profile-label',
              normalizedRect: Rect.fromLTWH(0.805, 0.958, 0.175, 0.026),
              child: CleanBaseText(
                'Profil',
                fontSize: 11,
                color: _ivory,
                letterSpacing: 0.25,
              ),
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
              normalizedRect: const Rect.fromLTWH(0.035, 0.635, 0.445, 0.135),
              callback: onWorldMap,
            ),
            _rootHotspot(
              id: 'home.battle-card',
              destination: HomeRootDestination.battle,
              semanticLabel: 'Savaşa Hazırlan',
              normalizedRect: const Rect.fromLTWH(0.515, 0.635, 0.450, 0.135),
            ),
            _hotspot(
              id: 'home.rewards',
              semanticLabel: 'Ödüller',
              normalizedRect: const Rect.fromLTWH(0.025, 0.780, 0.305, 0.105),
              callback: onRewards,
            ),
            _hotspot(
              id: 'home.quests',
              semanticLabel: 'Görevler',
              normalizedRect: const Rect.fromLTWH(0.345, 0.780, 0.310, 0.105),
              callback: onQuests,
            ),
            _hotspot(
              id: 'home.yesterday-summary',
              semanticLabel: 'Dünün Özeti',
              normalizedRect: const Rect.fromLTWH(0.670, 0.780, 0.305, 0.105),
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
