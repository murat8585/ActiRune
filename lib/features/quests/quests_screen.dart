import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/ui/clean_base_assets.dart';
import '../../core/ui/clean_base_navigation.dart';
import '../../core/ui/clean_base_overlay.dart';
import '../../core/ui/clean_base_screen.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CleanBaseScreen(
        assetPath: CleanBaseAssets.questCenter,
        children: [
          CleanBaseHotspot(
            left: 55,
            top: 900,
            width: 300,
            height: 610,
            semanticLabel: 'Günlük Görevler',
            onTap: () => context.go('/app/quests/daily'),
          ),
          CleanBaseHotspot(
            left: 390,
            top: 900,
            width: 300,
            height: 610,
            semanticLabel: 'Haftalık Görevler',
            onTap: () => context.go('/app/quests/weekly'),
          ),
          CleanBaseHotspot(
            left: 725,
            top: 900,
            width: 300,
            height: 610,
            semanticLabel: 'Macera',
            onTap: () => context.go('/app/adventure'),
          ),
          const ActiRuneBottomNavHotspots(activeIndex: -1),
        ],
      ),
    );
  }
}
