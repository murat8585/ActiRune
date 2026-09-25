import 'package:flutter/material.dart';

/// Home-only preview for the approved Rune Inbox reference.
///
/// The approved social artwork is shown without inventing message data or
/// interactive ownership. Runtime social/inbox behavior remains unconnected.
class RuneInboxPreviewScreen extends StatelessWidget {
  const RuneInboxPreviewScreen({super.key, required this.onBack});

  static const artworkAsset =
      'visual_authority/20260921/social_approved/'
      '06_RUNE_GELEN_KUTUSU_APPROVED_REFERENCE.png';

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Image.asset(
              artworkAsset,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton.filledTonal(
                  key: const ValueKey('rune-inbox-preview-back'),
                  tooltip: 'Ana Dünya’ya dön',
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
          const SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 12, 12, 0),
                child: _PreviewBadge(label: 'ÖNİZLEME'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewBadge extends StatelessWidget {
  const _PreviewBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xCC071522),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF3A718A)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8EEBFF),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
