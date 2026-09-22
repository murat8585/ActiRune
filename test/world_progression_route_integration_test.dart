import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/adventure/adventure_screen.dart';
import 'package:actirune/features/adventure/world_progression_screen.dart';
import 'package:actirune/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> openWorldProgression(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.nav-adventure')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AdventureScreen), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-adventure.world-map')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(WorldProgressionScreen), findsOneWidget);
  }

  testWidgets('Adventure World Map opens canonical World Progression', (
    tester,
  ) async {
    await openWorldProgression(tester);

    expect(
      find.byKey(
        const ValueKey('artwork-hotspot-world-progression.boss-preview'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('World Progression back returns to Adventure', (tester) async {
    await openWorldProgression(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-world-progression.back')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(WorldProgressionScreen), findsNothing);
    expect(find.byType(AdventureScreen), findsOneWidget);
  });

  testWidgets('World Progression root Home closes child route', (tester) async {
    await openWorldProgression(tester);

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-world-progression.nav-home'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(WorldProgressionScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
