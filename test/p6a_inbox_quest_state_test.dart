import 'package:actirune/app/actirune_app.dart';
import 'package:actirune/app/main_shell.dart';
import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/home/inbox_state.dart';
import 'package:actirune/features/home/quest_center_screen.dart';
import 'package:actirune/features/home/rune_inbox_screen.dart';
import 'package:actirune/features/onboarding/calibration_app_state.dart';
import 'package:actirune/features/quests/daily_quests_screen.dart';
import 'package:actirune/features/quests/local_quest_state.dart';
import 'package:actirune/features/quests/weekly_quests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> tap(WidgetTester tester, String id) async {
    await tester.tap(find.byKey(ValueKey('artwork-hotspot-$id')));
    await tester.pumpAndSettle();
  }

  test('local inbox filters IDs, not merely a tab outline', () {
    final owner = LocalInboxOwner();
    expect(owner.visible.map((m) => m.id).toSet(), {
      'sample-wolfrune',
      'sample-karalumi',
      'sample-arven',
      'sample-gold-league',
      'sample-rune-season',
    });
    owner.select(InboxCategory.social);
    expect(owner.visible.map((m) => m.id).toList(), [
      'sample-wolfrune',
      'sample-karalumi',
      'sample-arven',
    ]);
    owner.select(InboxCategory.system);
    expect(owner.visible.map((m) => m.id).toList(), [
      'sample-gold-league',
      'sample-rune-season',
    ]);
    owner.select(InboxCategory.all);
    expect(owner.visible.length, 5);
    owner.dispose();
  });

  testWidgets('inbox tabs display the filtered records and selected style', (
    tester,
  ) async {
    final owner = LocalInboxOwner();
    await tester.pumpWidget(
      MaterialApp(
        home: RuneInboxScreen(onBack: () {}, owner: owner),
      ),
    );
    await tester.pump();
    expect(owner.visible.length, 5);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-inbox-tab-social')),
    );
    await tester.pumpAndSettle();
    expect(owner.selected, InboxCategory.social);
    expect(
      owner.visible.every((record) => record.category == InboxCategory.social),
      isTrue,
    );
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-inbox-tab-system')),
    );
    await tester.pumpAndSettle();
    expect(owner.selected, InboxCategory.system);
    expect(
      owner.visible.every((record) => record.category == InboxCategory.system),
      isTrue,
    );
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-inbox-tab-all')),
    );
    await tester.pumpAndSettle();
    expect(owner.visible.length, 5);
    expect(find.byType(AlertDialog), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    owner.dispose();
  });

  test(
    'quest owner keeps daily/weekly IDs distinct and updates local status',
    () {
      final owner = LocalQuestOwner();
      final dailyIds = owner
          .recordsFor(QuestType.daily)
          .map((r) => r.id)
          .toSet();
      final weeklyIds = owner
          .recordsFor(QuestType.weekly)
          .map((r) => r.id)
          .toSet();
      expect(dailyIds.length, 5);
      expect(weeklyIds.length, 6);
      expect(dailyIds.intersection(weeklyIds), isEmpty);
      owner.setLocalProgress('sample-daily-explore', 1);
      expect(owner.byId('sample-daily-explore').status, QuestStatus.completed);
      expect(owner.byId('sample-daily-explore').progress, 1);
      expect(
        owner.recordsFor(QuestType.weekly).every((r) => r.progress == 0),
        isTrue,
      );
      owner.dispose();
    },
  );

  testWidgets(
    'Home quest hub reaches Daily and Weekly with exclusive record IDs',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainShell()));
      await tester.pumpAndSettle();
      await tap(tester, 'home.quests');
      expect(find.byType(QuestCenterScreen), findsOneWidget);
      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-quest-center.quest-1')),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('feature-unavailable-dialog')),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('feature-unavailable-close')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-quest-center-daily')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(DailyQuestsScreen), findsOneWidget);
      final daily = tester.widget<DailyQuestsScreen>(
        find.byType(DailyQuestsScreen),
      );
      expect(
        daily.questOwner!
            .recordsFor(QuestType.daily)
            .any((record) => record.id == 'sample-daily-explore'),
        isTrue,
      );
      Navigator.of(tester.element(find.byType(DailyQuestsScreen))).pop();
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-quest-center-weekly')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(WeeklyQuestsScreen), findsOneWidget);
      final weekly = tester.widget<WeeklyQuestsScreen>(
        find.byType(WeeklyQuestsScreen),
      );
      expect(
        weekly.questOwner!
            .recordsFor(QuestType.weekly)
            .any((record) => record.id == 'sample-weekly-1'),
        isTrue,
      );
    },
  );

  testWidgets('owned quest state updates while reward mutation stays gated', (
    tester,
  ) async {
    final owner = LocalQuestOwner();
    await tester.pumpWidget(
      MaterialApp(home: DailyQuestsScreen(questOwner: owner)),
    );
    await tester.pump();
    expect(owner.byId('sample-daily-explore').progress, 0);
    owner.setLocalProgress('sample-daily-explore', 1);
    await tester.pump();
    expect(owner.byId('sample-daily-explore').progress, 1);
    final claim = tester.widget<Semantics>(
      find.byKey(const ValueKey('artwork-hotspot-daily-quests.claim-explore')),
    );
    expect(claim.properties.enabled, isFalse);
    expect(owner.byId('sample-daily-explore').status, QuestStatus.completed);
    await tester.pumpWidget(const SizedBox.shrink());
    owner.dispose();
  });

  testWidgets('skipped calibration Home keeps approved art unobstructed', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ActiRuneApp(initialCalibrationState: CalibrationAppState.skipped()),
    );
    await tester.pumpAndSettle();
    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface).first,
    );
    expect(surface.overlays, isEmpty);
  });
}
