import 'package:flutter/material.dart';
import 'package:frontend/model/block.dart';
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

    // Create notebook
    final notebookId = Ref().databaseNotebooks.push().key;
    if (notebookId == null) {
      throw Exception('Notebook ID is null');
    }

    // Create initial block
    final block = await createBlock(notebookId, BlockType.code, 0);

    // Set initial notebook data
    final notebook = Notebook(
      id: notebookId,
      blocks: [block.id],
    );
    await Ref().databaseSpecificNotebook(notebookId).set(notebook.toMap());

    // Add notebook to user's list of notebooks
    await Ref()
        .databaseNotebookOverviewForUser(Repository().auth.currentUserUid()!)
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

    await Ref().databaseBlocksForNotebook(notebookId).remove();
    // Delete notebook from other user's notebook overview ?
  }

  @override
  Future<void> updateNotebook(Notebook notebook) {
    return Ref().databaseSpecificNotebook(notebook.id).update(notebook.toMap());
  }

  @override
  Future<void> updateBlockContent(String blockId, DeltaData deltaData) {
    return Ref().databaseBlockDeltaForBlock(blockId).update(deltaData.toMap());
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
  Stream<DeltaData> subscribeToBlockDelta(String blockId) {
    return Ref().databaseBlockDeltaForBlock(blockId).onValue.map((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        return DeltaData.fromMap(snapshot.value as Map<String, dynamic>);
      } else {
        return const DeltaData(user: '', delta: [], deviceId: '');
      }
    });
  }

  @override
  Future<Block> createBlock(
      String notebookId, BlockType type, int index) async {
    // Create block
    final blockId = Ref().databaseBlocksForNotebook(notebookId).push().key;
    if (blockId == null) {
      throw Exception('Block ID is null');
    }
    final block = Block(
      id: blockId,
      type: type,
    );

    // Set block values
    await Ref().databaseSpecificBlock(blockId).set(block.toMap());

    // Create block delta
    await Ref().databaseBlockDeltaForBlock(blockId).update({});

    // Get the current list of blocks
    final event =
        await Ref().databaseSpecificNotebook(notebookId).child("blocks").once();

    late final blocks;
    if (event.snapshot.value != null) {
      blocks = event.snapshot.value as List<dynamic>;
    } else {
      blocks = <String>[];
    }

    // Add the new block to the list at the specified index
    blocks.insert(index, blockId);

    // Set the updated list of blocks in the database
    Ref().databaseSpecificNotebook(notebookId).child("blocks").set(blocks);

    return block;
  }

  @override
  Future<void> deleteBlock(String notebookId, String blockId) {
    // TODO: implement deleteBlock
    throw UnimplementedError();
  }

  @override
  Future<void> updateBlock(Block block) async {
    Ref().databaseSpecificBlock(block.id).update(block.toMap());
  }

  @override
  Future<Block> getBlock(String blockId) async {
    final snapshot = await Ref().databaseSpecificBlock(blockId).get();
    if (snapshot.exists) {
      return Block.fromMap(snapshot.value as Map<String, dynamic>, blockId);
    } else {
      throw Exception('Block does not exist');
    }
  }
}
