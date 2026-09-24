enum ProductionIdentityCandidateIssue {
  missingAndroidApplicationId,
  invalidAndroidApplicationId,
  placeholderAndroidApplicationId,
  missingIosBundleIdentifier,
  invalidIosBundleIdentifier,
  placeholderIosBundleIdentifier,
}

final class ProductionIdentityCandidate {
  const ProductionIdentityCandidate({
    required this.androidApplicationId,
    required this.iosBundleIdentifier,
  });

  final String? androidApplicationId;
  final String? iosBundleIdentifier;
}

final class ProductionIdentityCandidateReport {
  const ProductionIdentityCandidateReport({required this.issues});

  final List<ProductionIdentityCandidateIssue> issues;

  bool get isValid => issues.isEmpty;
}

abstract final class ProductionIdentityCandidateGuard {
  static final RegExp _androidApplicationIdPattern = RegExp(
    r'^[A-Za-z][A-Za-z0-9_]*(\.[A-Za-z][A-Za-z0-9_]*)+$',
  );
  static final RegExp _iosBundleIdentifierPattern = RegExp(
    r'^[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$',
  );

  static ProductionIdentityCandidateReport evaluate(
    ProductionIdentityCandidate candidate,
  ) {
    final issues = <ProductionIdentityCandidateIssue>[];

    final android = candidate.androidApplicationId?.trim();
    if (android == null || android.isEmpty) {
      issues.add(ProductionIdentityCandidateIssue.missingAndroidApplicationId);
    } else {
      if (!_androidApplicationIdPattern.hasMatch(android)) {
        issues.add(
          ProductionIdentityCandidateIssue.invalidAndroidApplicationId,
        );
      }
      if (_isPlaceholderIdentifier(android)) {
        issues.add(
          ProductionIdentityCandidateIssue.placeholderAndroidApplicationId,
        );
      }
    }

    final ios = candidate.iosBundleIdentifier?.trim();
    if (ios == null || ios.isEmpty) {
      issues.add(ProductionIdentityCandidateIssue.missingIosBundleIdentifier);
    } else {
      if (!_iosBundleIdentifierPattern.hasMatch(ios)) {
        issues.add(ProductionIdentityCandidateIssue.invalidIosBundleIdentifier);
      }
      if (_isPlaceholderIdentifier(ios)) {
        issues.add(
          ProductionIdentityCandidateIssue.placeholderIosBundleIdentifier,
        );
      }
    }

    return ProductionIdentityCandidateReport(issues: List.unmodifiable(issues));
  }

  static bool _isPlaceholderIdentifier(String value) {
    final normalized = value.toLowerCase();
    return normalized == 'com.example' || normalized.startsWith('com.example.');
  }
}
