import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'clean_base_overlay.dart';

class ActiRuneBottomNavHotspots extends StatelessWidget {
  const ActiRuneBottomNavHotspots({super.key, required this.activeIndex});

  final int activeIndex;

  static const _routes = <String?>[
    '/app',
    '/app/adventure',
    '/app/battle/prep',
    '/app/hero',
    null,
  ];
  static const _labels = ['Ana Dünya', 'Macera', 'Savaş', 'Kahraman', 'Profil'];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List<Widget>.generate(5, (index) {
        final route = _routes[index];
        return CleanBaseHotspot(
          left: index * 216.0,
          top: 1690,
          width: 216,
          height: 230,
          semanticLabel: _labels[index],
          onTap: route == null || index == activeIndex
              ? () {}
              : () => context.go(route),
        );
      }),
    );
  }
}
