import 'dart:convert';
import 'dart:io';

import 'package:actirune/features/pose/validation/physical_validation_evidence.dart';

void main(List<String> args) {
  final path = args.isEmpty
      ? 'validation/physical_device_mlkit/evidence.json'
      : args.single;
  final file = File(path);

  if (!file.existsSync()) {
    stderr.writeln('Physical-device evidence file not found: $path');
    exitCode = 2;
    return;
  }

  try {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Evidence root must be a JSON object.');
    }

    final corpus = PhysicalValidationCorpus.fromJson(decoded);
    final summary = corpus.summarize();

    stdout.writeln('ActiRune physical-device ML Kit evidence summary');
    stdout.writeln('Records: ${summary.recordCount}');
    stdout.writeln('False positives observed: ${summary.falsePositives}');
    stdout.writeln('False negatives observed: ${summary.falseNegatives}');
    stdout.writeln('Reviewer FAIL records: ${summary.failedRecords}');
    stdout.writeln(
      'Threshold-review records: ${summary.thresholdReviewRecords}',
    );

    if (summary.warnings.isNotEmpty) {
      stdout.writeln('Warnings:');
      for (final warning in summary.warnings) {
        stdout.writeln('- $warning');
      }
    }

    if (!summary.readyForHumanReview) {
      stdout.writeln('RESULT: BLOCKED_EVIDENCE_INCOMPLETE');
      for (final blocker in summary.blockers) {
        stdout.writeln('- $blocker');
      }
      exitCode = 1;
      return;
    }

    stdout.writeln('RESULT: READY_FOR_HUMAN_REVIEW');
    stdout.writeln(
      'This result is not a release PASS. Human review of real-device evidence, '
      'thresholds and supported-device scope remains mandatory.',
    );
  } on FormatException catch (error) {
    stderr.writeln('Evidence schema error: ${error.message}');
    exitCode = 2;
  } on JsonUnsupportedObjectError catch (error) {
    stderr.writeln('Evidence JSON error: $error');
    exitCode = 2;
  }
}
