import 'dart:io';

import 'package:actirune/core/release/production_identity_candidate.dart';
import 'package:actirune/core/release/production_identity_guard.dart';

void main(List<String> args) {
  final androidApplicationId = _readNamedArgument(args, '--android-id');
  final iosBundleIdentifier = _readNamedArgument(args, '--ios-bundle-id');

  final candidate = ProductionIdentityCandidate(
    androidApplicationId: androidApplicationId,
    iosBundleIdentifier: iosBundleIdentifier,
  );
  final candidateReport = ProductionIdentityCandidateGuard.evaluate(candidate);

  print('ActiRune production identity migration plan');
  print('Mode: DRY_RUN_ONLY');
  print('Proposed Android applicationId: ${androidApplicationId ?? '<missing>'}');
  print('Proposed iOS bundle identifier: ${iosBundleIdentifier ?? '<missing>'}');

  if (!candidateReport.isValid) {
    print('Candidate issues:');
    for (final issue in candidateReport.issues) {
      print('- ${issue.name}');
    }
    print('RESULT: BLOCKED_CANDIDATE');
    exitCode = 2;
    return;
  }

  final androidGradleFile = File('android/app/build.gradle.kts');
  final iosProjectFile = File('ios/Runner.xcodeproj/project.pbxproj');
  final mainActivityFile = _discoverMainActivity();

  if (!androidGradleFile.existsSync() ||
      !iosProjectFile.existsSync() ||
      mainActivityFile == null) {
    stderr.writeln('Required platform identity files are missing or ambiguous.');
    exitCode = 3;
    return;
  }

  final current = ProductionIdentityEvidence.fromPlatformFiles(
    androidGradle: androidGradleFile.readAsStringSync(),
    androidMainActivity: mainActivityFile.readAsStringSync(),
    iosProject: iosProjectFile.readAsStringSync(),
  );

  print('Current Android namespace: ${current.androidNamespace ?? '<missing>'}');
  print(
    'Current Android applicationId: '
    '${current.androidApplicationId ?? '<missing>'}',
  );
  print(
    'Current MainActivity package: '
    '${current.androidMainActivityPackage ?? '<missing>'}',
  );
  print('Current iOS bundle id: ${current.iosBundleIdentifier ?? '<missing>'}');
  print(
    'Current RunnerTests bundle id: '
    '${current.iosRunnerTestBundleIdentifier ?? '<missing>'}',
  );

  print('Planned repository mutations after explicit owner authority:');
  print(
    '- android/app/build.gradle.kts namespace -> $androidApplicationId',
  );
  print(
    '- android/app/build.gradle.kts applicationId -> $androidApplicationId',
  );
  print(
    '- ${mainActivityFile.path} package -> $androidApplicationId',
  );
  print(
    '- MainActivity path -> '
    'android/app/src/main/kotlin/${androidApplicationId!.replaceAll('.', '/')}/MainActivity.kt',
  );
  print(
    '- ios/Runner.xcodeproj/project.pbxproj Runner bundle ids -> '
    '$iosBundleIdentifier',
  );
  print(
    '- ios/Runner.xcodeproj/project.pbxproj RunnerTests bundle ids -> '
    '$iosBundleIdentifier.RunnerTests',
  );
  print('- No signing/provider/account values are inferred or changed.');
  print('RESULT: READY_FOR_AUTHORITY_APPLY');
}

String? _readNamedArgument(List<String> args, String name) {
  final prefix = '$name=';
  for (final argument in args) {
    if (argument.startsWith(prefix)) {
      final value = argument.substring(prefix.length).trim();
      return value.isEmpty ? null : value;
    }
  }
  return null;
}

File? _discoverMainActivity() {
  final root = Directory('android/app/src/main/kotlin');
  if (!root.existsSync()) {
    return null;
  }

  final candidates = root
      .listSync(recursive: true, followLinks: false)
      .whereType<File>()
      .where((file) => file.path.replaceAll('\\', '/').endsWith('/MainActivity.kt'))
      .toList(growable: false);

  return candidates.length == 1 ? candidates.single : null;
}
