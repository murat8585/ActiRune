import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'calibration_result_screen.dart';
import 'first_calibration_engine.dart';
import 'first_calibration_screen.dart';
import 'onboarding_welcome_screen.dart';

typedef CalibrationRunner = Future<FirstCalibrationAssessment?> Function();

enum _OnboardingPhase { welcome, firstCalibration, calibrationResult }

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    this.onLanguage,
    this.onAccessibility,
    this.onRunCalibration,
    this.onCalibrationReady,
    this.onEnterApp,
  });

  final VoidCallback? onLanguage;
  final VoidCallback? onAccessibility;

  /// Runs the real calibration owned by the product layer.
  ///
  /// The result screen is shown only when the returned typed assessment is
  /// ready for a starting profile. A missing runner keeps the primary action
  /// disabled rather than fabricating calibration success.
  final CalibrationRunner? onRunCalibration;

  /// Receives the non-medical starting profile only after a fail-closed
  /// calibration assessment succeeds. Persistence remains caller-owned.
  final ValueChanged<StartingCalibrationProfile>? onCalibrationReady;

  /// Optional seam for tests/embedding. Production falls back to `/app`.
  final VoidCallback? onEnterApp;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  _OnboardingPhase _phase = _OnboardingPhase.welcome;
  bool _calibrationInFlight = false;

  void _showFirstCalibration() {
    if (_phase == _OnboardingPhase.firstCalibration) return;
    setState(() => _phase = _OnboardingPhase.firstCalibration);
  }

  Future<void> _runCalibration() async {
    final runner = widget.onRunCalibration;
    if (runner == null || _calibrationInFlight) return;

    setState(() => _calibrationInFlight = true);
    FirstCalibrationAssessment? assessment;
    try {
      assessment = await runner();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kalibrasyon başlatılamadı. Yeniden deneyebilirsin.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _calibrationInFlight = false);
      }
    }

    if (!mounted || assessment == null || !assessment.readyForStartingProfile) {
      return;
    }

    final startingProfile = assessment.startingProfile;
    if (startingProfile == null) return;

    widget.onCalibrationReady?.call(startingProfile);
    if (!mounted) return;
    setState(() => _phase = _OnboardingPhase.calibrationResult);
  }

  void _enterApp() {
    final callback = widget.onEnterApp;
    if (callback != null) {
      callback();
      return;
    }
    context.go('/app');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: switch (_phase) {
        _OnboardingPhase.welcome => OnboardingWelcomeScreen(
          onStart: _showFirstCalibration,
          onLanguage: widget.onLanguage,
          onAccessibility: widget.onAccessibility,
        ),
        _OnboardingPhase.firstCalibration => FirstCalibrationScreen(
          enabled: widget.onRunCalibration != null && !_calibrationInFlight,
          onStartCalibration: _runCalibration,
        ),
        _OnboardingPhase.calibrationResult => CalibrationResultScreen(
          onStartAdventure: _enterApp,
          onRecalibrate: _showFirstCalibration,
        ),
      },
    );
  }
}
