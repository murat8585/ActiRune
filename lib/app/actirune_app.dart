import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/design/actirune_theme.dart';
import '../core/widgets/feature_unavailable_dialog.dart';
import '../features/onboarding/first_calibration_engine.dart';
import '../features/onboarding/first_calibration_flow_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import 'main_shell.dart';

class ActiRuneApp extends StatefulWidget {
  const ActiRuneApp({
    super.key,
    this.requiredPlankHoldDuration = const Duration(seconds: 10),
    this.calibrationCameraSessionFactory =
        createProductionCalibrationCameraSession,
  });

  /// Product-owned first-calibration Plank target.
  final Duration? requiredPlankHoldDuration;
  final CalibrationCameraSessionFactory calibrationCameraSessionFactory;

  @override
  State<ActiRuneApp> createState() => _ActiRuneAppState();
}

class _ActiRuneAppState extends State<ActiRuneApp> {
  late final GoRouter _router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, _) => OnboardingScreen(
          onLanguage: () => unawaited(
            FeatureUnavailableDialog.show(
              context,
              feature: 'Dil Seçimi',
              message: 'Dil seçimi henüz kullanıma açılmadı.',
            ),
          ),
          onAccessibility: () => unawaited(
            FeatureUnavailableDialog.show(
              context,
              feature: 'Erişilebilirlik',
              message: 'Erişilebilirlik ayarlarına uygulama içinden erişim henüz açılmadı.',
            ),
          ),
          onRunCalibration: () => Navigator.of(context)
              .push<FirstCalibrationAssessment>(
                MaterialPageRoute(
                  builder: (_) => FirstCalibrationFlowScreen(
                    requiredPlankHoldDuration: widget.requiredPlankHoldDuration,
                    cameraSessionFactory:
                        widget.calibrationCameraSessionFactory,
                  ),
                ),
              ),
        ),
      ),
      GoRoute(path: '/app', builder: (_, _) => const MainShell()),
    ],
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ActiRune',
      debugShowCheckedModeBanner: false,
      theme: buildActiRuneTheme(),
      routerConfig: _router,
    );
  }
}
