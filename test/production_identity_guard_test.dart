import 'package:actirune/core/release/production_identity_guard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('current placeholder namespace remains explicitly blocked', () {
    final evidence = ProductionIdentityEvidence.fromPlatformFiles(
      androidGradle: '''
android {
  namespace = "com.example.actirune"
  defaultConfig {
    applicationId = "com.example.actirune"
  }
}
''',
      androidMainActivity: '''
package com.example.actirune

class MainActivity
''',
      iosProject: '''
PRODUCT_BUNDLE_IDENTIFIER = com.example.actirune;
PRODUCT_BUNDLE_IDENTIFIER = com.example.actirune.RunnerTests;
''',
    );

    final report = ProductionIdentityGuard.evaluate(evidence);

    expect(report.isConsistent, isFalse);
    expect(
      report.issues,
      contains(ProductionIdentityIssue.placeholderAndroidNamespace),
    );
  });

  test('production-shaped identity set is internally consistent', () {
    final evidence = ProductionIdentityEvidence.fromPlatformFiles(
      androidGradle: '''
android {
  namespace = "com.actirune.app"
  defaultConfig {
    applicationId = "com.actirune.app"
  }
}
''',
      androidMainActivity: '''
package com.actirune.app

class MainActivity
''',
      iosProject: '''
PRODUCT_BUNDLE_IDENTIFIER = com.actirune.app;
PRODUCT_BUNDLE_IDENTIFIER = com.actirune.app.RunnerTests;
''',
    );

    expect(ProductionIdentityGuard.evaluate(evidence).issues, isEmpty);
  });

  test('android namespace and application id mismatch fails closed', () {
    const evidence = ProductionIdentityEvidence(
      androidNamespace: 'com.actirune.runtime',
      androidApplicationId: 'com.actirune.app',
      androidMainActivityPackage: 'com.actirune.runtime',
      iosBundleIdentifier: 'com.actirune.app',
      iosRunnerTestBundleIdentifier: 'com.actirune.app.RunnerTests',
    );

    expect(
      ProductionIdentityGuard.evaluate(evidence).issues,
      contains(
        ProductionIdentityIssue.androidNamespaceApplicationIdMismatch,
      ),
    );
  });

  test('main activity package must follow the android namespace', () {
    const evidence = ProductionIdentityEvidence(
      androidNamespace: 'com.actirune.app',
      androidApplicationId: 'com.actirune.app',
      androidMainActivityPackage: 'com.example.actirune',
      iosBundleIdentifier: 'com.actirune.app',
      iosRunnerTestBundleIdentifier: 'com.actirune.app.RunnerTests',
    );

    expect(
      ProductionIdentityGuard.evaluate(evidence).issues,
      contains(ProductionIdentityIssue.androidMainActivityPackageMismatch),
    );
  });

  test('runner test bundle id must derive from the iOS app bundle id', () {
    const evidence = ProductionIdentityEvidence(
      androidNamespace: 'com.actirune.app',
      androidApplicationId: 'com.actirune.app',
      androidMainActivityPackage: 'com.actirune.app',
      iosBundleIdentifier: 'com.actirune.app',
      iosRunnerTestBundleIdentifier: 'com.other.RunnerTests',
    );

    expect(
      ProductionIdentityGuard.evaluate(evidence).issues,
      contains(
        ProductionIdentityIssue.iosRunnerTestBundleIdentifierMismatch,
      ),
    );
  });
}
