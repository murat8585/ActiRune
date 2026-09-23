import 'package:actirune/core/release/provider_authority_lock.dart';
import 'package:actirune/core/release/provider_configuration_evidence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('matching configured provider evidence is valid', () {
    final report = ProviderConfigurationValidator.evaluate(
      authority: _authority,
      evidence: _evidence(),
    );

    expect(report.isValid, isTrue);
    expect(report.issues, isEmpty);
  });

  test('provider names and production ids must match authority lock', () {
    final report = ProviderConfigurationValidator.evaluate(
      authority: _authority,
      evidence: _evidence(
        androidApplicationId: 'com.actirune.wrong',
        iosBundleIdentifier: 'com.actirune.wrong',
        backendProvider: 'Other Backend',
      ),
    );

    expect(report.isValid, isFalse);
    expect(
      report.issues,
      containsAll(<ProviderConfigurationIssue>[
        ProviderConfigurationIssue.androidApplicationIdMismatch,
        ProviderConfigurationIssue.iosBundleIdentifierMismatch,
        ProviderConfigurationIssue.backendProviderMismatch,
      ]),
    );
  });

  test('any unconfigured required provider keeps evidence blocked', () {
    final report = ProviderConfigurationValidator.evaluate(
      authority: _authority,
      evidence: _evidence(billingConfigured: false),
    );

    expect(report.isValid, isFalse);
    expect(
      report.issues,
      contains(ProviderConfigurationIssue.billingNotConfigured),
    );
  });

  test('JSON parser rejects credential-like extra fields', () {
    final json = _json();
    final backend = Map<String, Object?>.from(
      json['backend']! as Map<String, Object?>,
    );
    backend['apiKey'] = 'must-not-be-committed';
    json['backend'] = backend;

    expect(
      () => ProviderConfigurationEvidence.fromJson(json),
      throwsA(isA<FormatException>()),
    );
  });

  test('JSON parser requires non-empty verification methods', () {
    final json = _json();
    final analytics = Map<String, Object?>.from(
      json['analytics']! as Map<String, Object?>,
    );
    analytics['verificationMethods'] = <Object?>[];
    json['analytics'] = analytics;

    expect(
      () => ProviderConfigurationEvidence.fromJson(json),
      throwsA(isA<FormatException>()),
    );
  });

  test('JSON parser accepts auditable non-secret configuration evidence', () {
    final evidence = ProviderConfigurationEvidence.fromJson(_json());

    expect(evidence.androidApplicationId, 'com.actirune.app');
    expect(evidence.billing.configured, isTrue);
    expect(
      evidence.rewardedAds.verificationMethods,
      contains(ProviderConfigurationVerificationMethod.runtimeSmokeTest),
    );
  });
}

const _authority = ProviderAuthorityLock(
  androidApplicationId: 'com.actirune.app',
  iosBundleIdentifier: 'com.actirune.app',
  backendProvider: 'Firebase',
  billingProvider: 'RevenueCat',
  rewardedAdsProvider: 'Google Mobile Ads',
  analyticsProvider: 'Firebase Analytics',
);

ProviderConfigurationEvidence _evidence({
  String androidApplicationId = 'com.actirune.app',
  String iosBundleIdentifier = 'com.actirune.app',
  String backendProvider = 'Firebase',
  bool billingConfigured = true,
}) {
  const methods = <ProviderConfigurationVerificationMethod>{
    ProviderConfigurationVerificationMethod.providerConsoleReadback,
    ProviderConfigurationVerificationMethod.runtimeSmokeTest,
  };

  return ProviderConfigurationEvidence(
    androidApplicationId: androidApplicationId,
    iosBundleIdentifier: iosBundleIdentifier,
    releaseBuild: '1.0.0+100',
    backend: ProviderConfigurationEntry(
      providerName: backendProvider,
      publicReference: 'backend-project-public-id',
      configured: true,
      verificationMethods: methods,
    ),
    billing: ProviderConfigurationEntry(
      providerName: 'RevenueCat',
      publicReference: 'billing-project-public-id',
      configured: billingConfigured,
      verificationMethods: methods,
    ),
    rewardedAds: const ProviderConfigurationEntry(
      providerName: 'Google Mobile Ads',
      publicReference: 'ads-app-public-id',
      configured: true,
      verificationMethods: methods,
    ),
    analytics: const ProviderConfigurationEntry(
      providerName: 'Firebase Analytics',
      publicReference: 'analytics-project-public-id',
      configured: true,
      verificationMethods: methods,
    ),
  );
}

Map<String, Object?> _json() {
  Map<String, Object?> entry(String provider, String reference) =>
      <String, Object?>{
        'providerName': provider,
        'publicReference': reference,
        'configured': true,
        'verificationMethods': <String>[
          ProviderConfigurationVerificationMethod.providerConsoleReadback.name,
          ProviderConfigurationVerificationMethod.runtimeSmokeTest.name,
        ],
      };

  return <String, Object?>{
    'schemaVersion': 1,
    'androidApplicationId': 'com.actirune.app',
    'iosBundleIdentifier': 'com.actirune.app',
    'releaseBuild': '1.0.0+100',
    'backend': entry('Firebase', 'backend-project-public-id'),
    'billing': entry('RevenueCat', 'billing-project-public-id'),
    'rewardedAds': entry('Google Mobile Ads', 'ads-app-public-id'),
    'analytics': entry('Firebase Analytics', 'analytics-project-public-id'),
  };
}
