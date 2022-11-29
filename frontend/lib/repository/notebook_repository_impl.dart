import 'package:flutter_quill/flutter_quill.dart';
import 'package:frontend/model/delta_data.dart';
import 'package:frontend/model/notebook.dart';
import 'package:frontend/repository/ref.dart';
import 'package:frontend/repository/repository.dart';

class NotebookRepositoryImpl implements NotebookRepository {
  @override
  Future<Notebook> createNotebook() async {
    // Check if logged in
    if (!Repository().auth.haveActiveSession()) {
      throw Exception('Not logged in');
    }

    final notebookId = Ref().databaseNotebooks.push().key;
    if (notebookId == null) {
      throw Exception('Notebook ID is null');
    }
    final notebook = Notebook(
      id: notebookId,
    );

    await Ref().databaseSpecificNotebook(notebookId).set(notebook.toMap());

    await Ref().databaseSpecificNotebookContent(notebookId).set({
      'content': null,
      'user': null,
      'deviceId': null,
    });

    await Ref()
        .databaseNotebookOverviewForUser(Repository().auth.currentUserUid()!)
        .child(notebookId)
        .set({'notebookId': notebookId});

    return notebook;
  }

  @override
  Future<void> deleteNotebook(String notebookId) async {
    await Ref().databaseSpecificNotebook(notebookId).remove();
    await Ref().databaseSpecificNotebookContent(notebookId).remove();
    // Delete notebook from user's notebook overview ?
  }

  @override
  Future<void> updateNotebook(Notebook notebook) {
    return Ref().databaseSpecificNotebook(notebook.id).update(notebook.toMap());
  }

  @override
  Future<void> updateNotebookContent(String notebookId, DeltaData deltaData) {
    return Ref()
        .databaseSpecificNotebookContent(notebookId)
        .update(deltaData.toMap());
  }

  @override
  Future<List<Notebook>> getNotebooksForUser(uid) async {
    // First get notebook ids from overview then notebooks
    final notebookIds =
        await Ref().databaseNotebookOverviewForUser(uid).onValue.map((event) {
      final notebookIds = <String>[];
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        final map = snapshot.value as Map<dynamic, dynamic>;
        map.forEach((key, value) {
          notebookIds.add(key);
        });
      }
      return notebookIds;
    }).first;

    // Get notebooks from notebook ids
    final notebooks = <Notebook>[];
    for (final notebookId in notebookIds) {
      final notebook =
          await Ref().databaseSpecificNotebook(notebookId).onValue.map((event) {
        final snapshot = event.snapshot;
        if (snapshot.value != null) {
          return Notebook.fromMap(
              snapshot.value as Map<String, dynamic>, notebookId);
        } else {
          return null;
        }
      }).first;
      if (notebook != null) {
        notebooks.add(notebook);
      }
    }

    return notebooks;
  }
}
