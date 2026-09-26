import 'package:actirune/features/profile/profile_history_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 9, 27);
  const olderTitle = 'fixture reward';
  final records = [
    ProfileHistoryRecord(
      id: 'battle-1',
      title: 'fixture battle',
      tab: HistoryTab.battles,
      occurredAt: now.subtract(const Duration(days: 1)),
    ),
    ProfileHistoryRecord(
      id: 'movement-1',
      title: 'fixture movement',
      tab: HistoryTab.movements,
      occurredAt: now.subtract(const Duration(days: 2)),
    ),
    ProfileHistoryRecord(
      id: 'reward-1',
      title: olderTitle,
      tab: HistoryTab.rewards,
      occurredAt: now.subtract(const Duration(days: 40)),
    ),
  ];

  test('production history is empty', () {
    final owner = ProfileHistoryOwner();
    expect(owner.visibleRecords, isEmpty);
    owner.dispose();
  });

  test('tabs and date ranges filter actual record IDs', () {
    final owner = ProfileHistoryOwner(records: records, now: () => now);
    expect(owner.visibleRecords.map((record) => record.id), [
      'battle-1',
      'movement-1',
      'reward-1',
    ]);
    owner.selectTab(HistoryTab.battles);
    expect(owner.visibleRecords.map((record) => record.id), ['battle-1']);
    owner.selectTab(HistoryTab.movements);
    expect(owner.visibleRecords.map((record) => record.id), ['movement-1']);
    owner.selectTab(HistoryTab.rewards);
    expect(owner.visibleRecords.map((record) => record.id), ['reward-1']);
    owner.selectRange(HistoryRange.lastSevenDays);
    expect(owner.visibleRecords, isEmpty);
    owner.selectTab(HistoryTab.all);
    expect(owner.visibleRecords.map((record) => record.id), [
      'battle-1',
      'movement-1',
    ]);
    owner.dispose();
  });

  test('duplicate IDs and uncategorized records are rejected', () {
    expect(
      () => ProfileHistoryOwner(records: [records.first, records.first]),
      throwsArgumentError,
    );
    expect(
      () => ProfileHistoryOwner(
        records: [
          ProfileHistoryRecord(
            id: 'uncategorized',
            title: 'fixture',
            tab: HistoryTab.all,
            occurredAt: now,
          ),
        ],
      ),
      throwsArgumentError,
    );
  });
}
