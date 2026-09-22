import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum HistoryRootDestination { home, adventure, battle, hero, profile }

enum HistoryTab { all, battles, movements, rewards }

class ProfileHistoryScreen extends StatelessWidget {
  const ProfileHistoryScreen({
    super.key,
    this.onBack,
    this.onTab,
    this.onRange,
    this.onEntry,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_remaining_13/13_PROFILE_HISTORY_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final ValueChanged<HistoryTab>? onTab;
  final VoidCallback? onRange;
  final ValueChanged<int>? onEntry;
  final ValueChanged<HistoryRootDestination>? onRootNavigate;
  final bool battleRootEnabled;

  ArtworkHotspot _tabHotspot({
    required HistoryTab tab,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onTab;
    return ArtworkHotspot(
      id: 'history.tab-${tab.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(tab),
    );
  }

  ArtworkHotspot _entryHotspot({
    required int index,
    required Rect normalizedRect,
  }) {
    final callback = onEntry;
    return ArtworkHotspot(
      id: 'history.entry-$index',
      semanticLabel: 'Geçmiş Kaydı ${index + 1}',
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(index),
    );
  }

  ArtworkHotspot _rootHotspot({
    required HistoryRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != HistoryRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'history.nav-${destination.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: enabled,
      onTap: enabled ? () => callback(destination) : () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    const entryRects = <Rect>[
      Rect.fromLTWH(0.055, 0.260, 0.875, 0.082),
      Rect.fromLTWH(0.055, 0.348, 0.875, 0.082),
      Rect.fromLTWH(0.055, 0.436, 0.875, 0.082),
      Rect.fromLTWH(0.055, 0.524, 0.875, 0.082),
      Rect.fromLTWH(0.055, 0.612, 0.875, 0.082),
      Rect.fromLTWH(0.055, 0.700, 0.875, 0.082),
      Rect.fromLTWH(0.055, 0.788, 0.875, 0.082),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: artworkAsset,
          sourceSize: artworkSize,
          hotspots: [
            ArtworkHotspot(
              id: 'history.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.018, 0.010, 0.090, 0.060),
              enabled: onBack != null,
              onTap: onBack ?? () {},
            ),
            _tabHotspot(
              tab: HistoryTab.all,
              semanticLabel: 'Tümü',
              normalizedRect: const Rect.fromLTWH(0.040, 0.144, 0.224, 0.064),
            ),
            _tabHotspot(
              tab: HistoryTab.battles,
              semanticLabel: 'Savaşlar',
              normalizedRect: const Rect.fromLTWH(0.265, 0.144, 0.225, 0.064),
            ),
            _tabHotspot(
              tab: HistoryTab.movements,
              semanticLabel: 'Hareketler',
              normalizedRect: const Rect.fromLTWH(0.490, 0.144, 0.225, 0.064),
            ),
            _tabHotspot(
              tab: HistoryTab.rewards,
              semanticLabel: 'Ödüller',
              normalizedRect: const Rect.fromLTWH(0.715, 0.144, 0.230, 0.064),
            ),
            ArtworkHotspot(
              id: 'history.range',
              semanticLabel: 'Tarih Aralığı',
              normalizedRect: const Rect.fromLTWH(0.055, 0.218, 0.295, 0.034),
              enabled: onRange != null,
              onTap: onRange ?? () {},
            ),
            for (var index = 0; index < entryRects.length; index++)
              _entryHotspot(index: index, normalizedRect: entryRects[index]),
            _rootHotspot(
              destination: HistoryRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: HistoryRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: HistoryRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: HistoryRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.600, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: HistoryRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.800, 0.906, 0.200, 0.094),
            ),
          ],
        ),
      ),
    );
  }
}
