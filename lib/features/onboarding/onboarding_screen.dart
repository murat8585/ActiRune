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
    this.onSkipCalibration,
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

  /// Persists the non-medical starting profile after real evidence succeeds.
  /// A failed write must not expose a successful result screen.
  final Future<void> Function(StartingCalibrationProfile)? onCalibrationReady;
  final Future<void> Function()? onSkipCalibration;

  /// Optional seam for tests/embedding. Production falls back to `/app`.
  final VoidCallback? onEnterApp;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  _OnboardingPhase _phase = _OnboardingPhase.welcome;
  bool _calibrationInFlight = false;
  bool _skipInFlight = false;

  void _showFirstCalibration() {
    if (_phase == _OnboardingPhase.firstCalibration) return;
    setState(() => _phase = _OnboardingPhase.firstCalibration);
  }

  Future<void> _runCalibration() async {
    final runner = widget.onRunCalibration;
    if (runner == null || _calibrationInFlight) return;

    setState(() => _calibrationInFlight = true);
    try {
      FirstCalibrationAssessment? assessment;
      try {
        assessment = await runner();
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Kalibrasyon başlatılamadı. Yeniden deneyebilirsin.',
              ),
            ),
          );
        }
        return;
      }

      if (!mounted ||
          assessment == null ||
          !assessment.readyForStartingProfile) {
        return;
      }
      final startingProfile = assessment.startingProfile;
      if (startingProfile == null) return;

      try {
        await widget.onCalibrationReady?.call(startingProfile);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kalibrasyon sonucu kaydedilemedi. Yeniden dene.'),
            ),
          );
        }
        return;
      }
      if (mounted) setState(() => _phase = _OnboardingPhase.calibrationResult);
    } finally {
      if (mounted) {
        setState(() => _calibrationInFlight = false);
      }
    }
  }

  void _enterApp() {
    final callback = widget.onEnterApp;
    if (callback != null) {
      callback();
      return;
    }
    context.go('/app');
  }

  Future<void> _skipCalibration() async {
    final skip = widget.onSkipCalibration;
    if (skip == null || _skipInFlight || _calibrationInFlight) return;
    setState(() => _skipInFlight = true);
    try {
      await skip();
      if (mounted) _enterApp();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Atlama kaydedilemedi. Yeniden dene.')),
        );
      }
    } finally {
      if (mounted) setState(() => _skipInFlight = false);
    }
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
          enabled:
              widget.onRunCalibration != null &&
              !_calibrationInFlight &&
              !_skipInFlight,
          onStartCalibration: _runCalibration,
          onSkipCalibration: widget.onSkipCalibration == null
              ? null
              : _skipCalibration,
          skipEnabled: !_skipInFlight && !_calibrationInFlight,
        ),
        _OnboardingPhase.calibrationResult => CalibrationResultScreen(
          onStartAdventure: _enterApp,
          onRecalibrate: _showFirstCalibration,
        ),
      },
    );
  }
}
