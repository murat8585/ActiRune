import 'dart:io';

import 'package:actirune/core/release/production_release_guard.dart';

void main() {
  final androidGradle = File('android/app/build.gradle.kts');
  final iosProject = File('ios/Runner.xcodeproj/project.pbxproj');

  final missingFiles = <String>[
    if (!androidGradle.existsSync()) androidGradle.path,
    if (!iosProject.existsSync()) iosProject.path,
  ];

  if (missingFiles.isNotEmpty) {
    stderr.writeln(
      'Production release guard cannot inspect required files: '
      '${missingFiles.join(', ')}',
    );
    exitCode = 2;
    return;
  }

  final evidence = ProductionReleaseEvidence.fromPlatformFiles(
    androidGradle: androidGradle.readAsStringSync(),
    iosProject: iosProject.readAsStringSync(),
  );
  final report = ProductionReleaseGuard.evaluate(evidence);

  stdout.writeln('ActiRune production release guard');
  stdout.writeln('Android application id: ${evidence.androidApplicationId ?? '<missing>'}');
  stdout.writeln('Android release signing configured: ${evidence.androidReleaseSigningConfigured}');
  stdout.writeln('Android uses debug signing: ${evidence.androidUsesDebugSigning}');
  stdout.writeln('iOS bundle identifier: ${evidence.iosBundleIdentifier ?? '<missing>'}');
  stdout.writeln('iOS development team: ${evidence.iosDevelopmentTeam ?? '<missing>'}');

  if (report.isReady) {
    stdout.writeln('RESULT: PASS');
    return;
  }

  stdout.writeln('RESULT: BLOCKED');
  for (final issue in report.issues) {
    stdout.writeln('- ${issue.name}');
  }
  exitCode = 1;
}
