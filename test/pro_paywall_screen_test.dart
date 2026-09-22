import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:actirune/features/shop/pro_paywall_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    VoidCallback? onBack,
    VoidCallback? onClose,
    ValueChanged<ProPlan>? onPlanSelected,
    VoidCallback? onUpgradeRequested,
    VoidCallback? onContinueFree,
  }) {
    return MaterialApp(
      home: ProPaywallScreen(
        onBack: onBack,
        onClose: onClose,
        onPlanSelected: onPlanSelected,
        onUpgradeRequested: onUpgradeRequested,
        onContinueFree: onContinueFree,
      ),
    );
  }

  testWidgets('Pro paywall renders the canonical exact artwork shell', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, ProPaywallScreen.artworkAsset);
    expect(surface.sourceSize, ProPaywallScreen.artworkSize);
    expect(ProPaywallScreen.artworkSize, const Size(941, 1672));

    for (final id in [
      'pro-paywall.back',
      'pro-paywall.close',
      'pro-paywall.plan-monthly',
      'pro-paywall.plan-annual',
      'pro-paywall.upgrade',
      'pro-paywall.continue-free',
    ]) {
      expect(find.byKey(ValueKey('artwork-hotspot-$id')), findsOneWidget);
    }
  });

  testWidgets('back and close remain independent owner callbacks', (
    tester,
  ) async {
    var backCount = 0;
    var closeCount = 0;

    await tester.pumpWidget(
      buildSubject(onBack: () => backCount++, onClose: () => closeCount++),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-pro-paywall.back')),
    );
    await tester.pump();
    expect(backCount, 1);
    expect(closeCount, 0);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-pro-paywall.close')),
    );
    await tester.pump();
    expect(backCount, 1);
    expect(closeCount, 1);
  });

  testWidgets('monthly and annual plan taps dispatch without billing effects', (
    tester,
  ) async {
    final selected = <ProPlan>[];

    await tester.pumpWidget(buildSubject(onPlanSelected: selected.add));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-pro-paywall.plan-monthly')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-pro-paywall.plan-annual')),
    );
    await tester.pump();

    expect(selected, [ProPlan.monthly, ProPlan.annual]);
  });

  testWidgets('upgrade and continue-free dispatch only to their owners', (
    tester,
  ) async {
    var upgradeCount = 0;
    var freeCount = 0;

    await tester.pumpWidget(
      buildSubject(
        onUpgradeRequested: () => upgradeCount++,
        onContinueFree: () => freeCount++,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-pro-paywall.upgrade')),
    );
    await tester.pump();
    expect(upgradeCount, 1);
    expect(freeCount, 0);

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-pro-paywall.continue-free')),
    );
    await tester.pump();
    expect(upgradeCount, 1);
    expect(freeCount, 1);
  });
}
