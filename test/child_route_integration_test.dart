import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/hero/equipment_screen.dart';
import 'package:actirune/features/hero/inventory_screen.dart';
import 'package:actirune/features/hero/lumi_screen.dart';
import 'package:actirune/features/hero/movement_mastery_screen.dart';
import 'package:actirune/features/home/rune_shrine_ready_screen.dart';
import 'package:actirune/features/profile/player_level_screen.dart';
import 'package:actirune/features/profile/profile_history_screen.dart';
import 'package:actirune/features/profile/profile_screen.dart';
import 'package:actirune/features/profile/settings_accessibility_screen.dart';
import 'package:actirune/features/profile/settings_account_screen.dart';
import 'package:actirune/features/profile/settings_hub_screen.dart';
import 'package:actirune/features/profile/settings_notifications_screen.dart';
import 'package:actirune/features/profile/settings_permissions_screen.dart';
import 'package:actirune/features/profile/settings_privacy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> openHero(WidgetTester tester) async {
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.nav-hero')),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openProfile(WidgetTester tester) async {
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.nav-profile')),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Home Rewards opens Rune Shrine and root navigation exits child',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainShell()));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-home.rewards')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(RuneShrineReadyScreen), findsOneWidget);

      await tester.tap(
        find.byKey(
          const ValueKey('artwork-hotspot-rune-shrine-ready.nav-profile'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.byType(RuneShrineReadyScreen), findsNothing);
    },
  );

  testWidgets('Hero Equipment opens Inventory and back preserves the stack', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
    await openHero(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-hero.equipment')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(EquipmentScreen), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-equipment.inventory')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(InventoryScreen), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-inventory.back')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(EquipmentScreen), findsOneWidget);
  });

  testWidgets('Inventory root navigation closes all child routes', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
    await openHero(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-hero.equipment')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-equipment.inventory')),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-inventory.nav-profile')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.byType(InventoryScreen), findsNothing);
    expect(find.byType(EquipmentScreen), findsNothing);
  });

  testWidgets('Hero opens Movement Mastery exact-art child', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
    await openHero(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-hero.movement-mastery')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MovementMasteryScreen), findsOneWidget);
  });

  testWidgets('Hero companion entries open Lumi exact-art child', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
    await openHero(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-hero.companion')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(LumiScreen), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-lumi.nav-hero')),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-hero.companion-details')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(LumiScreen), findsOneWidget);
  });

  testWidgets('Profile opens Player Level and History children', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
    await openProfile(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-profile.details')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(PlayerLevelScreen), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-player-level.back')),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-profile.history')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ProfileHistoryScreen), findsOneWidget);
  });

  testWidgets('Profile quick settings routes open exact child screens', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
    await openProfile(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-profile.account-info')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SettingsAccountScreen), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-settings-account.back')),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-profile.notifications')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SettingsNotificationsScreen), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-settings-notifications.back')),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-profile.privacy')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPrivacyScreen), findsOneWidget);
  });

  testWidgets('Settings Hub opens Permissions and Accessibility children', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
    await openProfile(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-profile.settings')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SettingsHubScreen), findsOneWidget);

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-settings.section-permissions'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPermissionsScreen), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-settings-permissions.back')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SettingsHubScreen), findsOneWidget);

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-settings.section-accessibility'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SettingsAccessibilityScreen), findsOneWidget);
  });
}
