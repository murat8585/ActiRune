import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import 'battle_session_engine.dart';

enum CameraPrepCheckState { ready, checking, warning }

@immutable
class CameraPrepCheckStatus {
  const CameraPrepCheckStatus({required this.state, required this.label});

  final CameraPrepCheckState state;
  final String label;

  bool get isReady => state == CameraPrepCheckState.ready;
}

@immutable
class CameraPrepReadiness {
  const CameraPrepReadiness({
    required this.camera,
    required this.fullBody,
    required this.lighting,
    required this.space,
    required this.poseDetection,
  });

  final CameraPrepCheckStatus camera;
  final CameraPrepCheckStatus fullBody;
  final CameraPrepCheckStatus lighting;
  final CameraPrepCheckStatus space;
  final CameraPrepCheckStatus poseDetection;

  bool get allReady =>
      camera.isReady &&
      fullBody.isReady &&
      lighting.isReady &&
      space.isReady &&
      poseDetection.isReady;

  static const ready = CameraPrepReadiness(
    camera: CameraPrepCheckStatus(
      state: CameraPrepCheckState.ready,
      label: 'Hazır',
    ),
    fullBody: CameraPrepCheckStatus(
      state: CameraPrepCheckState.ready,
      label: 'Hazır',
    ),
    lighting: CameraPrepCheckStatus(
      state: CameraPrepCheckState.ready,
      label: 'Hazır',
    ),
    space: CameraPrepCheckStatus(
      state: CameraPrepCheckState.ready,
      label: 'Hazır',
    ),
    poseDetection: CameraPrepCheckStatus(
      state: CameraPrepCheckState.ready,
      label: 'Hazır',
    ),
  );
}

class CameraPrepScreen extends StatelessWidget {
  const CameraPrepScreen({
    super.key,
    required this.session,
    required this.readiness,
    required this.onBack,
    required this.onInfo,
    required this.onRecheck,
    required this.onStartLiveBattle,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_p0_battle/P0_CAMERA_PREP_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final BattleSessionEngine session;
  final CameraPrepReadiness readiness;
  final VoidCallback onBack;
  final VoidCallback onInfo;
  final VoidCallback onRecheck;
  final VoidCallback onStartLiveBattle;

  void _back() {
    if (session.returnToBattlePrep()) onBack();
  }

  void _start() {
    if (!readiness.allReady ||
        session.snapshot.phase != BattleSessionPhase.cameraPrep) {
      return;
    }
    session.startLiveBattle();
    onStartLiveBattle();
  }

  @override
  Widget build(BuildContext context) {
    final statuses = <({String id, Rect rect, CameraPrepCheckStatus status})>[
      (
        id: 'camera',
        rect: const Rect.fromLTWH(0.5824, 0.3768, 0.3294, 0.0347),
        status: readiness.camera,
      ),
      (
        id: 'full-body',
        rect: const Rect.fromLTWH(0.5824, 0.4270, 0.3294, 0.0347),
        status: readiness.fullBody,
      ),
      (
        id: 'lighting',
        rect: const Rect.fromLTWH(0.5824, 0.4767, 0.3294, 0.0347),
        status: readiness.lighting,
      ),
      (
        id: 'space',
        rect: const Rect.fromLTWH(0.5824, 0.5269, 0.3294, 0.0347),
        status: readiness.space,
      ),
      (
        id: 'pose',
        rect: const Rect.fromLTWH(0.5824, 0.5772, 0.3294, 0.0347),
        status: readiness.poseDetection,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: CameraPrepScreen.artworkAsset,
          sourceSize: CameraPrepScreen.artworkSize,
          overlays: [
            for (final item in statuses)
              ArtworkOverlay(
                id: 'camera-prep.${item.id}-status',
                normalizedRect: item.rect,
                child: _ReadinessBadge(status: item.status),
              ),
            if (!readiness.allReady)
              const ArtworkOverlay(
                id: 'camera-prep.ready-disabled',
                normalizedRect: Rect.fromLTWH(0.1010, 0.8038, 0.7694, 0.0658),
                child: ColoredBox(color: Color(0x99000000)),
              ),
          ],
          hotspots: [
            ArtworkHotspot(
              id: 'camera-prep.back',
              semanticLabel: 'Savaş Hazırlığına Dön',
              normalizedRect: const Rect.fromLTWH(
                0.0191,
                0.0108,
                0.0786,
                0.0407,
              ),
              onTap: _back,
            ),
            ArtworkHotspot(
              id: 'camera-prep.info',
              semanticLabel: 'Kamera Hazırlığı Bilgisi',
              normalizedRect: const Rect.fromLTWH(
                0.8959,
                0.0108,
                0.0776,
                0.0407,
              ),
              onTap: onInfo,
            ),
            ArtworkHotspot(
              id: 'camera-prep.ready',
              semanticLabel: 'Hazırım',
              normalizedRect: const Rect.fromLTWH(
                0.1010,
                0.8038,
                0.7694,
                0.0658,
              ),
              enabled: readiness.allReady,
              onTap: _start,
            ),
            ArtworkHotspot(
              id: 'camera-prep.recheck',
              semanticLabel: 'Tekrar Kontrol Et',
              normalizedRect: const Rect.fromLTWH(
                0.2062,
                0.8864,
                0.5877,
                0.0467,
              ),
              onTap: onRecheck,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadinessBadge extends StatelessWidget {
  const _ReadinessBadge({required this.status});

  final CameraPrepCheckStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (status.state) {
      CameraPrepCheckState.ready => (
        Icons.check_circle_outline,
        const Color(0xFF79F7AE),
      ),
      CameraPrepCheckState.checking => (
        Icons.hourglass_empty,
        const Color(0xFFFFC96B),
      ),
      CameraPrepCheckState.warning => (
        Icons.error_outline,
        const Color(0xFFFF7A7A),
      ),
    };

    return ColoredBox(
      color: const Color(0xFF071827),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 10),
              Text(
                status.label,
                style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
