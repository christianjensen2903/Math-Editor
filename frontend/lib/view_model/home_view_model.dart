import 'package:flutter/material.dart';
import 'package:frontend/model/notebook.dart';
import 'package:frontend/repository/firebase_auth.dart';
import 'package:frontend/repository/repository.dart';
import 'package:flutter_quill/flutter_quill.dart';

class HomeViewModel extends ChangeNotifier {
  // Get all notebooks for the current user
  Future<List<Notebook>> getNotebooks() {
    final uid = Repository().auth.currentUserUid();
    if (uid == null) {
      throw Exception('Not logged in');
    }

    return Repository().notebook.getNotebooksForUser(uid);
  }

  // Create a new notebook
  Future<Notebook> createNotebook() {
    return Repository().notebook.createNotebook();
  }
}
