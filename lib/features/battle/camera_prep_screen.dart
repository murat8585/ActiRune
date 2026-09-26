import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/feature_unavailable_dialog.dart';
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

  void _start(BuildContext context) {
    if (!readiness.allReady ||
        session.snapshot.phase != BattleSessionPhase.cameraPrep) {
      FeatureUnavailableDialog.show(
        context,
        feature: 'Kamera hazırlığı',
        message: 'Hazırlık kontrolleri tamamlanmadan savaş başlatılamaz.',
      );
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
              onTap: () => _start(context),
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
