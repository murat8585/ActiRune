import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/home/event_detail_popup.dart';
import 'package:actirune/features/home/events_screen.dart';
import 'package:actirune/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> openEvents(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('artwork-hotspot-home.events')));
    await tester.pumpAndSettle();
    expect(find.byType(EventsScreen), findsOneWidget);
  }

  testWidgets('Featured event opens modal and close returns to Events', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
    await openEvents(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-events.featured')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EventDetailPopup), findsOneWidget);
    expect(
      tester.widget<EventDetailPopup>(find.byType(EventDetailPopup)).event.id,
      'rune-storm',
    );

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-events.nav-profile')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(find.byType(EventDetailPopup), findsOneWidget);
    expect(find.byType(ProfileScreen), findsNothing);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-event-detail.close')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EventDetailPopup), findsNothing);
    expect(find.byType(EventsScreen), findsOneWidget);
  });

  testWidgets('Event card also opens the Event Detail modal', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
    await openEvents(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-events.event-1')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EventDetailPopup), findsOneWidget);
    expect(
      tester.widget<EventDetailPopup>(find.byType(EventDetailPopup)).event.id,
      'movement-master-week',
    );
    expect(
      find.descendant(
        of: find.byType(EventDetailPopup),
        matching: find.text('Hareket Ustası Haftası'),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'Kadim Vadi retains its own detail identity and join is blocked',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainShell()));
      await tester.pumpAndSettle();
      await openEvents(tester);
      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-events.event-2')),
      );
      await tester.pumpAndSettle();

      final detail = tester.widget<EventDetailPopup>(
        find.byType(EventDetailPopup),
      );
      expect(detail.event.id, 'ancient-valley-challenge');
      expect(
        find.descendant(
          of: find.byType(EventDetailPopup),
          matching: find.text('Kadim Vadi Mücadelesi'),
        ),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-event-detail.join')),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('katılım kaydedilmedi'), findsOneWidget);
    },
  );

  testWidgets('Event Detail action hotspots dispatch independently', (
    tester,
  ) async {
    var closeCount = 0;
    var joinCount = 0;
    var viewTasksCount = 0;
    EventDetailTask? selectedTask;

    await tester.pumpWidget(
      MaterialApp(
        home: EventDetailPopup(
          onClose: () => closeCount++,
          onJoin: () => joinCount++,
          onViewTasks: () => viewTasksCount++,
          onTask: (value) => selectedTask = value,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-event-detail.join')),
    );
    await tester.pump();
    expect(joinCount, 1);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-event-detail.view-tasks')),
    );
    await tester.pump();
    expect(viewTasksCount, 1);

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-event-detail.task-verifiedBattles'),
      ),
    );
    await tester.pump();
    expect(selectedTask, EventDetailTask.verifiedBattles);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-event-detail.task-eventGoal')),
    );
    await tester.pump();
    expect(selectedTask, EventDetailTask.eventGoal);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-event-detail.close')),
    );
    await tester.pump();
    expect(closeCount, 1);
  });
}
