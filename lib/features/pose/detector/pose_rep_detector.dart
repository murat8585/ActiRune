import '../provider/pose_models.dart';
import 'verified_rep.dart';

/// Common frame -> verified movement boundary for camera-fed exercise detectors.
///
/// Implementations own their own deterministic state machine and thresholds.
/// The camera layer only forwards normalized pose frames and never invents a
/// movement result.
abstract interface class PoseRepDetector {
  VerifiedRep? process(PoseFrame frame);
}
