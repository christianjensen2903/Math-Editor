import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/model/delta_data.dart';
import 'package:frontend/model/notebook.dart';
import 'package:frontend/repository/firebase_auth.dart';
import 'package:frontend/repository/repository.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NotebookViewModel extends ChangeNotifier {
  QuillController? _controller;

  Document? _document;

  bool _isSavedRemotely = false;

  Notebook? _notebook;

  get controller => _controller;

  Timer? _debounce;

  late final StreamSubscription<dynamic>? documentListener;
  late final StreamSubscription<dynamic>? realtimeListener;

  final _deviceId = UniqueKey().toString();

  bool isLoaded() {
    return _controller != null;
  }

  Future<void> loadNotebook(Future<Notebook> notebook) async {
    try {
      _notebook = await notebook;

      late final Document quillDoc;
      if (_notebook!.content.isEmpty) {
        quillDoc = Document()..insert(0, '');
      } else {
        quillDoc = Document.fromDelta(Delta.fromJson(_notebook!.content));
      }

      final quillController = QuillController(
        document: quillDoc,
        selection: TextSelection.collapsed(offset: 0),
      );

      _document = quillDoc;

      _controller = quillController;

      _listenForChanges();
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  void _listenForChanges() {
    _controller?.addListener(_quillControllerUpdate);

    _controller?.document.changes.listen((event) {
      final delta = event.item2;
      final source = event.item3;

      if (source != ChangeSource.LOCAL) {
        return;
      }
      _broadcastDeltaUpdate(delta);
    });

    // Listen for database changes
    realtimeListener = Repository()
        .notebook
        .subscribeToNotebookContent(_notebook!.id)
        .listen((data) {
      if (data.deviceId != _deviceId) {
        final delta = Delta.fromJson(data.delta);
        _controller?.compose(
            delta,
            _controller?.selection ?? const TextSelection.collapsed(offset: 0),
            ChangeSource.REMOTE);
      }
    });
  }

  Future<void> _broadcastDeltaUpdate(Delta delta) async {
    final currentUserUid = FirebaseAuthRepo().currentUserUid();
    if (_notebook == null || currentUserUid == null) {
      return;
    }

    Repository()
        .notebook
        .updateNotebookContent(
            _notebook!.id,
            DeltaData(
                user: currentUserUid,
                deviceId: _deviceId,
                delta: delta.toJson()))
        .then((value) {
      _isSavedRemotely = true;
      notifyListeners();
    }).catchError((error) {
      _isSavedRemotely = false;
      notifyListeners();
    });
  }

  void _quillControllerUpdate() {
    _isSavedRemotely = false;
    _debounceSave();
  }

  void _debounceSave({Duration duration = const Duration(seconds: 2)}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(duration, () {
      saveDocumentImmediately();
    });
  }

  void setTitle(String title) {
    // state = state.copyWith(
    //   documentPageData: state.documentPageData?.copyWith(
    //     title: title,
    //   ),
    //   isSavedRemotely: false,
    // );
    // _debounceSave(duration: const Duration(milliseconds: 500));
  }

  Future<void> saveDocumentImmediately() async {
    final currentUserUid = FirebaseAuthRepo().currentUserUid();
    if (currentUserUid == null || _notebook == null || _document == null) {
      return;
    }
    final notebook = Notebook(
      id: _notebook!.id,
      title: _notebook!.title,
      content: _document!.toDelta().toJson(),
    );
    await Repository().notebook.updateNotebook(notebook);
    _isSavedRemotely = true;
  }
}
