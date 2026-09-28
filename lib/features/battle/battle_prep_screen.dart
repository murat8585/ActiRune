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
  static const _gold = Color(0xFFE8C875);
  static const _ivory = Color(0xFFF3E7C6);

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
              id: 'battle-prep.back-icon',
              normalizedRect: Rect.fromLTWH(0.020, 0.018, 0.070, 0.045),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: _gold,
                  size: 24,
                ),
              ),
            ),
            ArtworkOverlay(
              id: 'battle-prep.enemy-label',
              normalizedRect: Rect.fromLTWH(0.605, 0.242, 0.300, 0.034),
              child: CleanBaseText(
                'GÖLGE MUHAFIZI',
                fontSize: 15,
                color: _gold,
                letterSpacing: 0.85,
              ),
            ),
            ArtworkOverlay(
              id: 'battle-prep.equipment-label',
              normalizedRect: Rect.fromLTWH(0.070, 0.564, 0.145, 0.027),
              child: CleanBaseText(
                'EKİPMAN',
                fontSize: 12,
                color: _ivory,
                letterSpacing: 0.55,
              ),
            ),
            ArtworkOverlay(
              id: 'battle-prep.runes-label',
              normalizedRect: Rect.fromLTWH(0.220, 0.670, 0.145, 0.026),
              child: CleanBaseText(
                'RUNELER',
                fontSize: 12,
                color: _ivory,
                letterSpacing: 0.55,
              ),
            ),
            ArtworkOverlay(
              id: 'battle-prep.strategy-label',
              normalizedRect: Rect.fromLTWH(0.480, 0.748, 0.330, 0.030),
              child: CleanBaseText(
                'ÖNERİLEN STRATEJİ',
                fontSize: 13,
                color: _ivory,
                textAlign: TextAlign.left,
                alignment: Alignment.centerLeft,
                letterSpacing: 0.6,
              ),
            ),
            ArtworkOverlay(
              id: 'battle-prep.start-label',
              normalizedRect: Rect.fromLTWH(0.090, 0.904, 0.430, 0.040),
              child: CleanBaseText(
                'SAVAŞA BAŞLA',
                fontSize: 18,
                color: _ivory,
                letterSpacing: 1.0,
              ),
            ),
            ArtworkOverlay(
              id: 'battle-prep.return-label',
              normalizedRect: Rect.fromLTWH(0.665, 0.907, 0.245, 0.036),
              child: CleanBaseText(
                'MACERAYA DÖN',
                fontSize: 14,
                color: _gold,
                letterSpacing: 0.75,
              ),
            ),
          ],
          hotspots: [
            ArtworkHotspot(
              id: 'battle-prep.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.000, 0.000, 0.120, 0.085),
              onTap: () => _leaveBattle(onBack),
            ),
            ArtworkHotspot(
              id: 'battle-prep.info',
              semanticLabel: 'Savaş Hazırlığı Bilgisi',
              normalizedRect: const Rect.fromLTWH(0.900, 0.000, 0.100, 0.075),
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
              normalizedRect: const Rect.fromLTWH(0.035, 0.870, 0.555, 0.105),
              onTap: _openCameraPrep,
            ),
            ArtworkHotspot(
              id: 'battle-prep.return-adventure',
              semanticLabel: 'Maceraya Dön',
              normalizedRect: const Rect.fromLTWH(0.610, 0.870, 0.355, 0.105),
              onTap: () => _leaveBattle(onReturnToAdventure),
            ),
          ],
        ),
      ),
    );
  }
}
