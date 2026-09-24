import 'provider_authority_lock.dart';

enum ProviderConfigurationVerificationMethod {
  providerConsoleReadback,
  storeConsoleReadback,
  runtimeSmokeTest,
  automatedApiReadback,
}

enum ProviderConfigurationIssue {
  androidApplicationIdMismatch,
  iosBundleIdentifierMismatch,
  backendProviderMismatch,
  billingProviderMismatch,
  rewardedAdsProviderMismatch,
  analyticsProviderMismatch,
  backendNotConfigured,
  billingNotConfigured,
  rewardedAdsNotConfigured,
  analyticsNotConfigured,
}

final class ProviderConfigurationEntry {
  const ProviderConfigurationEntry({
    required this.providerName,
    required this.publicReference,
    required this.configured,
    required this.verificationMethods,
  });

  factory ProviderConfigurationEntry.fromJson(
    Map<String, Object?> json, {
    required String fieldName,
  }) {
    const allowedKeys = <String>{
      'providerName',
      'publicReference',
      'configured',
      'verificationMethods',
    };
    final unknownKeys = json.keys.where((key) => !allowedKeys.contains(key));
    if (unknownKeys.isNotEmpty) {
      throw FormatException(
        '$fieldName contains unsupported field(s): ${unknownKeys.join(', ')}. '
        'Credentials, tokens and secrets must not be stored in release evidence.',
      );
    }

    final configured = json['configured'];
    if (configured is! bool) {
      throw FormatException('$fieldName.configured must be a boolean.');
    }

    final rawMethods = json['verificationMethods'];
    if (rawMethods is! List<Object?> || rawMethods.isEmpty) {
      throw FormatException(
        '$fieldName.verificationMethods must be a non-empty array.',
      );
    }

    final methods = <ProviderConfigurationVerificationMethod>{};
    for (final rawMethod in rawMethods) {
      if (rawMethod is! String) {
        throw FormatException(
          '$fieldName.verificationMethods entries must be strings.',
        );
      }
      methods.add(
        _enumValue(
          ProviderConfigurationVerificationMethod.values,
          rawMethod,
          '$fieldName.verificationMethods',
        ),
      );
    }

    return ProviderConfigurationEntry(
      providerName: _requiredString(json, 'providerName', prefix: fieldName),
      publicReference: _requiredString(
        json,
        'publicReference',
        prefix: fieldName,
      ),
      configured: configured,
      verificationMethods: Set.unmodifiable(methods),
    );
  }

  final String providerName;
  final String publicReference;
  final bool configured;
  final Set<ProviderConfigurationVerificationMethod> verificationMethods;
}

final class ProviderConfigurationEvidence {
  const ProviderConfigurationEvidence({
    required this.androidApplicationId,
    required this.iosBundleIdentifier,
    required this.releaseBuild,
    required this.backend,
    required this.billing,
    required this.rewardedAds,
    required this.analytics,
  });

  factory ProviderConfigurationEvidence.fromJson(Map<String, Object?> json) {
    const allowedKeys = <String>{
      'schemaVersion',
      'androidApplicationId',
      'iosBundleIdentifier',
      'releaseBuild',
      'backend',
      'billing',
      'rewardedAds',
      'analytics',
    };
    final unknownKeys = json.keys.where((key) => !allowedKeys.contains(key));
    if (unknownKeys.isNotEmpty) {
      throw FormatException(
        'Unsupported provider-configuration field(s): ${unknownKeys.join(', ')}. '
        'Credentials, tokens and secrets must not be stored in release evidence.',
      );
    }

    final schemaVersion = json['schemaVersion'];
    if (schemaVersion is! int || schemaVersion != 1) {
      throw const FormatException('schemaVersion must be integer 1.');
    }

    return ProviderConfigurationEvidence(
      androidApplicationId: _requiredString(json, 'androidApplicationId'),
      iosBundleIdentifier: _requiredString(json, 'iosBundleIdentifier'),
      releaseBuild: _requiredString(json, 'releaseBuild'),
      backend: ProviderConfigurationEntry.fromJson(
        _requiredObject(json, 'backend'),
        fieldName: 'backend',
      ),
      billing: ProviderConfigurationEntry.fromJson(
        _requiredObject(json, 'billing'),
        fieldName: 'billing',
      ),
      rewardedAds: ProviderConfigurationEntry.fromJson(
        _requiredObject(json, 'rewardedAds'),
        fieldName: 'rewardedAds',
      ),
      analytics: ProviderConfigurationEntry.fromJson(
        _requiredObject(json, 'analytics'),
        fieldName: 'analytics',
      ),
    );
  }

