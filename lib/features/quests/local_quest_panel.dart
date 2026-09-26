import 'package:flutter/material.dart';

import 'local_quest_state.dart';
import 'quest_engine.dart';

/// Covers baked sample progress and reward copy in the approved artwork.
class LocalQuestPanel extends StatelessWidget {
  const LocalQuestPanel({super.key, required this.type, required this.records});

  final QuestType type;
  final List<QuestRecord> records;

  @override
  Widget build(BuildContext context) {
    final visible = records.where((record) => record.type == type).toList();
    final completed = visible
        .where((record) => record.status == QuestStatus.completed)
        .length;
    final goal = type == QuestType.daily
        ? DailyQuestEngine.normalGoal
        : const WeeklyQuestEngine().policyForPlayerLevel(1).mainRewardMinimum;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xF408182B),
        border: Border.all(color: const Color(0xFFD8B873), width: 1.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              type == QuestType.daily ? 'GÜNLÜK GÖREVLER' : 'HAFTALIK GÖREVLER',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFFD991),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'YEREL ÖRNEK • $completed/${visible.length} • ana eşik $goal',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF8EEBFF), fontSize: 10),
            ),
            const SizedBox(height: 6),
            for (final record in visible)
              Container(
                key: ValueKey('quest-record-${record.id}'),
                margin: const EdgeInsets.only(bottom: 5),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF102C40),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF4F788C)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        record.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Text(
                      '${record.progress}/${record.target} • ${switch (record.status) {
                        QuestStatus.active => 'Sürüyor',
                        QuestStatus.completed => 'Tamamlandı',
                      }}',
                      key: ValueKey('quest-status-${record.id}'),
                      style: const TextStyle(
                        color: Color(0xFFFFD991),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            const Text(
              'Örnek ilerleme gerçek aktivite değildir. Gerçek görev ilerlemesi ve ödül işlemi bağlı değil; ödül verilmez.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFBBD3E3), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
