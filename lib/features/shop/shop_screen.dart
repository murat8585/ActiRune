import 'package:flutter/material.dart';
import '../../core/design/rune_card.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Mağaza / Plus')),
    body: const Padding(
      padding: EdgeInsets.all(16),
      child: RuneCard(
        child: Text(
          'Launch: free core + cosmetics/Crystal + rewarded ads + Founder Pack. Plus retention doğrulandıktan sonra.',
        ),
      ),
    ),
  );
}
