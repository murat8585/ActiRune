import 'package:flutter/material.dart';
import '../../core/ui/clean_base_assets.dart';
import '../../core/ui/clean_base_navigation.dart';
import '../../core/ui/clean_base_screen.dart';

class DailyQuestsScreen extends StatelessWidget {
  const DailyQuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CleanBaseScreen(
        assetPath: CleanBaseAssets.dailyQuests,
        children: [ActiRuneBottomNavHotspots(activeIndex: -1)],
      ),
    );
  }
}
