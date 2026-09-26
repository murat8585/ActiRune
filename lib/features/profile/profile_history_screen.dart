import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/artwork_sample_mask.dart';
import 'profile_history_state.dart';

export 'profile_history_state.dart' show HistoryTab, HistoryRange;

enum HistoryRootDestination { home, adventure, battle, hero, profile }

class ProfileHistoryScreen extends StatelessWidget {
  const ProfileHistoryScreen({
    super.key,
    this.onBack,
    this.onTab,
    this.onRange,
    this.onEntry,
    this.onRootNavigate,
    this.historyOwner,
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
  final ProfileHistoryOwner? historyOwner;
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
      enabled: callback != null || historyOwner != null,
      onTap: () {
        historyOwner?.selectTab(tab);
        callback?.call(tab);
      },
    );
  }

  ArtworkHotspot _entryHotspot({
    required int index,
    required Rect normalizedRect,
  }) {
    final callback = onEntry;
    final records = historyOwner?.visibleRecords;
    final record = records != null && index < records.length
        ? records[index]
        : null;
    return ArtworkHotspot(
      id: 'history.entry-$index',
      semanticLabel: record?.title ?? 'Geçmiş Kaydı ${index + 1}',
      normalizedRect: normalizedRect,
      enabled: historyOwner == null
          ? callback != null
          : record != null && callback != null,
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
    if (historyOwner != null) {
      return AnimatedBuilder(
        animation: historyOwner!,
        builder: (context, _) => _buildScreen(context),
      );
    }
    return _buildScreen(context);
  }

  Future<void> _chooseRange(BuildContext context) async {
    final owner = historyOwner;
    if (owner == null) return;
    final selected = await showDialog<HistoryRange>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Tarih aralığı'),
        children: [
          for (final range in HistoryRange.values)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, range),
              child: Text(range.name),
            ),
        ],
      ),
    );
    if (selected != null) owner.selectRange(selected);
  }

  Widget _buildScreen(BuildContext context) {
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
          overlays: historyOwner == null
              ? const []
              : [
                  ArtworkOverlay(
                    id: 'history-owned-records',
                    normalizedRect: const Rect.fromLTWH(.05, .26, .90, .61),
                    child: ArtworkSampleMask(
                      label: historyOwner!.visibleRecords.isEmpty
                          ? 'Doğrulanmış geçmiş kaydı yok'
                          : historyOwner!.visibleRecords
                                .take(7)
                                .map(
                                  (record) => '${record.id}: ${record.title}',
                                )
                                .join('\n'),
                    ),
                  ),
                  ArtworkOverlay(
                    id: 'history-current-filter',
                    normalizedRect: const Rect.fromLTWH(.39, .215, .55, .037),
                    child: ArtworkSampleMask(
                      label:
                          '${historyOwner!.selectedTab.name} • ${historyOwner!.selectedRange.name}',
                    ),
                  ),
                ],
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
              enabled: onRange != null || historyOwner != null,
              onTap: historyOwner == null
                  ? (onRange ?? () {})
                  : () => _chooseRange(context),
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
