import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:actirune/features/pose/validation/physical_validation_evidence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('complete Phase-1 evidence becomes ready for human review only', () {
    final records = <PhysicalValidationRecord>[
      _record(
        movement: VerifiedMovementType.squat,
        lighting: 'normal indoor',
        framing: 'full body centered',
        extraCoverage: const {PhysicalValidationCoverage.cameraLifecycle},
      ),
      _record(
        movement: VerifiedMovementType.lunge,
        lighting: 'bright indoor',
        framing: 'full body left offset',
        extraCoverage: const {PhysicalValidationCoverage.leftRightOrientation},
      ),
      _record(
        movement: VerifiedMovementType.pushUp,
        lighting: 'normal indoor',
        framing: 'side full body',
      ),
      _record(
        movement: VerifiedMovementType.plank,
        lighting: 'bright indoor',
        framing: 'side full body',
        disposition: PhysicalValidationDisposition.needsThresholdReview,
        extraCoverage: const {PhysicalValidationCoverage.plankHoldValidation},
      ),
    ];

    final summary = PhysicalValidationEvidenceSummary.fromRecords(records);

    expect(summary.readyForHumanReview, isTrue);
    expect(summary.blockers, isEmpty);
    expect(summary.thresholdReviewRecords, 1);
    expect(summary.recordCount, 4);
  });

  test('missing movement and end-to-end coverage remain blocked', () {
    final summary = PhysicalValidationEvidenceSummary.fromRecords([
      _record(
        movement: VerifiedMovementType.squat,
        lighting: 'normal indoor',
        framing: 'full body centered',
        removeCoverage: const {PhysicalValidationCoverage.battleIntegration},
      ),
    ]);

    expect(summary.readyForHumanReview, isFalse);
    expect(
      summary.blockers,
      contains(contains('squat: missing required coverage: battleIntegration')),
    );
    expect(
      summary.blockers,
      contains(contains('Missing physical-device evidence for lunge')),
    );
    expect(
      summary.blockers,
      contains(contains('Missing physical-device evidence for pushUp')),
    );
    expect(
      summary.blockers,
      contains(contains('Missing physical-device evidence for plank')),
    );
  });

  test(
    'reviewer FAIL is surfaced but never converted into an automatic gate',
    () {
      final records = <PhysicalValidationRecord>[
        _record(
          movement: VerifiedMovementType.squat,
          lighting: 'normal indoor',
          framing: 'full body centered',
          disposition: PhysicalValidationDisposition.fail,
          extraCoverage: const {PhysicalValidationCoverage.cameraLifecycle},
        ),
        _record(
          movement: VerifiedMovementType.lunge,
          lighting: 'bright indoor',
          framing: 'left offset',
          extraCoverage: const {
            PhysicalValidationCoverage.leftRightOrientation,
          },
        ),
        _record(
          movement: VerifiedMovementType.pushUp,
          lighting: 'normal indoor',
          framing: 'side full body',
        ),
        _record(
          movement: VerifiedMovementType.plank,
          lighting: 'bright indoor',
          framing: 'side full body',
          extraCoverage: const {PhysicalValidationCoverage.plankHoldValidation},
        ),
      ];

      final summary = PhysicalValidationEvidenceSummary.fromRecords(records);

      expect(summary.readyForHumanReview, isTrue);
      expect(summary.failedRecords, 1);
    },
  );

  test('raw personal media fields are rejected from repository evidence', () {
    final json = _recordJson(VerifiedMovementType.squat);
    json['rawVideoPath'] = '/private/person.mov';

    expect(
      () => PhysicalValidationRecord.fromJson(json),
      throwsA(isA<FormatException>()),
    );
  });

  test('invalid commit SHA is reported as a metadata blocker', () {
    final record = PhysicalValidationRecord.fromJson(
      _recordJson(VerifiedMovementType.squat)..['commitSha'] = 'not-a-sha',
    );

    expect(record.validateMetadata(), isNotEmpty);
  });

  test('JSON corpus parser requires schema version 1 and record array', () {
    expect(
      () => PhysicalValidationCorpus.fromJson(const {
        'schemaVersion': 2,
        'records': <Object?>[],
      }),
      throwsA(isA<FormatException>()),
    );

    final corpus = PhysicalValidationCorpus.fromJson({
      'schemaVersion': 1,
      'records': [_recordJson(VerifiedMovementType.squat)],
    });

    expect(corpus.schemaVersion, 1);
    expect(corpus.records, hasLength(1));
  });
}

