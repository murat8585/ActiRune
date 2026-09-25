import 'package:flutter/material.dart';

/// Home-only preview for the locked 7-day flexible activity streak.
///
/// This screen intentionally uses fixture-only presentation. It must not claim
/// live activity ownership until the streak data owner is connected.
class DailyStreakPreviewScreen extends StatelessWidget {
  const DailyStreakPreviewScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return Scaffold(
      backgroundColor: const Color(0xFF050A14),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    key: const ValueKey('daily-streak-preview-back'),
                    tooltip: 'Ana Dünya’ya dön',
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Expanded(
                    child: Text(
                      'GÜNLÜK SERİ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 8),
              child: Text(
                '7 Günlük Esnek Aktivite Yolu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF7DE8FF),
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                'Her gün zorunlu değil. Hedef, yedi gün içinde düzenli ve sürdürülebilir hareket.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFC6D5E8), fontSize: 15),
              ),
            ),
            const SizedBox(height: 34),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = 0; i < days.length; i++)
                    _DayNode(label: days[i], index: i),
                ],
              ),
            ),
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1728),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF184E68)),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Örnek haftalık hedef: 5 / 7 aktif gün',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Recovery Day aktif gün sayılabilir. Tek bir gün kaçırmak seriyi sıfırlamaz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF9FB5CC),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Text(
                'ÖNİZLEME • Canlı aktivite verisi henüz bağlı değil',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF71859A),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayNode extends StatelessWidget {
  const _DayNode({required this.label, required this.index});

  final String label;
  final int index;

  @override
  Widget build(BuildContext context) {
    final active = index < 5;
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? const Color(0xFF0B4057) : const Color(0xFF111A26),
            border: Border.all(
              color: active ? const Color(0xFF6DE7FF) : const Color(0xFF334153),
              width: 1.5,
            ),
          ),
          child: Icon(
            active ? Icons.bolt : Icons.remove,
            size: 18,
            color: active ? const Color(0xFF8FF0FF) : const Color(0xFF65758A),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Color(0xFFAEC0D3), fontSize: 12)),
      ],
    );
  }
}
