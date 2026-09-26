import 'package:actirune/features/social/social_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('social route does not claim friends or a completed raid', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SocialScreen()));
    expect(
      find.textContaining('Doğrulanmış arkadaş ve raid kaydı bağlı değil'),
      findsOneWidget,
    );
    expect(find.textContaining('iki kişilik boss raid'), findsOneWidget);
  });
}
