import 'package:flutter/foundation.dart';

enum InboxCategory { all, social, system }

@immutable
class InboxMessage {
  const InboxMessage({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.order,
    this.isRead = false,
  });

  final String id;
  final InboxCategory category;
  final String title;
  final String summary;
  final int order;
  final bool isRead;
}

/// User-independent examples transcribed from the approved Inbox artwork.
/// This is local display data, not an account inbox or network message feed.
class LocalInboxOwner extends ChangeNotifier {
  LocalInboxOwner({List<InboxMessage>? messages})
    : _messages = List.unmodifiable(messages ?? sampleMessages) {
    if (_messages.any((message) => message.category == InboxCategory.all) ||
        _messages.map((message) => message.id).toSet().length !=
            _messages.length) {
      throw ArgumentError(
        'Inbox records require unique IDs and a real category',
      );
    }
  }

  static const sampleMessages = <InboxMessage>[
    InboxMessage(
      id: 'sample-wolfrune',
      category: InboxCategory.social,
      title: 'WOLFRUNE',
      summary: 'Meydan okuma örneği',
      order: 0,
    ),
    InboxMessage(
      id: 'sample-karalumi',
      category: InboxCategory.social,
      title: 'KARALUMI',
      summary: 'Tebrik mesajı örneği',
      order: 1,
    ),
    InboxMessage(
      id: 'sample-arven',
      category: InboxCategory.social,
      title: 'ARVEN',
      summary: 'Arkadaşlık isteği örneği',
      order: 2,
    ),
    InboxMessage(
      id: 'sample-gold-league',
      category: InboxCategory.system,
      title: 'Altın Lig II',
      summary: 'Lig bildirimi örneği',
      order: 3,
    ),
    InboxMessage(
      id: 'sample-rune-season',
      category: InboxCategory.system,
      title: 'Rune Sezonu',
      summary: 'Sezon bildirimi örneği',
      order: 4,
    ),
  ];

  final List<InboxMessage> _messages;
  InboxCategory _selected = InboxCategory.all;

  InboxCategory get selected => _selected;
  List<InboxMessage> get visible => List.unmodifiable(
    (_messages
        .where(
          (message) =>
              _selected == InboxCategory.all || message.category == _selected,
        )
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order))),
  );

  void select(InboxCategory category) {
    if (_selected == category) return;
    _selected = category;
    notifyListeners();
  }
}
