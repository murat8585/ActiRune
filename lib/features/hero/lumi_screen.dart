import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum LumiAbility { heal, shield, support, ultimate }

enum LumiAppearance { frost, midnight, obsidian, golden }

enum LumiRootDestination { home, adventure, battle, hero, profile }

/// Canonical Lumi exact-art shell from VIS_0178.
///
/// The approved artwork is the UI. Visible controls only dispatch intent to
/// authoritative owners. This screen does not grant XP, change bond/evolution,
/// unlock appearances, apply combat effects, or fabricate progression state.
class LumiScreen extends StatelessWidget {
  const LumiScreen({
    super.key,
    this.onDailyStreak,
    this.onBondInfo,
    this.onLevelRewards,
    this.onAbilitySelected,
    this.onAppearanceSelected,
    this.onAppearanceNext,
    this.onCustomize,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/current/01_CANONICAL_FINAL/'
      'VIS_0178__P1_LUMI_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onDailyStreak;
  final VoidCallback? onBondInfo;
  final VoidCallback? onLevelRewards;
  final ValueChanged<LumiAbility>? onAbilitySelected;
  final ValueChanged<LumiAppearance>? onAppearanceSelected;
  final VoidCallback? onAppearanceNext;
  final VoidCallback? onCustomize;
  final ValueChanged<LumiRootDestination>? onRootNavigate;
  final bool battleRootEnabled;

  ArtworkHotspot _hotspot({
    required String id,
    required String semanticLabel,
    required Rect normalizedRect,
    required VoidCallback? callback,
  }) {
    return ArtworkHotspot(
      id: id,
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback ?? () {},
    );
  }

  ArtworkHotspot _abilityHotspot({
    required LumiAbility ability,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onAbilitySelected;
    return ArtworkHotspot(
      id: 'lumi.ability-${ability.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(ability),
    );
  }

  ArtworkHotspot _appearanceHotspot({
    required LumiAppearance appearance,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onAppearanceSelected;
    return ArtworkHotspot(
      id: 'lumi.appearance-${appearance.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(appearance),
    );
  }

  ArtworkHotspot _rootHotspot({
    required LumiRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != LumiRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'lumi.nav-${destination.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: enabled,
      onTap: enabled ? () => callback(destination) : () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: ArtworkInteractionSurface(
          assetPath: artworkAsset,
          sourceSize: artworkSize,
          hotspots: [
            _hotspot(
              id: 'lumi.daily-streak',
              semanticLabel: 'Günlük Seri',
              normalizedRect: const Rect.fromLTWH(0.665, 0.018, 0.315, 0.075),
              callback: onDailyStreak,
            ),
            _hotspot(
              id: 'lumi.bond-info',
              semanticLabel: 'Lumi Bağı Bilgisi',
              normalizedRect: const Rect.fromLTWH(0.385, 0.451, 0.052, 0.042),
              callback: onBondInfo,
            ),
            _hotspot(
              id: 'lumi.level-rewards',
              semanticLabel: 'Seviye Ödülleri',
              normalizedRect: const Rect.fromLTWH(0.730, 0.465, 0.210, 0.046),
              callback: onLevelRewards,
            ),
            _abilityHotspot(
              ability: LumiAbility.heal,
              semanticLabel: 'İyileştirme Yeteneği',
              normalizedRect: const Rect.fromLTWH(0.053, 0.690, 0.205, 0.121),
            ),
            _abilityHotspot(
              ability: LumiAbility.shield,
              semanticLabel: 'Kalkan Yeteneği',
              normalizedRect: const Rect.fromLTWH(0.275, 0.690, 0.205, 0.121),
            ),
            _abilityHotspot(
              ability: LumiAbility.support,
              semanticLabel: 'Destek Yeteneği',
              normalizedRect: const Rect.fromLTWH(0.500, 0.690, 0.205, 0.121),
            ),
            _abilityHotspot(
              ability: LumiAbility.ultimate,
              semanticLabel: 'Ultimate Yeteneği',
              normalizedRect: const Rect.fromLTWH(0.720, 0.690, 0.220, 0.121),
            ),
            _appearanceHotspot(
              appearance: LumiAppearance.frost,
              semanticLabel: 'Buz Görünümü',
              normalizedRect: const Rect.fromLTWH(0.445, 0.833, 0.110, 0.070),
            ),
            _appearanceHotspot(
              appearance: LumiAppearance.midnight,
              semanticLabel: 'Gece Görünümü',
              normalizedRect: const Rect.fromLTWH(0.560, 0.833, 0.105, 0.070),
            ),
            _appearanceHotspot(
              appearance: LumiAppearance.obsidian,
              semanticLabel: 'Obsidyen Görünümü',
              normalizedRect: const Rect.fromLTWH(0.670, 0.833, 0.105, 0.070),
            ),
            _appearanceHotspot(
              appearance: LumiAppearance.golden,
              semanticLabel: 'Altın Görünümü',
              normalizedRect: const Rect.fromLTWH(0.780, 0.833, 0.105, 0.070),
            ),
            _hotspot(
              id: 'lumi.appearance-next',
              semanticLabel: 'Sonraki Görünümler',
              normalizedRect: const Rect.fromLTWH(0.885, 0.833, 0.060, 0.070),
              callback: onAppearanceNext,
            ),
            _hotspot(
              id: 'lumi.customize',
              semanticLabel: 'Lumi Görünümünü Özelleştir',
              normalizedRect: const Rect.fromLTWH(0.710, 0.903, 0.225, 0.045),
              callback: onCustomize,
            ),
            _rootHotspot(
              destination: LumiRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, 0.922, 0.200, 0.078),
            ),
            _rootHotspot(
              destination: LumiRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, 0.922, 0.200, 0.078),
            ),
            _rootHotspot(
              destination: LumiRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, 0.922, 0.200, 0.078),
            ),
            _rootHotspot(
              destination: LumiRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.600, 0.922, 0.200, 0.078),
            ),
            _rootHotspot(
              destination: LumiRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.800, 0.922, 0.200, 0.078),
            ),
          ],
        ),
      ),
    );
  }
}
