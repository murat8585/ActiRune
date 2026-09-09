import 'dart:async';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'pose_models.dart';

/// Native camera-frame -> InputImage adaptation is intentionally isolated here.
/// This provider must use a single-inference-flight / latest-frame-wins policy.
/// The concrete CameraImage adapter is completed on a machine with Flutter SDK
/// and validated on real Android+iOS hardware before product use.
class MlKitPoseProvider implements PoseProvider {
  final _controller = StreamController<PoseFrame>.broadcast();
  final PoseDetector _detector = PoseDetector(options: PoseDetectorOptions());
  bool _running = false;
  bool _busy = false;

  @override
  Stream<PoseFrame> get frames => _controller.stream;

  @override
  Future<void> start() async {
    _running = true;
  }

  /// Adapter entry point. Caller supplies a correctly-oriented InputImage.
  Future<void> processInputImage(InputImage image) async {
    if (!_running || _busy) return;
    _busy = true;
    try {
      final poses = await _detector.processImage(image);
      if (poses.isEmpty) return;
      final pose = poses.first;
      JointPoint? p(PoseLandmarkType type) {
        final l = pose.landmarks[type];
        if (l == null) return null;
        return JointPoint(x: l.x, y: l.y, confidence: l.likelihood);
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
      _controller.add(PoseFrame(timestamp: DateTime.now(), joints: joints));
    } finally {
      _busy = false;
    }
  }

  @override
  Future<void> stop() async {
    _running = false;
  }

  Future<void> dispose() async {
    await _detector.close();
    await _controller.close();
  }
}
