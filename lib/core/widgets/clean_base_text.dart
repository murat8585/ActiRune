import 'package:flutter/material.dart';

/// Runtime text layer for clean-base artwork.
///
/// Clean-base PNGs intentionally contain no localizable labels or mutable
/// values. This widget restores those labels while keeping the artwork itself
/// reusable for later localization.
class CleanBaseText extends StatelessWidget {
  const CleanBaseText(
    this.text, {
    super.key,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w700,
    this.color = const Color(0xFFF3E7C6),
    this.textAlign = TextAlign.center,
    this.background = Colors.transparent,
    this.padding = EdgeInsets.zero,
    this.fontFamily = 'serif',
    this.letterSpacing = 0.8,
    this.maxLines = 2,
    this.alignment = Alignment.center,
    this.outlineColor = const Color(0xB8000000),
    this.outlineWidth = 1.15,
  });

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final Color background;
  final EdgeInsets padding;
  final String? fontFamily;
  final double letterSpacing;
  final int maxLines;
  final Alignment alignment;
  final Color outlineColor;
  final double outlineWidth;

  TextStyle _baseStyle() {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final base = _baseStyle();
    return ColoredBox(
      color: background,
      child: Padding(
        padding: padding,
        child: Align(
          alignment: alignment,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  text,
                  textAlign: textAlign,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: base.copyWith(
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = outlineWidth
                      ..strokeJoin = StrokeJoin.round
                      ..color = outlineColor,
                  ),
                ),
                Text(
                  text,
                  textAlign: textAlign,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: base.copyWith(
                    color: color,
                    shadows: const [
                      Shadow(
                        color: Color(0xCC000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
