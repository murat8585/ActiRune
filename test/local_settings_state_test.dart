import 'package:actirune/features/profile/local_settings_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'local notification and accessibility choices persist on device',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final first = LocalSettingsOwner(preferences);
      expect(first.value(LocalSetting.events), isNull);
      expect(first.value(LocalSetting.highContrast), isNull);
      expect(await first.toggle(LocalSetting.events), isTrue);
      expect(await first.toggle(LocalSetting.highContrast), isTrue);
      expect(first.value(LocalSetting.events), isTrue);
      first.dispose();

      final restored = LocalSettingsOwner(preferences);
      expect(restored.value(LocalSetting.events), isTrue);
      expect(restored.value(LocalSetting.highContrast), isTrue);
      expect(await restored.toggle(LocalSetting.events), isTrue);
      expect(restored.value(LocalSetting.events), isFalse);
      restored.dispose();
    },
  );

  test('without storage, state is local to one owner', () async {
    final owner = LocalSettingsOwner(null);
    expect(await owner.toggle(LocalSetting.social), isTrue);
    expect(owner.value(LocalSetting.social), isTrue);
    owner.dispose();
    final next = LocalSettingsOwner(null);
    expect(next.value(LocalSetting.social), isNull);
    next.dispose();
  });
}
