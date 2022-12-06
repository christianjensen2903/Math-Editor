import 'dart:async';
import 'dart:convert';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:frontend/model/delta_data.dart';
import 'package:frontend/model/notebook.dart';
import 'package:frontend/repository/firebase_auth.dart';
import 'package:frontend/repository/repository.dart';

class NotebookViewModel extends ChangeNotifier {
  bool _isSavedRemotely = false;

  Notebook? _notebook;

  EditorState? _editorState;

  EditorState? get editorState => _editorState;

  Timer? _debounce;

  final _deviceId = UniqueKey().toString();

  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  Future<void> loadNotebook(Future<Notebook> notebook) async {
    try {
      _notebook = await notebook;

      if (_notebook!.content.isEmpty) {
        _editorState = EditorState.empty();
      } else {
        _editorState = EditorState(
            document: Document.fromJson(jsonDecode(_notebook!.content)));
      }

      _listenForChanges();

      _isLoaded = true;
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future<void> _listenForChanges() async {
    if (_notebook == null) {
      throw Exception('Notebook is not loaded');
    }

    final realtimeListener =
        await Repository().notebook.subscribeToNotebook(_notebook!.id);

    realtimeListener.listen((data) {
      if (data.deviceId != _deviceId) {
        final delta = Delta.fromJson(data.delta);
        // blockController.compose(
        //     delta, blockController.selection, ChangeSource.REMOTE);
      }
    });

    // Listen for local changes and broadcast them
    // blockController.document.changes.listen((event) {
    //   final delta = event.item2;
    //   final source = event.item3;

    //   if (source != ChangeSource.LOCAL) {
    //     return;
    //   }
    //   _broadcastDeltaUpdate(delta, blockId);
    // });

    // Save the notebook regularly
    // blockController.addListener(() {
    //     _isSavedRemotely = false;
    //     _debouceSaveBlock(block: block);
    //   });
  }

  Future<void> _broadcastDeltaUpdate(Delta delta, String blockId) async {
    final currentUserUid = FirebaseAuthRepo().currentUserUid();
    if (_notebook == null || currentUserUid == null) {
      return;
    }

    Repository()
        .notebook
        .updateNotebookDelta(
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

  void _debouceSave({Duration duration = const Duration(seconds: 2)}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(duration, () {
      saveImmediately();
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

  Future<void> saveImmediately() async {
    if (_notebook == null) {
      return;
    }
    await Repository().notebook.updateNotebook(_notebook!);
    _isSavedRemotely = true;
  }
}
