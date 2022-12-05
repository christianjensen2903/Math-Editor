import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/model/block.dart';
import 'package:frontend/model/delta_data.dart';
import 'package:frontend/model/notebook.dart';
import 'package:frontend/repository/firebase_auth.dart';
import 'package:frontend/repository/repository.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Block;
import 'package:math_keyboard/math_keyboard.dart';

class NotebookViewModel extends ChangeNotifier {
  bool _isSavedRemotely = false;

  Notebook? _notebook;

  List<Block> _blocks = [];

  List<Block> get blocks => _blocks;

  MathFieldEditingController? _mathFieldController;

  // Controller for each block
  Map<String, QuillController> _blockControllers = {};

  Map<String, QuillController> get blockControllers => _blockControllers;

  Timer? _debounce;

  late final StreamSubscription<dynamic>? documentListener;
  late final StreamSubscription<dynamic>? realtimeListener;

  final _deviceId = UniqueKey().toString();

  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  Future<void> loadNotebook(Future<Notebook> notebook) async {
    try {
      _notebook = await notebook;
      await _loadBlocks();
      _isLoaded = true;
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future<void> _loadBlocks() async {
    final blockIds = _notebook!.blocks;

    // Retrieve blocks from repository
    _blocks = await Future.wait(blockIds.map((blockId) async {
      final block = await Repository().notebook.getBlock(blockId);
      return block;
    }).toList());

    // Create a controller for each block
    _blocks.forEach((block) {
      late final Document quillDoc;
      if (block.content.isEmpty) {
        quillDoc = Document()..insert(0, '');
      } else {
        quillDoc = Document.fromDelta(Delta.fromJson(block.content));
      }

      final blockController = QuillController(
        document: quillDoc,
        selection: const TextSelection.collapsed(offset: 0),
      );

      _blockControllers[block.id] = blockController;
    });

    // Listen for changes in blocks
    _listenForBlockChanges();
  }

  Future<void> _listenForBlockChanges() async {
    _blockControllers.forEach((blockId, blockController) async {
      // Listen for remote changes
      final realtimeListener =
          await Repository().notebook.subscribeToBlockDelta(blockId);

      realtimeListener.listen((data) {
        if (data.deviceId != _deviceId) {
          final delta = Delta.fromJson(data.delta);
          blockController.compose(
              delta, blockController.selection, ChangeSource.REMOTE);
        }
      });

      // Listen for local changes and broadcast them
      blockController.document.changes.listen((event) {
        final delta = event.item2;
        final source = event.item3;

        if (source != ChangeSource.LOCAL) {
          return;
        }
        _broadcastDeltaUpdate(delta, blockId);
      });
    });

    for (var block in _blocks) {
      // Save the notebook content regularly
      final blockController = _blockControllers[block.id]!;
      blockController.addListener(() {
        _isSavedRemotely = false;
        _debouceSaveBlock(block: block);
      });
    }
  }

  Future<void> _broadcastDeltaUpdate(Delta delta, String blockId) async {
    final currentUserUid = FirebaseAuthRepo().currentUserUid();
    if (_notebook == null || currentUserUid == null) {
      return;
    }

    print(delta);

    Repository()
        .notebook
        .updateBlockContent(
            blockId,
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

  void _debouceSaveBlock(
      {Duration duration = const Duration(seconds: 2), required Block block}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(duration, () {
      saveBlockImmediately(block);
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

  Future<void> saveBlockImmediately(Block block) async {
    final blockController = _blockControllers[block.id]!;
    await Repository().notebook.updateBlock(Block(
        id: block.id,
        content: blockController.document.toDelta().toJson(),
        type: block.type));
    _isSavedRemotely = true;
  }

  Future<void> createBlock(BlockType type, int index) async {
    final block =
        await Repository().notebook.createBlock(_notebook!.id, type, index);
    _blocks.add(block);
    final blockController = QuillController(
      document: Document()..insert(0, ''),
      selection: const TextSelection.collapsed(offset: 0),
    );
    _blockControllers[block.id] = blockController;
    _listenForBlockChanges();
    notifyListeners();
  }
}
