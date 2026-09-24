import '../provider/pose_models.dart';
import 'geometry.dart';
import 'pose_rep_detector.dart';
import 'verified_rep.dart';

enum LungePhase { unknown, standing, descending, bottom, ascending }

enum LungeSide { left, right }

/// Deterministic lunge repetition state machine.
///
/// Thresholds are configuration, not biomechanical truth. They must remain
/// adjustable until the labelled multi-view movement corpus and real-device
/// ML Kit validation are complete.
class LungeDetector implements PoseRepDetector {
  LungeDetector({
    this.minimumConfidence = defaultPoseMinimumConfidence,
    this.standingAngle = 160,
    this.bottomAngle = 105,
    this.minimumReturnDuration = const Duration(milliseconds: 250),
    this.cooldown = const Duration(milliseconds: 650),
  });

  final double minimumConfidence;
  final double standingAngle;
  final double bottomAngle;
  final Duration minimumReturnDuration;
  final Duration cooldown;

  LungePhase phase = LungePhase.unknown;
  LungeSide? leadSide;
  DateTime? _bottomAt;
  DateTime? _lastRepAt;

  @override
  VerifiedRep? process(PoseFrame frame) {
    final angles = _kneeAngles(frame);
    if (angles == null) return null;

    final leftAngle = angles.$1;
    final rightAngle = angles.$2;
    final bothStanding =
        leftAngle > standingAngle && rightAngle > standingAngle;

    if (bothStanding) {
      if (phase == LungePhase.ascending &&
          _bottomAt != null &&
          leadSide != null) {
        final returnDuration = frame.timestamp.difference(_bottomAt!);
        final cooldownOk =
            _lastRepAt == null ||
            frame.timestamp.difference(_lastRepAt!) >= cooldown;
        _resetToStanding();
        if (returnDuration >= minimumReturnDuration && cooldownOk) {
          _lastRepAt = frame.timestamp;
          return VerifiedRep(
            exercise: 'lunge',
            at: frame.timestamp,
            formScore: 1.0,
          );
        }
        return null;
      }

      _resetToStanding();
      return null;
    }

    switch (phase) {
      case LungePhase.unknown:
        return null;
      case LungePhase.standing:
        if (leftAngle < bottomAngle || rightAngle < bottomAngle) {
          _enterBottom(frame, leftAngle, rightAngle);
        } else {
          phase = LungePhase.descending;
        }
        return null;
      case LungePhase.descending:
        if (leftAngle < bottomAngle || rightAngle < bottomAngle) {
          _enterBottom(frame, leftAngle, rightAngle);
        }
        return null;
      case LungePhase.bottom:
        final leadAngle = _leadAngle(leftAngle, rightAngle);
        if (leadAngle > bottomAngle) {
          phase = LungePhase.ascending;
        }
        return null;
      case LungePhase.ascending:
        return null;
    }
  }

  void _enterBottom(PoseFrame frame, double leftAngle, double rightAngle) {
    phase = LungePhase.bottom;
    leadSide = leftAngle <= rightAngle ? LungeSide.left : LungeSide.right;
    _bottomAt ??= frame.timestamp;
  }

  double _leadAngle(double leftAngle, double rightAngle) {
    return leadSide == LungeSide.right ? rightAngle : leftAngle;
  }

  void _resetToStanding() {
    phase = LungePhase.standing;
    leadSide = null;
    _bottomAt = null;
  }

  (double, double)? _kneeAngles(PoseFrame frame) {
    final left = _leg(frame, Joint.leftHip, Joint.leftKnee, Joint.leftAnkle);
    final right = _leg(
      frame,
      Joint.rightHip,
      Joint.rightKnee,
      Joint.rightAnkle,
    );
    if (left == null || right == null) return null;

    return (
      jointAngle(left.$1, left.$2, left.$3),
      jointAngle(right.$1, right.$2, right.$3),
    );
  }

  (JointPoint, JointPoint, JointPoint)? _leg(
    PoseFrame frame,
    Joint hip,
    Joint knee,
    Joint ankle,
  ) {
    final hipPoint = frame[hip];
    final kneePoint = frame[knee];
    final anklePoint = frame[ankle];
    if (hipPoint == null || kneePoint == null || anklePoint == null) {
      return null;
    }
    if ([
      hipPoint,
      kneePoint,
      anklePoint,
    ].any((point) => point.confidence < minimumConfidence)) {
      return null;
    }
    return (hipPoint, kneePoint, anklePoint);
  }
}
