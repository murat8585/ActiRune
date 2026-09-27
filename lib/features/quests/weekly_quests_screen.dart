import 'package:flutter/material.dart';
import '../../core/ui/clean_base_assets.dart';
import '../../core/ui/clean_base_navigation.dart';
import '../../core/ui/clean_base_screen.dart';

class WeeklyQuestsScreen extends StatelessWidget {
  const WeeklyQuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CleanBaseScreen(
        assetPath: CleanBaseAssets.weeklyQuests,
        children: [ActiRuneBottomNavHotspots(activeIndex: -1)],
      ),
    );
  }
}
