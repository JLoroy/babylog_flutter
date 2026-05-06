import 'package:babylog/datamodel/babylogassistant.dart';
import 'package:babylog/theme/babylog_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final Future<void> Function(BuildContext context) deleteAccount;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _nameController = TextEditingController();
  final _apikeyController = TextEditingController();
  final TextEditingController _joinAssistantController =
      TextEditingController();

  bool _byok = false;
  int _usage = 0;
  String? _selectedLanguage;

  final List<TextEditingController> _usersControllers = [];
  final List<Map<String, TextEditingController>> _promptControllers = [];

  final List<String> _availableLanguages = [
    'French',
  ];

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.currentAssistant.name ?? '';
    _apikeyController.text = widget.currentAssistant.apikey ?? '';
    _byok = widget.currentAssistant.byok ?? false;
    _usage = widget.currentAssistant.usage ?? 0;

    _selectedLanguage = widget.currentAssistant.language;
    if (_selectedLanguage == null ||
        !_availableLanguages.contains(_selectedLanguage)) {
      _selectedLanguage = _availableLanguages.first;
    }

    if (widget.currentAssistant.users != null) {
      for (var user in widget.currentAssistant.users!) {
        _usersControllers.add(TextEditingController(text: user));
      }
    }

    if (widget.currentAssistant.promptsettings != null) {
      widget.currentAssistant.promptsettings!.forEach((key, value) {
        _promptControllers.add({
          'key': TextEditingController(text: key),
          'value': TextEditingController(text: value),
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

  BabylogAssistant _buildUpdatedAssistant() {
    final updatedUsers =
        _usersControllers.map((controller) => controller.text.trim()).toList();

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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final newAssistantId = _joinAssistantController.text.trim();
                if (newAssistantId.isNotEmpty) {
                  widget.joinAssistant(newAssistantId);
                }
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.login_rounded),
              label: const Text("Join"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openCoffeeLink() async {
    const coffeeUrl = 'https://justin.loroy.be';
    final uri = Uri.parse(coffeeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch $coffeeUrl")),
      );
    }
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Privacy Policy"),
          content: const SingleChildScrollView(
            child: Text(
              "Babylog uses Firebase Authentication to create and manage your account, and Cloud Firestore to store your shared baby timeline events.\n\n"
              "If you record audio, Babylog sends the recording to OpenAI for transcription and uses OpenAI to turn the transcription into timeline events. Your OpenAI API key is stored only on this device when bring-your-own-key is enabled.\n\n"
              "Babylog does not sell your data and does not intentionally include ads or analytics tracking. You can delete your account from Settings. Account deletion removes your Firebase account, your Babylog user profile, your current assistant timeline events, and your assistant membership where applicable.\n\n"
              "A public privacy policy and account deletion request page must be published before the Play Store release.",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
          child: Scaffold(
            backgroundColor: BabylogTheme.background,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  backgroundColor: BabylogTheme.background,
                  surfaceTintColor: Colors.transparent,
                  toolbarHeight: 92,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8CBC2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      Text(
                        "Assistant Settings",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton.icon(
                      onPressed: _showPrivacyPolicy,
                      icon: const Icon(Icons.privacy_tip_outlined),
                      label: const Text("Privacy Policy"),
                    ),
                    Tooltip(
                      message: "Join another assistant",
                      child: IconButton.filledTonal(
                        onPressed: _showJoinAnotherAssistantDialog,
                        icon: const Icon(Icons.group_add_rounded),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
                  sliver: SliverList.list(
                    children: [
                      _SectionCard(
                        title: "Assistant",
                        icon: Icons.auto_awesome_rounded,
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: "Assistant's Name",
                            ),
                          ),
                          const SizedBox(height: 14),
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
                        ],
                      ),
                      _SectionCard(
                        title: "OpenAI",
                        icon: Icons.key_rounded,
                        children: [
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text("Bring your own API key"),
                            value: _byok,
                            onChanged: (bool newValue) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _byok = newValue;
                              });
                            },
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: _byok
                                ? TextField(
                                    key: const ValueKey('api-key'),
                                    obscureText: true,
                                    controller: _apikeyController,
                                    decoration: const InputDecoration(
                                      labelText: "OpenAI API Key",
                                    ),
                                  )
                                : Row(
                                    key: const ValueKey('usage'),
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(999),
                                          child: LinearProgressIndicator(
                                            minHeight: 10,
                                            value: _usage.clamp(0, 100) / 100.0,
                                            backgroundColor:
                                                const Color(0xFFE8DDD5),
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(
                                              BabylogTheme.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        "$_usage left",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w900,
                                            ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                      _SectionCard(
                        title: "Users",
                        icon: Icons.people_alt_rounded,
                        children: _usersControllers.isEmpty
                            ? [
                                Text(
                                  "No users",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ]
                            : _usersControllers.map((controller) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: TextField(
                                    controller: controller,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      labelText: "User",
                                      prefixIcon:
                                          Icon(Icons.person_outline_rounded),
                                    ),
                                  ),
                                );
                              }).toList(),
                      ),
                      _SectionCard(
                        title: "Prompt Settings",
                        icon: Icons.tune_rounded,
                        children: _promptControllers.isEmpty
                            ? [
                                Text(
                                  "No prompt settings",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ]
                            : _promptControllers.map((map) {
                                final keyController = map['key']!;
                                final valueController = map['value']!;
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final compact =
                                          constraints.maxWidth < 520;
                                      final keyField = TextField(
                                        controller: keyController,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          labelText: "Key (read-only)",
                                        ),
                                      );
                                      final valueField = TextField(
                                        controller: valueController,
                                        decoration: const InputDecoration(
                                          labelText: "Value",
                                        ),
                                      );

                                      if (compact) {
                                        return Column(
                                          children: [
                                            keyField,
                                            const SizedBox(height: 10),
                                            valueField,
                                          ],
                                        );
                                      }

                                      return Row(
                                        children: [
                                          Expanded(child: keyField),
                                          const SizedBox(width: 10),
                                          Expanded(flex: 2, child: valueField),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                      ),
                      _SectionCard(
                        title: "Actions",
                        icon: Icons.shield_outlined,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  label: const Text("Back"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    Navigator.of(context).pop();
                                    widget.saveAssistant(
                                      _buildUpdatedAssistant(),
                                    );
                                  },
                                  icon: const Icon(Icons.check_rounded),
                                  label: const Text("Save"),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Center(
                            child: SelectableText(
                              widget.currentAssistant.assistantId != null
                                  ? 'Assistant ID: ${widget.currentAssistant.assistantId}'
                                  : 'No ID',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                              onPressed: _confirmDeleteAccount,
                              icon: const Icon(Icons.delete_forever_rounded),
                              label: const Text("Delete Account"),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _openCoffeeLink,
                              icon: const Icon(Icons.local_cafe_rounded),
                              label: const Text("Pay the developer a coffee"),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: TextButton.icon(
                              onPressed: _showPrivacyPolicy,
                              icon: const Icon(Icons.privacy_tip_outlined),
                              label: const Text("Privacy Policy"),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Center(
                            child: SelectableText(
                              widget.currentAssistant.assistantId ?? 'No ID',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDeleteAccount() {
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
              ),
              onPressed: () async {
                Navigator.of(ctx).pop();
                await widget.deleteAccount(context);
              },
              child: const Text("Delete Everything"),
            ),
          ],
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFECE5)),
        boxShadow: [
          BoxShadow(
            color: BabylogTheme.primaryDark.withValues(alpha: 0.06),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFE8DF),
                ),
                child: Icon(icon, color: BabylogTheme.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}
