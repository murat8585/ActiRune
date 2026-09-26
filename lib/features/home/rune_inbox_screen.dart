import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/feature_unavailable_dialog.dart';
import 'inbox_state.dart';

/// Approved Inbox artwork with a local, explicitly illustrative message owner.
class RuneInboxScreen extends StatefulWidget {
  const RuneInboxScreen({
    super.key,
    required this.onBack,
    this.onRootNavigate,
    this.owner,
  });

  static const artworkAsset =
      'visual_authority/20260921/social_approved/'
      '06_RUNE_GELEN_KUTUSU_APPROVED_REFERENCE.png';

  final VoidCallback onBack;
  final ValueChanged<String>? onRootNavigate;
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: RuneInboxScreen.artworkAsset,
          sourceSize: const Size(941, 1672),
          hotspots: [
            ArtworkHotspot(
              id: 'inbox.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(.013, .012, .10, .07),
              onTap: widget.onBack,
            ),
            for (final (category, x) in [
              (InboxCategory.all, .14),
              (InboxCategory.social, .39),
              (InboxCategory.system, .64),
            ])
              ArtworkHotspot(
                id: 'inbox-tab-${category.name}',
                semanticLabel: 'Gelen kutusu ${category.name}',
                normalizedRect: Rect.fromLTWH(x, .098, .23, .043),
                onTap: () => _owner.select(category),
              ),
            for (final (id, y) in [
              ('duel', .162),
              ('congratulation', .279),
              ('request', .395),
              ('league', .515),
              ('season', .63),
            ])
              ArtworkHotspot(
                id: 'inbox.preview-$id',
                semanticLabel: 'Örnek mesaj $id',
                normalizedRect: Rect.fromLTWH(.07, y, .88, .105),
                onTap: () => FeatureUnavailableDialog.show(
                  context,
                  feature: 'Gelen kutusu',
                  message:
                      'Görseldeki mesaj örnektir. Canlı hesap mesajı bağlı değil.',
                ),
              ),
            for (final (name, x) in [
              ('home', 0.0),
              ('adventure', .2),
              ('battle', .4),
              ('hero', .6),
              ('profile', .8),
            ])
              ArtworkHotspot(
                id: 'inbox.nav-$name',
                semanticLabel: 'Ana sekme $name',
                normalizedRect: Rect.fromLTWH(x, .904, .2, .076),
                onTap: () => widget.onRootNavigate == null
                    ? widget.onBack()
                    : widget.onRootNavigate!(name),
              ),
          ],
        ),
      ),
    );
  }
}
