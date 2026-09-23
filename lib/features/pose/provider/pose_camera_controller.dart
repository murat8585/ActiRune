import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';

import '../detector/pose_rep_detector.dart';
import '../detector/verified_rep.dart';
import 'camera_input_adapter.dart';
import 'mlkit_pose_provider.dart';
import 'pose_models.dart';

/// Pure frame-dispatch boundary between normalized ML Kit pose frames and the
/// movement detector selected by the authoritative encounter/task owner.
class PoseRepDispatcher {
  PoseRepDispatcher({required this.detector, required this.onVerifiedRep});

  final PoseRepDetector detector;
  final void Function(VerifiedRep rep) onVerifiedRep;

  void accept(PoseFrame frame) {
    final rep = detector.process(frame);
    if (rep != null) onVerifiedRep(rep);
  }
}

class PoseCameraController {
  PoseCameraController({
    required PoseRepDetector detector,
    required void Function(VerifiedRep rep) onVerifiedRep,
    MlKitPoseProvider? provider,
    this._adapter = const CameraInputAdapter(),
  }) : _dispatcher = PoseRepDispatcher(
         detector: detector,
         onVerifiedRep: onVerifiedRep,
       ),
       _provider = provider ?? MlKitPoseProvider();

  final PoseRepDispatcher _dispatcher;
  final MlKitPoseProvider _provider;
  final CameraInputAdapter _adapter;
  CameraController? _camera;
  StreamSubscription<PoseFrame>? _subscription;
  Object? error;

  CameraController? get camera => _camera;
  bool get isReady => _camera?.value.isInitialized ?? false;

  Future<void> start() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      error = UnsupportedError('Pose camera requires Android or iOS.');
      return;
    }
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw StateError('No camera is available.');
      final description = cameras.firstWhere(
        (item) => item.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        description,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );
      _camera = controller;
      await controller.initialize();
      await _provider.start();
      _subscription = _provider.frames.listen(_dispatcher.accept);
      await controller.startImageStream((image) {
        final input = _adapter.convert(
          image: image,
          camera: description,
          deviceOrientation: controller.value.deviceOrientation,
        );
        if (input != null) unawaited(_provider.processInputImage(input));
      });
    } catch (caught) {
      error = caught;
      await stop();
    }
  }

  Future<void> stop() async {
    final controller = _camera;
    _camera = null;
    if (controller?.value.isStreamingImages ?? false) {
      await controller!.stopImageStream();
    }
    await _subscription?.cancel();
    _subscription = null;
    await _provider.stop();
    await controller?.dispose();
  }

  Future<void> dispose() async {
    await stop();
    await _provider.dispose();
  }
}
