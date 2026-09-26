import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/profile/profile_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('production history route filters empty owned records', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-home.nav-profile')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-profile.history')),
    );
    await tester.pumpAndSettle();

    final screen = tester.widget<ProfileHistoryScreen>(
      find.byType(ProfileHistoryScreen),
    );
    expect(screen.historyOwner, isNotNull);
    expect(screen.historyOwner!.visibleRecords, isEmpty);
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-history.tab-battles')),
    );
    await tester.pumpAndSettle();
    expect(screen.historyOwner!.selectedTab, HistoryTab.battles);
    expect(screen.historyOwner!.visibleRecords, isEmpty);
  });
}
