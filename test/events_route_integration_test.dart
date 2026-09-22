import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/home/events_screen.dart';
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

  testWidgets('Events filters and cards dispatch independently', (tester) async {
    EventsFilter? selectedFilter;
    int? selectedEvent;
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

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-events.event-2')),
    );
    await tester.pump();
    expect(selectedEvent, 2);
  });
}
