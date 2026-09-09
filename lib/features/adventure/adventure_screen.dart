import 'package:flutter/material.dart';
import '../../core/design/rune_card.dart';

class AdventureScreen extends StatelessWidget {
  const AdventureScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Macera Haritası')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        RuneCard(child: Text('Yeşil Vadi V1. Buz, Volkan, Gökyüzü ve Karanlık Rün bölgeleri kilitli önizleme.')),
        SizedBox(height: 12),
        RuneCard(child: Text('Bu ekranın üretim layout’u docs/visual_reference altındaki kilitli görsele göre uygulanacaktır.')),
      ],
    ),
  );
}
