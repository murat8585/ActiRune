import 'package:actirune/core/release/provider_authority_lock.dart';
import 'package:actirune/core/release/store_submission_evidence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const authority = ProviderAuthorityLock(
    androidApplicationId: 'com.actirune.synthetic',
    iosBundleIdentifier: 'com.actirune.synthetic',
    backendProvider: 'Synthetic Backend',
    billingProvider: 'Synthetic Billing',
    rewardedAdsProvider: 'Synthetic Ads',
    analyticsProvider: 'Synthetic Analytics',
  );

  group('StoreSubmissionEvidence', () {
    test('valid submitted evidence passes', () {
      final evidence = StoreSubmissionEvidence.fromJson(
        _evidenceJson(reviewState: 'submitted', withSubmissionReferences: true),
      );

      final report = StoreSubmissionValidator.evaluate(
        authority: authority,
        evidence: evidence,
      );

      expect(report.isReadyForSubmission, isTrue);
      expect(report.hasValidSubmissionEvidence, isTrue);
      expect(report.issues, isEmpty);
    });

    test('complete pre-submission evidence is ready but not submitted', () {
      final evidence = StoreSubmissionEvidence.fromJson(
        _evidenceJson(
          reviewState: 'notSubmitted',
          withSubmissionReferences: false,
        ),
      );

      final report = StoreSubmissionValidator.evaluate(
        authority: authority,
        evidence: evidence,
      );

      expect(report.isReadyForSubmission, isTrue);
      expect(report.hasValidSubmissionEvidence, isFalse);
      expect(
        report.issues,
        containsAll(<StoreSubmissionIssue>[
          StoreSubmissionIssue.appleNotSubmitted,
          StoreSubmissionIssue.googlePlayNotSubmitted,
        ]),
      );
    });

    test('identity mismatch fails closed', () {
      final json = _evidenceJson(
        reviewState: 'submitted',
        withSubmissionReferences: true,
      );
      json['androidApplicationId'] = 'com.other.app';
      json['iosBundleIdentifier'] = 'com.other.app';
      final evidence = StoreSubmissionEvidence.fromJson(json);

      final report = StoreSubmissionValidator.evaluate(
        authority: authority,
        evidence: evidence,
      );

      expect(report.isReadyForSubmission, isFalse);
      expect(
        report.issues,
        containsAll(<StoreSubmissionIssue>[
          StoreSubmissionIssue.androidApplicationIdMismatch,
          StoreSubmissionIssue.iosBundleIdentifierMismatch,
        ]),
      );
    });

    test('required store declarations fail closed when incomplete', () {
      final json = _evidenceJson(
        reviewState: 'notSubmitted',
        withSubmissionReferences: false,
      );
      final apple = json['apple']! as Map<String, Object?>;
      final googlePlay = json['googlePlay']! as Map<String, Object?>;
      apple['requiredMetadataComplete'] = false;
      apple['appPrivacyComplete'] = false;
      apple['reviewAccessComplete'] = false;
      apple['monetizationItemsReady'] = false;
      googlePlay['playAppSigningVerified'] = false;
      googlePlay['storeListingComplete'] = false;
      googlePlay['appContentComplete'] = false;
      googlePlay['dataSafetyComplete'] = false;
      googlePlay['reviewAccessComplete'] = false;
      googlePlay['monetizationItemsReady'] = false;
      final evidence = StoreSubmissionEvidence.fromJson(json);

      final report = StoreSubmissionValidator.evaluate(
        authority: authority,
        evidence: evidence,
      );

      expect(report.isReadyForSubmission, isFalse);
      expect(report.hasValidSubmissionEvidence, isFalse);
      expect(report.issues, contains(StoreSubmissionIssue.appleMetadataIncomplete));
      expect(report.issues, contains(StoreSubmissionIssue.applePrivacyIncomplete));
      expect(
        report.issues,
        contains(StoreSubmissionIssue.googlePlaySigningUnverified),
      );
      expect(
        report.issues,
        contains(StoreSubmissionIssue.googlePlayDataSafetyIncomplete),
      );
    });

    test('submitted state requires non-secret audit references', () {
      final evidence = StoreSubmissionEvidence.fromJson(
        _evidenceJson(reviewState: 'submitted', withSubmissionReferences: false),
      );

      final report = StoreSubmissionValidator.evaluate(
        authority: authority,
        evidence: evidence,
      );

      expect(report.isReadyForSubmission, isFalse);
      expect(
        report.issues,
        containsAll(<StoreSubmissionIssue>[
          StoreSubmissionIssue.appleSubmissionReferenceMissing,
          StoreSubmissionIssue.googlePlaySubmissionReferenceMissing,
        ]),
      );
    });

    test('rejected review never counts as valid submission evidence', () {
      final evidence = StoreSubmissionEvidence.fromJson(
        _evidenceJson(reviewState: 'rejected', withSubmissionReferences: true),
      );

      final report = StoreSubmissionValidator.evaluate(
        authority: authority,
        evidence: evidence,
      );

      expect(report.isReadyForSubmission, isFalse);
      expect(report.hasValidSubmissionEvidence, isFalse);
      expect(
        report.issues,
        containsAll(<StoreSubmissionIssue>[
          StoreSubmissionIssue.appleRejected,
          StoreSubmissionIssue.googlePlayRejected,
        ]),
      );
    });

    test('invalid commit and unsupported fields are rejected by schema', () {
      final invalidCommit = _evidenceJson(
        reviewState: 'notSubmitted',
        withSubmissionReferences: false,
      )..['releaseGitCommit'] = 'not-a-sha';
      expect(
        () => StoreSubmissionEvidence.fromJson(invalidCommit),
        throwsFormatException,
      );

      final unknownField = _evidenceJson(
        reviewState: 'notSubmitted',
        withSubmissionReferences: false,
      );
      final apple = unknownField['apple']! as Map<String, Object?>;
      apple['apiToken'] = 'must-not-be-here';
      expect(
        () => StoreSubmissionEvidence.fromJson(unknownField),
        throwsFormatException,
      );
    });
  });
}

Map<String, Object?> _evidenceJson({
  required String reviewState,
  required bool withSubmissionReferences,
}) {
  return <String, Object?>{
    'schemaVersion': 1,
    'releaseGitCommit': '1234567890abcdef1234567890abcdef12345678',
    'releaseBuild': 'synthetic-build-1',
    'androidApplicationId': 'com.actirune.synthetic',
    'iosBundleIdentifier': 'com.actirune.synthetic',
    'apple': <String, Object?>{
      'appStoreConnectAppReference': 'apple-app-reference',
      'selectedBuildReference': 'apple-build-reference',
      'requiredMetadataComplete': true,
      'appPrivacyComplete': true,
      'exportCompliance': 'notRequired',
      'reviewAccessComplete': true,
      'monetizationItemsReady': true,
      'reviewState': reviewState,
      'submissionReference': withSubmissionReferences
          ? 'apple-submission-reference'
          : null,
    },
    'googlePlay': <String, Object?>{
      'playConsoleAppReference': 'play-app-reference',
      'artifactReference': 'play-artifact-reference',
      'playAppSigningVerified': true,
      'storeListingComplete': true,
      'appContentComplete': true,
      'dataSafetyComplete': true,
      'reviewAccessComplete': true,
      'productionAccess': 'notRequired',
      'monetizationItemsReady': true,
      'reviewState': reviewState,
      'submissionReference': withSubmissionReferences
          ? 'play-submission-reference'
          : null,
    },
  };
}
