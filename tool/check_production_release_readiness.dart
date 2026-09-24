import 'dart:io';

import 'package:actirune/core/release/production_identity_guard.dart';
import 'package:actirune/core/release/production_release_guard.dart';

void main() {
  final androidGradle = File('android/app/build.gradle.kts');
  final iosProject = File('ios/Runner.xcodeproj/project.pbxproj');
  final androidMainActivity = _findAndroidMainActivity();

  final missingFiles = <String>[
    if (!androidGradle.existsSync()) androidGradle.path,
    if (!iosProject.existsSync()) iosProject.path,
    if (androidMainActivity == null) 'android/app/src/main/kotlin/**/MainActivity.kt',
  ];

  if (missingFiles.isNotEmpty) {
    stderr.writeln(
      'Production release guard cannot inspect required files: '
      '${missingFiles.join(', ')}',
    );
    exitCode = 2;
    return;
  }

  final androidGradleText = androidGradle.readAsStringSync();
  final iosProjectText = iosProject.readAsStringSync();
  final mainActivityText = androidMainActivity!.readAsStringSync();

  final releaseEvidence = ProductionReleaseEvidence.fromPlatformFiles(
    androidGradle: androidGradleText,
    iosProject: iosProjectText,
  );
  final releaseReport = ProductionReleaseGuard.evaluate(releaseEvidence);

  final identityEvidence = ProductionIdentityEvidence.fromPlatformFiles(
    androidGradle: androidGradleText,
    androidMainActivity: mainActivityText,
    iosProject: iosProjectText,
  );
  final identityReport = ProductionIdentityGuard.evaluate(identityEvidence);

  stdout.writeln('ActiRune production release guard');
  stdout.writeln(
    'Android namespace: ${identityEvidence.androidNamespace ?? '<missing>'}',
  );
  stdout.writeln(
    'Android application id: '
    '${releaseEvidence.androidApplicationId ?? '<missing>'}',
  );
  stdout.writeln(
    'Android MainActivity package: '
    '${identityEvidence.androidMainActivityPackage ?? '<missing>'}',
  );
  stdout.writeln(
    'Android release signing configured: '
    '${releaseEvidence.androidReleaseSigningConfigured}',
  );
  stdout.writeln(
    'Android uses debug signing: ${releaseEvidence.androidUsesDebugSigning}',
  );
  stdout.writeln(
    'iOS bundle identifier: '
    '${releaseEvidence.iosBundleIdentifier ?? '<missing>'}',
  );
  stdout.writeln(
    'iOS RunnerTests bundle identifier: '
    '${identityEvidence.iosRunnerTestBundleIdentifier ?? '<missing>'}',
  );
  stdout.writeln(
    'iOS development team: '
    '${releaseEvidence.iosDevelopmentTeam ?? '<missing>'}',
  );

  if (releaseReport.isReady && identityReport.isConsistent) {
    stdout.writeln('RESULT: PASS');
    return;
  }

  stdout.writeln('RESULT: BLOCKED');
  for (final issue in releaseReport.issues) {
    stdout.writeln('- release.${issue.name}');
  }
  for (final issue in identityReport.issues) {
    stdout.writeln('- identity.${issue.name}');
  }
  exitCode = 1;
}

File? _findAndroidMainActivity() {
  final kotlinRoot = Directory('android/app/src/main/kotlin');
  if (!kotlinRoot.existsSync()) {
    return null;
  }

  final matches = kotlinRoot
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.replaceAll('\\', '/').endsWith('/MainActivity.kt'))
      .toList(growable: false);

  return matches.length == 1 ? matches.single : null;
}
