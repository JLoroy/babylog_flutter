import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Assistant's Name",
              ),
            ),
            ElevatedButton(
              onPressed: () => saveAssistantName(context),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void saveAssistantName(context) {
    // Replace 'assistantId' with the actual assistant's document ID
    FirebaseFirestore.instance.collection('assistants').doc('assistantId').update({
      'name': _controller.text,
    });
    Navigator.pop(context);
  }
}
