import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/artwork_sample_mask.dart';
import 'local_settings_state.dart';

enum NotificationsRootDestination { home, adventure, battle, hero, profile }

enum NotificationPreference {
  questReminders,
  events,
  social,
  runeLeague,
  system,
}

class SettingsNotificationsScreen extends StatelessWidget {
  const SettingsNotificationsScreen({
    super.key,
    this.onBack,
    this.onToggle,
    this.onReminderHours,
    this.onRootNavigate,
    this.settingsOwner,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_remaining_13/09_SETTINGS_NOTIFICATIONS_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final ValueChanged<NotificationPreference>? onToggle;
  final VoidCallback? onReminderHours;
  final ValueChanged<NotificationsRootDestination>? onRootNavigate;
  final LocalSettingsOwner? settingsOwner;
  final bool battleRootEnabled;

  ArtworkHotspot _toggleHotspot({
    required NotificationPreference preference,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onToggle;
    final owner = settingsOwner;
    return ArtworkHotspot(
      id: 'settings-notifications.toggle-${preference.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null || owner != null,
      onTap: () {
        if (owner != null) unawaited(owner.toggle(_settingFor(preference)));
        callback?.call(preference);
      },
    );
  }

  LocalSetting _settingFor(NotificationPreference preference) =>
      switch (preference) {
        NotificationPreference.questReminders => LocalSetting.questReminders,
        NotificationPreference.events => LocalSetting.events,
        NotificationPreference.social => LocalSetting.social,
        NotificationPreference.runeLeague => LocalSetting.runeLeague,
        NotificationPreference.system => LocalSetting.system,
      };

  ArtworkHotspot _rootHotspot({
    required NotificationsRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != NotificationsRootDestination.battle ||
            battleRootEnabled);
    return ArtworkHotspot(
      id: 'settings-notifications.nav-${destination.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: enabled,
      onTap: enabled ? () => callback(destination) : () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (settingsOwner != null) {
      return AnimatedBuilder(
        animation: settingsOwner!,
        builder: (context, _) => _buildScreen(),
      );
    }
    return _buildScreen();
  }

  Widget _buildScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: artworkAsset,
          sourceSize: artworkSize,
          overlays: settingsOwner == null
              ? const []
              : [
                  for (final (index, preference)
                      in NotificationPreference.values.indexed)
                    ArtworkOverlay(
                      id: 'notifications-local-${preference.name}',
                      normalizedRect: Rect.fromLTWH(
                        .785,
                        .184 + index * .100,
                        .11,
                        .06,
                      ),
                      child: ArtworkSampleMask(
                        label: switch (settingsOwner!.value(
                          _settingFor(preference),
                        )) {
                          true => 'Açık',
                          false => 'Kapalı',
                          null => '?',
                        },
                      ),
                    ),
                ],
          hotspots: [
            ArtworkHotspot(
              id: 'settings-notifications.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.018, 0.010, 0.090, 0.060),
              enabled: onBack != null,
              onTap: onBack ?? () {},
            ),
            _toggleHotspot(
              preference: NotificationPreference.questReminders,
              semanticLabel: 'Görev Hatırlatmaları',
              normalizedRect: const Rect.fromLTWH(0.785, 0.184, 0.110, 0.060),
            ),
            _toggleHotspot(
              preference: NotificationPreference.events,
              semanticLabel: 'Etkinlik Bildirimleri',
              normalizedRect: const Rect.fromLTWH(0.785, 0.284, 0.110, 0.060),
            ),
            _toggleHotspot(
              preference: NotificationPreference.social,
              semanticLabel: 'Sosyal Bildirimler',
              normalizedRect: const Rect.fromLTWH(0.785, 0.384, 0.110, 0.060),
            ),
            _toggleHotspot(
              preference: NotificationPreference.runeLeague,
              semanticLabel: 'Rune Ligi Bildirimleri',
              normalizedRect: const Rect.fromLTWH(0.785, 0.484, 0.110, 0.060),
            ),
            _toggleHotspot(
              preference: NotificationPreference.system,
              semanticLabel: 'Sistem Bildirimleri',
              normalizedRect: const Rect.fromLTWH(0.785, 0.584, 0.110, 0.060),
            ),
            ArtworkHotspot(
              id: 'settings-notifications.reminder-hours',
              semanticLabel: 'Hatırlatma Saatleri',
              normalizedRect: const Rect.fromLTWH(0.060, 0.680, 0.870, 0.085),
              enabled: onReminderHours != null,
              onTap: onReminderHours ?? () {},
            ),
            _rootHotspot(
              destination: NotificationsRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: NotificationsRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: NotificationsRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: NotificationsRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.600, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: NotificationsRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.800, 0.906, 0.200, 0.094),
            ),
          ],
        ),
      ),
    );
  }
}
