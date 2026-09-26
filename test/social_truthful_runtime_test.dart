import 'package:actirune/features/social/social_screen.dart';
import 'package:actirune/core/widgets/artwork_interaction_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('social route shows approved artwork without drawn-on panels', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SocialScreen()));
    final surface = tester.widget<ArtworkInteractionSurface>(
      find.byType(ArtworkInteractionSurface),
    );
    expect(surface.assetPath, SocialScreen.artworkPath);
    expect(surface.sourceSize, const Size(941, 1672));
    expect(surface.overlays, isEmpty);
  });

  testWidgets('social controls fail closed and bottom navigation calls shell', (
    tester,
  ) async {
    String? destination;
    await tester.pumpWidget(
      MaterialApp(
        home: SocialScreen(onRootNavigate: (next) => destination = next),
      ),
    );

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-social.add-friend')),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('feature-unavailable-dialog')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('feature-unavailable-close')));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-social.friend-1-challenge')),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('feature-unavailable-dialog')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('feature-unavailable-close')));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('artwork-hotspot-social.nav-adventure')),
    );
    expect(destination, 'adventure');
  });
}
