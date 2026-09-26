import 'dart:math' as math;

import '../provider/pose_models.dart';
import 'geometry.dart';

/// Body-relative 2D geometry shared by the standing calibration detectors.
/// The torso defines the down axis, so neither mirror nor raw image axes are
/// used to decide which physical side moved.
class StandingPoseGeometry {
  static const minimumStandingSegmentRatio = .3;
  StandingPoseGeometry._({
    required this.leftHip,
    required this.rightHip,
    required this.leftKnee,
    required this.rightKnee,
    required this.leftAnkle,
    required this.rightAnkle,
    required this.scale,
    required this.hipCenterX,
    required this.hipCenterY,
    required this.downX,
    required this.downY,
    required this.leftKneeAngle,
    required this.rightKneeAngle,
  });

  final JointPoint leftHip, rightHip, leftKnee, rightKnee;
  final JointPoint leftAnkle, rightAnkle;
  final double scale, hipCenterX, hipCenterY, downX, downY;
  final double leftKneeAngle, rightKneeAngle;

  static StandingPoseGeometry? read(PoseFrame frame, double minimumConfidence) {
    final leftShoulder = frame[Joint.leftShoulder];
    final rightShoulder = frame[Joint.rightShoulder];
    final leftHip = frame[Joint.leftHip];
    final rightHip = frame[Joint.rightHip];
    final leftKnee = frame[Joint.leftKnee];
    final rightKnee = frame[Joint.rightKnee];
    final leftAnkle = frame[Joint.leftAnkle];
    final rightAnkle = frame[Joint.rightAnkle];
    final points = [
      leftShoulder,
      rightShoulder,
      leftHip,
      rightHip,
      leftKnee,
      rightKnee,
      leftAnkle,
      rightAnkle,
    ];
    if (points.any((p) => p == null || p.confidence < minimumConfidence)) {
      return null;
    }
    final shoulderX = (leftShoulder!.x + rightShoulder!.x) / 2;
    final shoulderY = (leftShoulder.y + rightShoulder.y) / 2;
    final hipX = (leftHip!.x + rightHip!.x) / 2;
    final hipY = (leftHip.y + rightHip.y) / 2;
    final scale = math.sqrt(
      math.pow(shoulderX - hipX, 2) + math.pow(shoulderY - hipY, 2),
    );
    if (!scale.isFinite || scale <= 1e-6) return null;
    return StandingPoseGeometry._(
      leftHip: leftHip,
      rightHip: rightHip,
      leftKnee: leftKnee!,
      rightKnee: rightKnee!,
      leftAnkle: leftAnkle!,
      rightAnkle: rightAnkle!,
      scale: scale,
      hipCenterX: hipX,
      hipCenterY: hipY,
      downX: (hipX - shoulderX) / scale,
      downY: (hipY - shoulderY) / scale,
      leftKneeAngle: jointAngle(leftHip, leftKnee, leftAnkle),
      rightKneeAngle: jointAngle(rightHip, rightKnee, rightAnkle),
    );
  }

  bool isStanding(double standingAngle) =>
      leftKneeAngle >= standingAngle &&
      rightKneeAngle >= standingAngle &&
      downDistance(leftKnee, leftHip) > minimumStandingSegmentRatio &&
      downDistance(rightKnee, rightHip) > minimumStandingSegmentRatio &&
      downDistance(leftAnkle, leftKnee) > minimumStandingSegmentRatio &&
      downDistance(rightAnkle, rightKnee) > minimumStandingSegmentRatio;

  double ankleOffset(bool left) =>
      (((left ? leftAnkle.x : rightAnkle.x) - hipCenterX) * downY -
          ((left ? leftAnkle.y : rightAnkle.y) - hipCenterY) * downX) /
      scale;

  double kneeHeight(bool left) =>
      -downDistance(left ? leftKnee : rightKnee, left ? leftHip : rightHip);

  double downDistance(JointPoint point, JointPoint origin) =>
      ((point.x - origin.x) * downX + (point.y - origin.y) * downY) / scale;

  double kneeAngle(bool left) => left ? leftKneeAngle : rightKneeAngle;

  /// Positive depth is farther from the camera than the pelvis. Null means
  /// the provider did not supply depth, so directional proof is unavailable.
  double? ankleDepth(bool left) {
    final leftZ = leftHip.z;
    final rightZ = rightHip.z;
    final ankleZ = (left ? leftAnkle : rightAnkle).z;
    if (leftZ == null ||
        rightZ == null ||
        ankleZ == null ||
        !leftZ.isFinite ||
        !rightZ.isFinite ||
        !ankleZ.isFinite) {
      return null;
    }
    return (ankleZ - (leftZ + rightZ) / 2) / scale;
  }
}
