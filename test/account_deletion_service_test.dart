import 'package:babylog/services/account_deletion_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('deletes assistant data, user document, and auth user in order',
      () async {
    final log = <String>[];
    final service = AccountDeletionService(
      repository: _FakeAccountDeletionRepository(
        log: log,
        assistantUsers: const ['parent@example.com'],
      ),
      auth: _FakeAccountDeletionAuth(log: log),
      localData: _FakeAccountDeletionLocalData(log: log),
    );

    await service.deleteAccount(
      uid: 'uid-1',
      email: 'parent@example.com',
      assistantId: 'assistant-1',
      assistantUsers: const ['parent@example.com'],
    );

    expect(log, [
      'delete-events:assistant-1',
      'delete-user:uid-1',
      'delete-assistant:assistant-1',
      'delete-local:assistant-1',
      'delete-auth-user',
    ]);
  });

  test('removes deleting user from shared assistant instead of deleting it',
      () async {
    final log = <String>[];
    final repository = _FakeAccountDeletionRepository(
      log: log,
      assistantUsers: const ['parent@example.com', 'partner@example.com'],
    );
    final service = AccountDeletionService(
      repository: repository,
      auth: _FakeAccountDeletionAuth(log: log),
      localData: _FakeAccountDeletionLocalData(log: log),
    );

    await service.deleteAccount(
      uid: 'uid-1',
      email: 'parent@example.com',
      assistantId: 'assistant-1',
      assistantUsers: const ['parent@example.com', 'partner@example.com'],
    );

    expect(repository.updatedUsers, ['partner@example.com']);
    expect(log, [
      'delete-events:assistant-1',
      'delete-user:uid-1',
      'update-assistant-users:assistant-1',
      'delete-local:assistant-1',
      'delete-auth-user',
    ]);
  });
}

class _FakeAccountDeletionRepository implements AccountDeletionRepository {
  _FakeAccountDeletionRepository({
    required this.log,
    required this.assistantUsers,
  });

  final List<String> log;
  final List<String> assistantUsers;
  List<String>? updatedUsers;

  @override
  Future<void> deleteAssistant(String assistantId) async {
    log.add('delete-assistant:$assistantId');
  }

  @override
  Future<void> deleteAssistantEvents(String assistantId) async {
    log.add('delete-events:$assistantId');
  }

  @override
  Future<void> deleteUserDocument(String uid) async {
    log.add('delete-user:$uid');
  }

  @override
  Future<void> updateAssistantUsers(
    String assistantId,
    List<String> users,
  ) async {
    updatedUsers = users;
    log.add('update-assistant-users:$assistantId');
  }
}

class _FakeAccountDeletionAuth implements AccountDeletionAuth {
  _FakeAccountDeletionAuth({required this.log});

  final List<String> log;

  @override
  Future<void> deleteCurrentUser() async {
    log.add('delete-auth-user');
  }
}

class _FakeAccountDeletionLocalData implements AccountDeletionLocalData {
  _FakeAccountDeletionLocalData({required this.log});

  final List<String> log;

  @override
  Future<void> deleteAssistantLocalData(String assistantId) async {
    log.add('delete-local:$assistantId');
  }
}
