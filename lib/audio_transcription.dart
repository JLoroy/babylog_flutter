import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';

Future<void> transcribeAudio(String filename, TextEditingController text_controller) async {
  var request = http.MultipartRequest(
    'POST', 
    Uri.parse('https://api.openai.com/v1/audio/transcriptions')
  );

  request.headers.addAll({
    'Authorization': 'Bearer <key>',
  });

  request.files.add(
    await http.MultipartFile.fromPath(
      'file',
      filename,
    ),
  );

  request.fields['model'] = 'whisper-1';

  var response = await request.send();

  if (response.statusCode == 200) {
    text_controller.text = 'Transcription successful!';
} else {
    text_controller.text = 'Failed to transcribe audio';
  }
}
