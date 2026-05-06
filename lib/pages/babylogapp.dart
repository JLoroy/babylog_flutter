import 'package:babylog/components/recorder.dart';
import 'package:babylog/components/event_timeline.dart';
import 'package:babylog/datamodel/babylogassistant.dart';
import 'package:babylog/pages/settingspage.dart';
import 'package:babylog/services/account_deletion_service.dart';
import 'package:babylog/theme/babylog_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import '../scripts/audio_transcription.dart';

class BabylogApp extends StatefulWidget {
  //const BabylogApp({Key? key}) : super(key: key);
  const BabylogApp({
    super.key,
    required this.assistant,
    required this.saveAssistant,
    required this.joinAssistant,
    required this.backToAuth,
  });
  final Function() backToAuth;
  final BabylogAssistant assistant;
  final Function saveAssistant;
  final Function joinAssistant;

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

  BabylogAssistant currentAssistant = anonAssistant();

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    print("INITIALIZATION");
    super.initState();
    showPlayer = false;
    currentAssistant = widget.assistant;
  }

  void _changeText(String t) {
    setState(() {
      _descriptionText = t;
    });
  }

  void onSaveAssistant(BabylogAssistant newAssistant) {
    widget.saveAssistant(newAssistant);
    setState(() {
      currentAssistant = newAssistant;
    });
  }

  void onJoinAssistant(String newAssistantId) {
    widget.joinAssistant(newAssistantId);
  }

  void resetRecord() {
    setState(() {
      showPlayer = false;
    });
  }

  void signOutFromBabylog(BuildContext context) {
    FirebaseUIAuth.signOut(context: context, auth: auth);
    widget.backToAuth();
    //bye
  }

  Future<void> deleteAccount(BuildContext context) async {
    final user = auth.currentUser;
    final assistantId = currentAssistant.assistantId;
    final email = user?.email;

    if (user == null || email == null || assistantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete this account.')),
      );
      return;
    }

    try {
      await AccountDeletionService.firebase().deleteAccount(
        uid: user.uid,
        email: email,
        assistantId: assistantId,
        assistantUsers: currentAssistant.users ?? const [],
      );
      widget.backToAuth();
    } on FirebaseAuthException catch (error) {
      if (!context.mounted) {
        return;
      }
      final message = error.code == 'requires-recent-login'
          ? 'Please sign in again before deleting your account.'
          : 'Could not delete this account.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete this account.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canRecord =
        currentAssistant.byok == true || (currentAssistant.usage ?? 0) > 0;

    return MaterialApp(
      theme: BabylogTheme.light(),
      debugShowCheckedModeBanner: false,
      title: 'Babylog',
      home: Scaffold(
        body: Stack(
          children: [
            const _WarmBackdrop(),
            Positioned.fill(
              top: 116,
              bottom: canRecord ? 154 : 20,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: Timeline(
                  key: ValueKey(currentAssistant.assistantId),
                  assistant: currentAssistant,
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: _HomeHeader(
                assistant: currentAssistant,
                onSettings: () => _openSettings(context),
                onSignOut: () => signOutFromBabylog(context),
              ),
            ),
            if (canRecord)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _RecorderDock(
                  descriptionText: _descriptionText,
                  isProcessing: showPlayer,
                  onStop: (path) {
                    if (kDebugMode) {
                      print('Recorded file path: $path');
                    }
                    transcribeAudio(
                      currentAssistant,
                      path,
                      _changeText,
                      resetRecord,
                    );
                    setState(() {
                      audioPath = path;
                      showPlayer = true;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) => SettingsPage(
        currentAssistant: currentAssistant,
        saveAssistant: onSaveAssistant,
        joinAssistant: onJoinAssistant,
        deleteAccount: deleteAccount,
      ),
    );
  }
}

class _WarmBackdrop extends StatelessWidget {
  const _WarmBackdrop();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF1E8),
            BabylogTheme.background,
            Color(0xFFFFFCF8),
          ],
          stops: [0, 0.42, 1],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.assistant,
    required this.onSettings,
    required this.onSignOut,
  });

  final BabylogAssistant assistant;
  final VoidCallback onSettings;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = assistant.name?.trim().isNotEmpty == true
        ? assistant.name!.trim()
        : 'Baby';

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Container(
        height: 88,
        padding: const EdgeInsets.fromLTRB(18, 12, 8, 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.86),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.74)),
          boxShadow: [
            BoxShadow(
              color: BabylogTheme.primary.withValues(alpha: 0.10),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFE5DB),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: BabylogTheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: BabylogTheme.mint,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'Babylog Assistant',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: BabylogTheme.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<int>(
              icon: const Icon(Icons.more_horiz_rounded),
              tooltip: 'Menu',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.tune_rounded),
                      SizedBox(width: 12),
                      Text('Settings'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded),
                      SizedBox(width: 12),
                      Text('Sign Out'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 1) {
                  onSettings();
                } else if (value == 2) {
                  onSignOut();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RecorderDock extends StatelessWidget {
  const _RecorderDock({
    required this.descriptionText,
    required this.isProcessing,
    required this.onStop,
  });

  final String descriptionText;
  final bool isProcessing;
  final void Function(String path) onStop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = descriptionText.trim().isEmpty
        ? 'Ready when something happens.'
        : descriptionText.trim();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.fromLTRB(
        18,
        16,
        18,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD978),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: BabylogTheme.primaryDark.withValues(alpha: 0.16),
            blurRadius: 28,
            offset: const Offset(0, -12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              height: 86,
              padding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white),
              ),
              child: SingleChildScrollView(
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: descriptionText.trim().isEmpty
                        ? BabylogTheme.muted
                        : BabylogTheme.ink,
                    fontStyle: descriptionText.trim().isEmpty
                        ? FontStyle.italic
                        : FontStyle.normal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 72,
            height: 86,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutBack,
              child: isProcessing
                  ? const Center(
                      key: ValueKey('processing'),
                      child: SizedBox(
                        width: 54,
                        height: 54,
                        child: CircularProgressIndicator(
                          strokeWidth: 6,
                          color: BabylogTheme.primary,
                        ),
                      ),
                    )
                  : AudioRecorderWidget(
                      key: const ValueKey('recorder'),
                      onStop: onStop,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
