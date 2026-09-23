// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:actirune/core/release/phase1_release_readiness.dart';
import 'package:actirune/core/release/production_release_guard.dart';
import 'package:actirune/core/release/provider_authority_lock.dart';
import 'package:actirune/core/release/provider_configuration_evidence.dart';
import 'package:actirune/features/pose/validation/physical_validation_evidence.dart';
import 'package:actirune/features/pose/validation/physical_validation_final_review.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('repository satisfies all declared Phase-1 production gates', () {
    const authorityPath = 'validation/release/provider_authority.json';
    const configurationPath = 'validation/release/provider_configuration.json';
    const physicalEvidencePath =
        'validation/physical_device_mlkit/evidence.json';
    const physicalReviewPath = 'validation/release/physical_final_review.json';

    final androidFile = File('android/app/build.gradle.kts');
    final iosFile = File('ios/Runner.xcodeproj/project.pbxproj');

    expect(
      androidFile.existsSync(),
      isTrue,
      reason: 'Android platform authority file is missing.',
    );
    expect(
      iosFile.existsSync(),
      isTrue,
      reason: 'iOS platform authority file is missing.',
    );

    final productionEvidence = ProductionReleaseEvidence.fromPlatformFiles(
      androidGradle: androidFile.readAsStringSync(),
      iosProject: iosFile.readAsStringSync(),
    );
    final productionReport = ProductionReleaseGuard.evaluate(productionEvidence);

    ProviderAuthorityLock? authority;
    ProviderAuthorityReport? authorityReport;
    ProviderConfigurationReport? configurationReport;
    var providerState = ProviderReleaseState.undecided;

    final authorityFile = File(authorityPath);
    if (authorityFile.existsSync()) {
      authority = ProviderAuthorityLock.fromJson(
        _readJsonObject(authorityFile, 'provider authority'),
      );
      authorityReport = ProviderAuthorityValidator.evaluate(
        authority: authority,
        productionEvidence: productionEvidence,
      );
      providerState = ProviderReleaseState.lockedNotConfigured;

      final configurationFile = File(configurationPath);
      if (authorityReport.isValid && configurationFile.existsSync()) {
        final configuration = ProviderConfigurationEvidence.fromJson(
          _readJsonObject(configurationFile, 'provider configuration'),
        );
        configurationReport = ProviderConfigurationValidator.evaluate(
          authority: authority,
          evidence: configuration,
        );
        if (configurationReport.isValid) {
          providerState = ProviderReleaseState.configured;
        }
      }
    }

    PhysicalValidationCorpus? physicalCorpus;
    PhysicalValidationEvidenceSummary? physicalSummary;
    final physicalEvidenceFile = File(physicalEvidencePath);
    if (physicalEvidenceFile.existsSync()) {
      physicalCorpus = PhysicalValidationCorpus.fromJson(
        _readJsonObject(physicalEvidenceFile, 'physical-device evidence'),
      );
      physicalSummary = physicalCorpus.summarize();
    }

    var physicalFinalReview = PhysicalValidationFinalReview.pending;
    PhysicalValidationFinalReviewReport? physicalReviewReport;
    final physicalReviewFile = File(physicalReviewPath);
    if (physicalReviewFile.existsSync()) {
      if (physicalCorpus == null) {
        physicalFinalReview = PhysicalValidationFinalReview.failed;
      } else {
        final reviewRecord = PhysicalValidationFinalReviewRecord.fromJson(
          _readJsonObject(physicalReviewFile, 'physical final review'),
        );
        physicalReviewReport = PhysicalValidationFinalReviewValidator.evaluate(
          record: reviewRecord,
          actualEvidenceGitBlobSha: _gitBlobSha(physicalEvidencePath),
          evidenceBuilds: physicalCorpus.records
              .map((record) => record.build)
              .toSet(),
        );
        physicalFinalReview = physicalReviewReport.isPassed
            ? PhysicalValidationFinalReview.passed
            : PhysicalValidationFinalReview.failed;
      }
    }

    final aggregate = Phase1ReleaseReadiness.evaluate(
      Phase1ReleaseReadinessEvidence(
        productionRelease: productionReport,
        providerState: providerState,
        providerAuthority: authorityReport,
        physicalEvidence: physicalSummary,
        physicalFinalReview: physicalFinalReview,
      ),
    );

    print('ActiRune Phase-1 production readiness');
    _printSection(
      'Production identity/signing issues',
      productionReport.issues.map((issue) => issue.name),
    );

    if (authority == null) {
      print('Provider authority: MISSING ($authorityPath)');
    } else {
      print(
        'Provider authority: ${authorityReport!.isValid ? 'VALID' : 'INVALID'}',
      );
      _printSection(
        'Provider authority issues',
        authorityReport.issues.map((issue) => issue.name),
      );
    }

    if (File(configurationPath).existsSync()) {
      if (configurationReport == null) {
        print(
          'Provider configuration: '
          'PRESENT_BUT_NOT_VALIDATABLE_UNTIL_AUTHORITY_IS_VALID',
        );
      } else {
        print(
          'Provider configuration: '
          '${configurationReport.isValid ? 'VALID' : 'INVALID'}',
        );
        _printSection(
          'Provider configuration issues',
          configurationReport.issues.map((issue) => issue.name),
        );
      }
    } else {
      print('Provider configuration: MISSING ($configurationPath)');
    }

    if (physicalSummary == null) {
      print('Physical evidence: MISSING ($physicalEvidencePath)');
    } else {
      print(
        'Physical evidence: '
        '${physicalSummary.readyForHumanReview ? 'READY_FOR_HUMAN_REVIEW' : 'INCOMPLETE'}',
      );
      print('Physical evidence records: ${physicalSummary.recordCount}');
      print('Observed false positives: ${physicalSummary.falsePositives}');
      print('Observed false negatives: ${physicalSummary.falseNegatives}');
      _printSection('Physical evidence blockers', physicalSummary.blockers);
      _printSection('Physical evidence warnings', physicalSummary.warnings);
    }

    if (!physicalReviewFile.existsSync()) {
      print('Physical final review: MISSING ($physicalReviewPath)');
    } else if (physicalReviewReport == null) {
      print('Physical final review: INVALID_WITHOUT_EVIDENCE');
    } else {
      print(
        'Physical final review: '
        '${physicalReviewReport.isPassed ? 'PASSED' : 'FAILED'}',
      );
      _printSection(
        'Physical final review issues',
        physicalReviewReport.issues.map((issue) => issue.name),
      );
    }

    _printSection(
      'Aggregate blockers',
      aggregate.blockers.map((blocker) => blocker.name),
    );

    if (aggregate.allDeclaredGatesSatisfied) {
      print('RESULT: ALL_DECLARED_PHASE1_GATES_SATISFIED');
    } else {
      print('RESULT: BLOCKED_PHASE1_PRODUCTION_READINESS');
    }

    expect(
      aggregate.allDeclaredGatesSatisfied,
      isTrue,
      reason:
          'Production readiness remains blocked: '
          '${aggregate.blockers.map((blocker) => blocker.name).join(', ')}',
    );
  });
}

Map<String, Object?> _readJsonObject(File file, String label) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map<String, Object?>) {
    throw FormatException('$label root must be a JSON object.');
  }
  return decoded;
}

String _gitBlobSha(String path) {
  final result = Process.runSync('git', <String>['hash-object', path]);
  if (result.exitCode != 0) {
    throw FileSystemException(
      'Unable to hash physical evidence with git hash-object.',
      path,
    );
  }

  final sha = result.stdout.toString().trim();
  if (!RegExp(r'^[0-9a-fA-F]{40}$').hasMatch(sha)) {
    throw FileSystemException('git hash-object returned an invalid SHA.', path);
  }
  return sha;
}

void _printSection(String title, Iterable<String> values) {
  final items = values.toList(growable: false);
  if (items.isEmpty) {
    return;
  }

  print('$title:');
  for (final item in items) {
    print('- $item');
  }
}
