enum CalibrationReadinessPhase {
  waitingForCamera,
  waitingForPose,
  stabilizing,
  countdown,
  movementCapture,
}

/// Advances only while camera, pose and full-body evidence remain available.
/// The caller owns the clock and must stop ticking when the screen is disposed.
class CalibrationReadinessGate {
  static const stableDuration = Duration(seconds: 2);
  static const countdownDuration = Duration(seconds: 3);

  CalibrationReadinessPhase phase = CalibrationReadinessPhase.waitingForCamera;
  Duration _stableElapsed = Duration.zero;
  Duration _countdownElapsed = Duration.zero;

  int? get countdownNumber => phase == CalibrationReadinessPhase.countdown
      ? 3 - _countdownElapsed.inSeconds
      : null;

  void update({
    required bool cameraReady,
    required bool poseDetected,
    required bool fullBodyReady,
  }) {
    if (phase == CalibrationReadinessPhase.movementCapture) return;
    if (!cameraReady || !poseDetected || !fullBodyReady) {
      _stableElapsed = Duration.zero;
      _countdownElapsed = Duration.zero;
      phase = !cameraReady
          ? CalibrationReadinessPhase.waitingForCamera
          : CalibrationReadinessPhase.waitingForPose;
    } else if (phase == CalibrationReadinessPhase.waitingForCamera ||
        phase == CalibrationReadinessPhase.waitingForPose) {
      phase = CalibrationReadinessPhase.stabilizing;
    }
  }

  /// Returns true exactly once when automatic capture may begin.
  bool advance(Duration elapsed) {
    if (phase == CalibrationReadinessPhase.stabilizing) {
      _stableElapsed += elapsed;
      if (_stableElapsed >= stableDuration) {
        phase = CalibrationReadinessPhase.countdown;
        _countdownElapsed = Duration.zero;
      }
    } else if (phase == CalibrationReadinessPhase.countdown) {
      _countdownElapsed += elapsed;
      if (_countdownElapsed >= countdownDuration) {
        phase = CalibrationReadinessPhase.movementCapture;
        return true;
      }
    }
    return false;
  }

  void reset() {
    phase = CalibrationReadinessPhase.waitingForCamera;
    _stableElapsed = Duration.zero;
    _countdownElapsed = Duration.zero;
  }
}
