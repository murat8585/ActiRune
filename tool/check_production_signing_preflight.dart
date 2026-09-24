import 'dart:io';

import 'package:actirune/core/release/production_signing_hygiene_guard.dart';

void main() {
  final androidGradle = File('android/app/build.gradle.kts');
  final iosProject = File('ios/Runner.xcodeproj/project.pbxproj');
  final gitignore = File('.gitignore');

  if (!androidGradle.existsSync() ||
      !iosProject.existsSync() ||
      !gitignore.existsSync()) {
    stderr.writeln('Required signing preflight inputs are missing.');
    exitCode = 2;
    return;
  }

  final tracked = Process.runSync('git', const ['ls-files']);
  if (tracked.exitCode != 0) {
    stderr.writeln('Unable to inspect tracked repository paths.');
    exitCode = 3;
    return;
  }

  final evidence = ProductionSigningHygieneEvidence.fromRepositoryTexts(
    androidGradle: androidGradle.readAsStringSync(),
    iosProject: iosProject.readAsStringSync(),
    gitignore: gitignore.readAsStringSync(),
    trackedPaths: tracked.stdout
        .toString()
        .split('\n')
        .where((line) => line.trim().isNotEmpty),
  );
  final report = ProductionSigningHygieneGuard.evaluate(evidence);

  stdout.writeln('ActiRune production signing preflight');
  stdout.writeln('Secret values: NOT_READ');
  stdout.writeln('Signing material contents: NOT_READ');

  if (report.isReady) {
    stdout.writeln('RESULT: PASS');
    return;
  }

  for (final issue in report.issues) {
    stdout.writeln('- ${issue.name}');
  }
  stdout.writeln('RESULT: BLOCKED');
  exitCode = 1;
}
