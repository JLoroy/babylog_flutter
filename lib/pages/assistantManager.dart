import 'package:babylog/pages/babylogapp.dart';
import 'package:babylog/services/openai_api_key.dart';
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
  final OpenAiApiKeyStore _apiKeyStore = OpenAiApiKeyStore();
  FirebaseAuth get auth {
    return _auth ?? FirebaseAuth.instance;
  }

  Future<BabylogAssistant?> loadOrCreateAssistant(User user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userDoc = await users.doc(user.uid).get();

    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null && userData.containsKey('current_assistant')) {
        final assistantRef = userData['current_assistant'];

        if (assistantRef is! DocumentReference) {
          return createAssistant(user, userDoc, users);
        }

        DocumentSnapshot assistantDoc;
        try {
          assistantDoc = await assistantRef.get();
        } on FirebaseException catch (error) {
          if (error.code == 'permission-denied') {
            return createAssistant(user, userDoc, users);
          }
          rethrow;
        }

        // Check if the assistant document actually exists
        if (assistantDoc.exists) {
          var ass = BabylogAssistant.fromFirestore(assistantDoc, null);
          await ass.fetchEvents();
          return _withLocalApiKey(ass);
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

  Future<BabylogAssistant?> createAssistant(
      User user, DocumentSnapshot userDoc, CollectionReference users) async {
    // Create new assistant
    DocumentReference assistantRef = await FirebaseFirestore.instance
        .collection('assistants')
        .add(defaultAssistant(user).toFirestore());
    // Update user document with new assistant
    await users.doc(user.uid).update({'current_assistant': assistantRef});
    // Reload assistant
    return loadOrCreateAssistant(user);
  }

  Future<BabylogAssistant> _withLocalApiKey(BabylogAssistant assistant) async {
    final localApiKey = await _apiKeyStore.readApiKey(assistant.assistantId);
    return assistant.copyWith(apikey: localApiKey ?? '');
  }

  void saveAssistant(BabylogAssistant newAssistant) async {
    await _apiKeyStore.saveApiKey(
      newAssistant.assistantId,
      newAssistant.byok == true ? newAssistant.apikey ?? '' : '',
    );
    // Get a reference to the assistant's document in Firestore.
    DocumentReference assistantRef = FirebaseFirestore.instance
        .collection('assistants')
        .doc(newAssistant.assistantId);
    await assistantRef.update(newAssistant.toFirestore());
    setState(() {});
  }

  void joinAssistant(String newAssistantId) async {
    DocumentReference assistantRef =
        FirebaseFirestore.instance.collection('assistants').doc(newAssistantId);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final currentUser = auth.currentUser;

    if (currentUser?.email == null) {
      return;
    }

    await assistantRef.update({
      'users': FieldValue.arrayUnion([currentUser!.email!]),
    });
    await users.doc(currentUser.uid).update({
      'current_assistant': assistantRef,
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BabylogAssistant?>(
      future: auth.currentUser != null
          ? loadOrCreateAssistant(auth.currentUser!)
          : null,
      builder:
          (BuildContext context, AsyncSnapshot<BabylogAssistant?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFFCF7F3),
            body: Center(child: CircularProgressIndicator()),
          ); // Or any other loading widget
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFFFCF7F3),
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_off_rounded,
                        color: Color(0xFFB5534C),
                        size: 40,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Babylog could not load this account.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please sign out and try again. If this is an old account, Babylog may need a fresh assistant timeline.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () async {
                          await auth.signOut();
                          widget.backToAuth();
                        },
                        child: const Text('Back to sign in'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return BabylogApp(
              assistant: snapshot.data!,
              saveAssistant: saveAssistant,
              joinAssistant: joinAssistant,
              backToAuth: widget.backToAuth);
        }
      },
    );
  }
}
