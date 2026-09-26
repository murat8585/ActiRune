import 'dart:math' as math;

import '../provider/pose_models.dart';
import 'pose_rep_detector.dart';
import 'standing_pose_geometry.dart';
import 'verified_rep.dart';

enum HighKneePhase { unknown, standing, lifted }

/// A controlled single-side lift and return. Body-relative thresholds are
/// product configuration, not medical truth; real-device corpus validation is
/// required before treating these values as general movement quality.
class HighKneeDetector implements PoseRepDetector {
  HighKneeDetector({
    this.minimumConfidence = defaultPoseMinimumConfidence,
    this.standingAngle = 155,
    this.maximumLiftedKneeAngle = 150,
    this.minimumKneeHeight = .10,
    this.minimumLiftedShinDrop = .10,
    this.minimumOppositeElbowKneeDistance = .50,
    this.minimumLiftFrames = 2,
    this.minimumLiftDuration = const Duration(milliseconds: 150),
    this.cooldown = const Duration(milliseconds: 650),
  });

  final double minimumConfidence, standingAngle, maximumLiftedKneeAngle;
  final double minimumKneeHeight;
  final double minimumLiftedShinDrop;
  final double minimumOppositeElbowKneeDistance;
  final int minimumLiftFrames;
  final Duration minimumLiftDuration, cooldown;

  HighKneePhase phase = HighKneePhase.unknown;
  bool? liftedIsLeft;
  int _liftFrames = 0;
  DateTime? _liftAt, _lastRepAt;

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
      if (phase == HighKneePhase.lifted && _liftAt != null) {
        final duration = frame.timestamp.difference(_liftAt!);
        final cooldownOk =
            _lastRepAt == null ||
            frame.timestamp.difference(_lastRepAt!) >= cooldown;
        final valid =
            _liftFrames >= minimumLiftFrames &&
            duration >= minimumLiftDuration &&
            cooldownOk;
        _setStanding();
        if (valid) {
          _lastRepAt = frame.timestamp;
          return VerifiedRep(
            exercise: 'high_knee',
            at: frame.timestamp,
            formScore: 1,
          );
        }
      } else {
        _setStanding();
      }
      return null;
    }
    if (phase == HighKneePhase.unknown) return null;
    final left = _liftValid(pose, true, rightElbow);
    final right = _liftValid(pose, false, leftElbow);
    if (phase == HighKneePhase.standing) {
      if (left == right) return null;
      liftedIsLeft = left;
      phase = HighKneePhase.lifted;
      _liftFrames = 1;
      _liftAt = frame.timestamp;
    } else if (_liftValid(
      pose,
      liftedIsLeft!,
      liftedIsLeft! ? rightElbow : leftElbow,
    )) {
      _liftFrames++;
    } else {
      _reset();
    }
    return null;
  }

  bool _liftValid(
    StandingPoseGeometry pose,
    bool left,
    JointPoint oppositeElbow,
  ) =>
      pose.kneeHeight(left) >= minimumKneeHeight &&
      pose.kneeAngle(left) <= maximumLiftedKneeAngle &&
      pose.kneeAngle(!left) >= standingAngle &&
      pose.downDistance(
            left ? pose.leftAnkle : pose.rightAnkle,
            left ? pose.leftKnee : pose.rightKnee,
          ) >
          minimumLiftedShinDrop &&
      math.sqrt(
                math.pow(
                      (left ? pose.leftKnee : pose.rightKnee).x -
                          oppositeElbow.x,
                      2,
                    ) +
                    math.pow(
                      (left ? pose.leftKnee : pose.rightKnee).y -
                          oppositeElbow.y,
                      2,
                    ),
              ) /
              pose.scale >=
          minimumOppositeElbowKneeDistance;

  void _setStanding() {
    phase = HighKneePhase.standing;
    liftedIsLeft = null;
    _liftFrames = 0;
    _liftAt = null;
  }

  void _reset() {
    phase = HighKneePhase.unknown;
    liftedIsLeft = null;
    _liftFrames = 0;
    _liftAt = null;
  }
}
