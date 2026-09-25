import 'package:actirune/app/main_shell.dart';
import 'package:actirune/core/widgets/feature_unavailable_dialog.dart';
import 'package:actirune/features/adventure/adventure_screen.dart';
import 'package:actirune/features/hero/equipment_screen.dart';
import 'package:actirune/features/hero/hero_screen.dart';
import 'package:actirune/features/hero/inventory_screen.dart';
import 'package:actirune/features/home/daily_summary_popup.dart';
import 'package:actirune/features/home/event_detail_popup.dart';
import 'package:actirune/features/home/events_screen.dart';
import 'package:actirune/features/home/home_screen.dart';
import 'package:actirune/features/home/rune_inbox_preview_screen.dart';
import 'package:actirune/features/home/rune_shrine_ready_screen.dart';
import 'package:actirune/features/profile/achievements_screen.dart';
import 'package:actirune/features/profile/profile_screen.dart';
import 'package:actirune/features/profile/settings_accessibility_screen.dart';
import 'package:actirune/features/profile/settings_account_screen.dart';
import 'package:actirune/features/profile/settings_hub_screen.dart';
import 'package:actirune/features/profile/settings_notifications_screen.dart';
import 'package:actirune/features/profile/settings_permissions_screen.dart';
import 'package:actirune/features/profile/settings_privacy_screen.dart';
import 'package:actirune/features/quests/quest_chain_screen.dart';
import 'package:actirune/features/shop/pro_paywall_screen.dart';
import 'package:actirune/features/shop/shop_screen.dart';
import 'package:actirune/features/social/social_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpShell(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
  }

  Future<void> closeUnavailable(WidgetTester tester) async {
    expect(find.byType(FeatureUnavailableDialog), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('feature-unavailable-close')));
    await tester.pumpAndSettle();
  }

  Finder rootScreen(Type type) => find.byType(type, skipOffstage: false);

  testWidgets('production root screens expose no silent primary callbacks', (
    tester,
  ) async {
    await pumpShell(tester);

    final home = tester.widget<HomeScreen>(rootScreen(HomeScreen));
    expect(home.onDailyStreak, isNotNull);
    expect(home.onMessages, isNotNull);
    expect(home.onQuests, isNotNull);
    expect(home.onEvents, isNotNull);
    expect(home.onSettings, isNotNull);
    expect(home.onWorldMap, isNotNull);
    expect(home.onYesterdaySummary, isNotNull);
    expect(home.onRewards, isNotNull);
    expect(home.onRootNavigate, isNotNull);
    expect(home.battleRootEnabled, isTrue);

    final adventure = tester.widget<AdventureScreen>(
      rootScreen(AdventureScreen),
    );
    expect(adventure.onDailyStreak, isNotNull);
    expect(adventure.onMessages, isNotNull);
    expect(adventure.onQuests, isNotNull);
    expect(adventure.onEvents, isNotNull);
    expect(adventure.onSettings, isNotNull);
    expect(adventure.onWorldMap, isNotNull);
    expect(adventure.onEncounterPreview, isNotNull);
    expect(adventure.onStory, isNotNull);
    expect(adventure.onAdventureLog, isNotNull);
    expect(adventure.onRootNavigate, isNotNull);
    expect(adventure.battleRootEnabled, isTrue);

    final hero = tester.widget<HeroScreen>(rootScreen(HeroScreen));
    expect(hero.onEquipment, isNotNull);
    expect(hero.onRunes, isNotNull);
    expect(hero.onAbilities, isNotNull);
    expect(hero.onCompanion, isNotNull);
    expect(hero.onCharacterStory, isNotNull);
    expect(hero.onCompanionDetails, isNotNull);
    expect(hero.onRuneDetails, isNotNull);
    expect(hero.onDetailedStats, isNotNull);
    expect(hero.onMovementMastery, isNotNull);
    expect(hero.onRootNavigate, isNotNull);
    expect(hero.battleRootEnabled, isTrue);

    final profile = tester.widget<ProfileScreen>(rootScreen(ProfileScreen));
    expect(profile.onBack, isNotNull);
    expect(profile.onProfileDetails, isNotNull);
    expect(profile.onEditProfile, isNotNull);
    expect(profile.onAvatar, isNotNull);
    expect(profile.onBadges, isNotNull);
    expect(profile.onMovementMastery, isNotNull);
    expect(profile.onWorldProgress, isNotNull);
    expect(profile.onFriends, isNotNull);
    expect(profile.onHistory, isNotNull);
    expect(profile.onAccountInfo, isNotNull);
    expect(profile.onNotifications, isNotNull);
    expect(profile.onPrivacy, isNotNull);
    expect(profile.onSettings, isNotNull);
    expect(profile.onRootNavigate, isNotNull);
    expect(profile.battleRootEnabled, isTrue);
  });

  testWidgets('locked battle and missing inbox answer taps instead of dying', (
    tester,
  ) async {
    await pumpShell(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.messages')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(RuneInboxPreviewScreen), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('rune-inbox-preview-back')));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.nav-battle')),
    );
    await tester.pumpAndSettle();
    await closeUnavailable(tester);
  });

  testWidgets('Hero story no longer misroutes to Quest Chain', (tester) async {
    await pumpShell(tester);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.nav-hero')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-hero.character-story')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(QuestChainScreen), findsNothing);
    await closeUnavailable(tester);
  });

  testWidgets('Hero equipment and inventory callbacks are fully owned', (
    tester,
  ) async {
    await pumpShell(tester);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.nav-hero')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-hero.equipment')),
    );
    await tester.pumpAndSettle();

    final equipment = tester.widget<EquipmentScreen>(
      find.byType(EquipmentScreen),
    );
    expect(equipment.onBack, isNotNull);
    expect(equipment.onInfo, isNotNull);
    expect(equipment.onSlot, isNotNull);
    expect(equipment.onSelectedItem, isNotNull);
    expect(equipment.onInventory, isNotNull);
    expect(equipment.onPresets, isNotNull);
    expect(equipment.onRootNavigate, isNotNull);
    expect(equipment.battleRootEnabled, isTrue);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-equipment.inventory')),
    );
    await tester.pumpAndSettle();

    final inventory = tester.widget<InventoryScreen>(
      find.byType(InventoryScreen),
    );
    expect(inventory.onBack, isNotNull);
    expect(inventory.onInfo, isNotNull);
    expect(inventory.onCategory, isNotNull);
    expect(inventory.onSearch, isNotNull);
    expect(inventory.onFilter, isNotNull);
    expect(inventory.onSort, isNotNull);
    expect(inventory.onViewMode, isNotNull);
    expect(inventory.onItem, isNotNull);
    expect(inventory.onBulkActions, isNotNull);
    expect(inventory.onRootNavigate, isNotNull);
    expect(inventory.battleRootEnabled, isTrue);
  });

  testWidgets(
    'Profile friends route to Social, badges route through Shop to Pro',
    (tester) async {
      await pumpShell(tester);
      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-home.nav-profile')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-profile.friends')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SocialScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-profile.badges')),
      );
      await tester.pumpAndSettle();
      final achievements = tester.widget<AchievementsScreen>(
        find.byType(AchievementsScreen),
      );
      expect(achievements.onCrystalStore, isNotNull);
      expect(achievements.onGoldStore, isNotNull);
      expect(achievements.onNotifications, isNotNull);
      expect(achievements.onShowInProfile, isNotNull);

      await tester.tap(
        find.byKey(
          const ValueKey('artwork-hotspot-achievements.crystal-store'),
        ),
      );
      await tester.pumpAndSettle();
      final shop = tester.widget<ShopScreen>(find.byType(ShopScreen));
      expect(shop.onNotifications, isNotNull);
      expect(shop.onSettings, isNotNull);
      expect(shop.onCategorySelected, isNotNull);
      expect(shop.onWeeklyCollection, isNotNull);
      expect(shop.onSeeAllFeatured, isNotNull);
      expect(shop.onProductSelected, isNotNull);
      expect(shop.onRuneThemes, isNotNull);
      expect(shop.onCrystalPacks, isNotNull);
      expect(shop.onPro, isNotNull);
      expect(shop.onRootNavigate, isNotNull);

      await tester.tap(find.byKey(const ValueKey('artwork-hotspot-shop.pro')));
      await tester.pumpAndSettle();
      final pro = tester.widget<ProPaywallScreen>(
        find.byType(ProPaywallScreen),
      );
      expect(pro.onBack, isNotNull);
      expect(pro.onClose, isNotNull);
      expect(pro.onPlanSelected, isNotNull);
      expect(pro.onUpgradeRequested, isNotNull);
      expect(pro.onContinueFree, isNotNull);
    },
  );

  testWidgets('Settings children are not created with dead callbacks', (
    tester,
  ) async {
    await pumpShell(tester);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.nav-profile')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-profile.settings')),
    );
    await tester.pumpAndSettle();

    final hub = tester.widget<SettingsHubScreen>(
      find.byType(SettingsHubScreen),
    );
    expect(hub.onBack, isNotNull);
    expect(hub.onSection, isNotNull);
    expect(hub.onRootNavigate, isNotNull);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-settings.section-account')),
    );
    await tester.pumpAndSettle();
    final account = tester.widget<SettingsAccountScreen>(
      find.byType(SettingsAccountScreen),
    );
    expect(account.onBack, isNotNull);
    expect(account.onEditProfile, isNotNull);
    expect(account.onCopyRuneId, isNotNull);
    expect(account.onLinkedAccount, isNotNull);
    expect(account.onViewData, isNotNull);
    expect(account.onSignOut, isNotNull);
    expect(account.onDeleteAccount, isNotNull);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-settings-account.back')),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-settings.section-notifications'),
      ),
    );
    await tester.pumpAndSettle();
    final notifications = tester.widget<SettingsNotificationsScreen>(
      find.byType(SettingsNotificationsScreen),
    );
    expect(notifications.onToggle, isNotNull);
    expect(notifications.onReminderHours, isNotNull);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-settings-notifications.back')),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-settings.section-privacy')),
    );
    await tester.pumpAndSettle();
    final privacy = tester.widget<SettingsPrivacyScreen>(
      find.byType(SettingsPrivacyScreen),
    );
    expect(privacy.onProfileVisibility, isNotNull);
    expect(privacy.onToggle, isNotNull);
    expect(privacy.onBlockedPlayers, isNotNull);
    expect(privacy.onDataPrivacy, isNotNull);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-settings-privacy.back')),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-settings.section-permissions'),
      ),
    );
    await tester.pumpAndSettle();
    final permissions = tester.widget<SettingsPermissionsScreen>(
      find.byType(SettingsPermissionsScreen),
    );
    expect(permissions.onManage, isNotNull);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-settings-permissions.back')),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-settings.section-accessibility'),
      ),
    );
    await tester.pumpAndSettle();
    final accessibility = tester.widget<SettingsAccessibilityScreen>(
      find.byType(SettingsAccessibilityScreen),
    );
    expect(accessibility.onTextSize, isNotNull);
    expect(accessibility.onToggle, isNotNull);
    expect(accessibility.onColorSupport, isNotNull);
  });

  testWidgets('Home auxiliary routes own every visible action', (tester) async {
    await pumpShell(tester);

    await tester.tap(find.byKey(const ValueKey('artwork-hotspot-home.events')));
    await tester.pumpAndSettle();
    final events = tester.widget<EventsScreen>(find.byType(EventsScreen));
    expect(events.onBack, isNotNull);
    expect(events.onInfo, isNull);
    expect(events.onFeaturedEvent, isNotNull);
    expect(events.onFilter, isNull);
    expect(events.onEvent, isNotNull);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-events.featured')),
    );
    await tester.pumpAndSettle();
    final eventDetail = tester.widget<EventDetailPopup>(
      find.byType(EventDetailPopup),
    );
    expect(eventDetail.onJoin, isNotNull);
    expect(eventDetail.onViewTasks, isNotNull);
    expect(eventDetail.onTask, isNotNull);
  });

  testWidgets('Daily summary and Rune Shrine no longer expose dead CTA', (
    tester,
  ) async {
    await pumpShell(tester);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.yesterday-summary')),
    );
    await tester.pumpAndSettle();
    final summary = tester.widget<DailySummaryPopup>(
      find.byType(DailySummaryPopup),
    );
    expect(summary.onViewDetails, isNotNull);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-daily-summary.close')),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.rewards')),
    );
    await tester.pumpAndSettle();
    final shrine = tester.widget<RuneShrineReadyScreen>(
      find.byType(RuneShrineReadyScreen),
    );
    expect(shrine.onClose, isNotNull);
    expect(shrine.onOpenGift, isNotNull);
    expect(shrine.onNotNow, isNotNull);
  });
}
