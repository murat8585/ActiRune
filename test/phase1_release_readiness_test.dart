import 'package:actirune/core/release/phase1_release_readiness.dart';
import 'package:actirune/core/release/production_release_guard.dart';
import 'package:actirune/features/battle/battle_session_engine.dart';
import 'package:actirune/features/pose/validation/physical_validation_evidence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('current external blockers cannot produce a green aggregate report', () {
    final report = Phase1ReleaseReadiness.evaluate(
      Phase1ReleaseReadinessEvidence(
        productionRelease: ProductionReleaseGuard.evaluate(
          const ProductionReleaseEvidence(
            androidApplicationId: 'com.example.actirune',
            androidReleaseSigningConfigured: true,
            androidUsesDebugSigning: true,
            iosBundleIdentifier: 'com.example.actirune',
            iosDevelopmentTeam: null,
          ),
        ),
        providerState: ProviderReleaseState.undecided,
        physicalFinalReview: PhysicalValidationFinalReview.pending,
      ),
    );

    expect(report.allDeclaredGatesSatisfied, isFalse);
    expect(
      report.blockers,
      containsAll(<Phase1ReleaseBlocker>[
        Phase1ReleaseBlocker.productionIdentityOrSigning,
        Phase1ReleaseBlocker.providerAuthorityUndecided,
        Phase1ReleaseBlocker.physicalEvidenceMissing,
        Phase1ReleaseBlocker.physicalHumanReviewPending,
      ]),
    );
  });

  test('provider lock without real configuration remains blocked', () {
    final report = Phase1ReleaseReadiness.evaluate(
      Phase1ReleaseReadinessEvidence(
        productionRelease: _readyProductionReport(),
        providerState: ProviderReleaseState.lockedNotConfigured,
        physicalEvidence: _completePhysicalSummary(),
        physicalFinalReview: PhysicalValidationFinalReview.passed,
      ),
    );

    expect(report.allDeclaredGatesSatisfied, isFalse);
    expect(
      report.blockers,
      [Phase1ReleaseBlocker.providerConfigurationIncomplete],
    );
  });

  test('physical evidence must be structurally complete before final pass', () {
    final incompleteSummary = PhysicalValidationEvidenceSummary.fromRecords([
      _record(VerifiedMovementType.squat),
    ]);

    final report = Phase1ReleaseReadiness.evaluate(
      Phase1ReleaseReadinessEvidence(
        productionRelease: _readyProductionReport(),
        providerState: ProviderReleaseState.configured,
        physicalEvidence: incompleteSummary,
        physicalFinalReview: PhysicalValidationFinalReview.passed,
      ),
    );

    expect(report.allDeclaredGatesSatisfied, isFalse);
    expect(
      report.blockers,
      containsAll(<Phase1ReleaseBlocker>[
        Phase1ReleaseBlocker.physicalEvidenceIncomplete,
        Phase1ReleaseBlocker.physicalHumanReviewFailed,
      ]),
    );
  });

  test('failed physical record blocks even when final review says passed', () {
    final summary = _completePhysicalSummary(
      squatDisposition: PhysicalValidationDisposition.fail,
    );

    final report = Phase1ReleaseReadiness.evaluate(
      Phase1ReleaseReadinessEvidence(
        productionRelease: _readyProductionReport(),
        providerState: ProviderReleaseState.configured,
        physicalEvidence: summary,
        physicalFinalReview: PhysicalValidationFinalReview.passed,
      ),
    );

    expect(report.allDeclaredGatesSatisfied, isFalse);
    expect(
      report.blockers,
      containsAll(<Phase1ReleaseBlocker>[
        Phase1ReleaseBlocker.physicalEvidenceHasFailedRecords,
        Phase1ReleaseBlocker.physicalHumanReviewFailed,
      ]),
    );
  });

  test('outstanding threshold review blocks automatic green', () {
    final summary = _completePhysicalSummary(
      plankDisposition: PhysicalValidationDisposition.needsThresholdReview,
    );

    final report = Phase1ReleaseReadiness.evaluate(
      Phase1ReleaseReadinessEvidence(
        productionRelease: _readyProductionReport(),
        providerState: ProviderReleaseState.configured,
        physicalEvidence: summary,
        physicalFinalReview: PhysicalValidationFinalReview.passed,
      ),
    );

    expect(report.allDeclaredGatesSatisfied, isFalse);
    expect(
      report.blockers,
      containsAll(<Phase1ReleaseBlocker>[
        Phase1ReleaseBlocker.physicalThresholdReviewOutstanding,
        Phase1ReleaseBlocker.physicalHumanReviewFailed,
      ]),
    );
  });

  test('all declared gates must be explicitly satisfied for aggregate green', () {
    final report = Phase1ReleaseReadiness.evaluate(
      Phase1ReleaseReadinessEvidence(
        productionRelease: _readyProductionReport(),
        providerState: ProviderReleaseState.configured,
        physicalEvidence: _completePhysicalSummary(),
        physicalFinalReview: PhysicalValidationFinalReview.passed,
      ),
    );

    expect(report.blockers, isEmpty);
    expect(report.productionIssues, isEmpty);
    expect(report.allDeclaredGatesSatisfied, isTrue);
  });
}

