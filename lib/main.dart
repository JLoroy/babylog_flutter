import 'dart:async';

import 'package:babylog/timeline.dart';
import 'package:babylog/topbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:record/record.dart';
import 'package:babylog/audio_player.dart';
import 'package:babylog/audio_transcription.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  var box = await Hive.openBox('babylogBox');
  box.put(1688616763,["biberon de 120ml\nfer (4 gouttes)\nanti-cholique"]);
  box.put(1688620363,["bebe a fait caca"]);
  box.put(1688623763,["biberon 120ml\npas de rot"]);
  box.put(1688626363,["caca\ntemperature 36.6°"]);
  box.put(1688630763,["biberon 120ml"]);
  box.put(1688633363,["bebe a fait caca"]);
  box.put(1688638763,["bebe a bu 120ml"]);
  box.put(1688642363,["bebe a fait caca"]);
  
  // Dart uses for-in loop, not for loop like Python
  for (var val in box.values) {
    print(val);
  }
  
  runApp(const BabylogApp());
}
class AudioRecorder extends StatefulWidget {
  final void Function(String path) onStop;

  const AudioRecorder({Key? key, required this.onStop}) : super(key: key);

  @override
  State<AudioRecorder> createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  int _recordDuration = 0;
  Timer? _timer;
  final _audioRecorder = Record();
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;

  @override
  void initState() {
    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      setState(() => _recordState = recordState);
    });

    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) => setState(() => _amplitude = amp));

    super.initState();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // We don't do anything with this but printing
        final isSupported = await _audioRecorder.isEncoderSupported(
          AudioEncoder.aacLc,
        );
        if (kDebugMode) {
          print('${AudioEncoder.aacLc.name} supported: $isSupported');
        }

        // final devs = await _audioRecorder.listInputDevices();
        // final isRecording = await _audioRecorder.isRecording();

        await _audioRecorder.start();
        _recordDuration = 0;

        _startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _recordDuration = 0;

    final path = await _audioRecorder.stop();

    if (path != null) {
      widget.onStop(path);
    }
  }

  Future<void> _pause() async {
    _timer?.cancel();
    await _audioRecorder.pause();
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildRecordStopControl(),
                //const SizedBox(width: 20),
                //_buildPauseResumeControl(),
                //const SizedBox(width: 20),
                //_buildText(),
              ],
            )
          ],
        );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_recordState != RecordState.stop) {
      icon = const Icon(Icons.stop, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      // icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
      // color = theme.primaryColor.withOpacity(0.1);
      icon = Icon(Icons.mic, color: Color.fromARGB(255, 246, 124, 124), size: 30);
      color = Color(0xFFFCF7F3);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState != RecordState.stop) ? _stop() : _start();
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl() {
    if (_recordState == RecordState.stop) {
      return const SizedBox.shrink();
    }

    late Icon icon;
    late Color color;

    if (_recordState == RecordState.record) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow, color: Colors.red, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState == RecordState.pause) ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    if (_recordState != RecordState.stop) {
      return _buildTimer();
    }

    return const Text("Waiting to record");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }
}

class BabylogApp extends StatefulWidget {
  const BabylogApp({Key? key}) : super(key: key);

  @override
  State<BabylogApp> createState() => _BabylogAppState();
}

class _BabylogAppState extends State<BabylogApp> {
  bool showPlayer = false;
  String? audioPath;

  String _descriptionText = 'Initial Text';
  

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  void _changeText(String t) {
    setState(() {
      _descriptionText = t;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    _changeText("");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Babylog',
      home: Scaffold(
        backgroundColor: Color(0xFFFCF7F3),
        body: Stack(
          children: [
            Positioned(
              top:100,
              left:0,
              right:0,
              child: Container(height:500,child: BabyTimeline())
            ),
            TopBar(),
            Positioned(
              left:0,
              right:0,
              bottom:0,
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                  color:Color(0xFFFFD55C),
                  borderRadius: BorderRadius.only(topRight:Radius.circular(50)),
                  boxShadow: [BoxShadow(blurRadius: 10, offset:Offset(0, -5) ,color: Color.fromARGB(89, 195, 168, 146))],
                ),
                child: Column(
                  children: [ 
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 2, 2, 2),
                            height:80,
                            width:250,
                            decoration:BoxDecoration(color:Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: SingleChildScrollView (
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey, 
                                      fontSize: 11
                                    ),
                                    _descriptionText,
                                  ),
                                ]
                              ),
                            )
                          ), 
                          Container(
                            height:80,
                            width:100,
                            child: showPlayer
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 35),
                                child: AudioPlayer(
                                  source: audioPath!,
                                  onDelete: () {
                                    setState(() => showPlayer = false);
                                  },
                                ),
                              )
                             : AudioRecorder(
                                onStop: (path) {
                                  if (kDebugMode) print('Recorded file path: $path');
                                  transcribeAudio(path, _changeText);
                                  setState(() {
                                    audioPath = path;
                                    showPlayer = true;
                                  });
                                },
                              ),
                          ) 
                          
                        ]
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}