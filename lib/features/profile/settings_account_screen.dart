import 'package:flutter/material.dart';

import '../../core/widgets/artwork_interaction_surface.dart';

enum AccountRootDestination { home, adventure, battle, hero, profile }

enum LinkedAccountProvider { apple, google, email }

class SettingsAccountScreen extends StatelessWidget {
  const SettingsAccountScreen({
    super.key,
    this.onBack,
    this.onEditProfile,
    this.onCopyRuneId,
    this.onLinkedAccount,
    this.onViewData,
    this.onSignOut,
    this.onDeleteAccount,
    this.onRootNavigate,
    this.battleRootEnabled = true,
  });

  static const artworkAsset =
      'visual_authority/20260921/final_remaining_13/08_SETTINGS_ACCOUNT_FINAL.png';
  static const artworkSize = Size(941, 1672);

  final VoidCallback? onBack;
  final VoidCallback? onEditProfile;
  final VoidCallback? onCopyRuneId;
  final ValueChanged<LinkedAccountProvider>? onLinkedAccount;
  final VoidCallback? onViewData;
  final VoidCallback? onSignOut;
  final VoidCallback? onDeleteAccount;
  final ValueChanged<AccountRootDestination>? onRootNavigate;
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

  ArtworkHotspot _linkedAccountHotspot({
    required LinkedAccountProvider provider,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onLinkedAccount;
    return ArtworkHotspot(
      id: 'settings-account.link-${provider.name}',
      semanticLabel: semanticLabel,
      normalizedRect: normalizedRect,
      enabled: callback != null,
      onTap: callback == null ? () {} : () => callback(provider),
    );
  }

  ArtworkHotspot _rootHotspot({
    required AccountRootDestination destination,
    required String semanticLabel,
    required Rect normalizedRect,
  }) {
    final callback = onRootNavigate;
    final enabled =
        callback != null &&
        (destination != AccountRootDestination.battle || battleRootEnabled);
    return ArtworkHotspot(
      id: 'settings-account.nav-${destination.name}',
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
              id: 'settings-account.back',
              semanticLabel: 'Geri',
              normalizedRect: const Rect.fromLTWH(0.018, 0.010, 0.090, 0.060),
              callback: onBack,
            ),
            _hotspot(
              id: 'settings-account.edit-profile',
              semanticLabel: 'Profili Düzenle',
              normalizedRect: const Rect.fromLTWH(0.245, 0.255, 0.070, 0.040),
              callback: onEditProfile,
            ),
            _hotspot(
              id: 'settings-account.copy-rune-id',
              semanticLabel: 'Rune ID Kopyala',
              normalizedRect: const Rect.fromLTWH(0.505, 0.260, 0.060, 0.040),
              callback: onCopyRuneId,
            ),
            _linkedAccountHotspot(
              provider: LinkedAccountProvider.apple,
              semanticLabel: 'Apple Hesabı',
              normalizedRect: const Rect.fromLTWH(0.095, 0.378, 0.250, 0.058),
            ),
            _linkedAccountHotspot(
              provider: LinkedAccountProvider.google,
              semanticLabel: 'Google Hesabı',
              normalizedRect: const Rect.fromLTWH(0.360, 0.378, 0.250, 0.058),
            ),
            _linkedAccountHotspot(
              provider: LinkedAccountProvider.email,
              semanticLabel: 'E-posta Hesabı',
              normalizedRect: const Rect.fromLTWH(0.620, 0.378, 0.280, 0.058),
            ),
            _hotspot(
              id: 'settings-account.view-data',
              semanticLabel: 'Verilerimi Gör',
              normalizedRect: const Rect.fromLTWH(0.095, 0.510, 0.810, 0.062),
              callback: onViewData,
            ),
            _hotspot(
              id: 'settings-account.sign-out',
              semanticLabel: 'Çıkış Yap',
              normalizedRect: const Rect.fromLTWH(0.095, 0.642, 0.810, 0.064),
              callback: onSignOut,
            ),
            _hotspot(
              id: 'settings-account.delete-account',
              semanticLabel: 'Hesabı Sil',
              normalizedRect: const Rect.fromLTWH(0.095, 0.712, 0.810, 0.064),
              callback: onDeleteAccount,
            ),
            _rootHotspot(
              destination: AccountRootDestination.home,
              semanticLabel: 'Ana Dünya',
              normalizedRect: const Rect.fromLTWH(0.000, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: AccountRootDestination.adventure,
              semanticLabel: 'Macera',
              normalizedRect: const Rect.fromLTWH(0.200, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: AccountRootDestination.battle,
              semanticLabel: 'Savaş',
              normalizedRect: const Rect.fromLTWH(0.400, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: AccountRootDestination.hero,
              semanticLabel: 'Kahraman',
              normalizedRect: const Rect.fromLTWH(0.600, 0.906, 0.200, 0.094),
            ),
            _rootHotspot(
              destination: AccountRootDestination.profile,
              semanticLabel: 'Profil',
              normalizedRect: const Rect.fromLTWH(0.800, 0.906, 0.200, 0.094),
            ),
          ],
        ),
      ),
    );
  }
}