  final String androidApplicationId;
  final String iosBundleIdentifier;
  final String releaseBuild;
  final ProviderConfigurationEntry backend;
  final ProviderConfigurationEntry billing;
  final ProviderConfigurationEntry rewardedAds;
  final ProviderConfigurationEntry analytics;
}

final class ProviderConfigurationReport {
  const ProviderConfigurationReport({required this.issues});

  final List<ProviderConfigurationIssue> issues;

  bool get isValid => issues.isEmpty;
}

abstract final class ProviderConfigurationValidator {
  static ProviderConfigurationReport evaluate({
    required ProviderAuthorityLock authority,
    required ProviderConfigurationEvidence evidence,
  }) {
    final issues = <ProviderConfigurationIssue>[];

    if (evidence.androidApplicationId != authority.androidApplicationId) {
      issues.add(ProviderConfigurationIssue.androidApplicationIdMismatch);
    }
    if (evidence.iosBundleIdentifier != authority.iosBundleIdentifier) {
      issues.add(ProviderConfigurationIssue.iosBundleIdentifierMismatch);
    }

    _validateEntry(
      entry: evidence.backend,
      authorityProvider: authority.backendProvider,
      mismatch: ProviderConfigurationIssue.backendProviderMismatch,
      notConfigured: ProviderConfigurationIssue.backendNotConfigured,
      issues: issues,
    );
    _validateEntry(
      entry: evidence.billing,
      authorityProvider: authority.billingProvider,
      mismatch: ProviderConfigurationIssue.billingProviderMismatch,
      notConfigured: ProviderConfigurationIssue.billingNotConfigured,
      issues: issues,
    );
    _validateEntry(
      entry: evidence.rewardedAds,
      authorityProvider: authority.rewardedAdsProvider,
      mismatch: ProviderConfigurationIssue.rewardedAdsProviderMismatch,
      notConfigured: ProviderConfigurationIssue.rewardedAdsNotConfigured,
      issues: issues,
    );
    _validateEntry(
      entry: evidence.analytics,
      authorityProvider: authority.analyticsProvider,
      mismatch: ProviderConfigurationIssue.analyticsProviderMismatch,
      notConfigured: ProviderConfigurationIssue.analyticsNotConfigured,
      issues: issues,
    );

    return ProviderConfigurationReport(issues: List.unmodifiable(issues));
  }

  static void _validateEntry({
    required ProviderConfigurationEntry entry,
    required String authorityProvider,
    required ProviderConfigurationIssue mismatch,
    required ProviderConfigurationIssue notConfigured,
    required List<ProviderConfigurationIssue> issues,
  }) {
    if (_normalized(entry.providerName) != _normalized(authorityProvider)) {
      issues.add(mismatch);
    }
    if (!entry.configured) {
      issues.add(notConfigured);
    }
  }
}

Map<String, Object?> _requiredObject(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! Map<String, Object?>) {
    throw FormatException('$key must be a JSON object.');
  }
  return value;
}

String _requiredString(
  Map<String, Object?> json,
  String key, {
  String? prefix,
}) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    final name = prefix == null ? key : '$prefix.$key';
    throw FormatException('$name must be a non-empty string.');
  }
  return value.trim();
}

T _enumValue<T extends Enum>(List<T> values, String raw, String key) {
  for (final value in values) {
    if (value.name == raw) {
      return value;
    }
  }
  throw FormatException(
    '$key has unsupported value "$raw". Allowed: '
    '${values.map((value) => value.name).join(', ')}.',
  );
}

String _normalized(String value) => value.trim().toLowerCase();
