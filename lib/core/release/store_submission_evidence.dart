import 'provider_authority_lock.dart';

enum StoreReviewState { notSubmitted, submitted, inReview, approved, rejected }

enum RequirementDisposition { undecided, notRequired, complete }

enum StoreSubmissionIssue {
  androidApplicationIdMismatch,
  iosBundleIdentifierMismatch,
  appleMetadataIncomplete,
  applePrivacyIncomplete,
  appleExportComplianceUndecided,
  appleReviewAccessIncomplete,
  appleMonetizationIncomplete,
  googlePlaySigningUnverified,
  googlePlayStoreListingIncomplete,
  googlePlayAppContentIncomplete,
  googlePlayDataSafetyIncomplete,
  googlePlayReviewAccessIncomplete,
  googlePlayProductionAccessUndecided,
  googlePlayMonetizationIncomplete,
  appleNotSubmitted,
  appleSubmissionReferenceMissing,
  appleRejected,
  googlePlayNotSubmitted,
  googlePlaySubmissionReferenceMissing,
  googlePlayRejected,
}

final class AppleStoreEvidence {
  const AppleStoreEvidence({
    required this.appStoreConnectAppReference,
    required this.selectedBuildReference,
    required this.requiredMetadataComplete,
    required this.appPrivacyComplete,
    required this.exportCompliance,
    required this.reviewAccessComplete,
    required this.monetizationItemsReady,
    required this.reviewState,
    this.submissionReference,
  });

  factory AppleStoreEvidence.fromJson(Map<String, Object?> json) {
    _rejectUnknownKeys(json, 'apple', const <String>{
      'appStoreConnectAppReference',
      'selectedBuildReference',
      'requiredMetadataComplete',
      'appPrivacyComplete',
      'exportCompliance',
      'reviewAccessComplete',
      'monetizationItemsReady',
      'reviewState',
      'submissionReference',
    });

    return AppleStoreEvidence(
      appStoreConnectAppReference: _requiredString(
        json,
        'appStoreConnectAppReference',
        prefix: 'apple',
      ),
      selectedBuildReference: _requiredString(
        json,
        'selectedBuildReference',
        prefix: 'apple',
      ),
      requiredMetadataComplete: _requiredBool(
        json,
        'requiredMetadataComplete',
        prefix: 'apple',
      ),
      appPrivacyComplete: _requiredBool(
        json,
        'appPrivacyComplete',
        prefix: 'apple',
      ),
      exportCompliance: _enumValue(
        RequirementDisposition.values,
        _requiredString(json, 'exportCompliance', prefix: 'apple'),
        'apple.exportCompliance',
      ),
      reviewAccessComplete: _requiredBool(
        json,
        'reviewAccessComplete',
        prefix: 'apple',
      ),
      monetizationItemsReady: _requiredBool(
        json,
        'monetizationItemsReady',
        prefix: 'apple',
      ),
      reviewState: _enumValue(
        StoreReviewState.values,
        _requiredString(json, 'reviewState', prefix: 'apple'),
        'apple.reviewState',
      ),
      submissionReference: _optionalString(
        json,
        'submissionReference',
        prefix: 'apple',
      ),
    );
  }

  final String appStoreConnectAppReference;
  final String selectedBuildReference;
  final bool requiredMetadataComplete;
  final bool appPrivacyComplete;
  final RequirementDisposition exportCompliance;
  final bool reviewAccessComplete;
  final bool monetizationItemsReady;
  final StoreReviewState reviewState;
  final String? submissionReference;
}

final class GooglePlayStoreEvidence {
  const GooglePlayStoreEvidence({
    required this.playConsoleAppReference,
    required this.artifactReference,
    required this.playAppSigningVerified,
    required this.storeListingComplete,
    required this.appContentComplete,
    required this.dataSafetyComplete,
    required this.reviewAccessComplete,
    required this.productionAccess,
    required this.monetizationItemsReady,
    required this.reviewState,
    this.submissionReference,
  });

