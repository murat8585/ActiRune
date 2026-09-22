import 'package:flutter/material.dart';

import '../features/adventure/adventure_screen.dart';
import '../features/hero/hero_screen.dart';
import '../features/home/home_screen.dart';
import '../features/profile/profile_screen.dart';

enum _ShellDestination { home, adventure, battle, hero, profile }

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.battleRootBuilder});

  /// A battle root is supplied only when a real encounter/session owns it.
  /// Without one, Battle stays visible in canonical navigation but cannot be
  /// selected, avoiding a fabricated idle battle screen.
  final WidgetBuilder? battleRootBuilder;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  _ShellDestination destination = _ShellDestination.home;

  bool get _battleAvailable => widget.battleRootBuilder != null;

  void _select(_ShellDestination next) {
    if (next == _ShellDestination.battle && !_battleAvailable) return;
    if (destination == next) return;
    setState(() => destination = next);
  }

  void _selectAdventureRoot(AdventureRootDestination next) {
    _select(
      switch (next) {
        AdventureRootDestination.home => _ShellDestination.home,
        AdventureRootDestination.adventure => _ShellDestination.adventure,
        AdventureRootDestination.battle => _ShellDestination.battle,
        AdventureRootDestination.hero => _ShellDestination.hero,
        AdventureRootDestination.profile => _ShellDestination.profile,
      },
    );
  }

  void _selectProfileRoot(ProfileRootDestination next) {
    _select(
      switch (next) {
        ProfileRootDestination.home => _ShellDestination.home,
        ProfileRootDestination.adventure => _ShellDestination.adventure,
        ProfileRootDestination.battle => _ShellDestination.battle,
        ProfileRootDestination.hero => _ShellDestination.hero,
        ProfileRootDestination.profile => _ShellDestination.profile,
      },
    );
  }

  List<Widget> _screens(BuildContext context) {
    return [
      HomeScreen(
        onResumeBattle: _battleAvailable
            ? () => _select(_ShellDestination.battle)
            : null,
      ),
      AdventureScreen(
        onRootNavigate: _selectAdventureRoot,
        battleRootEnabled: _battleAvailable,
      ),
      widget.battleRootBuilder?.call(context) ?? const SizedBox.shrink(),
      const HeroScreen(),
      ProfileScreen(
        onRootNavigate: _selectProfileRoot,
        battleRootEnabled: _battleAvailable,
      ),
    ];
  }

  bool get _showShellNavigation =>
      destination == _ShellDestination.home ||
      destination == _ShellDestination.hero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: destination.index, children: _screens(context)),
      bottomNavigationBar: _showShellNavigation
          ? NavigationBar(
              selectedIndex: destination.index,
              onDestinationSelected: (index) =>
                  _select(_ShellDestination.values[index]),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Ana Dünya',
                ),
                NavigationDestination(
                  icon: Icon(Icons.map_outlined),
                  selectedIcon: Icon(Icons.map),
                  label: 'Macera',
                ),
                NavigationDestination(
                  icon: Icon(Icons.sports_martial_arts_outlined),
                  selectedIcon: Icon(Icons.sports_martial_arts),
                  label: 'Savaş',
                ),
                NavigationDestination(
                  icon: Icon(Icons.shield_outlined),
                  selectedIcon: Icon(Icons.shield),
                  label: 'Kahraman',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
            )
          : null,
    );
  }
}
