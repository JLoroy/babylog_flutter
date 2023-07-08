import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as httpeuh;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'chatbot.dart';

String openAIKey = dotenv.env['OPENAI_API_KEY'] ?? '';

Future<void> transcribeAudio(String filename, Function(String) _changeText) async {
  var request = httpeuh.MultipartRequest(
    'POST', 
    Uri.parse('https://api.openai.com/v1/audio/transcriptions')
  );

  request.headers.addAll({
    'Authorization': 'Bearer '+openAIKey,
  });

  request.files.add(
    await httpeuh.MultipartFile.fromPath(
      'file',
      filename,
    ),
  );

  request.fields['model'] = 'whisper-1';

  _changeText("sent for transcription");
  var streamedResponse = await request.send();
  var response = await httpeuh.Response.fromStream(streamedResponse);
  print(response.body);

  if (response.statusCode == 200) {
    jsonDecode(response.body)['text'];
      // Étape 1 : Décoder le JSON
    Map<String, dynamic> data = jsonDecode(response.body);

    // Étape 2 : Encoder la string en latin1
    List<int> latin1Bytes = latin1.encode(data['text']);

    // Étape 3 : Décoder la liste d'octets en UTF-8
    var userText = utf8.decode(latin1Bytes);
    _changeText(userText);
    interpret(userText, _changeText);
} else {
    _changeText('Failed to transcribe audio');
  }
}
