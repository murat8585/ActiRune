import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/adventure/adventure_screen.dart';
import 'package:actirune/features/home/daily_summary_popup.dart';
import 'package:actirune/features/home/home_screen.dart';
import 'package:actirune/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> openSummary(WidgetTester tester) async {
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.yesterday-summary')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(DailySummaryPopup), findsOneWidget);
  }

  testWidgets('Home opens Daily Summary and close returns to Home', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
    await openSummary(tester);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.nav-profile')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(find.byType(DailySummaryPopup), findsOneWidget);
    expect(find.byType(ProfileScreen), findsNothing);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-daily-summary.close')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DailySummaryPopup), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Continue Today closes Daily Summary and preserves Home', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
    await openSummary(tester);

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-daily-summary.continue-today'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DailySummaryPopup), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Adventure progress leaves the popup for canonical Adventure', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
    await openSummary(tester);

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-daily-summary.adventure-progress'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DailySummaryPopup), findsNothing);
    expect(find.byType(AdventureScreen), findsOneWidget);
  });

  testWidgets('Daily Summary visible actions dispatch independently', (
    tester,
  ) async {
    var closeCount = 0;
    var continueCount = 0;
    var adventureCount = 0;
    var detailsCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: DailySummaryPopup(
          onClose: () => closeCount++,
          onContinueToday: () => continueCount++,
          onAdventureProgress: () => adventureCount++,
          onViewDetails: () => detailsCount++,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-daily-summary.adventure-progress'),
      ),
    );
    await tester.pump();
    expect(adventureCount, 1);

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-daily-summary.continue-today'),
      ),
    );
    await tester.pump();
    expect(continueCount, 1);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-daily-summary.view-details')),
    );
    await tester.pump();
    expect(detailsCount, 1);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-daily-summary.close')),
    );
    await tester.pump();
    expect(closeCount, 1);
  });
}
