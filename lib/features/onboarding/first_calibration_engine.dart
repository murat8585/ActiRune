import 'package:flutter/foundation.dart';

enum CalibrationMovement { squat, lunge, pushUp, plank }

enum CalibrationMovementSuitability { standard, alternativeRequired }

enum CalibrationEvidenceStatus {
  notVerified,
  standardVerified,
  alternativeVerified,
}

enum CalibrationBlockerCode {
  goalMissing,
  preferredSessionDurationInvalid,
  experienceMissing,
  cameraPoseIntroIncomplete,
  movementPreferenceMissing,
  movementEvidenceMissing,
  alternativeMissing,
  movementNotVerified,
  evidencePreferenceMismatch,
}

@immutable
class CalibrationProfileInput {
  const CalibrationProfileInput({
    required this.goalKey,
    required this.preferredSessionMinutes,
    required this.experienceKey,
  });

  /// Product-owned opaque key. This domain layer deliberately does not invent
  /// goal categories or medical meaning.
  final String goalKey;
  final int preferredSessionMinutes;

  /// Product-owned opaque key. Numeric difficulty mapping remains external.
  final String experienceKey;
}

@immutable
class CalibrationMovementPreference {
  const CalibrationMovementPreference({
    required this.movement,
    required this.suitability,
    this.alternativeKey,
  });

  final CalibrationMovement movement;
  final CalibrationMovementSuitability suitability;

  /// Product-owned safe alternative/variation key. No medical diagnosis is
  /// inferred from the need for an alternative.
  final String? alternativeKey;
}

@immutable
class CalibrationMovementEvidence {
  const CalibrationMovementEvidence({
    required this.movement,
    required this.status,
    required this.evidenceId,
  });

  final CalibrationMovement movement;
  final CalibrationEvidenceStatus status;

  /// Opaque caller-owned reference to the concrete calibration attempt/result.
  /// This engine does not fabricate pose or rep evidence.
  final String evidenceId;
}

@immutable
class FirstCalibrationInput {
  const FirstCalibrationInput({
    required this.profile,
    required this.cameraPoseIntroCompleted,
    required this.preferences,
    required this.evidence,
  });

  final CalibrationProfileInput profile;
  final bool cameraPoseIntroCompleted;
  final Map<CalibrationMovement, CalibrationMovementPreference> preferences;
  final Map<CalibrationMovement, CalibrationMovementEvidence> evidence;
}

@immutable
class CalibrationBlocker {
  const CalibrationBlocker({
    required this.code,
    this.movement,
  });

  final CalibrationBlockerCode code;
  final CalibrationMovement? movement;

  @override
  bool operator ==(Object other) =>
      other is CalibrationBlocker &&
      other.code == code &&
      other.movement == movement;

  @override
  int get hashCode => Object.hash(code, movement);
}

@immutable
class StartingCalibrationProfile {
  StartingCalibrationProfile({
    required this.goalKey,
    required this.preferredSessionMinutes,
    required this.experienceKey,
    required Map<CalibrationMovement, CalibrationMovementPreference>
        movementPreferences,
  }) : movementPreferences = Map.unmodifiable(movementPreferences);

  final String goalKey;
  final int preferredSessionMinutes;
  final String experienceKey;
  final Map<CalibrationMovement, CalibrationMovementPreference>
      movementPreferences;
}

@immutable
class FirstCalibrationAssessment {
  FirstCalibrationAssessment._({
    required List<CalibrationBlocker> blockers,
    required this.startingProfile,
  }) : blockers = List.unmodifiable(blockers);

  final List<CalibrationBlocker> blockers;
  final StartingCalibrationProfile? startingProfile;

  bool get readyForStartingProfile =>
      blockers.isEmpty && startingProfile != null;
}

/// Fail-closed owner for First Calibration domain readiness.
///
/// This engine evaluates product-required profile inputs, camera/pose intro,
/// movement suitability/preferences and caller-supplied movement evidence. It
/// deliberately does not choose medical categories, pose thresholds, rep counts
/// or numeric difficulty values.
class FirstCalibrationEngine {
  const FirstCalibrationEngine();

  FirstCalibrationAssessment evaluate(FirstCalibrationInput input) {
    final blockers = <CalibrationBlocker>[];
    final profile = input.profile;

    if (profile.goalKey.trim().isEmpty) {
      blockers.add(
        const CalibrationBlocker(code: CalibrationBlockerCode.goalMissing),
      );
    }
    if (profile.preferredSessionMinutes <= 0) {
      blockers.add(
        const CalibrationBlocker(
          code: CalibrationBlockerCode.preferredSessionDurationInvalid,
        ),
      );
    }
    if (profile.experienceKey.trim().isEmpty) {
      blockers.add(
        const CalibrationBlocker(code: CalibrationBlockerCode.experienceMissing),
      );
    }
    if (!input.cameraPoseIntroCompleted) {
      blockers.add(
        const CalibrationBlocker(
          code: CalibrationBlockerCode.cameraPoseIntroIncomplete,
        ),
      );
    }

    for (final movement in CalibrationMovement.values) {
      final preference = input.preferences[movement];
      if (preference == null || preference.movement != movement) {
        blockers.add(
          CalibrationBlocker(
            code: CalibrationBlockerCode.movementPreferenceMissing,
            movement: movement,
          ),
        );
        continue;
      }

      final requiresAlternative =
          preference.suitability ==
          CalibrationMovementSuitability.alternativeRequired;
      if (requiresAlternative &&
          (preference.alternativeKey == null ||
              preference.alternativeKey!.trim().isEmpty)) {
        blockers.add(
          CalibrationBlocker(
            code: CalibrationBlockerCode.alternativeMissing,
            movement: movement,
          ),
        );
      }

      final movementEvidence = input.evidence[movement];
      if (movementEvidence == null || movementEvidence.movement != movement) {
        blockers.add(
          CalibrationBlocker(
            code: CalibrationBlockerCode.movementEvidenceMissing,
            movement: movement,
          ),
        );
        continue;
      }
      if (movementEvidence.evidenceId.trim().isEmpty ||
          movementEvidence.status == CalibrationEvidenceStatus.notVerified) {
        blockers.add(
          CalibrationBlocker(
            code: CalibrationBlockerCode.movementNotVerified,
            movement: movement,
          ),
        );
        continue;
      }

      final expectedEvidence = requiresAlternative
          ? CalibrationEvidenceStatus.alternativeVerified
          : CalibrationEvidenceStatus.standardVerified;
      if (movementEvidence.status != expectedEvidence) {
        blockers.add(
          CalibrationBlocker(
            code: CalibrationBlockerCode.evidencePreferenceMismatch,
            movement: movement,
          ),
        );
      }
    }

    if (blockers.isNotEmpty) {
      return FirstCalibrationAssessment._(
        blockers: blockers,
        startingProfile: null,
      );
    }

    return FirstCalibrationAssessment._(
      blockers: const [],
      startingProfile: StartingCalibrationProfile(
        goalKey: profile.goalKey.trim(),
        preferredSessionMinutes: profile.preferredSessionMinutes,
        experienceKey: profile.experienceKey.trim(),
        movementPreferences: input.preferences,
      ),
    );
  }
}
