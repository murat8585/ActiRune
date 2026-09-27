import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/design/actirune_theme.dart';
import '../features/adventure/adventure_screen.dart';
import '../features/battle/battle_prep_screen.dart';
import '../features/battle/battle_screen.dart';
import '../features/battle/camera_prep_screen.dart';
import '../features/battle/defeat_screen.dart';
import '../features/battle/victory_screen.dart';
import '../features/hero/hero_screen.dart';
import '../features/home/home_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/quests/daily_quests_screen.dart';
import '../features/quests/quests_screen.dart';
import '../features/quests/weekly_quests_screen.dart';

class ActiRuneApp extends StatelessWidget {
  const ActiRuneApp({super.key});

  static final _router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/app', builder: (_, _) => const HomeScreen()),
      GoRoute(path: '/app/quests', builder: (_, _) => const QuestsScreen()),
      GoRoute(
        path: '/app/quests/daily',
        builder: (_, _) => const DailyQuestsScreen(),
      ),
      GoRoute(
        path: '/app/quests/weekly',
        builder: (_, _) => const WeeklyQuestsScreen(),
      ),
      GoRoute(path: '/app/adventure', builder: (_, _) => const AdventureScreen()),
      GoRoute(path: '/app/battle/prep', builder: (_, _) => const BattlePrepScreen()),
      GoRoute(
        path: '/app/battle/camera-prep',
        builder: (_, _) => const CameraPrepScreen(),
      ),
      GoRoute(path: '/app/battle/live', builder: (_, _) => const BattleScreen()),
      GoRoute(
        path: '/app/battle/victory',
        builder: (_, _) => const VictoryScreen(),
      ),
      GoRoute(
        path: '/app/battle/defeat',
        builder: (_, _) => const DefeatScreen(),
      ),
      GoRoute(path: '/app/hero', builder: (_, _) => const HeroScreen()),
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
