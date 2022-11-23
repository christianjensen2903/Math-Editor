import 'package:flutter/material.dart';
import 'package:frontend/repository/auth_repository.dart';
import 'package:frontend/repository/repository.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NotebookViewModel extends ChangeNotifier {
  final QuillController _controller = QuillController.basic();

  QuillController get controller => _controller;
}