ProductionReleaseReport _readyProductionReport() {
  return ProductionReleaseGuard.evaluate(
    const ProductionReleaseEvidence(
      androidApplicationId: 'com.actirune.app',
      androidReleaseSigningConfigured: true,
      androidUsesDebugSigning: false,
      iosBundleIdentifier: 'com.actirune.app',
      iosDevelopmentTeam: 'TEAM123456',
    ),
  );
}

PhysicalValidationEvidenceSummary _completePhysicalSummary({
  PhysicalValidationDisposition squatDisposition =
      PhysicalValidationDisposition.pass,
  PhysicalValidationDisposition plankDisposition =
      PhysicalValidationDisposition.pass,
}) {
  return PhysicalValidationEvidenceSummary.fromRecords([
    _record(
      VerifiedMovementType.squat,
      disposition: squatDisposition,
      extraCoverage: const {PhysicalValidationCoverage.cameraLifecycle},
      lighting: 'normal indoor',
      framing: 'full body centered',
    ),
    _record(
      VerifiedMovementType.lunge,
      extraCoverage: const {PhysicalValidationCoverage.leftRightOrientation},
      lighting: 'bright indoor',
      framing: 'full body left offset',
    ),
    _record(
      VerifiedMovementType.pushUp,
      lighting: 'normal indoor',
      framing: 'side full body',
    ),
    _record(
      VerifiedMovementType.plank,
      disposition: plankDisposition,
      extraCoverage: const {PhysicalValidationCoverage.plankHoldValidation},
      lighting: 'bright indoor',
      framing: 'side full body',
    ),
  ]);
}

PhysicalValidationRecord _record(
  VerifiedMovementType movement, {
  PhysicalValidationDisposition disposition = PhysicalValidationDisposition.pass,
  Set<PhysicalValidationCoverage> extraCoverage = const {},
  String lighting = 'normal indoor',
  String framing = 'full body',
}) {
  return PhysicalValidationRecord(
    commitSha: '58686e9b5337de7a82885b2391911946e2c99cd4',
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
    expectedLabel: 'labelled expected result',
    expectedInvalidNonCountLabel: 'labelled invalid/non-count segments',
    observedAcceptedEvents: 1,
    observedRejectedEvents: 1,
    falsePositives: 0,
    falseNegatives: 0,
    occlusionConfidenceNotes: 'recorded',
    duplicateReplayNotes: 'recorded',
    performanceLifecycleNotes: 'recorded',
    coverage: Set.unmodifiable(<PhysicalValidationCoverage>{
      PhysicalValidationCoverage.normalValid,
      PhysicalValidationCoverage.incompleteMovement,
      PhysicalValidationCoverage.incorrectForm,
      PhysicalValidationCoverage.speedVariation,
      PhysicalValidationCoverage.occlusionConfidenceLoss,
      PhysicalValidationCoverage.cameraFramingVariation,
      PhysicalValidationCoverage.duplicateReplay,
      PhysicalValidationCoverage.battleIntegration,
      ...extraCoverage,
    }),
    reviewerDisposition: disposition,
  );
}
