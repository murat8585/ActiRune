import 'dart:convert';
import 'dart:io';

import 'package:actirune/core/release/provider_authority_lock.dart';
import 'package:actirune/core/release/provider_configuration_evidence.dart';

void main(List<String> args) {
  if (args.length > 2) {
    stderr.writeln(
      'Usage: dart run tool/validate_provider_configuration_evidence.dart '
      '[authority.json] [configuration.json]',
    );
    exitCode = 2;
    return;
  }

  final authorityPath = args.isEmpty
      ? 'validation/release/provider_authority.json'
      : args.first;
  final configurationPath = args.length < 2
      ? 'validation/release/provider_configuration.json'
      : args[1];

  final authorityFile = File(authorityPath);
  final configurationFile = File(configurationPath);

  if (!authorityFile.existsSync()) {
    stderr.writeln('RESULT: BLOCKED_PROVIDER_AUTHORITY_MISSING');
    stderr.writeln('Provider authority lock not found: $authorityPath');
    exitCode = 1;
    return;
  }
  if (!configurationFile.existsSync()) {
    stderr.writeln('RESULT: BLOCKED_PROVIDER_CONFIGURATION_MISSING');
    stderr.writeln('Provider configuration evidence not found: $configurationPath');
    exitCode = 1;
    return;
  }

  try {
    final authorityJson = _decodeObject(authorityFile, 'provider authority');
    final configurationJson = _decodeObject(
      configurationFile,
      'provider configuration',
    );

    final authority = ProviderAuthorityLock.fromJson(authorityJson);
    final evidence = ProviderConfigurationEvidence.fromJson(configurationJson);
    final report = ProviderConfigurationValidator.evaluate(
      authority: authority,
      evidence: evidence,
    );

    stdout.writeln('ActiRune provider configuration evidence');
    stdout.writeln('Release build: ${evidence.releaseBuild}');
    stdout.writeln('Backend configured: ${evidence.backend.configured}');
    stdout.writeln('Billing configured: ${evidence.billing.configured}');
    stdout.writeln(
      'Rewarded ads configured: ${evidence.rewardedAds.configured}',
    );
    stdout.writeln('Analytics configured: ${evidence.analytics.configured}');
    stdout.writeln('Public references: NOT_PRINTED');
    stdout.writeln('Credentials/secrets: NOT_SUPPORTED');

    if (!report.isValid) {
      stdout.writeln('RESULT: BLOCKED_PROVIDER_CONFIGURATION_INVALID');
      for (final issue in report.issues) {
        stdout.writeln('- ${issue.name}');
      }
      exitCode = 1;
      return;
    }

    stdout.writeln('RESULT: PROVIDER_CONFIGURATION_VALID');
    stdout.writeln(
      'This validates audit-safe configuration evidence only. It does not '
      'prove credentials, provider-account ownership, store review, or live '
      'production connectivity beyond the recorded verification methods.',
    );
  } on FormatException catch (error) {
    stderr.writeln('RESULT: BLOCKED_PROVIDER_CONFIGURATION_SCHEMA');
    stderr.writeln(error.message);
    exitCode = 2;
  }
}

Map<String, Object?> _decodeObject(File file, String label) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map<String, Object?>) {
    throw FormatException('$label root must be a JSON object.');
  }
  return decoded;
}
