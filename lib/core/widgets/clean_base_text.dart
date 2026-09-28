import 'package:flutter/material.dart';

/// Runtime text layer for clean-base artwork.
///
/// Clean-base PNGs intentionally contain no localizable labels or mutable
/// values. This widget restores readable Flutter-owned text without baking it
/// back into the image, keeping the screen ready for later localization.
class CleanBaseText extends StatelessWidget {
  const CleanBaseText(
    this.text, {
    super.key,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w700,
    this.color = Colors.white,
    this.textAlign = TextAlign.center,
    this.background = const Color(0x33000000),
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final Color background;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: background,
      child: Padding(
        padding: padding,
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              textAlign: textAlign,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: fontSize,
                fontWeight: fontWeight,
                letterSpacing: 0.4,
                shadows: const [
                  Shadow(
                    color: Color(0xCC000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
