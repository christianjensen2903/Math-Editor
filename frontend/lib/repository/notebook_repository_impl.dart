import 'package:flutter_quill/flutter_quill.dart';
import 'package:frontend/model/notebook.dart';
import 'package:frontend/repository/ref.dart';
import 'package:frontend/repository/repository.dart';

class NotebookRepositoryImpl implements NotebookRepository {
  @override
  Future<Notebook> createNotebook(String uid) async {
    final notebookId = Ref().databaseNotebooksForUser(uid).push().key;
    if (notebookId == null) {
      throw Exception('Notebook ID is null');
    }
    final notebook = Notebook(
      id: notebookId,
      title: 'Untitled',
      content: Delta(),
    );

    await Ref().databaseSpecificNotebook(uid, notebookId).set(notebook.toMap());

    print('Notebook created: $notebookId');

    return notebook;
  }

  @override
  Future<void> deleteNotebook(String uid, String notebookId) {
    return Ref().databaseSpecificNotebook(uid, notebookId).remove();
  }

  @override
  Stream<List<Notebook>> getNotebooks(String uid) {
    return Ref().databaseNotebooksForUser(uid).onValue.map((event) {
      final notebooks = <Notebook>[];
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        final notebookMaps = Map<String, dynamic>.from(snapshot.value as Map);
        notebookMaps.forEach((key, value) {
          final notebook = Notebook.fromJson(value, key);
          if (notebook != null) {
            notebooks.add(notebook);
          }
        });
      }
      return notebooks;
    });
  }

  @override
  Future<void> updateNotebook(String uid, Notebook notebook) {
    return Ref()
        .databaseSpecificNotebook(uid, notebook.id)
        .update(notebook.toMap());
  }
}
