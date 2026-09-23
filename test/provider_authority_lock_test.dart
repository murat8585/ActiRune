import 'package:actirune/core/release/production_release_guard.dart';
import 'package:actirune/core/release/provider_authority_lock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('matching non-placeholder authority validates without credentials', () {
    final authority = ProviderAuthorityLock.fromJson(const {
      'schemaVersion': 1,
      'androidApplicationId': 'com.actirune.app',
      'iosBundleIdentifier': 'com.actirune.app',
      'backendProvider': 'Firebase',
      'billingProvider': 'RevenueCat',
      'rewardedAdsProvider': 'Google Mobile Ads',
      'analyticsProvider': 'Firebase Analytics',
    });

    final report = ProviderAuthorityValidator.evaluate(
      authority: authority,
      productionEvidence: const ProductionReleaseEvidence(
        androidApplicationId: 'com.actirune.app',
        androidReleaseSigningConfigured: true,
        androidUsesDebugSigning: false,
        iosBundleIdentifier: 'com.actirune.app',
        iosDevelopmentTeam: 'TEAM123456',
      ),
    );

    expect(report.isValid, isTrue);
    expect(report.issues, isEmpty);
  });

  test('placeholder production identities are rejected', () {
    final authority = ProviderAuthorityLock.fromJson(const {
      'schemaVersion': 1,
      'androidApplicationId': 'com.example.actirune',
      'iosBundleIdentifier': 'com.example.actirune',
      'backendProvider': 'Firebase',
      'billingProvider': 'RevenueCat',
      'rewardedAdsProvider': 'Google Mobile Ads',
      'analyticsProvider': 'Firebase Analytics',
    });

    final report = ProviderAuthorityValidator.evaluate(
      authority: authority,
      productionEvidence: const ProductionReleaseEvidence(
        androidApplicationId: 'com.example.actirune',
        androidReleaseSigningConfigured: true,
        androidUsesDebugSigning: true,
        iosBundleIdentifier: 'com.example.actirune',
        iosDevelopmentTeam: null,
      ),
    );

    expect(
      report.issues,
      containsAll(<ProviderAuthorityIssue>[
        ProviderAuthorityIssue.placeholderAndroidApplicationId,
        ProviderAuthorityIssue.placeholderIosBundleIdentifier,
      ]),
    );
  });

  test('authority ids must exactly match platform ids', () {
    final authority = ProviderAuthorityLock.fromJson(const {
      'schemaVersion': 1,
      'androidApplicationId': 'com.actirune.release',
      'iosBundleIdentifier': 'com.actirune.release',
      'backendProvider': 'Firebase',
      'billingProvider': 'RevenueCat',
      'rewardedAdsProvider': 'Google Mobile Ads',
      'analyticsProvider': 'Firebase Analytics',
    });

    final report = ProviderAuthorityValidator.evaluate(
      authority: authority,
      productionEvidence: const ProductionReleaseEvidence(
        androidApplicationId: 'com.actirune.dev',
        androidReleaseSigningConfigured: true,
        androidUsesDebugSigning: false,
        iosBundleIdentifier: 'com.actirune.dev',
        iosDevelopmentTeam: 'TEAM123456',
      ),
    );

    expect(
      report.issues,
      containsAll(<ProviderAuthorityIssue>[
        ProviderAuthorityIssue.androidApplicationIdMismatch,
        ProviderAuthorityIssue.iosBundleIdentifierMismatch,
      ]),
    );
  });

  test('unknown or secret-like fields fail closed', () {
    expect(
      () => ProviderAuthorityLock.fromJson(const {
        'schemaVersion': 1,
        'androidApplicationId': 'com.actirune.app',
        'iosBundleIdentifier': 'com.actirune.app',
        'backendProvider': 'Firebase',
        'billingProvider': 'RevenueCat',
        'rewardedAdsProvider': 'Google Mobile Ads',
        'analyticsProvider': 'Firebase Analytics',
        'apiKey': 'must-not-live-here',
      }),
      throwsA(isA<FormatException>()),
    );
  });

  test('non-authoritative placeholder provider names are rejected', () {
    expect(
      () => ProviderAuthorityLock.fromJson(const {
        'schemaVersion': 1,
        'androidApplicationId': 'com.actirune.app',
        'iosBundleIdentifier': 'com.actirune.app',
        'backendProvider': 'TBD',
        'billingProvider': 'RevenueCat',
        'rewardedAdsProvider': 'Google Mobile Ads',
        'analyticsProvider': 'Firebase Analytics',
      }),
      throwsA(isA<FormatException>()),
    );
  });

  test('missing required provider fields fail closed', () {
    expect(
      () => ProviderAuthorityLock.fromJson(const {
        'schemaVersion': 1,
        'androidApplicationId': 'com.actirune.app',
        'iosBundleIdentifier': 'com.actirune.app',
        'backendProvider': 'Firebase',
        'billingProvider': 'RevenueCat',
        'rewardedAdsProvider': 'Google Mobile Ads',
      }),
      throwsA(isA<FormatException>()),
    );
  });
}
