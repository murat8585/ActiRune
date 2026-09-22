import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum EventsRootDestination { home, adventure, battle, hero, profile }

enum EventsFilter { active, upcoming, completed }

class EventsScreen extends StatelessWidget {
  const EventsScreen({
    super.key,
    this.onBack,
    this.onInfo,
    this.onFeaturedEvent,
    this.onFilter,
    this.onEvent,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_remaining_13/01_EVENTS_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final VoidCallback? onInfo;
  final VoidCallback? onFeaturedEvent;
  final ValueChanged<EventsFilter>? onFilter;
  final ValueChanged<int>? onEvent;
  final ValueChanged<EventsRootDestination>? onRootNavigate;
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

  ArtworkHotspot _filterHotspot({
    required EventsFilter filter,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onFilter;
    return ArtworkHotspot(
      id: 'events.filter-${filter.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(filter),
    );
  }

  ArtworkHotspot _eventHotspot({
    required int index,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onEvent;
    return ArtworkHotspot(
      id: 'events.event-$index',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(index),
    );
  }

  ArtworkHotspot _rootHotspot({
    required EventsRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != EventsRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'events.nav-${destination.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: enabled,
      onTap: enabled ? () => callback(destination) : () {},
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
          hotspots: [
            _hotspot(
              id: 'events.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.016, 0.012, 0.095, 0.055),
              callback: onBack,
            ),
            _hotspot(
              id: 'events.info',
              semanticLabel: 'Bilgi',
              normalizedRect: const Rect.fromLTWH(0.893, 0.012, 0.083, 0.055),
              callback: onInfo,
            ),
            _hotspot(
              id: 'events.featured',
              semanticLabel: 'Rune Fırtınası Etkinliğini Gör',
              normalizedRect: const Rect.fromLTWH(0.535, 0.385, 0.414, 0.066),
              callback: onFeaturedEvent,
            ),
            _filterHotspot(
              filter: EventsFilter.active,
              semanticLabel: 'Aktif Etkinlikler',
              normalizedRect: const Rect.fromLTWH(0.020, 0.465, 0.306, 0.057),
            ),
            _filterHotspot(
              filter: EventsFilter.upcoming,
              semanticLabel: 'Yaklaşan Etkinlikler',
              normalizedRect: const Rect.fromLTWH(0.330, 0.465, 0.320, 0.057),
            ),
            _filterHotspot(
              filter: EventsFilter.completed,
              semanticLabel: 'Tamamlanan Etkinlikler',
              normalizedRect: const Rect.fromLTWH(0.655, 0.465, 0.312, 0.057),
            ),
            _eventHotspot(
              index: 0,
              semanticLabel: 'Rune Fırtınası',
              normalizedRect: const Rect.fromLTWH(0.020, 0.525, 0.948, 0.097),
            ),
            _eventHotspot(
              index: 1,
              semanticLabel: 'Hareket Ustası Haftası',
              normalizedRect: const Rect.fromLTWH(0.020, 0.630, 0.948, 0.097),
            ),
            _eventHotspot(
              index: 2,
              semanticLabel: 'Kadim Vadi Mücadelesi',
              normalizedRect: const Rect.fromLTWH(0.020, 0.735, 0.948, 0.097),
            ),
            _rootHotspot(
              destination: EventsRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, 0.884, 0.200, 0.116),
            ),
            _rootHotspot(
              destination: EventsRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, 0.884, 0.200, 0.116),
            ),
            _rootHotspot(
              destination: EventsRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, 0.884, 0.200, 0.116),
            ),
            _rootHotspot(
              destination: EventsRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.600, 0.884, 0.200, 0.116),
            ),
            _rootHotspot(
              destination: EventsRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.800, 0.884, 0.200, 0.116),
            ),
          ],
        ),
      ),
    );
  }
}
