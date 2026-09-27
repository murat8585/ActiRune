import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/ui/clean_base_assets.dart';
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
          // Quest shortcut in the left-side action rail.
          CleanBaseHotspot(
            left: 0,
            top: 330,
            width: 170,
            height: 250,
            semanticLabel: 'Görev Merkezi',
            onTap: () => context.go('/app/quests'),
          ),
          ..._bottomNavigation(context, activeIndex: 0),
        ],
      ),
    );
  }
}

List<Widget> _bottomNavigation(BuildContext context, {required int activeIndex}) {
  const routes = <String?>[
    '/app',
    '/app/adventure',
    '/app/battle/prep',
    '/app/hero',
    null,
  ];
  const labels = ['Ana Dünya', 'Macera', 'Savaş', 'Kahraman', 'Profil'];
  return List<Widget>.generate(5, (index) {
    final route = routes[index];
    return CleanBaseHotspot(
      left: index * 216.0,
      top: 1690,
      width: 216,
      height: 230,
      semanticLabel: labels[index],
      onTap: route == null || index == activeIndex ? () {} : () => context.go(route),
    );
  });
}
