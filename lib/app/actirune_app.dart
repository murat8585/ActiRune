import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/design/actirune_theme.dart';
import '../features/onboarding/onboarding_screen.dart';
import 'main_shell.dart';

class ActiRuneApp extends StatelessWidget {
  const ActiRuneApp({super.key});

  static final _router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/app', builder: (_, _) => const MainShell()),
    ],
  );

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
