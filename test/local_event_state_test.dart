import 'package:actirune/features/home/local_event_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const owner = LocalEventOwner();

  test('approved-artwork references have stable distinct identities', () {
    expect(owner.visibleFor(EventsFilter.active).map((e) => e.id).toList(), [
      'rune-storm',
      'movement-master-week',
      'ancient-valley-challenge',
    ]);
    expect(owner.byId('movement-master-week').title, 'Hareket Ustası Haftası');
    expect(
      owner.byId('ancient-valley-challenge').title,
      'Kadim Vadi Mücadelesi',
    );
    expect(() => owner.byId('unknown'), throwsArgumentError);
  });

  test('upcoming and completed filters have no invented records', () {
    expect(owner.visibleFor(EventsFilter.upcoming), isEmpty);
    expect(owner.visibleFor(EventsFilter.completed), isEmpty);
  });
}
