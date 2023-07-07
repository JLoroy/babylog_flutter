import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

String openAIKey = Platform.environment['OPENAI_API_KEY'] ?? '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';
String systemPrompt = """Ton role est d'extraire les evenements important d'un texte donne par l'utilisateur. Les evenements peuvent etre du type:
                    - un bebe a bu du lait. Il est important de savoir combien il a bu. (en ml). Les biberons font 120ml
                    - un bebe a fait un caca. 
                    - un bebe a pris un medicament (du fer, du gaviscon, des vitamines D)

                    Tu vas devoir egalement deviner la date et l'heure de l'evenement. Pour information nous somme le ${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}. Cela peut etre approximatif.  
                    """;

String logEvent(List events) {
  String resultText = "";
  for (var event in events) {
    resultText += "${event['when']} | ${event['description']}\n";
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

void interpret(String userInput, Function(String) _changeText) async {
  var replyContent = await callGpt(userInput);
  var funcArg = replyContent['function_call']['arguments'];
  print(funcArg);
  var func = json.decode(funcArg);
  var text = logEvent(func['events']);
  print(text);
  _changeText(text);
}
