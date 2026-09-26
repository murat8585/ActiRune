import 'dart:async';

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'pose_models.dart';

/// Consumes adapted camera images with one inference in flight. While busy,
/// intermediate images are replaced so only the latest pending frame runs.
class MlKitPoseProvider implements PoseProvider {
  MlKitPoseProvider({this._inference});

  final _controller = StreamController<PoseFrame>.broadcast();
  final PoseDetector _detector = PoseDetector(options: PoseDetectorOptions());
  final PoseFrameInference? _inference;
  bool _running = false;
  bool _busy = false;
  InputImage? _latestPending;

  @override
  Stream<PoseFrame> get frames => _controller.stream;

  @override
  Future<void> start() async {
    _running = true;
  }

  /// Adapter entry point. Caller supplies a correctly-oriented InputImage.
  Future<void> processInputImage(InputImage image) async {
    if (!_running) return;
    if (_busy) {
      _latestPending = image;
      return;
    }
    _busy = true;
    try {
      var current = image;
      while (_running) {
        _latestPending = null;
        final frame = _inference == null
            ? await _inferWithMlKit(current)
            : await _inference(current, DateTime.now());
        if (_running && frame != null) _controller.add(frame);
        final pending = _latestPending;
        if (pending == null) break;
        current = pending;
      }
    } finally {
      _busy = false;
    }
  }

  Future<PoseFrame?> _inferWithMlKit(InputImage image) async {
    final poses = await _detector.processImage(image);
    if (poses.isEmpty) {
      return PoseFrame(timestamp: DateTime.now(), joints: const {});
    }
    final pose = poses.first;
    JointPoint? p(PoseLandmarkType type) {
      final l = pose.landmarks[type];
      if (l == null) return null;
      return JointPoint(x: l.x, y: l.y, z: l.z, confidence: l.likelihood);
    }

    final pairs = <Joint, PoseLandmarkType>{
      Joint.leftShoulder: PoseLandmarkType.leftShoulder,
      Joint.rightShoulder: PoseLandmarkType.rightShoulder,
      Joint.leftElbow: PoseLandmarkType.leftElbow,
      Joint.rightElbow: PoseLandmarkType.rightElbow,
      Joint.leftWrist: PoseLandmarkType.leftWrist,
      Joint.rightWrist: PoseLandmarkType.rightWrist,
      Joint.leftHip: PoseLandmarkType.leftHip,
      Joint.rightHip: PoseLandmarkType.rightHip,
      Joint.leftKnee: PoseLandmarkType.leftKnee,
      Joint.rightKnee: PoseLandmarkType.rightKnee,
      Joint.leftAnkle: PoseLandmarkType.leftAnkle,
      Joint.rightAnkle: PoseLandmarkType.rightAnkle,
    };
    final joints = <Joint, JointPoint>{};
    for (final e in pairs.entries) {
      final point = p(e.value);
      if (point != null) joints[e.key] = point;
    }
    return PoseFrame(timestamp: DateTime.now(), joints: joints);
  }

  @override
  Future<void> stop() async {
    _running = false;
    _latestPending = null;
  }

  Future<void> dispose() async {
    await _detector.close();
    await _controller.close();
  }
}

typedef PoseFrameInference =
    Future<PoseFrame?> Function(InputImage image, DateTime timestamp);
