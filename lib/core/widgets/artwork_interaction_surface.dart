import 'package:flutter/material.dart';

@immutable
class ArtworkHotspot {
  const ArtworkHotspot({
    required this.id,
    required this.semanticLabel,
    required this.normalizedRect,
    required this.onTap,
    this.enabled = true,
  });

  final String id;
  final String semanticLabel;
  final Rect normalizedRect;
  final VoidCallback onTap;
  final bool enabled;
}

@immutable
class ArtworkOverlay {
  const ArtworkOverlay({
    required this.id,
    required this.normalizedRect,
    required this.child,
  });

  final String id;
  final Rect normalizedRect;
  final Widget child;
}

/// Renders an approved artwork asset without stretching it and places
/// transparent semantic interaction regions in the exact same fitted bounds.
///
/// Hotspot and overlay coordinates are normalized to the source artwork
/// (0..1). Approved screens can provide their authoritative intrinsic size so
/// geometry is available on the first frame, independent of image decoding.
/// If no size is supplied the widget resolves the asset dimensions at runtime.
class ArtworkInteractionSurface extends StatefulWidget {
  const ArtworkInteractionSurface({
    super.key,
    required this.assetPath,
    required this.hotspots,
    this.overlays = const [],
    this.sourceSize,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.backgroundColor = Colors.black,
  });

  final String assetPath;
  final List<ArtworkHotspot> hotspots;
  final List<ArtworkOverlay> overlays;
  final Size? sourceSize;
  final BoxFit fit;
  final Alignment alignment;
  final Color backgroundColor;

  @override
  State<ArtworkInteractionSurface> createState() =>
      _ArtworkInteractionSurfaceState();
}

class _ArtworkInteractionSurfaceState extends State<ArtworkInteractionSurface> {
  ImageStream? _stream;
  ImageStreamListener? _listener;
  Size? _resolvedSourceSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.sourceSize == null) _resolveImage();
  }

  @override
  void didUpdateWidget(covariant ArtworkInteractionSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath ||
        oldWidget.sourceSize != widget.sourceSize) {
      _resolvedSourceSize = null;
      _detachImageListener();
      if (widget.sourceSize == null) _resolveImage();
    }
  }

  void _resolveImage() {
    final provider = AssetImage(widget.assetPath);
    final stream = provider.resolve(createLocalImageConfiguration(context));
    if (_stream?.key == stream.key) return;

    _detachImageListener();

    _listener = ImageStreamListener((info, _) {
      final next = Size(
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      );
      if (mounted && next != _resolvedSourceSize) {
        setState(() => _resolvedSourceSize = next);
      }
    });
    _stream = stream;
    stream.addListener(_listener!);
  }

  void _detachImageListener() {
    if (_stream != null && _listener != null) {
      _stream!.removeListener(_listener!);
    }
    _stream = null;
    _listener = null;
  }

  @override
  void dispose() {
    _detachImageListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: widget.backgroundColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewport = Size(constraints.maxWidth, constraints.maxHeight);
          final source = widget.sourceSize ?? _resolvedSourceSize;

          if (source == null || viewport.isEmpty) {
            return Image.asset(
              widget.assetPath,
              fit: widget.fit,
              alignment: widget.alignment,
              excludeFromSemantics: true,
            );
          }

          final fitted = applyBoxFit(widget.fit, source, viewport);
          final imageRect = widget.alignment.inscribe(
            fitted.destination,
            Offset.zero & viewport,
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fromRect(
                rect: imageRect,
                child: Image.asset(
                  widget.assetPath,
                  fit: BoxFit.fill,
                  excludeFromSemantics: true,
                ),
              ),
              for (final overlay in widget.overlays)
                _ArtworkOverlayRegion(imageRect: imageRect, overlay: overlay),
              for (final hotspot in widget.hotspots)
                _HotspotRegion(imageRect: imageRect, hotspot: hotspot),
            ],
          );
        },
      ),
    );
  }
}

class _ArtworkOverlayRegion extends StatelessWidget {
  const _ArtworkOverlayRegion({required this.imageRect, required this.overlay});

  final Rect imageRect;
  final ArtworkOverlay overlay;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: _normalizedRectInImage(imageRect, overlay.normalizedRect),
      child: IgnorePointer(
        child: KeyedSubtree(
          key: ValueKey('artwork-overlay-${overlay.id}'),
          child: overlay.child,
        ),
      ),
    );
  }
}

class _HotspotRegion extends StatelessWidget {
  const _HotspotRegion({required this.imageRect, required this.hotspot});

  final Rect imageRect;
  final ArtworkHotspot hotspot;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: _normalizedRectInImage(imageRect, hotspot.normalizedRect),
      child: Semantics(
        key: ValueKey('artwork-hotspot-${hotspot.id}'),
        label: hotspot.semanticLabel,
        button: true,
        enabled: hotspot.enabled,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: hotspot.enabled ? hotspot.onTap : null,
          excludeFromSemantics: true,
          child: const ColoredBox(color: Colors.transparent),
        ),
      ),
    );
  }
}

Rect _normalizedRectInImage(Rect imageRect, Rect normalizedRect) {
  return Rect.fromLTWH(
    imageRect.left + (normalizedRect.left * imageRect.width),
    imageRect.top + (normalizedRect.top * imageRect.height),
    normalizedRect.width * imageRect.width,
    normalizedRect.height * imageRect.height,
  );
}
