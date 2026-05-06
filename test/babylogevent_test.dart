import 'package:babylog/datamodel/babylogevent.dart';
import 'package:babylog/components/event_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('serializes only populated event fields for Firestore', () {
    final when = Timestamp.fromDate(DateTime.utc(2026, 5, 5, 12));
    final log = Timestamp.fromDate(DateTime.utc(2026, 5, 5, 12, 5));
    final event = BabylogEvent(
      ids: const ['event-1'],
      when: when,
      description: 'Baby drank 120 ml',
      by: 'parent@example.com',
      assistant: 'assistant-1',
      type: 'bottle',
      log: log,
    );

    expect(event.toFirestore(), {
      'when': when,
      'description': 'Baby drank 120 ml',
      'by': 'parent@example.com',
      'assistant': 'assistant-1',
      'type': 'bottle',
      'log': log,
    });
  });

  test('merges event ids and descriptions using the latest log first', () {
    final earlierLog = Timestamp.fromDate(DateTime.utc(2026, 5, 5, 12));
    final laterLog = Timestamp.fromDate(DateTime.utc(2026, 5, 5, 12, 5));
    final when = Timestamp.fromDate(DateTime.utc(2026, 5, 5, 11, 45));

    final merged = BabylogEvent.merge([
      BabylogEvent(
        ids: const ['older'],
        when: when,
        description: 'changed diaper',
        by: 'parent@example.com',
        assistant: 'assistant-1',
        type: 'diaper',
        log: earlierLog,
      ),
      BabylogEvent(
        ids: const ['newer'],
        when: when,
        description: 'wet diaper',
        by: 'parent@example.com',
        assistant: 'assistant-1',
        type: 'diaper',
        log: laterLog,
      ),
    ]);

    expect(merged.ids, ['newer', 'older']);
    expect(merged.description, 'wet diaper\nchanged diaper');
    expect(merged.log, laterLog);
  });

  test('maps unknown event types to the existing fallback icon asset', () {
    expect(eventIconAssetForType('bottle'), 'assets/bottle.svg');
    expect(eventIconAssetForType('note'), 'assets/other.svg');
    expect(eventIconAssetForType('diaper'), 'assets/other.svg');
    expect(eventIconAssetForType(null), 'assets/other.svg');
  });
}
