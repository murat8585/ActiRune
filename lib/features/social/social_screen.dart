import 'package:flutter/material.dart';
import '../../core/design/rune_card.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sosyal')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        RuneCard(child: Text('V1 asenkron 1:1 meydan okuma, arkadaşlar, rövanş ve paylaşım.')),
        SizedBox(height: 12),
        RuneCard(child: Text('Bu ekranın üretim layout’u docs/visual_reference altındaki kilitli görsele göre uygulanacaktır.')),
      ],
    ),
  );
}
