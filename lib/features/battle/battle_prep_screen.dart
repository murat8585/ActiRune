import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/ui/clean_base_assets.dart';
import '../../core/ui/clean_base_navigation.dart';
import '../../core/ui/clean_base_overlay.dart';
import '../../core/ui/clean_base_screen.dart';

class BattlePrepScreen extends StatelessWidget {
  const BattlePrepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CleanBaseScreen(
        assetPath: CleanBaseAssets.battlePrep,
        children: [
          CleanBaseHotspot(
            left: 45,
            top: 1660,
            width: 650,
            height: 205,
            semanticLabel: 'Savaş için kamera hazırlığına geç',
            onTap: () => context.go('/app/battle/camera-prep'),
          ),
          CleanBaseHotspot(
            left: 715,
            top: 1660,
            width: 320,
            height: 205,
            semanticLabel: 'Macera ekranına dön',
            onTap: () => context.go('/app/adventure'),
          ),
          const ActiRuneBottomNavHotspots(activeIndex: 2),
        ],
      ),
    );
  }
}
