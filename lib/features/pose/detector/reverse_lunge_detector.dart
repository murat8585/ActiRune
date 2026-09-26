import '../provider/pose_models.dart';
import 'pose_rep_detector.dart';
import 'standing_pose_geometry.dart';
import 'verified_rep.dart';

enum ReverseLungePhase { unknown, standing, rearward, bottom, returning }

/// Conservative camera-facing reverse-lunge verifier. ML Kit's experimental Z
/// must show one ankle moving away from the camera relative to the pelvis.
/// Thresholds are product configuration, not medical/biomechanical truth;
/// real-device corpus validation must confirm facing and depth reliability.
class ReverseLungeDetector implements PoseRepDetector {
  ReverseLungeDetector({
    this.minimumConfidence = defaultPoseMinimumConfidence,
    this.standingAngle = 155,
    this.leadBottomAngle = 125,
    this.rearMinimumAngle = 95,
    this.rearMaximumAngle = 165,
    this.minimumRearDepthTravel = .45,
    this.maximumSupportDepthTravel = .25,
    this.maximumReturnDepthTravel = .20,
    this.returnAngleMargin = 10,
    this.minimumBottomFrames = 2,
    this.minimumBottomDuration = const Duration(milliseconds: 100),
    this.cooldown = const Duration(milliseconds: 650),
  });

  final double minimumConfidence, standingAngle, leadBottomAngle;
  final double rearMinimumAngle, rearMaximumAngle;
  final double minimumRearDepthTravel, maximumSupportDepthTravel;
  final double maximumReturnDepthTravel;
  final double returnAngleMargin;
  final int minimumBottomFrames;
  final Duration minimumBottomDuration, cooldown;

  ReverseLungePhase phase = ReverseLungePhase.unknown;
  bool? rearIsLeft;
  double? _baseLeftDepth, _baseRightDepth;
  int _bottomFrames = 0;
  DateTime? _bottomAt, _lastRepAt;

  @override
  VerifiedRep? process(PoseFrame frame) {
    final pose = StandingPoseGeometry.read(frame, minimumConfidence);
    final leftDepth = pose?.ankleDepth(true);
    final rightDepth = pose?.ankleDepth(false);
    if (pose == null || leftDepth == null || rightDepth == null) {
      _reset();
      return null;
    }
    final standing = pose.isStanding(standingAngle);
    if (phase == ReverseLungePhase.unknown) {
      if (standing) _setBaseline(pose);
      return null;
    }
    final leftTravel = leftDepth - _baseLeftDepth!;
    final rightTravel = rightDepth - _baseRightDepth!;

    if (phase == ReverseLungePhase.standing) {
      final leftRear =
          leftTravel >= minimumRearDepthTravel &&
          rightTravel.abs() <= maximumSupportDepthTravel;
      final rightRear =
          rightTravel >= minimumRearDepthTravel &&
          leftTravel.abs() <= maximumSupportDepthTravel;
      if (leftRear != rightRear) {
        rearIsLeft = leftRear;
        phase = ReverseLungePhase.rearward;
      } else if (standing &&
          leftTravel.abs() <= maximumReturnDepthTravel &&
          rightTravel.abs() <= maximumReturnDepthTravel) {
        _setBaseline(pose);
      }
      return null;
    }

    final rearLeft = rearIsLeft!;
    final rearTravel = rearLeft ? leftTravel : rightTravel;
    final supportTravel = rearLeft ? rightTravel : leftTravel;
    if (supportTravel.abs() > maximumSupportDepthTravel) {
      _reset();
      return null;
    }
    if (phase == ReverseLungePhase.rearward) {
      if (standing && rearTravel.abs() <= maximumReturnDepthTravel) {
        _setBaseline(pose);
        return null;
      }
      final leadAngle = pose.kneeAngle(!rearLeft);
      final rearAngle = pose.kneeAngle(rearLeft);
      final kneesBelowHips =
          pose.downDistance(pose.leftKnee, pose.leftHip) > 0 &&
          pose.downDistance(pose.rightKnee, pose.rightHip) > 0;
      if (rearTravel >= minimumRearDepthTravel &&
          kneesBelowHips &&
          leadAngle <= leadBottomAngle &&
          rearAngle >= rearMinimumAngle &&
          rearAngle <= rearMaximumAngle) {
        phase = ReverseLungePhase.bottom;
        _bottomAt = frame.timestamp;
        _bottomFrames = 1;
      }
      return null;
    }
    if (phase == ReverseLungePhase.bottom) {
      final leadAngle = pose.kneeAngle(!rearLeft);
      final rearAngle = pose.kneeAngle(rearLeft);
      if (rearTravel < minimumRearDepthTravel / 2) {
        _reset();
      } else if (leadAngle <= leadBottomAngle &&
          rearAngle >= rearMinimumAngle &&
          rearAngle <= rearMaximumAngle) {
        _bottomFrames++;
      } else if (leadAngle > leadBottomAngle + returnAngleMargin) {
        final bottomDuration = frame.timestamp.difference(_bottomAt!);
        if (_bottomFrames >= minimumBottomFrames &&
            bottomDuration >= minimumBottomDuration) {
          phase = ReverseLungePhase.returning;
        } else {
          _reset();
        }
      } else {
        _reset();
      }
      return null;
    }
    if (phase == ReverseLungePhase.returning) {
      if (!standing || rearTravel.abs() > maximumReturnDepthTravel) return null;
      final cooldownOk =
          _lastRepAt == null ||
          frame.timestamp.difference(_lastRepAt!) >= cooldown;
      _setBaseline(pose);
      if (cooldownOk) {
        _lastRepAt = frame.timestamp;
        return VerifiedRep(
          exercise: 'reverse_lunge',
          at: frame.timestamp,
          formScore: 1,
        );
      }
    }
    return null;
  }

  void _setBaseline(StandingPoseGeometry pose) {
    _baseLeftDepth = pose.ankleDepth(true);
    _baseRightDepth = pose.ankleDepth(false);
    phase = ReverseLungePhase.standing;
    rearIsLeft = null;
    _bottomAt = null;
    _bottomFrames = 0;
  }

  void _reset() {
    phase = ReverseLungePhase.unknown;
    rearIsLeft = null;
    _baseLeftDepth = null;
    _baseRightDepth = null;
    _bottomAt = null;
    _bottomFrames = 0;
  }
}
