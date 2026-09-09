import 'package:flutter/material.dart';
import '../../core/design/rune_card.dart';

class HeroScreen extends StatelessWidget {
  const HeroScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Kahraman & Lumi')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        RuneCard(child: Text('Hero, ekipman, Lumi ve collection katmanı.')),
        SizedBox(height: 12),
        RuneCard(
          child: Text(
            'Bu ekranın üretim layout’u docs/visual_reference altındaki kilitli görsele göre uygulanacaktır.',
          ),
        ),
      ],
    ),
  );
}
