import 'package:flutter/material.dart';
import 'package:babylog/recorder.dart';
import 'package:babylog/audio_transcription.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  // SimpleRecorder _recorder = SimpleRecorder();
  // bool _isRecording = false;
  final _controller = TextEditingController();


  // void _toggleRecording() async {
  //   if (_isRecording) {
  //     await _recorder.stopRecording();
  //     setState(() {
  //       _isRecording = false;
  //     });
  //   } else {
  //     await _recorder._SimpleRecorderState.record();
  //     setState(() {
  //       _isRecording = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Babylog'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          TextField(controller: _controller),
          // FloatingActionButton(
          //   onPressed: _toggleRecording,
          //   child: Icon(_isRecording ? Icons.stop : Icons.mic),
          // ),
          SimpleRecorder(),
          ElevatedButton(
            onPressed: () {transcribeAudio("test.mp3", _controller);},
            child: Text('Send')
          )
        ].map((widget) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: widget,
        )).toList(),
      ),
    );
  }

}
