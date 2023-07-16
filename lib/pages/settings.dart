import 'package:babylog/datamodel/babylogassistant.dart';
import 'package:babylog/pages/babylogapp.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatelessWidget {
  final BabylogAssistant? assistant;

  SettingsPage({required this.assistant});

  final TextEditingController newAssistantName = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: newAssistantName,
              decoration: InputDecoration(
                labelText: "Assistant's Name",
              ),
            ),
            ElevatedButton(
              onPressed: () => saveSettings(context),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveSettings(context) async {
    // Get a reference to the assistant's document in Firestore.
    DocumentReference assistantRef = FirebaseFirestore.instance.collection('assistants').doc("pimnNYSNB599UmUNWYpG");

    // Update the name of the assistant in Firestore.
    await assistantRef.update({
      'name': newAssistantName.text,
    });

    // Then navigate back.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BabylogApp(assistant: assistant),
      ),
    );
  }

}