  factory GooglePlayStoreEvidence.fromJson(Map<String, Object?> json) {
    _rejectUnknownKeys(json, 'googlePlay', const <String>{
      'playConsoleAppReference',
      'artifactReference',
      'playAppSigningVerified',
      'storeListingComplete',
      'appContentComplete',
      'dataSafetyComplete',
      'reviewAccessComplete',
      'productionAccess',
      'monetizationItemsReady',
      'reviewState',
      'submissionReference',
    });

    return GooglePlayStoreEvidence(
      playConsoleAppReference: _requiredString(
        json,
        'playConsoleAppReference',
        prefix: 'googlePlay',
      ),
      artifactReference: _requiredString(
        json,
        'artifactReference',
        prefix: 'googlePlay',
      ),
      playAppSigningVerified: _requiredBool(
        json,
        'playAppSigningVerified',
        prefix: 'googlePlay',
      ),
      storeListingComplete: _requiredBool(
        json,
        'storeListingComplete',
        prefix: 'googlePlay',
      ),
      appContentComplete: _requiredBool(
        json,
        'appContentComplete',
        prefix: 'googlePlay',
      ),
      dataSafetyComplete: _requiredBool(
        json,
        'dataSafetyComplete',
        prefix: 'googlePlay',
      ),
      reviewAccessComplete: _requiredBool(
        json,
        'reviewAccessComplete',
        prefix: 'googlePlay',
      ),
      productionAccess: _enumValue(
        RequirementDisposition.values,
        _requiredString(json, 'productionAccess', prefix: 'googlePlay'),
        'googlePlay.productionAccess',
      ),
      monetizationItemsReady: _requiredBool(
        json,
        'monetizationItemsReady',
        prefix: 'googlePlay',
      ),
      reviewState: _enumValue(
        StoreReviewState.values,
        _requiredString(json, 'reviewState', prefix: 'googlePlay'),
        'googlePlay.reviewState',
      ),
      submissionReference: _optionalString(
        json,
        'submissionReference',
        prefix: 'googlePlay',
      ),
    );
  }

  final String playConsoleAppReference;
  final String artifactReference;
  final bool playAppSigningVerified;
  final bool storeListingComplete;
  final bool appContentComplete;
  final bool dataSafetyComplete;
  final bool reviewAccessComplete;
  final RequirementDisposition productionAccess;
  final bool monetizationItemsReady;
  final StoreReviewState reviewState;
  final String? submissionReference;
}

final class StoreSubmissionEvidence {
  const StoreSubmissionEvidence({
    required this.releaseGitCommit,
    required this.releaseBuild,
    required this.androidApplicationId,
    required this.iosBundleIdentifier,
    required this.apple,
    required this.googlePlay,
  });

  factory StoreSubmissionEvidence.fromJson(Map<String, Object?> json) {
    _rejectUnknownKeys(json, 'root', const <String>{
      'schemaVersion',
      'releaseGitCommit',
      'releaseBuild',
      'androidApplicationId',
      'iosBundleIdentifier',
      'apple',
      'googlePlay',
    });

    final schemaVersion = json['schemaVersion'];
    if (schemaVersion is! int || schemaVersion != 1) {
      throw const FormatException('schemaVersion must be integer 1.');
    }

    final releaseGitCommit = _requiredString(json, 'releaseGitCommit');
    if (!RegExp(r'^[0-9a-fA-F]{40}$').hasMatch(releaseGitCommit)) {
      throw const FormatException(
        'releaseGitCommit must be an exact 40-character Git commit SHA.',
      );
    }

    return StoreSubmissionEvidence(
      releaseGitCommit: releaseGitCommit.toLowerCase(),
      releaseBuild: _requiredString(json, 'releaseBuild'),
      androidApplicationId: _requiredString(json, 'androidApplicationId'),
      iosBundleIdentifier: _requiredString(json, 'iosBundleIdentifier'),
      apple: AppleStoreEvidence.fromJson(_requiredObject(json, 'apple')),
      googlePlay: GooglePlayStoreEvidence.fromJson(
        _requiredObject(json, 'googlePlay'),
      ),
    );
  }

  final String releaseGitCommit;
  final String releaseBuild;
  final String androidApplicationId;
  final String iosBundleIdentifier;
  final AppleStoreEvidence apple;
  final GooglePlayStoreEvidence googlePlay;
}

final class StoreSubmissionReport {
  const StoreSubmissionReport({required this.issues});

  final List<StoreSubmissionIssue> issues;

  bool get isReadyForSubmission => issues.every(
    (issue) =>
        issue == StoreSubmissionIssue.appleNotSubmitted ||
        issue == StoreSubmissionIssue.googlePlayNotSubmitted,
  );

  bool get hasValidSubmissionEvidence => issues.isEmpty;
}

