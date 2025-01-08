import 'dart:convert';
import 'dart:io';
import 'package:babylog/datamodel/babylogassistant.dart';
import 'package:babylog/datamodel/babylogevent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Event {
  final DateTime when;
  final String description;
  final String type;

  Event({required this.when, required this.description, required this.type});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      when: DateTime.parse(json['when']),
      description: json['description'],
      type: json['type'],
    );
  }
}

FirebaseAuth? _auth;
FirebaseAuth get auth {
  return _auth ?? FirebaseAuth.instance;
}
  
String systemPrompt = """Ton role est d'extraire les evenements important d'un texte donne par l'utilisateur. Les evenements peuvent etre du type:
                    - un bebe a bu du lait. Il est important de savoir combien il a bu. (en ml). Les biberons font 120ml en general. 
                    - un bebe a fait un caca. 
                    - un bebe a pris un medicament (du fer, du gaviscon, des vitamines D)

                    Tu vas devoir egalement deviner la date et l'heure de l'evenement. Pour information nous somme le ${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}. Cela peut etre approximatif.  
                    Pour finir, tu dois aussi donner le type de l'evenement. On differencie ces types : 
                     - bottle pour tout ce qui est biberon
                     - medicine pour ce qui est medicaments
                     - parameter lorsqu'on prend la temperature, le poids, la taille ou tout autre parametre du bébé
                     - hygiene s'il s'agit d'un caca, d'un bain, d'un changement de vetement
                     - other pour tout autre evenement 
                    """;

String logEvent(BabylogAssistant assistant, List<Event> events) {
  String resultText = "";
  for (var event in events) {
    //decode for utf8
    //var when = DateTime.parse(utf8.decode(latin1.encode(event.)));
    //var description = utf8.decode(latin1.encode(descriptionRaw));
    //var type = utf8.decode(latin1.encode(typeRaw));

    resultText += "${DateFormat('dd/MM HH:mm').format(event.when)} | ${event.description}\n";

    assistant.addEvent(
      BabylogEvent(
        ids: [],
        when: Timestamp.fromDate(event.when),
        description: event.description,
        by: auth.currentUser?.uid != null ? auth.currentUser!.email! : "anonymous",
        assistant: "${assistant.assistantId}",
        type: event.type,
        log: Timestamp.fromDate(DateTime.now())
      )
    );
  }
  if (assistant.byok == false) {
    assistant.decrementUsage();
    print("DECREMENT USAGE");
  }
  return resultText;
}

Future<List<Event>> getEventsFromText(String userInput, BabylogAssistant assistant) async {
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');
  final body = json.encode({
    'model': 'gpt-4o-mini',
    'messages': [
      {'role': 'system', 'content': systemPrompt},
      {'role': 'user', 'content': userInput}
    ],
    'response_format': {
      'type': 'json_schema',
      'json_schema': {
        'name': 'log_event_response',
        'strict': true,
        'schema': {
          'type': 'object',
          'properties': {
            'events': {
              'type': 'array',
              'items': {
                'type': 'object',
                'properties': {
                  'when': {'type': 'string'},
                  'description': {'type': 'string'},
                  'type': {'type': 'string'}
                },
                'required': ['when', 'description', 'type'],
                'additionalProperties': false
              }
            }
          },
          'required': ['events'],
          'additionalProperties': false
        }
      }
    }
  });

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${assistant.byok! ? assistant.apikey : assistant.devapikey}',
    },
    body: body,
  );

  // Force UTF-8 decoding to avoid garbled text
  final decodedJson = utf8.decode(response.bodyBytes);

  if (response.statusCode == 200) {
    final responseBody = json.decode(decodedJson);

    if (responseBody['choices'] != null && responseBody['choices'].isNotEmpty) {
      final replyContent = responseBody['choices'][0]['message'];
      if (replyContent != null && replyContent.containsKey('content')) {
        final content = json.decode(replyContent['content']);
        if (content.containsKey('events')) {
          return (content['events'] as List)
              .map((event) => Event.fromJson(event))
              .toList();
        } else {
          throw Exception('Response does not contain "events" object.');
        }
      } else {
        throw Exception('Response does not contain "content" object.');
      }
    } else {
      throw Exception('Invalid response format from OpenAI.');
    }
  } else {
    throw Exception('Failed to load data from OpenAI. Status code: ${response.statusCode}');
  }
}


void interpret(BabylogAssistant assistant, String userInput, Function(String) _changeText, Function() resetRecord) async {
  try {
    final events = await getEventsFromText(userInput, assistant);
    final text = logEvent(assistant, events);
    _changeText(text);
    resetRecord();
  } catch (e) {
    print('Error interpreting response: $e');
    _changeText('An error occurred while processing your request.');
  }
}
