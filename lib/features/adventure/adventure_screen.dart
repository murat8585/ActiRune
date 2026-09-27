import 'package:flutter/material.dart';
import '../../core/ui/clean_base_assets.dart';
import '../../core/ui/clean_base_navigation.dart';
import '../../core/ui/clean_base_screen.dart';

class AdventureScreen extends StatelessWidget {
  const AdventureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CleanBaseScreen(
        assetPath: CleanBaseAssets.adventure,
        children: [ActiRuneBottomNavHotspots(activeIndex: 1)],
      ),
    );
  }
}
