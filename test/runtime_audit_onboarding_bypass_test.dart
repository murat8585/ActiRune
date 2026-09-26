import 'package:actirune/app/actirune_app.dart';
import 'package:actirune/app/main_shell.dart';
import 'package:actirune/features/home/home_screen.dart';
import 'package:actirune/features/onboarding/onboarding_welcome_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

const bool _auditDefineEnabled = bool.fromEnvironment(
  'ACTIRUNE_RUNTIME_AUDIT_SKIP_ONBOARDING',
  defaultValue: false,
);

void main() {
  test('audit startup requires debug mode and an explicit define', () {
    expect(runtimeAuditSkipOnboarding, kDebugMode && _auditDefineEnabled);
  });

  if (_auditDefineEnabled) {
    testWidgets('audit define opens Ana Dunya without onboarding', (
      tester,
    ) async {
      await tester.pumpWidget(const ActiRuneApp());
      await tester.pumpAndSettle();

      expect(runtimeAuditSkipOnboarding, isTrue);
      expect(find.byType(MainShell), findsOneWidget);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(OnboardingWelcomeScreen), findsNothing);
    });
  } else {
    testWidgets('normal build keeps onboarding as the initial route', (
      tester,
    ) async {
      await tester.pumpWidget(const ActiRuneApp());
      await tester.pumpAndSettle();

      expect(runtimeAuditSkipOnboarding, isFalse);
      expect(find.byType(OnboardingWelcomeScreen), findsOneWidget);
      expect(find.byType(MainShell), findsNothing);
    });
  }
}
