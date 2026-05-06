import 'package:babylog/datamodel/babylogassistant.dart';
import 'package:babylog/services/openai_api_key.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('assistant Firestore payload never includes an OpenAI API key', () {
    final assistant = BabylogAssistant(
      assistantId: 'assistant-1',
      name: 'Baby',
      language: 'fr',
      byok: true,
      apikey: 'sk-user-secret',
      usage: 100,
      users: const ['parent@example.com'],
      promptsettings: const {'baby_name': 'Baby'},
    );

    expect(assistant.toFirestore(), isNot(contains('apikey')));
    expect(assistant.toJson(), isNot(contains('apikey')));
  });

  test('OpenAI calls require a local BYOK key', () {
    final assistant = BabylogAssistant(
      assistantId: 'assistant-1',
      name: 'Baby',
      language: 'fr',
      byok: false,
      apikey: '',
      usage: 100,
      users: const ['parent@example.com'],
      promptsettings: const {'baby_name': 'Baby'},
    );

    expect(
      () => openAiApiKeyForAssistant(assistant),
      throwsA(isA<MissingOpenAiApiKeyException>()),
    );
  });

  test('OpenAI calls use trimmed local BYOK key', () {
    final assistant = BabylogAssistant(
      assistantId: 'assistant-1',
      name: 'Baby',
      language: 'fr',
      byok: true,
      apikey: '  sk-local-secret  ',
      usage: 100,
      users: const ['parent@example.com'],
      promptsettings: const {'baby_name': 'Baby'},
    );

    expect(openAiApiKeyForAssistant(assistant), 'sk-local-secret');
  });

  test('local key store saves trimmed keys by assistant id', () async {
    final storage = _FakeOpenAiApiKeyStorage();
    final store = OpenAiApiKeyStore(storage: storage);

    await store.saveApiKey('assistant-1', '  sk-local-secret  ');

    expect(await store.readApiKey('assistant-1'), 'sk-local-secret');
    expect(storage.values.keys.single, 'openai_api_key:assistant-1');
  });

  test('local key store deletes blank keys', () async {
    final storage = _FakeOpenAiApiKeyStorage();
    final store = OpenAiApiKeyStore(storage: storage);

    await store.saveApiKey('assistant-1', 'sk-local-secret');
    await store.saveApiKey('assistant-1', '   ');

    expect(await store.readApiKey('assistant-1'), isNull);
  });
}

class _FakeOpenAiApiKeyStorage implements OpenAiApiKeyStorage {
  final values = <String, String>{};

  @override
  Future<void> delete({required String key}) async {
    values.remove(key);
  }

  @override
  Future<String?> read({required String key}) async {
    return values[key];
  }

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }
}
