enum ProductionSigningHygieneIssue {
  missingAndroidReleaseSigning,
  androidDebugSigning,
  missingIosDevelopmentTeam,
  invalidIosDevelopmentTeam,
  missingRequiredIgnorePattern,
  trackedSigningMaterial,
}

final class ProductionSigningHygieneEvidence {
  const ProductionSigningHygieneEvidence({
    required this.androidReleaseSigningConfigured,
    required this.androidUsesDebugSigning,
    required this.iosDevelopmentTeam,
    required this.gitignore,
    required this.trackedPaths,
  });

  factory ProductionSigningHygieneEvidence.fromRepositoryTexts({
    required String androidGradle,
    required String iosProject,
    required String gitignore,
    required Iterable<String> trackedPaths,
  }) {
    final signingMatch = RegExp(
      r'^\s*signingConfig\s*=\s*(.+)$',
      multiLine: true,
    ).firstMatch(androidGradle);
    final signingExpression = signingMatch?.group(1) ?? '';

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

    return ProductionSigningHygieneEvidence(
      androidReleaseSigningConfigured: signingMatch != null,
      androidUsesDebugSigning: signingExpression.contains('debug'),
      iosDevelopmentTeam: iosDevelopmentTeam,
      gitignore: gitignore,
      trackedPaths: List.unmodifiable(trackedPaths),
    );
  }

  final bool androidReleaseSigningConfigured;
  final bool androidUsesDebugSigning;
  final String? iosDevelopmentTeam;
  final String gitignore;
  final List<String> trackedPaths;
}

final class ProductionSigningHygieneReport {
  const ProductionSigningHygieneReport({required this.issues});

  final List<ProductionSigningHygieneIssue> issues;

  bool get isReady => issues.isEmpty;
}

abstract final class ProductionSigningHygieneGuard {
  static const requiredIgnorePatterns = <String>{
    '*.jks',
    '*.keystore',
    '*.p12',
    '*.mobileprovision',
    '.env',
    '.env.*',
    'key.properties',
  };

  static final RegExp _appleTeamIdPattern = RegExp(r'^[A-Za-z0-9]{10}$');

  static ProductionSigningHygieneReport evaluate(
    ProductionSigningHygieneEvidence evidence,
  ) {
    final issues = <ProductionSigningHygieneIssue>[];

    if (!evidence.androidReleaseSigningConfigured) {
      issues.add(ProductionSigningHygieneIssue.missingAndroidReleaseSigning);
    } else if (evidence.androidUsesDebugSigning) {
      issues.add(ProductionSigningHygieneIssue.androidDebugSigning);
    }

    final team = evidence.iosDevelopmentTeam?.trim();
    if (team == null || team.isEmpty) {
      issues.add(ProductionSigningHygieneIssue.missingIosDevelopmentTeam);
    } else if (!_appleTeamIdPattern.hasMatch(team)) {
      issues.add(ProductionSigningHygieneIssue.invalidIosDevelopmentTeam);
    }

    final ignoreLines = evidence.gitignore
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty && !line.startsWith('#'))
        .toSet();
    if (!ignoreLines.containsAll(requiredIgnorePatterns)) {
      issues.add(ProductionSigningHygieneIssue.missingRequiredIgnorePattern);
    }

    if (evidence.trackedPaths.any(_looksLikeSigningMaterial)) {
      issues.add(ProductionSigningHygieneIssue.trackedSigningMaterial);
    }

    return ProductionSigningHygieneReport(issues: List.unmodifiable(issues));
  }

  static bool _looksLikeSigningMaterial(String path) {
    final normalized = path.replaceAll('\\', '/').toLowerCase();
    final basename = normalized.split('/').last;
    return normalized.endsWith('.jks') ||
        normalized.endsWith('.keystore') ||
        normalized.endsWith('.p12') ||
        normalized.endsWith('.mobileprovision') ||
        basename == 'key.properties' ||
        basename == '.env' ||
        basename.startsWith('.env.');
  }
}

String? _cleanBuildSetting(String? value) {
  if (value == null) {
    return null;
  }

  final cleaned = value.trim().replaceAll('"', '');
  return cleaned.isEmpty ? null : cleaned;
}
