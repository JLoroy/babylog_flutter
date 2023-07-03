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

  var response = await request.send();

  if (response.statusCode == 200) {
    textController.text = 'Transcription successful!';
} else {
    textController.text = 'Failed to transcribe audio';
  }
}
