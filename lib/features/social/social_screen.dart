import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/feature_unavailable_dialog.dart';

/// The approved Rune Dostları composition is displayed without drawn-over
/// panels. Unavailable actions stay fail-closed until a real social owner exists.
class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key, this.onRootNavigate});

  static const artworkPath =
      'visual_authority/20260921/social_approved/'
      '02_RUNE_DOSTLARI_APPROVED_REFERENCE.png';

  final ValueChanged<String>? onRootNavigate;

  void _unavailable(BuildContext context, String feature, String message) {
    FeatureUnavailableDialog.show(context, feature: feature, message: message);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: ArtworkInteractionSurface(
      assetPath: artworkPath,
      sourceSize: const Size(941, 1672),
      hotspots: [
        ArtworkHotspot(
          id: 'social.back',
          semanticLabel: 'Geri',
          normalizedRect: const Rect.fromLTWH(0.012, 0.009, 0.106, 0.071),
          onTap: () => Navigator.of(context).pop(),
        ),
        ArtworkHotspot(
          id: 'social.add-friend',
          semanticLabel: 'Arkadaş ekle',
          normalizedRect: const Rect.fromLTWH(0.71, 0.02, 0.278, 0.058),
          onTap: () => _unavailable(
            context,
            'Arkadaş ekle',
            'Doğrulanmış arkadaş hesabı ve davet sahibi bağlı değil.',
          ),
        ),
        ArtworkHotspot(
          id: 'social.friends',
          semanticLabel: 'Arkadaşlar',
          normalizedRect: const Rect.fromLTWH(0.026, 0.194, 0.326, 0.046),
          onTap: () {},
        ),
        ArtworkHotspot(
          id: 'social.requests',
          semanticLabel: 'İstekler',
          normalizedRect: const Rect.fromLTWH(0.359, 0.194, 0.29, 0.046),
          onTap: () => _unavailable(
            context,
            'İstekler',
            'Canlı arkadaşlık isteği sahibi bağlı değil.',
          ),
        ),
        ArtworkHotspot(
          id: 'social.challenges',
          semanticLabel: 'Meydan okumalar',
          normalizedRect: const Rect.fromLTWH(0.657, 0.194, 0.321, 0.046),
          onTap: () => _unavailable(
            context,
            'Meydan okumalar',
            'Düello daha sonraki ürün aşaması için planlandı. '
                'İlk canlı sosyal mod iki kişilik boss raid olacak.',
          ),
        ),
        ArtworkHotspot(
          id: 'social.duel-preview',
          semanticLabel: 'Örnek düelloyu gör',
          normalizedRect: const Rect.fromLTWH(.72, .344, .23, .048),
          onTap: () => _unavailable(
            context,
            'Düello',
            'Görseldeki karşılaşma örnektir. Canlı düello kaydı bağlı değil.',
          ),
        ),
        for (final (id, y) in [
          ('friend-1', .478),
          ('friend-2', .617),
          ('friend-3', .756),
        ]) ...[
          ArtworkHotspot(
            id: 'social.$id-congratulate',
            semanticLabel: 'Örnek dosta tebrik gönder',
            normalizedRect: Rect.fromLTWH(.33, y, .27, .047),
            onTap: () => _unavailable(
              context,
              'Tebrik gönder',
              'Görseldeki kişi örnektir. Gerçek arkadaş kaydı bağlı değil.',
            ),
          ),
          ArtworkHotspot(
            id: 'social.$id-challenge',
            semanticLabel: 'Örnek dosta meydan oku',
            normalizedRect: Rect.fromLTWH(.62, y, .33, .047),
            onTap: () => _unavailable(
              context,
              'Meydan okuma',
              'Görseldeki kişi örnektir. Düello henüz canlı mod değildir.',
            ),
          ),
        ],
        ...[
          ('home', 0.0),
          ('adventure', 0.2),
          ('battle', 0.4),
          ('hero', 0.6),
          ('profile', 0.8),
        ].map(
          (nav) => ArtworkHotspot(
            id: 'social.nav-${nav.$1}',
            semanticLabel: 'Ana sekme ${nav.$1}',
            normalizedRect: Rect.fromLTWH(nav.$2, 0.904, 0.2, 0.076),
            onTap: () {
              if (onRootNavigate == null) {
                Navigator.of(context).pop();
              } else {
                onRootNavigate!(nav.$1);
              }
            },
          ),
        ),
      ],
    ),
  );
}
