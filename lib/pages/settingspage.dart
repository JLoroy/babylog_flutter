import 'package:babylog/datamodel/babylogassistant.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.currentAssistant, required this.saveAssistant });

  final BabylogAssistant currentAssistant;
  final Function(BabylogAssistant newAssistant) saveAssistant;


  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _nameController = TextEditingController();
  final _apikeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentAssistant.name!;
    _apikeyController.text = widget.currentAssistant.apikey!;

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Assistant's Name",
              ),
            ),
            TextField(
              obscureText: true,
              controller: _apikeyController,
              decoration: InputDecoration(
                labelText: "OpenAI API key",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.saveAssistant(
                  BabylogAssistant(
                    assistantId: widget.currentAssistant.assistantId, 
                    name: _nameController.text, 
                    language: widget.currentAssistant.language, 
                    apikey: _apikeyController.text,
                    users: widget.currentAssistant.users,
                    promptsettings: widget.currentAssistant.promptsettings
                  )
                );
              },
              child: Text('Save'),
            ),
          ],
        ),
    );
  }
}