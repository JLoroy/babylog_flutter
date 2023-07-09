import 'dart:convert';
import 'dart:io';
import 'package:babylog/datamodel/babylogevent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



FirebaseAuth? _auth;
FirebaseAuth get auth {
  return _auth ?? FirebaseAuth.instance;
}
  
String openAIKey = dotenv.env['OPENAI_API_KEY'] ?? '';
String systemPrompt = """Ton role est d'extraire les evenements important d'un texte donne par l'utilisateur. Les evenements peuvent etre du type:
                    - un bebe a bu du lait. Il est important de savoir combien il a bu. (en ml). Les biberons font 120ml
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

String logEvent(List events) {
  String resultText = "";
  for (var event in events) {
    var whenRaw = event['when'];
    var descriptionRaw = event['description'];
    var typeRaw = event['type'];
    //decode fore utf8
    var when = DateTime.parse(utf8.decode(latin1.encode(whenRaw)));
    var description = utf8.decode(latin1.encode(descriptionRaw));
    var type = utf8.decode(latin1.encode(typeRaw));

    resultText += "${DateFormat('dd/MM HH:mm').format(when)} | {$description}\n";

    var db = FirebaseFirestore.instance;
    db.collection('events').add(
      BabylogEvent(
        when: Timestamp.fromDate(when),
        description: "${event['description']}",
        by: auth.currentUser?.uid != null ? auth.currentUser!.email! : "anonymous",
        assistant: db.doc('assistants/6BM3kaQ4dO2aQJOVGQAU'),
        type: type,
        log: Timestamp.fromDate(DateTime.now())
      ).toFirestore()
    );
  }
  return resultText;
}

Future callGpt(String userInput) async {
  var url = Uri.parse('https://api.openai.com/v1/chat/completions');
  var body = json.encode({
    'model': 'gpt-4-0613',
    'messages': [
      {'role': 'system', 'content': systemPrompt},
      {'role': 'user', 'content': userInput}
    ],
    'functions': [
      {
        'name': 'log_event',
        'description':
            'enregistrer les evenements importants d\'un texte donne par l\'utilisateur',
        'parameters': {
          'type': 'object',
          'properties': {
            'events': {
              'type': 'array',
              'description': 'la liste des evenements',
              'items': {
                'type': 'object',
                'properties': {
                  'when': {
                    'type': 'string',
                    'description':
                        'quand l\'evenement est arrive en format YYYY-MM-DD HH:mm:SS cela peut etre approximatif'
                  },
                  'description': {
                    'type': 'string',
                    'description': 'description de l evenement'
                  },
                  'type': {
                    'type': 'string',
                    'description': 'doit etre bottle, medecine, parameter, hygiene ou other'
                  }
                }
              }
            }
          }
        }
      }
    ],
    'function_call': 'auto',
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $openAIKey',
    },
    body: body,
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['choices'][0]['message'];
  } else {
    print('Failed to load data from OpenAI.');
    throw Exception('Failed to load data');
  }
}

void interpret(String userInput, Function(String) _changeText, Function() resetRecord) async {
  var replyContent = await callGpt(userInput);
  var funcArg = replyContent['function_call']['arguments'];
  var func = json.decode(funcArg);
  var text = logEvent(func['events']);
  _changeText(text);
  resetRecord();
}
