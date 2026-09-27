import 'package:flutter/material.dart';

class CleanBaseHotspot extends StatelessWidget {
  const CleanBaseHotspot({
    super.key,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.onTap,
    this.semanticLabel,
  });

  final double left;
  final double top;
  final double width;
  final double height;
  final VoidCallback onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Semantics(
        button: true,
        label: semanticLabel,
        child: Material(
          color: Colors.transparent,
          child: InkWell(onTap: onTap),
        ),
      ),
    );
  }
}

class CleanBaseLabel extends StatelessWidget {
  const CleanBaseLabel({
    super.key,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.text,
    this.fontSize = 34,
    this.fontWeight = FontWeight.w700,
    this.color = Colors.white,
    this.alignment = Alignment.center,
  });

  final double left;
  final double top;
  final double width;
  final double height;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Align(
        alignment: alignment,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              shadows: const [
                Shadow(color: Colors.black87, blurRadius: 5, offset: Offset(0, 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
