import '../provider/pose_models.dart';
import 'geometry.dart';
import 'pose_rep_detector.dart';
import 'verified_rep.dart';

export 'verified_rep.dart';

enum SquatPhase { unknown, standing, descending, bottom, ascending }

class SquatDetector implements PoseRepDetector {
  SquatDetector({
    this.minimumConfidence = defaultPoseMinimumConfidence,
    this.standingAngle = 160,
    this.bottomAngle = 105,
    this.minimumBottomDuration = const Duration(milliseconds: 250),
    this.cooldown = const Duration(milliseconds: 650),
  });

  final double minimumConfidence;
  final double standingAngle;
  final double bottomAngle;
  final Duration minimumBottomDuration;
  final Duration cooldown;
  SquatPhase phase = SquatPhase.unknown;
  DateTime? _bottomAt;
  DateTime? _lastRepAt;

  @override
  VerifiedRep? process(PoseFrame frame) {
    final left = _leg(frame, Joint.leftHip, Joint.leftKnee, Joint.leftAnkle);
    final right = _leg(
      frame,
      Joint.rightHip,
      Joint.rightKnee,
      Joint.rightAnkle,
    );
    final points = left ?? right;
    if (points == null) return null;

    final angle = jointAngle(points.$1, points.$2, points.$3);

    if (angle > standingAngle) {
      if (phase == SquatPhase.ascending && _bottomAt != null) {
        final repDurationMs = frame.timestamp
            .difference(_bottomAt!)
            .inMilliseconds;
        final cooldownOk =
            _lastRepAt == null ||
            frame.timestamp.difference(_lastRepAt!) >= cooldown;
        phase = SquatPhase.standing;
        _bottomAt = null;
        if (repDurationMs >= minimumBottomDuration.inMilliseconds &&
            cooldownOk) {
          _lastRepAt = frame.timestamp;
          return VerifiedRep(
            exercise: 'squat',
            at: frame.timestamp,
            formScore: 1.0,
          );
        }
      }
      phase = SquatPhase.standing;
    } else if (angle < bottomAngle) {
      if (phase == SquatPhase.standing || phase == SquatPhase.descending) {
        phase = SquatPhase.bottom;
        _bottomAt ??= frame.timestamp;
      }
    } else if (phase == SquatPhase.standing) {
      phase = SquatPhase.descending;
    } else if (phase == SquatPhase.bottom) {
      phase = SquatPhase.ascending;
    }
    return null;
  }

  (JointPoint, JointPoint, JointPoint)? _leg(
    PoseFrame frame,
    Joint hip,
    Joint knee,
    Joint ankle,
  ) {
    final h = frame[hip], k = frame[knee], a = frame[ankle];
    if (h == null || k == null || a == null) return null;
    if ([h, k, a].any((point) => point.confidence < minimumConfidence)) {
      return null;
    }
    return (h, k, a);
  }
}
