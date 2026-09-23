import 'rewarded_ad_policy.dart';

enum RewardedAdPlacement { runeShrine, pveDefeatRetry }

enum RewardedAdGatewayOutcome { completed, cancelled, failed, unavailable }

/// Provider-neutral rewarded-ad boundary.
///
/// An AdMob or other provider adapter may implement this later. The provider
/// never owns ActiRune eligibility or reward mutation rules.
abstract interface class RewardedAdGateway {
  Future<RewardedAdGatewayOutcome> show(RewardedAdPlacement placement);
}

/// Bridges an eligible product-policy decision to an external ad provider while
/// preserving [RewardedAdPolicy] as the final reward gate.
class RewardedAdDeliveryCoordinator {
  const RewardedAdDeliveryCoordinator({
    required this.policy,
    required this.gateway,
  });

  final RewardedAdPolicy policy;
  final RewardedAdGateway gateway;

  Future<bool> execute({
    required RewardedAdDecision decision,
    required RewardedAdPlacement placement,
  }) async {
    switch (decision.deliveryMode) {
      case RewardDeliveryMode.unavailable:
        return false;
      case RewardDeliveryMode.directProGrant:
        return policy.rewardMayApply(decision: decision);
      case RewardDeliveryMode.watchAd:
        final providerOutcome = await gateway.show(placement);
        final externalOutcome = switch (providerOutcome) {
          RewardedAdGatewayOutcome.completed => ExternalAdOutcome.completed,
          RewardedAdGatewayOutcome.cancelled => ExternalAdOutcome.cancelled,
          RewardedAdGatewayOutcome.failed => ExternalAdOutcome.failed,
          RewardedAdGatewayOutcome.unavailable => null,
        };
        return policy.rewardMayApply(
          decision: decision,
          externalAdOutcome: externalOutcome,
        );
    }
  }
}
