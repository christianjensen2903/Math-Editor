import 'package:flutter/material.dart';
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

    final current_user_id = Repository().auth.currentUserUid()!;

    // Create notebook
    final notebookId = Ref().databaseNotebooks.push().key;
    if (notebookId == null) {
      throw Exception('Notebook ID is null');
    }

    // Set initial notebook data
    final notebook = Notebook(
      id: notebookId,
    );
    await Ref().databaseSpecificNotebook(notebookId).set(notebook.toMap());

    // Add notebook to user's list of notebooks
    await Ref()
        .databaseNotebookOverviewForUser(current_user_id)
        .child(notebookId)
        .set({'notebookId': notebookId});

    return notebook;
  }

  @override
  Future<void> deleteNotebook(String notebookId) async {
    await Ref().databaseSpecificNotebook(notebookId).remove();

    await Ref()
        .databaseNotebookOverviewForUser(Repository().auth.currentUserUid()!)
        .child(notebookId)
        .remove();

    // TODO: Delete notebook from other user's notebook overview ?
  }

  @override
  Future<void> updateNotebook(Notebook notebook) {
    return Ref().databaseSpecificNotebook(notebook.id).update(notebook.toMap());
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

  // Subscribe to notebook content
  @override
  Future<Stream<DeltaData>> subscribeToNotebook(String notebookId) async {
    final initialSnapshot =
        await Ref().databaseNotebookDeltaForNotebook(notebookId).get();

    late final DeltaData initialDeltaData;
    if (initialSnapshot.value != null) {
      initialDeltaData =
          DeltaData.fromMap(initialSnapshot.value as Map<String, dynamic>);
    } else {
      initialDeltaData = const DeltaData(user: '', delta: [], deviceId: '');
    }

    return Ref()
        .databaseNotebookDeltaForNotebook(notebookId)
        .onValue
        .map((event) {
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        final newDeltaData =
            DeltaData.fromMap(snapshot.value as Map<String, dynamic>);

        if (newDeltaData != initialDeltaData) {
          return newDeltaData;
        } else {
          return const DeltaData(user: '', delta: [], deviceId: '');
        }
      } else {
        return const DeltaData(user: '', delta: [], deviceId: '');
      }
    });
  }

  @override
  Future<void> updateNotebookDelta(String notebookId, DeltaData deltaData) {
    return Ref()
        .databaseNotebookDeltaForNotebook(notebookId)
        .update(deltaData.toMap());
  }
}
