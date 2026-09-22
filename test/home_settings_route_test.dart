import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/profile/settings_hub_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home Settings opens canonical Settings Hub', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.settings')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SettingsHubScreen), findsOneWidget);
  });
}
