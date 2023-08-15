import 'package:cloud_firestore/cloud_firestore.dart';

class BabylogEvent {
  final List<String>? ids;
  final Timestamp? when;
  final String? description;
  final String? by;
  final String? assistant;
  final String? type;
  final Timestamp? log;


  BabylogEvent({
    required this.ids,
    required this.when, 
    required this.description,
    required this.by,
    required this.assistant,
    required this.type,
    required this.log,
    });

  BabylogEvent.fromJson(String id, Map<String, Object?> json)
    : this(
        ids: [id],
        when: json['when']! as Timestamp,        
        description: json['description']! as String,
        by: json['by']! as String,
        assistant: json['assistant']! as String,
        type: json['type']! as String,
        log: json['log']! as Timestamp
      );


  Map<String, Object?> toJson() {
    return {
      'when': when,      
      'description': description,
      'by': by,
      'assistant': assistant,
      'type': type,      
      'log': log,
    };
  }
  
  factory BabylogEvent.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return BabylogEvent(
      ids: [snapshot.id],
      when: data?['when'],
      description: data?['description'],
      by: data?['by'],
      assistant: data?['assistant'],
      type: data?['type'],
      log: data?['log'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (when != null) "when": when,
      if (description != null) "description": description,
      if (by != null) "by": by,
      if (assistant != null) "assistant": assistant,
      if (type != null) "type": type,
      if (log != null) "log": log,
    };
  }

  static BabylogEvent merge(List<BabylogEvent> events) {
    if (events.isEmpty) {
      throw ArgumentError('Cannot merge empty list');
    }

    events.sort((a, b) => b.log!.compareTo(a.log!));  // Sort by log, latest first

    return BabylogEvent(
      //append the list of ids
      ids: events.map((e) => e.ids!).expand((i) => i).toList(),
      when: events.first.when,
      description: events.map((e) => e.description!).join('\n'),
      by: events.first.by,
      assistant: events.first.assistant,
      type: events.first.type,
      log: events.first.log,
    );
  }
}