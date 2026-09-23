import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum ProFormMovement { squat, lunge, pushUp, plank }

enum ProFormTrendRange { sevenDays, thirtyDays }

enum ProFormCoachRootDestination { home, adventure, battle, hero, profile }

/// Canonical Pro Form Coach long-term analytics shell from VIS_0219.
///
/// This is intentionally separate from the Free real-time battle Form Coach.
/// It does not calculate analytics, diagnose health conditions, or fabricate
/// entitlement state. The approved artwork remains the UI and interactive
/// selections are forwarded only to a real owning layer through callbacks.
class ProFormCoachScreen extends StatelessWidget {
  const ProFormCoachScreen({
    super.key,
    this.onCrystalStore,
    this.onGoldStore,
    this.onNotifications,
    this.onMovementSelected,
    this.onTrendRangeSelected,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/01_CANONICAL_FINAL/'
      'VIS_0219__P1_PRO_FORM_COACH_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onCrystalStore;
  final VoidCallback? onGoldStore;
  final VoidCallback? onNotifications;
  final ValueChanged<ProFormMovement>? onMovementSelected;
  final ValueChanged<ProFormTrendRange>? onTrendRangeSelected;
  final ValueChanged<ProFormCoachRootDestination>? onRootNavigate;
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

  ArtworkHotspot _movementHotspot({
    required ProFormMovement movement,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onMovementSelected;
    return ArtworkHotspot(
      id: 'pro-form-coach.movement-${movement.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(movement),
    );
  }

  ArtworkHotspot _rangeHotspot({
    required ProFormTrendRange range,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onTrendRangeSelected;
    return ArtworkHotspot(
      id: 'pro-form-coach.range-${range.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(range),
    );
  }

  ArtworkHotspot _rootHotspot({
    required ProFormCoachRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != ProFormCoachRootDestination.battle ||
            battleRootEnabled);
    return ArtworkHotspot(
      id: 'pro-form-coach.nav-${destination.name}',
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
              id: 'pro-form-coach.crystal-store',
              semanticLabel: 'Kristal Ekle',
              normalizedRect: const Rect.fromLTWH(
                0.7140,
                0.0130,
                0.0520,
                0.0360,
              ),
              callback: onCrystalStore,
            ),
            _hotspot(
              id: 'pro-form-coach.gold-store',
              semanticLabel: 'Altın Ekle',
              normalizedRect: const Rect.fromLTWH(
                0.8750,
                0.0130,
                0.0520,
                0.0360,
              ),
              callback: onGoldStore,
            ),
            _hotspot(
              id: 'pro-form-coach.notifications',
              semanticLabel: 'Bildirimler',
              normalizedRect: const Rect.fromLTWH(
                0.9320,
                0.0100,
                0.0550,
                0.0440,
              ),
              callback: onNotifications,
            ),
            _movementHotspot(
              movement: ProFormMovement.squat,
              semanticLabel: 'Squat',
              normalizedRect: const Rect.fromLTWH(
                0.0580,
                0.3130,
                0.2200,
                0.0430,
              ),
            ),
            _movementHotspot(
              movement: ProFormMovement.lunge,
              semanticLabel: 'Lunge',
              normalizedRect: const Rect.fromLTWH(
                0.2780,
                0.3130,
                0.2170,
                0.0430,
              ),
            ),
            _movementHotspot(
              movement: ProFormMovement.pushUp,
              semanticLabel: 'Şınav',
              normalizedRect: const Rect.fromLTWH(
                0.4950,
                0.3130,
                0.2180,
                0.0430,
              ),
            ),
            _movementHotspot(
              movement: ProFormMovement.plank,
              semanticLabel: 'Plank',
              normalizedRect: const Rect.fromLTWH(
                0.7130,
                0.3130,
                0.2180,
                0.0430,
              ),
            ),
            _rangeHotspot(
              range: ProFormTrendRange.sevenDays,
              semanticLabel: '7 Gün',
              normalizedRect: const Rect.fromLTWH(
                0.1800,
                0.3660,
                0.3150,
                0.0350,
              ),
            ),
            _rangeHotspot(
              range: ProFormTrendRange.thirtyDays,
              semanticLabel: '30 Gün',
              normalizedRect: const Rect.fromLTWH(
                0.4950,
                0.3660,
                0.3150,
                0.0350,
              ),
            ),
            _rootHotspot(
              destination: ProFormCoachRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(
                0.0000,
                0.9050,
                0.2000,
                0.0950,
              ),
            ),
            _rootHotspot(
              destination: ProFormCoachRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(
                0.2000,
                0.9050,
                0.2000,
                0.0950,
              ),
            ),
            _rootHotspot(
              destination: ProFormCoachRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(
                0.4000,
                0.9050,
                0.2000,
                0.0950,
              ),
            ),
            _rootHotspot(
              destination: ProFormCoachRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(
                0.6000,
                0.9050,
                0.2000,
                0.0950,
              ),
            ),
            _rootHotspot(
              destination: ProFormCoachRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(
                0.8000,
                0.9050,
                0.2000,
                0.0950,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
