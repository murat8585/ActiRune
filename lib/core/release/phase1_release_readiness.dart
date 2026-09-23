import 'package:flutter/foundation.dart';

import '../../features/pose/validation/physical_validation_evidence.dart';
import 'production_release_guard.dart';

enum ProviderReleaseState {
  undecided,
  lockedNotConfigured,
  configured,
}

enum PhysicalValidationFinalReview { pending, passed, failed }

enum Phase1ReleaseBlocker {
  productionIdentityOrSigning,
  providerAuthorityUndecided,
  providerConfigurationIncomplete,
  physicalEvidenceMissing,
  physicalEvidenceIncomplete,
  physicalEvidenceHasFailedRecords,
  physicalThresholdReviewOutstanding,
  physicalHumanReviewPending,
  physicalHumanReviewFailed,
}

@immutable
final class Phase1ReleaseReadinessEvidence {
  const Phase1ReleaseReadinessEvidence({
    required this.productionRelease,
    required this.providerState,
    required this.physicalFinalReview,
    this.physicalEvidence,
  });

  final ProductionReleaseReport productionRelease;
  final ProviderReleaseState providerState;
  final PhysicalValidationEvidenceSummary? physicalEvidence;
  final PhysicalValidationFinalReview physicalFinalReview;
}

@immutable
final class Phase1ReleaseReadinessReport {
  const Phase1ReleaseReadinessReport({
    required this.blockers,
    required this.productionIssues,
    required this.providerState,
    required this.physicalFinalReview,
  });

  final List<Phase1ReleaseBlocker> blockers;
  final List<ProductionReleaseIssue> productionIssues;
  final ProviderReleaseState providerState;
  final PhysicalValidationFinalReview physicalFinalReview;

  /// True only when every gate represented by this aggregate report is
  /// explicitly satisfied. This is not a substitute for store review, signing
  /// secret provenance, provider-console verification or other external release
  /// evidence that is not represented by the supplied inputs.
  bool get allDeclaredGatesSatisfied => blockers.isEmpty;
}

abstract final class Phase1ReleaseReadiness {
  static Phase1ReleaseReadinessReport evaluate(
    Phase1ReleaseReadinessEvidence evidence,
  ) {
    final blockers = <Phase1ReleaseBlocker>[];

    if (!evidence.productionRelease.isReady) {
      blockers.add(Phase1ReleaseBlocker.productionIdentityOrSigning);
    }

    switch (evidence.providerState) {
      case ProviderReleaseState.undecided:
        blockers.add(Phase1ReleaseBlocker.providerAuthorityUndecided);
      case ProviderReleaseState.lockedNotConfigured:
        blockers.add(Phase1ReleaseBlocker.providerConfigurationIncomplete);
      case ProviderReleaseState.configured:
        break;
    }

    final physicalEvidence = evidence.physicalEvidence;
    if (physicalEvidence == null) {
      blockers.add(Phase1ReleaseBlocker.physicalEvidenceMissing);
    } else {
      if (!physicalEvidence.readyForHumanReview) {
        blockers.add(Phase1ReleaseBlocker.physicalEvidenceIncomplete);
      }
      if (physicalEvidence.failedRecords > 0) {
        blockers.add(Phase1ReleaseBlocker.physicalEvidenceHasFailedRecords);
      }
      if (physicalEvidence.thresholdReviewRecords > 0) {
        blockers.add(
          Phase1ReleaseBlocker.physicalThresholdReviewOutstanding,
        );
      }
    }

    switch (evidence.physicalFinalReview) {
      case PhysicalValidationFinalReview.pending:
        blockers.add(Phase1ReleaseBlocker.physicalHumanReviewPending);
      case PhysicalValidationFinalReview.failed:
        blockers.add(Phase1ReleaseBlocker.physicalHumanReviewFailed);
      case PhysicalValidationFinalReview.passed:
        if (physicalEvidence == null ||
            !physicalEvidence.readyForHumanReview ||
            physicalEvidence.failedRecords > 0 ||
            physicalEvidence.thresholdReviewRecords > 0) {
          blockers.add(Phase1ReleaseBlocker.physicalHumanReviewFailed);
        }
    }

    return Phase1ReleaseReadinessReport(
      blockers: List.unmodifiable(blockers.toSet()),
      productionIssues: List.unmodifiable(evidence.productionRelease.issues),
      providerState: evidence.providerState,
      physicalFinalReview: evidence.physicalFinalReview,
    );
  }
}
