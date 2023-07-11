import 'package:cloud_firestore/cloud_firestore.dart';

class BabylogAssistant {
  final String? name;
  final String? language;
  final String? apikey;
  final List<String>? users;
  final Map<String, String>? promptsettings;


  BabylogAssistant({
    required this.name, 
    required this.language,
    required this.apikey,
    required this.users,
    required this.promptsettings,
    });

  BabylogAssistant.fromJson(Map<String, Object?> json)
    : this(
        name: json['name']! as String,        
        language: json['language']! as String,
        apikey: json['apikey']! as String,
        users: json['users'] is Iterable ? List.from(json['users']  as Iterable<dynamic>) : null,
        promptsettings: json['promptsettings'] is Map ? Map<String, String>.from(json['promptsettings'] as Map<String, String>) : null,
      );


  Map<String, Object?> toJson() {
    return {
      'name': name,      
      'language': language,
      'apikey': apikey,
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
      name: data?['name'],
      language: data?['language'],
      apikey: data?['apikey'],
      users: data?['users'] is Iterable ? List.from(data?['users']) : null,
      promptsettings: data?['promptsettings'] is Map ? Map<String, String>.from(data?['promptsettings']) : null,
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (language != null) "language": language,
      if (apikey != null) "apikey": apikey,
      if (users != null) "users": users,
      if (promptsettings != null) "promptsettings": promptsettings
    };
  }

}