import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/platform/app_settings_launcher.dart';
import '../pose/detector/pose_rep_detector.dart';
import '../pose/detector/verified_rep.dart';
import '../pose/provider/pose_camera_controller.dart';
import '../pose/provider/pose_models.dart';
import 'calibration_movement_sequence.dart';
import 'calibration_readiness_gate.dart';
import 'first_calibration_engine.dart';

typedef CalibrationCameraSessionFactory =
    PoseCameraSession Function({
      required PoseRepDetector detector,
      required void Function(VerifiedRep rep) onVerifiedRep,
      required void Function(PoseFrame frame) onPoseFrame,
    });

PoseCameraSession createProductionCalibrationCameraSession({
  required PoseRepDetector detector,
  required void Function(VerifiedRep rep) onVerifiedRep,
  required void Function(PoseFrame frame) onPoseFrame,
}) {
  return PoseCameraController(
    detector: detector,
    onVerifiedRep: onVerifiedRep,
    onPoseFrame: onPoseFrame,
  );
}

enum _CalibrationFlowStep { inputs, cameraPrep, movements }

/// Production camera and pose flow opened from the canonical First Calibration
/// artwork. The entry artwork and its hotspot geometry remain unchanged.
class FirstCalibrationFlowScreen extends StatefulWidget {
  const FirstCalibrationFlowScreen({
    super.key,
    this.requiredPlankHoldDuration,
    this.cameraSessionFactory = createProductionCalibrationCameraSession,
    this.settingsLauncher = const AppSettingsLauncher(),
  });

  /// A product-owned target. Null deliberately blocks Plank verification.
  final Duration? requiredPlankHoldDuration;
  final CalibrationCameraSessionFactory cameraSessionFactory;
  final AppSettingsLauncher settingsLauncher;

  @override
  State<FirstCalibrationFlowScreen> createState() =>
      _FirstCalibrationFlowScreenState();
}

