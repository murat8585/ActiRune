import 'package:flutter/foundation.dart';

enum PhysicalFinalReviewDisposition { passed, failed }

enum PhysicalFinalReviewIssue {
  dispositionFailed,
  invalidEvidenceGitBlobSha,
  evidenceGitBlobMismatch,
}

@immutable
final class PhysicalValidationFinalReviewRecord {
  const PhysicalValidationFinalReviewRecord({
    required this.disposition,
    required this.evidenceGitBlobSha,
    required this.reviewReference,
    required this.reviewedBuild,
  });

  factory PhysicalValidationFinalReviewRecord.fromJson(
    Map<String, Object?> json,
  ) {
    const allowedKeys = <String>{
      'schemaVersion',
      'disposition',
      'evidenceGitBlobSha',
      'reviewReference',
      'reviewedBuild',
    };
    final unknownKeys = json.keys.where((key) => !allowedKeys.contains(key));
    if (unknownKeys.isNotEmpty) {
      throw FormatException(
        'Unsupported physical final-review field(s): ${unknownKeys.join(', ')}. '
        'Raw video, biometric identity and credentials do not belong here.',
      );
    }

    final schemaVersion = json['schemaVersion'];
    if (schemaVersion is! int || schemaVersion != 1) {
      throw const FormatException('schemaVersion must be integer 1.');
    }

    return PhysicalValidationFinalReviewRecord(
      disposition: _enumValue(
        PhysicalFinalReviewDisposition.values,
        _requiredString(json, 'disposition'),
        'disposition',
      ),
      evidenceGitBlobSha: _requiredString(json, 'evidenceGitBlobSha'),
      reviewReference: _requiredString(json, 'reviewReference'),
      reviewedBuild: _requiredString(json, 'reviewedBuild'),
    );
  }

  final PhysicalFinalReviewDisposition disposition;
  final String evidenceGitBlobSha;
  final String reviewReference;
  final String reviewedBuild;
}

@immutable
final class PhysicalValidationFinalReviewReport {
  const PhysicalValidationFinalReviewReport({required this.issues});

  final List<PhysicalFinalReviewIssue> issues;

  bool get isPassed => issues.isEmpty;
}

abstract final class PhysicalValidationFinalReviewValidator {
  static PhysicalValidationFinalReviewReport evaluate({
    required PhysicalValidationFinalReviewRecord record,
    required String actualEvidenceGitBlobSha,
  }) {
    final issues = <PhysicalFinalReviewIssue>[];

    if (record.disposition != PhysicalFinalReviewDisposition.passed) {
      issues.add(PhysicalFinalReviewIssue.dispositionFailed);
    }

    if (!RegExp(r'^[0-9a-fA-F]{40}$').hasMatch(record.evidenceGitBlobSha)) {
      issues.add(PhysicalFinalReviewIssue.invalidEvidenceGitBlobSha);
    } else if (record.evidenceGitBlobSha.toLowerCase() !=
        actualEvidenceGitBlobSha.trim().toLowerCase()) {
      issues.add(PhysicalFinalReviewIssue.evidenceGitBlobMismatch);
    }

    return PhysicalValidationFinalReviewReport(
      issues: List.unmodifiable(issues),
    );
  }
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('$key must be a non-empty string.');
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
