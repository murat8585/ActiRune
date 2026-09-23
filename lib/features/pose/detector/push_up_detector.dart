import '../provider/pose_models.dart';
import 'geometry.dart';
import 'verified_rep.dart';

enum PushUpPhase { unknown, top, descending, bottom, ascending }

/// Deterministic push-up repetition state machine.
///
/// Thresholds are configuration until labelled-video and real-device ML Kit
/// validation are complete. Missing/low-confidence landmarks freeze progress;
/// an observed body-line failure invalidates the current repetition.
class PushUpDetector {
  PushUpDetector({
    this.minimumConfidence = .65,
    this.topElbowAngle = 160,
    this.bottomElbowAngle = 100,
    this.minimumBodyLineAngle = 155,
    this.minimumBottomDuration = const Duration(milliseconds: 250),
    this.cooldown = const Duration(milliseconds: 650),
  });

  final double minimumConfidence;
  final double topElbowAngle;
  final double bottomElbowAngle;
  final double minimumBodyLineAngle;
  final Duration minimumBottomDuration;
  final Duration cooldown;

  PushUpPhase phase = PushUpPhase.unknown;
  DateTime? _bottomAt;
  DateTime? _lastRepAt;
  bool _cycleInvalid = false;

  VerifiedRep? process(PoseFrame frame) {
    final points = _bodySide(frame);
    if (points == null) return null;

    final elbowAngle = jointAngle(points.shoulder, points.elbow, points.wrist);
    final bodyLineAngle = jointAngle(points.shoulder, points.hip, points.ankle);
    final bodyLineValid = bodyLineAngle >= minimumBodyLineAngle;

    if (!bodyLineValid) {
      if (phase == PushUpPhase.descending ||
          phase == PushUpPhase.bottom ||
          phase == PushUpPhase.ascending) {
        _cycleInvalid = true;
      }
      return null;
    }

    if (elbowAngle > topElbowAngle) {
      if (phase == PushUpPhase.ascending && _bottomAt != null) {
        final repDuration = frame.timestamp.difference(_bottomAt!);
        final cooldownOk =
            _lastRepAt == null ||
            frame.timestamp.difference(_lastRepAt!) >= cooldown;
        final validCycle =
            !_cycleInvalid && repDuration >= minimumBottomDuration;
        _resetToTop();
        if (validCycle && cooldownOk) {
          _lastRepAt = frame.timestamp;
          return VerifiedRep(
            exercise: 'push_up',
            at: frame.timestamp,
            formScore: 1.0,
          );
        }
        return null;
      }

      _resetToTop();
      return null;
    }

    switch (phase) {
      case PushUpPhase.unknown:
        return null;
      case PushUpPhase.top:
        if (elbowAngle < bottomElbowAngle) {
          _enterBottom(frame);
        } else {
          phase = PushUpPhase.descending;
        }
        return null;
      case PushUpPhase.descending:
        if (elbowAngle < bottomElbowAngle) {
          _enterBottom(frame);
        }
        return null;
      case PushUpPhase.bottom:
        if (elbowAngle > bottomElbowAngle) {
          phase = PushUpPhase.ascending;
        }
        return null;
      case PushUpPhase.ascending:
        return null;
    }
  }

  void _enterBottom(PoseFrame frame) {
    phase = PushUpPhase.bottom;
    _bottomAt ??= frame.timestamp;
  }

  void _resetToTop() {
    phase = PushUpPhase.top;
    _bottomAt = null;
    _cycleInvalid = false;
  }

  ({
    JointPoint shoulder,
    JointPoint elbow,
    JointPoint wrist,
    JointPoint hip,
    JointPoint ankle,
  })?
  _bodySide(PoseFrame frame) {
    final left = _side(
      frame,
      Joint.leftShoulder,
      Joint.leftElbow,
      Joint.leftWrist,
      Joint.leftHip,
      Joint.leftAnkle,
    );
    final right = _side(
      frame,
      Joint.rightShoulder,
      Joint.rightElbow,
      Joint.rightWrist,
      Joint.rightHip,
      Joint.rightAnkle,
    );
    return left ?? right;
  }

  ({
    JointPoint shoulder,
    JointPoint elbow,
    JointPoint wrist,
    JointPoint hip,
    JointPoint ankle,
  })?
  _side(
    PoseFrame frame,
    Joint shoulderJoint,
    Joint elbowJoint,
    Joint wristJoint,
    Joint hipJoint,
    Joint ankleJoint,
  ) {
    final shoulder = frame[shoulderJoint];
    final elbow = frame[elbowJoint];
    final wrist = frame[wristJoint];
    final hip = frame[hipJoint];
    final ankle = frame[ankleJoint];
    if (shoulder == null ||
        elbow == null ||
        wrist == null ||
        hip == null ||
        ankle == null) {
      return null;
    }
    if ([
      shoulder,
      elbow,
      wrist,
      hip,
      ankle,
    ].any((point) => point.confidence < minimumConfidence)) {
      return null;
    }
    return (
      shoulder: shoulder,
      elbow: elbow,
      wrist: wrist,
      hip: hip,
      ankle: ankle,
    );
  }
}
