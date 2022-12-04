import 'package:frontend/model/block.dart';
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

  Future<Block> getBlock(String blockId);

  Future<Block> createBlock(String notebookId, BlockType type, int index);

  Future<void> updateBlock(Block block);

  Future<void> deleteBlock(String notebookId, String blockId);

  Future<List<Notebook>> getNotebooksForUser(String uid);

  Stream<DeltaData> subscribeToBlockDelta(String blockId);

  Future<void> updateBlockContent(String blockId, DeltaData deltaData);
}

class Repository {
  final AuthRepository _authRepository = FirebaseAuthRepo();
  final NotebookRepository _notebookRepository = NotebookRepositoryImpl();

  AuthRepository get auth => _authRepository;

  NotebookRepository get notebook => _notebookRepository;
}
