import 'dart:convert';
import 'dart:io';

import 'package:babylog/datamodel/babylogassistant.dart';
import 'package:http/http.dart' as httpeuh;

import 'chatbot.dart';

Future<void> transcribeAudio(
  BabylogAssistant assistant,
  String filename,
  Function(String) _changeText,
  Function() resetRecord
) async {
  var request = httpeuh.MultipartRequest(
    'POST',
    Uri.parse('https://api.openai.com/v1/audio/transcriptions'),
  );

  request.headers.addAll({
    'Authorization': 'Bearer ${assistant.byok! ? assistant.apikey : assistant.devapikey}',
  });

  request.files.add(
    await httpeuh.MultipartFile.fromPath('file', filename),
  );

  request.fields['model'] = 'whisper-1';

  _changeText("sent for transcription");

  var streamedResponse = await request.send();
  final responseBytes = await streamedResponse.stream.toBytes();
  final decodedJson = utf8.decode(responseBytes);

  print(decodedJson);

  if (streamedResponse.statusCode == 200) {
    // Success
    Map<String, dynamic> data = jsonDecode(decodedJson);
    String userText = data['text'];
    _changeText(userText);
    interpret(assistant, userText, _changeText, resetRecord);
  } else {
    var error = "";
    // Optionally parse the error response if it's valid JSON:
    try {
      Map<String, dynamic> errorData = jsonDecode(decodedJson);
      // You might find "error" or something similar:
      print('Error details: ${errorData["error"] ?? "No error info"}');
      error = errorData["error"];
    } catch (e) {
      // If decoding fails, just print or log the raw text:
      print('Error parsing error response: $decodedJson');
      error = decodedJson;
    }
    
    // Error: could be wrong API key, invalid file, etc.
    _changeText('Failed to transcribe audio $error');
    resetRecord();
  }
}