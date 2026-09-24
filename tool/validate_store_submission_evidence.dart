// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:actirune/core/release/provider_authority_lock.dart';
import 'package:actirune/core/release/store_submission_evidence.dart';

void main(List<String> args) {
  if (args.length > 2) {
    stderr.writeln(
      'Usage: dart run tool/validate_store_submission_evidence.dart '
      '[authority.json] [store_submission.json]',
    );
    exitCode = 2;
    return;
  }

  final authorityPath = args.isEmpty
      ? 'validation/release/provider_authority.json'
      : args.first;
  final evidencePath = args.length < 2
      ? 'validation/release/store_submission.json'
      : args[1];

  final authorityFile = File(authorityPath);
  final evidenceFile = File(evidencePath);

  if (!authorityFile.existsSync()) {
    stderr.writeln('RESULT: BLOCKED_PROVIDER_AUTHORITY_MISSING');
    stderr.writeln('Provider authority lock not found: $authorityPath');
    exitCode = 1;
    return;
  }
  if (!evidenceFile.existsSync()) {
    stderr.writeln('RESULT: BLOCKED_STORE_SUBMISSION_EVIDENCE_MISSING');
    stderr.writeln('Store submission evidence not found: $evidencePath');
    exitCode = 1;
    return;
  }

  try {
    final authority = ProviderAuthorityLock.fromJson(
      _decodeObject(authorityFile, 'provider authority'),
    );
    final evidence = StoreSubmissionEvidence.fromJson(
      _decodeObject(evidenceFile, 'store submission evidence'),
    );
    final report = StoreSubmissionValidator.evaluate(
      authority: authority,
      evidence: evidence,
    );

    stdout.writeln('ActiRune store submission evidence');
    stdout.writeln('Release commit: ${evidence.releaseGitCommit}');
    stdout.writeln('Release build: ${evidence.releaseBuild}');
    stdout.writeln('Apple review state: ${evidence.apple.reviewState.name}');
    stdout.writeln(
      'Google Play review state: ${evidence.googlePlay.reviewState.name}',
    );
    stdout.writeln('Store references: NOT_PRINTED');
    stdout.writeln('Credentials/secrets: NOT_SUPPORTED');

    if (report.hasValidSubmissionEvidence) {
      stdout.writeln('RESULT: STORE_SUBMISSION_EVIDENCE_VALID');
      return;
    }

    if (report.isReadyForSubmission) {
      stdout.writeln('RESULT: READY_FOR_STORE_SUBMISSION');
    } else {
      stdout.writeln('RESULT: BLOCKED_STORE_SUBMISSION_EVIDENCE_INVALID');
    }
    for (final issue in report.issues) {
      stdout.writeln('- ${issue.name}');
    }
    exitCode = 1;
  } on FormatException catch (error) {
    stderr.writeln('RESULT: BLOCKED_STORE_SUBMISSION_EVIDENCE_SCHEMA');
    stderr.writeln(error.message);
    exitCode = 2;
  }
}

Map<String, Object?> _decodeObject(File file, String label) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map<String, Object?>) {
    throw FormatException('$label root must be a JSON object.');
  }
  return decoded;
}
