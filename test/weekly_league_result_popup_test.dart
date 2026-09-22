import 'package:actirune/features/social/weekly_league_result_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Weekly League Result dispatches only owner actions', (
    tester,
  ) async {
    var closeCount = 0;
    var claimCount = 0;
    var leaderboardCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: WeeklyLeagueResultPopup(
          onClose: () => closeCount++,
          onClaimReward: () => claimCount++,
          onViewLeaderboard: () => leaderboardCount++,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-weekly-league-result.claim-reward'),
      ),
    );
    await tester.pump();
    expect(claimCount, 1);

    await tester.tap(
      find.byKey(
        const ValueKey('artwork-hotspot-weekly-league-result.view-leaderboard'),
      ),
    );
    await tester.pump();
    expect(leaderboardCount, 1);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-weekly-league-result.close')),
    );
    await tester.pump();
    expect(closeCount, 1);
  });
}
