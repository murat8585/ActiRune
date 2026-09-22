import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/adventure/adventure_screen.dart';
import 'package:actirune/features/battle/battle_prep_screen.dart';
import 'package:actirune/features/hero/hero_screen.dart';
import 'package:actirune/features/home/home_screen.dart';
import 'package:actirune/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'MainShell starts on canonical Home artwork without Material nav',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainShell()));
      await tester.pump();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.text('SAVAŞA DEVAM ET'), findsNothing);

      for (final id in const [
        'home.nav-home',
        'home.nav-adventure',
        'home.nav-battle',
        'home.nav-hero',
        'home.nav-profile',
      ]) {
        expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
      }
    },
  );

  testWidgets(
    'artwork root navigation crosses Home Adventure Hero and Profile',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainShell()));
      await tester.pump();

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-home.nav-adventure')),
      );
      await tester.pump();
      expect(find.byType(AdventureScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-adventure.nav-hero')),
      );
      await tester.pump();
      expect(find.byType(HeroScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-hero.nav-profile')),
      );
      await tester.pump();
      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-profile.nav-home')),
      );
      await tester.pump();
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    },
  );

  testWidgets(
    'Battle root remains inaccessible without a real encounter owner',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainShell()));
      await tester.pump();

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-home.nav-battle')),
      );
      await tester.pump();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-home.nav-adventure')),
      );
      await tester.pump();
      expect(find.byType(AdventureScreen), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-adventure.nav-battle')),
      );
      await tester.pump();

      expect(find.byType(AdventureScreen), findsOneWidget);
    },
  );

  testWidgets(
    'a real battle root enables Battle and can return through root nav',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MainShell(
            battleRootBuilder: (_, onRootNavigate) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('REAL BATTLE ROOT'),
                    FilledButton(
                      key: const ValueKey('real-battle-home'),
                      onPressed: () =>
                          onRootNavigate(BattlePrepRootDestination.home),
                      child: const Text('ANA DÜNYAYA DÖN'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-home.nav-battle')),
      );
      await tester.pump();

      expect(find.text('REAL BATTLE ROOT'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      await tester.tap(find.byKey(const ValueKey('real-battle-home')));
      await tester.pump();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('REAL BATTLE ROOT'), findsNothing);
    },
  );
}
