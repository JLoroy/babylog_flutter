
import 'package:babylog/components/recorder.dart';
import 'package:babylog/components/timeline.dart';
import 'package:babylog/datamodel/babylogassistant.dart';
import 'package:babylog/pages/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import '../scripts/audio_transcription.dart';

class BabylogApp extends StatefulWidget {
  //const BabylogApp({Key? key}) : super(key: key);
  const BabylogApp({super.key, required this.assistant});
  final BabylogAssistant? assistant;

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

  BabylogAssistant? currentAssistant;

  String _descriptionText = '';

  @override
  void initState() {
    print("INITIALIZATION");
    super.initState();
    showPlayer = false;
    currentAssistant = widget.assistant;
    if (currentAssistant == null || currentAssistant!.name != null){
      print("WHERE IS HE?");
    }
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
  
  void signOutFromBabylog(BuildContext context) {
    FirebaseUIAuth.signOut(context: context, auth: auth);
    //bye
  }


  
  @override
  Widget build(BuildContext context) {
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
            Column(
              children: [
                SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFCF7F3),
                    boxShadow: [BoxShadow(blurRadius: 20, offset: Offset(0, 15), color: Color(0xFFFCF7F3))],
                  ),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentAssistant != null && currentAssistant!.name != null ? currentAssistant!.name! : "Louisa",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontStyle: FontStyle.normal, fontSize: 24),
                            ),
                            Text("Babylog Assistant", style: TextStyle(letterSpacing: 1.5, fontSize: 12)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            PopupMenuButton<int>(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: Text("Seettings"),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Text("Sign Out"),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 1) {
                                  // Navigate to Settings page
                                  print(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SettingsPage(assistant: currentAssistant),
                                    ),
                                  );
                                } else if (value == 2) {
                                  // Sign out
                                  signOutFromBabylog(context);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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