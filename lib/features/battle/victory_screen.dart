import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/ui/clean_base_assets.dart';
import '../../core/ui/clean_base_overlay.dart';
import '../../core/ui/clean_base_screen.dart';

class VictoryScreen extends StatelessWidget {
  const VictoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CleanBaseScreen(
        assetPath: CleanBaseAssets.victory,
        children: [
          CleanBaseHotspot(
            left: 50,
            top: 1680,
            width: 610,
            height: 200,
            semanticLabel: 'Ana Dünya’ya dön',
            onTap: () => context.go('/app'),
          ),
          CleanBaseHotspot(
            left: 680,
            top: 1680,
            width: 350,
            height: 200,
            semanticLabel: 'Savaşı tekrar hazırla',
            onTap: () => context.go('/app/battle/prep'),
          ),
        ],
      ),
    );
  }
}
