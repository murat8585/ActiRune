import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import 'home_preview_dialog.dart';
import 'local_event_state.dart';

export 'local_event_state.dart' show EventsFilter;

enum EventsRootDestination { home, adventure, battle, hero, profile }

class EventsScreen extends StatefulWidget {
  const EventsScreen({
    super.key,
    this.onBack,
    this.onInfo,
    this.onFeaturedEvent,
    this.onFilter,
    this.onEvent,
    this.eventOwner = const LocalEventOwner(),
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
  final ValueChanged<String>? onEvent;
  final LocalEventOwner eventOwner;
  final ValueChanged<EventsRootDestination>? onRootNavigate;
  final bool battleRootEnabled;

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  EventsFilter selectedFilter = EventsFilter.active;

  List<EventReference> get visibleEvents =>
      widget.eventOwner.visibleFor(selectedFilter);

  Rect _filterRect(EventsFilter filter) {
    return switch (filter) {
      EventsFilter.active => const Rect.fromLTWH(0.020, 0.465, 0.306, 0.057),
      EventsFilter.upcoming => const Rect.fromLTWH(0.330, 0.465, 0.320, 0.057),
      EventsFilter.completed => const Rect.fromLTWH(0.655, 0.465, 0.312, 0.057),
    };
  }

  void _selectFilter(EventsFilter filter) {
    if (selectedFilter != filter) {
      setState(() => selectedFilter = filter);
    }
    widget.onFilter?.call(filter);
  }

  void _showInfo() {
    widget.onInfo?.call();
    HomePreviewDialog.show(
      context,
      title: 'Etkinlikler',
      message:
          'Etkinlikler süreli hareket hedeflerini, özel görevleri ve dönemsel ödülleri bir araya getirir. Bu önizlemede kartlar ve filtre seçimi denenebilir; canlı katılım ve ödül sahipliği henüz bağlanmamıştır.',
    );
  }

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
  }) {
    return ArtworkHotspot(
      id: 'events.filter-${filter.name}',
      semanticLabel: semanticLabel,
      normalizedRect: _filterRect(filter),
      onTap: () => _selectFilter(filter),
    );
  }

  ArtworkHotspot _eventHotspot({
    required int index,
    required Rect normalizedRect,
  }) {
    final callback = widget.onEvent;
    final event = index < visibleEvents.length ? visibleEvents[index] : null;
    return ArtworkHotspot(
      id: 'events.event-$index',
      semanticLabel: event?.title ?? 'Etkinlik yok',
      normalizedRect: normalizedRect,
      enabled: callback != null && event != null,
      onTap: callback == null || event == null
          ? () {}
          : () => callback(event.id),
    );
  }

  ArtworkHotspot _rootHotspot({
    required EventsRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = widget.onRootNavigate;
    final enabled =
        callback != null &&
        (destination != EventsRootDestination.battle ||
            widget.battleRootEnabled);
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
          assetPath: EventsScreen.artworkAsset,
          sourceSize: EventsScreen.artworkSize,
          hotspots: [
            _hotspot(
              id: 'events.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.016, 0.012, 0.095, 0.055),
              callback: widget.onBack,
            ),
            _hotspot(
              id: 'events.info',
              semanticLabel: 'Bilgi',
              normalizedRect: const Rect.fromLTWH(0.893, 0.012, 0.083, 0.055),
              callback: _showInfo,
            ),
            _hotspot(
              id: 'events.featured',
              semanticLabel: 'Rune Fırtınası Etkinliğini Gör',
              normalizedRect: const Rect.fromLTWH(0.535, 0.385, 0.414, 0.066),
              callback: widget.onFeaturedEvent,
            ),
            _filterHotspot(
              filter: EventsFilter.active,
              semanticLabel: 'Aktif Etkinlikler',
            ),
            _filterHotspot(
              filter: EventsFilter.upcoming,
              semanticLabel: 'Yaklaşan Etkinlikler',
            ),
            _filterHotspot(
              filter: EventsFilter.completed,
              semanticLabel: 'Tamamlanan Etkinlikler',
            ),
            _eventHotspot(
              index: 0,
              normalizedRect: const Rect.fromLTWH(0.020, 0.525, 0.948, 0.097),
            ),
            _eventHotspot(
              index: 1,
              normalizedRect: const Rect.fromLTWH(0.020, 0.630, 0.948, 0.097),
            ),
            _eventHotspot(
              index: 2,
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
