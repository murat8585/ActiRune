import '../provider/pose_models.dart';
import 'geometry.dart';
import 'pose_rep_detector.dart';
import 'verified_rep.dart';

/// Deterministic plank hold verifier.
///
/// [requiredHoldDuration] is supplied by the authoritative encounter/task
/// owner. Pose thresholds remain configurable until labelled-video and
/// physical-device ML Kit validation are complete.
///
/// Missing or low-confidence landmarks freeze elapsed progress and never count
/// hidden time. An observed body-line failure resets the current hold.
class PlankDetector implements PoseRepDetector {
  PlankDetector({
    required this.requiredHoldDuration,
    this.minimumConfidence = .65,
    this.minimumBodyLineAngle = 155,
  }) : assert(requiredHoldDuration > Duration.zero);

  final Duration requiredHoldDuration;
  final double minimumConfidence;
  final double minimumBodyLineAngle;

  Duration _accumulatedValidDuration = Duration.zero;
  DateTime? _lastValidAt;
  bool _emittedCurrentHold = false;

  Duration get accumulatedValidDuration => _accumulatedValidDuration;
  bool get completedCurrentHold => _emittedCurrentHold;

  @override
  VerifiedRep? process(PoseFrame frame) {
    final points = _bodySide(frame);
    if (points == null) {
      _lastValidAt = null;
      return null;
    }

    final bodyLineAngle = jointAngle(points.shoulder, points.hip, points.ankle);
    if (bodyLineAngle < minimumBodyLineAngle) {
      _resetHold();
      return null;
    }

    final previous = _lastValidAt;
    if (previous != null && !frame.timestamp.isBefore(previous)) {
      _accumulatedValidDuration += frame.timestamp.difference(previous);
    }
    _lastValidAt = frame.timestamp;

    if (!_emittedCurrentHold &&
        _accumulatedValidDuration >= requiredHoldDuration) {
      _emittedCurrentHold = true;
      return VerifiedRep(
        exercise: 'plank',
        at: frame.timestamp,
        formScore: 1.0,
      );
    }
    return null;
  }

  void _resetHold() {
    _accumulatedValidDuration = Duration.zero;
    _lastValidAt = null;
    _emittedCurrentHold = false;
  }

  ({JointPoint shoulder, JointPoint hip, JointPoint ankle})? _bodySide(
    PoseFrame frame,
  ) {
    final left = _side(
      frame,
      Joint.leftShoulder,
      Joint.leftHip,
      Joint.leftAnkle,
    );
    final right = _side(
      frame,
      Joint.rightShoulder,
      Joint.rightHip,
      Joint.rightAnkle,
    );
    return left ?? right;
  }

  ({JointPoint shoulder, JointPoint hip, JointPoint ankle})? _side(
    PoseFrame frame,
    Joint shoulderJoint,
    Joint hipJoint,
    Joint ankleJoint,
  ) {
    final shoulder = frame[shoulderJoint];
    final hip = frame[hipJoint];
    final ankle = frame[ankleJoint];
    if (shoulder == null || hip == null || ankle == null) return null;
    if ([
      shoulder,
      hip,
      ankle,
    ].any((point) => point.confidence < minimumConfidence)) {
      return null;
    }
    return (shoulder: shoulder, hip: hip, ankle: ankle);
  }
}
