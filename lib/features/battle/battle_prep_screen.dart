import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import 'battle_session_engine.dart';

enum BattlePrepRootDestination { home, adventure, battle, hero, profile }

class BattlePrepScreen extends StatelessWidget {
  const BattlePrepScreen({
    super.key,
    required this.session,
    required this.onBack,
    required this.onInfo,
    required this.onEquipment,
    required this.onRunes,
    required this.onCompanion,
    required this.onAbilities,
    required this.onBattleTips,
    required this.onOpenCameraPrep,
    required this.onReturnToAdventure,
    required this.onRootNavigate,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_p0_battle/P0_BATTLE_PREP_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final BattleSessionEngine session;
  final VoidCallback onBack;
  final VoidCallback onInfo;
  final VoidCallback onEquipment;
  final VoidCallback onRunes;
  final VoidCallback onCompanion;
  final VoidCallback onAbilities;
  final VoidCallback onBattleTips;
  final VoidCallback onOpenCameraPrep;
  final VoidCallback onReturnToAdventure;
  final ValueChanged<BattlePrepRootDestination> onRootNavigate;

  void _openCameraPrep() {
    session.enterCameraPrep(syntheticMode: session.snapshot.syntheticMode);
    onOpenCameraPrep();
  }

  void _leaveBattle(VoidCallback callback) {
    session.retire();
    callback();
  }

  void _leaveForRoot(BattlePrepRootDestination destination) {
    session.retire();
    onRootNavigate(destination);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: BattlePrepScreen.artworkAsset,
          sourceSize: BattlePrepScreen.artworkSize,
          hotspots: [
            ArtworkHotspot(
              id: 'battle-prep.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(
                0.0191,
                0.0132,
                0.0871,
                0.0502,
              ),
              onTap: () => _leaveBattle(onBack),
            ),
            ArtworkHotspot(
              id: 'battle-prep.info',
              semanticLabel: 'Savaş Hazırlığı Bilgisi',
              normalizedRect: const Rect.fromLTWH(
                0.8948,
                0.0132,
                0.0808,
                0.0490,
              ),
              onTap: onInfo,
            ),
            ArtworkHotspot(
              id: 'battle-prep.equipment',
              semanticLabel: 'Ekipman',
              normalizedRect: const Rect.fromLTWH(
                0.0213,
                0.5251,
                0.1817,
                0.0987,
              ),
              onTap: onEquipment,
            ),
            ArtworkHotspot(
              id: 'battle-prep.runes',
              semanticLabel: 'Runeler',
              normalizedRect: const Rect.fromLTWH(
                0.2136,
                0.5251,
                0.1817,
                0.0987,
              ),
              onTap: onRunes,
            ),
            ArtworkHotspot(
              id: 'battle-prep.companion',
              semanticLabel: 'Yoldaş',
              normalizedRect: const Rect.fromLTWH(
                0.4038,
                0.5251,
                0.1817,
                0.0987,
              ),
              onTap: onCompanion,
            ),
            ArtworkHotspot(
              id: 'battle-prep.abilities',
              semanticLabel: 'Yetenekler',
              normalizedRect: const Rect.fromLTWH(
                0.5940,
                0.5251,
                0.1817,
                0.0987,
              ),
              onTap: onAbilities,
            ),
            ArtworkHotspot(
              id: 'battle-prep.tips',
              semanticLabel: 'Savaş İpuçları',
              normalizedRect: const Rect.fromLTWH(
                0.7843,
                0.5251,
                0.1849,
                0.0987,
              ),
              onTap: onBattleTips,
            ),
            ArtworkHotspot(
              id: 'battle-prep.start',
              semanticLabel: 'Savaşa Başla',
              normalizedRect: const Rect.fromLTWH(
                0.1849,
                0.7207,
                0.6291,
                0.0700,
              ),
              onTap: _openCameraPrep,
            ),
            ArtworkHotspot(
              id: 'battle-prep.return-adventure',
              semanticLabel: 'Maceraya Dön',
              normalizedRect: const Rect.fromLTWH(
                0.2891,
                0.7978,
                0.4070,
                0.0419,
              ),
              onTap: () => _leaveBattle(onReturnToAdventure),
            ),
            ArtworkHotspot(
              id: 'battle-prep.nav-home',
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(
                0.0000,
                0.8870,
                0.1945,
                0.0951,
              ),
              onTap: () => _leaveForRoot(BattlePrepRootDestination.home),
            ),
            ArtworkHotspot(
              id: 'battle-prep.nav-adventure',
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(
                0.1945,
                0.8870,
                0.1955,
                0.0951,
              ),
              onTap: () => _leaveForRoot(BattlePrepRootDestination.adventure),
            ),
            ArtworkHotspot(
              id: 'battle-prep.nav-battle',
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(
                0.3900,
                0.8870,
                0.2083,
                0.0951,
              ),
              onTap: () => _leaveForRoot(BattlePrepRootDestination.battle),
            ),
            ArtworkHotspot(
              id: 'battle-prep.nav-hero',
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(
                0.5983,
                0.8870,
                0.1987,
                0.0951,
              ),
              onTap: () => _leaveForRoot(BattlePrepRootDestination.hero),
            ),
            ArtworkHotspot(
              id: 'battle-prep.nav-profile',
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(
                0.7970,
                0.8870,
                0.2030,
                0.0951,
              ),
              onTap: () => _leaveForRoot(BattlePrepRootDestination.profile),
            ),
          ],
        ),
      ),
    );
  }
}
