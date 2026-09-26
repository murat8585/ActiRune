import 'dart:math' as math;

import '../provider/pose_models.dart';
import 'pose_rep_detector.dart';
import 'standing_pose_geometry.dart';
import 'verified_rep.dart';

enum CrossBodyKneeRaisePhase { unknown, standing, converged }

/// Opposite elbow and raised knee must converge in body-scale units and then
/// reset. Thresholds are product configuration, not medical truth; camera-view
/// and real-device corpus validation remain required.
class CrossBodyKneeRaiseDetector implements PoseRepDetector {
  CrossBodyKneeRaiseDetector({
    this.minimumConfidence = defaultPoseMinimumConfidence,
    this.standingAngle = 155,
    this.maximumLiftedKneeAngle = 150,
    this.minimumKneeHeight = .10,
    this.maximumElbowKneeDistance = .40,
    this.minimumElbowApproach = .50,
    this.minimumConvergedFrames = 2,
    this.minimumConvergedDuration = const Duration(milliseconds: 150),
    this.cooldown = const Duration(milliseconds: 650),
  });

  final double minimumConfidence, standingAngle, maximumLiftedKneeAngle;
  final double minimumKneeHeight, maximumElbowKneeDistance;
  final double minimumElbowApproach;
  final int minimumConvergedFrames;
  final Duration minimumConvergedDuration, cooldown;

  CrossBodyKneeRaisePhase phase = CrossBodyKneeRaisePhase.unknown;
  bool? liftedIsLeft;
  double? _baseLeftKneeToRightElbow, _baseRightKneeToLeftElbow;
  int _convergedFrames = 0;
  DateTime? _convergedAt, _lastRepAt;

  @override
  VerifiedRep? process(PoseFrame frame) {
    final pose = StandingPoseGeometry.read(frame, minimumConfidence);
    final leftElbow = frame[Joint.leftElbow];
    final rightElbow = frame[Joint.rightElbow];
    if (pose == null ||
        leftElbow == null ||
        rightElbow == null ||
        leftElbow.confidence < minimumConfidence ||
        rightElbow.confidence < minimumConfidence) {
      _reset();
      return null;
    }
    if (pose.isStanding(standingAngle)) {
      if (phase == CrossBodyKneeRaisePhase.converged && _convergedAt != null) {
        final duration = frame.timestamp.difference(_convergedAt!);
        final cooldownOk =
            _lastRepAt == null ||
            frame.timestamp.difference(_lastRepAt!) >= cooldown;
        final valid =
            _convergedFrames >= minimumConvergedFrames &&
            duration >= minimumConvergedDuration &&
            cooldownOk;
        _setStanding(pose, leftElbow, rightElbow);
        if (valid) {
          _lastRepAt = frame.timestamp;
          return VerifiedRep(
            exercise: 'cross_body_knee_raise',
            at: frame.timestamp,
            formScore: 1,
          );
        }
      } else {
        _setStanding(pose, leftElbow, rightElbow);
      }
      return null;
    }
    if (phase == CrossBodyKneeRaisePhase.unknown) return null;
    final left = _convergenceValid(pose, true, rightElbow);
    final right = _convergenceValid(pose, false, leftElbow);
    if (phase == CrossBodyKneeRaisePhase.standing) {
      if (left == right) return null;
      liftedIsLeft = left;
      phase = CrossBodyKneeRaisePhase.converged;
      _convergedFrames = 1;
      _convergedAt = frame.timestamp;
    } else if (_convergenceValid(
      pose,
      liftedIsLeft!,
      liftedIsLeft! ? rightElbow : leftElbow,
    )) {
      _convergedFrames++;
    } else {
      _reset();
    }
    return null;
  }

  bool _convergenceValid(
    StandingPoseGeometry pose,
    bool kneeIsLeft,
    JointPoint oppositeElbow,
  ) {
    final baseline = kneeIsLeft
        ? _baseLeftKneeToRightElbow
        : _baseRightKneeToLeftElbow;
    if (baseline == null) return false;
    final knee = kneeIsLeft ? pose.leftKnee : pose.rightKnee;
    final distance = _distance(knee, oppositeElbow) / pose.scale;
    return pose.kneeHeight(kneeIsLeft) >= minimumKneeHeight &&
        pose.kneeAngle(kneeIsLeft) <= maximumLiftedKneeAngle &&
        pose.kneeAngle(!kneeIsLeft) >= standingAngle &&
        distance <= maximumElbowKneeDistance &&
        baseline - distance >= minimumElbowApproach;
  }

  static double _distance(JointPoint a, JointPoint b) =>
      math.sqrt(math.pow(a.x - b.x, 2) + math.pow(a.y - b.y, 2));

  void _setStanding(
    StandingPoseGeometry pose,
    JointPoint leftElbow,
    JointPoint rightElbow,
  ) {
    phase = CrossBodyKneeRaisePhase.standing;
    liftedIsLeft = null;
    _convergedFrames = 0;
    _convergedAt = null;
    _baseLeftKneeToRightElbow =
        _distance(pose.leftKnee, rightElbow) / pose.scale;
    _baseRightKneeToLeftElbow =
        _distance(pose.rightKnee, leftElbow) / pose.scale;
  }

  void _reset() {
    phase = CrossBodyKneeRaisePhase.unknown;
    liftedIsLeft = null;
    _convergedFrames = 0;
    _convergedAt = null;
    _baseLeftKneeToRightElbow = null;
    _baseRightKneeToLeftElbow = null;
  }
}
