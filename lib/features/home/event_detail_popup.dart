import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum EventDetailTask { verifiedBattles, eventGoal }

class EventDetailPopup extends StatelessWidget {
  const EventDetailPopup({
    super.key,
    required this.onClose,
    this.onJoin,
    this.onViewTasks,
    this.onTask,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_remaining_13/'
      '02_EVENT_DETAIL_POPUP_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback onClose;
  final VoidCallback? onJoin;
  final VoidCallback? onViewTasks;
  final ValueChanged<EventDetailTask>? onTask;

  ArtworkHotspot _actionHotspot({
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

  ArtworkHotspot _taskHotspot({
    required EventDetailTask task,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onTask;
    return ArtworkHotspot(
      id: 'event-detail.task-${task.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(task),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: ArtworkInteractionSurface(
        assetPath: artworkAsset,
        sourceSize: artworkSize,
        hotspots: [
          ArtworkHotspot(
            id: 'event-detail.close',
            semanticLabel: 'Etkinlik Detayını Kapat',
            normalizedRect: const Rect.fromLTWH(0.837, 0.116, 0.082, 0.046),
            onTap: onClose,
          ),
          _taskHotspot(
            task: EventDetailTask.verifiedBattles,
            semanticLabel: 'Doğrulanmış Savaş Görevi',
            normalizedRect: const Rect.fromLTWH(0.098, 0.461, 0.794, 0.047),
          ),
          _taskHotspot(
            task: EventDetailTask.eventGoal,
            semanticLabel: 'Etkinlik Hedefi Görevi',
            normalizedRect: const Rect.fromLTWH(0.098, 0.559, 0.794, 0.047),
          ),
          _actionHotspot(
            id: 'event-detail.join',
            semanticLabel: 'Etkinliğe Katıl',
            normalizedRect: const Rect.fromLTWH(0.088, 0.744, 0.463, 0.057),
            callback: onJoin,
          ),
          _actionHotspot(
            id: 'event-detail.view-tasks',
            semanticLabel: 'Görevleri Gör',
            normalizedRect: const Rect.fromLTWH(0.568, 0.744, 0.329, 0.057),
            callback: onViewTasks,
          ),
        ],
      ),
    );
  }
}