class _FirstCalibrationFlowScreenState extends State<FirstCalibrationFlowScreen>
    with WidgetsBindingObserver {
  final _goalController = TextEditingController();
  final _sessionMinutesController = TextEditingController();
  final _experienceController = TextEditingController();
  final Map<CalibrationMovement, TextEditingController>
  _alternativeControllers = {
    for (final movement in CalibrationMovement.values)
      movement: TextEditingController(),
  };
  final Map<CalibrationMovement, CalibrationMovementSuitability?> _suitability =
      {for (final movement in CalibrationMovement.values) movement: null};

  _CalibrationFlowStep _step = _CalibrationFlowStep.inputs;
  CalibrationProfileInput? _profile;
  Map<CalibrationMovement, CalibrationMovementPreference> _preferences = {};
  CalibrationMovementSequence? _sequence;
  PoseCameraSession? _cameraSession;
  FirstCalibrationAssessment? _lastAssessment;
  VerifiedRep? _lastVerifiedRep;
  bool _cameraStarting = false;
  bool _cameraPoseIntroCompleted = false;
  bool _settingsOpened = false;
  bool _assessmentSubmitted = false;
  bool _poseDetected = false;
  bool _fullBodyReady = false;
  final CalibrationReadinessGate _readiness = CalibrationReadinessGate();
  Timer? _readinessTimer;
  String? _inputError;
  String? _settingsError;
  String? _lastAssessmentKey;

  static const _background = Color(0xFF061326);
  static const _panel = Color(0xFF0B1D37);
  static const _runeBlue = Color(0xFF45D9FF);
  static const _gold = Color(0xFFE7C47A);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _readinessTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _goalController.dispose();
    _sessionMinutesController.dispose();
    _experienceController.dispose();
    for (final controller in _alternativeControllers.values) {
      controller.dispose();
    }
    final camera = _cameraSession;
    if (camera != null) unawaited(camera.dispose());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _readinessTimer?.cancel();
      _readinessTimer = null;
      _readiness.reset();
      _poseDetected = false;
      _fullBodyReady = false;
    }
    if (state == AppLifecycleState.resumed && _settingsOpened) {
      _settingsOpened = false;
      unawaited(_startCamera());
    }
  }

  String _movementLabel(CalibrationMovement movement) {
    return switch (movement) {
      CalibrationMovement.squat => 'Squat',
      CalibrationMovement.lunge => 'Lunge',
      CalibrationMovement.pushUp => 'Push-up',
      CalibrationMovement.plank => 'Plank',
    };
  }

  String _movementPrompt(CalibrationMovement movement) {
    return switch (movement) {
      CalibrationMovement.squat =>
        'Kadrajda kalıp bir kontrollü Squat tamamla.',
      CalibrationMovement.lunge =>
        'İki bacağın da görünürken bir kontrollü Lunge tamamla.',
      CalibrationMovement.pushUp =>
        'Gövden ve kolların görünürken bir kontrollü Push-up tamamla.',
      CalibrationMovement.plank =>
        'Gövde çizgini koruyarak ürünün tanımlı Plank süresini tamamla.',
    };
  }

  void _continueToCamera() {
    final goalKey = _goalController.text.trim();
    final experienceKey = _experienceController.text.trim();
    final minutes = int.tryParse(_sessionMinutesController.text.trim());
    if (goalKey.isEmpty ||
        experienceKey.isEmpty ||
        minutes == null ||
        minutes <= 0) {
      setState(() {
        _inputError = 'Hedef, deneyim ve sıfırdan büyük günlük süreyi gir.';
      });
      return;
    }

    final preferences = <CalibrationMovement, CalibrationMovementPreference>{};
    for (final movement in CalibrationMovement.values) {
      final suitability = _suitability[movement];
      if (suitability == null) {
        setState(() {
          _inputError = 'Dört hareketin her biri için uygunluk seç.';
        });
        return;
      }
      final alternativeKey = _alternativeControllers[movement]!.text.trim();
      if (suitability == CalibrationMovementSuitability.alternativeRequired &&
          alternativeKey.isEmpty) {
        setState(() {
          _inputError =
              '${_movementLabel(movement)} için gereken alternatifi belirt.';
        });
        return;
      }
      preferences[movement] = CalibrationMovementPreference(
        movement: movement,
        suitability: suitability,
        alternativeKey:
            suitability == CalibrationMovementSuitability.alternativeRequired
            ? alternativeKey
            : null,
      );
    }

    _profile = CalibrationProfileInput(
      goalKey: goalKey,
      preferredSessionMinutes: minutes,
      experienceKey: experienceKey,
    );
    _preferences = Map.unmodifiable(preferences);
    final sequence = CalibrationMovementSequence(
      preferences: _preferences,
      requiredPlankHoldDuration: widget.requiredPlankHoldDuration,
    );
    _sequence = sequence;
    _cameraSession = widget.cameraSessionFactory(
      detector: sequence,
      onVerifiedRep: _onVerifiedRep,
      onPoseFrame: _onPoseFrame,
    );
    setState(() {
      _inputError = null;
      _step = _CalibrationFlowStep.cameraPrep;
      _lastAssessment = null;
      _lastVerifiedRep = null;
      _assessmentSubmitted = false;
      _lastAssessmentKey = null;
    });
    _readiness.reset();
    unawaited(_startCamera());
  }

  Future<void> _startCamera() async {
    final camera = _cameraSession;
    if (camera == null || _cameraStarting || camera.isReady) return;
    setState(() {
      _cameraStarting = true;
      _settingsError = null;
    });
    await camera.start();
    if (!mounted) return;
    setState(() => _cameraStarting = false);
    _updateReadiness();
    final error = camera.error;
    if (error != null) {
      _evaluateIncompleteAttempt();
    }
  }

  void _onPoseFrame(PoseFrame frame) {
    final sequence = _sequence;
    if (!mounted || sequence == null) return;
    final poseDetected = sequence.poseDetected;
    final fullBodyReady = sequence.fullBodyReady;
    if (_poseDetected != poseDetected || _fullBodyReady != fullBodyReady) {
      setState(() {
        _poseDetected = poseDetected;
        _fullBodyReady = fullBodyReady;
      });
    }
    _updateReadiness();
    final configurationError = sequence.configurationError;
    if (configurationError != null) {
      _evaluateIncompleteAttempt();
    }
  }

  void _onVerifiedRep(VerifiedRep rep) {
    if (!mounted) return;
    setState(() => _lastVerifiedRep = rep);
    if (_sequence?.isComplete ?? false) {
      unawaited(_evaluateAndFinish());
    }
  }

  void _updateReadiness() {
    if (!mounted || _step != _CalibrationFlowStep.cameraPrep) return;
    _readiness.update(
      cameraReady: _cameraSession?.isReady == true,
      poseDetected: _poseDetected,
      fullBodyReady: _fullBodyReady,
    );
    if (_readiness.phase == CalibrationReadinessPhase.stabilizing &&
        _readinessTimer == null) {
      _readinessTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        if (!mounted || _step != _CalibrationFlowStep.cameraPrep) {
          _readinessTimer?.cancel();
          _readinessTimer = null;
          return;
        }
        _readiness.update(
          cameraReady: _cameraSession?.isReady == true,
          poseDetected: _poseDetected,
          fullBodyReady: _fullBodyReady,
        );
        if (_readiness.phase == CalibrationReadinessPhase.waitingForCamera ||
            _readiness.phase == CalibrationReadinessPhase.waitingForPose) {
          _readinessTimer?.cancel();
          _readinessTimer = null;
        } else if (_readiness.advance(const Duration(milliseconds: 100))) {
          _beginMovements();
        }
        if (mounted) setState(() {});
      });
    }
    setState(() {});
  }

  void _beginMovements() {
    final sequence = _sequence;
    if (sequence == null ||
        _cameraSession?.isReady != true ||
        !sequence.poseDetected ||
        !sequence.fullBodyReady) {
      return;
    }
    sequence.enableCapture();
    _readinessTimer?.cancel();
    _readinessTimer = null;
    _cameraPoseIntroCompleted = true;
    setState(() {
      _step = _CalibrationFlowStep.movements;
      _lastAssessment = null;
    });
    if (sequence.configurationError != null) _evaluateIncompleteAttempt();
  }

  FirstCalibrationAssessment? _evaluateCurrentAttempt() {
    final profile = _profile;
    final sequence = _sequence;
    if (profile == null || sequence == null) return null;
    return const FirstCalibrationEngine().evaluate(
      FirstCalibrationInput(
        profile: profile,
        cameraPoseIntroCompleted: _cameraPoseIntroCompleted,
        preferences: _preferences,
        evidence: sequence.evidence,
      ),
    );
  }

  void _evaluateIncompleteAttempt() {
    final assessment = _evaluateCurrentAttempt();
    if (assessment == null || !mounted) return;
    final assessmentKey = assessment.blockers
        .map(
          (blocker) => '${blocker.code.name}:${blocker.movement?.name ?? ""}',
        )
        .join('|');
    if (_lastAssessmentKey == assessmentKey) return;
    _lastAssessmentKey = assessmentKey;
    setState(() => _lastAssessment = assessment);
  }

  Future<void> _evaluateAndFinish() async {
    if (_assessmentSubmitted) return;
    final assessment = _evaluateCurrentAttempt();
    if (assessment == null || !assessment.readyForStartingProfile) {
      _evaluateIncompleteAttempt();
      return;
    }

    _assessmentSubmitted = true;
    await _cameraSession?.stop();
    if (mounted) Navigator.of(context).pop(assessment);
  }

  Future<void> _openAppSettings() async {
    _settingsOpened = true;
    final opened = await widget.settingsLauncher.openAppSettings();
    if (!mounted) return;
    if (!opened) {
      setState(() {
        _settingsError =
            'Ayarlar açılamadı. Cihaz ayarlarından ActiRune kamera iznini açıp yeniden dene.';
      });
    }
  }

  Future<void> _editInputs() async {
    _readinessTimer?.cancel();
    _readinessTimer = null;
    _readiness.reset();
    final camera = _cameraSession;
    _cameraSession = null;
    await camera?.dispose();
    if (!mounted) return;
    setState(() {
      _step = _CalibrationFlowStep.inputs;
      _sequence = null;
      _lastAssessment = null;
      _cameraPoseIntroCompleted = false;
      _poseDetected = false;
      _fullBodyReady = false;
      _cameraStarting = false;
      _lastVerifiedRep = null;
      _lastAssessmentKey = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        foregroundColor: Colors.white,
        title: const Text('İlk Kalibrasyon'),
        leading: IconButton(
          tooltip: 'Geri',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_background, Color(0xFF0A2447), Color(0xFF061326)],
          ),
        ),
        child: SafeArea(
          top: false,
          child: _step == _CalibrationFlowStep.inputs
              ? _buildInputs()
              : _buildCameraFlow(),
        ),
      ),
    );
  }

  Widget _buildInputs() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        const Text(
          'Başlangıç profilin',
          style: TextStyle(
            color: _gold,
            fontSize: 23,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Bunlar tıbbi değerlendirme değildir. Kısa yanıtların ve hareket tercihin başlangıç yolunu belirler.',
          style: TextStyle(color: Color(0xFFD8E5F8), height: 1.35),
        ),
        const SizedBox(height: 18),
        _textInput(
          key: const ValueKey('first-calibration.goal'),
          label: 'ActiRune’daki kişisel hedefin',
          hint: 'Kısa bir yanıt yaz',
          controller: _goalController,
        ),
        const SizedBox(height: 12),
        _textInput(
          key: const ValueKey('first-calibration.session-minutes'),
          label: 'Günde ayırabileceğin süre (dakika)',
          hint: 'Dakika',
          controller: _sessionMinutesController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 12),
        _textInput(
          key: const ValueKey('first-calibration.experience'),
          label: 'Hareket deneyimin',
          hint: 'Kısa bir yanıt yaz',
          controller: _experienceController,
        ),
        const SizedBox(height: 20),
        const Text(
          'Hareket uygunluğu',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 4),
        const Text(
          'Her hareket için standart hareketi seç veya alternatif gerektiğini belirt. ActiRune tanı koymaz.',
          style: TextStyle(color: Color(0xFFB7C9E2), height: 1.35),
        ),
        const SizedBox(height: 10),
        for (final movement in CalibrationMovement.values)
          _buildMovementPreference(movement),
        if (_inputError case final error?) ...[
          const SizedBox(height: 8),
          Text(
            error,
            key: const ValueKey('first-calibration.input-error'),
            style: const TextStyle(color: Color(0xFFFF9B9B)),
          ),
        ],
        const SizedBox(height: 22),
        SizedBox(
          height: 54,
          child: FilledButton(
            key: const ValueKey('first-calibration.prepare-camera'),
            onPressed: _continueToCamera,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF087BC1),
              foregroundColor: Colors.white,
            ),
            child: const Text('Kamerayı ve pose algılamayı hazırla'),
          ),
        ),
      ],
    );
  }

  Widget _textInput({
    required Key key,
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      key: key,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: keyboardType == null ? 64 : 6,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: _gold),
        hintStyle: const TextStyle(color: Color(0xFF879AB5)),
        counterStyle: const TextStyle(color: Color(0xFF879AB5)),
        filled: true,
        fillColor: _panel,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF28527C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF28527C)),
        ),
      ),
    );
  }

  Widget _buildMovementPreference(CalibrationMovement movement) {
    final selected = _suitability[movement];
    final alternativeRequired =
        selected == CalibrationMovementSuitability.alternativeRequired;
    return Container(
      key: ValueKey('first-calibration.preference.${movement.name}'),
      margin: const EdgeInsets.only(top: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF28527C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _movementLabel(movement),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _suitabilityChoice(
                movement: movement,
                value: CalibrationMovementSuitability.standard,
                label: 'Standart uygun',
                selected: selected == CalibrationMovementSuitability.standard,
              ),
              _suitabilityChoice(
                movement: movement,
                value: CalibrationMovementSuitability.alternativeRequired,
                label: 'Alternatif gerekli',
                selected: alternativeRequired,
              ),
            ],
          ),
          if (alternativeRequired) ...[
            const SizedBox(height: 8),
            _textInput(
              key: ValueKey('first-calibration.alternative.${movement.name}'),
              label: 'Tercih ettiğin alternatif',
              hint: 'Kısa ad',
              controller: _alternativeControllers[movement]!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _suitabilityChoice({
    required CalibrationMovement movement,
    required CalibrationMovementSuitability value,
    required String label,
    required bool selected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() {
        _suitability[movement] = value;
        _inputError = null;
      }),
      selectedColor: const Color(0xFF075C90),
      backgroundColor: const Color(0xFF102744),
      side: BorderSide(color: selected ? _runeBlue : const Color(0xFF526A86)),
      labelStyle: TextStyle(
        color: selected ? Colors.white : const Color(0xFFD8E5F8),
      ),
    );
  }

  Widget _buildCameraFlow() {
    final camera = _cameraSession;
    final sequence = _sequence;
    final isMovements = _step == _CalibrationFlowStep.movements;
    final cameraReady = camera?.isReady ?? false;
    final error = camera?.error;
    final activeMovement = sequence?.currentMovement;
    final configurationError = sequence?.configurationError;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
      children: [
        _buildPreview(camera),
        const SizedBox(height: 14),
        _statusRow(
          'Kamera',
          cameraReady
              ? 'Hazır'
              : _cameraStarting
              ? 'Açılıyor'
              : 'Bekliyor',
          ready: cameraReady,
        ),
        _statusRow(
          'Pose algılama',
          _poseDetected ? 'Algılandı' : 'Kişi bekleniyor',
          ready: _poseDetected,
        ),
        _statusRow(
          'Tüm vücut',
          _fullBodyReady ? 'Kadrajda' : 'Kadraj kontrol ediliyor',
          ready: _fullBodyReady,
        ),
        const SizedBox(height: 12),
        if (error != null) _buildCameraError(error),
        if (_settingsError case final settingsError?)
          Text(
            settingsError,
            key: const ValueKey('first-calibration.settings-error'),
            style: const TextStyle(color: Color(0xFFFFC773)),
          ),
        if (configurationError != null) ...[
          const SizedBox(height: 10),
          _messagePanel(
            configurationError,
            key: const ValueKey('first-calibration.configuration-blocker'),
            warning: true,
          ),
          if (_lastAssessment != null)
            Text(
              'Eksik doğrulama nedeniyle başlangıç profili oluşturulmadı.',
              key: const ValueKey('first-calibration.blocked-assessment'),
              style: const TextStyle(color: Color(0xFFFFC773)),
            ),
        ],
        if (!isMovements && error == null) ...[
          const SizedBox(height: 12),
          _messagePanel(
            'Telefonu sabit tut. Bütün vücudunu göster; hareket alanında yeterli ışık ve boşluk bırak.',
            key: const ValueKey('first-calibration.camera-guidance'),
          ),
          const SizedBox(height: 14),
          _messagePanel(switch (_readiness.phase) {
            CalibrationReadinessPhase.waitingForCamera => 'Kamera bekleniyor',
            CalibrationReadinessPhase.waitingForPose =>
              'Tüm vücudun kadraja girmesi bekleniyor',
            CalibrationReadinessPhase.stabilizing =>
              'Algılama hazır · sabit kal',
            CalibrationReadinessPhase.countdown =>
              '${_readiness.countdownNumber}',
            CalibrationReadinessPhase.movementCapture =>
              'Hareket testi başladı',
          }, key: const ValueKey('first-calibration.readiness-status')),
        ],
        if (isMovements) ...[
          const SizedBox(height: 12),
          _messagePanel(
            activeMovement == null
                ? 'Hareket kanıtı bekleniyor.'
                : '${_movementLabel(activeMovement)}: ${_movementPrompt(activeMovement)}',
            key: const ValueKey('first-calibration.active-movement'),
          ),
          const SizedBox(height: 10),
          for (final movement in CalibrationMovement.values)
            _movementEvidenceRow(movement, sequence),
          if (_lastVerifiedRep != null)
            const Text(
              'Hareket pose doğrulayıcısı tarafından doğrulandı.',
              key: ValueKey('first-calibration.verified-event'),
              style: TextStyle(color: Color(0xFF91F0BB)),
            ),
        ],
        if (error != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              key: const ValueKey('first-calibration.retry-camera'),
              onPressed: _cameraStarting ? null : _startCamera,
              icon: const Icon(Icons.refresh),
              label: const Text('Kamerayı yeniden dene'),
            ),
          ),
          if (Platform.isAndroid) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                key: const ValueKey('first-calibration.open-settings'),
                onPressed: _openAppSettings,
                icon: const Icon(Icons.settings_outlined),
                label: const Text('Uygulama izinlerini aç'),
              ),
            ),
          ],
        ],
        const SizedBox(height: 16),
        TextButton(
          key: const ValueKey('first-calibration.edit-inputs'),
          onPressed: _editInputs,
          child: const Text('Bilgileri düzenle / kalibrasyonu yeniden başlat'),
        ),
      ],
    );
  }

  Widget _buildPreview(PoseCameraSession? camera) {
    final controller = camera?.camera;
    return Container(
      height: MediaQuery.sizeOf(context).height * .36,
      constraints: const BoxConstraints(minHeight: 210, maxHeight: 420),
      decoration: BoxDecoration(
        color: const Color(0xFF020811),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3E78A5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: controller != null && controller.value.isInitialized
          ? Center(child: CameraPreview(controller))
          : const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.videocam_outlined, color: _runeBlue, size: 44),
                  SizedBox(height: 8),
                  Text(
                    'Canlı kamera görüntüsü burada açılır',
                    style: TextStyle(color: Color(0xFFD8E5F8)),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _statusRow(String label, String value, {required bool ready}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            ready ? Icons.check_circle : Icons.radio_button_unchecked,
            color: ready ? const Color(0xFF78E8AA) : _gold,
            size: 20,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white)),
          ),
          Text(
            value,
            style: TextStyle(
              color: ready ? const Color(0xFF9AF0BE) : const Color(0xFFE6C57D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _movementEvidenceRow(
    CalibrationMovement movement,
    CalibrationMovementSequence? sequence,
  ) {
    final verified = sequence?.evidence.containsKey(movement) ?? false;
    final active = sequence?.currentMovement == movement;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            verified
                ? Icons.check_circle
                : active
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: verified
                ? const Color(0xFF78E8AA)
                : active
                ? _runeBlue
                : const Color(0xFF71849D),
            size: 19,
          ),
          const SizedBox(width: 8),
          Text(
            _movementLabel(movement),
            style: TextStyle(
              color: verified ? const Color(0xFF9AF0BE) : Colors.white,
            ),
          ),
          const Spacer(),
          if (verified)
            const Text(
              'Doğrulandı',
              style: TextStyle(color: Color(0xFF9AF0BE)),
            ),
        ],
      ),
    );
  }

  Widget _buildCameraError(Object error) {
    final denied =
        error is CameraException &&
        error.code.toLowerCase().contains('cameraaccessdenied');
    return _messagePanel(
      denied
          ? 'Kamera izni verilmedi. İzin olmadan pose kanıtı üretilemez; yeniden dene veya uygulama ayarlarından kamera iznini aç.'
          : 'Kamera veya pose hazırlığı tamamlanamadı. Kalibrasyon başarıya geçirilmedi; yeniden deneyebilirsin.',
      key: const ValueKey('first-calibration.camera-error'),
      warning: true,
    );
  }

  Widget _messagePanel(String text, {required Key key, bool warning = false}) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: warning ? const Color(0xFF392A1A) : _panel,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: warning ? const Color(0xFFBD8740) : const Color(0xFF28527C),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: warning ? const Color(0xFFFFD28B) : const Color(0xFFD8E5F8),
          height: 1.35,
        ),
      ),
    );
  }
}
