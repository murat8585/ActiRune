import 'package:flutter/foundation.dart';

import '../../battle/battle_session_engine.dart';

enum PhysicalValidationCamera { front, rear }

enum PhysicalValidationOrientation { portrait, landscape }

enum PhysicalValidationDisposition { pass, fail, needsThresholdReview }

enum PhysicalValidationCoverage {
  normalValid,
  incompleteMovement,
  incorrectForm,
  speedVariation,
  occlusionConfidenceLoss,
  cameraFramingVariation,
  leftRightOrientation,
  plankHoldValidation,
  duplicateReplay,
  battleIntegration,
  cameraLifecycle,
}

@immutable
final class PhysicalValidationRecord {
  const PhysicalValidationRecord({
    required this.commitSha,
    required this.build,
    required this.mlKitPackageVersion,
    required this.deviceModel,
    required this.osVersion,
    required this.camera,
    required this.orientation,
    required this.lighting,
    required this.framing,
    required this.corpusId,
    required this.sessionId,
    required this.movement,
    required this.expectedLabel,
    required this.expectedInvalidNonCountLabel,
    required this.observedAcceptedEvents,
    required this.observedRejectedEvents,
    required this.falsePositives,
    required this.falseNegatives,
    required this.occlusionConfidenceNotes,
    required this.duplicateReplayNotes,
    required this.performanceLifecycleNotes,
    required this.coverage,
    required this.reviewerDisposition,
    this.mediaHash,
  });

  factory PhysicalValidationRecord.fromJson(Map<String, Object?> json) {
    _rejectRawPersonalMediaFields(json);

    return PhysicalValidationRecord(
      commitSha: _requiredString(json, 'commitSha'),
      build: _requiredString(json, 'build'),
      mlKitPackageVersion: _requiredString(json, 'mlKitPackageVersion'),
      deviceModel: _requiredString(json, 'deviceModel'),
      osVersion: _requiredString(json, 'osVersion'),
      camera: _enumValue(
        PhysicalValidationCamera.values,
        _requiredString(json, 'camera'),
        'camera',
      ),
      orientation: _enumValue(
        PhysicalValidationOrientation.values,
        _requiredString(json, 'orientation'),
        'orientation',
      ),
      lighting: _requiredString(json, 'lighting'),
      framing: _requiredString(json, 'framing'),
      corpusId: _requiredString(json, 'corpusId'),
      sessionId: _requiredString(json, 'sessionId'),
      movement: _enumValue(
        VerifiedMovementType.values,
        _requiredString(json, 'movement'),
        'movement',
      ),
      expectedLabel: _requiredString(json, 'expectedLabel'),
      expectedInvalidNonCountLabel: _requiredString(
        json,
        'expectedInvalidNonCountLabel',
      ),
      observedAcceptedEvents: _nonNegativeInt(json, 'observedAcceptedEvents'),
      observedRejectedEvents: _nonNegativeInt(json, 'observedRejectedEvents'),
      falsePositives: _nonNegativeInt(json, 'falsePositives'),
      falseNegatives: _nonNegativeInt(json, 'falseNegatives'),
      occlusionConfidenceNotes: _requiredString(
        json,
        'occlusionConfidenceNotes',
      ),
      duplicateReplayNotes: _requiredString(json, 'duplicateReplayNotes'),
      performanceLifecycleNotes: _requiredString(
        json,
        'performanceLifecycleNotes',
      ),
      coverage: _coverageValues(json['coverage']),
      reviewerDisposition: _enumValue(
        PhysicalValidationDisposition.values,
        _requiredString(json, 'reviewerDisposition'),
        'reviewerDisposition',
      ),
      mediaHash: _optionalString(json['mediaHash']),
    );
  }

  final String commitSha;
  final String build;
  final String mlKitPackageVersion;
  final String deviceModel;
  final String osVersion;
  final PhysicalValidationCamera camera;
  final PhysicalValidationOrientation orientation;
  final String lighting;
  final String framing;
  final String corpusId;
  final String sessionId;
  final VerifiedMovementType movement;
  final String expectedLabel;
  final String expectedInvalidNonCountLabel;
  final int observedAcceptedEvents;
  final int observedRejectedEvents;
  final int falsePositives;
  final int falseNegatives;
  final String occlusionConfidenceNotes;
  final String duplicateReplayNotes;
  final String performanceLifecycleNotes;
  final Set<PhysicalValidationCoverage> coverage;
  final PhysicalValidationDisposition reviewerDisposition;
  final String? mediaHash;

