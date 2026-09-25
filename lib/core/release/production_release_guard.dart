enum ProductionReleaseIssue {
  missingAndroidApplicationId,
  placeholderAndroidApplicationId,
  missingAndroidReleaseSigning,
  androidDebugSigning,
  missingIosBundleIdentifier,
  placeholderIosBundleIdentifier,
  missingIosDevelopmentTeam,
}

final class ProductionReleaseEvidence {
  const ProductionReleaseEvidence({
    required this.androidApplicationId,
    required this.androidReleaseSigningConfigured,
    required this.androidUsesDebugSigning,
    required this.iosBundleIdentifier,
    required this.iosDevelopmentTeam,
  });

  factory ProductionReleaseEvidence.fromPlatformFiles({
    required String androidGradle,
    required String iosProject,
  }) {
    final applicationId = RegExp(r'applicationId\s*=\s*"([^"]+)"')
        .firstMatch(androidGradle)
        ?.group(1);

    final signingMatch = RegExp(
      r'^\s*signingConfig\s*=\s*(.+)$',
      multiLine: true,
    ).firstMatch(androidGradle);
    final signingExpression = signingMatch?.group(1) ?? '';

    String? iosBundleIdentifier;
    for (final match in RegExp(
      r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*([^;]+);',
    ).allMatches(iosProject)) {
      final candidate = _cleanBuildSetting(match.group(1));
      if (candidate != null && !candidate.contains('RunnerTests')) {
        iosBundleIdentifier = candidate;
        break;
      }
    }

    String? iosDevelopmentTeam;
    for (final match in RegExp(
      r'DEVELOPMENT_TEAM\s*=\s*([^;]+);',
    ).allMatches(iosProject)) {
      final candidate = _cleanBuildSetting(match.group(1));
      if (candidate != null) {
        iosDevelopmentTeam = candidate;
        break;
      }
    }

    return ProductionReleaseEvidence(
      androidApplicationId: _cleanBuildSetting(applicationId),
      androidReleaseSigningConfigured: signingMatch != null,
      androidUsesDebugSigning: signingExpression.contains('debug'),
      iosBundleIdentifier: iosBundleIdentifier,
      iosDevelopmentTeam: iosDevelopmentTeam,
    );
  }

  final String? androidApplicationId;
  final bool androidReleaseSigningConfigured;
  final bool androidUsesDebugSigning;
  final String? iosBundleIdentifier;
  final String? iosDevelopmentTeam;
}

final class ProductionReleaseReport {
  const ProductionReleaseReport({required this.issues});

  final List<ProductionReleaseIssue> issues;

  bool get isReady => issues.isEmpty;
}

abstract final class ProductionReleaseGuard {
  static ProductionReleaseReport evaluate(ProductionReleaseEvidence evidence) {
    final issues = <ProductionReleaseIssue>[];

    if (_isMissing(evidence.androidApplicationId)) {
      issues.add(ProductionReleaseIssue.missingAndroidApplicationId);
    } else if (_isPlaceholderIdentifier(evidence.androidApplicationId!)) {
      issues.add(ProductionReleaseIssue.placeholderAndroidApplicationId);
    }

    if (!evidence.androidReleaseSigningConfigured) {
      issues.add(ProductionReleaseIssue.missingAndroidReleaseSigning);
    } else if (evidence.androidUsesDebugSigning) {
      issues.add(ProductionReleaseIssue.androidDebugSigning);
    }

    if (_isMissing(evidence.iosBundleIdentifier)) {
      issues.add(ProductionReleaseIssue.missingIosBundleIdentifier);
    } else if (_isPlaceholderIdentifier(evidence.iosBundleIdentifier!)) {
      issues.add(ProductionReleaseIssue.placeholderIosBundleIdentifier);
    }

    if (_isMissing(evidence.iosDevelopmentTeam)) {
      issues.add(ProductionReleaseIssue.missingIosDevelopmentTeam);
    }

    return ProductionReleaseReport(issues: List.unmodifiable(issues));
  }

  static bool _isMissing(String? value) =>
      value == null || value.trim().isEmpty;

  static bool _isPlaceholderIdentifier(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'com.example' || normalized.startsWith('com.example.');
  }
}

String? _cleanBuildSetting(String? value) {
  if (value == null) {
    return null;
  }

  final cleaned = value.trim().replaceAll('"', '');
  return cleaned.isEmpty ? null : cleaned;
}
