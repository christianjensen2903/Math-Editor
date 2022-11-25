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
  Future<Notebook> createNotebook(String uid);

  Future<void> updateNotebook(String uid, Notebook notebook);

  Future<void> deleteNotebook(String uid, String notebookId);

  Stream<List<Notebook>> getNotebooks(String uid);
}

class Repository {
  final AuthRepository _authRepository = FirebaseAuthRepo();
  final NotebookRepository _notebookRepository = NotebookRepositoryImpl();

  AuthRepository get auth => _authRepository;

  NotebookRepository get notebook => _notebookRepository;
}
