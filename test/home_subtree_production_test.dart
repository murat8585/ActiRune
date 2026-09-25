import 'package:actirune/app/main_shell.dart';
import 'package:actirune/core/widgets/feature_unavailable_dialog.dart';
import 'package:actirune/features/adventure/adventure_screen.dart';
import 'package:actirune/features/adventure/world_progression_screen.dart';
import 'package:actirune/features/hero/hero_screen.dart';
import 'package:actirune/features/home/daily_streak_preview_screen.dart';
import 'package:actirune/features/home/daily_summary_popup.dart';
import 'package:actirune/features/home/quest_center_preview_screen.dart';
import 'package:actirune/features/home/rune_inbox_preview_screen.dart';
import 'package:actirune/features/home/event_detail_popup.dart';
import 'package:actirune/features/home/events_screen.dart';
import 'package:actirune/features/home/home_preview_dialog.dart';
import 'package:actirune/features/home/rune_shrine_ready_screen.dart';
import 'package:actirune/features/profile/profile_screen.dart';
import 'package:actirune/features/profile/settings_accessibility_screen.dart';
import 'package:actirune/features/profile/settings_account_screen.dart';
import 'package:actirune/features/profile/settings_hub_screen.dart';
import 'package:actirune/features/profile/settings_notifications_screen.dart';
import 'package:actirune/features/profile/settings_permissions_screen.dart';
import 'package:actirune/features/profile/settings_privacy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Finder hotspot(String id) =>
      find.byKey(ValueKey<String>('artwork-hotspot-$id'));

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
  }

  Future<void> tapHotspot(WidgetTester tester, String id) async {
    final finder = hotspot(id);
    expect(finder, findsOneWidget, reason: 'Missing production hotspot: $id');
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> expectUnavailable(WidgetTester tester, String feature) async {
    expect(find.byType(FeatureUnavailableDialog), findsOneWidget);
    expect(
      find.byKey(const ValueKey('feature-unavailable-dialog')),
      findsOneWidget,
    );
    expect(find.text(feature), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('feature-unavailable-close')));
    await tester.pumpAndSettle();
  }

  Future<void> openSettingsSection(WidgetTester tester, String section) async {
    await pumpHome(tester);
    await tapHotspot(tester, 'home.settings');
    expect(find.byType(SettingsHubScreen), findsOneWidget);
    await tapHotspot(tester, 'settings.section-$section');
  }

  testWidgets('Home direct actions reach their production owner', (
    tester,
  ) async {
    await pumpHome(tester);
    await tapHotspot(tester, 'home.daily-streak');
    expect(find.byType(DailyStreakPreviewScreen), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('daily-streak-preview-back')));
    await tester.pumpAndSettle();

    await pumpHome(tester);
    await tapHotspot(tester, 'home.messages');
    expect(find.byType(RuneInboxPreviewScreen), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('rune-inbox-preview-back')));
    await tester.pumpAndSettle();

    await pumpHome(tester);
    await tapHotspot(tester, 'home.quests');
    expect(find.byType(QuestCenterPreviewScreen), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('quest-center-preview-back')));
    await tester.pumpAndSettle();

    await pumpHome(tester);
    await tapHotspot(tester, 'home.events');
    expect(find.byType(EventsScreen), findsOneWidget);

    await pumpHome(tester);
    await tapHotspot(tester, 'home.settings');
    expect(find.byType(SettingsHubScreen), findsOneWidget);

    await pumpHome(tester);
    await tapHotspot(tester, 'home.world-map');
    expect(find.byType(WorldProgressionScreen), findsOneWidget);

    await pumpHome(tester);
    await tapHotspot(tester, 'home.yesterday-summary');
    expect(find.byType(DailySummaryPopup), findsOneWidget);

    await pumpHome(tester);
    await tapHotspot(tester, 'home.rewards');
    expect(find.byType(RuneShrineReadyScreen), findsOneWidget);
  });

  testWidgets('Home bottom navigation is responsive and Battle fails closed', (
    tester,
  ) async {
    await pumpHome(tester);
    await tapHotspot(tester, 'home.nav-adventure');
    expect(find.byType(AdventureScreen), findsOneWidget);

    await pumpHome(tester);
    await tapHotspot(tester, 'home.nav-hero');
    expect(find.byType(HeroScreen), findsOneWidget);

    await pumpHome(tester);
    await tapHotspot(tester, 'home.nav-profile');
    expect(find.byType(ProfileScreen), findsOneWidget);

    await pumpHome(tester);
    await tapHotspot(tester, 'home.nav-battle');
    await expectUnavailable(tester, 'Savaş');
  });

  testWidgets(
    'Events list and detail actions have observable production outcomes',
    (tester) async {
      await pumpHome(tester);
      await tapHotspot(tester, 'home.events');

      await tapHotspot(tester, 'events.info');
      expect(find.byType(HomePreviewDialog), findsOneWidget);
      expect(find.byType(FeatureUnavailableDialog), findsNothing);
      await tester.tap(find.byKey(const ValueKey('home-preview-dialog-close')));
      await tester.pumpAndSettle();

      for (final filter in <String>['active', 'upcoming', 'completed']) {
        await tapHotspot(tester, 'events.filter-$filter');
        expect(
          find.byKey(
            ValueKey<String>('artwork-overlay-events.filter-selection-$filter'),
          ),
          findsOneWidget,
        );
        expect(find.byType(FeatureUnavailableDialog), findsNothing);
      }

      await tapHotspot(tester, 'events.featured');
      expect(find.byType(EventDetailPopup), findsOneWidget);

      for (final entry in <String, String>{
        'event-detail.task-verifiedBattles': 'Etkinlik Görevi',
        'event-detail.task-eventGoal': 'Etkinlik Görevi',
        'event-detail.join': 'Etkinliğe Katıl',
        'event-detail.view-tasks': 'Etkinlik Görevleri',
      }.entries) {
        await tapHotspot(tester, entry.key);
        await expectUnavailable(tester, entry.value);
        expect(find.byType(EventDetailPopup), findsOneWidget);
      }

      await tapHotspot(tester, 'event-detail.close');
      expect(find.byType(EventsScreen), findsOneWidget);

      for (final index in <int>[0, 1, 2]) {
        await tapHotspot(tester, 'events.event-$index');
        expect(find.byType(EventDetailPopup), findsOneWidget);
        await tapHotspot(tester, 'event-detail.close');
        expect(find.byType(EventsScreen), findsOneWidget);
      }
    },
  );

  testWidgets(
    'World Progression visible actions respond including locked boss',
    (tester) async {
      await pumpHome(tester);
      await tapHotspot(tester, 'home.world-map');
      expect(find.byType(WorldProgressionScreen), findsOneWidget);

      const previews = <String, String>{
        'world-progression.region-select': 'Bölge Seçimi',
        'world-progression.ancient-tree': 'Kadim Ağaç',
        'world-progression.lost-rune-cave': 'Kayıp Rün Mağarası',
        'world-progression.waterfall-temple': 'Şelale Tapınağı',
        'world-progression.wind-cliffs': 'Rüzgar Kayalıkları',
        'world-progression.show-next-target': 'Sonraki Hedef',
        'world-progression.boss-preview': 'Boss Ön İzleme',
        'world-progression.reward-preview': 'Ödül Ön İzleme',
      };
      for (final entry in previews.entries) {
        await tapHotspot(tester, entry.key);
        expect(find.byType(HomePreviewDialog), findsOneWidget);
        expect(find.text(entry.value), findsOneWidget);
        expect(find.byType(FeatureUnavailableDialog), findsNothing);
        expect(find.byType(WorldProgressionScreen), findsOneWidget);
        await tester.tap(
          find.byKey(const ValueKey('home-preview-dialog-close')),
        );
        await tester.pumpAndSettle();
      }

      await tapHotspot(tester, 'world-progression.notifications');
      expect(find.byType(SettingsNotificationsScreen), findsOneWidget);
    },
  );

  testWidgets('Daily Summary actions close, continue, route and fail closed', (
    tester,
  ) async {
    await pumpHome(tester);
    await tapHotspot(tester, 'home.yesterday-summary');
    await tapHotspot(tester, 'daily-summary.view-details');
    expect(find.byType(HomePreviewDialog), findsOneWidget);
    expect(find.byType(FeatureUnavailableDialog), findsNothing);
    await tester.tap(find.byKey(const ValueKey('home-preview-dialog-close')));
    await tester.pumpAndSettle();

    await pumpHome(tester);
    await tapHotspot(tester, 'home.yesterday-summary');
    await tapHotspot(tester, 'daily-summary.adventure-progress');
    expect(find.byType(AdventureScreen), findsOneWidget);

    await pumpHome(tester);
    await tapHotspot(tester, 'home.yesterday-summary');
    await tapHotspot(tester, 'daily-summary.continue-today');
    expect(find.byType(DailySummaryPopup), findsNothing);
  });

  testWidgets('Rune Shrine controls are responsive without fake rewards', (
    tester,
  ) async {
    await pumpHome(tester);
    await tapHotspot(tester, 'home.rewards');
    await tapHotspot(tester, 'rune-shrine-ready.open-gift');
    await expectUnavailable(tester, 'Rün Hediyesi');
    expect(find.byType(RuneShrineReadyScreen), findsOneWidget);

    await tapHotspot(tester, 'rune-shrine-ready.not-now');
    expect(find.byType(RuneShrineReadyScreen), findsNothing);
  });

  testWidgets('Settings Hub opens every canonical settings child', (
    tester,
  ) async {
    const sections = <String, Type>{
      'account': SettingsAccountScreen,
      'notifications': SettingsNotificationsScreen,
      'privacy': SettingsPrivacyScreen,
      'permissions': SettingsPermissionsScreen,
      'accessibility': SettingsAccessibilityScreen,
    };
    for (final entry in sections.entries) {
      await openSettingsSection(tester, entry.key);
      expect(find.byType(entry.value), findsOneWidget);
    }
  });

  testWidgets('Settings Account visible actions never fail silently', (
    tester,
  ) async {
    await openSettingsSection(tester, 'account');
    const outcomes = <String, String>{
      'settings-account.edit-profile': 'Profili Düzenle',
      'settings-account.copy-rune-id': 'Rune ID',
      'settings-account.link-apple': 'Bağlı Hesaplar',
      'settings-account.link-google': 'Bağlı Hesaplar',
      'settings-account.link-email': 'Bağlı Hesaplar',
      'settings-account.view-data': 'Verilerimi Gör',
      'settings-account.sign-out': 'Çıkış Yap',
      'settings-account.delete-account': 'Hesabı Sil',
    };
    for (final entry in outcomes.entries) {
      await tapHotspot(tester, entry.key);
      await expectUnavailable(tester, entry.value);
    }
  });

  testWidgets('Settings Notifications visible actions never fail silently', (
    tester,
  ) async {
    await openSettingsSection(tester, 'notifications');
    for (final toggle in <String>[
      'questReminders',
      'events',
      'social',
      'runeLeague',
      'system',
    ]) {
      await tapHotspot(tester, 'settings-notifications.toggle-$toggle');
      await expectUnavailable(tester, 'Bildirim Tercihi');
    }
    await tapHotspot(tester, 'settings-notifications.reminder-hours');
    await expectUnavailable(tester, 'Hatırlatma Saatleri');
  });

  testWidgets('Settings Privacy visible actions never fail silently', (
    tester,
  ) async {
    await openSettingsSection(tester, 'privacy');
    await tapHotspot(tester, 'settings-privacy.profile-visibility');
    await expectUnavailable(tester, 'Profil Görünürlüğü');

    for (final toggle in <String>[
      'onlineStatus',
      'challenges',
      'congratulations',
    ]) {
      await tapHotspot(tester, 'settings-privacy.toggle-$toggle');
      await expectUnavailable(tester, 'Gizlilik Tercihi');
    }

    await tapHotspot(tester, 'settings-privacy.blocked-players');
    await expectUnavailable(tester, 'Engellenen Oyuncular');
    await tapHotspot(tester, 'settings-privacy.data-privacy');
    await expectUnavailable(tester, 'Veri ve Gizlilik');
  });

  testWidgets('Settings Accessibility visible actions never fail silently', (
    tester,
  ) async {
    await openSettingsSection(tester, 'accessibility');
    await tapHotspot(tester, 'settings-accessibility.text-size');
    await expectUnavailable(tester, 'Metin Boyutu');

    for (final toggle in <String>[
      'highContrast',
      'reducedAnimation',
      'haptics',
      'audioCues',
    ]) {
      await tapHotspot(tester, 'settings-accessibility.toggle-$toggle');
      await expectUnavailable(tester, 'Erişilebilirlik Tercihi');
    }

    await tapHotspot(tester, 'settings-accessibility.color-support');
    await expectUnavailable(tester, 'Renk Ayrımı Desteği');
  });
}
