import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'first_calibration_engine.dart';

enum CalibrationStatus { notStarted, inProgress, completed, skipped }

@immutable
class CalibrationAppState {
  const CalibrationAppState({required this.status, this.startingProfile})
    : assert(
        (status == CalibrationStatus.completed) == (startingProfile != null),
      );

  const CalibrationAppState.notStarted()
    : this(status: CalibrationStatus.notStarted);

  const CalibrationAppState.inProgress()
    : this(status: CalibrationStatus.inProgress);

  const CalibrationAppState.skipped() : this(status: CalibrationStatus.skipped);

  factory CalibrationAppState.completed(StartingCalibrationProfile profile) =>
      CalibrationAppState(
        status: CalibrationStatus.completed,
        startingProfile: profile,
      );

  final CalibrationStatus status;
  final StartingCalibrationProfile? startingProfile;

  bool get hasCompletedCalibration =>
      status == CalibrationStatus.completed && startingProfile != null;
}

abstract interface class CalibrationStateStore {
  Future<CalibrationAppState> read();

  Future<void> write(CalibrationAppState state);
}

/// In-memory store for embedded use and tests. Production passes the
/// SharedPreferences-backed store from main().
class InMemoryCalibrationStateStore implements CalibrationStateStore {
  InMemoryCalibrationStateStore([
    this._state = const CalibrationAppState.notStarted(),
  ]);

  CalibrationAppState _state;

  @override
  Future<CalibrationAppState> read() async => _state;

  @override
  Future<void> write(CalibrationAppState state) async {
    _state = state;
  }
}

class SharedPreferencesCalibrationStateStore implements CalibrationStateStore {
  SharedPreferencesCalibrationStateStore(this.preferences);

  static const storageKey = 'actirune.calibration_state.v1';

  final SharedPreferences preferences;

  @override
  Future<CalibrationAppState> read() async {
    final json = preferences.getString(storageKey);
    if (json == null) return const CalibrationAppState.notStarted();

    try {
      final decoded = jsonDecode(json);
      if (decoded is! Map<String, dynamic>) {
        return const CalibrationAppState.notStarted();
      }
      final status = CalibrationStatus.values.byName(
        decoded['status'] as String,
      );
      if (status != CalibrationStatus.completed) {
        return CalibrationAppState(status: status);
      }

      final profileJson = decoded['startingProfile'];
      if (profileJson is! Map<String, dynamic>) {
        return const CalibrationAppState.inProgress();
      }
      return CalibrationAppState.completed(_profileFromJson(profileJson));
    } on Object {
      // Corrupt or old local state never becomes a successful calibration.
      return const CalibrationAppState.notStarted();
    }
  }

  @override
  Future<void> write(CalibrationAppState state) async {
    final data = <String, Object?>{'status': state.status.name};
    if (state.hasCompletedCalibration) {
      data['startingProfile'] = _profileToJson(state.startingProfile!);
    }
    final saved = await preferences.setString(storageKey, jsonEncode(data));
    if (!saved) {
      throw StateError('Calibration state could not be stored');
    }
  }

  static Map<String, Object?> _profileToJson(
    StartingCalibrationProfile profile,
  ) {
    return {
      'goalKey': profile.goalKey,
      'preferredSessionMinutes': profile.preferredSessionMinutes,
      'experienceKey': profile.experienceKey,
      'movementPreferences': [
        for (final entry in profile.movementPreferences.entries)
          {
            'movement': entry.key.name,
            'suitability': entry.value.suitability.name,
            'alternativeKey': entry.value.alternativeKey,
          },
      ],
    };
  }

  static StartingCalibrationProfile _profileFromJson(
    Map<String, dynamic> json,
  ) {
    final preferencesJson = json['movementPreferences'];
    if (preferencesJson is! List<dynamic>) {
      throw const FormatException('Missing movement preferences');
    }
    final preferences = <CalibrationMovement, CalibrationMovementPreference>{};
    for (final item in preferencesJson) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Invalid movement preference');
      }
      final movement = CalibrationMovement.values.byName(
        item['movement'] as String,
      );
      final suitability = CalibrationMovementSuitability.values.byName(
        item['suitability'] as String,
      );
      preferences[movement] = CalibrationMovementPreference(
        movement: movement,
        suitability: suitability,
        alternativeKey: item['alternativeKey'] as String?,
      );
    }
    if (preferences.length != CalibrationMovement.values.length) {
      throw const FormatException('Incomplete movement preferences');
    }

    return StartingCalibrationProfile(
      goalKey: json['goalKey'] as String,
      preferredSessionMinutes: json['preferredSessionMinutes'] as int,
      experienceKey: json['experienceKey'] as String,
      movementPreferences: preferences,
    );
  }
}