  List<String> validateMetadata() {
    final issues = <String>[];

    if (!RegExp(r'^[0-9a-fA-F]{7,40}$').hasMatch(commitSha)) {
      issues.add('$sessionId: commitSha must be a 7-40 character git SHA.');
    }
    if (!RegExp(r'^[A-Za-z0-9._-]+$').hasMatch(corpusId)) {
      issues.add(
        '$sessionId: corpusId must be an anonymous machine-safe id, not a name.',
      );
    }
    if (!RegExp(r'^[A-Za-z0-9._-]+$').hasMatch(sessionId)) {
      issues.add('$sessionId: sessionId must be machine-safe.');
    }
    if (coverage.isEmpty) {
      issues.add('$sessionId: coverage must not be empty.');
    }

    return issues;
  }
}

@immutable
final class PhysicalValidationCorpus {
  const PhysicalValidationCorpus({
    required this.schemaVersion,
    required this.records,
  });

  factory PhysicalValidationCorpus.fromJson(Map<String, Object?> json) {
    final schemaVersion = json['schemaVersion'];
    if (schemaVersion is! int || schemaVersion != 1) {
      throw const FormatException('schemaVersion must be integer 1.');
    }

    final rawRecords = json['records'];
    if (rawRecords is! List<Object?>) {
      throw const FormatException('records must be a JSON array.');
    }

    final records = <PhysicalValidationRecord>[];
    for (var index = 0; index < rawRecords.length; index++) {
      final rawRecord = rawRecords[index];
      if (rawRecord is! Map<String, Object?>) {
        throw FormatException('records[$index] must be a JSON object.');
      }
      records.add(PhysicalValidationRecord.fromJson(rawRecord));
    }

    return PhysicalValidationCorpus(
      schemaVersion: schemaVersion,
      records: List.unmodifiable(records),
    );
  }

  final int schemaVersion;
  final List<PhysicalValidationRecord> records;

  PhysicalValidationEvidenceSummary summarize() {
    return PhysicalValidationEvidenceSummary.fromRecords(records);
  }
}

@immutable
final class PhysicalValidationEvidenceSummary {
  const PhysicalValidationEvidenceSummary._({
    required this.blockers,
    required this.warnings,
    required this.recordCount,
    required this.falsePositives,
    required this.falseNegatives,
    required this.failedRecords,
    required this.thresholdReviewRecords,
  });

