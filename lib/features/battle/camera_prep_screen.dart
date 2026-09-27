import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/ui/clean_base_assets.dart';
import '../../core/ui/clean_base_overlay.dart';
import '../../core/ui/clean_base_screen.dart';

class CameraPrepScreen extends StatelessWidget {
  const CameraPrepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CleanBaseScreen(
        assetPath: CleanBaseAssets.cameraPrep,
        children: [
          CleanBaseHotspot(
            left: 110,
            top: 1680,
            width: 860,
            height: 190,
            semanticLabel: 'Canlı savaşı başlat',
            onTap: () => context.go('/app/battle/live'),
          ),
          CleanBaseHotspot(
            left: 0,
            top: 0,
            width: 190,
            height: 180,
            semanticLabel: 'Savaş hazırlığına dön',
            onTap: () => context.go('/app/battle/prep'),
          ),
        ],
      ),
    );
  }
}
