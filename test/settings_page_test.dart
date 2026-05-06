import 'package:babylog/datamodel/babylogassistant.dart';
import 'package:babylog/pages/settingspage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('settings exposes privacy policy access', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsPage(
          currentAssistant: BabylogAssistant(
            assistantId: 'assistant-1',
            name: 'Baby',
            language: 'French',
            byok: true,
            apikey: 'sk-local-secret',
            usage: 100,
            users: const ['parent@example.com'],
            promptsettings: const {'baby_name': 'Baby'},
          ),
          saveAssistant: (_) {},
          joinAssistant: (_) {},
          deleteAccount: (_) async {},
        ),
      ),
    );

    expect(find.text('Privacy Policy'), findsOneWidget);
  });
}
