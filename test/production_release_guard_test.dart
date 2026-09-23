import 'package:actirune/core/release/production_release_guard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('current placeholder identities and debug signing fail closed', () {
    final evidence = ProductionReleaseEvidence.fromPlatformFiles(
      androidGradle: '''
android {
  defaultConfig {
    applicationId = "com.example.actirune"
  }
  buildTypes {
    release {
      signingConfig = signingConfigs.getByName("debug")
    }
  }
}
''',
      iosProject: '''
PRODUCT_BUNDLE_IDENTIFIER = com.example.actirune;
PRODUCT_BUNDLE_IDENTIFIER = com.example.actirune.RunnerTests;
''',
    );

    final report = ProductionReleaseGuard.evaluate(evidence);

    expect(report.isReady, isFalse);
    expect(report.issues, containsAll(<ProductionReleaseIssue>[
      ProductionReleaseIssue.placeholderAndroidApplicationId,
      ProductionReleaseIssue.androidDebugSigning,
      ProductionReleaseIssue.placeholderIosBundleIdentifier,
      ProductionReleaseIssue.missingIosDevelopmentTeam,
    ]));
  });

  test('production identities release signing and iOS team pass', () {
    final evidence = ProductionReleaseEvidence.fromPlatformFiles(
      androidGradle: '''
android {
  defaultConfig {
    applicationId = "com.actirune.app"
  }
  buildTypes {
    release {
      signingConfig = signingConfigs.getByName("release")
    }
  }
}
''',
      iosProject: '''
PRODUCT_BUNDLE_IDENTIFIER = com.actirune.app;
DEVELOPMENT_TEAM = ABC123XYZ9;
PRODUCT_BUNDLE_IDENTIFIER = com.actirune.app.RunnerTests;
''',
    );

    final report = ProductionReleaseGuard.evaluate(evidence);

    expect(report.isReady, isTrue);
    expect(report.issues, isEmpty);
  });

  test('missing platform authority fails closed', () {
    const evidence = ProductionReleaseEvidence(
      androidApplicationId: null,
      androidReleaseSigningConfigured: false,
      androidUsesDebugSigning: false,
      iosBundleIdentifier: null,
      iosDevelopmentTeam: null,
    );

    final report = ProductionReleaseGuard.evaluate(evidence);

    expect(report.issues, <ProductionReleaseIssue>[
      ProductionReleaseIssue.missingAndroidApplicationId,
      ProductionReleaseIssue.missingAndroidReleaseSigning,
      ProductionReleaseIssue.missingIosBundleIdentifier,
      ProductionReleaseIssue.missingIosDevelopmentTeam,
    ]);
  });

  test('iOS parser ignores RunnerTests bundle identifier', () {
    final evidence = ProductionReleaseEvidence.fromPlatformFiles(
      androidGradle: '''
applicationId = "com.actirune.app"
signingConfig = signingConfigs.getByName("release")
''',
      iosProject: '''
PRODUCT_BUNDLE_IDENTIFIER = com.actirune.app.RunnerTests;
PRODUCT_BUNDLE_IDENTIFIER = com.actirune.app;
DEVELOPMENT_TEAM = TEAM123456;
''',
    );

    expect(evidence.iosBundleIdentifier, 'com.actirune.app');
    expect(ProductionReleaseGuard.evaluate(evidence).isReady, isTrue);
  });
}
