import 'package:actirune/app/main_shell.dart';
import 'package:actirune/core/widgets/feature_unavailable_dialog.dart';
import 'package:actirune/features/home/events_screen.dart';
import 'package:actirune/features/home/home_preview_dialog.dart';
import 'package:actirune/features/home/home_screen.dart';
import 'package:actirune/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home opens Events and back returns to Home', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('artwork-hotspot-home.events')));
    await tester.pumpAndSettle();
    expect(find.byType(EventsScreen), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('artwork-hotspot-events.back')));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(EventsScreen), findsNothing);
  });

  testWidgets('Events root navigation closes the child route', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('artwork-hotspot-home.events')));
    await tester.pumpAndSettle();
    expect(find.byType(EventsScreen), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-events.nav-profile')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.byType(EventsScreen), findsNothing);
  });

  testWidgets('Events filters and cards dispatch independently', (
    tester,
  ) async {
    EventsFilter? selectedFilter;
    String? selectedEvent;
    var featuredCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: EventsScreen(
          onFeaturedEvent: () => featuredCount++,
          onFilter: (value) => selectedFilter = value,
          onEvent: (value) => selectedEvent = value,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-events.featured')),
    );
    await tester.pump();
    expect(featuredCount, 1);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-events.filter-upcoming')),
    );
    await tester.pump();
    expect(selectedFilter, EventsFilter.upcoming);
    expect(
      find.byKey(
        const ValueKey('artwork-overlay-events.filter-selection-upcoming'),
      ),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('event-record-rune-storm')), findsNothing);
    expect(
      find.text('Bu filtrede doğrulanmış etkinlik kaydı yok'),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-events.event-2')),
      warnIfMissed: false,
    );
    await tester.pump();
    expect(selectedEvent, isNull);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-events.filter-active')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-events.event-2')),
    );
    await tester.pump();
    expect(selectedEvent, 'ancient-valley-challenge');
  });

  testWidgets('Home Events info and filters use local preview behavior', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('artwork-hotspot-home.events')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('artwork-hotspot-events.info')));
    await tester.pumpAndSettle();
    expect(find.byType(HomePreviewDialog), findsOneWidget);
    expect(find.byType(FeatureUnavailableDialog), findsNothing);

    await tester.tap(find.byKey(const ValueKey('home-preview-dialog-close')));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-events.filter-completed')),
    );
    await tester.pump();
    expect(
      find.byKey(
        const ValueKey('artwork-overlay-events.filter-selection-completed'),
      ),
      findsOneWidget,
    );
    expect(find.byType(FeatureUnavailableDialog), findsNothing);
  });
}
