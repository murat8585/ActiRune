import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import 'inbox_state.dart';

/// Approved Inbox artwork with a local, explicitly illustrative message owner.
class RuneInboxScreen extends StatefulWidget {
  const RuneInboxScreen({super.key, required this.onBack, this.owner});

  static const artworkAsset =
      'visual_authority/20260921/social_approved/'
      '06_RUNE_GELEN_KUTUSU_APPROVED_REFERENCE.png';

  final VoidCallback onBack;
  final LocalInboxOwner? owner;

  @override
  State<RuneInboxScreen> createState() => _RuneInboxScreenState();
}

class _RuneInboxScreenState extends State<RuneInboxScreen> {
  late final LocalInboxOwner _owner = widget.owner ?? LocalInboxOwner();

  @override
  void initState() {
    super.initState();
    _owner.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _owner.removeListener(_refresh);
    if (widget.owner == null) _owner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final records = _owner.visible;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: RuneInboxScreen.artworkAsset,
          sourceSize: const Size(941, 1672),
          overlays: [
            ArtworkOverlay(
              id: 'inbox-owned-content',
              normalizedRect: const Rect.fromLTWH(.045, .105, .91, .74),
              interactive: true,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xF006172A),
                  border: Border.all(
                    color: const Color(0xFFD0A95C),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'YEREL ÖRNEK MESAJLAR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFD991),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          for (final category in InboxCategory.values)
                            Expanded(
                              child: GestureDetector(
                                key: ValueKey('inbox-tab-${category.name}'),
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _owner.select(category),
                                child: Container(
                                  key: ValueKey(
                                    'inbox-tab-style-${category.name}',
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _owner.selected == category
                                        ? const Color(0xFF1D617D)
                                        : const Color(0xFF102438),
                                    border: Border.all(
                                      color: _owner.selected == category
                                          ? const Color(0xFFFFD991)
                                          : const Color(0xFF385466),
                                    ),
                                  ),
                                  child: Text(
                                    switch (category) {
                                      InboxCategory.all => 'Tümü',
                                      InboxCategory.social => 'Sosyal',
                                      InboxCategory.system => 'Sistem',
                                    },
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      for (final message in records)
                        Container(
                          key: ValueKey('inbox-record-${message.id}'),
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF102C40),
                            border: Border.all(color: const Color(0xFF557488)),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFFFFD991),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                message.summary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Spacer(),
                      const Text(
                        'Bu kayıtlar hesap mesajı değildir. Yanıt, kabul ve ödül işlemleri bağlı değil.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFBBD3E3),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          hotspots: const [],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: SafeArea(
        child: IconButton.filledTonal(
          key: const ValueKey('rune-inbox-back'),
          tooltip: 'Ana Dünya’ya dön',
          onPressed: widget.onBack,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}
