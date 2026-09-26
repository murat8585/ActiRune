import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/actirune_app.dart';
import 'features/onboarding/calibration_app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final store = SharedPreferencesCalibrationStateStore(preferences);
  final initialState = await store.read();
  runApp(
    ActiRuneApp(
      calibrationStateStore: store,
      initialCalibrationState: initialState,
    ),
  );
}
