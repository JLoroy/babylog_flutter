import 'package:babylog/datamodel/babylogassistant.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.currentAssistant,
    required this.saveAssistant,
    required this.joinAssistant, 
    required this.deleteAccount, 
  });

  final BabylogAssistant currentAssistant;
  final Function(BabylogAssistant newAssistant) saveAssistant;
  final Function(String newAssistantId) joinAssistant; 
  final Function(BuildContext context) deleteAccount; 
  // This method should update your Firestore doc and reset the app as needed.

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _nameController = TextEditingController();
  final _apikeyController = TextEditingController();

  bool _byok = false;
  int _usage = 0;

  String? _selectedLanguage;

  // Users are displayed but cannot be added/removed
  final List<TextEditingController> _usersControllers = [];

  // Prompt settings: can edit value only, cannot add/remove pairs
  final List<Map<String, TextEditingController>> _promptControllers = [];

  // 10 most spoken languages (example list)
  final List<String> _availableLanguages = [
    'French',
  ];

  // For "Join another assistant" dialog
  final TextEditingController _joinAssistantController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Fill initial TextControllers from currentAssistant
    _nameController.text = widget.currentAssistant.name ?? '';
    _apikeyController.text = widget.currentAssistant.apikey ?? '';
    _byok = widget.currentAssistant.byok ?? false;
    _usage = widget.currentAssistant.usage ?? 0;

    _selectedLanguage = widget.currentAssistant.language;
    if (_selectedLanguage == null ||
        !_availableLanguages.contains(_selectedLanguage)) {
      _selectedLanguage = _availableLanguages.first;
    }

    // Build read-only controllers for each user
    if (widget.currentAssistant.users != null) {
      for (var user in widget.currentAssistant.users!) {
        final controller = TextEditingController(text: user);
        _usersControllers.add(controller);
      }
    }

    // Build controllers for each prompt setting
    if (widget.currentAssistant.promptsettings != null) {
      widget.currentAssistant.promptsettings!.forEach((key, value) {
        _promptControllers.add({
          'key': TextEditingController(text: key),     // read-only
          'value': TextEditingController(text: value), // editable
        });
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _apikeyController.dispose();
    _joinAssistantController.dispose();

    for (var c in _usersControllers) {
      c.dispose();
    }
    for (var map in _promptControllers) {
      map['key']?.dispose();
      map['value']?.dispose();
    }
    super.dispose();
  }

  /// Builds the updated BabylogAssistant object
  BabylogAssistant _buildUpdatedAssistant() {
    // Collect users (no add/remove, just read them)
    final updatedUsers = _usersControllers
        .map((controller) => controller.text.trim())
        .toList();

    // Collect prompt settings (only value can be updated)
    final Map<String, String> updatedPrompts = {};
    for (var map in _promptControllers) {
      final k = map['key']?.text.trim() ?? '';
      final v = map['value']?.text.trim() ?? '';
      if (k.isNotEmpty) {
        updatedPrompts[k] = v;
      }
    }

    return BabylogAssistant(
      assistantId: widget.currentAssistant.assistantId,
      name: _nameController.text,
      language: _selectedLanguage,
      byok: _byok,
      apikey: _apikeyController.text,
      usage: _usage,
      users: updatedUsers,
      promptsettings: updatedPrompts,
    );
  }

  /// Displays a modal dialog to join another assistant
  void _showJoinAnotherAssistantDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Join Another Assistant"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "WARNING: joining another assistant means you will lose "
                "your current timeline. Copy the assistant ID at the bottom "
                "if you don't want to lose your events.",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _joinAssistantController,
                decoration: const InputDecoration(
                  labelText: "New Assistant ID",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Cancel -> close the modal
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Join -> call the joinAssistant method, then close the modal
                final newAssistantId = _joinAssistantController.text.trim();
                if (newAssistantId.isNotEmpty) {
                  // You can do your Firestore update in the parent widget
                  // or handle it directly in this method. Typically you'd
                  // do something like:
                  //
                  // CollectionReference users = FirebaseFirestore.instance.collection('users');
                  // await users.doc(user.uid).update({'current_assistant': newAssistantId});
                  //
                  // Then you'd call setState or re-initialize the app state.
                  widget.joinAssistant(newAssistantId);
                }

                Navigator.of(context).pop();
              },
              child: const Text("Join"),
            ),
          ],
        );
      },
    );
  }


  // Open the coffee link
  Future<void> _openCoffeeLink() async {
    const coffeeUrl = 'https://justin.loroy.be';
    final uri = Uri.parse(coffeeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch $coffeeUrl")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Assistant Settings"),
          toolbarHeight: 80,
          actions: [
            // Top-right "Join another assistant" button
            TextButton(
              onPressed: _showJoinAnotherAssistantDialog,
              child: const Text(
                "Join another assistant",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Name
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Assistant's Name",
                  ),
                ),
                const SizedBox(height: 10),

                SwitchListTile(
                  title: const Text("Bring your own API key"),
                  value: _byok,
                  onChanged: (bool newValue) {
                    setState(() {
                      _byok = newValue;
                    });
                  },
                ),
                const SizedBox(height: 10),
                // If byok is on -> show the API key text field
                // If byok is off -> show usage progress bar
                if (_byok) ...[
                  TextField(
                    obscureText: true,
                    controller: _apikeyController,
                    decoration: const InputDecoration(
                      labelText: "OpenAI API Key",
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          // usage is from 0 to 100, so we convert usage/100.0
                          value: _usage.clamp(0, 100) / 100.0,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text("$_usage left"),
                    ],
                  ),
                ],

                const SizedBox(height: 20),

                // Language dropdown
                DropdownButtonFormField<String>(
                  value: _selectedLanguage,
                  decoration: const InputDecoration(
                    labelText: "Language",
                  ),
                  items: _availableLanguages.map((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Users (read-only)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Users",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  children: _usersControllers.map((controller) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        controller: controller,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "User",
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Prompt Settings (cannot add/remove, only update value)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Prompt Settings",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  children: _promptControllers.map((map) {
                    final keyController = map['key']!;
                    final valueController = map['value']!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          // Key is read-only
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: keyController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: "Key (read-only)",
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Value is editable
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: valueController,
                              decoration: const InputDecoration(
                                labelText: "Value",
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Back and Save Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Back"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.saveAssistant(_buildUpdatedAssistant());
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.currentAssistant.assistantId != null 
                        ? 'Assistant ID: ${widget.currentAssistant.assistantId}' 
                        : 'No ID',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              const SizedBox(height: 30),

              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Use your own color if needed
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text("Delete all data?"),
                        content: const Text(
                          "Are you sure you want to permanently delete your account? All other users of your assistant will lose all events.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              widget.deleteAccount(context);
                            },
                            child: const Text("Delete Everything"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text("Delete Account"),
              ),

                const SizedBox(height: 30),

                // NEW: Pay the developer a coffee button
                ElevatedButton(
                  onPressed: _openCoffeeLink,
                  child: const Text("Pay the developer a coffee"),
                ),

                const SizedBox(height: 30),

                // assistantId in italic grey at the bottom
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.currentAssistant.assistantId ?? 'No ID',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
