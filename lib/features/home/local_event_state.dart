import 'package:flutter/foundation.dart';

enum EventsFilter { active, upcoming, completed }

/// These identities come from the approved Events artwork. They are navigation
/// references, not a live schedule, participation record or reward authority.
@immutable
class EventReference {
  const EventReference({
    required this.id,
    required this.title,
    required this.artworkSection,
  });

  final String id;
  final String title;
  final EventsFilter artworkSection;
}

class LocalEventOwner {
  const LocalEventOwner();

  static const runeStorm = EventReference(
    id: 'rune-storm',
    title: 'Rune Fırtınası',
    artworkSection: EventsFilter.active,
  );
  static const movementMasterWeek = EventReference(
    id: 'movement-master-week',
    title: 'Hareket Ustası Haftası',
    artworkSection: EventsFilter.active,
  );
  static const ancientValleyChallenge = EventReference(
    id: 'ancient-valley-challenge',
    title: 'Kadim Vadi Mücadelesi',
    artworkSection: EventsFilter.active,
  );

  static const references = <EventReference>[
    runeStorm,
    movementMasterWeek,
    ancientValleyChallenge,
  ];

  List<EventReference> visibleFor(EventsFilter filter) => List.unmodifiable(
    references.where((event) => event.artworkSection == filter),
  );

  EventReference byId(String id) => references.singleWhere(
    (event) => event.id == id,
    orElse: () => throw ArgumentError.value(id, 'id', 'Unknown event'),
  );
}
