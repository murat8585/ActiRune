import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/design/actirune_theme.dart';
import '../features/onboarding/first_calibration_engine.dart';
import '../features/onboarding/first_calibration_flow_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import 'main_shell.dart';

class ActiRuneApp extends StatefulWidget {
  const ActiRuneApp({
    super.key,
    this.requiredPlankHoldDuration,
    this.calibrationCameraSessionFactory =
        createProductionCalibrationCameraSession,
  });

  /// Product-owned target. An unset value keeps Plank verification blocked.
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
          onRunCalibration: () =>
              Navigator.of(context).push<FirstCalibrationAssessment>(
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
