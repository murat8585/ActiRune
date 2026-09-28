import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';
import '../../core/widgets/clean_base_text.dart';
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
      'assets/ui/clean_base_final_60/46__LATE_QA_POS_15__PASS.png';
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
          overlays: const [
            ArtworkOverlay(
              id: 'battle-prep.title',
              normalizedRect: Rect.fromLTWH(0.070, 0.025, 0.420, 0.055),
              child: CleanBaseText('SAVAŞ HAZIRLIĞI', fontSize: 23),
            ),
            ArtworkOverlay(
              id: 'battle-prep.enemy-label',
              normalizedRect: Rect.fromLTWH(0.595, 0.245, 0.300, 0.045),
              child: CleanBaseText('GÖLGE MUHAFIZI', fontSize: 17),
            ),
            ArtworkOverlay(
              id: 'battle-prep.equipment-label',
              normalizedRect: Rect.fromLTWH(0.060, 0.565, 0.170, 0.035),
              child: CleanBaseText('Ekipman', fontSize: 14),
            ),
            ArtworkOverlay(
              id: 'battle-prep.runes-label',
              normalizedRect: Rect.fromLTWH(0.225, 0.665, 0.145, 0.035),
              child: CleanBaseText('Runeler', fontSize: 14),
            ),
            ArtworkOverlay(
              id: 'battle-prep.strategy-label',
              normalizedRect: Rect.fromLTWH(0.420, 0.755, 0.360, 0.040),
              child: CleanBaseText('ÖNERİLEN STRATEJİ', fontSize: 16),
            ),
            ArtworkOverlay(
              id: 'battle-prep.start-label',
              normalizedRect: Rect.fromLTWH(0.065, 0.910, 0.490, 0.050),
              child: CleanBaseText('SAVAŞA BAŞLA', fontSize: 21),
            ),
            ArtworkOverlay(
              id: 'battle-prep.return-label',
              normalizedRect: Rect.fromLTWH(0.650, 0.912, 0.275, 0.046),
              child: CleanBaseText('MACERAYA DÖN', fontSize: 16),
            ),
          ],
          hotspots: [
            ArtworkHotspot(
              id: 'battle-prep.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.000, 0.000, 0.090, 0.065),
              onTap: () => _leaveBattle(onBack),
            ),
            ArtworkHotspot(
              id: 'battle-prep.info',
              semanticLabel: 'Savaş Hazırlığı Bilgisi',
              normalizedRect: const Rect.fromLTWH(0.910, 0.000, 0.090, 0.065),
              onTap: onInfo,
            ),
            ArtworkHotspot(
              id: 'battle-prep.equipment',
              semanticLabel: 'Ekipman',
              normalizedRect: const Rect.fromLTWH(0.030, 0.475, 0.185, 0.125),
              onTap: onEquipment,
            ),
            ArtworkHotspot(
              id: 'battle-prep.runes',
              semanticLabel: 'Runeler',
              normalizedRect: const Rect.fromLTWH(0.205, 0.615, 0.155, 0.105),
              onTap: onRunes,
            ),
            ArtworkHotspot(
              id: 'battle-prep.companion',
              semanticLabel: 'Yoldaş',
              normalizedRect: const Rect.fromLTWH(0.365, 0.615, 0.155, 0.105),
              onTap: onCompanion,
            ),
            ArtworkHotspot(
              id: 'battle-prep.abilities',
              semanticLabel: 'Yetenekler',
              normalizedRect: const Rect.fromLTWH(0.525, 0.615, 0.155, 0.105),
              onTap: onAbilities,
            ),
            ArtworkHotspot(
              id: 'battle-prep.tips',
              semanticLabel: 'Savaş İpuçları',
              normalizedRect: const Rect.fromLTWH(0.685, 0.615, 0.270, 0.105),
              onTap: onBattleTips,
            ),
            ArtworkHotspot(
              id: 'battle-prep.start',
              semanticLabel: 'Savaşa Başla',
              normalizedRect: const Rect.fromLTWH(0.035, 0.875, 0.555, 0.100),
              onTap: _openCameraPrep,
            ),
            ArtworkHotspot(
              id: 'battle-prep.return-adventure',
              semanticLabel: 'Maceraya Dön',
              normalizedRect: const Rect.fromLTWH(0.610, 0.875, 0.355, 0.100),
              onTap: () => _leaveBattle(onReturnToAdventure),
            ),
            ArtworkHotspot(
              id: 'battle-prep.nav-home',
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, 0.000, 0.200, 0.012),
              onTap: () => _leaveForRoot(BattlePrepRootDestination.home),
            ),
            ArtworkHotspot(
              id: 'battle-prep.nav-adventure',
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, 0.000, 0.200, 0.012),
              onTap: () => _leaveForRoot(BattlePrepRootDestination.adventure),
            ),
            ArtworkHotspot(
              id: 'battle-prep.nav-battle',
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, 0.000, 0.200, 0.012),
              onTap: () => _leaveForRoot(BattlePrepRootDestination.battle),
            ),
            ArtworkHotspot(
              id: 'battle-prep.nav-hero',
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.600, 0.000, 0.200, 0.012),
              onTap: () => _leaveForRoot(BattlePrepRootDestination.hero),
            ),
            ArtworkHotspot(
              id: 'battle-prep.nav-profile',
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.800, 0.000, 0.200, 0.012),
              onTap: () => _leaveForRoot(BattlePrepRootDestination.profile),
            ),
          ],
        ),
      ),
    );
  }
}
