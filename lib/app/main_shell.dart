import 'package:flutter/material.dart';

import '../features/adventure/adventure_screen.dart';
import '../features/battle/battle_prep_screen.dart';
import '../features/hero/equipment_screen.dart';
import '../features/hero/hero_screen.dart';
import '../features/hero/inventory_screen.dart';
import '../features/hero/movement_mastery_screen.dart';
import '../features/home/event_detail_popup.dart';
import '../features/home/events_screen.dart';
import '../features/home/home_screen.dart';
import '../features/profile/player_level_screen.dart';
import '../features/profile/profile_history_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/settings_accessibility_screen.dart';
import '../features/profile/settings_account_screen.dart';
import '../features/profile/settings_hub_screen.dart';
import '../features/profile/settings_notifications_screen.dart';
import '../features/profile/settings_permissions_screen.dart';
import '../features/profile/settings_privacy_screen.dart';

enum _ShellDestination { home, adventure, battle, hero, profile }

typedef BattleRootBuilder = Widget Function(
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

  _ShellDestination _rootByName(String name) {
    return switch (name) {
      'home' => _ShellDestination.home,
      'adventure' => _ShellDestination.adventure,
      'battle' => _ShellDestination.battle,
      'hero' => _ShellDestination.hero,
      'profile' => _ShellDestination.profile,
      _ => throw ArgumentError.value(name, 'name', 'Unknown root destination'),
    };
  }

  void _selectHomeRoot(HomeRootDestination next) =>
      _select(_rootByName(next.name));
  void _selectAdventureRoot(AdventureRootDestination next) =>
      _select(_rootByName(next.name));
  void _selectBattleRoot(BattlePrepRootDestination next) =>
      _select(_rootByName(next.name));
  void _selectHeroRoot(HeroRootDestination next) =>
      _select(_rootByName(next.name));
  void _selectProfileRoot(ProfileRootDestination next) =>
      _select(_rootByName(next.name));

  void _closeChildStackAndSelect(BuildContext routeContext, String rootName) {
    final next = _rootByName(rootName);
    if (next == _ShellDestination.battle && !_battleAvailable) return;
    Navigator.of(routeContext).popUntil((route) => route.isFirst);
    _select(next);
  }

  Future<void> _openEventDetail(BuildContext context) async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Etkinlik Detayı',
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      pageBuilder: (dialogContext, _, __) =>
          EventDetailPopup(onClose: () => Navigator.of(dialogContext).pop()),
    );
  }

  Future<void> _openEvents(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => EventsScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onFeaturedEvent: () => _openEventDetail(routeContext),
          onEvent: (_) => _openEventDetail(routeContext),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: _battleAvailable,
        ),
      ),
    );
  }

  Future<void> _openInventory(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => InventoryScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
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
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: _battleAvailable,
        ),
      ),
    );
  }

  Future<void> _openMovementMastery(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => MovementMasteryScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: _battleAvailable,
        ),
      ),
    );
  }

  Future<void> _openPlayerLevel(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => PlayerLevelScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: _battleAvailable,
        ),
      ),
    );
  }

  Future<void> _openProfileHistory(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => ProfileHistoryScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: _battleAvailable,
        ),
      ),
    );
  }

  Future<void> _openAccount(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => SettingsAccountScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: _battleAvailable,
        ),
      ),
    );
  }

  Future<void> _openNotifications(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => SettingsNotificationsScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: _battleAvailable,
        ),
      ),
    );
  }

  Future<void> _openPrivacy(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => SettingsPrivacyScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: _battleAvailable,
        ),
      ),
    );
  }

  Future<void> _openPermissions(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => SettingsPermissionsScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: _battleAvailable,
        ),
      ),
    );
  }

  Future<void> _openAccessibility(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => SettingsAccessibilityScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: _battleAvailable,
        ),
      ),
    );
  }

  Future<void> _openSettingsHub(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => SettingsHubScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onSection: (section) {
            switch (section) {
              case SettingsSection.account:
                _openAccount(routeContext);
              case SettingsSection.notifications:
                _openNotifications(routeContext);
              case SettingsSection.privacy:
                _openPrivacy(routeContext);
              case SettingsSection.permissions:
                _openPermissions(routeContext);
              case SettingsSection.accessibility:
                _openAccessibility(routeContext);
            }
          },
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: _battleAvailable,
        ),
      ),
    );
  }

  List<Widget> _screens(BuildContext context) {
    return [
      HomeScreen(
        onEvents: () => _openEvents(context),
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
        onMovementMastery: () => _openMovementMastery(context),
        onRootNavigate: _selectHeroRoot,
        battleRootEnabled: _battleAvailable,
      ),
      ProfileScreen(
        onProfileDetails: () => _openPlayerLevel(context),
        onHistory: () => _openProfileHistory(context),
        onAccountInfo: () => _openAccount(context),
        onNotifications: () => _openNotifications(context),
        onPrivacy: () => _openPrivacy(context),
        onSettings: () => _openSettingsHub(context),
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
