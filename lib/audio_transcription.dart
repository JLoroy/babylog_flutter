import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<void> transcribeAudio(String filename, TextEditingController textController) async {
  var request = http.MultipartRequest(
    'POST', 
    Uri.parse('https://api.openai.com/v1/audio/transcriptions')
  );

  request.headers.addAll({
    'Authorization': 'Bearer sk-',
  });

  request.files.add(
    await http.MultipartFile.fromPath(
      'file',
      filename,
    ),
  );

  request.fields['model'] = 'whisper-1';

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  print(response.body);

  if (response.statusCode == 200) {
    jsonDecode(response.body)['text'];
      // Étape 1 : Décoder le JSON
    Map<String, dynamic> data = jsonDecode(response.body);

    // Étape 2 : Encoder la string en latin1
    List<int> latin1Bytes = latin1.encode(data['text']);

    // Étape 3 : Décoder la liste d'octets en UTF-8
    textController.text = utf8.decode(latin1Bytes);
} else {
    textController.text = 'Failed to transcribe audio';
  }
}
