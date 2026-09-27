import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/ui/clean_base_assets.dart';
import '../../core/ui/clean_base_navigation.dart';
import '../../core/ui/clean_base_overlay.dart';
import '../../core/ui/clean_base_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CleanBaseScreen(
        assetPath: CleanBaseAssets.home,
        children: [
          CleanBaseHotspot(
            left: 0,
            top: 330,
            width: 170,
            height: 250,
            semanticLabel: 'Görev Merkezi',
            onTap: () => context.go('/app/quests'),
          ),
          const ActiRuneBottomNavHotspots(activeIndex: 0),
        ],
      ),
    );
  }
}
