import 'package:flutter/foundation.dart';

import 'production_release_guard.dart';

enum ProviderAuthorityIssue {
  placeholderAndroidApplicationId,
  placeholderIosBundleIdentifier,
  androidApplicationIdMismatch,
  iosBundleIdentifierMismatch,
}

@immutable
final class ProviderAuthorityLock {
  const ProviderAuthorityLock({
    required this.androidApplicationId,
    required this.iosBundleIdentifier,
    required this.backendProvider,
    required this.billingProvider,
    required this.rewardedAdsProvider,
    required this.analyticsProvider,
  });

  factory ProviderAuthorityLock.fromJson(Map<String, Object?> json) {
    const allowedKeys = <String>{
      'schemaVersion',
      'androidApplicationId',
      'iosBundleIdentifier',
      'backendProvider',
      'billingProvider',
      'rewardedAdsProvider',
      'analyticsProvider',
    };

    final unknownKeys = json.keys.where((key) => !allowedKeys.contains(key));
    if (unknownKeys.isNotEmpty) {
      throw FormatException(
        'Unsupported provider-authority field(s): ${unknownKeys.join(', ')}. '
        'Credentials, tokens and secrets must never be stored in this lock.',
      );
    }

    final schemaVersion = json['schemaVersion'];
    if (schemaVersion is! int || schemaVersion != 1) {
      throw const FormatException('schemaVersion must be integer 1.');
    }

    return ProviderAuthorityLock(
      androidApplicationId: _requiredString(json, 'androidApplicationId'),
      iosBundleIdentifier: _requiredString(json, 'iosBundleIdentifier'),
      backendProvider: _requiredProviderName(json, 'backendProvider'),
      billingProvider: _requiredProviderName(json, 'billingProvider'),
      rewardedAdsProvider: _requiredProviderName(json, 'rewardedAdsProvider'),
      analyticsProvider: _requiredProviderName(json, 'analyticsProvider'),
    );
  }

  final String androidApplicationId;
  final String iosBundleIdentifier;
  final String backendProvider;
  final String billingProvider;
  final String rewardedAdsProvider;
  final String analyticsProvider;
}

@immutable
final class ProviderAuthorityReport {
  const ProviderAuthorityReport({required this.issues});

  final List<ProviderAuthorityIssue> issues;

  bool get isValid => issues.isEmpty;
}

abstract final class ProviderAuthorityValidator {
  static ProviderAuthorityReport evaluate({
    required ProviderAuthorityLock authority,
    required ProductionReleaseEvidence productionEvidence,
  }) {
    final issues = <ProviderAuthorityIssue>[];

    if (_isPlaceholderIdentifier(authority.androidApplicationId)) {
      issues.add(ProviderAuthorityIssue.placeholderAndroidApplicationId);
    }
    if (_isPlaceholderIdentifier(authority.iosBundleIdentifier)) {
      issues.add(ProviderAuthorityIssue.placeholderIosBundleIdentifier);
    }

    if (productionEvidence.androidApplicationId !=
        authority.androidApplicationId) {
      issues.add(ProviderAuthorityIssue.androidApplicationIdMismatch);
    }
    if (productionEvidence.iosBundleIdentifier != authority.iosBundleIdentifier) {
      issues.add(ProviderAuthorityIssue.iosBundleIdentifierMismatch);
    }

    return ProviderAuthorityReport(issues: List.unmodifiable(issues));
  }
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('$key must be a non-empty string.');
  }
  return value.trim();
}

String _requiredProviderName(Map<String, Object?> json, String key) {
  final value = _requiredString(json, key);
  final normalized = value.toLowerCase();
  if (normalized.contains('replace') ||
      normalized.contains('todo') ||
      normalized.contains('placeholder') ||
      normalized == 'tbd') {
    throw FormatException('$key must be an authoritative provider name.');
  }
  return value;
}

bool _isPlaceholderIdentifier(String value) {
  final normalized = value.trim().toLowerCase();
  return normalized == 'com.example' || normalized.startsWith('com.example.');
}
