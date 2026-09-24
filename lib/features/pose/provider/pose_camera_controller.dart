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
  PoseRepDispatcher({
    required this.detector,
    required this.onVerifiedRep,
    this.onPoseFrame,
  });

  final PoseRepDetector detector;
  final void Function(VerifiedRep rep) onVerifiedRep;
  final void Function(PoseFrame frame)? onPoseFrame;

  void accept(PoseFrame frame) {
    final rep = detector.process(frame);
    onPoseFrame?.call(frame);
    if (rep != null) onVerifiedRep(rep);
  }
}

abstract interface class PoseCameraSession {
  CameraController? get camera;
  bool get isReady;
  Object? get error;

  Future<void> start();
  Future<void> stop();
  Future<void> dispose();
}

class PoseCameraController implements PoseCameraSession {
  PoseCameraController({
    required PoseRepDetector detector,
    required void Function(VerifiedRep rep) onVerifiedRep,
    void Function(PoseFrame frame)? onPoseFrame,
    MlKitPoseProvider? provider,
    this._adapter = const CameraInputAdapter(),
  }) : _dispatcher = PoseRepDispatcher(
         detector: detector,
         onVerifiedRep: onVerifiedRep,
         onPoseFrame: onPoseFrame,
       ),
       _provider = provider ?? MlKitPoseProvider();

  final PoseRepDispatcher _dispatcher;
  final MlKitPoseProvider _provider;
  final CameraInputAdapter _adapter;
  CameraController? _camera;
  StreamSubscription<PoseFrame>? _subscription;
  @override
  Object? error;

  @override
  CameraController? get camera => _camera;

  @override
  bool get isReady => _camera?.value.isInitialized ?? false;

  @override
  Future<void> start() async {
    error = null;
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

  @override
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

  @override
  Future<void> dispose() async {
    await stop();
    await _provider.dispose();
  }
}
