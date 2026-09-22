import 'package:flutter/material.dart';

import '../features/adventure/adventure_screen.dart';
import '../features/battle/battle_prep_screen.dart';
import '../features/hero/equipment_screen.dart';
import '../features/hero/hero_screen.dart';
import '../features/hero/inventory_screen.dart';
import '../features/home/home_screen.dart';
import '../features/profile/profile_screen.dart';

enum _ShellDestination { home, adventure, battle, hero, profile }

typedef BattleRootBuilder =
    Widget Function(
      BuildContext context,
      ValueChanged<BattlePrepRootDestination> onRootNavigate,
    );

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.battleRootBuilder});

  /// A battle root is supplied only when a real encounter/session owns it.
  /// Without one, Battle stays visible in canonical artwork navigation but
  /// cannot be selected, avoiding a fabricated idle battle screen.
  final BattleRootBuilder? battleRootBuilder;

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

  void _selectHomeRoot(HomeRootDestination next) {
    _select(switch (next) {
      HomeRootDestination.home => _ShellDestination.home,
      HomeRootDestination.adventure => _ShellDestination.adventure,
      HomeRootDestination.battle => _ShellDestination.battle,
      HomeRootDestination.hero => _ShellDestination.hero,
      HomeRootDestination.profile => _ShellDestination.profile,
    });
  }

  void _selectAdventureRoot(AdventureRootDestination next) {
    _select(switch (next) {
      AdventureRootDestination.home => _ShellDestination.home,
      AdventureRootDestination.adventure => _ShellDestination.adventure,
      AdventureRootDestination.battle => _ShellDestination.battle,
      AdventureRootDestination.hero => _ShellDestination.hero,
      AdventureRootDestination.profile => _ShellDestination.profile,
    });
  }

  void _selectBattleRoot(BattlePrepRootDestination next) {
    _select(switch (next) {
      BattlePrepRootDestination.home => _ShellDestination.home,
      BattlePrepRootDestination.adventure => _ShellDestination.adventure,
      BattlePrepRootDestination.battle => _ShellDestination.battle,
      BattlePrepRootDestination.hero => _ShellDestination.hero,
      BattlePrepRootDestination.profile => _ShellDestination.profile,
    });
  }

  void _selectHeroRoot(HeroRootDestination next) {
    _select(switch (next) {
      HeroRootDestination.home => _ShellDestination.home,
      HeroRootDestination.adventure => _ShellDestination.adventure,
      HeroRootDestination.battle => _ShellDestination.battle,
      HeroRootDestination.hero => _ShellDestination.hero,
      HeroRootDestination.profile => _ShellDestination.profile,
    });
  }

  void _selectProfileRoot(ProfileRootDestination next) {
    _select(switch (next) {
      ProfileRootDestination.home => _ShellDestination.home,
      ProfileRootDestination.adventure => _ShellDestination.adventure,
      ProfileRootDestination.battle => _ShellDestination.battle,
      ProfileRootDestination.hero => _ShellDestination.hero,
      ProfileRootDestination.profile => _ShellDestination.profile,
    });
  }

  void _selectEquipmentRoot(EquipmentRootDestination next) {
    _select(switch (next) {
      EquipmentRootDestination.home => _ShellDestination.home,
      EquipmentRootDestination.adventure => _ShellDestination.adventure,
      EquipmentRootDestination.battle => _ShellDestination.battle,
      EquipmentRootDestination.hero => _ShellDestination.hero,
      EquipmentRootDestination.profile => _ShellDestination.profile,
    });
  }

  void _selectInventoryRoot(InventoryRootDestination next) {
    _select(switch (next) {
      InventoryRootDestination.home => _ShellDestination.home,
      InventoryRootDestination.adventure => _ShellDestination.adventure,
      InventoryRootDestination.battle => _ShellDestination.battle,
      InventoryRootDestination.hero => _ShellDestination.hero,
      InventoryRootDestination.profile => _ShellDestination.profile,
    });
  }

  void _closeChildStackAndSelect(
    BuildContext routeContext,
    _ShellDestination next,
  ) {
    if (next == _ShellDestination.battle && !_battleAvailable) return;
    Navigator.of(routeContext).popUntil((route) => route.isFirst);
    _select(next);
  }

  Future<void> _openInventory(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => InventoryScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onRootNavigate: (next) {
            final shellDestination = switch (next) {
              InventoryRootDestination.home => _ShellDestination.home,
              InventoryRootDestination.adventure => _ShellDestination.adventure,
              InventoryRootDestination.battle => _ShellDestination.battle,
              InventoryRootDestination.hero => _ShellDestination.hero,
              InventoryRootDestination.profile => _ShellDestination.profile,
            };
            _closeChildStackAndSelect(routeContext, shellDestination);
          },
          battleRootEnabled: _battleAvailable,
        ),
      ),
    );
  }

  Future<void> _openEquipment(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => EquipmentScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onInventory: () => _openInventory(routeContext),
          onRootNavigate: (next) {
            if (next == EquipmentRootDestination.battle && !_battleAvailable) {
              return;
            }
            Navigator.of(routeContext).pop();
            _selectEquipmentRoot(next);
          },
          battleRootEnabled: _battleAvailable,
        ),
      ),
    );
  }

  List<Widget> _screens(BuildContext context) {
    return [
      HomeScreen(
        onRootNavigate: _selectHomeRoot,
        battleRootEnabled: _battleAvailable,
      ),
      AdventureScreen(
        onRootNavigate: _selectAdventureRoot,
        battleRootEnabled: _battleAvailable,
      ),
      widget.battleRootBuilder?.call(context, _selectBattleRoot) ??
          const SizedBox.shrink(),
      HeroScreen(
        onEquipment: () => _openEquipment(context),
        onRootNavigate: _selectHeroRoot,
        battleRootEnabled: _battleAvailable,
      ),
      ProfileScreen(
        onRootNavigate: _selectProfileRoot,
        battleRootEnabled: _battleAvailable,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(index: destination.index, children: _screens(context)),
    );
  }
}
