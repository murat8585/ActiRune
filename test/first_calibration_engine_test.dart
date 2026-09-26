import 'package:actirune/features/onboarding/first_calibration_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = FirstCalibrationEngine();

  test('complete standard evidence creates a non-medical starting profile', () {
    final assessment = engine.evaluate(_validInput());

    expect(assessment.readyForStartingProfile, isTrue);
    expect(assessment.blockers, isEmpty);
    expect(assessment.startingProfile, isNotNull);
    expect(assessment.startingProfile!.goalKey, 'general-fitness');
    expect(assessment.startingProfile!.preferredSessionMinutes, 20);
    expect(assessment.startingProfile!.experienceKey, 'starter');
    expect(
      assessment.startingProfile!.movementPreferences.keys.toSet(),
      CalibrationMovement.values.toSet(),
    );
  });

  test('camera and pose introduction is a hard readiness gate', () {
    final input = _validInput(cameraPoseIntroCompleted: false);
    final assessment = engine.evaluate(input);

    expect(assessment.readyForStartingProfile, isFalse);
    expect(
      assessment.blockers,
      contains(
        const CalibrationBlocker(
          code: CalibrationBlockerCode.cameraPoseIntroIncomplete,
        ),
      ),
    );
  });

  test('empty goal, invalid duration and experience block calibration', () {
    final input = _validInput(
      profile: const CalibrationProfileInput(
        goalKey: ' ',
        preferredSessionMinutes: 0,
        experienceKey: '',
      ),
    );
    final assessment = engine.evaluate(input);

    expect(assessment.readyForStartingProfile, isFalse);
    expect(
      assessment.blockers.map((blocker) => blocker.code),
      containsAll({
        CalibrationBlockerCode.goalMissing,
        CalibrationBlockerCode.preferredSessionDurationInvalid,
        CalibrationBlockerCode.experienceMissing,
      }),
    );
  });

  test('all four standing movements need preference and concrete evidence', () {
    final preferences =
        Map<CalibrationMovement, CalibrationMovementPreference>.from(
          _validPreferences(),
        )..remove(CalibrationMovement.crossBodyKneeRaise);
    final evidence = Map<CalibrationMovement, CalibrationMovementEvidence>.from(
      _validEvidence(),
    )..remove(CalibrationMovement.reverseLunge);

    final assessment = engine.evaluate(
      _validInput(preferences: preferences, evidence: evidence),
    );

    expect(
      assessment.blockers,
      contains(
        const CalibrationBlocker(
          code: CalibrationBlockerCode.movementPreferenceMissing,
          movement: CalibrationMovement.crossBodyKneeRaise,
        ),
      ),
    );
    expect(
      assessment.blockers,
      contains(
        const CalibrationBlocker(
          code: CalibrationBlockerCode.movementEvidenceMissing,
          movement: CalibrationMovement.reverseLunge,
        ),
      ),
    );
    expect(assessment.readyForStartingProfile, isFalse);
  });

  test(
    'alternative-required movement needs named alternative and matching evidence',
    () {
      final preferences =
          Map<CalibrationMovement, CalibrationMovementPreference>.from(
              _validPreferences(),
            )
            ..[CalibrationMovement
                .highKnee] = const CalibrationMovementPreference(
              movement: CalibrationMovement.highKnee,
              suitability: CalibrationMovementSuitability.alternativeRequired,
            );

      final assessment = engine.evaluate(_validInput(preferences: preferences));

      expect(
        assessment.blockers,
        contains(
          const CalibrationBlocker(
            code: CalibrationBlockerCode.alternativeMissing,
            movement: CalibrationMovement.highKnee,
          ),
        ),
      );
      expect(
        assessment.blockers,
        contains(
          const CalibrationBlocker(
            code: CalibrationBlockerCode.evidencePreferenceMismatch,
            movement: CalibrationMovement.highKnee,
          ),
        ),
      );
    },
  );

  test(
    'named High Knee alternative can be accepted without inventing difficulty',
    () {
      final preferences =
          Map<CalibrationMovement, CalibrationMovementPreference>.from(
              _validPreferences(),
            )
            ..[CalibrationMovement
                .highKnee] = const CalibrationMovementPreference(
              movement: CalibrationMovement.highKnee,
              suitability: CalibrationMovementSuitability.alternativeRequired,
              alternativeKey: 'supported-high-knee-variant',
            );
      final evidence =
          Map<CalibrationMovement, CalibrationMovementEvidence>.from(
              _validEvidence(),
            )
            ..[CalibrationMovement.highKnee] =
                const CalibrationMovementEvidence(
                  movement: CalibrationMovement.highKnee,
                  status: CalibrationEvidenceStatus.alternativeVerified,
                  evidenceId: 'attempt-high-knee-alt-1',
                );

      final assessment = engine.evaluate(
        _validInput(preferences: preferences, evidence: evidence),
      );

      expect(assessment.readyForStartingProfile, isTrue);
      expect(
        assessment
            .startingProfile!
            .movementPreferences[CalibrationMovement.highKnee]!
            .alternativeKey,
        'supported-high-knee-variant',
      );
    },
  );

  test('unverified or empty evidence cannot manufacture success', () {
    final evidence =
        Map<CalibrationMovement, CalibrationMovementEvidence>.from(
            _validEvidence(),
          )
          ..[CalibrationMovement.squat] = const CalibrationMovementEvidence(
            movement: CalibrationMovement.squat,
            status: CalibrationEvidenceStatus.notVerified,
            evidenceId: '',
          );

    final assessment = engine.evaluate(_validInput(evidence: evidence));

    expect(assessment.readyForStartingProfile, isFalse);
    expect(
      assessment.blockers,
      contains(
        const CalibrationBlocker(
          code: CalibrationBlockerCode.movementNotVerified,
          movement: CalibrationMovement.squat,
        ),
      ),
    );
  });
}

FirstCalibrationInput _validInput({
  CalibrationProfileInput profile = const CalibrationProfileInput(
    goalKey: 'general-fitness',
    preferredSessionMinutes: 20,
    experienceKey: 'starter',
  ),
  bool cameraPoseIntroCompleted = true,
  Map<CalibrationMovement, CalibrationMovementPreference>? preferences,
  Map<CalibrationMovement, CalibrationMovementEvidence>? evidence,
}) {
  return FirstCalibrationInput(
    profile: profile,
    cameraPoseIntroCompleted: cameraPoseIntroCompleted,
    preferences: preferences ?? _validPreferences(),
    evidence: evidence ?? _validEvidence(),
  );
}

Map<CalibrationMovement, CalibrationMovementPreference> _validPreferences() {
  return {
    for (final movement in CalibrationMovement.values)
      movement: CalibrationMovementPreference(
        movement: movement,
        suitability: CalibrationMovementSuitability.standard,
      ),
  };
}

Map<CalibrationMovement, CalibrationMovementEvidence> _validEvidence() {
  return {
    for (final movement in CalibrationMovement.values)
      movement: CalibrationMovementEvidence(
        movement: movement,
        status: CalibrationEvidenceStatus.standardVerified,
        evidenceId: 'attempt-${movement.name}-1',
      ),
  };
}
