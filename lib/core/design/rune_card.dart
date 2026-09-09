import 'package:flutter/material.dart';
import 'actirune_theme.dart';

class RuneCard extends StatelessWidget {
  const RuneCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: ActiRuneColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ActiRuneColors.cyan.withValues(alpha: .25)),
      ),
      child: child,
    );
  }
}
