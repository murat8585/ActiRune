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
        RuneCard(
          child: Text(
            'Doğrulanmış arkadaş ve raid kaydı bağlı değil. Davet ve katılım henüz kullanılamıyor.',
          ),
        ),
        SizedBox(height: 12),
        RuneCard(
          child: Text(
            'İlk canlı sosyal mod: arkadaş davetiyle iki kişilik boss raid. Sunucu sahibi bağlandığında açılacak.',
          ),
        ),
      ],
    ),
  );
}
