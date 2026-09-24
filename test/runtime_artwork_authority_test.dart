import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const forbiddenRuntimeFragments = <String>[
    'visual_authority/20260921/current/03_NEAR_FINAL_REFERENCES/',
    'visual_authority/20260921/current/04_CAMERA_PREP_REFERENCE_PAIR/',
    'visual_authority/20260921/current/05_CURRENT_PATCH_REFERENCES/',
    'visual_authority/20260921/current/07_CURRENT_SUPERSEDED_BY_FINAL/',
    'visual_authority/20260921/current/08_LEGACY_FUNCTION_REFERENCE_ONLY/',
  ];

  const selectedP1RuntimeExceptions = <String, String>{
    'visual_authority/20260921/final_p1/02_P1_EQUIPMENT_FINAL.png':
        'lib/features/hero/equipment_screen.dart',
    'visual_authority/20260921/final_p1/03_P1_INVENTORY_FINAL.png':
        'lib/features/hero/inventory_screen.dart',
    'visual_authority/20260921/final_p1/04_P1_CRAFTING_FINAL.png':
        'lib/features/hero/crafting_screen.dart',
    'visual_authority/20260921/final_p1/05_P1_MOVEMENT_MASTERY_FINAL.png':
        'lib/features/hero/movement_mastery_screen.dart',
    'visual_authority/20260921/final_p1/06_P1_PLAYER_LEVEL_FINAL.png':
        'lib/features/profile/player_level_screen.dart',
    'visual_authority/20260921/final_p1/07_P1_SETTINGS_HUB_FINAL.png':
        'lib/features/profile/settings_hub_screen.dart',
  };

  List<File> runtimeDartFiles() {
    return Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList(growable: false);
  }

  String repositoryPath(File file) => file.path.replaceAll('\\', '/');

  test('runtime never points at non-runtime visual reference classes', () {
    final offenders = <String>[];

    for (final file in runtimeDartFiles()) {
      final source = file.readAsStringSync();
      for (final fragment in forbiddenRuntimeFragments) {
        if (source.contains(fragment)) {
          offenders.add('${repositoryPath(file)} -> $fragment');
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Runtime must not consume near-final, camera-reference, patch-base, '
          'superseded, or legacy-only visual classes.',
    );
  });

  test('selected P1 candidate runtime use is an exact documented exception', () {
    final files = runtimeDartFiles();
    final usedFinalP1Assets = <String, List<String>>{};
    final finalP1Pattern = RegExp(
      r"visual_authority/20260921/final_p1/[^'\"\s]+\.png",
    );

    for (final file in files) {
      final source = file.readAsStringSync();
      for (final match in finalP1Pattern.allMatches(source)) {
        final asset = match.group(0)!;
        usedFinalP1Assets
            .putIfAbsent(asset, () => <String>[])
            .add(repositoryPath(file));
      }
    }

    expect(
      usedFinalP1Assets.keys.toSet(),
      selectedP1RuntimeExceptions.keys.toSet(),
      reason:
          'final_p1 contains selected candidates, not blanket canonical '
          'authority. Runtime use must remain on the explicit exception list.',
    );

    for (final entry in selectedP1RuntimeExceptions.entries) {
      expect(
        usedFinalP1Assets[entry.key],
        <String>[entry.value],
        reason: '${entry.key} may only be owned by ${entry.value}.',
      );
    }

    expect(
      usedFinalP1Assets,
      isNot(contains(
        'visual_authority/20260921/final_p1/'
        '01_P1_PROFILE_FINAL_REVISION.png',
      )),
      reason:
          'The Profile revision remains a candidate; the current canonical '
          'Profile shell must not be silently replaced.',
    );
  });
}
