import '../provider/pose_models.dart';
import 'geometry.dart';

enum SquatPhase { unknown, standing, descending, bottom, ascending }

class VerifiedRep {
  const VerifiedRep({required this.exercise, required this.at, required this.formScore});
  final String exercise;
  final DateTime at;
  final double formScore;
}

class SquatDetector {
  SquatPhase phase = SquatPhase.unknown;
  DateTime? _bottomAt;
  DateTime? _lastRepAt;

  VerifiedRep? process(PoseFrame frame) {
    final h = frame[Joint.leftHip];
    final k = frame[Joint.leftKnee];
    final a = frame[Joint.leftAnkle];
    if (h == null || k == null || a == null) return null;
    if ([h, k, a].any((p) => p.confidence < .65)) return null;

    final angle = jointAngle(h, k, a);

    if (angle > 160) {
      if (phase == SquatPhase.ascending && _bottomAt != null) {
        final repDurationMs = frame.timestamp.difference(_bottomAt!).inMilliseconds;
        final cooldownOk = _lastRepAt == null ||
            frame.timestamp.difference(_lastRepAt!).inMilliseconds >= 650;
        phase = SquatPhase.standing;
        if (repDurationMs >= 250 && cooldownOk) {
          _lastRepAt = frame.timestamp;
          _bottomAt = null;
          return VerifiedRep(exercise: 'squat', at: frame.timestamp, formScore: 1.0);
        }
      }
      phase = SquatPhase.standing;
    } else if (angle < 105) {
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
}
