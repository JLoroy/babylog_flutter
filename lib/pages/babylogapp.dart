
import 'package:babylog/components/recorder.dart';
import 'package:babylog/components/timeline.dart';
import 'package:babylog/components/topbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import '../scripts/audio_transcription.dart';

class BabylogApp extends StatefulWidget {
  const BabylogApp({Key? key}) : super(key: key);
  @override
  State<BabylogApp> createState() => _BabylogAppState();
}

class _BabylogAppState extends State<BabylogApp> {
  bool showPlayer = false;
  String? audioPath;

  FirebaseAuth? _auth;
  FirebaseAuth get auth {
    return _auth ?? FirebaseAuth.instance;
  }

  String _descriptionText = '';
  

  @override
  void initState() {
    showPlayer = false;
    _changeText(auth.currentUser?.uid != null ? auth.currentUser!.email! : "anon");
    super.initState();
  }

  void _changeText(String t) {
    setState(() {
      _descriptionText = t;
    });
  }

  void resetRecord() {
    setState(() {
      showPlayer = false;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    auth.authStateChanges().listen((User? user){
      if (user == null){
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    });
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
              bottom:130,
              child: Container(child: BabyTimeline())
            ),
            TopBar(auth: auth),
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
                            width:MediaQuery.of(context).size.width - 120,
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
                            width: 80,
                            child: showPlayer
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CircularProgressIndicator(strokeWidth: 12,color:Color(0xFFFF6B6B)),
                                  ],
                                )]
                              )
                             : AudioRecorder(
                                onStop: (path) {
                                  if (kDebugMode) print('Recorded file path: $path');
                                  transcribeAudio(path, _changeText, resetRecord);
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