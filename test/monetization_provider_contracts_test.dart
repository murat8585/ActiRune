import 'package:actirune/features/monetization/pro_billing_gateway.dart';
import 'package:actirune/features/monetization/rewarded_ad_gateway.dart';
import 'package:actirune/features/monetization/rewarded_ad_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pro billing contract', () {
    test('only purchased plus active entitlement grants Pro', () {
      const activePurchase = ProPurchaseResult(
        outcome: ProPurchaseOutcome.purchased,
        entitlementState: ProEntitlementState.active,
      );
      const inactivePurchase = ProPurchaseResult(
        outcome: ProPurchaseOutcome.purchased,
        entitlementState: ProEntitlementState.inactive,
      );
      const cancelled = ProPurchaseResult(
        outcome: ProPurchaseOutcome.cancelled,
        entitlementState: ProEntitlementState.active,
      );
      const failed = ProPurchaseResult(
        outcome: ProPurchaseOutcome.failed,
        entitlementState: ProEntitlementState.active,
      );

      expect(activePurchase.grantsPro, isTrue);
      expect(inactivePurchase.grantsPro, isFalse);
      expect(cancelled.grantsPro, isFalse);
      expect(failed.grantsPro, isFalse);
    });

    test('offering keeps provider identity opaque and price display-only', () {
      const offering = ProOffering(
        period: ProBillingPeriod.annual,
        providerPackageId: 'provider-owned-package',
        localizedPrice: 'provider-formatted-price',
      );

      expect(offering.period, ProBillingPeriod.annual);
      expect(offering.providerPackageId, 'provider-owned-package');
      expect(offering.localizedPrice, 'provider-formatted-price');
    });
  });

  group('Rewarded ad delivery coordinator', () {
    test('completed external rewarded ad may apply reward', () async {
      final gateway = _FakeRewardedAdGateway(
        RewardedAdGatewayOutcome.completed,
      );
      final coordinator = RewardedAdDeliveryCoordinator(
        policy: const RewardedAdPolicy(),
        gateway: gateway,
      );

      final result = await coordinator.execute(
        decision: RewardedAdDecision.watchAd(),
        placement: RewardedAdPlacement.runeShrine,
      );

      expect(result, isTrue);
      expect(gateway.calls, [RewardedAdPlacement.runeShrine]);
    });

    for (final outcome in <RewardedAdGatewayOutcome>[
      RewardedAdGatewayOutcome.cancelled,
      RewardedAdGatewayOutcome.failed,
      RewardedAdGatewayOutcome.unavailable,
    ]) {
      test('$outcome cannot apply reward', () async {
        final gateway = _FakeRewardedAdGateway(outcome);
        final coordinator = RewardedAdDeliveryCoordinator(
          policy: const RewardedAdPolicy(),
          gateway: gateway,
        );

        final result = await coordinator.execute(
          decision: RewardedAdDecision.watchAd(),
          placement: RewardedAdPlacement.pveDefeatRetry,
        );

        expect(result, isFalse);
        expect(gateway.calls, [RewardedAdPlacement.pveDefeatRetry]);
      });
    }

    test('Pro direct grant does not invoke external ad provider', () async {
      final gateway = _FakeRewardedAdGateway(
        RewardedAdGatewayOutcome.completed,
      );
      final coordinator = RewardedAdDeliveryCoordinator(
        policy: const RewardedAdPolicy(),
        gateway: gateway,
      );

      final result = await coordinator.execute(
        decision: RewardedAdDecision.directProGrant(),
        placement: RewardedAdPlacement.runeShrine,
      );

      expect(result, isTrue);
      expect(gateway.calls, isEmpty);
    });

    test('blocked policy decision does not invoke external ad provider', () async {
      final gateway = _FakeRewardedAdGateway(
        RewardedAdGatewayOutcome.completed,
      );
      final coordinator = RewardedAdDeliveryCoordinator(
        policy: const RewardedAdPolicy(),
        gateway: gateway,
      );

      final result = await coordinator.execute(
        decision: RewardedAdDecision.unavailable(
          RewardedAdBlockReason.dailyLimit,
        ),
        placement: RewardedAdPlacement.runeShrine,
      );

      expect(result, isFalse);
      expect(gateway.calls, isEmpty);
    });
  });
}

class _FakeRewardedAdGateway implements RewardedAdGateway {
  _FakeRewardedAdGateway(this.outcome);

  final RewardedAdGatewayOutcome outcome;
  final List<RewardedAdPlacement> calls = [];

  @override
  Future<RewardedAdGatewayOutcome> show(RewardedAdPlacement placement) async {
    calls.add(placement);
    return outcome;
  }
}
