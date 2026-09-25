import 'package:flutter/material.dart';

/// Home-only preview for the current strong Quest Center reference.
///
/// This screen intentionally does not invent quest-state ownership or child
/// hotspots. It provides a truthful Home -> Quest Center preview and back path
/// until the live quest center owner is connected.
class QuestCenterPreviewScreen extends StatelessWidget {
  const QuestCenterPreviewScreen({super.key, required this.onBack});

  static const artworkAsset =
      'visual_authority/20260921/current/06_CURRENT_STRONG_CHILD_REFERENCES/'
      'VIS_0173__CURRENT_QUESTS_PARENT_ALT.png';

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
                  key: const ValueKey('quest-center-preview-back'),
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
                child: _QuestPreviewBadge(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestPreviewBadge extends StatelessWidget {
  const _QuestPreviewBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xCC071522),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF3A718A)),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          'ÖNİZLEME',
          style: TextStyle(
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
