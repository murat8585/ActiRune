import 'package:flutter/foundation.dart';

import 'quest_engine.dart';

enum QuestType { daily, weekly }

enum QuestStatus { active, completed, claimed }

@immutable
class QuestRecord {
  const QuestRecord({
    required this.id,
    required this.type,
    required this.title,
    required this.progress,
    required this.target,
    required this.status,
  }) : assert(target > 0),
       assert(progress >= 0 && progress <= target);

  final String id;
  final QuestType type;
  final String title;
  final int progress;
  final int target;
  final QuestStatus status;

  QuestRecord withLocalProgress(int next) {
    if (next < 0 || next > target) throw RangeError.range(next, 0, target);
    return QuestRecord(
      id: id,
      type: type,
      title: title,
      progress: next,
      target: target,
      status: next == target ? QuestStatus.completed : QuestStatus.active,
    );
  }
}

/// In-memory display owner. No gameplay event, persistence or reward writes.
class LocalQuestOwner extends ChangeNotifier {
  LocalQuestOwner({List<QuestRecord>? records})
    : _records = List.of(records ?? sampleRecords) {
    if (_records.map((record) => record.id).toSet().length != _records.length) {
      throw ArgumentError('Quest IDs must be unique');
    }
  }

  static final List<QuestRecord> sampleRecords = List.unmodifiable([
    const QuestRecord(
      id: 'sample-daily-explore',
      type: QuestType.daily,
      title: 'Keşif',
      progress: 0,
      target: 1,
      status: QuestStatus.active,
    ),
    const QuestRecord(
      id: 'sample-daily-battle',
      type: QuestType.daily,
      title: 'Savaş',
      progress: 0,
      target: 1,
      status: QuestStatus.active,
    ),
    const QuestRecord(
      id: 'sample-daily-form',
      type: QuestType.daily,
      title: 'Hareket formu',
      progress: 0,
      target: 1,
      status: QuestStatus.active,
    ),
    const QuestRecord(
      id: 'sample-daily-lumi',
      type: QuestType.daily,
      title: 'Lumi',
      progress: 0,
      target: 1,
      status: QuestStatus.active,
    ),
    const QuestRecord(
      id: 'sample-daily-balance',
      type: QuestType.daily,
      title: 'Denge',
      progress: 0,
      target: 1,
      status: QuestStatus.active,
    ),
    for (
      var i = 1;
      i <= const WeeklyQuestEngine().policyForPlayerLevel(1).totalQuestCount;
      i++
    )
      QuestRecord(
        id: 'sample-weekly-$i',
        type: QuestType.weekly,
        title: 'Haftalık görev $i',
        progress: 0,
        target: 1,
        status: QuestStatus.active,
      ),
  ]);

  final List<QuestRecord> _records;

  List<QuestRecord> recordsFor(QuestType type) =>
      List.unmodifiable(_records.where((record) => record.type == type));

  QuestRecord byId(String id) =>
      _records.singleWhere((record) => record.id == id);

  void setLocalProgress(String id, int progress) {
    final index = _records.indexWhere((record) => record.id == id);
    if (index < 0) throw ArgumentError.value(id, 'id', 'Unknown quest');
    _records[index] = _records[index].withLocalProgress(progress);
    notifyListeners();
  }
}
