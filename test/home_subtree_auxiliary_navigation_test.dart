import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/adventure/world_progression_screen.dart';
import 'package:actirune/features/hero/hero_screen.dart';
import 'package:actirune/features/home/daily_summary_popup.dart';
import 'package:actirune/features/home/events_screen.dart';
import 'package:actirune/features/home/home_screen.dart';
import 'package:actirune/features/home/rune_shrine_ready_screen.dart';
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

  Finder hotspot(String id) =>
      find.byKey(ValueKey<String>('artwork-hotspot-$id'));

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
  }

  Future<void> tapHotspot(WidgetTester tester, String id) async {
    final finder = hotspot(id);
    expect(finder, findsOneWidget, reason: 'Missing production hotspot: $id');
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('Events back returns to Home', (tester) async {
    await pumpHome(tester);
    await tapHotspot(tester, 'home.events');
    expect(find.byType(EventsScreen), findsOneWidget);
    await tapHotspot(tester, 'events.back');
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('World Progression back, hero, settings and notifications route correctly', (
    tester,
  ) async {
    await pumpHome(tester);
    await tapHotspot(tester, 'home.world-map');
    expect(find.byType(WorldProgressionScreen), findsOneWidget);
    await tapHotspot(tester, 'world-progression.back');
    expect(find.byType(HomeScreen), findsOneWidget);

    await pumpHome(tester);
    await tapHotspot(tester, 'home.world-map');
    await tapHotspot(tester, 'world-progression.hero-profile');
    expect(find.byType(HeroScreen), findsOneWidget);

    await pumpHome(tester);
    await tapHotspot(tester, 'home.world-map');
    await tapHotspot(tester, 'world-progression.settings');
    expect(find.byType(SettingsHubScreen), findsOneWidget);

    await pumpHome(tester);
    await tapHotspot(tester, 'home.world-map');
    await tapHotspot(tester, 'world-progression.notifications');
    expect(find.byType(SettingsNotificationsScreen), findsOneWidget);
  });

  testWidgets('Daily Summary close returns to Home without changing root', (
    tester,
  ) async {
    await pumpHome(tester);
    await tapHotspot(tester, 'home.yesterday-summary');
    expect(find.byType(DailySummaryPopup), findsOneWidget);
    await tapHotspot(tester, 'daily-summary.close');
    expect(find.byType(DailySummaryPopup), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Rune Shrine close returns to Home', (tester) async {
    await pumpHome(tester);
    await tapHotspot(tester, 'home.rewards');
    expect(find.byType(RuneShrineReadyScreen), findsOneWidget);
    await tapHotspot(tester, 'rune-shrine-ready.close');
    expect(find.byType(RuneShrineReadyScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Settings Hub back returns to Home', (tester) async {
    await pumpHome(tester);
    await tapHotspot(tester, 'home.settings');
    expect(find.byType(SettingsHubScreen), findsOneWidget);
    await tapHotspot(tester, 'settings.back');
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  final settingsChildren = <String, Type>{
    'account': SettingsAccountScreen,
    'notifications': SettingsNotificationsScreen,
    'privacy': SettingsPrivacyScreen,
    'permissions': SettingsPermissionsScreen,
    'accessibility': SettingsAccessibilityScreen,
  };

  for (final entry in settingsChildren.entries) {
    testWidgets('Settings ${entry.key} back returns to Settings Hub', (
      tester,
    ) async {
      await pumpHome(tester);
      await tapHotspot(tester, 'home.settings');
      await tapHotspot(tester, 'settings.section-${entry.key}');
      expect(find.byType(entry.value), findsOneWidget);
      await tapHotspot(tester, 'settings-${entry.key}.back');
      expect(find.byType(SettingsHubScreen), findsOneWidget);
    });
  }
}
