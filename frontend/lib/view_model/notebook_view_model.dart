import 'package:flutter/material.dart';
import 'package:frontend/repository/firebase_auth.dart';
import 'package:frontend/repository/repository.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NotebookViewModel extends ChangeNotifier {
  final QuillController _controller = QuillController.basic();

  QuillController get controller => _controller;

  // Listen for changes in the document and update the view
  void listenForChanges() {
    _controller.document.changes.listen((event) {
      // print(event.item1); //Delta
      // print(event.item2); //Delta
      // print(event.item3); //ChangeSource
      Delta delta = _controller.document.toDelta();
    });
  }
}
