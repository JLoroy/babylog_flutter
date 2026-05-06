import 'package:babylog/datamodel/babylogassistant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MissingOpenAiApiKeyException implements Exception {
  const MissingOpenAiApiKeyException();

  @override
  String toString() {
    return 'MissingOpenAiApiKeyException: add a local OpenAI API key in settings.';
  }
}

String openAiApiKeyForAssistant(BabylogAssistant assistant) {
  if (assistant.byok != true) {
    throw const MissingOpenAiApiKeyException();
  }

  final apiKey = assistant.apikey?.trim() ?? '';
  if (apiKey.isEmpty) {
    throw const MissingOpenAiApiKeyException();
  }

  return apiKey;
}

abstract class OpenAiApiKeyStorage {
  Future<String?> read({required String key});

  Future<void> write({required String key, required String value});

  Future<void> delete({required String key});
}

class SecureOpenAiApiKeyStorage implements OpenAiApiKeyStorage {
  SecureOpenAiApiKeyStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }

  @override
  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  @override
  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }
}

class OpenAiApiKeyStore {
  OpenAiApiKeyStore({OpenAiApiKeyStorage? storage})
      : storage = storage ?? SecureOpenAiApiKeyStorage();

  final OpenAiApiKeyStorage storage;

  String storageKey(String assistantId) {
    return 'openai_api_key:$assistantId';
  }

  Future<String?> readApiKey(String? assistantId) {
    if (assistantId == null || assistantId.isEmpty) {
      return Future.value(null);
    }
    return storage.read(key: storageKey(assistantId));
  }

  Future<void> saveApiKey(String? assistantId, String apiKey) {
    if (assistantId == null || assistantId.isEmpty) {
      return Future.value();
    }

    final trimmedApiKey = apiKey.trim();
    final key = storageKey(assistantId);
    if (trimmedApiKey.isEmpty) {
      return storage.delete(key: key);
    }

    return storage.write(key: key, value: trimmedApiKey);
  }
}
