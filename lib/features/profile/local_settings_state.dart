import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LocalSetting {
  questReminders,
  events,
  social,
  runeLeague,
  system,
  highContrast,
  reducedAnimation,
  haptics,
  audioCues,
}

/// Device-local preference intent. It does not grant OS permissions, schedule
/// notifications, or mutate account/server privacy settings.
class LocalSettingsOwner extends ChangeNotifier {
  LocalSettingsOwner(this._preferences) {
    for (final setting in LocalSetting.values) {
      _values[setting] = _preferences?.getBool(_key(setting));
    }
  }

  final SharedPreferences? _preferences;
  final Map<LocalSetting, bool?> _values = {};

  bool? value(LocalSetting setting) => _values[setting];

  Future<bool> toggle(LocalSetting setting) async {
    final next = !(_values[setting] ?? false);
    if (_preferences != null &&
        !await _preferences.setBool(_key(setting), next)) {
      return false;
    }
    _values[setting] = next;
    notifyListeners();
    return true;
  }

  static String _key(LocalSetting setting) =>
      'actirune.local-setting.${setting.name}';
}
