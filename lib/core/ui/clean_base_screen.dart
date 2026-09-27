import 'package:flutter/material.dart';

/// Shared runtime surface for ActiRune's approved 9:16 clean-base artwork.
///
/// The image and every runtime overlay live in the same 1080x1920 logical
/// coordinate space, so scaling/cropping stays synchronized across devices.
class CleanBaseScreen extends StatelessWidget {
  const CleanBaseScreen({
    super.key,
    required this.assetPath,
    this.children = const <Widget>[],
    this.fit = BoxFit.cover,
    this.canvasSize = const Size(1080, 1920),
  });

  final String assetPath;
  final List<Widget> children;
  final BoxFit fit;
  final Size canvasSize;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: SizedBox.expand(
        child: FittedBox(
          fit: fit,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: canvasSize.width,
            height: canvasSize.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(assetPath, fit: BoxFit.fill),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Convenience helper for placing runtime widgets in the shared clean-base
/// logical coordinate system.
class CleanBasePositioned extends StatelessWidget {
  const CleanBasePositioned({
    super.key,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.child,
  });

  final double left;
  final double top;
  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: child,
    );
  }
}
