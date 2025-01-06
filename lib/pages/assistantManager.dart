import 'package:babylog/pages/babylogapp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../datamodel/babylogassistant.dart';

class AssistantManager extends StatefulWidget {
  const AssistantManager({
    super.key, 
    required this.backToAuth,
  });
  final Function() backToAuth;

  @override
  State<AssistantManager> createState() => _AssistantManagerState();
}

class _AssistantManagerState extends State<AssistantManager> {
  FirebaseAuth? _auth;
  FirebaseAuth get auth {
    return _auth ?? FirebaseAuth.instance;
  }

  Future<BabylogAssistant?> loadOrCreateAssistant(User user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userDoc = await users.doc(user.uid).get();

    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null && userData.containsKey('current_assistant')) {
        // Load assistant if it exists
        DocumentReference assistantRef = userData['current_assistant'];
        DocumentSnapshot assistantDoc = await assistantRef.get();

        // Check if the assistant document actually exists
        if (assistantDoc.exists) {
          var ass =  BabylogAssistant.fromFirestore(assistantDoc, null);
          await ass.fetchEvents();
          return ass;

        } else {
          // If the assistant document does not exist, create a new one
          return createAssistant(user, userDoc, users);
        }
      } else {
        // If 'current_assistant' field does not exist in the user document, create a new assistant
        return createAssistant(user, userDoc, users);
      }
    } else {
      // If user document does not exist, create it and a new assistant
      await users.doc(user.uid).set({'email': user.email});
      userDoc = await users.doc(user.uid).get();
      return createAssistant(user, userDoc, users);
    }
  }

  Future<BabylogAssistant?> createAssistant(User user, DocumentSnapshot userDoc, CollectionReference users) async {
    // Create new assistant
    DocumentReference assistantRef = await FirebaseFirestore.instance.collection('assistants').add(
      BabylogAssistant(
        assistantId: "notimportant",
        name: "Baby", 
        language: "fr", 
        apikey: "key", 
        users: [user.email!], 
        promptsettings: {"bottle_ml":"120", "baby_name":"Basile", "medicine":"gaviscon, fer, vitamineD, anticholique"},
      ).toFirestore()
    );
    // Update user document with new assistant
    await users.doc(user.uid).update({'current_assistant': assistantRef});
    // Reload assistant
    return loadOrCreateAssistant(user);
  }

  void saveAssistant(BabylogAssistant newAssistant) async {
    // Get a reference to the assistant's document in Firestore.
    DocumentReference assistantRef = FirebaseFirestore.instance.collection('assistants').doc(newAssistant.assistantId);
    await assistantRef.update(newAssistant.toFirestore());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BabylogAssistant?>(
      future: auth.currentUser != null ? loadOrCreateAssistant(auth.currentUser!) : null,
      builder: (BuildContext context, AsyncSnapshot<BabylogAssistant?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFFCF7F3),
            body: Center(child: CircularProgressIndicator()),
          ); // Or any other loading widget
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return BabylogApp(
            assistant: snapshot.data!,
            saveAssistant: saveAssistant,
            backToAuth: widget.backToAuth
            );
        }
      },
    );
  }
}