import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/clean_base_text.dart';
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

  static const checking = CameraPrepReadiness(
    camera: CameraPrepCheckStatus(
      state: CameraPrepCheckState.checking,
      label: 'Kontrol Ediliyor',
    ),
    fullBody: CameraPrepCheckStatus(
      state: CameraPrepCheckState.checking,
      label: 'Kontrol Ediliyor',
    ),
    lighting: CameraPrepCheckStatus(
      state: CameraPrepCheckState.checking,
      label: 'Kontrol Ediliyor',
    ),
    space: CameraPrepCheckStatus(
      state: CameraPrepCheckState.checking,
      label: 'Kontrol Ediliyor',
    ),
    poseDetection: CameraPrepCheckStatus(
      state: CameraPrepCheckState.checking,
      label: 'Kontrol Ediliyor',
    ),
  );

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
      'assets/ui/clean_base_final_60/47__LATE_QA_POS_16__PASS.png';
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: CameraPrepScreen.artworkAsset,
          sourceSize: CameraPrepScreen.artworkSize,
          overlays: [
            const ArtworkOverlay(
              id: 'camera-prep.title',
              normalizedRect: Rect.fromLTWH(0.245, 0.035, 0.510, 0.050),
              child: CleanBaseText('SAVAŞ İÇİN HAZIRLIK', fontSize: 22),
            ),
            const ArtworkOverlay(
              id: 'camera-prep.camera-label',
              normalizedRect: Rect.fromLTWH(0.315, 0.445, 0.245, 0.038),
              child: CleanBaseText('Kamera', fontSize: 16),
            ),
            ArtworkOverlay(
              id: 'camera-prep.camera-status',
              normalizedRect: const Rect.fromLTWH(0.575, 0.445, 0.285, 0.038),
              child: _ReadinessBadge(status: readiness.camera),
            ),
            const ArtworkOverlay(
              id: 'camera-prep.light-label',
              normalizedRect: Rect.fromLTWH(0.315, 0.535, 0.245, 0.038),
              child: CleanBaseText('Işık', fontSize: 16),
            ),
            ArtworkOverlay(
              id: 'camera-prep.light-status',
              normalizedRect: const Rect.fromLTWH(0.575, 0.535, 0.285, 0.038),
              child: _ReadinessBadge(status: readiness.lighting),
            ),
            const ArtworkOverlay(
              id: 'camera-prep.space-label',
              normalizedRect: Rect.fromLTWH(0.315, 0.625, 0.245, 0.038),
              child: CleanBaseText('Alan', fontSize: 16),
            ),
            ArtworkOverlay(
              id: 'camera-prep.space-status',
              normalizedRect: const Rect.fromLTWH(0.575, 0.625, 0.285, 0.038),
              child: _ReadinessBadge(status: readiness.space),
            ),
            const ArtworkOverlay(
              id: 'camera-prep.body-label',
              normalizedRect: Rect.fromLTWH(0.315, 0.715, 0.245, 0.038),
              child: CleanBaseText('Tam Vücut', fontSize: 15),
            ),
            ArtworkOverlay(
              id: 'camera-prep.body-status',
              normalizedRect: const Rect.fromLTWH(0.555, 0.704, 0.205, 0.034),
              child: _ReadinessBadge(status: readiness.fullBody),
            ),
            ArtworkOverlay(
              id: 'camera-prep.pose-status',
              normalizedRect: const Rect.fromLTWH(0.760, 0.704, 0.205, 0.034),
              child: _ReadinessBadge(status: readiness.poseDetection),
            ),
            const ArtworkOverlay(
              id: 'camera-prep.pose-label',
              normalizedRect: Rect.fromLTWH(0.620, 0.744, 0.285, 0.032),
              child: CleanBaseText('Pose Algılama', fontSize: 13),
            ),
            ArtworkOverlay(
              id: 'camera-prep.start-label',
              normalizedRect: const Rect.fromLTWH(0.170, 0.862, 0.660, 0.055),
              child: CleanBaseText(
                'SAVAŞA BAŞLA',
                fontSize: 21,
                color: readiness.allReady ? Colors.white : Colors.white54,
              ),
            ),
            if (!readiness.allReady)
              const ArtworkOverlay(
                id: 'camera-prep.ready-disabled',
                normalizedRect: Rect.fromLTWH(0.125, 0.835, 0.750, 0.100),
                child: ColoredBox(color: Color(0x66000000)),
              ),
          ],
          hotspots: [
            ArtworkHotspot(
              id: 'camera-prep.back',
              semanticLabel: 'Savaş Hazırlığına Dön',
              normalizedRect: const Rect.fromLTWH(0.000, 0.000, 0.090, 0.060),
              onTap: _back,
            ),
            ArtworkHotspot(
              id: 'camera-prep.info',
              semanticLabel: 'Kamera Hazırlığı Bilgisi',
              normalizedRect: const Rect.fromLTWH(0.910, 0.000, 0.090, 0.060),
              onTap: onInfo,
            ),
            ArtworkHotspot(
              id: 'camera-prep.ready',
              semanticLabel: 'Savaşa Başla',
              normalizedRect: const Rect.fromLTWH(0.125, 0.835, 0.750, 0.100),
              enabled: readiness.allReady,
              onTap: _start,
            ),
            ArtworkHotspot(
              id: 'camera-prep.recheck',
              semanticLabel: 'Tekrar Kontrol Et',
              normalizedRect: const Rect.fromLTWH(0.100, 0.790, 0.800, 0.040),
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
      color: const Color(0x88071827),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 5),
              Text(
                status.label,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
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
