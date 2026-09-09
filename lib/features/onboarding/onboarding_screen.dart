import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/actirune_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _steps = [
    ('ACTIRUNE', 'Hareket et. Savaş. Güçlen.', Icons.auto_awesome),
    (
      'Hareketin Güçtür',
      'Gerçek hareketlerin savaşta güce dönüşür.',
      Icons.directions_run,
    ),
    (
      'Kahramanını Seç',
      'Savaşçı, Büyücü veya Korucu. Fiziksel yük aynı, fantezi farklı.',
      Icons.shield,
    ),
    (
      'İlk Hareket',
      'Kamera yalnız hareket doğrulamak için kullanılır. Ham video sunucuya gönderilmez.',
      Icons.camera_alt,
    ),
    (
      'İlk Mini Savaş',
      'Doğrulanmış tekrar boss HP’sini düşürür.',
      Icons.sports_martial_arts,
    ),
    ('İlk Zafer', 'Loot kazan, Ana Dünya’ya geç.', Icons.emoji_events),
  ];

  void _next() {
    if (_page == _steps.length - 1) {
      context.go('/app');
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _steps.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) {
                  final step = _steps[i];
                  return Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(step.$3, size: 96, color: ActiRuneColors.cyan),
                        const SizedBox(height: 28),
                        Text(
                          step.$1,
                          style: Theme.of(context).textTheme.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          step.$2,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(
                    _page == _steps.length - 1 ? 'ANA DÜNYAYA GİT' : 'DEVAM ET',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
