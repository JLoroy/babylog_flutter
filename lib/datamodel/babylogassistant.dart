import 'package:babylog/datamodel/babylogevent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


BabylogAssistant defaultAssistant(User user) {
  return BabylogAssistant(
      assistantId: "notimportant",
      name: "Baby", 
      language: "fr", 
      byok: false, 
      apikey: "", 
      usage: 100, 
      users: [user.email!], 
      promptsettings: {"bottle_ml":"120", "baby_name":"Basile", "medicine":"gaviscon, fer, vitamineD, anticholique"},
    );
}
BabylogAssistant anonAssistant() {
  return BabylogAssistant(
      assistantId: "notimportant",
      name: "Baby", 
      language: "fr", 
      byok: false, 
      apikey: "", 
      usage: 100, 
      users: ["notimportant"], 
      promptsettings: {"bottle_ml":"120", "baby_name":"Basile", "medicine":"gaviscon, fer, vitamineD, anticholique"},
    );
}

class BabylogAssistant {
  final String? assistantId;
  final String? name;
  final String? language;
  final bool? byok;
  final String? apikey;
  int? usage;
  final List<String>? users;
  final Map<String, String>? promptsettings;

  List<BabylogEvent>? _events;
  String? _devapikey;

  BabylogAssistant({
    required this.assistantId,
    required this.name,
    required this.language,
    required this.byok,
    required this.apikey,
    required this.usage,
    required this.users,
    required this.promptsettings,
  }) {
    fetchDevApiKey();
  }

  fetchEvents() async {
    var eventsQuery = FirebaseFirestore.instance.collection('events')
      .where("assistant", isEqualTo: "${assistantId}")
      .orderBy('when')
      .withConverter<BabylogEvent>(
        fromFirestore: (snapshot, _) => BabylogEvent.fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (BabylogEvent event, _) => event.toJson(),
      );

    await eventsQuery.get().then((data) {
      final List<DocumentSnapshot<BabylogEvent>> documents = data.docs;
      _events = documents.map((doc) => doc.data()!).toList();
    });
  }

  fetchDevApiKey() async {
    CollectionReference assistants = FirebaseFirestore.instance.collection('assistants');
    DocumentSnapshot devAssistantDoc = await assistants.doc("WF5u5xEk6asldWoefz6r").get();
    if (devAssistantDoc.exists) {
      Map<String, dynamic>? devAssistantData = devAssistantDoc.data() as Map<String, dynamic>?;
      if (devAssistantData != null && devAssistantData.containsKey('apikey')) {
        _devapikey = devAssistantData['apikey'];
      }
    }
  }

  BabylogAssistant.fromJson(Map<String, Object?> json)
    : this(
        assistantId: json['id']! as String,
        name: json['name']! as String,        
        language: json['language']! as String,
        byok: json['byok']! as bool,
        apikey: json['apikey']! as String,
        usage: json['usage']! as int,
        users: json['users'] is Iterable ? List.from(json['users']  as Iterable<dynamic>) : null,
        promptsettings: json['promptsettings'] is Map ? Map<String, String>.from(json['promptsettings'] as Map<String, String>) : null,
      );



  Map<String, Object?> toJson() {
    return {
      'name': name,      
      'language': language,
      'byok': byok,
      'apikey': apikey,
      'usage': usage,
      'users': users,
      'promptsettings': promptsettings,  
    };
  }

  factory BabylogAssistant.fromFirestore(
    DocumentSnapshot<Object?> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data() as Map<String, dynamic>?;
    return BabylogAssistant(
      assistantId: snapshot.id,
      name: data?['name'],
      language: data?['language'],
      byok: data?['byok'],
      apikey: data?['apikey'],
      usage: data?['usage'],
      users: data?['users'] is Iterable ? List.from(data?['users']) : null,
      promptsettings: data?['promptsettings'] is Map ? Map<String, String>.from(data?['promptsettings']) : null,
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (language != null) "language": language,
      if (byok != null) "byok": byok,
      if (apikey != null) "apikey": apikey,
      if (usage != null) "usage": usage,
      if (users != null) "users": users,
      if (promptsettings != null) "promptsettings": promptsettings
    };
  }

  List<BabylogEvent> get events {
    if (_events == null){
      fetchEvents();
      return [];
    }
    else {
      return _events!;
    }
  }
  String get devapikey {
    if (_devapikey == null){
      fetchDevApiKey();
      return "";
    }
    else {
      return _devapikey!;
    }
  }

  
  Stream<List<BabylogEvent>> get eventsStream {
    return FirebaseFirestore.instance.collection('events')
      .where("assistant", isEqualTo: assistantId)
      .orderBy('when')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) => BabylogEvent.fromJson(doc.id, doc.data())).toList();
      });
  }

  // add an event to the assistant
  void addEvent(BabylogEvent event){
    var db = FirebaseFirestore.instance;
    db.collection('events').add(event.toFirestore());
    fetchEvents();
  }

  //decrement usage
  void decrementUsage(){
    if (usage != null && usage! > 0) {
      var db = FirebaseFirestore.instance;
      db.collection('assistants').doc(assistantId).update({'usage': usage! - 1});
      usage = usage! - 1;
    }
  }

  // delete an event from the assistant
  void deleteEvent(BabylogEvent event){
    var db = FirebaseFirestore.instance;
    //delete all events with id from event.ids
    event.ids!.forEach((id) {
      db.collection('events').doc(id).delete();
    });
    fetchEvents();
  }

  //delete all events
  void deleteAllEvents(){
    var db = FirebaseFirestore.instance;
    events.forEach((event) {
      event.ids!.forEach((id) {
        db.collection('events').doc(id).delete();
      });
    });
    fetchEvents();
  }


}