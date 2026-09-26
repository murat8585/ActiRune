import 'package:actirune/features/pose/provider/pose_models.dart';

final calibrationBaseTime = DateTime.utc(2026, 9, 26);

typedef Point2 = (double, double);

final Map<Joint, Point2> _standing = {
  Joint.leftShoulder: (-20, 0),
  Joint.rightShoulder: (20, 0),
  Joint.leftElbow: (-25, 80),
  Joint.rightElbow: (25, 80),
  Joint.leftWrist: (-25, 150),
  Joint.rightWrist: (25, 150),
  Joint.leftHip: (-15, 100),
  Joint.rightHip: (15, 100),
  Joint.leftKnee: (-15, 200),
  Joint.rightKnee: (15, 200),
  Joint.leftAnkle: (-15, 300),
  Joint.rightAnkle: (15, 300),
};

PoseFrame standingFrame(int ms, {double scale = 1, Joint? lowConfidence}) =>
    calibrationFrame(ms, scale: scale, lowConfidence: lowConfidence);

PoseFrame calibrationFrame(
  int ms, {
  Map<Joint, Point2> overrides = const {},
  Map<Joint, double> zOverrides = const {},
  double scale = 1,
  Joint? lowConfidence,
  bool omitJoint = false,
}) {
  final coordinates = {..._standing, ...overrides};
  if (omitJoint && lowConfidence != null) coordinates.remove(lowConfidence);
  return PoseFrame(
    timestamp: calibrationBaseTime.add(Duration(milliseconds: ms)),
    joints: {
      for (final entry in coordinates.entries)
        entry.key: JointPoint(
          x: entry.value.$1 * scale,
          y: entry.value.$2 * scale,
          confidence: entry.key == lowConfidence ? .3 : 1,
          z: (zOverrides[entry.key] ?? 0) * scale,
        ),
    },
  );
}

PoseFrame reverseStep(
  int ms, {
  bool rearLeft = true,
  double scale = 1,
  double depth = 80,
}) => calibrationFrame(
  ms,
  scale: scale,
  overrides: rearLeft
      ? {Joint.leftAnkle: (-90, 300)}
      : {Joint.rightAnkle: (90, 300)},
  zOverrides: rearLeft ? {Joint.leftAnkle: depth} : {Joint.rightAnkle: depth},
);

PoseFrame reverseBottom(
  int ms, {
  bool rearLeft = true,
  double scale = 1,
  double depth = 80,
  Joint? lowConfidence,
}) => calibrationFrame(
  ms,
  scale: scale,
  lowConfidence: lowConfidence,
  overrides: rearLeft
      ? {
          Joint.leftKnee: (-20, 230),
          Joint.leftAnkle: (-90, 300),
          Joint.rightKnee: (70, 180),
        }
      : {
          Joint.rightKnee: (20, 230),
          Joint.rightAnkle: (90, 300),
          Joint.leftKnee: (-70, 180),
        },
  zOverrides: rearLeft ? {Joint.leftAnkle: depth} : {Joint.rightAnkle: depth},
);

PoseFrame reverseReturning(
  int ms, {
  bool rearLeft = true,
  double scale = 1,
  double depth = 70,
}) => calibrationFrame(
  ms,
  scale: scale,
  overrides: rearLeft
      ? {
          Joint.leftKnee: (-20, 215),
          Joint.leftAnkle: (-70, 300),
          Joint.rightKnee: (40, 175),
        }
      : {
          Joint.rightKnee: (20, 215),
          Joint.rightAnkle: (70, 300),
          Joint.leftKnee: (-40, 175),
        },
  zOverrides: rearLeft ? {Joint.leftAnkle: depth} : {Joint.rightAnkle: depth},
);

PoseFrame highKneeFrame(
  int ms, {
  bool left = true,
  double scale = 1,
  Joint? lowConfidence,
}) => calibrationFrame(
  ms,
  scale: scale,
  lowConfidence: lowConfidence,
  overrides: left
      ? {Joint.leftKnee: (-30, 70), Joint.leftAnkle: (-20, 160)}
      : {Joint.rightKnee: (30, 70), Joint.rightAnkle: (20, 160)},
);

PoseFrame crossBodyFrame(
  int ms, {
  bool leftKnee = true,
  bool sameSideOnly = false,
  double scale = 1,
  Joint? lowConfidence,
}) {
  final kneeJoint = leftKnee ? Joint.leftKnee : Joint.rightKnee;
  final ankleJoint = leftKnee ? Joint.leftAnkle : Joint.rightAnkle;
  final targetElbow = sameSideOnly
      ? (leftKnee ? Joint.leftElbow : Joint.rightElbow)
      : (leftKnee ? Joint.rightElbow : Joint.leftElbow);
  return calibrationFrame(
    ms,
    scale: scale,
    lowConfidence: lowConfidence,
    overrides: {
      kneeJoint: leftKnee ? (-30, 70) : (30, 70),
      ankleJoint: leftKnee ? (-20, 160) : (20, 160),
      targetElbow: leftKnee ? (-25, 60) : (25, 60),
    },
  );
}

PoseFrame squatFrame(int ms, {bool bottom = true}) => calibrationFrame(
  ms,
  overrides: bottom
      ? {Joint.leftKnee: (-100, 180), Joint.rightKnee: (100, 180)}
      : {Joint.leftKnee: (-50, 190), Joint.rightKnee: (50, 190)},
);
