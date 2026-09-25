import 'package:flutter/material.dart';

import '../../core/design/rune_card.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Görevler')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        RuneCard(
          child: Text(
            'Günlük, haftalık, dünya görevi, başarımlar ve dinlenme günü.',
          ),
        ),
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