  factory PhysicalValidationEvidenceSummary.fromRecords(
    List<PhysicalValidationRecord> records,
  ) {
    final blockers = <String>[];
    final warnings = <String>[];

    for (final record in records) {
      blockers.addAll(record.validateMetadata());
    }

    const phase1Movements = <VerifiedMovementType>{
      VerifiedMovementType.squat,
      VerifiedMovementType.lunge,
      VerifiedMovementType.pushUp,
      VerifiedMovementType.plank,
    };

    const perMovementCoverage = <PhysicalValidationCoverage>{
      PhysicalValidationCoverage.normalValid,
      PhysicalValidationCoverage.incompleteMovement,
      PhysicalValidationCoverage.incorrectForm,
      PhysicalValidationCoverage.speedVariation,
      PhysicalValidationCoverage.occlusionConfidenceLoss,
      PhysicalValidationCoverage.cameraFramingVariation,
      PhysicalValidationCoverage.duplicateReplay,
      PhysicalValidationCoverage.battleIntegration,
    };

    for (final movement in phase1Movements) {
      final movementRecords = records
          .where((record) => record.movement == movement)
          .toList(growable: false);
      if (movementRecords.isEmpty) {
        blockers.add('Missing physical-device evidence for ${movement.name}.');
        continue;
      }

      final covered = <PhysicalValidationCoverage>{
        for (final record in movementRecords) ...record.coverage,
      };
      final missing = perMovementCoverage.difference(covered);
      if (missing.isNotEmpty) {
        blockers.add(
          '${movement.name}: missing required coverage: '
          '${missing.map((value) => value.name).join(', ')}.',
        );
      }
    }

    final plankCoverage = <PhysicalValidationCoverage>{
      for (final record in records)
        if (record.movement == VerifiedMovementType.plank) ...record.coverage,
    };
    if (!plankCoverage.contains(
      PhysicalValidationCoverage.plankHoldValidation,
    )) {
      blockers.add('plank: missing plankHoldValidation coverage.');
    }

    if (!records.any(
      (record) =>
          record.coverage.contains(PhysicalValidationCoverage.cameraLifecycle),
    )) {
      blockers.add('Missing physical-device cameraLifecycle coverage.');
    }

    if (!records.any(
      (record) => record.coverage.contains(
        PhysicalValidationCoverage.leftRightOrientation,
      ),
    )) {
      warnings.add(
        'No leftRightOrientation evidence recorded; reviewer must confirm '
        'whether it is applicable to the tested detector/camera setups.',
      );
    }

    final lightingConditions = records
        .map((record) => record.lighting.trim().toLowerCase())
        .where((value) => value.isNotEmpty)
        .toSet();
    if (lightingConditions.length < 2) {
      warnings.add(
        'Only ${lightingConditions.length} distinct lighting description(s) '
        'recorded; protocol requires realistic variation, but no numeric '
        'release threshold is auto-invented.',
      );
    }

    final framingConditions = records
        .map((record) => record.framing.trim().toLowerCase())
        .where((value) => value.isNotEmpty)
        .toSet();
    if (framingConditions.length < 2) {
      warnings.add(
        'Only ${framingConditions.length} distinct framing description(s) '
        'recorded; protocol requires realistic variation, but no numeric '
        'release threshold is auto-invented.',
      );
    }

    return PhysicalValidationEvidenceSummary._(
      blockers: List.unmodifiable(blockers),
      warnings: List.unmodifiable(warnings),
      recordCount: records.length,
      falsePositives: records.fold(
        0,
        (total, record) => total + record.falsePositives,
      ),
      falseNegatives: records.fold(
        0,
        (total, record) => total + record.falseNegatives,
      ),
      failedRecords: records
          .where(
            (record) =>
                record.reviewerDisposition ==
                PhysicalValidationDisposition.fail,
          )
          .length,
      thresholdReviewRecords: records
          .where(
            (record) =>
                record.reviewerDisposition ==
                PhysicalValidationDisposition.needsThresholdReview,
          )
          .length,
    );
  }

  final List<String> blockers;
  final List<String> warnings;
  final int recordCount;
  final int falsePositives;
  final int falseNegatives;
  final int failedRecords;
  final int thresholdReviewRecords;

  /// Means the mandatory evidence structure is complete enough for a human
  /// release review. It deliberately does NOT mean the physical validation gate
  /// passed, because threshold/performance acceptance remains a reviewed
  /// product/engineering decision.
  bool get readyForHumanReview => blockers.isEmpty;
}

void _rejectRawPersonalMediaFields(Map<String, Object?> json) {
  const forbidden = <String>{
    'subjectName',
    'subjectRealName',
    'rawVideo',
    'rawVideoPath',
    'videoBytes',
    'faceId',
    'biometricId',
  };

  final found = json.keys.where(forbidden.contains).toList(growable: false);
  if (found.isNotEmpty) {
    throw FormatException(
      'Raw personal/biometric media fields are not allowed in repository '
      'evidence: ${found.join(', ')}.',
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

String? _optionalString(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is! String || value.trim().isEmpty) {
    throw const FormatException('Optional string values must be non-empty.');
  }
  return value.trim();
}

int _nonNegativeInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! int || value < 0) {
    throw FormatException('$key must be a non-negative integer.');
  }
  return value;
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

Set<PhysicalValidationCoverage> _coverageValues(Object? raw) {
  if (raw is! List<Object?> || raw.isEmpty) {
    throw const FormatException('coverage must be a non-empty JSON array.');
  }

  final values = <PhysicalValidationCoverage>{};
  for (final item in raw) {
    if (item is! String) {
      throw const FormatException('coverage entries must be strings.');
    }
    values.add(_enumValue(PhysicalValidationCoverage.values, item, 'coverage'));
  }
  return Set.unmodifiable(values);
}
