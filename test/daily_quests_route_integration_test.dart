import 'package:actirune/app/main_shell.dart';
import 'package:actirune/core/widgets/feature_unavailable_dialog.dart';
import 'package:actirune/features/home/home_screen.dart';
import 'package:actirune/features/quests/daily_quests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Home Daily Streak stays truthful until the real streak owner exists',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainShell()));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('artwork-hotspot-home.daily-streak')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FeatureUnavailableDialog), findsOneWidget);
      expect(find.text('Günlük Seri'), findsOneWidget);
      expect(find.byType(DailyQuestsScreen), findsNothing);
      expect(
        find.text(
          '7 günlük esnek seri sistemi canlı aktivite verisine bağlandığında bu alan açılacak.',
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const ValueKey('feature-unavailable-close')));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    },
  );
}