PhysicalValidationRecord _record({
  required VerifiedMovementType movement,
  required String lighting,
  required String framing,
  PhysicalValidationDisposition disposition =
      PhysicalValidationDisposition.pass,
  Set<PhysicalValidationCoverage> extraCoverage = const {},
  Set<PhysicalValidationCoverage> removeCoverage = const {},
}) {
  final coverage = <PhysicalValidationCoverage>{
    PhysicalValidationCoverage.normalValid,
    PhysicalValidationCoverage.incompleteMovement,
    PhysicalValidationCoverage.incorrectForm,
    PhysicalValidationCoverage.speedVariation,
    PhysicalValidationCoverage.occlusionConfidenceLoss,
    PhysicalValidationCoverage.cameraFramingVariation,
    PhysicalValidationCoverage.duplicateReplay,
    PhysicalValidationCoverage.battleIntegration,
    ...extraCoverage,
  }..removeAll(removeCoverage);

  return PhysicalValidationRecord(
    commitSha: '26e060538ef8fdd7bc1f3f67c827a690ad130a41',
    build: '0.1.0+1',
    mlKitPackageVersion: '0.16.1',
    deviceModel: 'anonymous-device-class',
    osVersion: 'test-os',
    camera: PhysicalValidationCamera.front,
    orientation: PhysicalValidationOrientation.portrait,
    lighting: lighting,
    framing: framing,
    corpusId: 'subject-001',
    sessionId: 'session-${movement.name}',
    movement: movement,
    expectedLabel: 'labelled expected movement result',
    expectedInvalidNonCountLabel: 'labelled invalid and non-count segments',
    observedAcceptedEvents: 1,
    observedRejectedEvents: 1,
    falsePositives: 0,
    falseNegatives: 0,
    occlusionConfidenceNotes: 'recorded',
    duplicateReplayNotes: 'recorded',
    performanceLifecycleNotes: 'recorded',
    coverage: Set.unmodifiable(coverage),
    reviewerDisposition: disposition,
  );
}

Map<String, Object?> _recordJson(VerifiedMovementType movement) {
  return <String, Object?>{
    'commitSha': '26e060538ef8fdd7bc1f3f67c827a690ad130a41',
    'build': '0.1.0+1',
    'mlKitPackageVersion': '0.16.1',
    'deviceModel': 'anonymous-device-class',
    'osVersion': 'test-os',
    'camera': 'front',
    'orientation': 'portrait',
    'lighting': 'normal indoor',
    'framing': 'full body centered',
    'corpusId': 'subject-001',
    'sessionId': 'session-${movement.name}',
    'movement': movement.name,
    'expectedLabel': 'labelled expected movement result',
    'expectedInvalidNonCountLabel': 'labelled invalid and non-count segments',
    'observedAcceptedEvents': 1,
    'observedRejectedEvents': 1,
    'falsePositives': 0,
    'falseNegatives': 0,
    'occlusionConfidenceNotes': 'recorded',
    'duplicateReplayNotes': 'recorded',
    'performanceLifecycleNotes': 'recorded',
    'coverage': <String>[
      PhysicalValidationCoverage.normalValid.name,
      PhysicalValidationCoverage.incompleteMovement.name,
      PhysicalValidationCoverage.incorrectForm.name,
      PhysicalValidationCoverage.speedVariation.name,
      PhysicalValidationCoverage.occlusionConfidenceLoss.name,
      PhysicalValidationCoverage.cameraFramingVariation.name,
      PhysicalValidationCoverage.duplicateReplay.name,
      PhysicalValidationCoverage.battleIntegration.name,
    ],
    'reviewerDisposition': PhysicalValidationDisposition.pass.name,
  };
}
