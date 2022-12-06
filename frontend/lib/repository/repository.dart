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

  Future<void> updateNotebookDelta(String notebookId, DeltaData deltaData);

  Future<Stream<DeltaData>> subscribeToNotebook(String notebookId);

  Future<List<Notebook>> getNotebooksForUser(String uid);
}

class Repository {
  final AuthRepository _authRepository = FirebaseAuthRepo();
  final NotebookRepository _notebookRepository = NotebookRepositoryImpl();

  AuthRepository get auth => _authRepository;

  NotebookRepository get notebook => _notebookRepository;
}
