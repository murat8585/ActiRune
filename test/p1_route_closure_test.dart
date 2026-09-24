import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/adventure/world_progression_screen.dart';
import 'package:actirune/features/hero/movement_mastery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home World Map opens World Progression child', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.world-map')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(WorldProgressionScreen), findsOneWidget);
  });

  testWidgets('Profile Movement Mastery opens exact child', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.nav-profile')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-profile.movement-mastery')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MovementMasteryScreen), findsOneWidget);
  });
}
