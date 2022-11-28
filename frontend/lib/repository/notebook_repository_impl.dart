import 'package:flutter_quill/flutter_quill.dart';
import 'package:frontend/model/delta_data.dart';
import 'package:frontend/model/notebook.dart';
import 'package:frontend/repository/ref.dart';
import 'package:frontend/repository/repository.dart';

class NotebookRepositoryImpl implements NotebookRepository {
  @override
  Future<Notebook> createNotebook() async {
    final notebookId = Ref().databaseNotebooks.push().key;
    if (notebookId == null) {
      throw Exception('Notebook ID is null');
    }
    final notebook = Notebook(
      id: notebookId,
      title: 'Untitled',
      content: Delta(),
    );

    await Ref().databaseSpecificNotebook(notebookId).set(notebook.toMap());

    await Ref().databaseSpecificNotebookContent(notebookId).set({
      'content': null,
      'user': null,
      'deviceId': null,
    });

    return notebook;
  }

  @override
  Future<void> deleteNotebook(String notebookId) {
    return Ref().databaseSpecificNotebook(notebookId).remove();
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
  Stream<List<Notebook>> getNotebooks() {
    // TODO: implement getNotebooks
    throw UnimplementedError();
  }
}
