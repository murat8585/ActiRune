import 'package:flutter/foundation.dart';

enum ProductionIdentityIssue {
  missingAndroidNamespace,
  placeholderAndroidNamespace,
  androidNamespaceApplicationIdMismatch,
  missingAndroidMainActivityPackage,
  androidMainActivityPackageMismatch,
  missingIosRunnerTestBundleIdentifier,
  iosRunnerTestBundleIdentifierMismatch,
}

@immutable
final class ProductionIdentityEvidence {
  const ProductionIdentityEvidence({
    required this.androidNamespace,
    required this.androidApplicationId,
    required this.androidMainActivityPackage,
    required this.iosBundleIdentifier,
    required this.iosRunnerTestBundleIdentifier,
  });

  factory ProductionIdentityEvidence.fromPlatformFiles({
    required String androidGradle,
    required String androidMainActivity,
    required String iosProject,
  }) {
    final namespace = RegExp(r'namespace\s*=\s*"([^"]+)"')
        .firstMatch(androidGradle)
        ?.group(1);
    final applicationId = RegExp(r'applicationId\s*=\s*"([^"]+)"')
        .firstMatch(androidGradle)
        ?.group(1);
    final mainActivityPackage = RegExp(
      r'^\s*package\s+([^\s;]+)',
      multiLine: true,
    ).firstMatch(androidMainActivity)?.group(1);

    String? iosBundleIdentifier;
    String? iosRunnerTestBundleIdentifier;
    for (final match in RegExp(
      r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*([^;]+);',
    ).allMatches(iosProject)) {
      final candidate = _cleanBuildSetting(match.group(1));
      if (candidate == null) {
        continue;
      }
      if (candidate.endsWith('.RunnerTests')) {
        iosRunnerTestBundleIdentifier ??= candidate;
      } else {
        iosBundleIdentifier ??= candidate;
      }
    }

    return ProductionIdentityEvidence(
      androidNamespace: _cleanBuildSetting(namespace),
      androidApplicationId: _cleanBuildSetting(applicationId),
      androidMainActivityPackage: _cleanBuildSetting(mainActivityPackage),
      iosBundleIdentifier: iosBundleIdentifier,
      iosRunnerTestBundleIdentifier: iosRunnerTestBundleIdentifier,
    );
  }

  final String? androidNamespace;
  final String? androidApplicationId;
  final String? androidMainActivityPackage;
  final String? iosBundleIdentifier;
  final String? iosRunnerTestBundleIdentifier;
}

@immutable
final class ProductionIdentityReport {
  const ProductionIdentityReport({required this.issues});

  final List<ProductionIdentityIssue> issues;

  bool get isConsistent => issues.isEmpty;
}

abstract final class ProductionIdentityGuard {
  static ProductionIdentityReport evaluate(
    ProductionIdentityEvidence evidence,
  ) {
    final issues = <ProductionIdentityIssue>[];

    if (_isMissing(evidence.androidNamespace)) {
      issues.add(ProductionIdentityIssue.missingAndroidNamespace);
    } else if (_isPlaceholderIdentifier(evidence.androidNamespace!)) {
      issues.add(ProductionIdentityIssue.placeholderAndroidNamespace);
    }

    if (!_isMissing(evidence.androidNamespace) &&
        !_isMissing(evidence.androidApplicationId) &&
        evidence.androidNamespace != evidence.androidApplicationId) {
      issues.add(ProductionIdentityIssue.androidNamespaceApplicationIdMismatch);
    }

    if (_isMissing(evidence.androidMainActivityPackage)) {
      issues.add(ProductionIdentityIssue.missingAndroidMainActivityPackage);
    } else if (!_isMissing(evidence.androidNamespace) &&
        evidence.androidMainActivityPackage != evidence.androidNamespace) {
      issues.add(ProductionIdentityIssue.androidMainActivityPackageMismatch);
    }

    if (_isMissing(evidence.iosRunnerTestBundleIdentifier)) {
      issues.add(ProductionIdentityIssue.missingIosRunnerTestBundleIdentifier);
    } else if (!_isMissing(evidence.iosBundleIdentifier) &&
        evidence.iosRunnerTestBundleIdentifier !=
            '${evidence.iosBundleIdentifier}.RunnerTests') {
      issues.add(ProductionIdentityIssue.iosRunnerTestBundleIdentifierMismatch);
    }

    return ProductionIdentityReport(issues: List.unmodifiable(issues));
  }
}

bool _isMissing(String? value) => value == null || value.trim().isEmpty;

bool _isPlaceholderIdentifier(String value) {
  final normalized = value.trim().toLowerCase();
  return normalized == 'com.example' || normalized.startsWith('com.example.');
}

String? _cleanBuildSetting(String? value) {
  if (value == null) {
    return null;
  }
  final cleaned = value.trim().replaceAll('"', '');
  return cleaned.isEmpty ? null : cleaned;
}
