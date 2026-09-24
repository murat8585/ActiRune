import '../pose/detector/movement_detector_factory.dart';
import '../pose/detector/pose_rep_detector.dart';
import '../pose/detector/verified_rep.dart';
import '../pose/provider/pose_models.dart';
import 'first_calibration_engine.dart';

/// Runs the existing production movement detectors in the order required by
/// first-use calibration. Evidence is recorded only when a detector emits a
/// matching [VerifiedRep].
class CalibrationMovementSequence implements PoseRepDetector {
  CalibrationMovementSequence({
    required this.preferences,
    required this.requiredPlankHoldDuration,
    this.detectorFactory = const MovementDetectorFactory(),
  });

  final Map<CalibrationMovement, CalibrationMovementPreference> preferences;
  final Duration? requiredPlankHoldDuration;
  final MovementDetectorFactory detectorFactory;

  final Map<CalibrationMovement, CalibrationMovementEvidence> _evidence = {};
  int _movementIndex = 0;
  PoseRepDetector? _activeDetector;
  bool _captureEnabled = false;
  bool _poseDetected = false;
  bool _fullBodyReady = false;
  bool _previousFrameFullBodyReady = false;
  String? _configurationError;

  CalibrationMovement? get currentMovement =>
      _movementIndex < CalibrationMovement.values.length
      ? CalibrationMovement.values[_movementIndex]
      : null;

  Map<CalibrationMovement, CalibrationMovementEvidence> get evidence =>
      Map.unmodifiable(_evidence);

  bool get isComplete => currentMovement == null && _evidence.length == 4;
  bool get poseDetected => _poseDetected;
  bool get fullBodyReady => _fullBodyReady;
  String? get configurationError => _configurationError;

  void enableCapture() {
    _captureEnabled = true;
    _previousFrameFullBodyReady = _fullBodyReady;
    _prepareCurrentMovement();
  }

  @override
  VerifiedRep? process(PoseFrame frame) {
    _poseDetected = frame.joints.isNotEmpty;
    _fullBodyReady = _isFullBodyReady(frame);

    if (!_captureEnabled || _configurationError != null) {
      _previousFrameFullBodyReady = _fullBodyReady;
      return null;
    }

    if (!_fullBodyReady) {
      if (_previousFrameFullBodyReady) {
        // A verifier must not carry movement or hold time across pose loss.
        _activeDetector = null;
        _prepareCurrentMovement();
      }
      _previousFrameFullBodyReady = false;
      return null;
    }
    _previousFrameFullBodyReady = true;

    final movement = currentMovement;
    if (movement == null) return null;
    _prepareCurrentMovement();
    final detector = _activeDetector;
    if (detector == null) return null;

    final verifiedRep = detector.process(frame);
    if (verifiedRep == null ||
        verifiedRep.exercise != _exerciseNameFor(movement)) {
      return null;
    }

    _evidence[movement] = CalibrationMovementEvidence(
      movement: movement,
      status: CalibrationEvidenceStatus.standardVerified,
      evidenceId:
          'first-calibration:${movement.name}:'
          '${verifiedRep.at.toUtc().microsecondsSinceEpoch}',
    );
    _movementIndex++;
    _activeDetector = null;
    _configurationError = null;
    _prepareCurrentMovement();
    return verifiedRep;
  }

  void _prepareCurrentMovement() {
    if (_activeDetector != null || _configurationError != null) return;
    final movement = currentMovement;
    if (movement == null) return;

    final preference = preferences[movement];
    if (preference == null || preference.movement != movement) {
      _configurationError =
          'Bu hareket için kalibrasyon tercihi seçilmedi. Kalibrasyon tamamlanamaz.';
      return;
    }
    if (preference.suitability ==
        CalibrationMovementSuitability.alternativeRequired) {
      _configurationError =
          'Seçilen alternatif için gerçek pose doğrulayıcısı bulunmuyor. '
          'Bu hareket kanıtı olmadan kalibrasyon başarılı sayılamaz.';
      return;
    }
    if (movement == CalibrationMovement.plank &&
        (requiredPlankHoldDuration == null ||
            requiredPlankHoldDuration! <= Duration.zero)) {
      _configurationError =
          'Plank doğrulama süresi ürün yapılandırmasında tanımlı değil.';
      return;
    }

    try {
      _activeDetector = detectorFactory.create(
        _poseExerciseFor(movement),
        requiredPlankHoldDuration: movement == CalibrationMovement.plank
            ? requiredPlankHoldDuration
            : null,
      );
    } on ArgumentError {
      _configurationError =
          'Bu hareket için doğrulama yapılandırması eksik. Kalibrasyon tamamlanamaz.';
    }
  }

  static bool _isFullBodyReady(PoseFrame frame) {
    return Joint.values.every((joint) {
      final point = frame[joint];
      return point != null && point.confidence >= defaultPoseMinimumConfidence;
    });
  }

  static PoseExerciseType _poseExerciseFor(CalibrationMovement movement) {
    return switch (movement) {
      CalibrationMovement.squat => PoseExerciseType.squat,
      CalibrationMovement.lunge => PoseExerciseType.lunge,
      CalibrationMovement.pushUp => PoseExerciseType.pushUp,
      CalibrationMovement.plank => PoseExerciseType.plank,
    };
  }

  static String _exerciseNameFor(CalibrationMovement movement) {
    return switch (movement) {
      CalibrationMovement.squat => 'squat',
      CalibrationMovement.lunge => 'lunge',
      CalibrationMovement.pushUp => 'push_up',
      CalibrationMovement.plank => 'plank',
    };
  }
}
