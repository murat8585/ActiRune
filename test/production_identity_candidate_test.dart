import 'package:actirune/core/release/production_identity_candidate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('production-shaped Android and iOS identifiers are accepted', () {
    final report = ProductionIdentityCandidateGuard.evaluate(
      const ProductionIdentityCandidate(
        androidApplicationId: 'com.actirune.app',
        iosBundleIdentifier: 'com.actirune.app',
      ),
    );

    expect(report.isValid, isTrue);
    expect(report.issues, isEmpty);
  });

  test('placeholder identifiers fail closed', () {
    final report = ProductionIdentityCandidateGuard.evaluate(
      const ProductionIdentityCandidate(
        androidApplicationId: 'com.example.actirune',
        iosBundleIdentifier: 'com.example.actirune',
      ),
    );

    expect(
      report.issues,
      containsAll(<ProductionIdentityCandidateIssue>[
        ProductionIdentityCandidateIssue.placeholderAndroidApplicationId,
        ProductionIdentityCandidateIssue.placeholderIosBundleIdentifier,
      ]),
    );
  });

  test('missing identifiers fail closed independently', () {
    final report = ProductionIdentityCandidateGuard.evaluate(
      const ProductionIdentityCandidate(
        androidApplicationId: null,
        iosBundleIdentifier: '',
      ),
    );

    expect(
      report.issues,
      containsAll(<ProductionIdentityCandidateIssue>[
        ProductionIdentityCandidateIssue.missingAndroidApplicationId,
        ProductionIdentityCandidateIssue.missingIosBundleIdentifier,
      ]),
    );
  });

  test('malformed Android application id is rejected', () {
    final report = ProductionIdentityCandidateGuard.evaluate(
      const ProductionIdentityCandidate(
        androidApplicationId: '123.invalid',
        iosBundleIdentifier: 'com.actirune.app',
      ),
    );

    expect(
      report.issues,
      contains(ProductionIdentityCandidateIssue.invalidAndroidApplicationId),
    );
  });

  test('malformed iOS bundle identifier is rejected', () {
    final report = ProductionIdentityCandidateGuard.evaluate(
      const ProductionIdentityCandidate(
        androidApplicationId: 'com.actirune.app',
        iosBundleIdentifier: 'com.actirune_bad.app',
      ),
    );

    expect(
      report.issues,
      contains(ProductionIdentityCandidateIssue.invalidIosBundleIdentifier),
    );
  });
}
