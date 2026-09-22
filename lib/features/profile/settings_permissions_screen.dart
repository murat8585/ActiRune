import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum PermissionsRootDestination { home, adventure, battle, hero, profile }

enum PermissionTarget {
  camera,
  physicalActivity,
  notifications,
  healthIntegration,
}

class SettingsPermissionsScreen extends StatelessWidget {
  const SettingsPermissionsScreen({
    super.key,
    this.onBack,
    this.onManage,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_remaining_13/11_SETTINGS_PERMISSIONS_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final ValueChanged<PermissionTarget>? onManage;
  final ValueChanged<PermissionsRootDestination>? onRootNavigate;
  final bool battleRootEnabled;

  ArtworkHotspot _manageHotspot({
    required PermissionTarget target,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onManage;
    return ArtworkHotspot(
      id: 'settings-permissions.manage-${target.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(target),
    );
  }

  ArtworkHotspot _rootHotspot({
    required PermissionsRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != PermissionsRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'settings-permissions.nav-${destination.name}',
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
            ArtworkHotspot(
              id: 'settings-permissions.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.018, 0.010, 0.090, 0.060),
              enabled: onBack != null,
              onTap: onBack ?? () {},
            ),
            _manageHotspot(
              target: PermissionTarget.camera,
              semanticLabel: 'Kamera İznini Yönet',
              normalizedRect: const Rect.fromLTWH(0.720, 0.210, 0.185, 0.050),
            ),
            _manageHotspot(
              target: PermissionTarget.physicalActivity,
              semanticLabel: 'Hareket İznini Yönet',
              normalizedRect: const Rect.fromLTWH(0.720, 0.320, 0.185, 0.050),
            ),
            _manageHotspot(
              target: PermissionTarget.notifications,
              semanticLabel: 'Bildirim İznini Yönet',
              normalizedRect: const Rect.fromLTWH(0.720, 0.430, 0.185, 0.050),
            ),
            _manageHotspot(
              target: PermissionTarget.healthIntegration,
              semanticLabel: 'Sağlık Entegrasyonunu Yönet',
              normalizedRect: const Rect.fromLTWH(0.720, 0.540, 0.185, 0.050),
            ),
            _rootHotspot(
              destination: PermissionsRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: PermissionsRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: PermissionsRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: PermissionsRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.600, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: PermissionsRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.800, 0.906, 0.200, 0.094),
            ),
          ],
        ),
      ),
    );
  }
}
