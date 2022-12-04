import 'package:flutter/material.dart';
import 'package:frontend/model/block.dart';
import 'package:frontend/view_model/notebook_view_model.dart';

class NewBlockButtons extends StatelessWidget {
  const NewBlockButtons({
    Key? key,
    required NotebookViewModel notebookViewModel,
    required this.i,
  })  : _notebookViewModel = notebookViewModel,
        super(key: key);

  final NotebookViewModel _notebookViewModel;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            _notebookViewModel.createBlock(BlockType.text, i + 1);
          },
          child: const Text('Text'),
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: () {
            _notebookViewModel.createBlock(BlockType.code, i + 1);
          },
          child: const Text('Code'),
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: () {
            _notebookViewModel.createBlock(BlockType.math, i + 1);
          },
          child: const Text('Math'),
        ),
      ],
    );
  }
}
