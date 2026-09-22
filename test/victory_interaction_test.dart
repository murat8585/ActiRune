import 'package:actirune/features/battle/victory_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onContinue,
    VoidCallback? onReplay,
    VoidCallback? onViewRewards,
  }) {
    return MaterialApp(
      home: VictoryScreen(
        onContinue: onContinue ?? () {},
        onReplay: onReplay ?? () {},
        onViewRewards: onViewRewards ?? () {},
      ),
    );
  }

  testWidgets('Victory exposes exactly the three final artwork CTAs', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(
      find.byKey(const ValueKey('artwork-hotspot-victory.continue')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-victory.replay')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-victory.view-rewards')),
      findsOneWidget,
    );

    expect(
      find.byKey(const ValueKey('artwork-hotspot-victory.stats')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-victory.reward-summary')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('artwork-hotspot-victory.adventure-progress')),
      findsNothing,
    );
  });

  testWidgets('Victory CTA callbacks fire once each', (tester) async {
    var continued = 0;
    var replayed = 0;
    var rewardsOpened = 0;

    await tester.pumpWidget(
      buildSubject(
        onContinue: () => continued++,
        onReplay: () => replayed++,
        onViewRewards: () => rewardsOpened++,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-victory.continue')),
    );
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-victory.replay')),
    );
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-victory.view-rewards')),
    );

    expect(continued, 1);
    expect(replayed, 1);
    expect(rewardsOpened, 1);
  });

  testWidgets('Victory does not add duplicate Flutter buttons or bottom nav', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.byType(ElevatedButton), findsNothing);
    expect(find.byType(FilledButton), findsNothing);
    expect(find.byType(OutlinedButton), findsNothing);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byType(BottomNavigationBar), findsNothing);
  });
}
