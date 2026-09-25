import 'package:actirune/app/main_shell.dart';
import 'package:actirune/core/widgets/feature_unavailable_dialog.dart';
import 'package:actirune/features/profile/settings_permissions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Finder hotspot(String id) =>
      find.byKey(ValueKey<String>('artwork-hotspot-$id'));

  Future<void> tapHotspot(WidgetTester tester, String id) async {
    final finder = hotspot(id);
    expect(finder, findsOneWidget, reason: 'Missing production hotspot: $id');
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> openPermissions(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
    await tapHotspot(tester, 'home.settings');
    await tapHotspot(tester, 'settings.section-permissions');
    expect(find.byType(SettingsPermissionsScreen), findsOneWidget);
  }

  testWidgets(
    'Home Settings Permissions exposes every manage action to the platform launcher',
    (tester) async {
      await openPermissions(tester);

      const fallbackTitles = <String, String>{
        'settings-permissions.manage-camera': 'camera İzni',
        'settings-permissions.manage-physicalActivity': 'physicalActivity İzni',
        'settings-permissions.manage-notifications': 'notifications İzni',
        'settings-permissions.manage-healthIntegration': 'healthIntegration İzni',
      };

      for (final entry in fallbackTitles.entries) {
        await tapHotspot(tester, entry.key);

        // Widget CI is not Android, so the real MethodChannel launcher correctly
        // falls back to an explicit product message instead of failing silently.
        expect(find.byType(FeatureUnavailableDialog), findsOneWidget);
        expect(
          find.byKey(const ValueKey('feature-unavailable-dialog')),
          findsOneWidget,
        );
        expect(find.text(entry.value), findsOneWidget);
        await tester.tap(
          find.byKey(const ValueKey('feature-unavailable-close')),
        );
        await tester.pumpAndSettle();
        expect(find.byType(SettingsPermissionsScreen), findsOneWidget);
      }
    },
  );
}
