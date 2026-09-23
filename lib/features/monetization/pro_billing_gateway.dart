import 'package:flutter/foundation.dart';

enum ProBillingPeriod { monthly, annual }

enum ProEntitlementState { unknown, inactive, active }

enum ProPurchaseOutcome { purchased, cancelled, failed }

@immutable
final class ProOffering {
  const ProOffering({
    required this.period,
    required this.providerPackageId,
    required this.localizedPrice,
  });

  final ProBillingPeriod period;

  /// Opaque provider/store package id. Gameplay and UI must not derive product
  /// behavior from this value.
  final String providerPackageId;

  /// Provider-formatted display value only. ActiRune does not calculate or
  /// hard-code store pricing in the client domain layer.
  final String localizedPrice;
}

@immutable
final class ProPurchaseResult {
  const ProPurchaseResult({
    required this.outcome,
    required this.entitlementState,
  });

  final ProPurchaseOutcome outcome;
  final ProEntitlementState entitlementState;

  bool get grantsPro =>
      outcome == ProPurchaseOutcome.purchased &&
      entitlementState == ProEntitlementState.active;
}

/// Provider-neutral subscription/entitlement boundary.
///
/// A RevenueCat, StoreKit or Google Play implementation may sit behind this
/// interface later. The UI must not fabricate purchase success, price, trial
/// state or entitlement state when no provider implementation exists.
abstract interface class ProBillingGateway {
  Future<List<ProOffering>> loadOfferings();

  Future<ProEntitlementState> currentEntitlement();

  Future<ProPurchaseResult> purchase(ProOffering offering);

  Future<ProEntitlementState> restorePurchases();
}
