import 'package:frontend/model/delta_data.dart';
import 'package:frontend/repository/firebase_auth.dart';
import 'package:frontend/model/notebook.dart';
import 'package:frontend/repository/notebook_repository_impl.dart';

abstract class AuthRepository {
  Future<void> register(String email, String password);

  Future<void> login(String email, String password);

  Future<void> logout();

  String? currentUserUid();

  bool haveActiveSession();
}

abstract class NotebookRepository {
  Future<Notebook> createNotebook();

  Future<void> updateNotebook(Notebook notebook);

  Future<void> deleteNotebook(String notebookId);

  Future<List<Notebook>> getNotebooksForUser(String uid);

  // TODO: Implementing retrieving and updating notebook content remotely
  // https://github.com/funwithflutter/google-docs-clone-flutter/blob/master/lib/components/document/state/document_controller.dart
  Future<void> updateNotebookContent(String notebookId, DeltaData deltaData);
}

class Repository {
  final AuthRepository _authRepository = FirebaseAuthRepo();
  final NotebookRepository _notebookRepository = NotebookRepositoryImpl();

  AuthRepository get auth => _authRepository;

  NotebookRepository get notebook => _notebookRepository;
}
