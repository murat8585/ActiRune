import 'package:flutter/foundation.dart';

enum HistoryTab { all, battles, movements, rewards }

enum HistoryRange { all, lastSevenDays, lastThirtyDays }

@immutable
class ProfileHistoryRecord {
  const ProfileHistoryRecord({
    required this.id,
    required this.title,
    required this.tab,
    required this.occurredAt,
  });

  final String id;
  final String title;
  final HistoryTab tab;
  final DateTime occurredAt;
}

/// Production starts empty until a verified history source supplies records.
class ProfileHistoryOwner extends ChangeNotifier {
  ProfileHistoryOwner({
    Iterable<ProfileHistoryRecord> records = const [],
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now {
    for (final record in records) {
      if (record.id.trim().isEmpty ||
          record.title.trim().isEmpty ||
          record.tab == HistoryTab.all ||
          _records.containsKey(record.id)) {
        throw ArgumentError(
          'History records need unique owned IDs and a category',
        );
      }
      _records[record.id] = record;
    }
  }

  final DateTime Function() _now;
  final Map<String, ProfileHistoryRecord> _records = {};
  HistoryTab selectedTab = HistoryTab.all;
  HistoryRange selectedRange = HistoryRange.all;

  List<ProfileHistoryRecord> get visibleRecords {
    final now = _now();
    final cutoff = switch (selectedRange) {
      HistoryRange.all => null,
      HistoryRange.lastSevenDays => now.subtract(const Duration(days: 7)),
      HistoryRange.lastThirtyDays => now.subtract(const Duration(days: 30)),
    };
    final matching = _records.values.where((record) {
      return (selectedTab == HistoryTab.all || record.tab == selectedTab) &&
          (cutoff == null || !record.occurredAt.isBefore(cutoff)) &&
          !record.occurredAt.isAfter(now);
    }).toList();
    matching.sort((a, b) {
      final byTime = b.occurredAt.compareTo(a.occurredAt);
      return byTime == 0 ? a.id.compareTo(b.id) : byTime;
    });
    return List.unmodifiable(matching);
  }

  void selectTab(HistoryTab tab) {
    if (selectedTab == tab) return;
    selectedTab = tab;
    notifyListeners();
  }

  void selectRange(HistoryRange range) {
    if (selectedRange == range) return;
    selectedRange = range;
    notifyListeners();
  }
}
