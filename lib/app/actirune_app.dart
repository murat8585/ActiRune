import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/design/actirune_theme.dart';
import '../core/widgets/feature_unavailable_dialog.dart';
import '../features/onboarding/calibration_app_state.dart';
import '../features/onboarding/first_calibration_flow_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import 'main_shell.dart';

class ActiRuneApp extends StatefulWidget {
  const ActiRuneApp({
    super.key,
    this.requiredPlankHoldDuration = const Duration(seconds: 10),
    this.calibrationCameraSessionFactory =
        createProductionCalibrationCameraSession,
    this.calibrationStateStore,
    this.initialCalibrationState = const CalibrationAppState.notStarted(),
  });

  /// Product-owned first-calibration Plank target.
  final Duration? requiredPlankHoldDuration;
  final CalibrationCameraSessionFactory calibrationCameraSessionFactory;
  final CalibrationStateStore? calibrationStateStore;
  final CalibrationAppState initialCalibrationState;

  @override
  State<ActiRuneApp> createState() => _ActiRuneAppState();
}

class _ActiRuneAppState extends State<ActiRuneApp> {
  late final CalibrationStateStore _stateStore =
      widget.calibrationStateStore ?? InMemoryCalibrationStateStore();
  late final GoRouter _router = GoRouter(
    initialLocation:
        widget.initialCalibrationState.status == CalibrationStatus.skipped ||
            widget.initialCalibrationState.hasCompletedCalibration
        ? '/app'
        : '/onboarding',
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
              message:
                  'Erişilebilirlik ayarlarına uygulama içinden erişim henüz açılmadı.',
            ),
          ),
          onSkipCalibration: () =>
              _stateStore.write(const CalibrationAppState.skipped()),
          onRunCalibration: () async {
            await FeatureUnavailableDialog.show(
              context,
              feature: 'İlk Kalibrasyon',
              message:
                  'Yeni hareket algılayıcıları P5B aşamasında bağlanacak. Kalibrasyonu şimdilik geçerek uygulamaya devam edebilirsin.',
            );
            return null;
          },
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
