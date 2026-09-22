import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onBack,
    VoidCallback? onProfileDetails,
    VoidCallback? onEditProfile,
    VoidCallback? onAvatar,
    VoidCallback? onBadges,
    VoidCallback? onMovementMastery,
    VoidCallback? onWorldProgress,
    VoidCallback? onFriends,
    VoidCallback? onHistory,
    VoidCallback? onAccountInfo,
    VoidCallback? onNotifications,
    VoidCallback? onPrivacy,
    VoidCallback? onSettings,
    ValueChanged<ProfileRootDestination>? onRootNavigate,
  }) {
    return MaterialApp(
      home: ProfileScreen(
        onBack: onBack,
        onProfileDetails: onProfileDetails,
        onEditProfile: onEditProfile,
        onAvatar: onAvatar,
        onBadges: onBadges,
        onMovementMastery: onMovementMastery,
        onWorldProgress: onWorldProgress,
        onFriends: onFriends,
        onHistory: onHistory,
        onAccountInfo: onAccountInfo,
        onNotifications: onNotifications,
        onPrivacy: onPrivacy,
        onSettings: onSettings,
        onRootNavigate: onRootNavigate,
      ),
    );
  }

  testWidgets('Profile renders the canonical base without Rune League entry', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, ProfileScreen.artworkAsset);
    expect(surface.sourceSize, ProfileScreen.artworkSize);
    expect(ProfileScreen.artworkSize, const Size(941, 1672));

    const authoritativeIds = [
      'profile.back',
      'profile.settings-top',
      'profile.details',
      'profile.edit',
      'profile.avatar',
      'profile.badges',
      'profile.movement-mastery',
      'profile.world-progress',
      'profile.friends',
      'profile.history',
      'profile.account-info',
      'profile.notifications',
      'profile.privacy',
      'profile.settings',
      'profile.nav-home',
      'profile.nav-adventure',
      'profile.nav-battle',
      'profile.nav-hero',
      'profile.nav-profile',
    ];
    for (final id in authoritativeIds) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
    }

    expect(
      find.byKey(const ValueKey('artwork-hotspot-profile.rune-league')),
      findsNothing,
    );
  });

  testWidgets('Profile visible controls dispatch without synthetic routes', (
    tester,
  ) async {
    final counts = <String, int>{};
    void hit(String id) => counts[id] = (counts[id] ?? 0) + 1;

    await tester.pumpWidget(
      buildSubject(
        onBack: () => hit('back'),
        onProfileDetails: () => hit('details'),
        onEditProfile: () => hit('edit'),
        onAvatar: () => hit('avatar'),
        onBadges: () => hit('badges'),
        onMovementMastery: () => hit('movement-mastery'),
        onWorldProgress: () => hit('world-progress'),
        onFriends: () => hit('friends'),
        onHistory: () => hit('history'),
        onAccountInfo: () => hit('account-info'),
        onNotifications: () => hit('notifications'),
        onPrivacy: () => hit('privacy'),
        onSettings: () => hit('settings'),
      ),
    );
    await tester.pump();

    for (final entry in const {
      'profile.back': 'back',
      'profile.details': 'details',
      'profile.edit': 'edit',
      'profile.avatar': 'avatar',
      'profile.badges': 'badges',
      'profile.movement-mastery': 'movement-mastery',
      'profile.world-progress': 'world-progress',
      'profile.friends': 'friends',
      'profile.history': 'history',
      'profile.account-info': 'account-info',
      'profile.notifications': 'notifications',
      'profile.privacy': 'privacy',
    }.entries) {
      await tester.tap(find.byKey(ValueKey('artwork-hotspot-${entry.key}')));
      await tester.pump();
      expect(counts[entry.value], 1);
    }

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-profile.settings-top')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-profile.settings')),
    );
    await tester.pump();
    expect(counts['settings'], 2);
  });

  testWidgets('Profile root artwork dispatches canonical destinations', (
    tester,
  ) async {
    for (final destination in ProfileRootDestination.values) {
      ProfileRootDestination? routed;
      await tester.pumpWidget(
        buildSubject(onRootNavigate: (value) => routed = value),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(ValueKey('artwork-hotspot-profile.nav-${destination.name}')),
      );
      await tester.pump();

      expect(routed, destination);
    }
  });
}
