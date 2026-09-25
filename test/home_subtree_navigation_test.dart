import 'package:actirune/app/main_shell.dart';
import 'package:actirune/core/widgets/feature_unavailable_dialog.dart';
import 'package:actirune/features/adventure/adventure_screen.dart';
import 'package:actirune/features/hero/hero_screen.dart';
import 'package:actirune/features/home/home_screen.dart';
import 'package:actirune/features/profile/profile_screen.dart';
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

  Future<void> openPath(WidgetTester tester, List<String> path) async {
    await pumpHome(tester);
    for (final id in path) {
      await tapHotspot(tester, id);
    }
  }

  Future<void> expectBattleLocked(WidgetTester tester) async {
    expect(find.byType(FeatureUnavailableDialog), findsOneWidget);
    expect(find.text('Savaş'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('feature-unavailable-close')));
    await tester.pumpAndSettle();
  }

  Future<void> verifyRootNavigation(
    WidgetTester tester, {
    required List<String> openPathIds,
    required String prefix,
  }) async {
    await openPath(tester, openPathIds);
    await tapHotspot(tester, '$prefix.nav-home');
    expect(find.byType(HomeScreen), findsOneWidget);

    await openPath(tester, openPathIds);
    await tapHotspot(tester, '$prefix.nav-adventure');
    expect(find.byType(AdventureScreen), findsOneWidget);

    await openPath(tester, openPathIds);
    await tapHotspot(tester, '$prefix.nav-battle');
    await expectBattleLocked(tester);

    await openPath(tester, openPathIds);
    await tapHotspot(tester, '$prefix.nav-hero');
    expect(find.byType(HeroScreen), findsOneWidget);

    await openPath(tester, openPathIds);
    await tapHotspot(tester, '$prefix.nav-profile');
    expect(find.byType(ProfileScreen), findsOneWidget);
  }

  testWidgets('Home current-root hotspot remains responsive', (tester) async {
    await pumpHome(tester);
    await tapHotspot(tester, 'home.nav-home');
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  final childRoots = <String, List<String>>{
    'events': ['home.events'],
    'world-progression': ['home.world-map'],
    'rune-shrine-ready': ['home.rewards'],
    'settings': ['home.settings'],
    'settings-account': ['home.settings', 'settings.section-account'],
    'settings-notifications': [
      'home.settings',
      'settings.section-notifications',
    ],
    'settings-privacy': ['home.settings', 'settings.section-privacy'],
    'settings-permissions': ['home.settings', 'settings.section-permissions'],
    'settings-accessibility': [
      'home.settings',
      'settings.section-accessibility',
    ],
  };

  for (final entry in childRoots.entries) {
    testWidgets('${entry.key} routes every visible root navigation control', (
      tester,
    ) async {
      await verifyRootNavigation(
        tester,
        openPathIds: entry.value,
        prefix: entry.key,
      );
    });
  }
}
