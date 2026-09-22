import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import 'battle_session_engine.dart';

class FormCoachScreen extends StatelessWidget {
  const FormCoachScreen({
    super.key,
    required this.session,
    required this.onResumeBattle,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/02_CORE_LOCKED_ANCHORS/'
      'VIS_0353__CORE_FORM_COACH_OVERLAY_ANCHOR.png';

  final BattleSessionEngine session;
  final VoidCallback onResumeBattle;

  void _resume() {
    session.resumeLiveBattle();
    onResumeBattle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: FormCoachScreen.artworkAsset,
          hotspots: [
            ArtworkHotspot(
              id: 'form-coach.pause',
              semanticLabel: 'Savaşa Dön',
              normalizedRect: const Rect.fromLTWH(0.031, 0.118, 0.071, 0.046),
              onTap: _resume,
            ),
            ArtworkHotspot(
              id: 'form-coach.rune-action',
              semanticLabel: 'Rune Gücü',
              normalizedRect: const Rect.fromLTWH(0.867, 0.215, 0.082, 0.056),
              onTap: () => session.requestSupportAction(
                BattleSupportAction.runePower,
              ),
            ),
            ArtworkHotspot(
              id: 'form-coach.guard-action',
              semanticLabel: 'Koruma',
              normalizedRect: const Rect.fromLTWH(0.869, 0.288, 0.080, 0.054),
              onTap: () => session.requestSupportAction(
                BattleSupportAction.protection,
              ),
            ),
            ArtworkHotspot(
              id: 'form-coach.potion-action',
              semanticLabel: 'Güç İksiri',
              normalizedRect: const Rect.fromLTWH(0.868, 0.357, 0.080, 0.052),
              onTap: () => session.requestSupportAction(
                BattleSupportAction.powerPotion,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
