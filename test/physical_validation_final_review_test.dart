import 'package:actirune/features/pose/validation/physical_validation_final_review.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const evidenceSha = '0123456789abcdef0123456789abcdef01234567';
  const evidenceBuilds = <String>{'1.0.0+100'};

  test('passed review bound to exact evidence blob and build is valid', () {
    final report = PhysicalValidationFinalReviewValidator.evaluate(
      record: const PhysicalValidationFinalReviewRecord(
        disposition: PhysicalFinalReviewDisposition.passed,
        evidenceGitBlobSha: evidenceSha,
        reviewReference: 'release-review-001',
        reviewedBuild: '1.0.0+100',
      ),
      actualEvidenceGitBlobSha: evidenceSha,
      evidenceBuilds: evidenceBuilds,
    );

    expect(report.isPassed, isTrue);
    expect(report.issues, isEmpty);
  });

  test('failed human disposition can never pass', () {
    final report = PhysicalValidationFinalReviewValidator.evaluate(
      record: const PhysicalValidationFinalReviewRecord(
        disposition: PhysicalFinalReviewDisposition.failed,
        evidenceGitBlobSha: evidenceSha,
        reviewReference: 'release-review-001',
        reviewedBuild: '1.0.0+100',
      ),
      actualEvidenceGitBlobSha: evidenceSha,
      evidenceBuilds: evidenceBuilds,
    );

    expect(report.isPassed, isFalse);
    expect(report.issues, contains(PhysicalFinalReviewIssue.dispositionFailed));
  });

  test('review cannot be reused after physical evidence changes', () {
    final report = PhysicalValidationFinalReviewValidator.evaluate(
      record: const PhysicalValidationFinalReviewRecord(
        disposition: PhysicalFinalReviewDisposition.passed,
        evidenceGitBlobSha: evidenceSha,
        reviewReference: 'release-review-001',
        reviewedBuild: '1.0.0+100',
      ),
      actualEvidenceGitBlobSha: 'ffffffffffffffffffffffffffffffffffffffff',
      evidenceBuilds: evidenceBuilds,
    );

    expect(report.isPassed, isFalse);
    expect(
      report.issues,
      contains(PhysicalFinalReviewIssue.evidenceGitBlobMismatch),
    );
  });

  test('review cannot be reused for a different build', () {
    final report = PhysicalValidationFinalReviewValidator.evaluate(
      record: const PhysicalValidationFinalReviewRecord(
        disposition: PhysicalFinalReviewDisposition.passed,
        evidenceGitBlobSha: evidenceSha,
        reviewReference: 'release-review-001',
        reviewedBuild: '1.0.0+101',
      ),
      actualEvidenceGitBlobSha: evidenceSha,
      evidenceBuilds: evidenceBuilds,
    );

    expect(report.isPassed, isFalse);
    expect(
      report.issues,
      contains(PhysicalFinalReviewIssue.reviewedBuildMismatch),
    );
  });

  test('mixed-build physical evidence cannot receive one final pass', () {
    final report = PhysicalValidationFinalReviewValidator.evaluate(
      record: const PhysicalValidationFinalReviewRecord(
        disposition: PhysicalFinalReviewDisposition.passed,
        evidenceGitBlobSha: evidenceSha,
        reviewReference: 'release-review-001',
        reviewedBuild: '1.0.0+100',
      ),
      actualEvidenceGitBlobSha: evidenceSha,
      evidenceBuilds: const <String>{'1.0.0+100', '1.0.0+101'},
    );

    expect(report.isPassed, isFalse);
    expect(
      report.issues,
      contains(PhysicalFinalReviewIssue.evidenceBuildSetInvalid),
    );
  });

  test('malformed evidence blob SHA is rejected', () {
    final report = PhysicalValidationFinalReviewValidator.evaluate(
      record: const PhysicalValidationFinalReviewRecord(
        disposition: PhysicalFinalReviewDisposition.passed,
        evidenceGitBlobSha: 'not-a-git-blob-sha',
        reviewReference: 'release-review-001',
        reviewedBuild: '1.0.0+100',
      ),
      actualEvidenceGitBlobSha: evidenceSha,
      evidenceBuilds: evidenceBuilds,
    );

    expect(report.isPassed, isFalse);
    expect(
      report.issues,
      contains(PhysicalFinalReviewIssue.invalidEvidenceGitBlobSha),
    );
  });

  test('JSON parser rejects raw media or identity fields', () {
    final json = <String, Object?>{
      'schemaVersion': 1,
      'disposition': 'passed',
      'evidenceGitBlobSha': evidenceSha,
      'reviewReference': 'release-review-001',
      'reviewedBuild': '1.0.0+100',
      'subjectName': 'must-not-be-here',
    };

    expect(
      () => PhysicalValidationFinalReviewRecord.fromJson(json),
      throwsA(isA<FormatException>()),
    );
  });

  test('JSON parser accepts privacy-safe auditable review metadata', () {
    final record = PhysicalValidationFinalReviewRecord.fromJson(
      const <String, Object?>{
        'schemaVersion': 1,
        'disposition': 'passed',
        'evidenceGitBlobSha': evidenceSha,
        'reviewReference': 'release-review-001',
        'reviewedBuild': '1.0.0+100',
      },
    );

    expect(record.disposition, PhysicalFinalReviewDisposition.passed);
    expect(record.evidenceGitBlobSha, evidenceSha);
  });
}
