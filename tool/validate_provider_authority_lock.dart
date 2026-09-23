import 'dart:convert';
import 'dart:io';

import 'package:actirune/core/release/production_release_guard.dart';
import 'package:actirune/core/release/provider_authority_lock.dart';

void main(List<String> args) {
  final authorityPath = args.isEmpty
      ? 'validation/release/provider_authority.json'
      : args.single;
  final authorityFile = File(authorityPath);

  if (!authorityFile.existsSync()) {
    stderr.writeln('RESULT: BLOCKED_PROVIDER_AUTHORITY_MISSING');
    stderr.writeln('Provider authority lock not found: $authorityPath');
    exitCode = 1;
    return;
  }

  final androidFile = File('android/app/build.gradle.kts');
  final iosFile = File('ios/Runner.xcodeproj/project.pbxproj');
  if (!androidFile.existsSync() || !iosFile.existsSync()) {
    stderr.writeln('RESULT: BLOCKED_PLATFORM_AUTHORITY_MISSING');
    stderr.writeln('Android/iOS platform authority files are required.');
    exitCode = 2;
    return;
  }

  try {
    final decoded = jsonDecode(authorityFile.readAsStringSync());
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Provider authority root must be an object.');
    }

    final authority = ProviderAuthorityLock.fromJson(decoded);
    final productionEvidence = ProductionReleaseEvidence.fromPlatformFiles(
      androidGradle: androidFile.readAsStringSync(),
      iosProject: iosFile.readAsStringSync(),
    );
    final report = ProviderAuthorityValidator.evaluate(
      authority: authority,
      productionEvidence: productionEvidence,
    );

    stdout.writeln('ActiRune provider authority lock');
    stdout.writeln('Backend: ${authority.backendProvider}');
    stdout.writeln('Billing: ${authority.billingProvider}');
    stdout.writeln('Rewarded ads: ${authority.rewardedAdsProvider}');
    stdout.writeln('Analytics: ${authority.analyticsProvider}');
    stdout.writeln('Android id: ${authority.androidApplicationId}');
    stdout.writeln('iOS id: ${authority.iosBundleIdentifier}');

    if (!report.isValid) {
      stdout.writeln('RESULT: BLOCKED_PROVIDER_AUTHORITY_INVALID');
      for (final issue in report.issues) {
        stdout.writeln('- ${issue.name}');
      }
      exitCode = 1;
      return;
    }

    stdout.writeln('RESULT: PROVIDER_AUTHORITY_LOCK_VALID');
    stdout.writeln(
      'This validates provider/identity authority only. It does not prove SDK '
      'configuration, credentials, signing, store products or production '
      'provider connectivity.',
    );
  } on FormatException catch (error) {
    stderr.writeln('RESULT: BLOCKED_PROVIDER_AUTHORITY_SCHEMA');
    stderr.writeln(error.message);
    exitCode = 2;
  }
}
