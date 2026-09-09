import 'package:flutter/material.dart';
import '../../core/design/actirune_theme.dart';
import '../../core/design/rune_card.dart';
import '../battle/battle_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 12),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Orin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Lv. 8   320 / 600 XP'),
                ])),
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 380,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF15466A), Color(0xFF09243A), Color(0xFF061729)],
                ),
              ),
              child: const Stack(
                children: [
                  Positioned(top: 20, right: 20, child: RuneCard(child: Text('YEŞİL VADİ\nBölüm 3-2'))),
                  Center(child: Icon(Icons.shield, size: 150, color: ActiRuneColors.gold)),
                  Positioned(left: 20, bottom: 28, child: Text('Vadi Muhafızı\nZırh %63', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 62,
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BattleScreen())),
                icon: const Icon(Icons.sports_martial_arts),
                label: const Text('SAVAŞA DEVAM ET', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            const Row(children: [
              Expanded(child: RuneCard(child: Column(children:[Text('Bugünün Macerası'), Text('2 / 4', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))]))),
              SizedBox(width: 8),
              Expanded(child: RuneCard(child: Column(children:[Text('Haftalık Yolculuk'), Text('3 / 5', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))]))),
              SizedBox(width: 8),
              Expanded(child: RuneCard(child: Column(children:[Text('Aktif Seri'), Text('4 gün', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))]))),
            ]),
          ],
        ),
      ),
    );
  }
}
