import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/adventure/adventure_screen.dart';
import 'package:actirune/features/home/home_screen.dart';
import 'package:actirune/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MainShell exposes only the canonical five root destinations', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pump();

    expect(find.byType(NavigationBar), findsOneWidget);
    for (final label in const [
      'Ana Dünya',
      'Macera',
      'Savaş',
      'Kahraman',
      'Profil',
    ]) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('Görevler'), findsNothing);
    expect(find.text('Sosyal'), findsNothing);

    final resumeBattle = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'SAVAŞA DEVAM ET'),
    );
    expect(resumeBattle.onPressed, isNull);
  });

  testWidgets(
    'artwork roots replace the shell NavigationBar instead of stacking',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainShell()));
      await tester.pump();

      await tester.tap(find.text('Macera'));
      await tester.pump();

      expect(find.byType(AdventureScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-adventure.nav-profile')),
      );
      await tester.pump();

      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-profile.nav-home')),
      );
      await tester.pump();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
    },
  );

  testWidgets(
    'Battle root remains inaccessible without a real encounter owner',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainShell()));
      await tester.pump();

      await tester.tap(find.text('Savaş'));
      await tester.pump();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        0,
      );

      await tester.tap(find.text('Macera'));
      await tester.pump();
      expect(find.byType(AdventureScreen), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-adventure.nav-battle')),
      );
      await tester.pump();

      expect(find.byType(AdventureScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    },
  );

  testWidgets('a real battle root enables canonical Battle navigation', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MainShell(
          battleRootBuilder: (_) =>
              const Scaffold(body: Center(child: Text('REAL BATTLE ROOT'))),
        ),
      ),
    );
    await tester.pump();

    final resumeBattle = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'SAVAŞA DEVAM ET'),
    );
    expect(resumeBattle.onPressed, isNotNull);

    await tester.tap(find.text('Savaş'));
    await tester.pump();

    expect(find.text('REAL BATTLE ROOT'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
