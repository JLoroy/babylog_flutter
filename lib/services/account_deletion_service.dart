import 'package:babylog/services/openai_api_key.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountDeletionService {
  AccountDeletionService({
    required this.repository,
    required this.auth,
    AccountDeletionLocalData? localData,
  }) : localData = localData ?? NoopAccountDeletionLocalData();

  factory AccountDeletionService.firebase({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  }) {
    return AccountDeletionService(
      repository: FirestoreAccountDeletionRepository(
        firestore ?? FirebaseFirestore.instance,
      ),
      auth: FirebaseAccountDeletionAuth(firebaseAuth ?? FirebaseAuth.instance),
      localData: OpenAiAccountDeletionLocalData(),
    );
  }

  final AccountDeletionRepository repository;
  final AccountDeletionAuth auth;
  final AccountDeletionLocalData localData;

  Future<void> deleteAccount({
    required String uid,
    required String email,
    required String assistantId,
    required List<String> assistantUsers,
  }) async {
    await repository.deleteAssistantEvents(assistantId);
    await repository.deleteUserDocument(uid);

    final remainingUsers =
        assistantUsers.where((user) => user != email).toList();
    if (remainingUsers.isEmpty) {
      await repository.deleteAssistant(assistantId);
    } else {
      await repository.updateAssistantUsers(assistantId, remainingUsers);
    }

    await localData.deleteAssistantLocalData(assistantId);
    await auth.deleteCurrentUser();
  }
}

abstract class AccountDeletionRepository {
  Future<void> deleteAssistantEvents(String assistantId);

  Future<void> deleteUserDocument(String uid);

  Future<void> updateAssistantUsers(String assistantId, List<String> users);

  Future<void> deleteAssistant(String assistantId);
}

abstract class AccountDeletionAuth {
  Future<void> deleteCurrentUser();
}

abstract class AccountDeletionLocalData {
  Future<void> deleteAssistantLocalData(String assistantId);
}

class NoopAccountDeletionLocalData implements AccountDeletionLocalData {
  @override
  Future<void> deleteAssistantLocalData(String assistantId) async {}
}

class OpenAiAccountDeletionLocalData implements AccountDeletionLocalData {
  OpenAiAccountDeletionLocalData({OpenAiApiKeyStore? apiKeyStore})
      : apiKeyStore = apiKeyStore ?? OpenAiApiKeyStore();

  final OpenAiApiKeyStore apiKeyStore;

  @override
  Future<void> deleteAssistantLocalData(String assistantId) {
    return apiKeyStore.saveApiKey(assistantId, '');
  }
}

class FirestoreAccountDeletionRepository implements AccountDeletionRepository {
  FirestoreAccountDeletionRepository(this.firestore);

  final FirebaseFirestore firestore;

  @override
  Future<void> deleteAssistantEvents(String assistantId) async {
    final snapshot = await firestore
        .collection('events')
        .where('assistant', isEqualTo: assistantId)
        .get();

    var batch = firestore.batch();
    var pendingWrites = 0;

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
      pendingWrites++;

      if (pendingWrites == 450) {
        await batch.commit();
        batch = firestore.batch();
        pendingWrites = 0;
      }
    }

    if (pendingWrites > 0) {
      await batch.commit();
    }
  }

  @override
  Future<void> deleteUserDocument(String uid) {
    return firestore.collection('users').doc(uid).delete();
  }

  @override
  Future<void> updateAssistantUsers(String assistantId, List<String> users) {
    return firestore
        .collection('assistants')
        .doc(assistantId)
        .update({'users': users});
  }

  @override
  Future<void> deleteAssistant(String assistantId) {
    return firestore.collection('assistants').doc(assistantId).delete();
  }
}

class FirebaseAccountDeletionAuth implements AccountDeletionAuth {
  FirebaseAccountDeletionAuth(this.auth);

  final FirebaseAuth auth;

  @override
  Future<void> deleteCurrentUser() {
    final user = auth.currentUser;
    if (user == null) {
      throw StateError('Cannot delete an account when no user is signed in.');
    }
    return user.delete();
  }
}