abstract final class StoreSubmissionValidator {
  static StoreSubmissionReport evaluate({
    required ProviderAuthorityLock authority,
    required StoreSubmissionEvidence evidence,
  }) {
    final issues = <StoreSubmissionIssue>[];

    if (evidence.androidApplicationId != authority.androidApplicationId) {
      issues.add(StoreSubmissionIssue.androidApplicationIdMismatch);
    }
    if (evidence.iosBundleIdentifier != authority.iosBundleIdentifier) {
      issues.add(StoreSubmissionIssue.iosBundleIdentifierMismatch);
    }

    final apple = evidence.apple;
    if (!apple.requiredMetadataComplete) {
      issues.add(StoreSubmissionIssue.appleMetadataIncomplete);
    }
    if (!apple.appPrivacyComplete) {
      issues.add(StoreSubmissionIssue.applePrivacyIncomplete);
    }
    if (apple.exportCompliance == RequirementDisposition.undecided) {
      issues.add(StoreSubmissionIssue.appleExportComplianceUndecided);
    }
    if (!apple.reviewAccessComplete) {
      issues.add(StoreSubmissionIssue.appleReviewAccessIncomplete);
    }
    if (!apple.monetizationItemsReady) {
      issues.add(StoreSubmissionIssue.appleMonetizationIncomplete);
    }
    _validateReviewState(
      state: apple.reviewState,
      submissionReference: apple.submissionReference,
      notSubmitted: StoreSubmissionIssue.appleNotSubmitted,
      missingReference: StoreSubmissionIssue.appleSubmissionReferenceMissing,
      rejected: StoreSubmissionIssue.appleRejected,
      issues: issues,
    );

    final googlePlay = evidence.googlePlay;
    if (!googlePlay.playAppSigningVerified) {
      issues.add(StoreSubmissionIssue.googlePlaySigningUnverified);
    }
    if (!googlePlay.storeListingComplete) {
      issues.add(StoreSubmissionIssue.googlePlayStoreListingIncomplete);
    }
    if (!googlePlay.appContentComplete) {
      issues.add(StoreSubmissionIssue.googlePlayAppContentIncomplete);
    }
    if (!googlePlay.dataSafetyComplete) {
      issues.add(StoreSubmissionIssue.googlePlayDataSafetyIncomplete);
    }
    if (!googlePlay.reviewAccessComplete) {
      issues.add(StoreSubmissionIssue.googlePlayReviewAccessIncomplete);
    }
    if (googlePlay.productionAccess == RequirementDisposition.undecided) {
      issues.add(StoreSubmissionIssue.googlePlayProductionAccessUndecided);
    }
    if (!googlePlay.monetizationItemsReady) {
      issues.add(StoreSubmissionIssue.googlePlayMonetizationIncomplete);
    }
    _validateReviewState(
      state: googlePlay.reviewState,
      submissionReference: googlePlay.submissionReference,
      notSubmitted: StoreSubmissionIssue.googlePlayNotSubmitted,
      missingReference:
          StoreSubmissionIssue.googlePlaySubmissionReferenceMissing,
      rejected: StoreSubmissionIssue.googlePlayRejected,
      issues: issues,
    );

    return StoreSubmissionReport(issues: List.unmodifiable(issues));
  }

  static void _validateReviewState({
    required StoreReviewState state,
    required String? submissionReference,
    required StoreSubmissionIssue notSubmitted,
    required StoreSubmissionIssue missingReference,
    required StoreSubmissionIssue rejected,
    required List<StoreSubmissionIssue> issues,
  }) {
    if (state == StoreReviewState.notSubmitted) {
      issues.add(notSubmitted);
      return;
    }
    if (submissionReference == null) {
      issues.add(missingReference);
    }
    if (state == StoreReviewState.rejected) {
      issues.add(rejected);
    }
  }
}

void _rejectUnknownKeys(
  Map<String, Object?> json,
  String label,
  Set<String> allowedKeys,
) {
  final unknownKeys = json.keys.where((key) => !allowedKeys.contains(key));
  if (unknownKeys.isNotEmpty) {
    throw FormatException(
      '$label contains unsupported field(s): ${unknownKeys.join(', ')}. '
      'Credentials, tokens and secrets must not be stored in store evidence.',
    );
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

String? _optionalString(
  Map<String, Object?> json,
  String key, {
  required String prefix,
}) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('$prefix.$key must be null or a non-empty string.');
  }
  return value.trim();
}

bool _requiredBool(
  Map<String, Object?> json,
  String key, {
  required String prefix,
}) {
  final value = json[key];
  if (value is! bool) {
    throw FormatException('$prefix.$key must be a boolean.');
  }
  return value;
}

T _enumValue<T extends Enum>(List<T> values, String raw, String key) {
  for (final value in values) {
    if (value.name == raw) return value;
  }
  throw FormatException(
    '$key has unsupported value "$raw". Allowed: '
    '${values.map((value) => value.name).join(', ')}.',
  );
}
