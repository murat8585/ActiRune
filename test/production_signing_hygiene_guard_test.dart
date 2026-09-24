import 'package:actirune/core/release/production_signing_hygiene_guard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const cleanGitignore = '''
*.jks
*.keystore
*.p12
*.mobileprovision
.env
.env.*
key.properties
''';

  test('current debug signing and missing Apple team fail closed', () {
    final evidence = ProductionSigningHygieneEvidence.fromRepositoryTexts(
      androidGradle: '''
buildTypes {
  release {
    signingConfig = signingConfigs.getByName("debug")
  }
}
''',
      iosProject: 'PRODUCT_BUNDLE_IDENTIFIER = com.example.actirune;',
      gitignore: cleanGitignore,
      trackedPaths: const <String>['lib/main.dart'],
    );

    final report = ProductionSigningHygieneGuard.evaluate(evidence);

    expect(report.isReady, isFalse);
    expect(
      report.issues,
      containsAll(<ProductionSigningHygieneIssue>[
        ProductionSigningHygieneIssue.androidDebugSigning,
        ProductionSigningHygieneIssue.missingIosDevelopmentTeam,
      ]),
    );
    expect(
      report.issues,
      isNot(contains(ProductionSigningHygieneIssue.trackedSigningMaterial)),
    );
  });

  test('release signing team and secret hygiene pass', () {
    final evidence = ProductionSigningHygieneEvidence.fromRepositoryTexts(
      androidGradle: '''
buildTypes {
  release {
    signingConfig = signingConfigs.getByName("release")
  }
}
''',
      iosProject: '''
DEVELOPMENT_TEAM = ABC123XYZ9;
PRODUCT_BUNDLE_IDENTIFIER = com.actirune.app;
''',
      gitignore: cleanGitignore,
      trackedPaths: const <String>['lib/main.dart', 'android/app/build.gradle.kts'],
    );

    expect(ProductionSigningHygieneGuard.evaluate(evidence).isReady, isTrue);
  });

  test('tracked signing material fails closed', () {
    final evidence = ProductionSigningHygieneEvidence.fromRepositoryTexts(
      androidGradle:
          'signingConfig = signingConfigs.getByName("release")',
      iosProject: 'DEVELOPMENT_TEAM = ABC123XYZ9;',
      gitignore: cleanGitignore,
      trackedPaths: const <String>[
        'android/upload-key.jks',
        'ios/AuthKey.p12',
      ],
    );

    expect(
      ProductionSigningHygieneGuard.evaluate(evidence).issues,
      contains(ProductionSigningHygieneIssue.trackedSigningMaterial),
    );
  });

  test('missing ignore coverage and malformed Apple team fail closed', () {
    final evidence = ProductionSigningHygieneEvidence.fromRepositoryTexts(
      androidGradle:
          'signingConfig = signingConfigs.getByName("release")',
      iosProject: 'DEVELOPMENT_TEAM = TOO-SHORT;',
      gitignore: '*.jks\n',
      trackedPaths: const <String>[],
    );

    final report = ProductionSigningHygieneGuard.evaluate(evidence);

    expect(
      report.issues,
      containsAll(<ProductionSigningHygieneIssue>[
        ProductionSigningHygieneIssue.invalidIosDevelopmentTeam,
        ProductionSigningHygieneIssue.missingRequiredIgnorePattern,
      ]),
    );
  });
}
